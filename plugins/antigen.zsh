# Antigen bootstrap and plugin loader
# Loads desired plugins; can leverage the Oh My Zsh framework via Antigen.

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
antigen use oh-my-zsh

# ssh-agent plugin configuration (set before loading the plugin)
zstyle :omz:plugins:ssh-agent ssh-add-args --apple-load-keychain
zstyle :omz:plugins:ssh-agent quiet yes

# Define plugin list
_antigen_plugins=(
  "ohmyzsh/ohmyzsh plugins/git"
  "ohmyzsh/ohmyzsh plugins/z"
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

# Theme (explicit repo to avoid resolution ambiguity)
if [ -n "$MZSH_ANTIGEN_DEBUG" ]; then
  echo "[mzsh][antigen] theming: ohmyzsh/ohmyzsh simple"
fi
if ! antigen theme ohmyzsh/ohmyzsh simple; then
  echo "[mzsh][antigen] theme load failed: ohmyzsh/ohmyzsh simple" >&2
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
  for _p in "${_antigen_plugins[@]}"; do
    antigen bundle $_p
  done
  # Apply changes (initializes compinit)
  antigen apply
fi
