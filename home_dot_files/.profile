shopt -s  cdspell checkwinsize
set -ao emacs
LOGIN="$LOGNAME"
#if [ -s "$MAIL" ]           # This is at Shell startup.  In normal
#then echo "$MAILMSG"        # operation, the Shell checks
#fi                          # periodically.

set -o emacs
set -o allexport
#PS1="`uname -n`> "
#PS2="#huh...> "
#path stuff for me
UNAME=`uname -n`
EDITOR=vim
PAGER="less"

# few things about pathing. this is a path for doingn compiles with the
# stock cc #from solaris. Also the path should only be set in one place
# to avoid confusion.
#KDEDIR=/opt/kde

PATH=$PATH:/usr/local/bin:/bin:/usr/bin:/usr/ccs/bin:$HOME/bin:/var/qmail/bin:/sbin:/usr/common/bin:/usr/openwin/bin:/usr/dt/bin:/usr/local/netscape:/usr/sbin:/usr/X11R6/bin:/home/thansmann/cf/tools/utils

[ $TERM = "screen" ] && TERM=xterm
UNAME=`uname -n`
ARCH=$(uname -a)
if [[ "$ARCH" =~ "Darwin" ]] ; then
  ALT_HOME=$HOME/Dropbox/home/thansmann
  ENV=$ALT_HOME/profile.d/kshrc
  ALS=$ALT_HOME/profile.d/aliases
  #. $ALS
  P=$ALT_HOME/.profile
else 
  ENV=$HOME/profile.d/kshrc
  ALS=$HOME/profile.d/aliases
  P=$HOME/.profile


  # http://www.faqs.org/docs/Linux-mini/Xterm-Title.html
  # get the cool xterm title changing stuff
  PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"' 

  # do the cool thing showing just my CWD w/o a full path
  PS1='${UNAME%%.*}:${PWD##*/}> '
  # makes debugging better
  PS4='(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]}\n'
fi


#LPDEST=hp5simx
HISTFILE="$ENV/env/$UNAME.sh_hist"

# i have removed all refs to $MAIL to avoid the elm 
# behavior of moving mail to a "received" folder, which 
# i really hate. $mail and $m are definded to be the var for
# easy mail access.

# if [ ! -z "$DISPLAY" ]
# then
#   echo "DISPLAY is already set to \"$DISPLAY\""
# 	xrdb -merge ~/.xresources
# elif [  $TERM = aixterm -o $TERM = xterm  ]
# then
#   DISPLAY=192.1.1.74:0.0
#   echo "The DISPLAY has just been set to \"$DISPLAY\""
# else
#   echo "Sorry, I can't figure out where we are "
# #  echo "You will need to set the 'export DISPLAY=' yourself"
#   echo "the most likely place for us is '192.1.1.74:0.0'"
#   printf "enter y to use ayn.ads.com:0.0 -> " 
#   read 
#   [ $REPLY = "y" -o $REPLY = "Y" ] && DISPLAY=192.1.1.74:0.0
    
    
# fi	
  

# Set up pager env vars.
if  [ ! -z "$(type -path less)" ]
then
  export MANPAGER='less'
  export PAGER='less'
    # this is what makes less NOT clear the screen when it exits.
    # added the 'R' so ANSI color stuff comes thru -tony 6/1/30
  export LESS=-igMQXR
  alias more="less"
  alias pg="less"
  alias les="less"
  alias le="less"
else
echo Executing where i shouldnt be in .profile
#   export MANPAGER='pg'
#   export PAGER='pg'
#   alias more="pg"
#   alias less="pg"
fi

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<
#
# findout what type of Xwindows display we are on...
#
#CUR_DISPLAY_VENDOR_STR=`xdpyinfo 2>/dev/null | \
#    /bin/grep "^vendor string"`
#CUR_DISPLAY_VENDOR_STR=`echo "$CUR_DISPLAY_VENDOR_STR" | \
#        (read ven str rest; echo $rest)`
#case "$CUR_DISPLAY_VENDOR_STR" in
#        "Network Computing Devices Inc." ) DPYTYPE="NCD" ;;
#        "Hummingbird Communications Ltd." ) DPYTYPE="HUM" ;;
#        * ) DPYTYPE="UKN" ;;
#esac

# we only need to start the screen saver if we are on 
# an Xterminal. the follow checks to see if we are
# and then, if so, starts xscreensaver.
# Note that the DPYTYPE above will be set to only
# NCD or HUM. this info can be used or expanded as
# needed (like for macs)

#if [ "$DPYTYPE" = "NCD" ]
#then
#  /usr/local/bin/xscreensaver -lock -timeout 10 &
#fi
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<

