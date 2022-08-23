class Board
  def initialize
    @board = create_empty_board
    #@board = Array.new(8) { Array.new(8) { "_" } }
  end

  def show_board
    @board.each do |row|
      puts row.join("|")
    end
  end

  private

  def create_empty_board
    ("a".."h").to_a
    column_index = ("a".."h").to_a
    column_index.unshift(" ")
    intermediate_board_arr = []
    8.times do |index|
      intermediate_board_arr.push([index + 1] + Array.new(8) { "_" })
    end
    intermediate_board_arr.unshift(column_index)
    intermediate_board_arr
  end
end
