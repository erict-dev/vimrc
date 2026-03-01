# Dotfiles

Terminal configuration for macOS: Vim, tmux, zsh, and iTerm2.

## What's Included

- `.vimrc`: Vim config with vim-plug, CoC.nvim language server, NERDTree, onedark theme
- `.tmux.conf`: tmux with mouse support, vi keys, splits in current path
- `.zshrc`: zsh with NVM, autosuggestions, syntax highlighting
- `iterm2/Default.json`: iTerm2 dynamic profile (JetBrains Mono Nerd Font, fullscreen, auto-tmux)
- `setup.sh`: Bootstrap script for new machines
- `vim-tips`: Personal vim cheatsheet

## New Machine Setup

### 1. Install Homebrew

If you don't have it yet (the setup script handles this too, but doing it first lets you use `git`):

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Clone this repo

```sh
git clone https://github.com/ericwenn/vimrc.git ~/workspace/vimrc
cd ~/workspace/vimrc
```

### 3. Run the setup script

```sh
chmod +x setup.sh
./setup.sh
```

This will:
- Install brew packages (vim, tmux, the_silver_searcher, zsh-autosuggestions, zsh-syntax-highlighting, JetBrains Mono Nerd Font)
- Install NVM via the official install script
- Symlink `.vimrc`, `.tmux.conf`, and `.zshrc` to your home directory (backs up any existing files to `.bak`)
- Copy the iTerm2 dynamic profile to `~/Library/Application Support/iTerm2/DynamicProfiles/`

### 4. Restart your terminal

Close and reopen iTerm2 so `.zshrc` and the iTerm2 profile take effect.

### 5. Install Vim plugins

Open Vim and run:

```
:PlugInstall
```

### 6. Install CoC language servers

Still in Vim, run:

```
:CocInstall coc-pyright coc-tsserver coc-json coc-html coc-css coc-eslint coc-prettier
```

### 7. Set up secrets and local config

Create `~/.zshrc.local` for API keys and machine-specific settings (this file is gitignored):

```sh
# Example ~/.zshrc.local
export ANTHROPIC_API_KEY=sk-ant-...
export OPENAI_API_KEY=sk-proj-...
```

### 8. Install a Node.js version

```sh
nvm install --lts
```

### 9. Select the iTerm2 profile

The dynamic profile should load automatically. If it doesn't, go to iTerm2 Preferences > Profiles and select "Default". Set JetBrains Mono Nerd Font as the font if it isn't already picked up.
