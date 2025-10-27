# Entry point for modular mzsh

# Resolve base directory of this file (zsh-specific)
BASE_DIR=${0:A:h}

# Ensure mzsh bin directory is on PATH (relocatable)
case ":$PATH:" in
  *":$BASE_DIR/bin:"*) ;;
  *) export PATH="$BASE_DIR/bin:$PATH" ;;
 esac

# 1) Antigen plugin manager
[ -f "$BASE_DIR/plugins/antigen.zsh" ] && source "$BASE_DIR/plugins/antigen.zsh"

# 2) Tools
for f in "$BASE_DIR/tools"/*.zsh; do [ -f "$f" ] && source "$f"; done
[ -f "$BASE_DIR/tools/macos.zsh" ] && source "$BASE_DIR/tools/macos.zsh"

# 3) Plugins (autosuggestions, syntax highlighting)
[ -f "$BASE_DIR/plugins/extra.zsh" ] && source "$BASE_DIR/plugins/extra.zsh"

# 4) Aliases
for f in "$BASE_DIR/aliases"/*.zsh; do [ -f "$f" ] && source "$f"; done

# 5) Local machine overrides (ignored by git)
[ -f "$BASE_DIR/local.zsh" ] && source "$BASE_DIR/local.zsh"

# 6) Private configuration synced with 1Password
[ -f "$HOME/.privaterc" ] && source "$HOME/.privaterc"
