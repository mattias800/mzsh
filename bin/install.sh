#!/usr/bin/env bash
set -euo pipefail

# mzsh bootstrap installer (macOS)
# - Clones or updates the repo to ~/.mzsh (or $MZSH_DIR if set)
# - Ensures Homebrew is installed and on PATH (installs automatically if missing)
# - Installs all dependencies (e.g., eza, bat, fzf, etc.)
# - Appends source line to ~/.zshrc if missing

REPO_URL="https://github.com/mattias800/mzsh"
TARBALL_URL="https://codeload.github.com/mattias800/mzsh/tar.gz/refs/heads/main"
REPO_DIR="${MZSH_DIR:-$HOME/.mzsh}"

log() { printf "[mzsh] %s\n" "$*"; }
err() { printf "[mzsh] ERROR: %s\n" "$*" >&2; }

# Ensure destination dir exists
mkdir -p "$REPO_DIR"

# Fetch or update repo
if command -v git >/dev/null 2>&1; then
  if [ -d "$REPO_DIR/.git" ]; then
    log "Repo exists; updating (fast-forward if possible)"
    git -C "$REPO_DIR" fetch --prune --quiet || true
    if git -C "$REPO_DIR" rev-parse --verify --quiet main >/dev/null; then
      git -C "$REPO_DIR" pull --ff-only --quiet || log "Non-FF; leaving as-is"
    fi
  else
    log "Cloning $REPO_URL to $REPO_DIR"
    git clone "$REPO_URL" "$REPO_DIR"
  fi
else
  # Fallback: download tarball and extract
  if ! command -v curl >/dev/null 2>&1; then
    err "curl not found; please install git or curl and retry"
    exit 1
  fi
  TMPDIR="$(mktemp -d)"
  log "Downloading tarball"
  curl -fsSL "$TARBALL_URL" -o "$TMPDIR/mzsh.tar.gz"
  log "Extracting to $REPO_DIR"
  tar -xzf "$TMPDIR/mzsh.tar.gz" -C "$TMPDIR"
  SRC_DIR="$(find "$TMPDIR" -maxdepth 1 -type d -name "mzsh-*" | head -n1)"
  if [ -z "$SRC_DIR" ]; then
    err "Failed to locate extracted directory"
    exit 1
  fi
  (cd "$SRC_DIR" && tar -cf - .) | (cd "$REPO_DIR" && tar -xf -)
  rm -rf "$TMPDIR"
fi

# Ensure Homebrew exists and is on PATH
ensure_brew() {
  # Detect Homebrew even if it's not on PATH yet
  local brew_bin=""
  if command -v brew >/dev/null 2>&1; then
    brew_bin="$(command -v brew)"
  elif [ -x /opt/homebrew/bin/brew ]; then
    brew_bin=/opt/homebrew/bin/brew
  elif [ -x /usr/local/bin/brew ]; then
    brew_bin=/usr/local/bin/brew
  fi

  # If we found brew already installed, initialize environment and persist, then return
  if [ -n "$brew_bin" ]; then
    # shellenv for current session
    eval "$(${brew_bin} shellenv)" || true
    # Persist shellenv in ~/.zprofile if not already present
    local ZPROFILE="$HOME/.zprofile"
    local SHELLENV_LINE="eval \"\$(${brew_bin} shellenv)\""
    if [ ! -f "$ZPROFILE" ] || ! grep -Fq "$SHELLENV_LINE" "$ZPROFILE"; then
      log "Appending Homebrew shellenv to ~/.zprofile"
      printf "\n%s\n" "$SHELLENV_LINE" >> "$ZPROFILE"
    fi
    return 0
  fi

  # Otherwise install Homebrew non-interactively
  log "Homebrew not found; installing (non-interactive)"
  NONINTERACTIVE=1 /bin/bash -c "$(/usr/bin/curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || true

  # Re-detect brew after install
  if [ -x /opt/homebrew/bin/brew ]; then
    brew_bin=/opt/homebrew/bin/brew
  elif [ -x /usr/local/bin/brew ]; then
    brew_bin=/usr/local/bin/brew
  else
    brew_bin="$(command -v brew || true)"
  fi
  if [ -z "${brew_bin}" ]; then
    err "Homebrew installation appears to have failed (brew not found)."
    exit 1
  fi

  # shellenv for current session
  eval "$(${brew_bin} shellenv)" || true

  # Persist shellenv in ~/.zprofile if not already present
  local ZPROFILE="$HOME/.zprofile"
  local SHELLENV_LINE="eval \"\$(${brew_bin} shellenv)\""
  if [ ! -f "$ZPROFILE" ] || ! grep -Fq "$SHELLENV_LINE" "$ZPROFILE"; then
    log "Appending Homebrew shellenv to ~/.zprofile"
    printf "\n%s\n" "$SHELLENV_LINE" >> "$ZPROFILE"
  fi
}

