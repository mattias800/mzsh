-- Neovim keymaps

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Remap leader to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General
map("n", "<leader>w", "<cmd>write<CR>", opts)
map("n", "<leader>q", "<cmd>quit<CR>", opts)
map("n", "<leader>Q", "<cmd>quit!<CR>", opts)

-- Clear search highlights
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- Better navigation
map("n", "j", "gj", opts)
map("n", "k", "gk", opts)
map("n", "gj", "j", opts)
map("n", "gk", "k", opts)

-- Window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Window resize
map("n", "<C-Up>", "<cmd>resize +2<CR>", opts)
map("n", "<C-Down>", "<cmd>resize -2<CR>", opts)
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts)
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)

-- Indentation
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move selected lines
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Buffers
map("n", "<Tab>", "<cmd>bnext<CR>", opts)
map("n", "<S-Tab>", "<cmd>bprevious<CR>", opts)
map("n", "<leader>bd", "<cmd>bdelete<CR>", opts)

-- Splits
map("n", "<leader>v", "<cmd>vsplit<CR>", opts)
map("n", "<leader>s", "<cmd>split<CR>", opts)