MANPATH=/usr/share/man:/usr/lib/perl5/man:/usr/local/man:/usr/local/lib/perl5/man:/usr/local/LessTif/doc/man:/usr/man:/var/qmail/man:/usr/X11R6/man:/usr/lib/perl5/5.00502:$HOME/share/man
CC=gcc
#TCL_LIBRARY=/usr/local/lib/tcl7.5

#loading this from an include file now
#LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib:/usr/X11/lib
#LM_LICENSE_FILE=/apps/lang/license_dir/sunpro.lic,1
#XMCD_LIBDIR=/usr/openwin/lib/X11/xmcd



##############################
##########
# Mon Feb 16 15:10:50 1998
#  ORACLE specific things for my profile. 
#	
#	

# umask 022
# ORACLE_BASE=/opt/oracle/u01/app/oracle;export ORACLE_BASE
# ORACLE_TERM=$TERM; export ORACLE_TERM
#ORACLE_SID=PASA; export ORACLE_SID
#TWO_TASK=pasa.quepasa.com
## ORACLE_HOME=/opt/oracle/u01/app/oracle/8.0.3; export ORACLE_HOME
# ORAENV_ASK=NO
#. /opt/bin/oraenv
#export TWO_TASK
# END oracle things.
# 
##########
##############################


# CLASSPATH=/usr/local/java/JDK/lib/classes.zip:/usr/local/java/SWING/beaninfo.jar:/usr/local/java/SWING/motif.jar:/usr/local/java/SWING/multi.jar:/usr/local/java/SWING/swing.jar:/usr/local/java/SWING/swingall.jar:/usr/local/java/SWING/windows.jar:.
#JAVA_HOME=/usr/local/java/JDK
#SWING_HOME=/usr/local/java/SWING
# my special classpath for my build dirs. 

#CLASSPATH=$CLASSPATH:$HOME/src/java/TokenJC:$HOME/src/java/TokenManageJC:$HOME/src/java/adsCallRecordJC:$HOME/src/java/adsCallRecordListJC:$HOME/src/java/adsDelimiterParseJC:$HOME/src/java/adsPartJC:$HOME/src/java/adsPartListJC:$HOME/src/java/htmlPageJC:$HOME/src/java/unenumeratedListJC:$HOME/src/java/toyJTreeJC:$HOME/src/java/oraSwing/ch2:/home/tony/src/java/ALJC:/home/tony/src/java/LSLJC


#CLASSPATH=$CLASSPATH:.:$HOME/src/parthold/java:$HOME/src/java/oraSwing/ch2

RSYNC_RSH=$(type -path ssh)
export RSYNC_RSH

export MOZILLA_NO_ASYNC_DNS=True

#if [ $TERM = "xterm" ]; then
#  export PROMPT_COMMAND='echo -ne \
#  "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#fi

#echo "sourceing kshrc"
# . $HOME/env/kshrc # havent needed this in 10 years

#echo SHELL is $SHELL. I know how to handle ksh and bash
if [ $SHELL = "/usr/bin/ksh" -o $SHELL = "/bin/ksh" ]
    then
	#echo "sourceing  ksh.aliases"
	. $HOME/profile.d/ksh.aliases 
    else
	#echo "sourceing  aliases"
	. $ALS
fi



##############################
##########
#  path cleaner, i hate multiple entries in a path
# 
type -a perl > /dev/null 2>&1 
if [ $? -eq 0 ]
  then
    #echo cleaning PATH var
    PATH=$(echo $PATH | perl -ne 'chomp;
        map {$f{$_}++} split /:/;
	print join(":", keys %f) ."\n";'
     )
fi
export PATH

##############################
##########
#  MAN path cleaner, i hate multiple entries in a path
# 
type -a perl > /dev/null 2>&1 
if [ $? -eq 0 ]
  then
    #echo cleaning MANPATH var
    MANPATH=$(echo $MANPATH | perl -ne 'chomp;
        map {$f{$_}++} split /:/;
	print join(":", keys %f) ."\n";'
     )
fi
export MANPATH

##############################
##########
# 
# @#----------
# Thu Jun  8 14:38:21 2000
# 

export PERLDB_OPTS="inhibit_exit=1 ReadLine=1"
export PRINTER=lp0


# use keychain to manage ssh-keys
KEYCHAIN=`type -p keychain`
if [ ! -z "$KEYCHAIN"  ] ; then
    SSH_KEYCHAIN=$HOME/.keychain/$(uname -n)-sh
    test -f $HOME/.ssh/id_dsa && /usr/bin/keychain -q  $HOME/.ssh/id_dsa
    
    if [ -f $SSH_KEYCHAIN  ]
        then
        source $SSH_KEYCHAIN
    fi
fi


#if [ -d $P ]; then
#  for i in $P/*; do
#    if [ -r $i ]; then
#      . $i
#    fi
#  done
#  unset i
#fi
