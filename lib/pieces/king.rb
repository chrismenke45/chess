class King
  UNICODE = "\u2654"

  attr_reader :team

  include Piece

  def possible_moves(position)
    moves = []
    moves.push([position[0] + 1, position[1] + 1])
    moves.push([position[0] + 1, position[1] + 0])
    moves.push([position[0] + 0, position[1] + 1])
    moves.push([position[0] + 1, position[1] - 1])
    moves.push([position[0] - 1, position[1] + 1])
    moves.push([position[0] - 1, position[1] + 0])
    moves.push([position[0] + 0, position[1] - 1])
    moves.push([position[0] - 1, position[1] - 1])
    moves
  end
end
