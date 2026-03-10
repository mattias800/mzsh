# AGENTS.md - Coding Agent Guide for mzsh

## Project overview

mzsh is a modular Zsh configuration framework for macOS. It replaces Oh My Zsh with a
relocatable, opinionated shell environment built on Antigen, Homebrew, and a curated set
of CLI tools. It is not a library or application -- it is shell configuration that gets
sourced into the user's Zsh session.

## Repository layout

```
init.zsh              # Main entry point -- sourced from ~/.zshrc
local.zsh             # Machine-local overrides (gitignored, never commit)
Brewfile              # Homebrew dependencies (~70 formulae + casks)
secrets.manifest.json # Secrets manifest for credential pulling

bin/                  # Executable commands (bash scripts)
  mzsh                #   Main dispatcher -- routes subcommands to mzsh-* scripts
  mzsh-update         #   Pull repo + refresh deps (fast-forward only)
  mzsh-install-deps   #   Install Homebrew + Brewfile packages
  mzsh-clear-cache    #   Clear antigen/zsh caches and lock files
  mzsh-config         #   JSON config manager (~/.mzsh.json)
  mzsh-secrets        #   Pull credentials from password managers into local.zsh
  mzsh-private        #   Sync ~/.privaterc with 1Password
  mzsh-ssh            #   Add SSH keys to macOS Keychain
  install.sh          #   Bootstrap installer (clone + install deps)

lib/                  # Shared libraries sourced by bin/ scripts
  config.sh           #   config_get/set/delete/list for ~/.mzsh.json (uses jq)
  remove-ohmyzsh.sh   #   Oh My Zsh detection and cleanup

plugins/              # Zsh plugin loading
  antigen.zsh         #   Antigen bootstrap + Oh My Zsh plugin bundles
  extra.zsh           #   Autosuggestions, syntax highlighting, atuin, zoxide

tools/                # Tool integrations (sourced as zsh)
  env.zsh             #   TERM, EDITOR, JetBrains PATH
  git.zsh             #   gswi() fuzzy branch switcher
  node.zsh            #   Node.js helpers
  bun.zsh             #   Bun runtime PATH + completions
  tmux.zsh            #   Tmux aliases and helpers
  neovim.zsh          #   Neovim aliases (v, vim, nv) and nvl()
  macos.zsh           #   Finder integration (pfd, cdf)

aliases/              # Command aliases (sourced as zsh)
  bat.zsh             #   cat -> bat
  eza.zsh             #   ls -> eza
  docker.zsh          #   Docker compose shortcuts
  git.zsh             #   gitprunelocal and other git maintenance
  mzsh.zsh            #   mzsh command shortcuts
  zoxide.zsh          #   Smart cd via zoxide

config/               # Application configs copied during install
  tmux/tmux.conf      #   Tmux config (vim-style nav, 256 colors)
  nvim/               #   Neovim Lua config (lazy.nvim, LSP, Treesitter)
```

## Initialization flow

`init.zsh` is the single entry point, sourced from `~/.zshrc`. It loads modules in this
fixed order:

1. Resolve base directory via `${0:A:h}` (makes it relocatable)
2. Add `bin/` to PATH
3. Initialize zoxide
4. Load Antigen and plugin bundles (`plugins/antigen.zsh`)
5. Source all `tools/*.zsh` files
6. Load extra plugins (`plugins/extra.zsh`)
7. Source all `aliases/*.zsh` files
8. Source `local.zsh` if it exists (machine-local, gitignored)
9. Source `~/.privaterc` if it exists (synced via 1Password)

## Language and shell conventions

- **bin/ scripts**: Bash (`#!/usr/bin/env bash`) with `set -euo pipefail`.
- **Everything else** (init.zsh, tools/, aliases/, plugins/): Zsh, often without a shebang
  since they are sourced, not executed.
- **lib/ scripts**: Bash, sourced by bin/ scripts (not standalone).

