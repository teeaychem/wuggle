# Wuggle

More-or-less a clone of boggle, written to learn some swift.

Though, after adding some features I wanted, there are at least two ways to play:

1. A large lexicon or many tiles and trying to find as many words as possible.
2. A small lexicon or few tiles and trying to find every word (esp. as tiles  which don't make a new word can be faded).

#### Images

<img src="https://github.com/teeaychem/wuggle/blob/main/images/01.PNG?raw=true" alt="Game screen, partially played, some tiles faded" width="250"/><img src="https://github.com/teeaychem/wuggle/blob/main/images/02.PNG?raw=true" alt="Different game screen, partially played, some tiles faded, word selected, different stats" width="250"/><img src="https://github.com/teeaychem/wuggle/blob/main/images/04.PNG?raw=true" alt="Stats screen" width="250"/><img src="https://github.com/teeaychem/wuggle/blob/main/images/08.PNG?raw=true" alt="Settings screen" width="250"/>

<img src="https://github.com/teeaychem/wuggle/blob/main/images/03.PNG?raw=true" alt="Game over screen, purple colour scheme, many tiles" width="250"/><img src="https://github.com/teeaychem/wuggle/blob/main/images/05.PNG?raw=true" alt="Settings screen, strange colour scheme choice" width="250"/><img src="https://github.com/teeaychem/wuggle/blob/main/images/06.PNG?raw=true" alt="Fresh game, many tiles, bright colour scheme, percent not shown" width="250"/><img src="https://github.com/teeaychem/wuggle/blob/main/images/07.PNG?raw=true" alt="Fresh game, 4 tiles, awful colour scheme" width="250"/>

##### Some nice things

Here are a few of the nice things:

1. A UI made of three different 'cards'.
    - A game card, where playing a game happens.
    - A settings card, where you can choose how much time is available, minimum word length, etc.
    - A statistics card, which stores some statistics related to the current settings chosen.
2. An option to fade tiles which cannot be used to create a new word.
3. Support for using a variety of lexicons.
    For example, the only worlds possible to find are those found in Jane Austen's novels.
    Built in are:
    - The international 3of6 list from 12dicts [wordlist.aspell.net](http://wordlist.aspell.net/12dicts/)
    - Ogden's Basic English [ogden.basic-english.org](http://ogden.basic-english.org/words.html)
    - Jane Austen [Mary Robinette Kowal](https://maryrobinettekowal.com/journal/the-jane-austen-word-list/)
    - Shakespeare [Dubaduba / Wiktionary](https://en.wiktionary.org/wiki/Wiktionary:Frequency_lists/Complete_Shakespeare_wordlist)
    - The King James Bible [Art and the Bible](https://www.artbible.info/concordance/)
4. Support for boards of size n^2, n > 0.
    - Though 8^2 is the built in maximum, and more tiles means more work when figuring out which tiles to fade.

##### Some more nice things

There are also a few things to make playing games pleasant:

1. Games are preserved unless ended by the timer or the user.
    - You can easily switch between searching for every word on a board with infinite time and many short games.
2. You can hold the visible part of the board after a game is over to reshow the board.
    - This is nice for figuring out where a word was.
3. You can switch the horizonal position of the found words list and timer on the game card.
4. Enable or disable showing the percent of words found (mysterious!), and impact (along with fading tiles).
5. Choose different colour schemes (though most were chosen to look bad).


##### Some notable things

Aside from the game mechanics, there are a few notable things:

1. CoreData is used to keep track of almost everything, with a little concurrency sprinkled in at places to mask some waiting.
2. Everything is dynamically generated according to screen size.
    - Font size is the result of a binary search (memoed to the size of it's bounding box) and icons are bézier paths (sometimes specified by hand).
3. I managed to keep working on various UI things, even though I got very bored.

##### Some things I might do

A few things could easily be added:

1. In order to keep track of tiles to fade, data about which tiles can be used to make a word are saved.
These tiles could be shown on the board when holding down on a word displayed on game over.
2. Improved colours (lol).
3. Statistics saving to iCloud, etc.
    - This would be nice as at the moment lost when the application is deleted.
4. A way to view the board associated with a statistic.
    - I'd prefer to do other things for now.
    - Though, on the topic of stats, it would be nice if some stats were updated to be more 'impressive' even if not new.
    For example, %100 is more impressive when 14 words are found rather than 3.
    At the moment, a stat is only recorded the first time it is obtained.
5. In general, more UI polish.
    - The problem is, I need to play and test to figure out what feels good.

Less easy, but on a list:

1. Removing words from a lexicon.
    - Lexicons are stored in a unified trie, and while pruning the trie is easy, I'd need to think about UI for deleting, restoring the original lexicon, etc.
    Do I show a list of words?
    Or, only allow a word to be deleted after it's been on a board?
2. Adding words to a lexicon.
    - Even easier than above, but similar issues.