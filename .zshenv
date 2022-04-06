export XDG_CONFIG_HOME="$HOME/.config"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export HISTFILE="$ZDOTDIR/.zhistory"
export HISTSIZE=10000
export SAVEHIST=10000

export EDITOR="nvim"
export VISUAL="nvim"

# Haskell environment
[ -f "/home/jacob/.ghcup/env" ] && source "/home/jacob/.ghcup/env"
[ -d "/home/jacob/.cargo/bin" ] && export PATH="$PATH:/home/jacob/.cargo/bin"
# export PATH=$PATH:/home/jacob/.cargo/bin
