require "./lib/pieces/pawn.rb"
require "./lib/pieces/rook.rb"
require "./lib/pieces/knight.rb"
require "./lib/pieces/bishop.rb"
require "./lib/pieces/queen.rb"
require "./lib/pieces/king.rb"
require "./lib/piece.rb"
require "./lib/string.rb"
require "./lib/player.rb"

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
    puts "Welcome to Chess! Will you be playing:"
    puts "1. Player vs. Player"
    puts "2. Player vs. Computer"
    game_type_response = nil
    until game_type_response == "1" || game_type_response == "2"
      puts "Please enter 1 or 2"
      game_type_response = gets.chomp
    end
  end

  def player_set_up
    puts "Please enter white team player name:"
    @players = [Player.new(gets.chomp, "white")]
    puts "Please enter black team player name:"
    @players << Player.new(gets.chomp, "black")
  end

  def check_values(defending_king, team, current_board = @board) #checks if king is in check, either returns false or array with locations of pieces puting king in check
    danger_positions = { non_knight: [], knight: [] }
    self.each_space do |space, row_index, column_index|
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
    king_moves_array.each { |move| return false if move_unchecks?(defending_king, move, team, move) }
    danger_positions_array = danger_positions[:knight] + danger_positions[:non_knight]
    #check if killing attacker prevents checkmate
    if danger_positions_array.length == 1
      self.each_space do |space, row_index, column_index|
        next if space.nil? || space.team != team
        moves = space.possible_moves([row_index, column_index], @board)
        return false if moves[:offensive].include?(danger_positions[0]) && move_unchecks?([row_index, column_index], danger_positions[0], team, defending_king)
      end
    end
    #check if blocking attacker(s) prevents checkmate
    intercept_positions = intercept_danger_positions(defending_king, danger_positions[:non_knight])
    self.each_space do |space, row_index, column_index|
      next if space.nil? || space.team != team || space.class == King
      moves = space.possible_moves([row_index, column_index], @board)
      overlap_moves = moves[:passive] & intercept_positions
      overlap_moves.each do |overlap_move|
        return false if move_unchecks?([row_index, column_index], overlap_move, team, defending_king)
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

  def move_unchecks?(current_position, move, team, defending_king) #check if this move with remove king from check
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
