# zsh configuration for macOS

# Aliases
alias ls='ls -G' # colored directories
alias claude-sandbox='docker run -it -p 3000:3000 -e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY claude-sandbox'
alias claude-sandbox-build='~/.claude-sandbox/build.sh'

# NVM (Node Version Manager)
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Detect Homebrew prefix (works on both Apple Silicon and Intel Macs)
BREW_PREFIX="$(brew --prefix 2>/dev/null)"

# zsh-autosuggestions: https://github.com/zsh-users/zsh-autosuggestions
[ -n "$BREW_PREFIX" ] && source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
export TERM=xterm-256color

# zsh-syntax-highlighting: https://github.com/zsh-users/zsh-syntax-highlighting
# Must be at the end of .zshrc (before sourcing .zshrc.local)
[ -n "$BREW_PREFIX" ] && source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Source local overrides (API keys, machine-specific settings)
# Create ~/.zshrc.local for secrets and per-machine config (gitignored)
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
