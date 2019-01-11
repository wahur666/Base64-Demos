require "test/unit"
extend Test::Unit::Assertions


Entry = Struct.new(:num, :char)

def create_dictionary
  abc = [*"A".."Z", *"a".."z", *"0".."9", "+", "/"]
  dict = Array.new
  abc.each_with_index {|val, index| dict.append(Entry.new(index, val))}
  dict
end

def pad_left(input_string, filler, len)
  input_string.ljust(len, filler.to_s)
end

def pad_right(input_string, filler, len)
  input_string.to_s.rjust(len, filler.to_s)
end

def to_bit_string(num)
  if num.zero?
    []
  else
    num.to_s(2).split('').map(&:to_i)
  end
end

def from_bit_string(bit_string)
  if bit_string == []
    0
  else
    bit_string.join('').to_i(2)
  end
end

def to_binary(str)
  arr = []
  str.to_s.each_char do |c|
    bits = to_bit_string(c.ord)
    while bits.size < 8
      bits.insert(0, 0)
    end
    arr += bits
  end
  arr
end

def chunks_of(num, arr)
  chunks = []
  arr.each_slice(num) do |a|
    chunks.push(a)
  end
  chunks
end

def find_char(dictionary, bit_string)
  a = from_bit_string(bit_string)
  dictionary.each do |item|
    return item[:char] if item[:num] == a
  end
end

def translate(dictionary, string)
  temp = to_binary(string)
  while temp.size % 6 != 0
    temp.push(0);
  end
  chunkz = chunks_of(6, temp)
  ret_str = ""
  chunkz.each {|item| ret_str += find_char(dictionary, item)}
  ret_str
end

def encode(dictionary, string)
  translated = translate(dictionary, string)
  if translated.size % 4 != 0
    translated = pad_left(translated, "=", translated.size + 4 - (translated.size % 4))
  end
  translated
end

def find_code(dictionary, char)
  dictionary.each do |item|
    if item[:char] == char
      return "%06b" % item[:num]
    end
  end
end

def decode(dictionary, string='')
  while string.end_with?('=')
    string = string[0...-1]
  end
  binary_text = []
  string.each_char do |char|
    binary_text.push(*find_code(dictionary, char).split(""));
  end
  chunks = chunks_of(8, binary_text)
  out_str = ''
  chunks.each do |item|
    out_str += from_bit_string(item).chr
  end
  if out_str.end_with?("\0")
    out_str = out_str[0...-1]
  end
  out_str
end