#
# ~/.bash_profile
#

[[ -f ~/.local/scripts/sethostname ]] && ~/.local/scripts/sethostname

[[ -f ~/.bashrc ]] && . ~/.bashrc
. "$HOME/.cargo/env"
