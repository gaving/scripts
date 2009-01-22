#!/usr/bin/env python

# usage: ./lyrics.py "Frank Sinatra" "New York"

import sys
import mpdclient2
from SOAPpy import WSDL
from optparse import OptionParser

parser = OptionParser(usage="%prog artist title", version="0.1",
                      description="Grab Lyrics")
options, args = parser.parse_args()

proxy = WSDL.Proxy('http://lyricwiki.org/server.php?wsdl')

if len(args) < 2:
    track = mpdclient2.connect().currentsong()
    artist = track['artist']
    title = track['title']
else:
    artist = sys.argv[1]
    title = sys.argv[2]

if proxy.checkSongExists(artist, title):
    info = proxy.getSong(artist, title)
    print info['lyrics']
else:
    print "No song found :("

# vim:set shiftwidth=4 tabstop=4 expandtab textwidth=79:
