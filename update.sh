#!/bin/bash

# update.sh - Update dotfiles and refresh symlinks

set -e

DOTFILES_DIR="$HOME/dotfiles"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Updating dotfiles...${NC}"

if [ ! -d "$DOTFILES_DIR" ]; then
    echo -e "${BLUE}Dotfiles directory not found at $DOTFILES_DIR. Please run install.sh first.${NC}"
    exit 1
fi

cd "$DOTFILES_DIR"

# Pull latest changes
echo -e "${BLUE}Pulling latest changes from Git...${NC}"
git pull origin main

# Refresh symlinks
echo -e "${BLUE}Refreshing symlinks with Stow...${NC}"
PACKAGES=(zsh git nvm)

for pkg in "${PACKAGES[@]}"; do
    echo -e "${BLUE}Restowing $pkg...${NC}"
    stow -v -R "$pkg"
done

echo -e "${GREEN}Dotfiles updated successfully!${NC}"
