# zmodload zsh/zprof

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

# Make cd push the old directory onto the directory stack
setopt AUTO_PUSHD
# Don’t push multiple copies of the same directory onto the directory stack
setopt PUSHD_IGNORE_DUPS
# Do not print the directory stack after pushd or popd
setopt PUSHD_SILENT
# Append commands to the history file right away, rather than waiting for shell to exit
setopt INC_APPEND_HISTORY

# C-e and C-a in insert mode
bindkey -e

source $ZDOTDIR/aliases
source $ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZDOTDIR/zsh-autosuggestions/zsh-autosuggestions.zsh

source $ZDOTDIR/.fzf.zsh
# Override default preview options after sourcing fzf
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview='bat --color=always {}' --height=100% --bind shift-up:preview-page-up,shift-down:preview-page-down"

source $ZDOTDIR/LS_COLORS/lscolors.sh

# Haskell
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"
# Rust
[ -d "$HOME/.cargo/bin" ] && export PATH="$PATH:$HOME/.cargo/bin"
# Bob installs of neovim
[ -d "$HOME/.local/share/bob/nvim-bin" ] && export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"

eval "$(zoxide init zsh)"

# Autostart tmux (https://unix.stackexchange.com/a/113768)
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

# zprof
