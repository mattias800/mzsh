# Oh My Zsh bootstrap
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

# Merge default plugins into any user-defined plugins (deduplicated)
# Users may set `plugins=(...)` in ~/.zshrc before sourcing mzsh.
# We append missing defaults and uniquify the result prior to loading OMZ.
default_plugins=(
  docker
  docker-compose
  fzf
  dotnet
  dotenv
  eza
  gh
  git
  jump
  autojump
)

if (( ${+plugins} && ${#plugins[@]} > 0 )); then
  typeset -A _mzsh_seen
  for p in "${plugins[@]}"; do _mzsh_seen[$p]=1; done
  for p in "${default_plugins[@]}"; do [[ ${_mzsh_seen[$p]} ]] || plugins+=("$p"); done
  plugins=(${(u)plugins})
else
  plugins=("${default_plugins[@]}")
fi

# Load Oh My Zsh if present
if [ -f "$ZSH/oh-my-zsh.sh" ]; then
  source "$ZSH/oh-my-zsh.sh"
fi
