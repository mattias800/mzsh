# Neovim helpers

# Quick neovim shortcuts
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias nv='nvim'

# Open neovim with a specific file in a specific line
function nvl() {
  local file="$1"
  local line="${2:-1}"
  nvim "+$line" "$file"
}
