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
if [ -f /opt/homebrew/share/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh ]; then
  source /opt/homebrew/share/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh
fi
