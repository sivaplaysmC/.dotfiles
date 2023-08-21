local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)


-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", "<CMD>bnext<CR>", opts)
keymap("n", "<S-h>", "<CMD>bprev<CR>", opts)

keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)


-- secret trick , no pasting allowed in select mode (useful for cmp)
keymap("x", "p", '"_dP', opts)


keymap("n", "<leader>w", "<C-w>", opts);

vim.keymap.set('n', '<leader>fs', "<cmd>w<CR>", opts)

vim.keymap.set('n', '<leader>ff', "<CMD>FzfLua files<CR>", opts)
vim.keymap.set('n', '<leader>fo', "<CMD>FzfLua oldfiles<CR>", opts)
vim.keymap.set('n', '<leader>fd',
  "<CMD>lua require'fzf-lua'.files({ cmd = 'fd --type f --exclude node_modules --exclude build' })<CR>", opts)
vim.keymap.set('n', '<leader>fr', "<CMD>FzfLua live_grep<CR>", opts)


vim.keymap.set('n', '<leader>bk', ":bd!<CR>", opts)
vim.keymap.set('n', '<leader>bb', "<cmd>FzfLua buffers<CR>", opts)
vim.keymap.set('n', '<leader>bs', "<cmd>FzfLua lines<CR>", opts)


vim.keymap.set('n', '<leader>h', "<cmd>noh<CR>", opts)
