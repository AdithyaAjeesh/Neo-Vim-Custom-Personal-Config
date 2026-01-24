-- Enable true color support
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true         
vim.opt.relativenumber = true

-- Enable swap, backup, and undo files
vim.opt.swapfile = true
vim.opt.backup = true
vim.opt.undofile = true

-- Set directories for safety
local data_path = vim.fn.stdpath("data")

vim.opt.directory = data_path .. "/swap//"    -- Swap files
vim.opt.backupdir = data_path .. "/backup//"  -- Backups
vim.opt.undodir = data_path .. "/undo//"      -- Undo history


vim.fn.mkdir(tostring(vim.opt.directory:get()[1]), "p")
vim.fn.mkdir(tostring(vim.opt.backupdir:get()[1]), "p")
vim.fn.mkdir(tostring(vim.opt.undodir:get()[1]), "p")


local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end


require("lsp")
require("keybindings")
require("plugins.lazy_setup")
require("plugins.copilot")



