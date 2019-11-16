import XCTest
@testable import Base64

final class Base64Tests: XCTestCase {
    func testCreateDict() {
        let dict = createDict()
        XCTAssertEqual(Entry(num: 0, c: "A"), dict[0])
        XCTAssertEqual(Entry(num: 1, c: "B"), dict[1])
        XCTAssertEqual(Entry(num: 25, c: "Z"), dict[25])
        XCTAssertEqual(Entry(num: 26, c: "a"), dict[26])
        XCTAssertEqual(Entry(num: 51, c: "z"), dict[51])
        XCTAssertEqual(Entry(num: 52, c: "0"), dict[52])
        XCTAssertEqual(Entry(num: 62, c: "+"), dict[62])
        XCTAssertEqual(Entry(num: 63, c: "/"), dict[63])
    }

    func testPadding() {
        XCTAssertEqual("ASD111", padLeft(input_string: "ASD", filler: "1", len: 6))
        XCTAssertEqual("111ASD", padRight(input_string: "ASD", filler: "1", len: 6))
    }

    func testToBitString() {
        XCTAssertEqual(BitString(), toBitString(num: 0))
        XCTAssertEqual(BitString([1, 0, 1, 0, 0]), toBitString(num: 20))
        XCTAssertEqual(BitString([1, 0, 1, 1, 0]), toBitString(num: 22))
    }

    func testFromBitString() {
        XCTAssertEqual(0, fromBitString(bitString: BitString([])))
        XCTAssertEqual(20, fromBitString(bitString: BitString([1, 0, 1, 0, 0])))
        XCTAssertEqual(22, fromBitString(bitString: BitString([1, 0, 1, 1, 0])))
    }

    func testToBinary() {
        XCTAssertEqual(BitString([0, 1, 1, 1, 0, 0, 1, 1]), toBinary(inputString: "s"))
        XCTAssertEqual(BitString([0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1]), toBinary(inputString: "SOS"))
    }

    func testChunksOf() {
        let z: [[Int]] = []
        XCTAssertEqual(z, chunksOf(num: 8, arr: []))
        let a: [[Int]] = [[1, 2, 3, 4, 5, 6], [7, 8, 9, 10]]
        XCTAssertEqual(a, chunksOf(num: 6, arr: Array(1...10)))
        let b: [[Int]] = [[1,2,3], [4,5,6], [7,8,9], [10, 11, 12], [13, 14, 15]]
        XCTAssertEqual(b, chunksOf(num: 3, arr: Array(1...15)))
    }

    func testFindChar() {
        let dict = createDict()
        XCTAssertEqual("A", findChar(dict: dict, bitString: []))
        XCTAssertEqual("E", findChar(dict: dict, bitString: BitString([1,0,0])))
        XCTAssertEqual("8", findChar(dict: dict, bitString: BitString([1,1,1,1,0,0])))
        XCTAssertEqual("/", findChar(dict: dict, bitString: BitString([1,1,1,1,1,1])))
    }
    
    func testTranslate() {
        let dict = createDict()
        XCTAssertEqual("TWFu", translate(dict: dict, str: "Man"))
        XCTAssertEqual("cGxlYXN1cmUu", translate(dict: dict, str: "pleasure."))
        XCTAssertEqual("cGxlYXN1cmU", translate(dict: dict, str: "pleasure"))
        XCTAssertEqual("cA", translate(dict: dict, str: "p"))
        XCTAssertEqual("", translate(dict: dict, str: ""))
    }

    func testEncode() {
        let dict = createDict()
        XCTAssertEqual("U2F2ZSBvdXIgc291bHMh", encode(dict: dict, str: "Save our souls!"))
        XCTAssertEqual("U2F2ZSBvdXIgc291bHM=", encode(dict: dict, str: "Save our souls"))
        XCTAssertEqual("U2F2ZSBvdXIgc291bA==", encode(dict: dict, str: "Save our soul"))
        XCTAssertEqual("U2F2ZSBvdXIgc291", encode(dict: dict, str: "Save our sou"))
    }

    func testFindCode() {
        let dict = createDict()
        XCTAssertEqual("011010", findCode(dict: dict, c: "a"))
        XCTAssertEqual("011001", findCode(dict: dict, c: "Z"))
        XCTAssertEqual("111101", findCode(dict: dict, c: "9"))
    }

    func testDecode() {
        let dict = createDict()
        XCTAssertEqual("Save our souls!", decode(dict: dict, str: encode(dict: dict, str: "Save our souls!")))
        XCTAssertEqual("Save our souls", decode(dict: dict, str: encode(dict: dict, str: "Save our souls")))
        XCTAssertEqual("Save our soul", decode(dict: dict, str: encode(dict: dict, str: "Save our soul")))
    }


    static var allTests = [
        ("testCreateDict", testCreateDict),
        ("testPadding", testPadding),
        ("testToBitString", testToBitString),
        ("testFromBitString", testFromBitString),
        ("testToBinary", testToBinary),
        ("testChunksOf", testChunksOf),
        ("testFindChar", testFindChar),
        ("testTranslate", testTranslate),
        ("testEncode", testEncode),
        ("testFindCode", testFindCode),
        ("testDecode", testDecode)
    ]
}
