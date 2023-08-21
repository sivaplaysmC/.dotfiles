local fn = vim.fn


-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system {
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	}
	print "Installing packer close and reopen Neovim..."
	vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerInstall
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init {
	display = {
		open_fn = function()
			return require("packer.util").float { border = "double" }
		end,
	},
}

-- Install your plugins here
return packer.startup(function(use)
	-- My plugins here
	use "wbthomason/packer.nvim" -- Have packer manage itself
	use "nvim-lua/popup.nvim"    -- An implementation of the Popup API from vim in Neovim
	use "nvim-lua/plenary.nvim"  -- Useful lua functions used ny lots of plugins
	use "windwp/nvim-autopairs"  -- Autopairs, integrates with both cmp and treesitter
	use "numToStr/Comment.nvim"  -- Easily comment stuff

	-- use 'karb94/neoscroll.nvim'

	-- Colorschemes
	-- use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
	use "lunarvim/darkplus.nvim"
	use 'navarasu/onedark.nvim'
	use "catppuccin/nvim"
	use 'sivaplaysmC/nord.nvim'
	use "dnlhc/glance.nvim"

	-- cmp plugins
	use "hrsh7th/nvim-cmp"         -- The completion plugin
	use "hrsh7th/cmp-nvim-lua"
	use "hrsh7th/cmp-buffer"       -- buffer completions
	use "hrsh7th/cmp-path"         -- path completions
	use "hrsh7th/cmp-cmdline"      -- cmdline completions
	use "saadparwaiz1/cmp_luasnip" -- snippet completions
	use "hrsh7th/cmp-nvim-lsp"
	use "hrsh7th/cmp-emoji"        -- path completions
	use "onsails/lspkind.nvim"
	use {
		"ray-x/lsp_signature.nvim",
	}
	use {
		"SmiteshP/nvim-navic",
		requires = "neovim/nvim-lspconfig"
	}

	use "kelly-lin/ranger.nvim"
	use "kevinhwang91/rnvimr"
	use {
		"X3eRo0/dired.nvim",
		requires = "MunifTanjim/nui.nvim",
		config = function()
			require("dired").setup {
				path_separator = "/",
				show_banner = false,
				show_hidden = true,
				show_dot_dirs = true,
				show_colors = true,
			}
		end
	}

	-- snippets
	use "L3MON4D3/LuaSnip"             --snippet engine
	use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

	-- LSP
	use "neovim/nvim-lspconfig"           -- enable LSP
	use "williamboman/nvim-lsp-installer" -- simple to use language server installer
	use "tamago324/nlsp-settings.nvim"    -- language server settings defined in json for
	use "folke/trouble.nvim"
	use 'simrat39/rust-tools.nvim'
	use 'p00f/clangd_extensions.nvim'

	-- Telescope
	use "nvim-telescope/telescope.nvim"
	use "nvim-tree/nvim-web-devicons"
	use 'echasnovski/mini.nvim'
	--
	use {
		'declancm/cinnamon.nvim',
	}
	use { 'ibhagwan/fzf-lua',
		-- optional for icon support
		requires = { 'nvim-tree/nvim-web-devicons' }
	}

	use 'vijaymarupudi/nvim-fzf'

	use({ 'cloudsftp/peek.nvim', run = 'deno task --quiet build' })
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
		ft = { "markdown" },
	})


	use {
		"nvim-neorg/neorg",
		-- config = ,
		-- run = ":Neorg sync-parsers",
		requires = "nvim-lua/plenary.nvim",
	}

	-- StatusLine
	use "nvim-lualine/lualine.nvim"

	use "akinsho/bufferline.nvim"
	--
	use "ggandor/leap.nvim"
	use "phaazon/hop.nvim"

	use "ur4ltz/surround.nvim"

	-- use 'JASONews/glow-hover'

	use 'rmehri01/onenord.nvim'

	-- Treesitter
	use {
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	}
	use 'JoosepAlviste/nvim-ts-context-commentstring'
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
		requires = "nvim-treesitter/nvim-treesitter",
	})
	use 'nvim-treesitter/playground'
	use "kiyoon/treesitter-indent-object.nvim"
	use "kevinhwang91/nvim-bqf"

	use 'airblade/vim-rooter'

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
