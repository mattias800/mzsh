gswi() {
  if ! command -v fzf >/dev/null 2>&1; then
    echo "[mzsh] gswi requires fzf. Run ~/.mzsh/bin/mzsh-install-deps to install it." >&2
    return 1
  fi
  git fetch --all --prune --quiet
  local sel local_branch
  sel=$(
    git branch --all --sort=-committerdate --format='%(refname:short)' \
      | grep -vE '^(HEAD|.*/HEAD)$' \
      | awk '!seen[$0]++' \
      | fzf --preview '
          git --no-pager log -n5 --color=always \
              --pretty=format:"%C(yellow)%h%Creset %Cgreen%cr%Creset %C(bold blue)%an%Creset%n    %s%n" {1} \
          && echo "" \
          && git --no-pager show --stat --oneline --color=always {1} | head -n 20
        ' \
        --preview-window=right:70%:wrap
  ) || return
  if git show-ref --verify --quiet "refs/heads/$sel"; then
    git switch "$sel"
    return
  fi
  if git show-ref --verify --quiet "refs/remotes/$sel"; then
    local_branch="${sel#*/}"
    git switch -c "$local_branch" --track "$sel"
    return
  fi
  echo "Not a known local or remote branch: $sel" >&2
  return 1
}
