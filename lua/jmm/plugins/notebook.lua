return {
	"meatballs/notebook.nvim",
	config = function()
		local notebook = require("notebook")
		notebook.setup({
			insert_blank_line = true,
			show_index = true,
			show_cell_type = true,
			virtual_text_style = { fg = "lightblue", italic = true },
		})
	end,
}
