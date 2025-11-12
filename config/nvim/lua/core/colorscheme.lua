-- Colorscheme configuration

-- Use default neovim colorscheme
-- You can replace this with your favorite colorscheme
-- Popular options: tokyonight, catppuccin, gruvbox, nord, etc.
-- To use: require("colorscheme-name").setup() or vim.cmd("colorscheme colorscheme-name")

-- For now, use the default nvim colorscheme
vim.cmd("colorscheme default")

-- Override some highlights for better visibility
local hl = vim.api.nvim_set_hl
hl(0, "ColorColumn", { bg = "#3a3a3a" })
hl(0, "CursorLine", { bg = "#2a2a2a" })
hl(0, "SignColumn", { bg = "NONE" })
