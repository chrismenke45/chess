class Rook
  UNICODE = "\u2656"

  attr_reader :team

  include Piece

  def possible_moves(position)
    moves = []
    moves += (move_in_direction(position, [1, 0])) unless position[0] == 8
    moves += (move_in_direction(position, [0, 1])) unless position[1] == 8
    moves += (move_in_direction(position, [-1, 0])) unless position[0] == 1
    moves += (move_in_direction(position, [0, -1])) unless position[1] == 1
    moves
  end
end
