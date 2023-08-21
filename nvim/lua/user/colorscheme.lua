-- vim.cmd [[
-- try
--   colorscheme darkplus
-- catch /^Vim\%((\a\+)\)\=:E185/
--   colorscheme default
--   set background=dark
-- endtry
-- ]] --

vim.g.nord_italic = false;
vim.g.nord_contrast = true;
vim.g.nord_borders = true;


vim.cmd [[colorscheme nord]]

vim.api.nvim_set_hl(0, "LspDiagnosticsUnderlineError", { sp = "#bf616a" , underline = true })
