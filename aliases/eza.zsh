# Prefer eza with -al by default if available
if command -v eza >/dev/null 2>&1; then
  alias ls="eza -al"
fi
