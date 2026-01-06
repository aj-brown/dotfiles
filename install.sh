#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
REPO_URL="https://github.com/aj-brown/dotfiles.git"

echo "Detecting operating system..."

OS="$(uname -s)"
case "$OS" in
    Darwin)
        PLATFORM="macos"
        ;;
    Linux)
        if [[ -f /etc/os-release ]]; then
            . /etc/os-release
            if [[ "$ID" == "ubuntu" || "$ID_LIKE" == *"ubuntu"* || "$ID_LIKE" == *"debian"* || "$ID" == "debian" ]]; then
                PLATFORM="ubuntu"
            else
                echo "Unsupported Linux distribution: $ID"
                exit 1
            fi
        else
            echo "Cannot detect Linux distribution"
            exit 1
        fi
        ;;
    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

echo "Platform detected: $PLATFORM"

# Install prerequisites
if [[ "$PLATFORM" == "macos" ]]; then
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    echo "Installing git and stow via Homebrew..."
    brew install git stow || true
fi

if [[ "$PLATFORM" == "ubuntu" ]]; then
    echo "Updating apt and installing git, stow, zsh, curl..."
    sudo apt update
    sudo apt install -y git stow zsh curl
fi

# Install Oh My Zsh (idempotent)
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
else
    echo "Oh My Zsh already installed"
fi

# Install NVM (idempotent)
if [[ ! -d "$HOME/.nvm" ]]; then
    echo "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
else
    echo "NVM already installed"
fi

# Clone dotfiles repo
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "Cloning dotfiles repository..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
else
    echo "Dotfiles directory already exists"
fi

cd "$DOTFILES_DIR"

# Stow all packages (add/remove package names as you create them)
echo "Stowing dotfiles packages..."
stow zsh
stow git
# stow nvm   # optional - only if you manage nvm-related files via stow
# add more: stow vim, stow tmux, etc.

echo ""
echo "Installation complete!"
echo "Please restart your terminal or run: source ~/.zshrc"
echo "For device-specific overrides, create ~/.zshrc.local manually."