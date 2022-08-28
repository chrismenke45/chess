class Rook
  UNICODE = "\u2656"

  attr_reader :team

  include Piece

  def possible_moves(position, board)
    intermediate_moves = []
    #moves += (move_in_direction(position, [1, 0], board)) unless position[0] == 8
    #moves += (move_in_direction(position, [0, 1], board)) unless position[1] == 8
    #moves += (move_in_direction(position, [-1, 0], board)) unless position[0] == 1
    #moves += (move_in_direction(position, [0, -1], board)) unless position[1] == 1
    intermediate_moves[0] = (move_in_direction(position, [1, 0], board)) unless position[0] == 8
    intermediate_moves[1] = (move_in_direction(position, [0, 1], board)) unless position[1] == 8
    intermediate_moves[2] = (move_in_direction(position, [-1, 0], board)) unless position[0] == 1
    intermediate_moves[3] = (move_in_direction(position, [0, -1], board)) unless position[1] == 1
    intermediate_moves2moves(intermediate_moves)
  end
end
