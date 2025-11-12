-- Plugins configuration using lazy.nvim
-- Plugins are loaded on-demand to improve startup time

return {
  -- Appearance
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "vim",
          "json",
          "markdown",
          "yaml",
          "typescript",
          "tsx",
          "javascript",
          "jsx",
          "csharp",
          "css",
          "html",
          "go",
          "rust",
          "cpp",
          "c",
          "python",
          "bash",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Utilities
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle file explorer" },
    },
  },

  -- Mason (LSP/tool installer)
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "typescript-language-server",
          "csharp_ls",
          "lua_ls",
          "gopls",
          "rust_analyzer",
          "clangd",
          "pylsp",
          "html",
          "cssls",
          "json",
        },
        automatic_installation = true,
      })
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "mason.nvim",
      "mason-lspconfig.nvim",
    },
    config = function()
      require("config.lsp")
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "roobert/tailwindcss-colorizer-cmp.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local tailwindcss_colorizer_cmp = require("tailwindcss-colorizer-cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = tailwindcss_colorizer_cmp.formatter,
        },
      })
    end,
  },

  -- Formatting (conform.nvim with Prettier and prettierd)
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      require("config.formatting")
    end,
  },

  -- React
  {
    "maxmellon/vim-jsx-pretty",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  },

  {
    "neoclide/vim-jsx-improve",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  },

  -- Tailwind CSS
  {
    "luckasRanarison/tailwind-tools.nvim",
    ft = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("tailwind-tools").setup({
        document_color = {
          enabled = true,
        },
      })
    end,
  },
}
