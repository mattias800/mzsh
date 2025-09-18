# mzsh

Modular Zsh configuration for macOS. Clone, source `init.zsh` from your local `~/.zshrc`, and you're set.

## Prerequisites

- macOS with Zsh (5.8+). macOS includes Zsh by default.
- Homebrew (required for dependency installation):
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```
- Oh My Zsh (required for the OMZ plugins used here):
  ```bash
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ```
- curl (built-in on macOS)
- git (optional; the installer will install it via Homebrew if missing)

## Quick start

```bash
curl -fsSL https://raw.githubusercontent.com/mattias800/mzsh/main/bin/install.sh | bash
```

Note: The config is relocatable. `init.zsh` sources all modules relative to its own path, so you can clone it anywhere; just adjust the source line accordingly. PATH for tools is expected to be handled by each tool’s installer.

## Manual installation

1) Clone (recommended location):
   git clone https://github.com/mattias800/mzsh.git "$HOME/.mzsh"

2) Source from your local ~/.zshrc (append once):
   echo 'source "$HOME/.mzsh/init.zsh"' >> "$HOME/.zshrc"

3) Restart your terminal.

## Updating

After pulling new changes, you can update dependencies and the repo safely with:

```
mzsh-update
```

This command will:
- Clone ~/.mzsh if missing (respects $MZSH_DIR if set)
- Refuse to overwrite local changes
- Fast-forward pull the current branch (or main)
- Re-run the dependency installer

## Guide

This section lists what this repo adds: aliases, functions, scripts, tools enabled, and OMZ plugins with examples.

Aliases
- ls => eza -al (if eza is installed)
  - Bypass: command ls or /bin/ls
- cat => bat --paging=never --style=plain (if bat is installed)
  - Bypass: command cat or /bin/cat
- Docker Compose helpers
  - dcdu     # docker compose down && docker compose up --build
  - dcdua    # docker compose down && docker compose --profile all up --build
  - dcua     # docker compose --profile all up --build
- Git cleanup
  - gitprunelocal  # fetch/prune and delete local branches with gone upstream

Functions
- gswi (Git Switch Interactive)
  - gswi                  # fuzzy-pick local/remote branch with preview; switches or creates tracking branch
  - Requires: fzf

Scripts
- ~/.mzsh/bin/mzsh-install-deps
  - Installs recommended tools via Homebrew
- ~/.mzsh/bin/mzsh-update
  - Fast-forward pulls the repo and re-runs the installer (safe: refuses if you have local changes)

Tools (enabled/configured)
- eza (ls replacement)
  - eza -la --git         # long listing incl. git columns
  - eza -T                # tree view
- bat (cat replacement)
  - bat -n file.txt       # show line numbers
- yazi (terminal file manager)
  - yazi                  # launch in current dir; q to quit
- fzf (fuzzy finder)
  - fzf --preview 'bat --style=plain --color=always {} | head -200'
- Atuin (shell history)
  - Ctrl-r                # fuzzy search history (provided by Atuin)
- z (frecent directory jumper)
  - z project             # jump to a frequently used directory matching "project"

Oh My Zsh plugins (enabled by default)
- git: adds many aliases
  - Examples: gst (git status), gco (git checkout/switch), gl (git pull), gb (git branch), gaa (git add --all), gcam (git commit -am)
  - More: gcm (git commit -m), gpo (git push origin), gpf (git push --force-with-lease)
- docker, docker-compose: convenience aliases and completions for Docker and Compose
  - Examples: dps (docker ps), dcu (docker-compose up), dcd (docker-compose down), dcb (docker-compose build), dclf (docker container logs -f)
  - Tip: list available aliases with: alias | grep '^d' | sort
- gh: completions and helpers for GitHub CLI
  - Examples: gh repo view, gh pr status, gh pr create -w, gh issue list
- dotenv: helpers for .env workflows (use with care in untrusted repos)
  - Example: dotenv export > /dev/null && <command>  # load .env vars for a single command
- dotnet: completions and helpers for the dotnet CLI
  - Examples: dotnet new, dotnet build, dotnet test
- fzf: integrates fzf with zsh where available
  - Example: fc -rl 1 | fzf  # browse history (Atuin provides Ctrl-r too)
- eza: additional aliases for eza
  - Examples: l (eza -la), lt (eza -T)
- jump, z: directory jumping helpers (install the tool you prefer)
  - z examples: z src, z -l, z -r pattern
  - jump examples (optional, requires `brew install jump`):
    - j proj         # jump to a directory matching "proj"
    - j --stat       # show database stats
    - j --purge      # remove non-existing paths from the db

## Structure
- init.zsh                # Entry point that sources modules below
- plugins/omz.zsh         # oh-my-zsh bootstrap (no theme)
- plugins/extra.zsh       # autosuggestions and syntax highlighting
- aliases/docker.zsh      # docker-compose helpers
- aliases/git.zsh         # git maintenance helpers
- tools/node.zsh          # Node helpers (e.g., types alias)
- tools/git.zsh           # Git helpers (fzf-powered branch switcher)
- local.zsh               # Optional machine-local tweaks (ignored)

## Dependencies
You can install recommended dependencies automatically:

    ~/.mzsh/bin/mzsh-install-deps

This installs via Homebrew:
- git
- zsh-autosuggestions
- zsh-syntax-highlighting
- fzf
- bat
- eza
- yazi
- atuin
- z
- git-delta
- htop
- pstree
- jq

Notes:
- z: initialized automatically if Homebrew’s /opt/homebrew/etc/profile.d/z.sh is present.
- atuin: initialized automatically at shell startup.

Installed as an Oh My Zsh custom plugin (cloned into $ZSH_CUSTOM/plugins):
- zsh-interactive-cd

Oh My Zsh plugins enabled by default in this config:
- docker, docker-compose, fzf, dotnet, dotenv, eza, gh, git, jump, z
Note: These plugins expect the corresponding tools to be installed (except dotenv). Install whichever you use; others will simply be inactive if the tool is missing.

- jump, z: Directory jumping helpers. Install the tools (jump, z) you prefer; unused plugins remain inactive.


## Notes
- Mac defaults like commented examples from stock ~/.zshrc are omitted.
