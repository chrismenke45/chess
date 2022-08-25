require "./lib/string.rb"

module Piece
  BOARD_SIZE = 8

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

  def move_in_direction(position, direction)
    moves = []
    x_incr = direction[0]
    y_incr = direction[1]
    while on_board?([position[0] + x_incr, position[1] + y_incr])
      moves << [position[0] + x_incr, position[1] + y_incr]
      x_incr += direction[0]
      y_incr += direction[1]
    end
    moves
  end

  def into_other_piece?(move, board)
    board[move[0]][move[1]] != nil
  end

  def into_friendly_piece?(move, board)
    board[move[0]][move[1]].team == self.team
  end
end
