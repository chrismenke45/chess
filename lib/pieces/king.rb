class King
  UNICODE = "\u2654"

  attr_reader :team

  include Piece

  def possible_moves(position, board)
    intermediate_moves = []
    intermediate_moves.push([position[0] + 1, position[1] + 1]) if on_board?([position[0] + 1, position[1] + 1]) && !into_friendly_piece?([position[0] + 1, position[1] + 1], board)
    intermediate_moves.push([position[0] + 1, position[1] + 0]) if on_board?([position[0] + 1, position[1] + 0]) && !into_friendly_piece?([position[0] + 1, position[1] + 0], board)
    intermediate_moves.push([position[0] + 0, position[1] + 1]) if on_board?([position[0] + 0, position[1] + 1]) && !into_friendly_piece?([position[0] + 0, position[1] + 1], board)
    intermediate_moves.push([position[0] + 1, position[1] - 1]) if on_board?([position[0] + 1, position[1] - 1]) && !into_friendly_piece?([position[0] + 1, position[1] - 1], board)
    intermediate_moves.push([position[0] - 1, position[1] + 1]) if on_board?([position[0] - 1, position[1] + 1]) && !into_friendly_piece?([position[0] - 1, position[1] + 1], board)
    intermediate_moves.push([position[0] - 1, position[1] + 0]) if on_board?([position[0] - 1, position[1] + 0]) && !into_friendly_piece?([position[0] - 1, position[1] + 0], board)
    intermediate_moves.push([position[0] + 0, position[1] - 1]) if on_board?([position[0] + 0, position[1] - 1]) && !into_friendly_piece?([position[0] + 0, position[1] - 1], board)
    intermediate_moves.push([position[0] - 1, position[1] - 1]) if on_board?([position[0] - 1, position[1] - 1]) && !into_friendly_piece?([position[0] - 1, position[1] - 1], board)
    moves = {
      passive: [],
      offensive: [],
    }
    intermediate_moves.each do |int_move|
      into_enemy_piece?(int_move, board) ? moves[:offensive] << int_move : moves[:passive] << int_move
    end
    moves
  end
end
