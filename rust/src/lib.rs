
pub trait Indexer {
    fn get_at(&self, num: usize) -> Option<char>;
}


impl Indexer for String {
    fn get_at(&self, num: usize) -> Option<char> {
        let chars : Vec<char> = self.chars().collect();
        if chars.len() < num {
            None
        } else {
            Some(chars[num])
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_indexer() {
        let t = String::from("qwesgwefeczegt");
        assert_eq!('s', t.get_at(3).unwrap());
        assert_eq!('w', t.get_at(1).unwrap());
        assert_eq!('f', t.get_at(7).unwrap());
        assert_eq!(None, t.get_at(111));
    }
}
