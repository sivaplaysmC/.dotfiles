local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup {
  ensure_installed = { "" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  sync_install = false,      -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { "" },   -- List of parsers to ignore installing
  autopairs = {
    enable = true,
  },
  highlight = {
    enable = true,    -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true, disable = { "yaml" } },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  textobjects = {
    select = {
      enable = true,

      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",

        ["aC"] = "@class.outer",
        ["iC"] = "@class.inner",

        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",

        ["a/"] = "@comment.outer",
        ["i/"] = "@comment.inner",

        ["ac"] = "@conditional.outer",
        ["ic"] = "@conditional.inner",

        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",

      },
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V',  -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      include_surrounding_whitespace = false,
    },

    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]a"] = "@paramater.inner",
        ["]d"] = "@conditional.outer",
      },
      goto_previous_start = {
        ["[a"] = "@paramater.inner",
        ["[d"] = "@conditional.outer",
      },
      goto_next = {
      },
      goto_previous = {
      }
    },

    lsp_interop = {
      enable = true,
      border = 'single',
      floating_preview_opts = {},
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },


  },

  playground = {
    enable = true,
    disable = {},
    updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
}

