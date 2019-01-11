#ifndef H_STRING_HELPER
#define H_STRING_HELPER

#include <string>
#include <vector>
#include <sstream>
#include <map>
#include <algorithm>

static std::vector<std::string> split(std::string str, char delimiter = ' ')
{
	std::vector<std::string> split_internal;
	std::stringstream split_ss(str); // Turn the string into a stream.
	std::string split_tok;

	while (getline(split_ss, split_tok, delimiter))
	{
		split_internal.push_back(split_tok);
	}
	
	return split_internal;
}

template <typename T>
static void print_vector_map(T data)
{
	char indent = ' ';
	int level = 5;
	std::cout << '[' << std::endl;
	for (auto elem : data)
	{
		std::cout << std::string(level, indent) << '{' << std::endl;
		level = 10;
		for (auto it = elem.cbegin(); it != elem.cend(); it++)
		{
			std::cout << std::string(level, indent) << it->first << " : " << it->second << std::endl;
		}
		level = 5;
		std::cout << std::string(level, indent) << '}' << std::endl;
	}
	std::cout << ']' << std::endl;
}

static std::string to_binary(int number) {
	long rem, i = 1, sum = 0;
	do
	{
		rem = number % 2;
		sum = sum + (i*rem);
		number = number / 2;
		i = i * 10;
	} while (number > 0);
	return std::to_string(sum);
	
}

#endif  // H_STRING_HELPER
