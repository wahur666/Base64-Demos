module MyBase64
  VERSION = "0.1.0"

  alias Dict = Array(Entry) 
  alias BitString = Array(Int32)

  struct Entry
    property num, char
    def initialize(@num : Int32, @char : Char)
    end

    def inspect(io : IO)
        io << "Entry: #{@num}, #{@char}"
    end
  end

  def create_dict() : Dict
      abc = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a + ['+', '/']    
      dict = Dict.new
      abc.each_with_index do |value, index|
          dict.push(Entry.new(index, value))
      end
      dict
  end

  def pad_left(input_string : String, filler : Char, len : Int) : String
    input_string.ljust(len, filler)
  end

  def pad_right(input_string : String, filler : Char, len : Int) : String
    input_string.rjust(len, filler)
  end

  def to_bit_string(num : Int32) : BitString
    if num.zero?
      [] of Int32
    else
      num.to_s(2).split("").map{|i| i.to_i}
    end
  end

  def from_bit_string(bit_string : BitString) : Int32
    if bit_string.empty?
      0
    else
      bit_string.join("").to_i(2)
    end
  end

  def to_binary(str : String) : BitString
    arr = [] of Int32
    str.each_char do |c|
      bits = to_bit_string(c.ord)
      while bits.size < 8
        bits.insert(0, 0)
      end
      arr += bits
    end
    arr
  end

  def chunks_of(num : Int32, arr : U) : Array(U) forall U
    chunks = [] of U
    arr.each_slice(num) do |a|
      chunks.push(a)
    end
    chunks
  end

  def find_char(dictionary : Dict, bit_string : BitString) : Char
    a = from_bit_string(bit_string)
    b = Char::ZERO
    dictionary.each do |item|
      b = item.char if item.num == a
    end
    b
  end

  def translate(dictionary : Dict, string : String) : String
    temp = to_binary(string)
    while temp.size % 6 != 0
      temp.push(0)
    end
    chunks = chunks_of(6, temp)
    ret_str = ""
    chunks.each do |item|
      ret_str += find_char(dictionary, item)
    end
    ret_str
  end

  def encode(dictionary : Dict, string : String) : String
    translated = translate(dictionary, string)
    if translated.size % 4 != 0
      translated = pad_left(translated, '=', translated.size + 4 - (translated.size % 4))
    end
    translated
  end

  def find_code(dictionary : Dict, char : Char) : String
    code = ""
    dictionary.each do |item|
      if item.char == char
        code = "%06b" % item.num
        break
      end
    end
    code
  end

  def decode(dictionary : Dict, string="") : String
    while string.ends_with?("=")
      string = string[0...-1]
    end
    binary_text = [] of Int32
    string.each_char do |char|
      binary_text += find_code(dictionary, char).split("").map{|i| i.to_i}
    end
    chunks = chunks_of(8, binary_text)
    out_str = ""
    chunks.each do |item|
      out_str += from_bit_string(item).chr
    end
    if out_str.ends_with?("\0")
      out_str = out_str[0...-1]
    end
    out_str
  end

end
