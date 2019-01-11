require 'test/unit'
require './base64_main'

class Base64Test < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_dict()
    dictionary = create_dictionary
    assert_equal(Entry.new(0, "A"), dictionary[0])
    assert_equal(Entry.new(1, "B"), dictionary[1])
    assert_equal(Entry.new(25, "Z"), dictionary[25])
    assert_equal(Entry.new(26, "a"), dictionary[26])
    assert_equal(Entry.new(51, "z"), dictionary[51])
    assert_equal(Entry.new(52, "0"), dictionary[52])
    assert_equal(Entry.new(62, "+"), dictionary[62])
    assert_equal(Entry.new(63, "/"), dictionary[63])
    assert_equal(64, dictionary.size)
  end

  def test_padding
    assert_equal("ASD111", pad_left("ASD", "1", 6))
    assert_equal("111ASD", pad_right("ASD", "1", 6))
  end

  def test_to_bit_string
    assert_equal([], to_bit_string(0))
    assert_equal([1,0,1,0,0], to_bit_string(20))
    assert_equal([1,0,1,1,0], to_bit_string(22))
  end

  def test_from_bit_string
    assert_equal(0, from_bit_string([]))
    assert_equal(20, from_bit_string([1,0,1,0,0]))
    assert_equal(22, from_bit_string([1,0,1,1,0]))
  end

  def test_to_binary
    assert_equal([0, 1, 1, 1, 0, 0, 1, 1], to_binary("s"))
    assert_equal([0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1], to_binary("SOS"))
  end

  def test_chunks_of
    assert_equal([], chunks_of(8, []))
    assert_equal([[1, 2, 3, 4, 5, 6], [7, 8, 9, 10]], chunks_of(6, [*1..10]))
    assert_equal([[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12], [13, 14, 15]], chunks_of(3, [*1..15]))
  end

  def test_find_char
    dictionary = create_dictionary
    assert_equal('A', find_char(dictionary, []))
    assert_equal('E', find_char(dictionary, [1,0,0]))
    assert_equal('8', find_char(dictionary, [1,1,1,1,0,0]))
    assert_equal('/', find_char(dictionary, [1,1,1,1,1,1]))
  end

  def test_translate
    dictionary = create_dictionary
    assert_equal("TWFu", translate(dictionary, "Man"))
    assert_equal("cGxlYXN1cmUu", translate(dictionary, "pleasure."))
    assert_equal("cGxlYXN1cmU", translate(dictionary, "pleasure"))
    assert_equal("cA", translate(dictionary, "p"))
    assert_equal("", translate(dictionary, ""))
  end

  def test_encode
    dictionary = create_dictionary
    assert_equal("U2F2ZSBvdXIgc291bHMh", encode(dictionary, "Save our souls!"))
    assert_equal("U2F2ZSBvdXIgc291bHM=", encode(dictionary, "Save our souls"))
    assert_equal("U2F2ZSBvdXIgc291bA==", encode(dictionary, "Save our soul"))
    assert_equal("U2F2ZSBvdXIgc291", encode(dictionary, "Save our sou"))
  end

  def test_find_code
    dictionary = create_dictionary
    assert_equal("011010", find_code(dictionary, 'a'))
    assert_equal("011001", find_code(dictionary, 'Z'))
    assert_equal("111101", find_code(dictionary, '9'))
  end

  def test_decode
    dictionary = create_dictionary
    assert_equal("Save our souls!", decode(dictionary, encode(dictionary, "Save our souls!")))
    assert_equal("Save our souls", decode(dictionary, encode(dictionary, "Save our souls")))
    assert_equal("Save our soul", decode(dictionary, encode(dictionary, "Save our soul")))
  end

end