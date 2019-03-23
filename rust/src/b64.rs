use itertools::join;
use core::fmt::Debug;

#[derive(Debug, PartialEq, Eq)]
pub struct Entry {
    pub num: i32,
    pub c: char,
}

pub type Dict = Vec<Entry>;
type BitString = Vec<i32>;


trait Justify {
    fn ljust(&self, filler: char, len: usize) -> String;
    fn rjust(&self, filler: char, len: usize) -> String;
}

impl Justify for String {
    fn ljust(&self, filler: char, len: usize) -> String {
        let mut outstr = self.clone();
        while outstr.len() < len {
            outstr.push(filler);
        }
        outstr
    }
    fn rjust(&self, filler: char, len: usize) -> String {
        let mut outstr = self.clone();
        while outstr.len() < len {
            outstr.insert(0, filler);
        }
        outstr
    }
}

pub fn create_dict() -> Dict {
    let abc = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    let mut dict = Dict::new();

    for (i, c) in abc.chars().enumerate() {
        dict.push(Entry{num: i as i32, c});
    }

    dict
}

fn pad_left(input_string: &String, filler: char, len: i32) -> String {
    input_string.ljust(filler, len as usize)
}

#[allow(dead_code)]
fn pad_right(input_string: &String, filler: char, len: i32) -> String {
    input_string.rjust(filler, len as usize)
}

fn to_bit_string(num: i32) -> BitString {
    let bitstring: BitString;
    if num == 0 {
        bitstring = Vec::new();
    } else {
        bitstring = format!("{:b}", num).chars().map( |x| x.to_digit(10).unwrap() as i32 ).collect();
    };
    bitstring
}

fn from_bit_string(bit_string: &BitString) -> i32 {
    let val: i32;
    if bit_string.is_empty() {
        val = 0;
    } else {
        val =  i32::from_str_radix(join(bit_string, &"").as_str(), 2).unwrap();
    }
    val
}

fn to_binary(input_str: &String) -> BitString {
    let mut arr = Vec::new();
    for c in input_str.chars() {
        let mut bits = to_bit_string(c as i32);
        while bits.len() < 8 {
            bits.insert(0, 0);
        }
        arr.extend(bits);
    }
    arr
}

fn chunks_of<T>(num: usize, arr: &Vec<T>) -> Vec<Vec<T>> 
  where T: Debug + Clone {
    let mut chunks : Vec<Vec<T>> = Vec::new();
    for a in arr.chunks(num) {
        chunks.push(a.to_vec());
    }
    chunks
}

fn find_char(dictionary: &Dict, bit_string: &BitString) -> char {
    let a = from_bit_string(bit_string);
    let mut b: char = '\0';
    for item in dictionary {
        if item.num == a { b = item.c };
    }
    b
}

fn translate(dictionary: &Dict, string: &String) -> String {
    let mut tmp: BitString = to_binary(string);
    while tmp.len() % 6 != 0 {
        tmp.push(0);
    }
    let chunks = chunks_of(6, &tmp);
    let mut ret_str = String::new();
    for item in chunks {
        ret_str.push(find_char(dictionary, &item));
    }
    ret_str
}

pub fn encode(dictionary: &Dict, string: &String) -> String {
    let mut translated = translate(&dictionary, &string);
    if translated.len() % 4 != 0 {
        translated = pad_left(&translated, '=', (translated.len() + 4 - (translated.len() % 4)) as i32);
    }
    translated
}

fn find_code(dictionary: &Dict, c: char) -> String {
    let mut code = String::new();
    for item in dictionary {
        if item.c == c {
            code = format!("{:06b}", item.num);
        }
    }
    code
}

