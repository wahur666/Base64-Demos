
mod b64;
mod lib;

fn main() {
    use b64::*;
    use lib::Indexer;

    let dict: Dict = create_dict();
    let _v = encode(&dict, &String::from("Save Our souls"));

    let a = String::from("s: Box<str>");

    println!("{:?}", a.get_at(3) );

}
