# Use zoxide for cd if available
if command -v zoxide >/dev/null 2>&1; then
  alias cd="__zoxide_cd"
fi
