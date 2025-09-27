# Antigen bootstrap and plugin loader
# Loads desired plugins without installing Oh My Zsh itself.

# Locate antigen (Homebrew preferred)
if [ -f /opt/homebrew/share/antigen/antigen.zsh ]; then
  source /opt/homebrew/share/antigen/antigen.zsh
elif [ -f /usr/local/share/antigen/antigen.zsh ]; then
  source /usr/local/share/antigen/antigen.zsh
elif [ -f "$HOME/.antigen/antigen.zsh" ]; then
  source "$HOME/.antigen/antigen.zsh"
else
  echo "[mzsh] Antigen not found. Run ~/.mzsh/bin/mzsh-install-deps to install dependencies (Brewfile includes antigen)." >&2
  return 0
fi

# Bundle plugins (prefer first-class repos; use OMZ plugin subpaths where needed)
# Note: For Antigen, specify the subdirectory directly (no "path:" prefix).
antigen bundle Aloxaf/fzf-tab
antigen bundle ohmyzsh/ohmyzsh plugins/git
antigen bundle ohmyzsh/ohmyzsh plugins/docker
antigen bundle ohmyzsh/ohmyzsh plugins/docker-compose
antigen bundle ohmyzsh/ohmyzsh plugins/dotnet
antigen bundle ohmyzsh/ohmyzsh plugins/dotenv
antigen bundle ohmyzsh/ohmyzsh plugins/gh

# Apply changes (initializes compinit)
antigen apply
