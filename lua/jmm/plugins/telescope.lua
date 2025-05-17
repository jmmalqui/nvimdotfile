return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local transform_mod = require("telescope.actions.mt").transform_mod

		local trouble = require("trouble")
		local trouble_telescope = require("trouble.sources.telescope")

		-- or create your custom action
		local custom_actions = transform_mod({
			open_trouble_qflist = function(prompt_bufnr)
				trouble.toggle("quickfix")
			end,
		})
		telescope.setup({
			defaults = {
				path_display = { "smart" },
				file_ignore_patterns = { "node%_modules/.*", "build/.*", "subprojects/.*" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
						["<C-t>"] = trouble_telescope.open,
					},
				},
			},
			borderchars = {
				{ "─", "│", "─", "│", "┌", "┐", "┘", "└" },
				prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
				results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
				preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
			},

			pickers = {
				lsp_document_symbols = {
					symbol_width = 70, -- Allocate more width to the symbol names
					symbol_type_width = 15, -- Limit the width of the symbol type
					show_line = false, -- Don't show line numbers to save space
					-- symbols = {
					-- 	-- Customize which symbols to show if needed
					-- 	"class",
					-- 	"function",
					-- 	"method",
					-- 	"constructor",
					-- 	"interface",
					-- 	"module",
					-- 	"struct",
					-- 	"trait",
					-- 	"field",
					-- 	"property",
					-- 	"variable",
					-- },
					-- entry_maker = function(entry)
					-- 	-- Safely access properties with nil checks
					-- 	local name = entry.name or (entry.text and entry.text.text) or "nekokoneko"
					-- 	local kind = vim.lsp.protocol.SymbolKind[entry.kind] or "Unknown"
					-- 	local container = entry.containerName or ""
					-- 	local prefix = ""
					--
					-- 	if container ~= "" then
					-- 		prefix = container .. " → "
					-- 	end
					--
					-- 	-- Create display string
					-- 	local display_items = {
					-- 		{ name, "TelescopeResultsIdentifier" },
					-- 		{ " [" .. kind .. "]", "TelescopeResultsConstant" },
					-- 	}
					--
					-- 	-- Return the entry with custom formatting
					-- 	return {
					-- 		valid = true,
					-- 		value = entry,
					-- 		ordinal = prefix .. name,
					-- 		display = function()
					-- 			return display_items
					-- 		end,
					-- 		filename = entry.filename
					-- 			or (entry.location and entry.location.uri)
					-- 			or vim.api.nvim_buf_get_name(0),
					-- 		lnum = entry.lnum or (entry.location and entry.location.range.start.line + 1) or 1,
					-- 		col = entry.col or (entry.location and entry.location.range.start.character + 1) or 1,
					-- 		symbol_name = name,
					-- 		symbol_type = kind,
					-- 		start = entry.range and entry.range.start.character or entry.col or 1,
					-- 		finish = entry.range and entry.range["end"].character or entry.col or 1,
					-- 	}
					-- end,
				},
			},
			-- pickers = {
			-- 	find_files = {
			-- 		theme = "dropdown",
			-- 	},
			-- 	grep_string = {
			-- 		theme = "dropdown",
			-- 	},
			-- 	live_grep = {
			-- 		theme = "dropdown",
			-- 	},
			-- 	lsp_document_symbols = {
			-- 		theme = "dropdown",
			-- 	},
			-- },
		})

		telescope.load_extension("fzf")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>fm", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Find document symbols" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
	end,
}
