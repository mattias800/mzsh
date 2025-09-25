# zcomet bootstrap and plugin loader
# Ensures zcomet is installed and loads desired plugins (including OMZ plugins without OMZ).

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

# Load OMZ library bits if needed by plugins (minimal set)
# You can add more libs if a plugin complains; most work without extra libs.
# zcomet light ohmyzsh/ohmyzsh path:lib/functions.zsh
# zcomet light ohmyzsh/ohmyzsh path:lib/git.zsh

# Load plugins (OMZ plugins loaded directly from repo)
zcomet load ohmyzsh/ohmyzsh plugins/git
zcomet load ohmyzsh/ohmyzsh plugins/docker
zcomet load ohmyzsh/ohmyzsh plugins/docker-compose
zcomet load ohmyzsh/ohmyzsh plugins/fzf
zcomet load ohmyzsh/ohmyzsh plugins/dotnet
zcomet load ohmyzsh/ohmyzsh plugins/dotenv
zcomet load ohmyzsh/ohmyzsh plugins/eza
zcomet load ohmyzsh/ohmyzsh plugins/gh

# You can add more plugins below using either GitHub repo names or URL specs, e.g.:
# zcomet load zsh-users/zsh-autosuggestions
# zcomet load zsh-users/zsh-syntax-highlighting
