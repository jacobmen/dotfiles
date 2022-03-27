# Setup fzf
# ---------
if [[ ! "$PATH" == */home/jacob/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/jacob/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/jacob/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/jacob/.fzf/shell/key-bindings.zsh"
