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
