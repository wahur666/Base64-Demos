#include "stdafx.h"
#include "Base64.h"

using namespace std;

Base64::Base64()
{
	string str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	dict = Dict();
	for (size_t i = 0; i < str.size(); i++)
		dict.push_back(Entry(i, str[i]));
}


Base64::~Base64()
{
}


int Base64::DictLength()
{
	return dict.size();
}

char Base64::operator[](const int i) const 
{
	if (i < 0)
		return std::get<1>(dict[dict.size() + i]);
	return std::get<1>(dict[i]);
}

char & Base64::operator[](const int i)
{
	if (i < 0)
		return std::get<1>(dict[dict.size() + i]);
	return std::get<1>(dict[i]);
}

std::string Base64::pad(const std::string side, const char fillerChar, int n, std::string inputStr)
{
	if (side == "right")
		return inputStr.append(n - inputStr.length(), fillerChar);
	if (side == "left")
		return inputStr.insert(0, n - inputStr.length(), fillerChar);
	return std::string();
}

Bitstring Base64::toBitString(int number)
{
	if (number == 0)
		return Bitstring();
	Bitstring bits = Bitstring();
	string b1 = to_binary(number);
	for (char c : b1)
		bits.push_back((int)c - '0');
	return bits;
}

int Base64::fromBitString(Bitstring bits)
{
	if (bits.size() == 0)
		return 0;
	stringstream ss;
	for (int bit : bits)
		ss << bit;
	return stoi(ss.str(), 0, 2);
}

Bitstring Base64::toBinary(std::string str)
{
	Bitstring bits = {};
	for (char item : str) 
	{
		Bitstring a = toBitString(item);
		while (a.size() < 8)
			a.insert(a.begin(), 8 - a.size(), 0);
		bits.insert(bits.end(), a.begin(), a.end());
	}

	return bits;
}

char Base64::findChar(Dict dict, Bitstring bits)
{
	int a = fromBitString(bits);
	for(Entry pair : dict)
	{
		if (a == get<0>(pair))
			return get<1>(pair);
	}
	return '\0';
}

std::string Base64::translate(Dict dict, std::string str)
{
	Bitstring temp = toBinary(str);
	string temp1 = "";
	vector<Bitstring> chunkz;
	if (temp.size() % 6 != 0)
		temp.insert(temp.end(), 6 - temp.size() % 6, 0);
	chunkz = chunksOf(6, temp);

	string retStr = "";
	for(Bitstring item : chunkz)
	{
		retStr += findChar(dict, item);
	}

	return retStr;
}

std::string Base64::encode(Dict dict, std::string str)
{
	string retStr = Base64::translate(dict, str);
	if (retStr.length() % 4 != 0)
	{
		retStr = pad("right", '=', retStr.length() + 4 - (retStr.length() % 4), retStr);
	}
	return retStr;
}

Bitstring Base64::findCode(Dict dict, char c)
{
	for(Entry item : dict)
	{
		if (get<1>(item) == c)
			return toBitString(get<0>(item));
	}
	return Bitstring();
}

Bitstring Base64::padTo6(Bitstring bits)
{
	if (bits.size() % 6 != 0 || bits.size() == 0)
		bits.insert(bits.begin(), 6 - bits.size() % 6, 0);
	return bits;
}

std::string Base64::decode(Dict dict, std::string str)
{
	while (str[str.length() - 1] == '=' )
		str = str.substr(0, str.length() - 1);

	Bitstring bits = {};

	for(char item : str)
	{
		Bitstring t = padTo6(findCode(dict, item));
		bits.insert(bits.end(), t.begin(), t.end());
	}
	vector<Bitstring> chunks = chunksOf(8, bits);
	string outStr = "";
	for(Bitstring item : chunks)
	{
		outStr += (char)fromBitString(item);
	}
	if (outStr[outStr.length() - 1] == '\0')
		outStr = outStr.substr(0, outStr.length() - 1);
	return outStr;
}

;
