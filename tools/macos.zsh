# macOS Finder helpers

function pfd() {
  osascript 2>/dev/null <<'EOF'
    tell application "Finder"
      return POSIX path of (insertion location as alias)
    end tell
EOF
}

function cdf() {
  cd "$(pfd)"
}

