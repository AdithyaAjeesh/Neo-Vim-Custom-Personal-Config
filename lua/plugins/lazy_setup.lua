-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
	{
		"ThePrimeagen/vim-be-good",
		cmd = "VimBeGood",
	},
	{
		"ThePrimeagen/harpoon",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("harpoon").setup {}
			local km = vim.keymap.set
			km("n", "<leader>a", require("harpoon.mark").add_file, { desc = "Harpoon: add file" })
			km("n", "<leader>h", require("harpoon.ui").toggle_quick_menu, { desc = "Harpoon: menu" })
			km("n", "<leader>n", require("harpoon.ui").nav_next, { desc = "Harpoon: next" })
			km("n", "<leader>p", require("harpoon.ui").nav_prev, { desc = "Harpoon: prev" })
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = vim.fn.executable("make") == 1,
			},
		},
		config = function()
			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
					},
					mappings = {
						i = {
							["<C-u>"] = false,
							["<C-d>"] = false,
						},
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})
			telescope.load_extension("fzf")
			local km = vim.keymap.set
			km("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Find Files" })
			km("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "Live Grep" })
			km("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "Help Tags" })
			km("n", "<leader>fd", require("telescope.builtin").diagnostics, { desc = "Project Diagnostics" })
		end,
	},
	{
		"kdheepak/lazygit.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "akinsho/toggleterm.nvim" },
		cmd = "LazyGit",
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<CR>", desc = "Open Lazygit" },
		},
		config = function()
			require("toggleterm").setup({ direction = "float", close_on_exit = true })
		end,
	},

{
	"crnvl96/lazydocker.nvim",
	dependencies = { "akinsho/toggleterm.nvim" },
	keys = {
		{
			"<leader>dd",
			function()
				local Terminal = require("toggleterm.terminal").Terminal
				local lazydocker = Terminal:new({
					cmd = "sudo lazydocker",
					direction = "float",
					close_on_exit = true,
					hidden = true,
				})
				lazydocker:toggle()
			end,
			desc = "Open LazyDocker",
		},
	},
},

	{
		"stevearc/conform.nvim",
		opts = {
			format_on_save = {
				timeout_ms = 1000,
				lsp_fallback = true,
			},
		},
	},


	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"L3MON4D3/LuaSnip", -- Snippet engine
			"saadparwaiz1/cmp_luasnip", -- Snippet completions
			"hrsh7th/cmp-nvim-lsp", -- LSP completions
			"hrsh7th/cmp-buffer", -- Buffer completions
			"hrsh7th/cmp-path", -- Path completions
			"hrsh7th/cmp-cmdline", -- Command-line completions
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

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
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
	-- {
	-- 	"catppuccin/nvim",
	-- 	name = "catppuccin",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("catppuccin").setup({
	-- 			flavour = "mocha", -- latte, frappe, macchiato, mocha
	-- 			transparent_background = true,
	-- 			integrations = {
	-- 				treesitter = true,
	-- 				native_lsp = { enabled = true },
	-- 				-- telescope = true,
	-- 				cmp = true,
	-- 				gitsigns = true,
	-- 				which_key = true,
	-- 				mason = true,
	-- 				lsp_trouble = true,
	-- 				noice = true,
	-- 				illuminate = true,
	-- 				nvimtree = true,
	-- 			},
	-- 		})
	-- 		vim.cmd.colorscheme("catppuccin")
	-- 	end,
	-- },
	
	{
		"nvim-tree/nvim-web-devicons",
		lazy = false,
		config = function()
			require("nvim-web-devicons").setup()
		end,
	},


	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				direction = "float", -- 👈 Floating terminal by default
				float_opts = {
					border = "curved",
					winblend = 3,
				},
			})
		end,
	},

	{
		"nvim-pack/nvim-spectre",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require('spectre').setup({
				color_devicons = true,
				open_cmd = 'vnew',
				live_update = false,
				mapping = {
					['toggle_line'] = {
						map = "dd",
						cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
						desc = "toggle item"
					},
					['enter_file'] = {
						map = "<cr>",
						cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
						desc = "open file"
					},
					['run_replace'] = {
						map = "<leader>R",
						cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
						desc = "replace all"
					},
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"go", "dart", "lua", "vim", "vimdoc", "query", "bash", "json", "yaml", "markdown",
					"html", "css", "rust",
				},
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<CR>",
						node_incremental = "<CR>",
						scope_incremental = "<TAB>",
						node_decremental = "<BS>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
				},
			})
		end,
	},
	{
		'norcalli/nvim-colorizer.lua',
		config = function()
			require('colorizer').setup({
				'dart',
				'javascript',
				'typescript',
				'css',
				'html',
			})
		end
	}
})