### Naming

- Bin commands: `mzsh-<verb>` (e.g., `mzsh-update`, `mzsh-clear-cache`)
- Aliases: short lowercase mnemonics (e.g., `gswi`, `lt`, `dcdu`)
- Functions: lowercase, underscores for multi-word (e.g., `config_get`)
- Exported env vars: UPPERCASE
- Local variables: lowercase

### Error handling pattern

```bash
# Bash scripts use set -euo pipefail plus explicit checks:
if ! command -v fzf >/dev/null 2>&1; then
  echo "[mzsh] requires fzf" >&2
  return 1  # return (not exit) in sourced zsh files
fi
```

### Conditional sourcing

Zsh modules check for tool availability before defining aliases/functions:

```zsh
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons'
fi
```

## Key architectural rules

1. **Each file has a single responsibility.** One tool or alias group per file.
2. **No cross-dependencies between tools/ or aliases/ files.** Each can be removed
   independently by deleting its source line from init.zsh.
3. **local.zsh is gitignored.** Never commit it -- it holds machine-specific config and
   secrets injected by `mzsh-secrets`.
4. **Secrets are managed via a manifest.** `secrets.manifest.json` defines credentials;
   `mzsh-secrets` writes them into a managed block in local.zsh.
5. **Updates must be safe.** `mzsh-update` refuses to pull when local changes exist and
   only does fast-forward merges.
6. **macOS-first.** Homebrew, Apple Keychain, Finder integrations, and Apple Silicon paths
   are assumed throughout.

## Configuration system

- **~/.mzsh.json**: JSON config managed by `lib/config.sh` via `jq`.
- **local.zsh**: Shell exports and overrides, gitignored.
- **secrets.manifest.json**: Declarative secrets definitions.
- Providers for secrets: 1Password (`op`), Bitwarden (`bw`), LastPass (`lpass`), macOS Keychain.

## Caching

- Antigen caches: `~/.antigen/` (bundles, init.zsh, *.zwc, .lock)
- Zsh completion cache: `~/.zcompdump*`
- Clear everything: `mzsh clear-cache` (handles stuck lock files and processes)

## Testing

There is no automated test suite. Validate changes by:

1. Running `zsh -i -c 'echo ok'` to check the shell starts without errors.
2. Opening a new terminal to verify full init.zsh loads cleanly.
3. Running the specific `mzsh` subcommand you modified.

## Common tasks for agents

### Adding a new tool integration

1. Create `tools/<toolname>.zsh`.
2. Guard with `command -v <tool>` check.
3. Add a `source` line in `init.zsh` in the tools section.

### Adding new aliases

1. Create or edit the appropriate file in `aliases/`.
2. If it's a new file, add a `source` line in `init.zsh` in the aliases section.

### Adding a new bin command

1. Create `bin/mzsh-<name>` with `#!/usr/bin/env bash` and `set -euo pipefail`.
2. Add the subcommand routing in `bin/mzsh` (the dispatcher).
3. Add a help line in the `usage()` function in `bin/mzsh`.

### Adding a Homebrew dependency

1. Add the formula or cask to `Brewfile`.
2. If it needs PATH or init setup, add that in the appropriate `tools/*.zsh` file.

### Modifying the Neovim config

- Entry point: `config/nvim/init.lua`
- Settings: `config/nvim/lua/core/settings.lua`
- Keymaps: `config/nvim/lua/core/keymaps.lua`
- Plugins: `config/nvim/lua/plugins/init.lua`
- LSP: `config/nvim/lua/config/lsp.lua`
- Note: `mzsh-install-deps` copies `config/nvim/` to `~/.config/nvim/`.

## Files to never modify

- `plugins/antigen.zsh.zwc` -- compiled cache, regenerated automatically
- `local.zsh` -- machine-specific, gitignored
- `secrets.manifest.json` -- contains real credential references
