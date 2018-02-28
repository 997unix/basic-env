#!/usr/bin/perl
# Author: Tony Hansmann
#
# As ugly as a hack gets - but it's pretty gratifiting to setup a
# whole mess of screen sessions (with names!) by cut and paste.

# what you'll need before using this:
# 1] an open screen session set to use ctrl-\ as the attention key.
# 2] A ssh-agent running and loaded with all the keys you'll need to
# login to the boxes. To confirm you have the identities loaded check
# 'ssh-add -l'

# how to use:

# call script with machine list to generate redrirect it to a file
# screen_helper_vm.pl foo01..foo05  tony1..tony4 bax baz bam > ~/tmp/screen_paste

# open the file with xemacs or other editor that cuts-and-pastes control chars.
# (vi doesnt' seem to do the right thing.) highlight the buffer and paste it into your
# xterm and watch your screens get created automatically.


# if we have commandline args treat them like they are perl list defs and expand them
if (@ARGV) {
    for (@ARGV) {
        push @machines, eval ($_);
    }
}
else {
    @machines =  (vm0..vm2, ub0);
}


# $ctrl_backslash = sprintf %c , "\x1c";
# $ctrl_A = '\x01';
# $ctrl_U = '\x15';

foreach $i (@machines)  {
    # 
    # my screen has the attention key as ctrl-\ but stock is ctrl-A which is
    # 'x01'. replace '\x1c' with '\x01' for stock screen attention key. -Tony
    print "\x1c" . "c" . "ssh root\@$i" . "\n" . "\x1c" . "A" . "\cU"  . "$i su -" . "\n";

}

