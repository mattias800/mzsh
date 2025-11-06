#!/usr/bin/env bash
# Reusable function to check for and optionally remove oh-my-zsh installation
# Call: remove_ohmyzsh_if_exists

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
      ;;
    *)
      echo "[mzsh] Keeping existing Oh My Zsh installation. You can remove it later with:"
      echo "       ZSH=\"$omz_dir\" sh \"$omz_dir/tools/uninstall.sh\""
      ;;
  esac
}
