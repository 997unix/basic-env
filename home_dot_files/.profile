shopt -s  cdspell checkwinsize
set -ao emacs
LOGIN="$LOGNAME"

set -o emacs
set -o allexport
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

HISTFILE="$ENV/env/$UNAME.sh_hist"

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
fi

MANPATH=/usr/share/man:/usr/lib/perl5/man:/usr/local/man:/usr/local/lib/perl5/man:/usr/local/LessTif/doc/man:/usr/man:/var/qmail/man:/usr/X11R6/man:/usr/lib/perl5/5.00502:$HOME/share/man
CC=gcc

RSYNC_RSH=$(type -path ssh)
export RSYNC_RSH

export MOZILLA_NO_ASYNC_DNS=True

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
