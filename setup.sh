#!/usr/bin/env bash
# Bootstrap script for setting up a new macOS machine with these dotfiles.
# Run from the repo root: ./setup.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Install Homebrew if missing
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to PATH for the rest of this script
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
fi

# Install packages
echo "Installing brew packages..."
brew install vim tmux the_silver_searcher
brew install zsh-autosuggestions zsh-syntax-highlighting
brew install --cask font-jetbrains-mono-nerd-font

# Install NVM via official script (not brew, to match .zshrc config)
if [ ! -d "$HOME/.nvm" ]; then
  echo "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

# Create symlinks
echo "Creating symlinks..."
for file in .vimrc .tmux.conf .zshrc; do
  target="$HOME/$file"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "  Backing up existing $file to ${file}.bak"
    mv "$target" "${target}.bak"
  fi
  ln -sf "$DOTFILES_DIR/$file" "$target"
  echo "  $file -> $target"
done

# Copy iTerm2 dynamic profile
ITERM_PROFILES_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
mkdir -p "$ITERM_PROFILES_DIR"
cp "$DOTFILES_DIR/iterm2/Default.json" "$ITERM_PROFILES_DIR/Default.json"
echo "  iTerm2 profile copied to DynamicProfiles/"

echo ""
echo "Done! Remaining manual steps:"
echo "  1. Open Vim and run :PlugInstall"
echo "  2. Install CoC servers - :CocInstall coc-pyright coc-tsserver coc-json coc-html coc-css coc-eslint coc-prettier"
echo "  3. Add API keys and secrets to ~/.zshrc.local"
echo "  4. Restart your terminal"
