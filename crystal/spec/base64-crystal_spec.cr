require "./spec_helper"

  include MyBase64


describe MyBase64 do

  it "test create dictionary" do
    dictionary = create_dict()
    Entry.new( 0, 'A').should eq(dictionary[0])
    Entry.new( 1, 'B').should eq(dictionary[1])
    Entry.new(25, 'Z').should eq(dictionary[25])
    Entry.new(26, 'a').should eq(dictionary[26])
    Entry.new(51, 'z').should eq(dictionary[51])
    Entry.new(52, '0').should eq(dictionary[52])
    Entry.new(62, '+').should eq(dictionary[62])
    Entry.new(63, '/').should eq(dictionary[63])
    dictionary.size.should eq(64)
  end

  it "test paddings" do
    pad_left("ASD", '1', 6).should eq("ASD111")
    pad_right("ASD", '1', 6).should eq("111ASD")
  end

  it "test to bit string" do
    to_bit_string(0).should eq([] of Int32)
    to_bit_string(20).should eq([1,0,1,0,0])
    to_bit_string(22).should eq([1,0,1,1,0])
  end

  it "test from bit string" do
    from_bit_string([] of Int32).should eq(0)
    from_bit_string([1,0,1,0,0]).should eq(20)
    from_bit_string([1,0,1,1,0]).should eq(22)
  end

  it "test to binary" do
    to_binary("s").should eq([0, 1, 1, 1, 0, 0, 1, 1])
    to_binary("SOS").should eq([0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1])
  end

  it "test chunks of" do
    chunks_of(8, [] of Int32).should eq([] of Array(Int32))
    chunks_of(6, (1..10).to_a).should eq([[1, 2, 3, 4, 5, 6], [7, 8, 9, 10]])
    chunks_of(3, (1..15).to_a).should eq([[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12], [13, 14, 15]])
  end

  it "test find char" do
    dictionary = create_dict
    find_char(dictionary, [] of Int32).should eq('A')
    find_char(dictionary, [1,0,0]).should eq('E')
    find_char(dictionary, [1,1,1,1,0,0]).should eq('8')
    find_char(dictionary, [1,1,1,1,1,1]).should eq('/')
  end

  it "test translate" do
    dictionary = create_dict
    translate(dictionary, "Man").should eq("TWFu")
    translate(dictionary, "pleasure.").should eq("cGxlYXN1cmUu")
    translate(dictionary, "pleasure").should eq("cGxlYXN1cmU")
    translate(dictionary, "p").should eq("cA")
    translate(dictionary, "").should eq("")
  end

  it "test encode" do
    dictionary = create_dict
    encode(dictionary, "Save our souls!").should eq("U2F2ZSBvdXIgc291bHMh")
    encode(dictionary, "Save our souls").should eq("U2F2ZSBvdXIgc291bHM=")
    encode(dictionary, "Save our soul").should eq("U2F2ZSBvdXIgc291bA==")
    encode(dictionary, "Save our sou").should eq("U2F2ZSBvdXIgc291")
  end

  it "test find code" do
    dictionary = create_dict
    find_code(dictionary, 'a').should eq("011010")
    find_code(dictionary, 'Z').should eq("011001")
    find_code(dictionary, '9').should eq("111101")
  end

  it "test decode" do
    dictionary = create_dict
    decode(dictionary, encode(dictionary, "Save our souls!")).should eq("Save our souls!")
    decode(dictionary, encode(dictionary, "Save our souls")).should eq("Save our souls")
    decode(dictionary, encode(dictionary, "Save our soul")).should eq("Save our soul")
  end


end
