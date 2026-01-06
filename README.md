# aj-brown's Dotfiles

My personal dotfiles for macOS, managed with GNU Stow.

## Installation

To set up a new MacBook, run the following command in your terminal:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/aj-brown/dotfiles/main/install.sh)"
```

This script will:
1. Install **Homebrew** (if not present).
2. Install **Git** and **GNU Stow**.
3. Clone this repository to `~/dotfiles`.
4. Install **Oh My Zsh**.
5. Install **NVM**.
6. Symlink configurations using `stow`.
7. Create a `~/.zshrc.local` for device-specific overrides.

## Structure

The repository is organized into package directories:

- `zsh/`: Zsh configuration (`.zshrc`).
- `git/`: Git configuration (`.gitconfig`).
- `install.sh`: Setup script.
- `update.sh`: Script to pull changes and refresh symlinks.

## Customization

For device-specific overrides (like environment variables or aliases), use the `~/.zshrc.local` file. This file is sourced by `.zshrc` but is not tracked by Git.

Example `~/.zshrc.local`:
```bash
export GITHUB_TOKEN="your_token_here"
alias work-server="ssh user@work-ip"
```

## Updating

To update your dotfiles and refresh symlinks on an existing machine, run:

```bash
~/dotfiles/update.sh
```
