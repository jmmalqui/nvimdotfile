require("jmm.core.options")
require("jmm.core.keymaps")
vim.cmd([[
  augroup transparent_bg
    autocmd!
    autocmd VimEnter * hi Normal guibg=NONE ctermbg=NONE
    autocmd VimEnter * hi NormalNC guibg=NONE ctermbg=NONE
    autocmd VimEnter * hi VertSplit guibg=NONE ctermbg=NONE
    autocmd VimEnter * hi StatusLine guibg=NONE ctermbg=NONE
    autocmd VimEnter * hi StatusLineNC guibg=NONE ctermbg=NONE
    autocmd VimEnter * hi EndOfBuffer guibg=NONE ctermbg=NONE
  augroup END
]])
