# Neovim LSP and Formatting Setup

## Overview

This Neovim configuration includes a comprehensive development environment with:
- **Mason**: Automatic installation and management of language servers and tools
- **LSP**: Language server support for multiple languages
- **Formatting**: Fast formatting with Prettier (via prettierd daemon) and language-specific formatters
- **React & Tailwind**: Specialized support for React development and Tailwind CSS
- **Completion**: Context-aware code completion with Tailwind color previews

## Language Servers Installed by Mason

Mason automatically installs and manages the following language servers:

### Primary Languages (Your Stack)
- **TypeScript/JavaScript**: `typescript-language-server` (TSLs)
  - Provides type checking, code completion, refactoring
  - Inlay hints for types, parameters, and return values
  
- **C#**: `csharp_ls`
  - .NET language support with completion and diagnostics
  
- **Go**: `gopls`
  - Go language support with code analysis and formatting
  - Includes staticcheck and gofumpt
  
- **Rust**: `rust_analyzer`
  - Advanced Rust analysis with clippy checks
  - All features enabled for maximum compatibility

- **C/C++**: `clangd`
  - C and C++ support with background indexing
  - Includes clang-tidy analysis and header insertion
  
- **Python**: `pylsp`
  - Python linting and code completion
  - Uses black for formatting, pycodestyle and pyflakes for linting

### Additional Languages
- **Lua**: `lua_ls` (with neovim globals configured)
- **HTML**: `html`
- **CSS**: `cssls`
- **JSON**: `json` (jsonls)

## Formatters

### Prettier (via prettierd daemon)
Fast formatting for web technologies using the prettierd daemon:
- TypeScript, JavaScript, JSX, TSX
- HTML, CSS, SCSS, Less
- JSON, YAML, Markdown

**Installation**: `brew install prettierd`

**Usage**: 
- Automatic on save (500ms timeout)
- Manual: `<leader>f` in normal or visual mode

### Language-Specific Formatters
- **C#**: csharpier
- **Go**: gofmt
- **Rust**: rustfmt
- **C/C++**: clang-format
- **Python**: black + isort
- **Lua**: stylua
- **Bash**: shfmt

## LSP Keybindings

Once an LSP server attaches to a buffer:

| Keybinding | Action |
|-----------|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Find references |
| `K` | Show hover information |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action (refactoring, fixes) |
| `<leader>sd` | Show diagnostics in floating window |
| `[d` | Go to previous diagnostic |
| `]d` | Go to next diagnostic |

## Formatting Keybindings

| Keybinding | Action |
|-----------|--------|
| `<leader>f` | Format buffer (normal mode) |
| `<leader>f` | Format selection (visual mode) |

**Note**: Formatting also happens automatically on save

## Completion

Code completion is provided by `nvim-cmp` with:
- LSP completions from language servers
- Snippet support (LuaSnip)
- Buffer-based completions
- Path completions
- **Tailwind CSS color previews** in completion menu

**Navigation**:
- `<C-Space>` - Trigger completion manually
- `<C-n>` / `<C-p>` - Navigate completion menu
- `<CR>` - Confirm selection
- `<C-e>` - Abort completion

## React & TypeScript Support

### JSX/TSX Syntax Highlighting
- `vim-jsx-pretty`: Enhanced JSX syntax highlighting
- `vim-jsx-improve`: Additional JSX improvements
- Treesitter syntax highlighting for modern syntax

### Tailwind CSS Support

**tailwind-tools.nvim** provides:
- Color highlighting and previews
- Autocomplete with color swatches
- Document color support
- Syntax highlighting for Tailwind classes

**tailwindcss-colorizer-cmp** adds:
- Tailwind color previews in completion menu
- Visual feedback for color utilities

## File Type Detection

Language servers and tools are loaded based on file type:

- TypeScript: `.ts`, `.tsx`, `.mts`, `.cts`
- JavaScript: `.js`, `.jsx`, `.mjs`, `.cjs`
- C#: `.cs`, `.csx`
- Go: `.go`
- Rust: `.rs`
- C/C++: `.c`, `.h`, `.cpp`, `.hpp`, `.cc`, `.cxx`
- Python: `.py`
- HTML: `.html`, `.htm`
- CSS: `.css`, `.scss`, `.less`
- JSON: `.json`, `.jsonc`
- YAML: `.yaml`, `.yml`
- Markdown: `.md`, `.markdown`
- Lua: `.lua`

## Installing Language Servers Manually

If automatic installation via Mason doesn't work, you can:

1. Open Neovim
2. Run `:Mason` to open the Mason UI
3. Search for the language server you need
4. Press `i` to install
5. Press `u` to update

Or install via command line:
```bash
# Example: install TypeScript LSP
nvim --headless -c "MasonInstall typescript-language-server" -c "quit"
```

## Troubleshooting

### LSP not working
1. Check if server is installed: `:Mason` and look for ✓ mark
2. Check if file type is recognized: `:set filetype?`
3. Check logs: `:LspLog` (if available)
4. Manually attach: `:LspStart <server-name>`

### Formatting not working
1. Verify formatter is installed: `which prettierd` or `brew list prettier`
2. Check file type detection: `:set filetype?`
3. Verify conform config: `:ConformInfo` (if using conform)
4. Check for .prettierrc or prettier config in project

### Performance issues
- prettierd is already optimized (uses daemon)
- Adjust timeout in formatting config if needed: search `timeout_ms`
- Disable LSP inlay hints if too slow (edit `config/lsp.lua`)

## Configuration Files

- **LSP setup**: `lua/config/lsp.lua`
- **Formatting**: `lua/config/formatting.lua`
- **Plugins**: `lua/plugins/init.lua` (Mason, React, Tailwind)
- **Keymaps**: `lua/core/keymaps.lua` (LSP bindings added via on_attach)
- **Settings**: `lua/core/settings.lua`

## Next Steps

1. Run `:Mason` to verify all servers are installed
2. Open a TypeScript file to test LSP features
3. Test formatting with `<leader>f`
4. Check completion with `<C-Space>`
5. Verify Tailwind colors display in CSS/JSX files

All language servers are configured to start automatically when you open a file of their type.
