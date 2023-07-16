import os
import sys
import re

shortWords = []
longWords = []

# with open(sys.argv[1:][0], encoding='cp1252') as f: # For JA as uses windows encoding quotes
with open(sys.argv[1:][0]) as f:
  for line in f.readlines():
    # Get first string on line. If a word has a space then ???
    wordRe = re.search('([^\s]+)\s*', line)
    word = wordRe.group(0)
    # at this point, could do regex for chars and then combine.
    charRe = re.findall('\w', word)
    foundWord = ''.join(charRe)
    print(foundWord)
    if len(foundWord) < 3:
      shortWords.append(foundWord)
    else:
      longWords.append(foundWord.upper().replace("QU", "!"))

outFile = sys.argv[1:][0][:-4] + "-3+.txt"


with open(outFile, 'a') as f:
  for line in longWords:
    f.write(line + "\n")


