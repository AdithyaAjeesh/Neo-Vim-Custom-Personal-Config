vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
})



-- Create autocommand group
local lsp_group = vim.api.nvim_create_augroup("LSPConfig", { clear = true })

-- Organize imports on save for Go, Dart, and Lua
vim.api.nvim_create_autocmd("BufWritePre", {
	group = lsp_group,
	pattern = { "*.go", "*.dart", "*.lua" },
	callback = function()
		local params = vim.lsp.util.make_range_params()
		params.context = { only = { "source.organizeImports" } }

		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
		for _, res in pairs(result or {}) do
			for _, action in pairs(res.result or {}) do
				if action.edit or type(action.command) == "table" then
					if action.edit then
						vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
					end
					if type(action.command) == "table" then
						vim.lsp.buf.execute_command(action.command)
					end
				end
			end
		end
	end,
})


-- Go LSP autocommand
vim.api.nvim_create_autocmd("FileType", {
	group = lsp_group,
	pattern = "go",
	callback = function()
		vim.lsp.start({
			name = 'gopls',
			cmd = { 'gopls' },
			root_dir = vim.fs.dirname(vim.fs.find({ 'go.mod', '.git' }, { upward = true })[1]),
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
					gofumpt = true,
				},
			},
		})
	end,
})

-- Dart LSP autocommand
vim.api.nvim_create_autocmd("FileType", {
	group = lsp_group,
	pattern = "dart",
	callback = function()
		local root_dir = vim.fs.dirname(vim.fs.find({ 'pubspec.yaml', '.git' }, { upward = true })[1])
		if not root_dir then
			vim.notify("Could not find Dart project root (pubspec.yaml)", vim.log.levels.WARN)
			return
		end
		vim.lsp.start({
			name = 'dartls',
			cmd = { 'dart', 'language-server', '--protocol=lsp' },
			root_dir = root_dir,
			init_options = {
				onlyAnalyzeProjectsWithOpenFiles = false,
				suggestFromUnimportedLibraries = true,
				closingLabels = true,
				outline = true,
				flutterOutline = true,
			},
			settings = {
				dart = {
					completeFunctionCalls = true,
					showTodos = true,
					enableSdkFormatter = true,
					lineLength = 80,
				}
			},
			on_attach = function(client, bufnr)
			end,
		})
	end,
})


-- Rust LSP autocommand
vim.api.nvim_create_autocmd("FileType", {
	group = lsp_group,
	pattern = "rust",
	callback = function()
		-- Check if rust-analyzer is available
		if vim.fn.executable('rust-analyzer') == 0 then
			vim.notify('rust-analyzer not found in PATH', vim.log.levels.ERROR)
			return
		end

		-- Find root directory
		local root_files = { 'Cargo.toml', 'Cargo.lock', '.git' }
		local found = vim.fs.find(root_files, { upward = true })
		local root_dir = found[1] and vim.fs.dirname(found[1])

		if not root_dir then
			vim.notify('No Cargo.toml found - not in a Rust project?', vim.log.levels.WARN)
			return
		end

		vim.lsp.start({
			name = 'rust-analyzer',
			cmd = { 'rust-analyzer' },
			root_dir = root_dir,
			settings = {
				['rust-analyzer'] = {
					-- Cargo configuration
					cargo = {
						allFeatures = true,
						loadOutDirsFromCheck = true,
						runBuildScripts = true,
					},
					-- Check on save with clippy
					checkOnSave = true,
					check = {
						command = "clippy",
						extraArgs = { "--all", "--", "-W", "clippy::all" },
					},
					-- Proc macro support
					procMacro = {
						enable = true,
						ignored = {
							leptos_macro = {
								-- List of proc macro types to ignore
								"component",
								"server",
							},
						},
					},
					-- Diagnostics
					diagnostics = {
						enable = true,
						disabled = {},
						enableExperimental = true,
					},
					-- Completion settings
					completion = {
						postfix = {
							enable = true,
						},
						autoimport = {
							enable = true,
						},
						callable = {
							snippets = "fill_arguments",
						},
					},
					-- Assist settings
					assist = {
						importGranularity = "module",
						importPrefix = "by_self",
					},
					-- Lens settings
					lens = {
						enable = true,
						methodReferences = true,
						references = true,
					},
					-- Hover settings
					hover = {
						actions = {
							enable = true,
							implementations = true,
							references = true,
							run = true,
							debug = true,
						},
					},
					-- Inlay hints
					inlayHints = {
						bindingModeHints = {
							enable = false,
						},
						chainingHints = {
							enable = true,
						},
						closingBraceHints = {
							enable = true,
							minLines = 25,
						},
						closureReturnTypeHints = {
							enable = "never",
						},
						lifetimeElisionHints = {
							enable = "never",
							useParameterNames = false,
						},
						maxLength = 25,
						parameterHints = {
							enable = true,
						},
						reborrowHints = {
							enable = "never",
						},
						renderColons = true,
						typeHints = {
							enable = true,
							hideClosureInitialization = false,
							hideNamedConstructor = false,
						},
					},
				},
			},
			on_attach = function(client, bufnr)
				if client.server_capabilities.inlayHintProvider then
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
				end
			end,
		})
	end,
})

-- ASM LSP autocommand
vim.api.nvim_create_autocmd("FileType", {
  group = lsp_group,
  pattern = { "asm", "s", "S" },
  callback = function()
    vim.lsp.start({
      name = 'asm-lsp',
      cmd = { 'asm-lsp' },
      root_dir = vim.fn.getcwd(),
      init_options = {
        assembler = "nasm"
      },
      filetypes = { "asm", "s", "S" },
    })
  end,
})

-- TypeScript/JavaScript LSP autocommand
vim.api.nvim_create_autocmd("FileType", {
	group = lsp_group,
	pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	callback = function()
		vim.lsp.start({
			name = 'tsserver',
			cmd = { 'typescript-language-server', '--stdio' },
			root_dir = vim.fs.dirname(vim.fs.find({ 'package.json', 'tsconfig.json', '.git' }, { upward = true })[1]),
			init_options = {
				preferences = {
					quotePreference = "single",
					importModuleSpecifierPreference = "non-relative",
				}
			},
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					}
				}
			},
		})
	end,
})




-- vim.api.nvim_create_autocmd("FileType", {
-- 	group = lsp_group,
-- 	pattern = "lua",
-- 	callback = function()
-- 		vim.lsp.start({
-- 			name = 'lua_ls',
-- 			cmd = { 'lua-language-server' },
-- 			root_dir = vim.fs.dirname(vim.fs.find(
-- 				{ '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', '.git' },
-- 				{ upward = true })[1]),
-- 			settings = {
-- 				Lua = {
-- 					runtime = {
-- 						version = 'LuaJIT'
-- 					},
-- 					diagnostics = {
-- 						globals = { 'vim' }
-- 					},
-- 					workspace = {
-- 						library = vim.api.nvim_get_runtime_file("", true),
-- 						checkThirdParty = false,
-- 					},
-- 					telemetry = {
-- 						enable = false,
-- 					},
-- 				},
-- 			},
-- 		})
-- 	end,
-- })
