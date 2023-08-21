myBlah = function(a, b, c)
end
local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

local navic = require("nvim-navic")

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local current_signature = function(width)
  local sig = require("lsp_signature").status_line(width)
  return sig.label .. "🐼" .. sig.hint
end

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = { error = " ", warn = " " },
  colored = false,
  update_in_insert = false,
  always_visible = true,
}

local diff = {
  "diff",
  colored = true,
  symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width
}

local mode = {
  "mode",
  fmt = function(str)
    return str:gsub("^%l", string.upper)
  end,
}

local filetype = {
  "filetype",
  icons_enabled = false,
  icon = nil,
}

local branch = {
  "branch",
  icons_enabled = true,
  icon = "",
}

local location = {
  "location",
  padding = 1,
}

-- cool function for progress
local progress = function()
  local current_line = vim.fn.line(".")
  local total_lines = vim.fn.line("$")
  local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
  local line_ratio = current_line / total_lines
  local index = math.ceil(line_ratio * #chars)
  return chars[index]
end

local spaces = function()
  return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local lsp_signature = require("lsp_signature")

local PreHint = {
  function()
    -- return "Pre"
    local signature = lsp_signature.status_line(800);
    return signature.label:sub(1, signature.range["start"] - 1);
  end,
  padding = { left = 1, right = 0 },
  separator = { left = '', right = '' }
}


local Hint = {
  function()
    -- return "Hint"
    local signature = lsp_signature.status_line(800);
    return signature.label:sub(signature.range["start"], signature.range["end"]);
  end,
  padding = { left = 0, right = 0 },
  separator = { left = '', right = '' },
  color = { bg = "#4c566a" }
}

local PostHint = {
  function()
    -- return "Post"
    local signature = lsp_signature.status_line(800);
    return signature.label:sub(signature.range["end"] + 1, -1);
  end,
  padding = { left = 0, right = 1 },
  separator = { left = '', right = '' }
}


lualine.setup({
  options = {
    icons_enabled = true,
    theme = "nord",
    -- component_separators = { left = '', right = '' },
    -- section_separators = { left = '', right = '' },
    -- component_separators = '',
    -- section_separators = { left = '', right = '' },


    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { branch, diagnostics },
    lualine_b = { mode },
    lualine_c = { PreHint, Hint, PostHint },
    lualine_x = { diff, spaces, filetype },
    lualine_y = { location },
    lualine_z = { progress },
  },


  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  winbar = {
    lualine_a = {
      {
        "filename",
        fmt = function(str)
          return "File: " .. str
        end
      }
    },
    lualine_b = {},
    lualine_c = {
      {
        function()
          if navic.is_available() then
            return navic.get_location()
          else
            return ""
          end
        end,
        draw_empty = true,
        color = 'NormalFloat'
      }
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  inactive_winbar = {
    lualine_a = {
      {
        "filename",
        fmt = function(str)
          return "File: " .. str
        end
      }

    },
    lualine_b = {},
    lualine_c = {
      {
        function()
          if navic.is_available() then
            return navic.get_location()
          else
            return ""
          end
        end,
        draw_empty = true,
        color = 'NormalFloat'
      }
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },

  tabline = {},
  extensions = {},
})
