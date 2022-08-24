require "./lib/string.rb"

module Piece
  BOARD_SIZE = 8

  def valid_move?(move, possible_moves)
    possible_moves.include?(move) && on_board?(move)
  end

  def on_board?(move)
    move[0] <= BOARD_SIZE && move[0] > 0 && move[1] <= BOARD_SIZE && move[1] > 0
  end

  def show_piece
    @team == "black" ? self.class::UNICODE.black : self.class::UNICODE
  end

  def show_team
    puts @team
  end

  def initialize(team)
    @team = team
  end
end
