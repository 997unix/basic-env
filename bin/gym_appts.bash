#!/bin/bash
for i in Mon Wed Sat
 do  for j in 0 1 2 3 4
 do echo -n "$i: "
 gdate -d "$i + $j weeks" +%F
 done
 done | pcut -f 2,1 -d : -o |sort |
 perl -ne 'chomp;
 $six="6PM";
 $ten="10AM";
 /Mon|Wed/ and print "$_ $six\n";
 /Sat/ and print "$_ $ten\n---\n";'

