require "./lib/pieces/pawn.rb"
require "./lib/pieces/bishop.rb"
require "./lib/pieces/knight.rb"
require "./lib/pieces/rook.rb"
require "./lib/pieces/queen.rb"
require "./lib/pieces/king.rb"
require "./lib/board.rb"

describe Board do
  subject(:board_class) { Board.new }
  describe Pawn do
    subject(:dummy_class_black) { described_class.new("black") }
    it "returns proper opening moves for black pawn" do
      expect(dummy_class_black.possible_moves([2, 2], board_class.board)).to include(:passive => [[3, 2], [4, 2]]).and include(:offensive => match_array([]))
    end
    subject(:dummy_class_white) { described_class.new("white") }
    it "returns proper opening moves for whitw pawn" do
      expect(dummy_class_white.possible_moves([7, 2], board_class.board)).to include(:passive => [[6, 2], [5, 2]]).and include(:offensive => match_array([]))
    end
    subject(:dummy_class_white) { described_class.new("white") }
    #dummy_class_white.moved
    it "returns proper moves for whitw pawn that has been moved" do
      dummy_class_white.moved
      expect(dummy_class_white.possible_moves([6, 2], board_class.board)).to include(:passive => [[5, 2]]).and include(:offensive => match_array([]))
    end
    subject(:dummy_class_white) { described_class.new("white") }
    it "returns proper moves for whitw pawn that can attack" do
      expect(dummy_class_white.possible_moves([3, 2], board_class.board)).to include(:passive => []).and include(:offensive => match_array([[2, 1], [2, 3]]))
    end
  end
  describe Bishop do
    subject(:dummy_class) { described_class.new("black") }
    it "returns proper attacking/passive moves for bishop" do
      moves = dummy_class.possible_moves([2, 2], board_class.board)
      expect(moves).to include(:passive => match_array([[3, 1], [3, 3], [4, 4], [5, 5], [6, 6]])).and include(:offensive => match_array([[7, 7]]))
    end
  end
  describe Knight do
    subject(:dummy_class) { described_class.new("black") }
    it "returns proper opening moves for black knight" do
      moves = dummy_class.possible_moves([1, 2], board_class.board)
      expect(moves).to include(:passive => match_array([[3, 1], [3, 3]])).and include(:offensive => match_array([]))
    end
    it "returns proper attacking/passive moves for black knight" do
      moves = dummy_class.possible_moves([6, 2], board_class.board)
      expect(moves).to include(:passive => match_array([[4, 1], [4, 3], [5, 4]])).and include(:offensive => match_array([[8, 1], [8, 3], [7, 4]]))
    end
  end
  describe Rook do
    subject(:dummy_class) { described_class.new("black") }
    it "returns proper attacking/passive moves for rook" do
      moves = dummy_class.possible_moves([3, 2], board_class.board)
      expect(moves).to include(:passive => match_array([[4, 2], [5, 2], [6, 2], [3, 1], [3, 3], [3, 4], [3, 5], [3, 6], [3, 7], [3, 8]])).and include(:offensive => match_array([[7, 2]]))
    end
  end
  describe Queen do
    subject(:dummy_class) { described_class.new("black") }
    it "returns proper attacking/passive moves for queen" do
      moves = dummy_class.possible_moves([3, 2], board_class.board)
      expect(moves).to include(:passive => match_array([[4, 2], [5, 2], [6, 2], [3, 1], [3, 3], [3, 4], [3, 5], [3, 6], [3, 7], [3, 8], [4, 1], [4, 3], [5, 4], [6, 5]])).and include(:offensive => match_array([[7, 6], [7, 2]]))
    end
  end
  describe King do
    subject(:dummy_class) { described_class.new("black") }
    it "returns proper attacking/passive moves for king" do
      moves = dummy_class.possible_moves([6, 2], board_class.board)
      expect(moves).to include(:passive => match_array([[6, 1], [6, 3], [5, 1], [5, 3], [5, 2]])).and include(:offensive => match_array([[7, 1], [7, 2], [7, 3]]))
    end
  end
end
