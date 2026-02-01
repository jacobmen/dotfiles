# zmodload zsh/zprof

zstyle ':completion:*' menu select

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

autoload -U compinit; compinit

fpath+=~/.nix-profile/share/zsh/site-functions
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

source ~/.nix-profile/share/fzf-tab/fzf-tab.plugin.zsh

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 $realpath'
# use tab to toggle selection
zstyle ':fzf-tab:*' fzf-bindings 'tab:toggle'
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
# use tmux pop up window for selection
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

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