pub fn decode(dictionary: &Dict, string: &String) -> String {
    let mut outstr = String::new();
    
    let mut tmp = string.clone();
    while tmp.ends_with("=") {
        tmp.truncate(tmp.len()-1);
    }
    
    let mut binary_text: Vec<i32> = Vec::new();

    for c in tmp.chars() {
        let t: Vec<i32> = find_code(&dictionary, c).chars().map( |x| x.to_digit(10).unwrap() as i32 ).collect();
        binary_text.extend( t );
    }
    
    let chunks = chunks_of(8, &binary_text);
    for item in chunks {
        outstr.push( (from_bit_string(&item) as u8) as char );
    }

    if outstr.ends_with("\0") {
        outstr.truncate(outstr.len() - 1);
    }

    outstr
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_create_dictionary() {
        let dictionary = create_dict();
        assert_eq!(Entry{num: 0, c:'A'}, dictionary[0]);
        assert_eq!(Entry{num: 1, c:'B'}, dictionary[1]);
        assert_eq!(Entry{num:25, c:'Z'}, dictionary[25]);
        assert_eq!(Entry{num:26, c:'a'}, dictionary[26]);
        assert_eq!(Entry{num:51, c:'z'}, dictionary[51]);
        assert_eq!(Entry{num:52, c:'0'}, dictionary[52]);
        assert_eq!(Entry{num:62, c:'+'}, dictionary[62]);
        assert_eq!(Entry{num:63, c:'/'}, dictionary[63]);
        assert_eq!(dictionary.len(), 64);
    }

    #[test]
    fn test_padding() {
        assert_eq!("ASD111", pad_left(&"ASD".to_string(), '1', 6));
        assert_eq!("111ASD", pad_right(&"ASD".to_string(), '1', 6));
    }

    #[test]
    fn test_to_bit_string() {
        assert_eq!(Vec::<i32>::new(), to_bit_string(0));
        assert_eq!(vec![1,0,1,0,0], to_bit_string(20));
        assert_eq!(vec![1,0,1,1,0], to_bit_string(22));
    }

    #[test]
    fn test_from_bitsring() {
        assert_eq!(0, from_bit_string(&vec![]));
        assert_eq!(20, from_bit_string(&vec![1, 0, 1, 0, 0]));
        assert_eq!(22, from_bit_string(&vec![1, 0, 1, 1, 0]));
    }

    #[test]
    fn test_to_binary() {
        assert_eq!(vec![0, 1, 1, 1, 0, 0, 1, 1], to_binary(&String::from("s")));
        assert_eq!(vec![0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1], to_binary(&String::from("SOS")));
    }

    #[test]
    fn test_chunks_of() {
        assert_eq!(Vec::<Vec<i32>>::new(), chunks_of(8, &Vec::new()));
        assert_eq!(vec![vec![1,2,3,4,5,6], vec![7,8,9,10]], chunks_of(6, &(1..11).collect()));
        assert_eq!(vec![vec![1,2,3], vec![4,5,6], vec![7,8,9], vec![10, 11, 12], vec![13, 14, 15]], chunks_of(3, &(1..16).collect()));
    }

    #[test]
    fn test_find_char() {
        let dictionary = create_dict();
        assert_eq!('A', find_char(&dictionary, &Vec::new()));
        assert_eq!('E', find_char(&dictionary, &vec![1,0,0]));
        assert_eq!('8', find_char(&dictionary, &vec![1,1,1,1,0,0]));
        assert_eq!('/', find_char(&dictionary, &vec![1,1,1,1,1,1]));
    }

    #[test]
    fn test_translate() {
        let dictionary = create_dict();
        assert_eq!("TWFu", translate(&dictionary, &String::from("Man")).as_str());
        assert_eq!("cGxlYXN1cmUu", translate(&dictionary, &String::from("pleasure.")).as_str());
        assert_eq!("cGxlYXN1cmU", translate(&dictionary, &String::from("pleasure")).as_str());
        assert_eq!("cA", translate(&dictionary, &String::from("p")).as_str());
        assert_eq!("", translate(&dictionary, &String::new()).as_str());
    }


    #[test]
    fn test_encode() {
        let dictionary = create_dict();
        assert_eq!("U2F2ZSBvdXIgc291bHMh", encode(&dictionary, &String::from("Save our souls!")).as_str());
        assert_eq!("U2F2ZSBvdXIgc291bHM=", encode(&dictionary, &String::from("Save our souls")).as_str());
        assert_eq!("U2F2ZSBvdXIgc291bA==", encode(&dictionary, &String::from("Save our soul")).as_str());
        assert_eq!("U2F2ZSBvdXIgc291", encode(&dictionary, &String::from("Save our sou")).as_str());
    }

    #[test]
    fn test_find_code() {
        let dictionary = create_dict();
        assert_eq!("011010", find_code(&dictionary, 'a').as_str());
        assert_eq!("011001", find_code(&dictionary, 'Z').as_str());
        assert_eq!("111101", find_code(&dictionary, '9').as_str());
    }

    #[test]
    fn test_decode() {
        let dictionary = create_dict();
        assert_eq!("Save our souls!", decode(&dictionary, &encode(&dictionary, &String::from("Save our souls!"))).as_str());
        assert_eq!("Save our souls", decode(&dictionary, &encode(&dictionary, &String::from("Save our souls"))).as_str());
        assert_eq!("Save our soul", decode(&dictionary, &encode(&dictionary, &String::from("Save our soul"))).as_str());
    }
}