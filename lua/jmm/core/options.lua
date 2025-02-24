local opt = vim.opt
opt.relativenumber = true
opt.number = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.signcolumn = "no"
opt.ttimeoutlen = 50

opt.wrap = false
opt.ignorecase = true
opt.smartcase = true

opt.cursorline = false

opt.winblend = 0
opt.pumblend = 0
-- opt.background = "dark"
-- opt.signcolumn = "no"

opt.splitright = true
opt.splitbelow = true

opt.swapfile = false
--
-- local colorscheme = "morning"
-- local ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
-- vim.o.background = "dark" -- or "light" for light mode
-- if not ok then
-- 	vim.notify("colorscheme " .. colorscheme .. " not found!")
-- 	return
-- end
--
local statusline = {
	"%t",
	"%r",
	"%m",
	"%=",
	"%{&filetype}",
	" %2p%%",
	" %3l:%-2c ",
}

vim.o.statusline = table.concat(statusline, "")
opt.termguicolors = true
