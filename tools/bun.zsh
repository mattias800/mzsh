# Bun runtime setup
# - If installed via official installer, BUN_INSTALL defaults to ~/.bun and PATH is updated
# - If installed via Homebrew, bun is already on PATH; this still works harmlessly
# - Load completions if the generated file exists

# Default Bun install dir for official installer
export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"

# Prepend Bun bin to PATH if present
if [ -d "$BUN_INSTALL/bin" ]; then
  case ":$PATH:" in
    *":$BUN_INSTALL/bin:"*) :;;
    *) export PATH="$BUN_INSTALL/bin:$PATH";;
  esac
fi

# Completions from official installer
if [ -s "$BUN_INSTALL/_bun" ]; then
  source "$BUN_INSTALL/_bun"
fi
