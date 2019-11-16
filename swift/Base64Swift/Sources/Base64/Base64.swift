struct Entry: Equatable {
    var num: Int32
    var c: Character

    public static func ==(lhs: Entry, rhs: Entry) -> Bool {
        return lhs.c == rhs.c && lhs.num == rhs.num
    }
}


typealias Dict = [Entry]
typealias BitString = [Int32]

func createDict() -> Dict {
    let abc = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    var dict = Dict()

    for (i, c) in abc.enumerated() {
        dict.append(Entry(num: Int32(i), c: c));
    }

    return dict
}

func padLeft(input_string: String, filler: Character, len: Int32) -> String {
    var str = input_string;
    while str.count < len {
        str.append(filler)
    }
    return str
}

func padRight(input_string: String, filler: Character, len: Int32) -> String {
    var str = input_string;
    while str.count < len {
        str.insert(filler, at: input_string.startIndex)
    }
    return str
}

func toBitString(num: Int32) -> BitString {
    var bitString: BitString
    if num == 0 {
        bitString = BitString()
    } else {
        bitString = Array(String(num, radix: 2)).map({Int32(String($0), radix: 10) ?? 0})
    }
    return bitString
}

func fromBitString(bitString: BitString) -> Int32 {
    var val: Int32
    if bitString.isEmpty {
        val = 0
    } else {
        val = Int32(bitString.map({String($0)}).joined(separator: ""), radix: 2) ?? 0
    }
    return val
}

func toBinary(inputString: String) -> BitString {
    var arr = BitString()
    for c in inputString {
        var bits = toBitString(num: Int32(c.asciiValue ?? 0))
        while bits.count < 8 {
            bits.insert(0, at: 0)
        }
        arr += bits
    }
    return arr
}

func chunksOf<T>(num: Int, arr: [T]) -> [[T]] {
    var chunks: [[T]] = []
    for i in stride(from: 0, through: arr.count-1, by: num){
        chunks.append(Array(arr[i..<min(i + num, arr.count)]))
    }
    return chunks
}

func findChar(dict: Dict, bitString: BitString) -> Character {
    let a = fromBitString(bitString: bitString)
    var b: Character = "\0"
    for item in dict {
        if item.num == a {
            b = item.c
            break
        }
    }
    return b
}

func translate(dict: Dict, str: String) -> String {
    var tmp: BitString = toBinary(inputString: str)
    while tmp.count % 6 != 0 {
        tmp.append(0)
    }
    let chunks = chunksOf(num: 6, arr: tmp)
    var retStr = ""
    for chunk in chunks {
        retStr.append(findChar(dict: dict, bitString: chunk))
    }

    return retStr
}

func encode(dict: Dict, str: String) -> String {
    var translated = translate(dict: dict, str: str)
    if translated.count % 4 != 0 {
        translated = padLeft(input_string: translated, filler: "=", len: (Int32(translated.count + 4 - (translated.count % 4))))
    }
    return translated
}

func findCode(dict: Dict, c: Character) -> String {
    var code = ""
    for item in dict {
        if item.c == c {
            let a = toBitString(num: item.num).map({String($0)}).joined(separator: "")
            code = padRight(input_string: a, filler: "0", len: 6)
        }
    }
    return code
}

func decode(dict: Dict, str: String) -> String {
    var outStr = ""

    var tmp = str
    while tmp.hasSuffix("=") {
        tmp = String(tmp.dropLast())
    }

    var binaryText: BitString = []
    for c in tmp {
        let t: BitString = Array(findCode(dict: dict, c: c)).map({Int32(String($0)) ?? 0})
        binaryText += t
    }

    let chunks = chunksOf(num: 8, arr: binaryText)
    for chunk in chunks {
        outStr.append(Character(UnicodeScalar(UInt32(fromBitString(bitString: chunk)) ) ?? "\0"))
    }

    if outStr.hasSuffix("\0") {
        outStr = String(outStr.dropLast())
    }
    return outStr
}