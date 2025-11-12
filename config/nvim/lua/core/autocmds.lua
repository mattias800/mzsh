-- Autocommands

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Remove trailing whitespace on save
augroup("remove_trailing_whitespace", { clear = true })
autocmd("BufWritePre", {
  group = "remove_trailing_whitespace",
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Highlight on yank
augroup("highlight_yank", { clear = true })
autocmd("TextYankPost", {
  group = "highlight_yank",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Restore cursor position
augroup("restore_cursor_position", { clear = true })
autocmd("BufReadPost", {
  group = "restore_cursor_position",
  pattern = "*",
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 1 and line <= vim.fn.line("$") then
      vim.cmd('normal! g`"')
    end
  end,
})
