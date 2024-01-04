# need to load before compinit (https://github.com/agkozak/zsh-z#installation)
source $ZDOTDIR/zsh-z.plugin.zsh
zstyle ':completion:*' menu select

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

autoload -U compinit; compinit

fpath+=$ZDOTDIR/pure
export PATH=~/.local/bin:$PATH
zstyle :prompt:pure:path color cyan
autoload -U promptinit; promptinit
prompt pure

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# enable vim mode
bindkey -v
export KEYTIMEOUT=1
autoload -Uz edit-command-line
zle -N edit-command-line
# v in normal mode to edit in nvim
bindkey -M vicmd v edit-command-line

# C-e and C-a in insert mode
bindkey -e

source $ZDOTDIR/aliases
source $ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZDOTDIR/zsh-autosuggestions/zsh-autosuggestions.zsh

source $ZDOTDIR/.fzf.zsh
# Override default preview options after sourcing fzf
export FZF_CTRL_T_OPTS="--preview='bat --color=always {}' --height=100% --bind shift-up:preview-page-up,shift-down:preview-page-down"

source $ZDOTDIR/LS_COLORS/lscolors.sh

# Haskell
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"
# Rust
[ -d "$HOME/.cargo/bin" ] && export PATH="$PATH:$HOME/.cargo/bin"

# Autostart tmux (https://unix.stackexchange.com/a/113768)
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi
