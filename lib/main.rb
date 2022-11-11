require "./lib/board.rb"
require "./lib/string.rb"

b = Board.new
b.show_board
#b.game_setup
#b.make_move([7, 1], [6, 1])
#.show_board
#p b.board_to_object
b.play
