return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")
		local util = require("lspconfig.util")
		-- import mason_lspconfig plugin
		local mason_lspconfig = require("mason-lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness
		local root_file = {
			".eslintrc",
			".eslintrc.js",
			".eslintrc.cjs",
			".eslintrc.yaml",
			".eslintrc.yml",
			".eslintrc.json",
			"eslint.config.js",
			"eslint.config.mjs",
			"eslint.config.cjs",
			"eslint.config.ts",
			"eslint.config.mts",
			"eslint.config.cts",
		}

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()
		-- local on_attach = cmp_nvim_lsp.
		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		mason_lspconfig.setup_handlers({
			-- default handler for installed servers
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
			["svelte"] = function()
				-- configure svelte server
				lspconfig["svelte"].setup({
					capabilities = capabilities,
					on_attach = function(client, bufnr)
						vim.api.nvim_create_autocmd("BufWritePost", {
							pattern = { "*.js", "*.ts" },
							callback = function(ctx)
								-- Here use ctx.match instead of ctx.file
								client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
							end,
						})
					end,
				})
			end,
			["graphql"] = function()
				-- configure graphql language server
				lspconfig["graphql"].setup({
					capabilities = capabilities,
					filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
				})
			end,

			["ts_ls"] = function()
				lspconfig["ts_ls"].setup({

					init_options = { hostInfo = "neovim" },
					cmd = { "typescript-language-server", "--stdio" },
					filetypes = {
						"javascript",
						"javascriptreact",
						"javascript.jsx",
						"typescript",
						"typescriptreact",
						"typescript.tsx",
					},
					root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
					single_file_support = true,
				})
			end,
			["csharp-ls"] = function()
				lspconfig["csharp-ls"].setup({
					cmd = { "csharp-ls" },
					root_dir = function(bufnr, on_dir)
						local fname = vim.api.nvim_buf_get_name(bufnr)
						on_dir(util.root_pattern("*.sln")(fname) or util.root_pattern("*.csproj")(fname))
					end,
					filetypes = { "cs" },
					init_options = {
						AutomaticWorkspaceInit = true,
					},
				})
			end,
			["emmet_language_server"] = function()
				lspconfig["emmet_language_server"].setup({
					cmd = { "emmet-language-server", "--stdio" },
					filetypes = {
						"css",
						"eruby",
						"html",
						"htmldjango",
						"javascriptreact",
						"less",
						"pug",
						"sass",
						"scss",
						"typescriptreact",
						"htmlangular",
					},
					root_dir = function(fname)
						return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
					end,
					single_file_support = true,
				})
			end,

			["eslint"] = function()
				-- configure lua server (with special settings)
				lspconfig["eslint"].setup({
					cmd = { "vscode-eslint-language-server", "--stdio" },
					filetypes = {
						"javascript",
						"javascriptreact",
						"javascript.jsx",
						"typescript",
						"typescriptreact",
						"typescript.tsx",
						"vue",
						"svelte",
						"astro",
					},
					-- https://eslint.org/docs/user-guide/configuring/configuration-files#configuration-file-formats
					root_dir = function(fname)
						root_file = util.insert_package_json(root_file, "eslintConfig", fname)
						return util.root_pattern(unpack(root_file))(fname)
					end,
					-- Refer to https://github.com/Microsoft/vscode-eslint#settings-options for documentation.
					settings = {
						validate = "on",
						packageManager = nil,
						useESLintClass = false,
						experimental = {
							useFlatConfig = false,
						},
						codeActionOnSave = {
							enable = false,
							mode = "all",
						},
						format = true,
						quiet = false,
						onIgnoredFiles = "off",
						rulesCustomizations = {},
						run = "onType",
						problems = {
							shortenToSingleLine = false,
						},
						-- nodePath configures the directory in which the eslint server should start its node_modules resolution.
						-- This path is relative to the workspace folder (root dir) of the server instance.
						nodePath = "",
						-- use the workspace folder location or the file location (if no workspace folder is open) as the working directory
						workingDirectory = { mode = "location" },
						codeAction = {
							disableRuleComment = {
								enable = true,
								location = "separateLine",
							},
							showDocumentation = {
								enable = true,
							},
						},
					},
					on_new_config = function(config, new_root_dir)
						-- The "workspaceFolder" is a VSCode concept. It limits how far the
						-- server will traverse the file system when locating the ESLint config
						-- file (e.g., .eslintrc).
						config.settings.workspaceFolder = {
							uri = new_root_dir,
							name = vim.fn.fnamemodify(new_root_dir, ":t"),
						}

						-- Support flat config
						if
							vim.fn.filereadable(new_root_dir .. "/eslint.config.js") == 1
							or vim.fn.filereadable(new_root_dir .. "/eslint.config.mjs") == 1
							or vim.fn.filereadable(new_root_dir .. "/eslint.config.cjs") == 1
							or vim.fn.filereadable(new_root_dir .. "/eslint.config.ts") == 1
							or vim.fn.filereadable(new_root_dir .. "/eslint.config.mts") == 1
							or vim.fn.filereadable(new_root_dir .. "/eslint.config.cts") == 1
						then
							config.settings.experimental.useFlatConfig = true
						end

						-- Support Yarn2 (PnP) projects
						local pnp_cjs = new_root_dir .. "/.pnp.cjs"
						local pnp_js = new_root_dir .. "/.pnp.js"
						if vim.loop.fs_stat(pnp_cjs) or vim.loop.fs_stat(pnp_js) then
							config.cmd = vim.list_extend({ "yarn", "exec" }, config.cmd)
						end
					end,
					handlers = {
						["eslint/openDoc"] = function(_, result)
							if result then
								vim.ui.open(result.url)
							end
							return {}
						end,
						["eslint/confirmESLintExecution"] = function(_, result)
							if not result then
								return
							end
							return 4 -- approved
						end,
						["eslint/probeFailed"] = function()
							vim.notify("[lspconfig] ESLint probe failed.", vim.log.levels.WARN)
							return {}
						end,
						["eslint/noLibrary"] = function()
							vim.notify("[lspconfig] Unable to find ESLint library.", vim.log.levels.WARN)
							return {}
						end,
					},
				})
			end,

			["lua_ls"] = function()
				-- configure lua server (with special settings)
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				})
			end,
			["pyright"] = function()
				lspconfig["pyright"].setup({
					capabilities = capabilities,
					on_attach = function(client, bufnr) end,
					root_dir = vim.loop.cwd,
				})
			end,
			["clangd"] = function()
				lspconfig["clangd"].setup({
					capabilities = capabilities,
					-- for KrakenEngine contributions
					cmd = { "clangd", "--background-index", "--compile-commands-dir=builddir" },
					-- root_dir = vim.loop.cwd,
					root_dir = require("lspconfig").util.root_pattern(
						"compile_commands.json",
						"CMakeLists.txt",
						".git"
					),
				})
			end,
		})
	end,
}
