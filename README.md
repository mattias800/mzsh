# mzsh

Modular Zsh configuration for macOS. Clone, source `init.zsh` from your local `~/.zshrc`, and you're set.

## Prerequisites

- macOS with Zsh (5.8+). macOS includes Zsh by default.
- Homebrew (required for dependency installation):
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```
- zcomet (plugin manager) is auto-installed by mzsh on first run and ensured by the installer; no manual action needed.
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

## Migration from Oh My Zsh

If you previously used Oh My Zsh, migrate on this machine with:

```
~/.mzsh/bin/migrate-omz-to-zcomet
```

This comments out OMZ lines in ~/.zshrc and ensures mzsh is sourced. zcomet is installed automatically and is ensured by the installer.

Optional flags:
- ~/.mzsh/bin/migrate-omz-to-zcomet --remove-omz  # back up ~/.oh-my-zsh to ~/.oh-my-zsh.bak-<timestamp>
- ~/.mzsh/bin/migrate-omz-to-zcomet --purge-omz   # delete ~/.oh-my-zsh (dangerous)

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

This section lists what this repo adds: aliases, functions, scripts, tools enabled, and plugins (via zcomet) with examples.

Secrets (optional)
- You can pull secrets from a password manager into an ignored local file.
- Nothing secret is committed; values are written to local.zsh (which is .gitignored).
- Supported managers: 1Password (op), Bitwarden (bw), LastPass (lpass), macOS Keychain (security)
  ```bash
  # Install required CLIs via Homebrew
  mzsh secrets install all

  # Check setup and see guidance for sign-in/unlock steps
  mzsh secrets doctor

  # Create an example manifest (edit it to match your vault item names/fields)
  mzsh secrets sample

  # Pull secrets (writes exports into ~/.mzsh/local.zsh managed block)
  mzsh secrets pull

  # Force a specific provider or custom manifest path
  mzsh secrets pull --provider op
  mzsh secrets pull --manifest ~/.config/mzsh/secrets.json
  ```
- Provider setup quick tips:
  - 1Password (op): Run op signin once.
  - Bitwarden (bw): BW_SESSION=$(bw unlock --raw); export BW_SESSION; run bw login first time.
  - LastPass (lpass): lpass login you@example.com; keep session active.
  - Keychain: values pulled with security find-generic-password.
- Manifest format (JSON array), examples:
  ```json
  [
    { "env": "GITHUB_TOKEN", "provider": "op", "item": "GitHub Token", "field": "token" },
    { "env": "NPM_TOKEN",    "provider": "bw", "item": "npm token",    "field": "password" },
    { "env": "FOO_API_KEY",  "provider": "keychain", "service": "foo_api_key", "account": "$USER" },
    { "env": "AWS_PROFILE",  "value": "personal" }
  ]
  ```
- Notes:
  - 1Password: sign in once (op signin) so op item get works.
  - Bitwarden: ensure BW_SESSION is set (bw unlock --raw, then export BW_SESSION=...).
  - LastPass: run lpass login once; keep session active.
  - Keychain: values are retrieved via: security find-generic-password -s <service> -a <account> -w

Aliases
- ls => eza -al (if eza is installed)
  ```bash
  # Bypass
  command ls
  /bin/ls
  ```
- lt => eza -T --level=${MZSH_LT_LEVEL:-2} (tree view with limited depth)
  ```bash
  # Show current directory tree up to 2 levels
  lt
  # Override depth for a single call
  MZSH_LT_LEVEL=3 lt src
  ```
- cat => bat --paging=never --style=plain (if bat is installed)
  ```bash
  # Bypass
  command cat
  /bin/cat
  ```
- Docker Compose helpers
  ```bash
  dcdu      # docker compose down && docker compose up --build
  dcdua     # docker compose down && docker compose --profile all up --build
  dcua      # docker compose --profile all up --build
  ```
- Git cleanup
  ```bash
  gitprunelocal   # fetch/prune and delete local branches with gone upstream
  ```

Functions
- gswi (Git Switch Interactive)
  ```bash
  gswi   # fuzzy-pick local/remote branch with preview; switches or creates tracking branch
  ```
  Requires: fzf

Scripts
- ~/.mzsh/bin/mzsh-install-deps
  ```bash
  ~/.mzsh/bin/mzsh-install-deps
  ```
- ~/.mzsh/bin/mzsh-update
  ```bash
  mzsh-update
  ```
  Fast-forward pulls the repo and re-runs the installer (safe: refuses if you have local changes)

Tools (enabled/configured)
- eza (ls replacement)
  ```bash
  eza -la --git           # long listing incl. git columns
  lt                      # tree view via eza with limited depth (default level=2)
  MZSH_LT_LEVEL=3 lt src  # override depth for a single command
  ```
- bat (cat replacement)
  ```bash
  bat -n file.txt         # show line numbers
  ```
- gping (graphical ping)
  ```bash
  gping 1.1.1.1                   # live latency graph to Cloudflare DNS
  gping --avg google.com          # include rolling average
  gping --rate 0.25 github.com    # ping every 4s to reduce noise
  ```
- yazi (terminal file manager)
  ```bash
  yazi              # launch in current dir; q to quit
  ```
- fzf (fuzzy finder)
  ```bash
  fzf --preview 'bat --style=plain --color=always {} | head -200'
  ```
- Atuin (shell history)
  ```bash
  # Atuin binds Ctrl-r to fuzzy search history by default
  ```
- z (frecent directory jumper)
  ```bash
  z project         # jump to a frequently used directory matching "project"
  ```

Plugins via zcomet (Oh My Zsh plugins loaded without installing OMZ)
- git: adds many aliases
  ```bash
  gst         # git status
  gco main    # git switch/checkout main
  gcm "msg"   # git commit -m "msg"
  gpo         # git push origin
  gpf         # git push --force-with-lease
  ```
- docker, docker-compose: convenience aliases and completions for Docker and Compose
  ```bash
  dps         # docker ps
  dcu         # docker-compose up
  dcd         # docker-compose down
  dcb         # docker-compose build
  dclf        # docker container logs -f
  ```
  Tip: list available aliases with: alias | grep '^d' | sort
- gh: completions and helpers for GitHub CLI
  ```bash
  gh repo view
  gh pr status
  gh pr create -w
  gh issue list
  ```
- dotenv: helpers for .env workflows (use with care in untrusted repos)
  ```bash
  # Prompting is enabled by default; you can choose Always/Never per folder.
  # To force no prompt on your machine, set in ~/.mzsh/local.zsh:
  #   export ZSH_DOTENV_PROMPT=false
  dotenv export > /dev/null && <command>  # load .env vars for a single command
  ```
- dotnet: completions and helpers for the dotnet CLI
  ```bash
  dotnet new
  dotnet build
  dotnet test
  ```
- fzf: integrates fzf with zsh where available
  ```bash
  fc -rl 1 | fzf  # browse history (Atuin provides Ctrl-r too)
  ```
- eza: additional aliases for eza
  ```bash
  l      # eza -la
  lt     # eza -T
  ```
- jump, z: directory jumping helpers (install the tool you prefer)
  ```bash
  # z
  z src
  z -l
  z -r pattern

  # jump (optional; brew install jump)
  j proj
  j --stat
  j --purge
  ```

## Structure
- init.zsh                # Entry point that sources modules below
- plugins/zcomet.zsh      # zcomet bootstrap and plugin loader
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
- gping

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
