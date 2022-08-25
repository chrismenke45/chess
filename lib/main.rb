require "./lib/board.rb"
require "./lib/string.rb"

b = Board.new
b.show_board

require "./lib/pieces/pawn.rb"
require "./lib/pieces/knight.rb"
require "./lib/pieces/rook.rb"
require "./lib/pieces/bishop.rb"
require "./lib/pieces/queen.rb"
require "./lib/pieces/king.rb"

pawn = Pawn.new("white")

p pawn.possible_moves([1, 2])

knight = Knight.new("black")

p knight.possible_moves([1, 2])

rook = Rook.new("black")

p rook.possible_moves([1, 2])

bishop = Bishop.new("black")

p bishop.possible_moves([8, 3])

queen = Queen.new("black")

p queen.possible_moves([1, 2])

king = King.new("black")

p king.possible_moves([8, 3])
