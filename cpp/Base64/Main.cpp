// Base64.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "Base64.h"


bool compareBitsrings(Bitstring a, Bitstring b)
{
	if (a.size() != b.size())
		return false;
	for (size_t i = 0; i < a.size(); i++) {
		if (a[i] != b[i])
			return false;
	}
	return true;
};

int main()
{
	Base64* base = new Base64();
	
	std::vector<int> asd = { 1,2,3,4,5,6,7,8,9,10 };

	std::cout << Base64::pad("left", 'A', 12, "asdasdpoi") << std::endl;
	std::cout << Base64::pad("right", 'A', 12, "asdasdpoi") << std::endl;
	std::cout << Base64::pad("", 'A', 12, "asdasdpoi") << std::endl;

	Bitstring bits = { 1, 1 };
	
	auto b = ((std::string)"qwe").empty();

	compareBitsrings(bits, Base64::toBitString(3));

	auto chunkz = Base64::chunksOf<int>(4, asd);

	std::cout << chunkz << std::endl;

	system("pause");

    return 0;
}

