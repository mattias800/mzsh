-- LSP Configuration

local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")

-- Default capabilities with LSP completion
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Global LSP settings
local on_attach = function(client, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
  end

  -- Diagnostics
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
  map("n", "gr", vim.lsp.buf.references, "Go to references")
  map("n", "K", vim.lsp.buf.hover, "Hover")
  map("n", "<leader>sd", vim.diagnostic.open_float, "Show diagnostics")
  map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
  map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
end

-- Setup language servers via mason-lspconfig
mason_lspconfig.setup_handlers({
  -- Default handler for any server without explicit config
  function(server_name)
    lspconfig[server_name].setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,

  -- TypeScript-specific config
  ["typescript-language-server"] = function()
    lspconfig.typescript_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          },
        },
      },
    })
  end,

  -- C# specific config
  ["csharp_ls"] = function()
    lspconfig.csharp_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,

  -- Lua specific config
  ["lua_ls"] = function()
    lspconfig.lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
          },
        },
      },
    })
  end,

  -- Go specific config
  ["gopls"] = function()
    lspconfig.gopls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
          },
          staticcheck = true,
          gofumpt = true,
        },
      },
    })
  end,

  -- Rust specific config
  ["rust_analyzer"] = function()
    lspconfig.rust_analyzer.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
          },
          checkOnSave = {
            command = "clippy",
          },
        },
      },
    })
  end,

  -- C/C++ specific config
  ["clangd"] = function()
    lspconfig.clangd.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
      },
    })
  end,

  -- Python specific config
  ["pylsp"] = function()
    lspconfig.pylsp.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        pylsp = {
          plugins = {
            autopep8 = { enabled = false },
            black = { enabled = true },
            pycodestyle = { enabled = true },
            pyflakes = { enabled = true },
            pylint = { enabled = false },
          },
        },
      },
    })
  end,

  -- HTML specific config
  ["html"] = function()
    lspconfig.html.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,

  -- CSS specific config
  ["cssls"] = function()
    lspconfig.cssls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,

  -- JSON specific config
  ["jsonls"] = function()
    lspconfig.jsonls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,
})

-- Configure diagnostics appearance
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
})
