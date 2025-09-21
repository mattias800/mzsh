# Convenience alias to update mzsh repo and dependencies
alias mzsh-update="$HOME/.mzsh/bin/mzsh-update"

# Expose the mzsh helper CLI
if [ -x "$HOME/.mzsh/bin/mzsh" ]; then
  alias mzsh="$HOME/.mzsh/bin/mzsh"
fi
