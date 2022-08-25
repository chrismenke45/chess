require "./lib/piece.rb"

class Pawn
  UNICODE = "\u2659"

  attr_reader :team

  include Piece

  def initialize(team)
    @team = team
    @unmoved = true
  end

  def possible_moves(position)
    multiplier = @team == "white" ? -1 : 1
    moves = [[position[0], position[1] + 1 * multiplier]]
    moves << [position[0], position[1] + 2 * multiplier] if @unmoved
    moves
  end
end
