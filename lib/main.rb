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

pawn = Pawn.new("black")

p pawn.possible_moves([6, 2], b.board)

knight = Knight.new("black")

#p knight.possible_moves([6, 2], b.board)

#rook = Rook.new("black")

#p rook.possible_moves([3, 3], b.board)

bishop = Bishop.new("black")

#p bishop.possible_moves([3, 3], b.board)

queen = Queen.new("black")

#p queen.possible_moves([3, 3], b.board)

king = King.new("black")

#p king.possible_moves([6, 3], b.board)
