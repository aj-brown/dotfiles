#!/bin/bash

# install.sh - Dotfiles installation script for macOS
# This script is idempotent and can be run multiple times.

set -e

DOTFILES_DIR="$HOME/dotfiles"
REPO_URL="https://github.com/aj-brown/dotfiles.git"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

HOSTNAME=$(hostname -s)
echo -e "${BLUE}Installing dotfiles on machine: ${NC}${HOSTNAME}"

echo -e "${BLUE}Starting dotfiles installation...${NC}"

# 1. Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo -e "${BLUE}Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for the current session
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo -e "${GREEN}Homebrew already installed.${NC}"
fi

# 2. Install Git and Stow
echo -e "${BLUE}Installing Git and GNU Stow...${NC}"
brew install git stow

# 3. Clone dotfiles repository
if [ ! -d "$DOTFILES_DIR" ]; then
    echo -e "${BLUE}Cloning dotfiles repository...${NC}"
    git clone "$REPO_URL" "$DOTFILES_DIR"
else
    echo -e "${GREEN}Dotfiles directory already exists at $DOTFILES_DIR.${NC}"
fi

# 4. Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${BLUE}Installing Oh My Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "${GREEN}Oh My Zsh already installed.${NC}"
fi

# 5. Install NVM
if [ ! -d "$HOME/.nvm" ]; then
    echo -e "${BLUE}Installing NVM...${NC}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
else
    echo -e "${GREEN}NVM already installed.${NC}"
fi

# 6. Symlink configurations using Stow
echo -e "${BLUE}Symlinking configurations with Stow...${NC}"
cd "$DOTFILES_DIR"

# List of packages to stow
PACKAGES=(zsh git nvm)

for pkg in "${PACKAGES[@]}"; do
    echo -e "${BLUE}Stowing $pkg...${NC}"
    stow -v -R "$pkg"
done

# 7. Create .zshrc.local if it doesn't exist
if [ ! -f "$HOME/.zshrc.local" ]; then
    echo -e "${BLUE}Creating ~/.zshrc.local...${NC}"
    touch "$HOME/.zshrc.local"
    echo "# Device-specific overrides" >> "$HOME/.zshrc.local"
fi

echo -e "${GREEN}Dotfiles installation complete!${NC}"
echo -e "${BLUE}Please restart your terminal or run 'source ~/.zshrc' to apply changes.${NC}"