ensure_brew

# Work around stale/removed taps that can break first-run brew update
brew_sanitize_taps() {
  # Remove deprecated cask-drivers tap if present (old Homebrew setups)
  if brew tap | grep -q '^homebrew/homebrew-cask-drivers$'; then
    log "Untapping deprecated tap homebrew/homebrew-cask-drivers"
    brew untap homebrew/homebrew-cask-drivers || true
  fi
  if brew tap | grep -q '^homebrew/cask-drivers$'; then
    log "Untapping deprecated tap homebrew/cask-drivers"
    brew untap homebrew/cask-drivers || true
  fi
}

brew_sanitize_taps || true
# Try a quiet update to settle taps; ignore failures (brew bundle will proceed)
brew update --force --quiet || true

# Install/update dependencies (includes eza)
if [ -x "$REPO_DIR/bin/mzsh-install-deps" ]; then
  log "Installing/updating dependencies"
  "$REPO_DIR/bin/mzsh-install-deps"
else
  err "Installer not found at $REPO_DIR/bin/mzsh-install-deps"
  exit 1
fi

# Offer to remove Oh My Zsh if present (mzsh uses Antigen instead)
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo
  echo "[mzsh] Detected an existing Oh My Zsh installation at ~/.oh-my-zsh."
  echo "[mzsh] mzsh uses Antigen to manage plugins and does not require Oh My Zsh."
  read -r -p "[mzsh] Do you want to remove Oh My Zsh now? [y/N]: " _mzsh_resp || _mzsh_resp=""
  case "${_mzsh_resp}" in
    [yY]|[yY][eE][sS])
      if [ -x "$HOME/.oh-my-zsh/tools/uninstall.sh" ]; then
        echo "[mzsh] Running Oh My Zsh uninstaller..."
        ZSH="$HOME/.oh-my-zsh" sh "$HOME/.oh-my-zsh/tools/uninstall.sh" || true
      else
        echo "[mzsh] Uninstaller not found; removing ~/.oh-my-zsh directory"
        rm -rf "$HOME/.oh-my-zsh"
      fi
      ;;
    *)
      echo "[mzsh] Keeping existing Oh My Zsh installation. You can remove it later with:"
      echo "       ZSH=\"$HOME/.oh-my-zsh\" sh \"$HOME/.oh-my-zsh/tools/uninstall.sh\""
      ;;
  esac
fi

# Ensure source line in ~/.zshrc
SRC_LINE="source \"$REPO_DIR/init.zsh\""
ZSHRC="$HOME/.zshrc"
if [ -f "$ZSHRC" ] && grep -qF "$SRC_LINE" "$ZSHRC"; then
  log "Source line already present in ~/.zshrc"
else
  log "Adding source line to ~/.zshrc"
  printf "\n%s\n" "$SRC_LINE" >> "$ZSHRC"
fi

log "Done. Restart your terminal or run: exec zsh"
