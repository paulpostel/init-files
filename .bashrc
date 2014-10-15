# $Id: .bashrc 313 2014-02-06 02:14:16Z paul $
# ~/.bashrc: executed by bash(1) for non-login shells
[[ ! -z "$debug_bash_startup" ]]        && echo ".bashrc start"

# If not running interactively, don't do anything
[[ -z "$PS1" ]] && return

export PS1='[\h:\u][\W] \# \$ '
PATH=$HOME/bin:$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

export EDITOR=vi


export HISTTIMEFORMAT="%a %T "  # timestamp history list
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

export VISUAL=vi

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
alias cur="cd $RENT_HOME"
alias +cur="pushd $RENT_HOME"
alias +='pushd'
alias +2='pushd +2'
alias +3='pushd +3'
alias +4='pushd +4'
alias +5='pushd +5'
alias -- -='popd'
alias -- -2='popd +2'
alias -- -3='popd +3'
alias -- -4='popd +4'
alias -- -5='popd +5'

# misc
alias shortname='hostname -s'
alias sswap='/usr/etc/pstat -s'
alias h='history'
alias hg='history | grep'

# csh help
alias rehash='hash -r'

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

# svn
alias sstat='svn status -u'
alias sprops="svn propset svn:keywords 'Date Author Revision Id'"
alias svndiff='svn diff --diff-cmd diff -x -w'

alias hivedebug='hive -hiveconf hive.root.logger=INFO,console'
alias hfs='sudo -u hdfs hadoop fs'

# window-related stuff
alias initvt='echo c'
alias lspager='less --RAW-CONTROL-CHARS --quit-if-one-screen --no-init'
lf()           { env CLICOLOR_FORCE=1 \ls  -GFC $@ | lspager; }
laf()          { env CLICOLOR_FORCE=1 \ls -GAFC $@ | lspager; }
lt()           { env CLICOLOR_FORCE=1 \ls -Glt $@ | lspager; }
lat()          { env CLICOLOR_FORCE=1 \ls -GlAt $@ | lspager; }
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

#better prompt
#PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME%%.*}:${PWD/#$HOME/~}"; echo -ne "\007"'

labeltab `shortname`

export rvm_scripts_path=~/.rvm/scripts
if [ -f ~/.rvm/scripts/rvm ]; then
    source ~/.rvm/scripts/rvm
fi

[ ! -z "$debug_bash_startup" ]          && echo ".bashrc end"
