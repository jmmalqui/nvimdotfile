local colorscheme = {
	melange = { "savq/melange-nvim", "melange" },
	kanagawa = { "rebelot/kanagawa.nvim", "kanagawa-dragon" },
	gruber = { "thimc/gruber-darker.nvim", "gruber-darker" },
	minimalist = { "kar9222/minimalist.nvim", "minimalist" },
	accent = { "Alligator/accent.vim", "accent" },
	brutalist = { "wjlroe/brutalist.vim", "brutalist-dark" },
	decoldest = { "mxi/decoldest.vim", "decoldest" },
	gruvbox = { "ellisonleao/gruvbox.nvim", "gruvbox" },
	minibase = { "echasnovski/mini.base16", "minicyan" },
	noclown = { "no-clown-fiesta/no-clown-fiesta.nvim", "no-clown-fiesta" },
	lackluster = { "slugbyte/lackluster.nvim", "lackluster" },
	base4tone = { "atelierbram/Base4Tone-nvim", "base4tone_modern_n_dark" },
	vscode = { "Mofiqul/vscode.nvim", "vscode" },
	toytiza = { "profesorpaiche/toytiza.nvim", "toytiza" },
	fullerene = { "steguiosaur/fullerene.nvim", "fullerene" },
	grail = { "chama-chomo/grail", "grail" },
	mellow = { "mellow-theme/mellow.nvim", "mellow" },
	zenbones = { "zenbones-theme/zenbones.nvim", "zenbones" },
	iceberg = { "oahlen/iceberg.nvim", "iceberg-light" },
	nitepal = { "jascha030/nitepal.nvim", "nitepal" },
	catppuccin = { "catppuccin/nvim", "catppuccin" },
	deepwhite = { "Verf/deepwhite.nvim", "deepwhite" },
	lake = { "antonk52/lake.nvim", "lake" },
	everforest = { "neanias/everforest-nvim", "everforest" },
	tender = { "jacoborus/tender.vim", "tender" },
	obscure = { "killitar/obscure.nvim", "obscure" },
	nano = { "gaelph/nano.nvim", "nano" },
	juli = { "kaiuri/nvim-juliana", "juliana" },
	solarized = { "maxmx03/solarized.nvim", "solarized" },
	monokai = { "ku1ik/vim-monokai", "monokai" },
	naysay = { "jameswalls/naysayer.nvim", "naysayer" },
}

local using = colorscheme.naysay
-- return {}
return {
	using[1],
	priority = 1000,
	config = function()
		vim.cmd(string.format("colorscheme %s", using[2]))
	end,
}
