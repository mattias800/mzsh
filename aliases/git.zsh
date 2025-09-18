# Git maintenance helper
# Remove local branches whose upstream is gone
alias gitprunelocal='git fetch -p && for branch in $(git branch -vv | grep ": gone]" | awk "{print \$1}"); do git branch -D "$branch"; done'
