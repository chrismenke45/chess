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
      expect(board_class.check_values(board_class.king_position("black"), "white")).to be_falsy
    end
    it "check returns single coordinate when 1 piece has king in check" do
      board_class.board[3][3], board_class.board[1][5] = board_class.board[1][5], nil
      board_class.board[3][6] = Rook.new("white")
      expect(board_class.check_values(board_class.king_position("black"), "black")).to eql({ :knight => [], :non_knight => [[3, 6]] })
    end
    it "check returns single coordinate when 1 piece has king in check pt 2" do
      board_class.board[4][2], board_class.board[1][5] = board_class.board[1][5], nil
      board_class.board[5][2] = Rook.new("white")
      expect(board_class.check_values(board_class.king_position("black"), "black")).to eql({ :knight => [], :non_knight => [[5, 2]] })
    end
    it "check returns 2 coordinates when 2 pieces have king in check" do
      board_class.board[3][3], board_class.board[1][5] = board_class.board[1][5], nil
      board_class.board[5][3] = Rook.new("white")
      board_class.board[6][6] = Bishop.new("white")
      expect(board_class.check_values(board_class.king_position("black"), "black")).to include(:knight => []).and include(:non_knight => match_array([[6, 6], [5, 3]]))
    end
  end

  context "#intercept_danger_positions" do
    it "works with 1 intercept_position and a knight also checking" do
      board_class.board[3][3], board_class.board[1][5] = board_class.board[1][5], nil
      board_class.board[5][3] = Rook.new("white")
      board_class.board[4][2] = Knight.new("white")
      check_location = board_class.check_values(board_class.king_position("black"), "black")
      defending_king = board_class.king_position("black")
      expect(board_class.intercept_danger_positions(defending_king, check_location[:non_knight])).to match_array([[4, 3]])
    end
    it "works with 2 intercept_positions" do
      board_class.board[3][3], board_class.board[1][5] = board_class.board[1][5], nil
      board_class.board[5][3] = Rook.new("white")
      board_class.board[5][5] = Bishop.new("white")
      check_location = board_class.check_values(board_class.king_position("black"), "black")
      defending_king = board_class.king_position("black")
      expect(board_class.intercept_danger_positions(defending_king, check_location[:non_knight])).to match_array([[4, 3], [4, 4]])
    end
    it "works with multistep intercept_positions" do
      board_class.board[3][3], board_class.board[1][5] = board_class.board[1][5], nil
      board_class.board[7][3] = Rook.new("white")
      board_class.board[6][6] = Bishop.new("white")
      check_location = board_class.check_values(board_class.king_position("black"), "black")
      defending_king = board_class.king_position("black")
      expect(board_class.intercept_danger_positions(defending_king, check_location[:non_knight])).to match_array([[4, 3], [5, 3], [6, 3], [4, 4], [5, 5]])
    end
  end
  context "#check_mate?" do
    it "returns false if danger position piece and be killed by another piece" do
      board_class.board[3][3], board_class.board[1][5] = board_class.board[1][5], nil
      board_class.board[3][6] = Rook.new("white")
      check_location = board_class.check_values(board_class.king_position("black"), "black")
      defending_king = board_class.king_position("black")
      expect(board_class.check_mate?(defending_king, "black", check_location)).to be_falsy
    end
    it "check_mate returns false when 2 pieces have king in check but king can move out of way" do
      board_class.board[3][3], board_class.board[1][5] = board_class.board[1][5], nil
      board_class.board[5][3] = Rook.new("white")
      board_class.board[6][6] = Bishop.new("white")
      check_location = board_class.check_values(board_class.king_position("black"), "black")
      defending_king = board_class.king_position("black")
      expect(board_class.check_mate?(defending_king, "black", check_location)).to be_falsy
    end
    it "check_mate returns false when a piece has king in check but king can be blocked by another piece" do
      board_class.board[3][1], board_class.board[1][5] = board_class.board[1][5], nil
      board_class.board[4][1] = Pawn.new("black")
      board_class.board[3][2] = Pawn.new("black")
      board_class.board[5][3] = Bishop.new("white")
      check_location = board_class.check_values(board_class.king_position("black"), "black")
      defending_king = board_class.king_position("black")
      expect(board_class.check_mate?(defending_king, "black", check_location)).to be_falsy
    end
    it "check_mate returns false when a piece has king in check but king can be blocked by another piece PT2" do
      board_class.board[5][1], board_class.board[1][5] = board_class.board[1][5], nil
      board_class.board[6][1] = Pawn.new("black")
      board_class.board[4][1] = Pawn.new("black")
      board_class.board[4][2] = Knight.new("black")
      board_class.board[6][2] = Pawn.new("black")
      board_class.board[3][3] = Rook.new("black")
      board_class.board[5][5] = Rook.new("white")
      check_location = board_class.check_values(board_class.king_position("black"), "black")
      defending_king = board_class.king_position("black")
      expect(board_class.check_mate?(defending_king, "black", check_location)).to be_falsy
    end
    it "check_mate returns true when a piece has king in check mate" do
      board_class.board[3][1], board_class.board[1][5] = board_class.board[1][5], nil
      board_class.board[5][1] = Rook.new("white")
      board_class.board[5][2] = Rook.new("white")
      board_class.board[5][3] = Rook.new("white")
      check_location = board_class.check_values(board_class.king_position("black"), "black")
      defending_king = board_class.king_position("black")
      expect(board_class.check_mate?(defending_king, "black", check_location)).to be_truthy
    end
    it "check_mate returns true when a piece has king in check mate and a piece that could block is pinned" do
      board_class.board[5][1], board_class.board[1][5] = board_class.board[1][5], nil
      board_class.board[4][1] = Pawn.new("black")
      board_class.board[6][1] = Pawn.new("black")
      board_class.board[6][2] = Pawn.new("black")
      board_class.board[4][2] = Queen.new("black")
      board_class.board[5][5] = Rook.new("white")
      board_class.board[3][3] = Bishop.new("white")
      check_location = board_class.check_values(board_class.king_position("black"), "black")
      defending_king = board_class.king_position("black")
      expect(board_class.check_mate?(defending_king, "black", check_location)).to be_truthy
    end
  end
end
