# $Id: .bashrc 313 2014-02-06 02:14:16Z paul $
# ~/.bashrc: executed by bash(1) for non-login shells
#debug_bash_startup=1
[[ ! -z "$debug_bash_startup" ]]        && echo ".bashrc start"

# Source global definitions
if [[ -f /etc/bashrc ]]; then
    . /etc/bashrc
fi

# increase open file limit or idg start complains
ulimit -n 4096

uname=`uname`
if [[ "$uname" == 'Darwin' ]]; then
    OS="OSX"
elif [[ "$uname" == 'Linux' ]]; then
    OS="LINUX"
else
    OS="UNKNOWN"
fi

# If not running interactively, don't do anything
[[ -z "$PS1" ]] && return

export PS1='[\h:\u][\W] \! \$ '

export EDITOR=vim


export HISTTIMEFORMAT="%a %T "  # timestamp history list
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

export VISUAL=vim

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar -- not supported on mac?

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ls
alias lspager='less --RAW-CONTROL-CHARS --quit-if-one-screen --no-init'
alias ls='ls -CF'

alias cls='clear'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# dirs
alias d='dirs'
alias +='pushd'
alias +2='pushd +2'
alias +3='pushd +3'
alias +4='pushd +4'
alias +5='pushd +5'
alias -- -='popd'
alias -- -1='popd +1'
alias -- -2='popd +2'
alias -- -3='popd +3'
alias -- -4='popd +4'
alias -- -5='popd +5'

# misc
alias shortname='hostname -s'
alias h='history'
alias hg='history | grep'
alias be='bundle exec'
alias bu_itunes='rsync -avzh rsync -avzh Music /Volumes/ITUNES/A'
alias bu-itunes='bu_itunes'

# csh help
alias rehash='hash -r'
alias showf='declare -f '

# git

alias restart_nginx='sudo nginx -s stop && sudo nginx'
alias restart-nginx='restart_nginx'

# hosts
chameleon()     { labeltab "Chameleon";ssh chameleon.yasl.net; labeltab `shortname`; }
macdaddy()	{ labeltab "MacDaddy";ssh macdaddy.yasl.net;labeltab `shortname`; }
poppy()	        { labeltab "Poppy";ssh -p 3343 poppy.yasl.net;labeltab `shortname`; }
c1()	        { labeltab "C1";ssh -p 3343 c1.yasl.net;labeltab `shortname`; }
pebble()	{ labeltab "Pebble";ssh pebble.localhost;labeltab `shortname`; }

# Rent hosts
r_www()     { labeltab "www-01";ssh www-01.ppostel.sb.lax1.rent.com; labeltab `shortname`; }
r_oneweb()  { labeltab "oneweb";ssh oneweb-01.ppostel.sb.lax1.rent.com; labeltab `shortname`; }
r_webapp()  { labeltab "webapp";ssh webapp-01.ppostel.sb.lax1.rent.com; labeltab `shortname`; }
r_ruby()  { labeltab "rruby";ssh ppostel.dev.lax.primedia.com; labeltab `shortname`; }

# svn
alias sstat='svn status -u'
alias sprops="svn propset svn:keywords 'Date Author Revision Id'"
alias svndiff='svn diff --diff-cmd diff -x -w'

alias hivedebug='hive -hiveconf hive.root.logger=INFO,console'
alias hfs='sudo -u hdfs hadoop fs'

# window-related stuff
alias initvt='echo c'
alias lspager='less --RAW-CONTROL-CHARS --quit-if-one-screen --no-init'
if [[ "$OS" == 'OSX' ]]; then
    alias lscmd='env CLICOLOR_FORCE=1 \ls'
elif [[ "$OS" == 'LINUX' ]]; then
    alias lscmd='\ls --color=always'
else
    alias lscmd='ls'
