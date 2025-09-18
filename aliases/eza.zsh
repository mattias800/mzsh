# Prefer eza with -al by default if available
# Add 'lt' tree alias with limited depth to avoid heavy disk I/O
if command -v eza >/dev/null 2>&1; then
  # Default ls -> eza long listing (show all)
  alias ls="eza -al"

  # Depth-limited tree view. Users can override depth via $MZSH_LT_LEVEL.
  # Example: MZSH_LT_LEVEL=3 lt src
  alias lt="eza -T --level=${MZSH_LT_LEVEL:-2}"
fi
