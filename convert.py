#!/usr/bin/env python

""" Usage: convert.py [options] [snippet file] [output directory]

converts a snippets emu file into a nerd snippets compatible dir

Options:

  --version             show program's version number and exit
  -h, --help            show this help message and exit
  -d, --dry-run         just display the converted snippets
"""

import re
import os.path
from optparse import OptionParser
options = {}

class Coverter:

    st = '<+';
    et = '+>';

    class Snippet:

        def __init__(self, line):
            matches = re.compile(r'exec "Snippet (\S+) (.*)').findall(line)[0]
            self.name = matches[0]
            self.body = matches[1]

    def __init__(self, file, dir):
        self.snippets = []
        self.file = file
        self.dir = dir

    def scan(self):
        f = open(self.file, 'r')
        [self.snippets.append(self.Snippet(l.strip())) \
                for l in f.readlines() if l.strip() and l.startswith('exec')]
        f.close()

    def fix(self, snippet):
        fixed = re.compile(r'("?\.st\.et\.?"?)').sub(self.st + self.et, snippet)
        fixed = re.compile(r'("?\.st\."?)').sub(self.st, fixed)
        fixed = re.compile(r'("?\.et\."?)').sub(self.et, fixed)
        fixed = fixed.replace('\\"', '"')
        fixed = fixed.replace('\\$', '$')
        return fixed.replace('<CR>', '\n')

    def save(self):
        for snippet in self.snippets:
            body = self.fix(snippet.body)
            if options['dry']:
                print "\n%s\n===\n%s\n===" % (snippet.name, body)
            else:
                file = open(os.path.join(self.dir, snippet.name + '.snippet'), 'w')
                file.write(body)
                file.write("\n")
                file.close()
        print "Converted %d snippets." % len(self.snippets)

def main():
    parser = OptionParser(usage="%prog [snippet file] [output directory]", version="0.1",
            description="converts a snippets emu snippet file over for nerd snippets")
    parser.add_option('-d', '--dry-run', dest='dry',
            help='just display the converted snippets', action="store_const",
            const=1)

    DEFAULTS = { 'dry': 0 }
    parser.set_defaults(**DEFAULTS)
    (option_obj, args) = parser.parse_args()

    options['dry'] = option_obj.dry

    if len(args) < 2:
        parser.error("too few arguments")

    if not os.path.exists(args[0]):
        parser.error("snippet file doesn't exist")

    if not os.path.exists(args[1]):
        parser.error("output directory doesn't exist")

    converter = Coverter(args[0], args[1])
    converter.scan()
    converter.save()

if __name__ == "__main__":
    main()
