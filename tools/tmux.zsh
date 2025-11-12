# Tmux helpers

# Quick tmux shortcuts
alias tm='tmux'
alias tma='tmux attach'
alias tmn='tmux new-session -s'
alias tml='tmux list-sessions'
alias tmk='tmux kill-session -t'

# Attach to a session or create if doesn't exist
function tmaa() {
  if [[ $# -eq 0 ]]; then
    tmux attach || tmux new-session
  else
    tmux attach -t "$1" || tmux new-session -s "$1"
  fi
}
