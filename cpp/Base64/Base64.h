#pragma once
#include "stdafx.h"

class Base64
{
public:

	Base64();
	virtual ~Base64();
	int DictLength();

	char operator[](const int i) const;
	char & operator[](const int i);
	Dict GetDict() { return dict; }

	static std::string pad(const std::string side, const char fillerChar, int n, std::string inputStr);
	static Bitstring toBitString(int number);
	static int fromBitString(Bitstring bits);
	static Bitstring toBinary(std::string str);
	
	template <class T>
	static std::vector<std::vector<T> > chunksOf(size_t n, std::vector<T> elemList);
	static char findChar(Dict dict, Bitstring bits);
	static std::string translate(Dict dict, std::string str);
	static std::string encode(Dict dict, std::string str);
	static Bitstring findCode(Dict dict, char c);
	static Bitstring padTo6(Bitstring bits);
	static std::string decode(Dict dict, std::string str);

private:

	Dict dict;


};

template<class T>
inline std::vector<std::vector<T>> Base64::chunksOf(size_t n, std::vector<T> elemList)
{
	std::vector<std::vector<T>> chunks = {};

	for (size_t i = 0; i < elemList.size(); i += n)
	{
		std::vector<T> z(elemList.begin() + i, elemList.begin() + i + std::min(n, elemList.size() - i));
		chunks.push_back(z);
	}

	return chunks;
}
