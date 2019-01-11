#!/usr/bin/python3

import sys
import os.path
import time

__author__ = 'Imre'


def dictionary():
    str = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    collection = []
    for x in range(len(str)):
        collection.append((x, str[x]))
    return collection


def pad(oldal, kiegeszito, n, szoveg):
    if oldal == 'right':
        return szoveg.rjust(n, kiegeszito)
    if oldal == 'left':
        return szoveg.ljust(n, kiegeszito)


def toBitString(number):
    return [int(x) for x in list("{0:08b}".format(number))]


def fromBitString(bitstring):
    return int(''.join(str(x) for x in bitstring), 2)


def toBinary(str):
    binaryText = []
    binaryList = [toBitString(ord(x)) for x in list(str)]
    for x in binaryList:
        binaryText += x
    return binaryText


def chunksOf(n, lista):
    return [lista[i:i + n] for i in range(0, len(lista), n)]


def findChar(dictionary, bitstring):
    a = fromBitString(bitstring)
    for (x, y) in dictionary:
        if x == a:
            return y
    print("No such entry")


def traslate(dictonary, string):
    temp = toBinary(string)
    if len(temp) % 6 != 0:
        e = ''.join(str(x) for x in temp)
        temp = pad("left", '0', len(e) + 6 - (len(temp) % 6), e)
    return ''.join(str(x) for x in [findChar(dictonary, i) for i in chunksOf(6, list(temp))])


def endcode(dictt, string):
    a = traslate(dictt, string)
    leng = len(a)
    if leng % 4 != 0:
        a = pad("left", '=', leng + 4 - (leng % 4), a)
    return a


def findCode(dictt, karakter):
    for (x, y) in dictt:
        if y == karakter:
            return "{0:06b}".format(x)


def decode(dictt, string):
    while string.endswith('='):
        string = string[:-1]
    binaryText = []
    for x in [findCode(dictt, x) for x in list(string)]:
        binaryText += x
    a = [fromBitString(x) for x in chunksOf(8, ''.join(str(x) for x in binaryText))]
    while a[-1] == 0:
        a = a[:-1]
    return ''.join(str(x) for x in [chr(int(x)) for x in a])


def main():
    start_time = time.clock()
    if len(sys.argv) == 2:
        if sys.argv[1] == "-help":
            print("python base64.py -e inputFile [outputfile]   || ASCII->Base64")
            print("python base64.py -d inputFile [outputfile]   || Base64->ASCII")
            sys.exit()
        if sys.argv[1] == "-version" :
            print("version 1.1.2")
            sys.exit()
        if sys.argv[1] == "-credits" :
            print("Szecsodi \"FrostGhost\" Imre - 2015 - 2016")
            sys.exit()
    if len(sys.argv) == 3 or len(sys.argv) == 4:
        inputfile = os.path.join(os.path.dirname(os.path.abspath(sys.argv[0])), sys.argv[2])
        if os.path.isfile(inputfile):
            if len(sys.argv) == 4:
                output = os.path.join(os.path.dirname(os.path.abspath(sys.argv[0])), sys.argv[3])
            else:
                mode = 'encoded' if sys.argv[1] == "-e" else 'decoded'
                output = os.path.join(os.path.dirname(os.path.abspath(sys.argv[0])), mode)
            infile = open(inputfile, 'r')
            outfile = open(output, 'w')
            frag = False
            if sys.argv[1] == "-d":
                temp = infile.read().splitlines()
                for line in temp:
                    if line == '':
                        outfile.write('\n')
                        continue
                    try:
                        outfile.write(decode(dictionary(), line))
                    except:
                        print("Error, rossz a decodolando file, biztos Base64 a formatuma?")
                print("Decode completed")
                frag = True
            elif sys.argv[1] == "-e":
                buffersize = 50000
                temp = infile.read(buffersize)
                while len(temp):
                    tempint = 0
                    outtext = endcode(dictionary(), temp)
                    for c in outtext:
                        tempint+=1
                        if tempint == 76:
                            outfile.write(c)
                            outfile.write('\n')
                            tempint=0
                        else:
                            outfile.write(c)
                    outfile.write('\n')
                    temp = infile.read(buffersize)
                print("Encode completed")
                frag = True
            else:
                print("Rossz kapcsolo")
            if frag:
                outfile.close()
                infile.close()
                print(format(time.clock() - start_time, '.6f'), "seconds")
                print(output)
        else:
            print("Nem talalhato a megadott file")
    else:
        print("Nem megfelelo az argumentumok szama")
        print("Probalja meg a -help kapcsolot!")


if __name__ == "__main__": main()



# Tesztek
# asd = dictionary()
# print(asd)

# print(pad("left", 'a', 2,"bbb"))

# print(toBitString(10))
# print(fromBitString([1,0,1,0]))
# print(toBinary("SOS"))
# asd = chunksOf(6, list(range(1, 11)))
# print(asd)

# print(findChar(asd,  [0,0,0,1,1,0]))
# print(endcode(asd, "mukodik"))
# print(findCode(asd, 'a'))
