# Homebrew Bundle file for mzsh
# Manage taps, formulae, and casks here.

# Taps
# Homebrew 6.0+ requires third-party taps to be explicitly trusted before it
# will evaluate their Ruby code. `trusted: true` grants that trust at bundle
# time so `brew bundle` runs non-interactively on fresh machines.
# See: https://docs.brew.sh/Tap-Trust
#
# Support multiple .NET SDK versions installed side-by-side
# See: https://github.com/isen-ng/homebrew-dotnet-sdk-versions
tap "isen-ng/dotnet-sdk-versions", trusted: true

# Bun (official tap for compatibility across Homebrew versions)
tap "oven-sh/bun", trusted: true

# Rendered markdown Quick Look plugin (used by the flux-markdown cask below)
tap "xykong/tap", trusted: true

# Formulae
brew "git"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "antigen"
brew "fzf"
brew "bat"
brew "eza"
brew "yazi"
brew "atuin"
brew "git-delta"
brew "htop"
brew "btop"
brew "pstree"
brew "jq"
brew "ffmpeg"
brew "sevenzip"
brew "poppler"
brew "fd"
brew "ripgrep"
brew "zoxide"
brew "resvg"
brew "imagemagick"
brew "gping"
brew "gawk"
brew "tree"
brew "tokei"
brew "node"
brew "oven-sh/bun/bun"
brew "pnpm"
brew "magic-wormhole"
brew "azure-cli"
brew "gh"
brew "docker"
brew "docker-compose"
brew "colima"
brew "tmux"
brew "neovim"
brew "prettierd"

# Casks
# Meta-packages for .NET SDKs; install multiple versions as needed
cask "dotnet-sdk9"
cask "dotnet-sdk10"

# Communication apps
cask "slack"
cask "discord"
cask "warp"

# Utility apps
cask "raycast"                            # launcher - replaces Spotlight (hotkeys disabled by mzsh-disable-macos-shortcuts)
cask "trex"                               # OCR tool - extract text from screenshots
cask "linearmouse"                        # customize mouse behavior - disable acceleration

# Quick Look plugins
cask "quicklook-video"
cask "syntax-highlight"          # syntax highlighting for source code and text files
cask "xykong/tap/flux-markdown"  # rendered markdown Quick Look (tap trusted above)
cask "webpquicklook"
cask "suspicious-package"
cask "quicklook-csv"
