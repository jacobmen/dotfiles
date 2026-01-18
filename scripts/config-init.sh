#! /usr/bin/env bash
git clone --bare git@github.com:jacobmen/dotfiles.git "$HOME/.dotfiles"
git clone git@github.com:tmux-plugins/tpm.git ~/.tmux/plugins/tpm

function config {
   git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}

mkdir -p .dotfiles-backup

if config checkout; then
    echo "Checked out dotfiles"
else
    echo "Moving existing dotfiles to ~/.dotfiles-backup"
    config checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} mv {} .dotfiles-backup/{}
fi

config checkout
config config status.showUntrackedFiles no

config submodule init
config submodule update

