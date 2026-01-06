Generate a complete, executable `install.sh` script and an `update.sh` script for managing dotfiles on macOS using Git and GNU Stow. The setup should allow a new MacBook to run a single curl command to install prerequisites (Homebrew, Git, Stow, Oh My Zsh, NVM), clone the dotfiles repo from GitHub, and symlink configurations using Stow. Organize the repo in `~/dotfiles` with package directories like `zsh/`, `git/`, `nvm/`, etc., containing files like `.zshrc`, `.gitconfig`.

For device-specific overrides, use the Simple Approach: In shared config files (e.g., `.zshrc` in `zsh/`), include a check to source a local override file if it exists, like:

if [ -f ~/.zshrc.local ]; then

    source ~/.zshrc.local

fi

The `.zshrc.local` (or similar) is created manually on each device and not stored in the repo, allowing per-device customizations like env vars or aliases.

The curl command should be: bash -c "$(curl -fsSL https://raw.githubusercontent.com/aj-brown/dotfiles/main/install.sh)"

Include error handling, machine detection via hostname (but only for basic use), and instructions in a README.md. Also, provide the `update.sh` for pulling changes and restowing on existing devices.

Ensure scripts are bash-compatible, idempotent where possible, and handle PATH updates for Homebrew/NVM.