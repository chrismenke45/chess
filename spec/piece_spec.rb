require "./lib/piece.rb"
describe Piece do
  let(:dummy_class) { Class.new { extend Piece } }
  describe "#valid_move?"
  it "returns true when move is allowed" do
    expect(dummy_class.valid_move?([0, 5], [[1, 3], [4, 2], [5, 2], [0, 5]])).to be_truthy
  end

  it "returns false when move isnt allowed move" do
    expect(dummy_class.valid_move?([0, 6], [[1, 3], [4, 2], [5, 2], [0, 5]])).to be_falsy
  end
  it "returns false when move is off board" do
    expect(dummy_class.valid_move?([0, 9], [[1, 3], [4, 2], [5, 2], [0, 9]])).to be_falsy
  end
  xit "returns false when move is blocked by another piece" do
  end
end
