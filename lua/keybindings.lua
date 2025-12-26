-- Map 'j' and 'k' to move 5 display lines down or up
vim.api.nvim_set_keymap("n", "J", "5gj", { noremap = true, silent = true }) -- Move 5 display lines down
vim.api.nvim_set_keymap("n", "K", "5gk", { noremap = true, silent = true }) -- Move 5 display lines up

-- File Saving
vim.keymap.set("n", "<leader>w", function()
	vim.cmd("write")
	vim.api.nvim_echo({ { "File saved!", "MoreMsg" } }, false, {})
end, { desc = "Save file" })

-- Go to definition
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true, desc = "Go to Definition" })

-- Open the Explorer
vim.keymap.set('n', '<leader>e', ':Explore<CR>', { noremap = true, silent = true })

--Floating Terminal View
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", { desc = "Toggle Floating Terminal" })


--Spectre (Find And Replace)
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
	{ desc = "Search current word" })
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', { desc = "Search selection" })
vim.keymap.set('n', '<leader>fr', '<cmd>lua require("spectre").toggle()<CR>', { desc = "Open Spectre" })

-- Code Actions
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find References" })

-- Reload config without restarting Neovim
vim.keymap.set("n", "<leader>R", ":source $MYVIMRC<CR>", { desc = "Reload Neovim config" })

-- Show LSP hover info (like VS Code hover)
vim.keymap.set("n", "<leader>v", vim.lsp.buf.hover, { desc = "Show hover info" })

-- Save All Files
vim.keymap.set('n', '<leader>wa', function()
  vim.cmd('wall')
  print("✓ All files saved")
end, { desc = 'Write all buffers' })
