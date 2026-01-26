# Use zoxide for cd if available
# Only define custom cd function if zoxide is installed
if command -v zoxide >/dev/null 2>&1; then
  # Create a smart cd function that uses zoxide for frecency lookup
  # Falls back to builtin cd if __zoxide_cd is not available (non-interactive shells)
  function cd() {
    # Runtime check: if __zoxide_cd doesn't exist, use builtin cd
    if ! type __zoxide_cd >/dev/null 2>&1; then
      builtin cd "$@"
      return
    fi

    if [[ $# -eq 0 ]]; then
      # cd with no args goes home
      __zoxide_cd ~
    elif [[ $# -eq 1 ]] && [[ ! -d "$1" ]] && [[ "$1" != '-' ]] && [[ ! "$1" =~ ^[-+][0-9]$ ]]; then
      # If argument is not a directory, path, or special cd arg, try zoxide query
      local result
      if result="$(command zoxide query -- "$1" 2>/dev/null)"; then
        __zoxide_cd "${result}"
      else
        __zoxide_cd "$@"
      fi
    else
      # Otherwise use normal cd (handles paths, -, +N, -N)
      __zoxide_cd "$@"
    fi
  }
fi
