require "./lib/piece.rb"

class Pawn
  UNICODE = "\u2659"

  attr_reader :team

  include Piece

  def initialize(team)
    @team = team
    @unmoved = true
  end

  def possible_moves(position, board)
    multiplier = @team == "white" ? -1 : 1
    moves = {
      passive: [],
      offensive: [],
    }
    unless into_other_piece?([position[0] + 1 * multiplier, position[1]], board)
      moves[:passive] << [position[0] + 1 * multiplier, position[1]] if on_board?([position[0] + 1 * multiplier, position[1]])
      moves[:passive] << [position[0] + 2 * multiplier, position[1]] if @unmoved && !into_other_piece?([position[0] + 2 * multiplier, position[1]], board)
    end
    moves[:offensive] << [position[0] + 1 * multiplier, position[1] + 1] if on_board?([position[0] + 1 * multiplier, position[1] + 1]) && into_enemy_piece?([position[0] + 1 * multiplier, position[1] + 1], board)
    moves[:offensive] << [position[0] + 1 * multiplier, position[1] - 1] if on_board?([position[0] + 1 * multiplier, position[1] - 1]) && into_enemy_piece?([position[0] + 1 * multiplier, position[1] - 1], board)
    moves
  end

  def moved
    @unmoved = false
  end
end
