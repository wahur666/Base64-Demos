#include "stdafx.h"
#include <algorithm>
#include "CppUnitTest.h"
#include "../Base64/Base64.h"
#include "../Base64/stdafx.h"

#pragma comment(lib, "Base64.lib")

using namespace Microsoft::VisualStudio::CppUnitTestFramework;

namespace UnitTest1
{		
	
	TEST_CLASS(UnitTest1)
	{
	public:
		bool compareBitsrings(Bitstring a, Bitstring b)
		{
			if (a.size() != b.size())
				return false;
			for (size_t i = 0; i < a.size(); i++)
				if (a[i] != b[i])
					return false;
			return true;
		};

		TEST_METHOD(CreateDictionaryTest)
		{
			Base64 base64 = Base64();

			Assert::AreEqual(base64[0], 'A');
			Assert::AreEqual(base64[1], 'B');
			Assert::AreEqual(base64[25], 'Z');
			Assert::AreEqual(base64[26], 'a');
			Assert::AreEqual(base64[51], 'z');
			Assert::AreEqual(base64[52], '0');
			Assert::AreEqual(base64[62], '+');
			Assert::AreEqual(base64[63], '/');
			Assert::AreEqual(base64.DictLength(), 64);
		}

		TEST_METHOD(padTest)
		{
			std::string str = "asdasdpoi";
			Assert::AreEqual(std::string("asdasdpoiAAA"), Base64::pad("right", 'A', 12, str));
			Assert::AreEqual(std::string("AAAasdasdpoi"), Base64::pad("left", 'A', 12, str));
			Assert::AreEqual(std::string(), Base64::pad("", 'A', 12, str));
		}


		TEST_METHOD(toBitStringTest)
		{
			Bitstring bits = { 1, 1 };
			Assert::AreEqual(true, compareBitsrings(bits, Base64::toBitString(3)));
			bits = { 1 };
			Assert::AreEqual(true, compareBitsrings(bits, Base64::toBitString(1)));
			bits = {};
			Assert::AreEqual(true, compareBitsrings(bits, Base64::toBitString(0)));
			bits = { 1, 0, 1, 0 };
			Assert::AreEqual(true, compareBitsrings(bits, Base64::toBitString(10)));
			bits = { 1, 1, 0, 0, 1, 0, 0 };
			Assert::AreEqual(true, compareBitsrings(bits, Base64::toBitString(100)));
		}
		
		TEST_METHOD(fromBitStringTest)
		{
			Bitstring bits = { 0, 0, 0, 0, 0, 0, 1, 1 };
			Assert::AreEqual(Base64::fromBitString(bits), 3);
			bits = { 1, 0, 1, 0, 0 };
			Assert::AreEqual(Base64::fromBitString(bits), 20);
			bits = { 1, 0, 1, 1, 0 };
			Assert::AreEqual(Base64::fromBitString(bits), 22);
		}


		
		TEST_METHOD(toBinaryTest)
		{
			std::string str1 = "s";
			Bitstring bits = { 0, 1, 1, 1, 0, 0, 1, 1 };
			Assert::AreEqual(true, compareBitsrings(bits, Base64::toBinary(str1)));
			str1 = "SOS";
			bits = { 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1 };
			Assert::AreEqual(true, compareBitsrings(bits, Base64::toBinary(str1)));
		}

		
		TEST_METHOD(chunksOfTest)
		{
			// Test 1
			std::vector<Bitstring> chunks = { Bitstring{ 1, 2, 3, 4, 5, 6 }, 
											  Bitstring{ 7, 8, 9, 10 } };
			std::vector<int> chunkTest(10);
			int n = 1;
			std::generate(chunkTest.begin(), chunkTest.begin() + 10, [&n] { return n++; });
			auto chunkz1 = Base64::chunksOf(6, chunkTest);
			if (chunkz1.size() != chunks.size())
				Assert::Fail(L"Size not equal");
			else
				for (int i = 0; i < chunks.size(); i++)
					Assert::AreEqual(true, compareBitsrings(chunks[i], chunkz1[i]));

			// Test 2
			chunks = { Bitstring{ 1, 2, 3 },
					   Bitstring{ 4, 5, 6 },
					   Bitstring{ 7, 8, 9 },
					   Bitstring{ 10, 11, 12 },
					   Bitstring{ 13, 14, 15 } };
			n = 1;
			chunkTest.resize(15);
			std::generate(chunkTest.begin(), chunkTest.begin() + 15, [&n] { return n++; });
			chunkz1 = Base64::chunksOf(3, chunkTest);
			if (chunkz1.size() != chunks.size())
				Assert::Fail();
			else
				for (int i = 0; i < chunks.size(); i++)
					Assert::AreEqual(true, compareBitsrings(chunks[i], chunkz1[i]));
			
		}
		
		TEST_METHOD(findCharTest)
		{
			Base64 base64 = Base64();
			char character = Base64::findChar(base64.GetDict(), Bitstring{});
			Assert::AreEqual('A', character);
			character = Base64::findChar(base64.GetDict(), Bitstring{ 1, 0, 0 });
			Assert::AreEqual('E', character);			   
			character = Base64::findChar(base64.GetDict(), Bitstring{ 1, 1, 1, 1, 0, 0 });
			Assert::AreEqual('8', character);			   
			character = Base64::findChar(base64.GetDict(), Bitstring{ 1, 1, 1, 1, 1, 1 });
			Assert::AreEqual('/', character);

		}
		TEST_METHOD(translateTest)
		{
			Base64 base64 = Base64();
			Assert::AreEqual(std::string("TWFu"),			Base64::translate(base64.GetDict(), "Man"));
			Assert::AreEqual(std::string("cGxlYXN1cmUu"),	Base64::translate(base64.GetDict(), "pleasure."));
			Assert::AreEqual(std::string("cGxlYXN1cmU"),	Base64::translate(base64.GetDict(), "pleasure"));
			Assert::AreEqual(std::string("cGxlYXN1cg"),		Base64::translate(base64.GetDict(), "pleasur"));
			Assert::AreEqual(std::string("cA"),				Base64::translate(base64.GetDict(), "p"));
		}
		

		TEST_METHOD(encodeTest)
		{
			Base64 base64 = Base64();

			Assert::AreEqual(std::string("U2F2ZSBvdXIgc291bHMh"), Base64::encode(base64.GetDict(), "Save our souls!"));
			Assert::AreEqual(std::string("U2F2ZSBvdXIgc291bHM="), Base64::encode(base64.GetDict(), "Save our souls"));
			Assert::AreEqual(std::string("U2F2ZSBvdXIgc291bA=="), Base64::encode(base64.GetDict(), "Save our soul"));
			Assert::AreEqual(std::string("U2F2ZSBvdXIgc291"),     Base64::encode(base64.GetDict(), "Save our sou"));
		}
		TEST_METHOD(findCodeTest)
		{
			Base64 base64 = Base64();

			Bitstring bits = { 1, 1, 0, 1, 0 };
			Assert::AreEqual(true, compareBitsrings(bits, Base64::findCode(base64.GetDict(), 'a')));
			bits = { 1, 1, 0, 0, 1 };
			Assert::AreEqual(true, compareBitsrings(bits, Base64::findCode(base64.GetDict(), 'Z')));
			bits = { 1, 1, 1, 1, 0, 1 };
			Assert::AreEqual(true, compareBitsrings(bits, Base64::findCode(base64.GetDict(), '9')));

		}
		TEST_METHOD(decodeTest)
		{
			Base64 base64 = Base64();
			Dict dict = base64.GetDict();
			Assert::AreEqual(std::string("Save Our Souls!"),		Base64::decode(dict, Base64::encode(dict, "Save Our Souls!")));
			Assert::AreEqual(std::string("Save Our Souls"),			Base64::decode(dict, Base64::encode(dict, "Save Our Souls")));
			Assert::AreEqual(std::string("Save Our Soul"),			Base64::decode(dict, Base64::encode(dict, "Save Our Soul")));
			Assert::AreEqual(std::string("Base64 is a group of"),	Base64::decode(dict, Base64::encode(dict, "Base64 is a group of")));
		}
	};
}