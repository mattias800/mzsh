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
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi
  log "Homebrew not found; installing (non-interactive)"
  NONINTERACTIVE=1 /bin/bash -c "$(/usr/bin/curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Detect brew binary path (Apple Silicon vs Intel)
  local brew_bin=""
  if [ -x /opt/homebrew/bin/brew ]; then
    brew_bin=/opt/homebrew/bin/brew
  elif [ -x /usr/local/bin/brew ]; then
    brew_bin=/usr/local/bin/brew
  else
    brew_bin="$(command -v brew || true)"
  fi
  if [ -z "${brew_bin}" ]; then
    err "Homebrew installation appears to have failed (brew not found on PATH)."
    exit 1
  fi

  # shellenv for current session
  eval "$(${brew_bin} shellenv)"

  # Persist shellenv in ~/.zprofile if not already present
  local ZPROFILE="$HOME/.zprofile"
  local SHELLENV_LINE="eval \"\$(${brew_bin} shellenv)\""
  if [ ! -f "$ZPROFILE" ] || ! grep -Fq "$SHELLENV_LINE" "$ZPROFILE"; then
    log "Appending Homebrew shellenv to ~/.zprofile"
    printf "\n%s\n" "$SHELLENV_LINE" >> "$ZPROFILE"
  fi
}

ensure_brew

# Install/update dependencies (includes eza)
if [ -x "$REPO_DIR/bin/mzsh-install-deps" ]; then
  log "Installing/updating dependencies"
  "$REPO_DIR/bin/mzsh-install-deps"
else
  err "Installer not found at $REPO_DIR/bin/mzsh-install-deps"
  exit 1
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
