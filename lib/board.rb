require "./lib/pieces/pawn.rb"
require "./lib/pieces/rook.rb"
require "./lib/pieces/knight.rb"
require "./lib/pieces/bishop.rb"
require "./lib/pieces/queen.rb"
require "./lib/pieces/king.rb"
require "./lib/piece.rb"
require "./lib/string.rb"
require "./lib/player.rb"
require "./lib/save_game.rb"

class Board
  #attr_reader :board
  attr_accessor :board

  def initialize(existing_game_array = nil)
    @board = create_game_board(existing_game_array)
  end

  def show_board
    @board.each_with_index do |row, outer_index|
      pretty_row = row.map.with_index do |space, inner_index|
        next "#{space} " if inner_index == 0
        next "  #{space}   " if outer_index == 0
        text_to_return = space.class.included_modules.include?(Piece) ? "  #{space.show_piece}" : "   "
        (outer_index + inner_index) % 2 == 0 ? text_to_return.bg_cyan + "   ".bg_cyan : text_to_return.bg_blue + "   ".bg_blue
      end
      if outer_index == 0
        puts pretty_row.join("")
      else
        color_row = "  "
        8.times do |last_index|
          (last_index + outer_index) % 2 == 1 ? color_row << "      ".bg_cyan : color_row << "      ".bg_blue
        end
        puts color_row
        puts pretty_row.join("")
        puts color_row
      end
    end
  end

  #private
  def play
    game_setup
    game_play
  end

  def game_setup
    puts "Welcome to Chess! Will you be playing:"
    puts "1. Player vs. Player"
    puts "2. Player vs. Computer"
    puts "3. Load Prior Saved Game"
    #game_type_response = nil
    loop do
      game_type_response = nil
      until game_type_response == "1" || game_type_response == "2" || game_type_response == "3"
        puts "Please enter 1 or 2"
        game_type_response = gets.chomp
      end
      case game_type_response
      when "1"
        player_set_up("white")
        player_set_up("black")
        break
      when "2"
        player_set_up("white")
        player_set_up("black", true)
        break
      when "3"
        loaded = load_game
        break if loaded
      else
        puts "Error, not a valid selection for game set up"
      end
    end
  end

  def player_set_up(team, computer = false)
    @players = [] unless @players
    if computer
      @players << Player.new("Computer", team, true)
    else
      puts "Please enter #{team} team player name:"
      @players << Player.new(gets.chomp, team)
    end
  end

  def game_play
    @i = 0 unless @i
    loop do
      player = @players[@i % 2]
      show_board
      the_end = player_turn(player)
      break if the_end
      @i += 1
    end
  end

  def player_turn(player)
    defending_king = king_position(player.team)
    danger_positions = check_values(defending_king, player.team)
    if danger_positions && check_mate?(defending_king, player.team, danger_positions)
      puts "The #{player.team.capitalize} King has been check mated"
      true
    else
      if player.computer
        puts "Computer is thinking..."
        sleep(1)
        piece_coordinate = computer_piece_to_move(player, danger_positions)
        move_coordinate = computer_place_to_move(player, piece_coordinate, danger_positions)
      else
        loop do
          piece_coordinate = piece_to_move(player, danger_positions)
          unless piece_coordinate
            save_game
            return true
          end
          move_coordinate = place_to_move(player, piece_coordinate)
          break if move_coordinate
        end
      end
      @board = make_move(piece_coordinate, move_coordinate, @board, player)
      false
    end
  end

  def save_game
    game_object = {
      i: @i,
      player1: @players[0].to_object,
      player2: @players[1].to_object,
      board: board_to_object,
    }
    SaveGame.save_it(game_object)
  end

  def load_game
    game_object = SaveGame.load_it
    return false unless game_object
    @i = game_object["i"]
    @players = []
    @players << Player.new(game_object["player1"]["name"], game_object["player1"]["team"], game_object["player1"]["computer"])
    @players << Player.new(game_object["player2"]["name"], game_object["player2"]["team"], game_object["player2"]["computer"])
    board_from_object(game_object["board"])
  end

  def board_to_object
    board = Array.new(9) { [] }
    self.each_space do |space, row_index, column_index|
      if space.class.ancestors.include?(Piece)
        board[row_index][column_index] = space.to_object
      else
        board[row_index][column_index] = space
      end
    end
    board
  end

  def board_from_object(object)
    self.each_space do |space, row_index, column_index|
      #p object[row_index][column_index].class
      if object[row_index][column_index].class == Hash
        case object[row_index][column_index]["piece_type"]
        when Pawn::UNICODE
          @board[row_index][column_index] = Pawn.new(object[row_index][column_index]["team"], object[row_index][column_index]["unmoved"])
        when Rook::UNICODE
          @board[row_index][column_index] = Rook.new(object[row_index][column_index]["team"])
        when Bishop::UNICODE
          @board[row_index][column_index] = Bishop.new(object[row_index][column_index]["team"])
        when Knight::UNICODE
          @board[row_index][column_index] = Knight.new(object[row_index][column_index]["team"])
        when King::UNICODE
          @board[row_index][column_index] = King.new(object[row_index][column_index]["team"])
        when Queen::UNICODE
          @board[row_index][column_index] = Queen.new(object[row_index][column_index]["team"])
        end
      else
        @board[row_index][column_index] = object[row_index][column_index]
      end
    end
  end

  def computer_piece_to_move(player, danger_positions)
    piece_coordinate = [nil, nil]
    loop do
      piece_coordinate = [rand(1..8), rand(1..8)]
      next unless @board[piece_coordinate[0]][piece_coordinate[1]]&.team == player.team
      if danger_positions
        defending_king = king_position(player.team)
        next unless can_remove_check?(piece_coordinate, player.team, defending_king)
      end
      break if moves_available?(piece_coordinate)
    end
    piece_coordinate
  end

  def computer_place_to_move(player, piece_coordinate, danger_positions)
    move_coordinate = [nil, nil]
    potential_moves = @board[piece_coordinate[0]][piece_coordinate[1]].possible_moves(piece_coordinate, @board)
    potential_moves_array = potential_moves[:passive] + potential_moves[:offensive]
    if danger_positions
      defending_king = king_position(player.team)
      potential_moves_array.each do |move|
        correct_king_position = @board[piece_coordinate[0]][piece_coordinate[1]].class == King ? move : defending_king
        move_coordinate = move if move_no_check?(piece_coordinate, move, player.team, correct_king_position)
      end
    else
      move_coordinate = potential_moves_array[rand(0...move_coordinate.length)]
    end
    move_coordinate
  end

  def piece_to_move(player, danger_positions)
    puts "#{player.name}, what piece would you like to move. Please enter a chess coordinate. Or enter 'save' to save the game"
    piece_coordinate = nil
    loop do
      input = gets.chomp
      return false if input.downcase == "save"
      piece_coordinate = text2space(input) if valid_input_space?(input)
      if valid_input_space?(input) && @board[piece_coordinate[0]][piece_coordinate[1]]&.team == player.team
        if danger_positions
          defending_king = king_position(player.team)
          unless can_remove_check?(piece_coordinate, player.team, defending_king)
            puts "This piece can't remove the check on your king, please choose another"
            next
          end
        end
        moves_available?(piece_coordinate) ? break : (puts "This piece has no possible moves, please try another")
      end
      puts "#{player.name}, please enter a valid chess coordinate (e.g. 'B8', 'F3', 'c5') to select a piece to move from the #{player.team} team"
    end
    piece_coordinate
  end

  def place_to_move(player, piece_coordinate)
    moves = piece_moves(piece_coordinate)
    move_coordinate = nil
    loop do
      puts "#{player.name}, where would you like to move your #{@board[piece_coordinate[0]][piece_coordinate[1]].class}, or enter 'back' to select a different piece"
      move = gets.chomp
      break if move.downcase == "back"
      move_coordinate = text2space(move) if valid_input_space?(move)
      if moves[:passive].include?(move_coordinate) || moves[:offensive].include?(move_coordinate)
        potential_board = board_dup
        potential_board = make_move(piece_coordinate, move_coordinate, potential_board)
        defending_king = king_position(player.team)
        defending_king = move_coordinate if defending_king == piece_coordinate
        break unless check_values(defending_king, player.team, potential_board)
        puts "That move would put you in check, please make a different move"
      else
        "That is not a valid move, please make a different move"
      end
    end
    move_coordinate
  end

  def make_move(current_position, move, the_board = @board, player = nil)
    actual_move = (the_board == @board)
    the_board[move[0]][move[1]], the_board[current_position[0]][current_position[1]] = the_board[current_position[0]][current_position[1]], nil
    if player && actual_move && the_board[move[0]][move[1]].class == Pawn
      if the_board[move[0]][move[1]].team == "white" && move[0] == 1
        the_board = change_piece(move, player, the_board)
      elsif the_board[move[0]][move[1]].team == "black" && move[0] == 8
        the_board = change_piece(move, player, the_board)
      end
    end
    the_board
  end

  def change_piece(position, player, the_board)
    if player.computer
      the_board[position[0]][position[1]] = Queen.new(player.team)
    else
      loop do
        puts "#{player.name}, Which piece would you like to change your pawn to?"
        piece_name = gets.chomp
        case piece_name.downcase
        when "rook"
          the_board[position[0]][position[1]] = Rook.new(player.team)
        when "bishop"
          the_board[position[0]][position[1]] = Bishop.new(player.team)
        when "knight"
          the_board[position[0]][position[1]] = Knight.new(player.team)
        when "queen"
          the_board[position[0]][position[1]] = Queen.new(player.team)
        else
          puts "You can only change you pawn to a rook, bishop, knight or queen."
          piece_name = nil
        end
        break if piece_name
      end
    end
    the_board
  end

  def moves_available?(coordinate)
    moves = @board[coordinate[0]][coordinate[1]].possible_moves(coordinate, @board)
    !moves[:passive].empty? || !moves[:offensive].empty?
  end

  def piece_moves(coordinate)
    @board[coordinate[0]][coordinate[1]].possible_moves(coordinate, @board)
  end

  def valid_input_space?(text)
    arr = text.downcase.bytes
    return false unless arr.length == 2
    arr.each_with_index do |coordinate, index|
      if index == 0
        return false unless coordinate <= 104 && coordinate >= 97
      else
        return false unless coordinate <= 56 && coordinate >= 49
      end
    end
    true
  end

  def text2space(text)
    arr = text.downcase.bytes
    arr.reverse!
    arr[0] -= 48
    arr[1] -= 96
    arr
  end

  def check_values(defending_king, team, current_board = @board) #checks if king is in check, either returns false or array with locations of pieces puting king in check
    danger_positions = { non_knight: [], knight: [] }
    self.each_space do |space, row_index, column_index|
      space = current_board[row_index][column_index]
      next if space.nil? || space.team == team
      moves = space.possible_moves([row_index, column_index], current_board)
      if moves[:offensive].include?(defending_king)
        space.class == Knight ? danger_positions[:knight] << [row_index, column_index] : danger_positions[:non_knight] << [row_index, column_index]
      end
    end
    danger_positions[:knight].empty? && danger_positions[:non_knight].empty? ? false : danger_positions
  end

  def check_mate?(defending_king, team, danger_positions)
    return false if danger_positions.empty?
    #check if moving king prevents checkmate
    king_dummy = King.new(team)
    king_moves = king_dummy.possible_moves(defending_king, @board)
    king_moves_array = king_moves[:passive] + king_moves[:offensive]
    king_moves_array.each { |move| return false if move_no_check?(defending_king, move, team, move) }
    danger_positions_array = danger_positions[:knight] + danger_positions[:non_knight]
    #check if killing attacker prevents checkmate
    if danger_positions_array.length == 1
      self.each_space do |space, row_index, column_index|
        next if space.nil? || space.team != team || space.class == King
        moves = space.possible_moves([row_index, column_index], @board)
        unless moves[:offensive].empty?
        end
        return false if moves[:offensive].include?(danger_positions_array[0]) && move_no_check?([row_index, column_index], danger_positions_array[0], team, defending_king)
      end
    end
    #check if blocking attacker(s) prevents checkmate
    intercept_positions = intercept_danger_positions(defending_king, danger_positions[:non_knight])
    self.each_space do |space, row_index, column_index|
      next if space.nil? || space.team != team || space.class == King
      moves = space.possible_moves([row_index, column_index], @board)
      overlap_moves = moves[:passive] & intercept_positions
      overlap_moves.each do |overlap_move|
        return false if move_no_check?([row_index, column_index], overlap_move, team, defending_king)
      end
    end
    true
  end

  def intercept_danger_positions(defending_king, non_knight_danger_positions)
    intercept_positions = []
    non_knight_danger_positions.each do |position|
      row_direction_to_king = defending_king[0] <=> position[0]
      column_direction_to_king = defending_king[1] <=> position[1]
      loop do
        position[0] += row_direction_to_king
        position[1] += column_direction_to_king
        break if position == defending_king
        intercept_positions << position.dup
      end
    end
    intercept_positions
  end

  def can_remove_check?(piece_coordinate, team, defending_king)
    potential_moves = @board[piece_coordinate[0]][piece_coordinate[1]].possible_moves(piece_coordinate, @board)
    potential_moves_array = potential_moves[:passive] + potential_moves[:offensive]
    potential_moves_array.each { |move| return true if move_no_check?(piece_coordinate, move, team, defending_king) }
    false
  end

  def move_no_check?(current_position, move, team, defending_king) #check if this move with remove king from check
    potential_board = self.board_dup
    potential_board[move[0]][move[1]], potential_board[current_position[0]][current_position[1]] = potential_board[current_position[0]][current_position[1]], nil
    !check_values(defending_king, team, potential_board)
  end

  def king_position(team)
    self.each_space { |space, row_index, column_index| return [row_index, column_index] if space.class == King && space.team == team }
  end

  def each_space(&the_block)
    @board.each_with_index do |row, row_index|
      next if row_index == 0
      row.each_with_index do |space, column_index|
        next if column_index == 0
        the_block.call(space, row_index, column_index)
      end
    end
  end

  def board_dup
    duplicate = [@board[0], [1], [2], [3], [4], [5], [6], [7], [8]]
    self.each_space { |space, row_index, column_index| duplicate[row_index] << space.dup }
    duplicate
  end

  def create_game_board(existing_game_array = nil)
    if existing_game_array
      p "NEED TO IMPLIMETN THIS"
    else
      new_game_board
    end
  end

  def new_game_board
    the_board = create_empty_board
    the_board = add_pawns(the_board, "black", 2)
    the_board = add_pawns(the_board, "white", 7)
    the_board = end_line_row(the_board, "black", 1)
    the_board = end_line_row(the_board, "white", 8)
    the_board
  end

  def create_empty_board
    ("a".."h").to_a
    column_index = ("a".."h").to_a
    column_index.unshift(" ")
    intermediate_board_arr = []
    8.times do |index|
      #intermediate_board_arr.push([index + 1] + Array.new(8) { "_" })
      intermediate_board_arr.push([index + 1] + Array.new(8) { nil })
    end
    intermediate_board_arr.unshift(column_index)
    intermediate_board_arr
  end

  def add_pawns(the_board, team, row)
    the_board[row] = [row] + Array.new(8) { Pawn.new(team) }
    the_board
  end

  def rook_thru_bishop_array(team)
    [Rook.new(team), Knight.new(team), Bishop.new(team)]
  end

  def end_line_row(the_board, team, row)
    the_board[row] = [row] + rook_thru_bishop_array(team) + [Queen.new(team), King.new(team)] + rook_thru_bishop_array(team).reverse
    the_board
  end
end
