# Prefer bat over cat when available
if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never --style=plain'
fi
