using Microsoft.VisualStudio.TestTools.UnitTesting;
using Base64CSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Base64CSharp.Tests
{
    using BitString = List<int>;
    using Entry = Tuple<int, char>;
    using Dict = List<Tuple<int, char>>;
    [TestClass()]
    public class Base64Tests
    {
        Base64 base64 = new Base64();
        [TestMethod()]
        public void CreateDictionaryTest()
        {
            Assert.AreEqual(base64[0], 'A');
            Assert.AreEqual(base64[1], 'B');
            Assert.AreEqual(base64[25], 'Z');
            Assert.AreEqual(base64[26], 'a');
            Assert.AreEqual(base64[51], 'z');
            Assert.AreEqual(base64[52], '0');
            Assert.AreEqual(base64[62], '+');
            Assert.AreEqual(base64[63], '/');
            Assert.AreEqual(base64.DictLenght, 64);
        }

        [TestMethod()]
        public void padTest()
        {
            string str = "asdasdpoi";
            Assert.AreEqual("asdasdpoiAAA", Base64.pad("right", 'A', 12, str));
            Assert.AreEqual("AAAasdasdpoi", Base64.pad("left", 'A', 12, str));
            Assert.AreEqual(null, Base64.pad("", 'A', 12, str));
        }

        [TestMethod()]
        public void toBitStringTest()
        {
            BitString bits = new BitString() { 1, 1 };
            CollectionAssert.AreEqual(bits, Base64.toBitString(3));
            bits = new BitString() { 1 };
            CollectionAssert.AreEqual(bits, Base64.toBitString(1));
            bits = new BitString();
            CollectionAssert.AreEqual(bits, Base64.toBitString(0));
            bits = new BitString() { 1, 0, 1, 0 };
            CollectionAssert.AreEqual(bits, Base64.toBitString(10));
            bits = new BitString() { 1, 1, 0, 0, 1, 0, 0 };
            CollectionAssert.AreEqual(bits, Base64.toBitString(100));
        }

        [TestMethod()]
        public void fromBitStringTest()
        {
            BitString bits = new BitString() { 0, 0, 0, 0, 0, 0, 1, 1 };
            Assert.AreEqual(Base64.fromBitString(bits), 3);
            bits = new BitString() { 1, 0, 1, 0, 0 };
            Assert.AreEqual(Base64.fromBitString(bits), 20);
            bits = new BitString() { 1, 0, 1, 1, 0 };
            Assert.AreEqual(Base64.fromBitString(bits), 22);
        }

        [TestMethod()]
        public void toBinaryTest()
        {
            string str1 = "s";
            BitString bits = new BitString() { 0, 1, 1, 1, 0, 0, 1, 1 };
            CollectionAssert.AreEqual(bits, Base64.toBinary(str1));
            str1 = "SOS";
            bits = new BitString() { 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1 };
            CollectionAssert.AreEqual(bits, Base64.toBinary(str1));
        }

        [TestMethod()]
        public void chunksOfTest()
        {
            // Test 1
            List<BitString> chunks = new List<BitString> { new BitString() { 1, 2, 3, 4, 5, 6 }, new BitString() { 7, 8, 9, 10 } };
            List<int> chunkTest = Enumerable.Range(1, 10).ToList();
            var chunkz1 = Base64.chunksOf(6, chunkTest);
            if (chunkz1.Count != chunks.Count)
                Assert.Fail();
            else
                for (int i = 0; i < chunks.Count; i++)
                    CollectionAssert.AreEqual(chunks[i], chunkz1[i]);

            // Test 2
            chunks = new List<BitString> { new BitString() { 1, 2, 3 },
                                           new BitString() { 4, 5, 6 },
                                           new BitString() { 7, 8, 9 },
                                           new BitString() { 10, 11, 12 },
                                           new BitString() { 13, 14, 15} };
            chunkTest = Enumerable.Range(1, 15).ToList();
            chunkz1 = Base64.chunksOf(3, chunkTest);
            if (chunkz1.Count != chunks.Count)
                Assert.Fail();
            else
                for (int i = 0; i < chunks.Count; i++)
                    CollectionAssert.AreEqual(chunks[i], chunkz1[i]);
        }

        [TestMethod()]
        public void findCharTest()
        {
            char character = Base64.findChar(base64.GetDict, new BitString() { });
            Assert.AreEqual('A', character);
            character = Base64.findChar(base64.GetDict, new BitString() { 1, 0, 0 });
            Assert.AreEqual('E', character);
            character = Base64.findChar(base64.GetDict, new BitString() { 1, 1, 1, 1, 0, 0 });
            Assert.AreEqual('8', character);
            character = Base64.findChar(base64.GetDict, new BitString() { 1, 1, 1, 1, 1, 1 });
            Assert.AreEqual('/', character);

        }

        [TestMethod()]
        public void translateTest()
        {
            Assert.AreEqual("TWFu", Base64.translate(base64.GetDict, "Man"));
            Assert.AreEqual("cGxlYXN1cmUu", Base64.translate(base64.GetDict, "pleasure."));
            Assert.AreEqual("cGxlYXN1cmU", Base64.translate(base64.GetDict, "pleasure"));
            Assert.AreEqual("cGxlYXN1cg", Base64.translate(base64.GetDict, "pleasur"));
            Assert.AreEqual("cA", Base64.translate(base64.GetDict, "p"));
        }

        [TestMethod()]
        public void encodeTest()
        {
            Assert.AreEqual("U2F2ZSBvdXIgc291bHMh", Base64.encode(base64.GetDict, "Save our souls!"));
            Assert.AreEqual("U2F2ZSBvdXIgc291bHM=", Base64.encode(base64.GetDict, "Save our souls"));
            Assert.AreEqual("U2F2ZSBvdXIgc291bA==", Base64.encode(base64.GetDict, "Save our soul"));
            Assert.AreEqual("U2F2ZSBvdXIgc291", Base64.encode(base64.GetDict, "Save our sou"));
        }

        [TestMethod()]
        public void findCodeTest()
        {
            BitString bits = new BitString() { 1, 1, 0, 1, 0 };
            CollectionAssert.AreEqual(bits, Base64.findCode(base64.GetDict, 'a'));
            bits = new BitString() { 1, 1, 0, 0, 1 };
            CollectionAssert.AreEqual(bits, Base64.findCode(base64.GetDict, 'Z'));
            bits = new BitString() { 1, 1, 1, 1, 0, 1 };
            CollectionAssert.AreEqual(bits, Base64.findCode(base64.GetDict, '9'));
        }

        [TestMethod()]
        public void decodeTest()
        {
            Dict dict = base64.GetDict;
            Assert.AreEqual("Save Our Souls!", Base64.decode(dict, Base64.encode(dict, "Save Our Souls!")));
            Assert.AreEqual("Save Our Souls", Base64.decode(dict, Base64.encode(dict, "Save Our Souls")));
            Assert.AreEqual("Save Our Soul", Base64.decode(dict, Base64.encode(dict, "Save Our Soul")));
            Assert.AreEqual("Base64 is a group of", Base64.decode(dict, Base64.encode(dict, "Base64 is a group of")));
        }
    }
}



