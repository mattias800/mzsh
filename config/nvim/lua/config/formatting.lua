-- Formatting Configuration using conform.nvim with prettierd

local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    -- TypeScript/JavaScript/JSX/TSX with prettier via prettierd
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    jsx = { "prettier" },
    tsx = { "prettier" },

    -- Web
    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    less = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },

    -- C#
    cs = { "csharpier" },

    -- Go
    go = { "gofmt" },

    -- Rust
    rust = { "rustfmt" },

    -- C/C++
    c = { "clang-format" },
    cpp = { "clang-format" },

    -- Python
    python = { "black", "isort" },

    -- Lua
    lua = { "stylua" },

    -- Bash
    bash = { "shfmt" },
    sh = { "shfmt" },
  },

  -- Use prettierd (daemon) for Prettier formatters (faster)
  formatters = {
    prettier = {
      command = "prettierd",
      args = { "$FILENAME" },
      stdin = true,
      cwd = require("conform.util").root_file({ ".prettierrc", ".prettierrc.json", ".prettierrc.js", "prettier.config.js", "package.json" }),
      require_cwd = false,
    },
  },

  -- Format on save
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },

  -- Async format (doesn't block UI)
  format_after_save = {
    lsp_fallback = true,
  },
})

-- Keymaps for formatting
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Format current buffer
map("n", "<leader>f", function()
  conform.format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

-- Format selected text in visual mode
map("v", "<leader>f", function()
  conform.format({ async = true, lsp_fallback = true })
end, { desc = "Format selection" })
