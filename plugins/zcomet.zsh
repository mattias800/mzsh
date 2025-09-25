# zcomet bootstrap and plugin loader
# Ensures zcomet is installed and loads desired plugins (preferring native repos; falling back to OMZ snippets when needed).

# Where to install zcomet
ZCOMET_HOME=${ZCOMET_HOME:-$HOME/.zcomet}

# Install or repair zcomet if missing
if [ ! -f "$ZCOMET_HOME/zcomet.zsh" ]; then
  if [ -d "$ZCOMET_HOME/.git" ]; then
    git -C "$ZCOMET_HOME" fetch --prune --quiet || true
    git -C "$ZCOMET_HOME" pull --ff-only || true
  else
    rm -rf "$ZCOMET_HOME" 2>/dev/null || true
    mkdir -p "$ZCOMET_HOME"
    git clone --depth=1 https://github.com/agkozak/zcomet "$ZCOMET_HOME"
  fi
fi

# Load zcomet
[ -f "$ZCOMET_HOME/zcomet.zsh" ] && source "$ZCOMET_HOME/zcomet.zsh" || {
  echo "[mzsh] Failed to load zcomet from $ZCOMET_HOME" >&2
}

# Initialize completion (independent of OMZ)
autoload -Uz compinit
# Use cached compinit for speed; create cache dir if needed
ZSH_COMPDUMP_DIR=${ZSH_COMPDUMP_DIR:-$HOME/.zcompdump}
compinit -C -d "$ZSH_COMPDUMP_DIR"

# Preferred non-OMZ plugins
# Note: autosuggestions and syntax-highlighting are handled in plugins/extra.zsh
# Use fzf-tab for powerful completion UI if available
zcomet load Aloxaf/fzf-tab

# Fallback to OMZ plugin snippets when no first-class alternative is in use
# Keep: git/docker/docker-compose/dotnet/dotenv/gh from OMZ
zcomet load ohmyzsh/ohmyzsh plugins/git
zcomet load ohmyzsh/ohmyzsh plugins/docker
zcomet load ohmyzsh/ohmyzsh plugins/docker-compose
zcomet load ohmyzsh/ohmyzsh plugins/dotnet
zcomet load ohmyzsh/ohmyzsh plugins/dotenv
zcomet load ohmyzsh/ohmyzsh plugins/gh

# eza and fzf are not loaded via OMZ: eza aliases live in aliases/eza.zsh; fzf keybinds are handled elsewhere if desired.
