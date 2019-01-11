// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#pragma once

#include "targetver.h"

#include <stdio.h>
#include <tchar.h>
#include <iostream>
#include <list>
#include <vector>
#include <tuple>
#include <bitset>


#include "helpers.h"
#include "prettyprint.hpp"


using Bitstring = std::vector<int>;
using Entry = std::tuple<int, char>;
using Dict = std::vector<Entry>;

/*
#include <iostream>
#include <algorithm>
#include <sstream>
#include <iterator>

inline
std::string strip( std::string str, char  ch = ' ' )
{
str.erase(0, std::min(str.find_first_not_of(ch), str.size()-1));
str.erase(std::min(str.find_last_not_of(ch), str.size()-1),str.size()-1);
return str;
}

inline
std::vector<std::string> split( const std::string& str, char ch = ' ')
{
std::vector<std::string> result;
std::stringstream ss(str);
std::string a;
while(std::getline(ss,a, ch))
{
if(a.size())
result.push_back(a);
}
return result;
}


int main()
{
std::string a = "    aaaaaa     asdasdasd ";
std::cout<<strip(a) <<std::endl;
std::vector<std::string> vec_a =  split(a);
std::copy(vec_a.begin(), vec_a.end(), std::ostream_iterator<std::string>(std::cout,"\n"));

std::string removeLeadingZeros(std::string str)
{
return str.erase(0, std::min(str.find_first_not_of('0'), str.size() - 1));
}

}*/



// TODO: reference additional headers your program requires here
