class Bishop
  UNICODE = "\u2657"

  attr_reader :team

  include Piece

  def possible_moves(position)
    moves = []
    moves += (move_in_direction(position, [1, 1])) unless position[0] == 8 || position[1] == 8
    moves += (move_in_direction(position, [-1, 1])) unless position[0] == 1 || position[1] == 8
    moves += (move_in_direction(position, [-1, -1])) unless position[0] == 1 || position[1] == 1
    moves += (move_in_direction(position, [1, -1])) unless position[0] == 8 || position[1] == 1
    moves
  end
end
