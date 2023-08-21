require "user.options"
require "user.keymaps"
require "user.plugins"
require "user.colorscheme"
require "user.comment"
require "user.cmp"
require "user.lspc"
require "user.treesitter"
require "user.statusline"

require("user.sideline").setup()

MiniAi = require("mini.ai")
MiniAlign = require("mini.align")
MiniAnimate = require("mini.animate")
MiniBase16 = require("mini.base16")
MiniBufremove = require("mini.bufremove")
MiniBasics = require("mini.basics")
MiniBracketed = require("mini.bracketed")
MiniClue = require("mini.clue")
MiniColors = require("mini.colors")
MiniComment = require("mini.comment")
MiniCompletion = require("mini.completion")
MiniCursorword = require("mini.cursorword")
MiniDoc = require("mini.doc")
MiniFiles = require("mini.files")
MiniFuzzy = require("mini.fuzzy")
MiniHipatterns = require("mini.hipatterns")
MiniHues = require("mini.hues")
MiniIndentscope = require("mini.indentscope")
MiniJump = require("mini.jump")
MiniJump2d = require("mini.jump2d")
MiniMap = require("mini.map")
MiniMisc = require("mini.misc")
MiniMove = require("mini.move")
MiniPairs = require("mini.pairs")
MiniSessions = require("mini.sessions")
MiniSplitjoin = require("mini.splitjoin")
MiniStarter = require("mini.starter")
MiniStatusline = require("mini.statusline")
MiniSurround = require("mini.surround")
MiniTabline = require("mini.tabline")
MiniTest = require("mini.test")
MiniTrailspace = require("mini.trailspace")

local Plugins = {
	MiniAnimate,
	MiniAi,
	MiniMap,
	MiniBracketed,
	-- MiniComment,
	MiniPairs,
	MiniJump,
	MiniSurround,
	MiniJump2d,
	MiniIndentscope,
	MiniHipatterns,
	MiniTabline,
}

for _, mini in pairs(Plugins) do
	mini.setup()
end


local a = "#ffffff";


MiniHipatterns.setup({
	highlighters = {
		-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
		fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
		hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
		todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
		note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

		-- Highlight hex color strings (`#d500f0`) using that color
		hex_color = MiniHipatterns.gen_highlighter.hex_color(),
	},
})

local actions = require "fzf-lua.actions"
require('fzf-lua').setup {
	winopts = {
		row     = 1.0,
		col     = 0.0,
		height  = 0.35,
		width   = 1.0,
		border  = "none",
		split   = "belowright new", -- open in a bottom split
		preview = { hidden = "hidden" },
	},
	actions = {
		files = {
			["default"] = actions.file_edit,
			["ctrl-s"]  = actions.file_split,
			["ctrl-v"]  = actions.file_vsplit,
			["ctrl-t"]  = actions.file_tabedit,
			["alt-q"]   = actions.file_sel_to_qf,
			["alt-l"]   = actions.file_sel_to_ll,
		},
	},
	hl = {
		normal         = 'Define',     -- window normal color (fg+bg)
		border         = 'Define',     -- border color
		help_normal    = 'Normal',     -- <F1> window normal
		help_border    = 'Define',     -- <F1> window border
		-- Only used with the builtin previewer:
		cursor         = 'Cursor',     -- cursor highlight (grep/LSP matches)
		cursorline     = 'CursorLine', -- cursor line
		cursorlinenr   = 'CursorLineNr', -- cursor line number
		search         = 'IncSearch',  -- search matches (ctags|help)
		title          = 'Normal',     -- preview border title (file/buffer)
		-- Only used with 'winopts.preview.scrollbar = 'float'
		scrollfloat_e  = 'PmenuSbar',  -- scrollbar "empty" section highlight
		scrollfloat_f  = 'PmenuThumb', -- scrollbar "full" section highlight
		-- Only used with 'winopts.preview.scrollbar = 'border'
		scrollborder_e = 'FloatBorder', -- scrollbar "empty" section highlight
		scrollborder_f = 'FloatBorder', -- scrollbar "full" section highlight
	},
	fzf_colors = {
		["fg"]      = { "fg", "CursorLine" },
		["bg"]      = { "bg", "Normal" },
		["hl"]      = { "fg", "Comment" },
		["fg+"]     = { "fg", "Normal" },
		["bg+"]     = { "bg", "CursorLine" },
		["hl+"]     = { "fg", "Statement" },
		["info"]    = { "fg", "PreProc" },
		["prompt"]  = { "fg", "Conditional" },
		["pointer"] = { "fg", "Exception" },
		["marker"]  = { "fg", "Keyword" },
		["spinner"] = { "fg", "Label" },
		["header"]  = { "fg", "Comment" },
		["gutter"]  = { "bg", "Normal" },
	},
	fzf_opts = {
		['--pointer'] = '" "',
	}
}


function Prnt(arg)
	print(vim.inspect(arg))
end

vim.cmd([[
    autocmd FileType fzf resize 13
]])

require('neorg').setup {
	load = {
		["core.defaults"] = {}, -- Loads default behaviour
		["core.concealer"] = {}, -- Adds pretty icons to your documents
		["core.dirman"] = {    -- Manages Neorg workspaces
			config = {
				workspaces = {
					notes = "~/notes",
				},
			},
		},
	},
}


vim.opt.list = true
vim.opt.listchars:append "eol:⤵"
vim.opt.listchars:append "space:⋅"


local ranger_nvim = require("ranger-nvim")
ranger_nvim.setup({
	enable_cmds = false,
	replace_netrw = false,
	keybinds = {
		["<C-v>"] = ranger_nvim.OPEN_MODE.vsplit,
		["<C-s>"] = ranger_nvim.OPEN_MODE.split,
		["<C-t>"] = ranger_nvim.OPEN_MODE.tabedit,
		["<C-r>"] = ranger_nvim.OPEN_MODE.rifle,
	},
	ui = {
		border = { "╔", "═", "╗",
			"║", "╝", "═", "╚", "║" },
		height = 0.65,
		width = 0.65,
		x = 0.5,
		y = 0.5,
	}
})

require("dired").setup {
	path_separator = "/",
	show_banner = false,
	show_hidden = true,
	show_dot_dirs = true,
	show_colors = true,


}
