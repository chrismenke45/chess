require "./lib/pieces/pawn.rb"
require "./lib/pieces/rook.rb"
require "./lib/pieces/knight.rb"
require "./lib/pieces/bishop.rb"
require "./lib/pieces/queen.rb"
require "./lib/pieces/king.rb"
require "./lib/piece.rb"
require "./lib/string.rb"

class Board
  def initialize
    @board = new_game_board
  end

  def show_board
    @board.each_with_index do |row, outer_index|
      pretty_row = row.map.with_index do |space, inner_index|
        next "#{space} " if inner_index == 0
        next "  #{space}   " if outer_index == 0
        text_to_return = space.class.included_modules.include?(Piece) ? "  #{space.show_piece}" : "   "
        (outer_index + inner_index) % 2 == 0 ? text_to_return.bg_cyan + "   ".bg_cyan : text_to_return.bg_blue + "   ".bg_blue
      end
      if outer_index == 0
        puts pretty_row.join("")
      else
        color_row = "  "
        8.times do |last_index|
          (last_index + outer_index) % 2 == 1 ? color_row << "      ".bg_cyan : color_row << "      ".bg_blue
        end
        puts color_row
        puts pretty_row.join("")
        puts color_row
      end
    end
  end

  private

  def new_game_board
    the_board = create_empty_board
    the_board = add_pawns(the_board, "black", 2)
    the_board = add_pawns(the_board, "white", 7)
    the_board = end_line_row(the_board, "black", 1)
    the_board = end_line_row(the_board, "white", 8)
    the_board
  end

  def create_empty_board
    ("a".."h").to_a
    column_index = ("a".."h").to_a
    column_index.unshift(" ")
    intermediate_board_arr = []
    8.times do |index|
      #intermediate_board_arr.push([index + 1] + Array.new(8) { "_" })
      intermediate_board_arr.push([index + 1] + Array.new(8) { nil })
    end
    intermediate_board_arr.unshift(column_index)
    intermediate_board_arr
  end

  def add_pawns(the_board, team, row)
    the_board[row] = [row] + Array.new(8) { Pawn.new(team) }
    the_board
  end

  def rook_thru_bishop_array(team)
    [Rook.new(team), Knight.new(team), Bishop.new(team)]
  end

  def end_line_row(the_board, team, row)
    the_board[row] = [row] + rook_thru_bishop_array(team) + [Queen.new(team), King.new(team)] + rook_thru_bishop_array(team).reverse
    the_board
  end
end
