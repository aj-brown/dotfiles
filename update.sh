#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"

if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "Dotfiles directory not found at $DOTFILES_DIR"
    echo "Run install.sh first"
    exit 1
fi

cd "$DOTFILES_DIR"

echo "Pulling latest changes from repository..."
git pull --rebase

echo "Restowing packages to apply updates..."
stow --restow zsh
stow --restow git
# stow --restow nvm
# add others as needed

echo ""
echo "Update complete! Reload your shell: source ~/.zshrc"