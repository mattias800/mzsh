#!/usr/bin/env bash
# Reusable function to check for and optionally remove oh-my-zsh installation
# Call: remove_ohmyzsh_if_exists

# Clean up Oh My Zsh references from ~/.zshrc after uninstallation
cleanup_zshrc_omz_references() {
  local zshrc="$HOME/.zshrc"
  
  if [ ! -f "$zshrc" ]; then
    return 0
  fi
  
  # Check if there are any OMZ references to clean up
  if ! grep -q -E '(export ZSH=|source.*oh-my-zsh\.sh|^ZSH_THEME=|^plugins=)' "$zshrc"; then
    return 0
  fi
  
  # Create a timestamped backup
  local backup="${zshrc}.backup-omz-removal-$(date +%s)"
  cp "$zshrc" "$backup"
  echo "[mzsh] Created backup at $backup"
  
  echo "[mzsh] Cleaning up Oh My Zsh references from ~/.zshrc..."
  
  # Use sed to remove OMZ-specific lines:
  # 1. Lines exporting ZSH variable pointing to ~/.oh-my-zsh
  # 2. Lines sourcing oh-my-zsh.sh (with/without quotes)
  # 3. Lines setting ZSH_THEME (Antigen manages themes independently)
  # 4. Lines defining plugins (Oh My Zsh plugin arrays)
  sed -i.tmp \
    -e '/^export ZSH[[:space:]]*=/d' \
    -e '/^source[[:space:]]*.*oh-my-zsh\.sh/d' \
    -e '/^ZSH_THEME[[:space:]]*=/d' \
    -e '/^plugins[[:space:]]*=/,/^)/d' \
    "$zshrc"
  
  # Clean up sed's temporary backup
  rm -f "${zshrc}.tmp"
  
  echo "[mzsh] Cleanup complete. Backup saved to $backup"
}

remove_ohmyzsh_if_exists() {
  local omz_dir="$HOME/.oh-my-zsh"
  
  # Check if oh-my-zsh is installed
  if [ ! -d "$omz_dir" ]; then
    return 0
  fi
  
  echo
  echo "[mzsh] Detected an existing Oh My Zsh installation at ~/.oh-my-zsh."
  echo "[mzsh] mzsh uses Antigen to manage plugins and does not require Oh My Zsh."
  
  # Prompt user for confirmation (only if interactive terminal available)
  if [ -r /dev/tty ]; then
    read -r -p "[mzsh] Do you want to remove Oh My Zsh now? [y/N]: " _mzsh_resp </dev/tty || _mzsh_resp=""
  else
    echo "[mzsh] Non-interactive install detected (no /dev/tty). Skipping OMZ removal prompt."
    echo "       To remove OMZ later, run:"
    echo "       ZSH=\"$omz_dir\" sh \"$omz_dir/tools/uninstall.sh\""
    _mzsh_resp=""
  fi
  
  # Handle user response
  case "${_mzsh_resp}" in
    [yY]|[yY][eE][sS])
      if [ -x "$omz_dir/tools/uninstall.sh" ]; then
        echo "[mzsh] Running Oh My Zsh uninstaller..."
        ZSH="$omz_dir" sh "$omz_dir/tools/uninstall.sh" || true
      else
        echo "[mzsh] Uninstaller not found; removing ~/.oh-my-zsh directory"
        rm -rf "$omz_dir"
      fi
      
      # After successful removal, clean up .zshrc references
      if [ ! -d "$omz_dir" ]; then
        cleanup_zshrc_omz_references
      fi
      ;;
    *)
      echo "[mzsh] Keeping existing Oh My Zsh installation. You can remove it later with:"
      echo "       ZSH=\"$omz_dir\" sh \"$omz_dir/tools/uninstall.sh\""
      ;;
  esac
}
