module Piece
  BOARD_SIZE = 8

  def valid_move?(move, possible_moves)
    possible_moves.include?(move) && on_board?(move)
  end

  def on_board?(move)
    move[0] < BOARD_SIZE && move[0] >= 0 && move[1] < BOARD_SIZE && move[1] >= 0
  end
end
