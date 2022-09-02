require "./lib/pieces/pawn.rb"
require "./lib/pieces/bishop.rb"
require "./lib/pieces/knight.rb"
require "./lib/pieces/rook.rb"
require "./lib/pieces/queen.rb"
require "./lib/pieces/king.rb"
require "./lib/board.rb"

describe Board do
  subject(:board_class) { Board.new }
  context "#find_king" do
    it "#find_king works with black" do
      expect(board_class.king_position("black")).to eql([1, 5])
    end
    it "#find_king works with white" do
      expect(board_class.king_position("white")).to eql([8, 5])
    end
  end
  context "#check" do
    it "check returns false when no check" do
      expect(board_class.check_values("white")).to be_falsy
    end
    it "check returns single coordinate when 1 piece has king in check" do
      board_class.board[3][3], board_class.board[1][5] = board_class.board[1][5], nil
      board_class.board[5][3] = Rook.new("white")
      expect(board_class.check_values("black")).to eql([[5, 3]])
    end
    it "check returns 2 coordinates when 2 pieces have king in check" do
      board_class.board[3][3], board_class.board[1][5] = board_class.board[1][5], nil
      board_class.board[5][3] = Rook.new("white")
      board_class.board[6][6] = Bishop.new("white")
      expect(board_class.check_values("black")).to match_array([[6, 6], [5, 3]])
    end
  end
  context "#check_mate?" do
    xit "check_mate returns false when 2 pieces have king in check but king can move out of way" do
      board_class.board[3][3], board_class.board[1][5] = board_class.board[1][5], nil
      board_class.board[5][3] = Rook.new("white")
      board_class.board[6][6] = Bishop.new("white")
      expect(board_class.check_mate?("black")).to be_falsy
    end
    xit "check_mate returns false when a piece has king in check but king can be blocked by another piece" do
      board_class[3, 1], board_class[1, 5] = board_class[1, 5], nil
      board_class[4, 1] = Pawn.new("black")
      board_class[3, 2] = Pawn.new("black")
      board_class[5, 3] = Bishop.new("white")
      expect(board_class.check_mate?("black")).to be_falsy
    end
    xit "check_mate returns true when a piece has king in check mate" do
      board_class[3, 1], board_class[1, 5] = board_class[1, 5], nil
      board_class[4, 1] = Pawn.new("black")
      board_class[3, 2] = Bishop.new("black")
      board_class[5, 3] = Bishop.new("white")
      expect(board_class.check_mate?("black")).to be_truthy
    end
  end
end
