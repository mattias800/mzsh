# Autosuggestions and syntax highlighting (Homebrew paths assumed)
# zsh-autosuggestions must be sourced before zsh-syntax-highlighting.
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Disable underline highlight style if available
if (( ${+ZSH_HIGHLIGHT_STYLES} )); then
  :
else
  typeset -A ZSH_HIGHLIGHT_STYLES
fi
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Interactive cd (fzf-powered)
# Prefer vendor path under ~/.local/share; fallback to Homebrew if present
if [ -f "$HOME/.local/share/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh" ]; then
  source "$HOME/.local/share/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh"
elif [ -f /opt/homebrew/share/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh ]; then
  source /opt/homebrew/share/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh
fi

# Atuin history (if installed)
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi

# Initialize z (directory jumping) if provided by Homebrew
if [ -f /opt/homebrew/etc/profile.d/z.sh ]; then
  . /opt/homebrew/etc/profile.d/z.sh
fi
