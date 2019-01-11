using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Base64CSharp
{
    using BitString = List<int>;
    using Entry = Tuple<int, char>;
    using Dict = List<Tuple<int, char>>;

    public class Base64
    {

        Dict dict;

        public Base64()
        {
            dict = CreateDictionary();
        }

        Dict CreateDictionary()
        {
            string str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
            dict = new Dict();
            for (int i = 0; i < str.Length; i++)
            {
                dict.Add(new Entry(i, str[i]));
            }
            return dict;
        }

        public Char this[int i]
        {
            get { return dict.ElementAt(i).Item2; }
        }

        public Dict GetDict
        {
            get { return dict; }
        }

        public int DictLenght
        {
            get { return dict.Count; }
        }

        public static string ListToString<T>(List<T> list, char separator = ',')
        {
            StringBuilder strbuilder = new StringBuilder();
            strbuilder.Append('[');
            foreach (T item in list)
            {
                strbuilder.Append(item).Append(separator);
            }
            strbuilder.Length--;
            strbuilder.Append(']');
            return strbuilder.ToString();
        }

        public static BitString StringToIntList(string str)
        {
            BitString bits = new BitString();
            foreach (var item in str)
            {
                bits.Add((int)Char.GetNumericValue(item));
            }
            return bits;
        }


        public static string pad(string side, char fillerChar, int n, string inputStr)
        {
            if (side == "right")
                return inputStr.PadRight(n, fillerChar);
            if (side == "left")
                return inputStr.PadLeft(n, fillerChar);
            return null;
        }

        public static BitString toBitString(int number)
        {
            if (number == 0)
                return new BitString();
            BitString bits = new BitString();
            String binary = Convert.ToString(number, 2);
            foreach (char item in binary)
            {
                bits.Add((int)Char.GetNumericValue(item));
            }
            return bits;
        }

        public static int fromBitString(BitString bits)
        {
            if (bits.Count == 0)
                return 0;
            string tempStr = "";
            foreach (int item in bits)
            {
                tempStr += item;
            }
            return Convert.ToInt32(tempStr, 2);
        }

        public static BitString toBinary(string str)
        {
            BitString bits = new BitString();
            foreach (char item in str)
            {
                BitString a = toBitString(item);
                while (a.Count < 8)
                    a.Insert(0, 0);
                bits.AddRange(a);
            }
            return bits;
        }

        public static List<List<T>> chunksOf<T>(int n, List<T> elemList)
        {
            List<List<T>> chunks = new List<List<T>>();
            for (int i = 0; i < elemList.Count; i+=n)
            {
                chunks.Add(elemList.GetRange(i, Math.Min(n, elemList.Count - i)));
            }
            return chunks;
        }

        public static char findChar(Dict dict, BitString bits)
        {
            int a = fromBitString(bits);
            foreach(var pair in dict)
            {
                if (a == pair.Item1)
                    return pair.Item2;
            }
            return '\0';
        }

        public static string translate(Dict dict, string str)
        {
            BitString temp = toBinary(str);
            string temp1 = null;
            List<BitString> chunkz;
            if (temp.Count % 6 != 0)
            {
                string e = string.Join("", temp);
                temp1 = pad("right", '0', e.Length + 6 - (temp.Count % 6), e);
                chunkz = chunksOf(6, StringToIntList(temp1));
            }
            else
            {
                chunkz = chunksOf(6, temp);
            }
            
            string retStr = "";
            foreach (BitString item in chunkz)
            {
                retStr += findChar(dict, item);
            }
            
            return retStr;

        }

        public static string encode(Dict dict, string str)
        {
            string retStr = Base64.translate(dict, str);
            if (retStr.Length%4 != 0)
            {
                retStr = pad("right", '=', retStr.Length + 4 - (retStr.Length%4), retStr);
            }
            return retStr;
        }

        public static BitString findCode(Dict dict, char c)
        {
            foreach (var item in dict)
            {
                if (item.Item2 == c)
                    return toBitString(item.Item1);
            }
            return null;
        }

        public static BitString padTo6(BitString bits)
        {
            while (bits.Count % 6 != 0 || bits.Count == 0)
                bits.Insert(0, 0);
            return bits;
        }

        public static string decode(Dict dict, string str)
        {
            while (str.EndsWith("="))
                str = str.Substring(0, str.Length - 1);

            BitString bits = new BitString();

            foreach (char item in str)
            {
                bits.AddRange(padTo6(findCode(dict, item)));
            }
            List<BitString> chunks = chunksOf(8, bits);
            string outStr = "";
            foreach (BitString item in chunks)
            {
                outStr += (char)fromBitString(item);
            }
            if (outStr.EndsWith("\0"))
                outStr = outStr.Substring(0, outStr.Length - 1);
            return outStr;
        }
    }
}
