# mzsh

Modular Zsh configuration for macOS. Clone, source `init.zsh` from your local `~/.zshrc`, and you're set.

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
- zsh-interactive-cd
- bat

Oh My Zsh plugins enabled by default in this config:
- docker, docker-compose, fzf, dotnet, dotenv, eza, gh, git, jump, autojump
Note: These plugins expect the corresponding tools to be installed (except dotenv). Install whichever you use; others will simply be inactive if the tool is missing.


## Notes
- Mac defaults like commented examples from stock ~/.zshrc are omitted.
