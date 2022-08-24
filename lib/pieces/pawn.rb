require "./lib/piece.rb"

class Pawn
  UNICODE = "\u2659"

  attr_reader :team

  include Piece

  def initialize(team)
    @team = team
    @unmoved = true
  end
end
