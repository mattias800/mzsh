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

## Guide

Tools
- eza: Modern ls replacement with colors, icons, and git info. With the OMZ eza plugin enabled, common ls commands are aliased to eza. Examples:
  - eza -la         # long, all
  - eza -T          # tree view
  - eza -la --git   # include git status columns
- bat: cat replacement with syntax highlighting. In this config, cat is aliased to bat --paging=never --style=plain if bat is installed. To bypass, run command cat or /bin/cat.
- yazi: A fast terminal file manager. Launch with yazi from any directory; q to quit.
- fzf: Fuzzy finder used by helpers like gswi (see below). Install key bindings/completions separately if desired.
- atuin: Fast, syncable shell history. After install, it's initialized automatically. Use Ctrl-r for fuzzy history search (configurable in Atuin).

Git helper
- gswi: Fuzzy switch to a local or remote branch with preview.
  - Fetches/prunes, lists branches by recent activity, shows recent commits in a preview, then switches.
  - Requires fzf. Run ~/.mzsh/bin/mzsh-install-deps to install it.

Enabled OMZ plugins (high-level)
- docker, docker-compose: Aliases and completions for Docker and Compose.
- fzf: Convenience functions around fzf.
- dotnet: Aliases/completions for the dotnet CLI.
- dotenv: Helpers for working with .env files. Be mindful when auto-loading environment from arbitrary repos.
- eza: Aliases ls to eza variants.
- gh: Aliases/completions for GitHub CLI.
- git: A rich set of git aliases (e.g., gst, gco, gl, gb, gaa, gcam).
- jump, z: Directory jumping helpers. Install the tools (jump, z) you prefer; unused plugins remain inactive.


## Notes
- Mac defaults like commented examples from stock ~/.zshrc are omitted.
