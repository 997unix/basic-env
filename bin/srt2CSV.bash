#!/bin/bash
cat <&0|
   egrep -v '^$' |
   perl -pe 's/\Z/;/xsm;' |
   paste - - - |
   perl -pe '$. % 10 or print "----\n"'
