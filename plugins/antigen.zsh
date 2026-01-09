# Antigen bootstrap and plugin loader
# Loads desired plugins; can leverage the Oh My Zsh framework via Antigen.
#
# If experiencing plugin load failures, clear antigen caches:
#   rm -rf ~/.antigen/bundles ~/.antigen/init.zsh ~/.antigen/*.zwc ~/.zcompdump*

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

# Use the Oh My Zsh framework (fetched by Antigen; does not require ~/.oh-my-zsh)
export ZSH_DISABLE_COMPFIX="true"
export ZSH_COMPDUMP="${ZSH_COMPDUMP:-$HOME/.zcompdump}"
antigen use oh-my-zsh

# ssh-agent plugin configuration (set before loading the plugin)
zstyle :omz:plugins:ssh-agent ssh-add-args --apple-load-keychain
zstyle :omz:plugins:ssh-agent quiet yes

# Define plugin list
_antigen_plugins=(
  "ohmyzsh/ohmyzsh plugins/git"
  "ohmyzsh/ohmyzsh plugins/fzf"
  "ohmyzsh/ohmyzsh plugins/extract"
  "ohmyzsh/ohmyzsh plugins/completions"
  "ohmyzsh/ohmyzsh plugins/yarn"
  "ohmyzsh/ohmyzsh plugins/ssh-agent"
  "zsh-users/zsh-autosuggestions"
  "zsh-users/zsh-syntax-highlighting"
  "zsh-users/zsh-completions"
)

# gibo completion (via Homebrew-installed completion if present)
if [ -d /opt/homebrew/share/zsh/site-functions ] || [ -d /usr/local/share/zsh/site-functions ]; then
  fpath+=(/opt/homebrew/share/zsh/site-functions /usr/local/share/zsh/site-functions)
fi

# Theme
if [ -n "$MZSH_ANTIGEN_DEBUG" ]; then
  echo "[mzsh][antigen] theming: simple"
  if antigen theme simple; then
    antigen apply
    echo "[mzsh][antigen] theme loaded: simple"
  else
    echo "[mzsh][antigen] theme load failed: simple" >&2
  fi
else
  antigen theme simple
fi

# Bundle and apply
if [ -n "$MZSH_ANTIGEN_DEBUG" ]; then
  for _p in "${_antigen_plugins[@]}"; do
    echo "[mzsh][antigen] bundling: $_p"
    if antigen bundle $_p; then
      antigen apply
      echo "[mzsh][antigen] loaded: $_p"
    else
      echo "[mzsh][antigen] failed: $_p" >&2
    fi
  done
else
  # Use sequential apply by default to surface exact failing plugin and avoid batch-apply quirks
  for _p in "${_antigen_plugins[@]}"; do
    antigen bundle $_p
  done
  antigen apply
fi
