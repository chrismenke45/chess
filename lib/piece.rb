require "./lib/string.rb"

module Piece
  BOARD_SIZE = 8

  attr_reader :team

  def to_object
    the_object = {
      team: @team,
      piece_type: self.class::UNICODE,
    }
  end

  def valid_move?(move, possible_moves)
    possible_moves.include?(move) && on_board?(move)
  end

  def on_board?(move)
    move[0] <= BOARD_SIZE && move[0] > 0 && move[1] <= BOARD_SIZE && move[1] > 0
  end

  def show_piece
    @team == "black" ? self.class::UNICODE.black : self.class::UNICODE
  end

  def initialize(team)
    @team = team
  end

  def move_in_direction(position, direction, board)
    moves = {
      passive: [],
      offensive: [],
    }
    x_incr = direction[1]
    y_incr = direction[0]
    while on_board?([position[0] + y_incr, position[1] + x_incr])
      if into_other_piece?([position[0] + y_incr, position[1] + x_incr], board)
        moves[:offensive] << [position[0] + y_incr, position[1] + x_incr] unless into_friendly_piece?([position[0] + y_incr, position[1] + x_incr], board)
        break
      else
        moves[:passive] << [position[0] + y_incr, position[1] + x_incr]
        x_incr += direction[1]
        y_incr += direction[0]
      end
    end
    moves
  end

  def into_other_piece?(move, board)
    board.dig(move[0], move[1]) != nil
  end

  def into_friendly_piece?(move, board)
    return false unless into_other_piece?(move, board)
    board[move[0]][move[1]].team == self.team
  end

  def into_enemy_piece?(move, board)
    return false unless into_other_piece?(move, board)
    board[move[0]][move[1]].team != self.team
  end

  def intermediate_moves2moves(intermediate_moves)
    moves = {
      passive: [],
      offensive: [],
    }
    intermediate_moves.each do |int_move|
      moves[:passive] += int_move[:passive] unless int_move.nil? || int_move[:passive].empty?
      moves[:offensive] += int_move[:offensive] unless int_move.nil? || int_move[:offensive].empty?
    end
    moves
  end
end
