-- Enable true color support
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true         -- Shows absolute number on the current line
vim.opt.relativenumber = true -- Shows relative numbers on other lines


-- Load pywal colors for Neovim
local wal_colors = vim.fn.expand('~/.cache/wal/colors-nvim.vim')
if vim.fn.filereadable(wal_colors) == 1 then
    vim.cmd('source ' .. wal_colors)
end

require("lsp")
require("keybindings")
require("plugins.lazy_setup")




