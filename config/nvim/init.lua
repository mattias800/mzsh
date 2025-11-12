-- mzsh neovim configuration
-- A modern, modular neovim setup

-- Load core settings
require("core.settings")

-- Load keymaps
require("core.keymaps")

-- Initialize lazy package manager if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup("plugins", {
  defaults = {
    lazy = true,
  },
})

-- Load additional configurations
require("core.colorscheme")
require("core.autocmds")
