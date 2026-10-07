#
# ~/.bash_profile
#

[[ -f ~/.local/scripts/sethostname ]] && ~/.local/scripts/sethostname

[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -f $HOME/.cargo/env ]] && . "$HOME/.cargo/env"
