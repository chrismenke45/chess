class Knight
  UNICODE = "\u2658"

  attr_reader :team

  include Piece

  def possible_moves(position)
    moves = []
    moves << [position[0] + 2, position[1] + 1]
    moves << [position[0] + 2, position[1] - 1]
    moves << [position[0] + 1, position[1] + 2]
    moves << [position[0] + 1, position[1] - 2]
    moves << [position[0] - 2, position[1] + 1]
    moves << [position[0] - 2, position[1] - 1]
    moves << [position[0] - 1, position[1] + 2]
    moves << [position[0] - 1, position[1] - 2]
    moves
  end
end
