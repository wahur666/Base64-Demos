using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Base64CSharp
{
   
    class Program
    {
        static void Main(string[] args)
        {
            Base64 base64 = new Base64();
            Console.WriteLine(Base64.ListToString(Base64.toBinary("SOS")));
            Console.WriteLine(Base64.ListToString(new List<string>() { "qwe", "asd", "asd", "qwe"}, ';'));
            Console.WriteLine(Base64.translate(base64.GetDict, "Man"));
            //Console.WriteLine(Base64.decode(base64.GetDict, Base64.encode(base64.GetDict, "Save Our Soul")));
            Console.WriteLine(Base64.decode(base64.GetDict, ""));
            Console.WriteLine("Press any key to exit program. . .");
            Console.ReadKey();
        }

    }

}
