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

# OMZ plugins (explicit subpaths to avoid resolution issues)
antigen bundle ohmyzsh/ohmyzsh plugins/git
antigen bundle ohmyzsh/ohmyzsh plugins/z
antigen bundle ohmyzsh/ohmyzsh plugins/fzf
antigen bundle ohmyzsh/ohmyzsh plugins/extract
antigen bundle ohmyzsh/ohmyzsh plugins/completions
antigen bundle ohmyzsh/ohmyzsh plugins/yarn
antigen bundle ohmyzsh/ohmyzsh plugins/ssh-agent

# External/community plugins
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions

# gibo completion (via Homebrew-installed completion if present)
if [ -d /opt/homebrew/share/zsh/site-functions ] || [ -d /usr/local/share/zsh/site-functions ]; then
  fpath+=(/opt/homebrew/share/zsh/site-functions /usr/local/share/zsh/site-functions)
fi

# Theme
antigen theme simple

# Apply changes (initializes compinit)
antigen apply
