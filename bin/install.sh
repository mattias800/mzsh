#!/usr/bin/env bash
set -euo pipefail

# mzsh bootstrap installer
# - Clones or downloads the repo to ~/.mzsh (or $MZSH_DIR if set)
# - Runs dependency installer
# - Appends source line to ~/.zshrc if missing

REPO_URL="https://github.com/mattias800/mzsh"
TARBALL_URL="https://codeload.github.com/mattias800/mzsh/tar.gz/refs/heads/main"
REPO_DIR="${MZSH_DIR:-$HOME/.mzsh}"

log() { printf "[mzsh] %s\n" "$*"; }
err() { printf "[mzsh] ERROR: %s\n" "$*" >&2; }

# Ensure destination dir exists
mkdir -p "$REPO_DIR"

# Prefer git if available; fallback to tarball
if command -v git >/dev/null 2>&1; then
  if [ -d "$REPO_DIR/.git" ]; then
    log "Repo exists; updating (fast-forward)"
    git -C "$REPO_DIR" fetch --prune --quiet || true
    # Try fast-forward on main; ignore if diverged
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
  # Sync contents (rsync may not be present by default; use tar piping)
  (cd "$SRC_DIR" && tar -cf - .) | (cd "$REPO_DIR" && tar -xf -)
  rm -rf "$TMPDIR"
fi

# Run dependency installer (best-effort)
if [ -x "$REPO_DIR/bin/mzsh-install-deps" ]; then
  log "Installing/updating dependencies"
  "$REPO_DIR/bin/mzsh-install-deps" || true
else
  log "Installer not found at $REPO_DIR/bin/mzsh-install-deps"
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