fi
lf()           { lscmd  -FC $@ | lspager; }
laf()          { lscmd -AFC $@ | lspager; }
lt()           { lscmd -lt $@ | lspager; }
lat()          { lscmd -lAt $@ | lspager; }
labelicon()    { echo -n "]1;$1"; }
labelwin()     { echo -n "]2;$1"; } # window title only
labeltab()     { echo -n "]0;$1"; } # tab title only

vm() {
    labeltab "$1"
    ssh $1.localhost
    labeltab `shortname`
}

gt() {
    labeltab "$1"
    ssh $1
    labeltab `shortname`
}


labeltab `shortname`

# pickup local/bin/perl first, amongst others
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH
export PERL5LIB=$HOME/perl5/lib

RVM_DIR=~/.rvm
if [[ -x "$RVM_DIR/scripts/rvm" ]]; then
    source $RVM_DIR/scripts/rvm
fi

if [[ -d $RVM_DIR/bin ]]; then
    PATH=$PATH:$RVM_DIR/bin # Add RVM to PATH for scripting
fi

# two possible chruby paths, one for OS X, one for CentOs, sigh.
chruby_path_one=/usr/share/chruby
chruby_path_two=/usr/local/share/chruby
if [[ -f "$chruby_path_one/chruby.sh" ]]; then
    source "$chruby_path_one/chruby.sh"
    source "$chruby_path_one/auto.sh"
elif [[ -f "$chruby_path_two/chruby.sh" ]]; then
    source "$chruby_path_two/chruby.sh"
    source "$chruby_path_two/auto.sh"
fi

if [ -f ~/.idg_profile ]; then
    source ~/.idg_profile
fi

# Automatically guess your WEBROOT from your username:
case "$(hostname)" in
    oneweb-01.$LOGNAME.sb.lax1.rent.com)
        WEBROOT=$HOME/rent-01
        ;;
    webapp-01.$LOGNAME.sb.lax1.rent.com)
        WEBROOT=$HOME/rent-01
        ;;
    www-01.$LOGNAME.sb.lax1.rent.com)
        WEBROOT=$HOME/rent-01
        ;;
    www-01.v-lax-$LOGNAME.rent.com)
        WEBROOT=$HOME/rent-01
        ;;
    www-02.v-lax-$LOGNAME.rent.com)
        WEBROOT=$HOME/rent-02
        ;;
    *)
        WEBROOT=/company
        ;;
esac
 
# Export the important envars
export WEBROOT
export RENT_HOME=$WEBROOT
export ORACLE_HOME=/usr/local/oracle
export PERL5LIB=$WEBROOT/lib${PERL5LIB:+:$PERL5LIB}

# per comments in setup page at;
# http://confluence.rent.com/pages/viewpage.action?pageId=31360544&focusedCommentId=33194758#comment-33194758&src=search
MIGHT_BE_ORACLE_HOME=/usr/lib/oracle/11.2/client64
if [[ -d "$MIGHT_BE_ORACLE_HOME" ]]; then
    export ORACLE_HOME=$MIGHT_BE_ORACLE_HOME
    export PATH=$ORACLE_HOME/bin:$PATH
    if [[ -z "$LD_LIBRARY_PATH" ]]; then
        export LD_LIBRARY_PATH=$ORACLE_HOME/lib
    else
        export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
    fi
    export TNS_ADMIN=/usr/local/oracle/network/admin/
fi
 
# Load the custom .bashrc only if it exists
if [[ -d "$RENT_HOME" ]]; then
    source $RENT_HOME/bin/rent-bashrc
    if [[ -d "$RENT_HOME/local-lib" ]]; then
        source $RENT_HOME/local-lib/bashrc
    fi
    alias +r="pushd $RENT_HOME"
fi
 
 
# Add devweb binaries into the path if it exists
if [[ -d "$RENT_HOME/devweb" ]]; then
    export PATH=$RENT_HOME/devweb/bin:$PATH
fi

# Source local definitions if there are any
if [[ -f ~/.bash_local ]]; then
    . ~/.bash_local
fi

[ ! -z "$debug_bash_startup" ]  && echo ".bashrc end"

