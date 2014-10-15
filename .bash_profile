# $Id: .bash_profile 272 2013-05-10 20:57:12Z paul $
#debug_bash_startup=1
[[ ! -z "$debug_bash_startup" ]]        && echo ".bash_profile start"
[[ -s "$HOME/.bashrc" ]]                && source "$HOME/.bashrc"
[[ -s "$HOME/.bash_login" ]]            && source "$HOME/.bash_login"
# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]]       && source "$HOME/.rvm/scripts/rvm"

bind Space:magic-space

[[ ! -z "$debug_bash_startup" ]]        && echo ".bash_profile end"
