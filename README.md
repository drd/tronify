Tronify
=======

A GUI app to run your tronbots. The commercial potential is huge, but you know, I'm just giving this one back to the community.

Running
-------

Compile/build with XCode. Open a legitimate map file (.txt) and then choose Player 1 and Player 2. Click the Go button. Watch in amazement.

TODO
----
- fix the timer loop, it's not really doing the right thing yet
- implement pause and reset
- fix the countless bugs that are sure to exist in this hastily hacked out prototype
- etc

DONE
----
+ make non-compiled bots work
+ don't load non-existent map if the user hits cancel
+ add live window resizing of the maps
+ fix the way the players array is stupid: argh, NSArray. 
	+ create SNNullTronBot subclass to pre-populate players array
+ don't forget to switch players 1 & 2 when sending them the map!
+ display prior moves in the players own colors


eric AT roundpegdesigns DOT com 
