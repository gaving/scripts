#!/usr/bin/env python

import re
import sys
import urllib2
import sgmllib
import random
from optparse import OptionParser

GROUPHUG_URL = 'http://grouphug.us/'

parser = OptionParser(usage="%prog query", version="0.1",
                              description="Grab sob stories from grouphug.us")
options, args = parser.parse_args()

class Stripper(sgmllib.SGMLParser):
    def __init__(self):
        sgmllib.SGMLParser.__init__(self)

    def strip(self, some_html):
        self.theString = ""
        self.feed(some_html)
        self.close()
        return self.theString

    def handle_data(self, data):
        self.theString += data

if len(args) > 0:
    url = GROUPHUG_URL + 'search?q=' + sys.argv[1]
else:
    url = GROUPHUG_URL + 'random'

regex = re.compile(r'<td class="conf-text">(.*?)<\/td>', re.DOTALL)
response = urllib2.urlopen(url)
text = response.read()
matches = regex.findall(text)

random.shuffle(matches)
stripper = Stripper()

if len(matches) > 0:
    print stripper.strip(matches[0]).strip()
else:
    print "I found nothing."

# vim:set shiftwidth=4 tabstop=4 expandtab textwidth=79:
