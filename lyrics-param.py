#!/usr/bin/env python

# usage: ./lyrics.py "Frank Sinatra" "New York"

import sys
from SOAPpy import WSDL
from optparse import OptionParser

parser = OptionParser(usage="%prog artist title", version="0.1",
                      description="Grab Lyrics")
options, args = parser.parse_args()

if len(args) < 2:
    print "error: no parameters"
    sys.exit(1)

proxy = WSDL.Proxy('http://lyricwiki.org/server.php?wsdl')

artist = sys.argv[1]
title = sys.argv[2]

if proxy.checkSongExists(artist, title):
    info = proxy.getSong(artist, title)
    print info['lyrics']
else:
    print "No song found :("

# vim:set shiftwidth=4 tabstop=4 expandtab textwidth=79:
