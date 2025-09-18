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

The tools below are installed or enabled by this config. Here are handy examples to get started.

- eza (ls replacement)
  - ls                      # aliased to: eza -al
  - eza -la --git           # long, all, include git status columns
  - eza -T                  # tree view of current directory
- bat (cat replacement)
  - cat file.txt            # aliased to: bat --paging=never --style=plain file.txt
  - bat -n file.txt         # show line numbers
- yazi (terminal file manager)
  - yazi                    # launch in current directory; q to quit
- fzf (fuzzy finder)
  - fzf --preview 'bat --style=plain --color=always {} | head -200'
  - Note: Shell keybindings/completions are not auto-installed. See: https://github.com/junegunn/fzf#installation
  - gswi                     # fuzzy switch git branches with previews (provided by tools/git.zsh)
- Atuin (shell history)
  - Ctrl-r                  # fuzzy search history (atuin overrides Ctrl-r)
  - atuin login             # optional: set up sync
  - atuin import auto       # optional: import existing history
- z (frecent directory jumper)
  - z project               # jump to directories you've visited matching "project"
  - z -l                    # list ranked matches
  - z -r docs               # remove a path from database that matches docs
- git-delta (better git pager)
  - Optional setup to use delta for diffs and paging:
    git config --global core.pager delta
    git config --global interactive.diffFilter 'delta --color-only'
    git config --global delta.navigate true
    git config --global delta.light false
- htop (interactive process viewer)
  - htop                    # live CPU/mem view; F to filter; / to search; q to quit
  - htop -u "$USER"         # show only your processes
- pstree (process tree)
  - pstree -p -a            # show PIDs and command line
- jq (JSON processor)
  - jq . package.json       # pretty-print JSON
  - curl -s https://api.github.com | jq '.rate_limit'  # filter a field
- fd (find files fast)
  - fd src                  # list files whose path contains "src"
  - fd -e tsx -t f src      # only .tsx files under src
- ripgrep (rg: fast grep)
  - rg "TODO:" -n           # search recursively with line numbers
  - rg -S "exact?case"       # smart case; treat uppercase as case-sensitive
  - rg -g '!node_modules' pattern   # ignore node_modules
- zoxide (alternative jumper; optional)
  - Not auto-initialized by default. To enable, add to local.zsh:
    eval "$(zoxide init zsh)"
  - Then use: z foo (similar to z)
- ffmpeg (media toolbelt)
  - ffmpeg -i in.mp4 -vn -acodec copy out.aac  # extract audio
  - ffmpeg -i in.mov -vf scale=1280:-2 out.mp4 # resize keeping aspect
- ImageMagick (magick)
  - magick convert in.png -resize 50% out.png
  - magick mogrify -format jpg *.png
- Poppler (PDF utils)
  - pdftotext file.pdf out.txt
  - pdftoppm file.pdf page -png   # page-1.png, page-2.png, ...
- 7-Zip (sevenzip)
  - 7zz a archive.7z folder/
  - 7zz x archive.7z

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
