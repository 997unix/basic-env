#!/usr/bin/perl
# Author: Tony Hansmann
#
for (0..20) {

  printf("%.0f:", (rand  3) +1 );
  printf("%02.0f ", (rand  60) );
  printf("%.0f\n", (rand  2) );
}

