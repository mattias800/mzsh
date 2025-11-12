-- Core neovim settings

local opt = vim.opt
local g = vim.g

-- Disable netrw in favor of nvim-tree (if used)
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.numberwidth = 4

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Visual
opt.cursorline = true
opt.cursorcolumn = false
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes:2"
opt.colorcolumn = "80,120"

-- Behavior
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.undofile = true
opt.splitbelow = true
opt.splitright = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10

-- Performance
opt.updatetime = 200
opt.timeoutlen = 500
