class Bishop
  UNICODE = "\u2657"

  attr_reader :team

  include Piece

  def possible_moves(position, board)
    intermediate_moves = []
    intermediate_moves[0] = (move_in_direction(position, [1, 1], board)) unless position[0] == 8 || position[1] == 8
    intermediate_moves[1] = (move_in_direction(position, [-1, 1], board)) unless position[0] == 1 || position[1] == 8
    intermediate_moves[2] = (move_in_direction(position, [-1, -1], board)) unless position[0] == 1 || position[1] == 1
    intermediate_moves[3] = (move_in_direction(position, [1, -1], board)) unless position[0] == 8 || position[1] == 1
    intermediate_moves2moves(intermediate_moves)
  end
end
