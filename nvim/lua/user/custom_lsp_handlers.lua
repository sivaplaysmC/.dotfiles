local M = {}

local validate = vim.validate
local api = vim.api

local npcall = vim.F.npcall


local util = require("vim.lsp.util")



local function find_window_by_var(name, value)
  for _, win in ipairs(api.nvim_list_wins()) do
    if npcall(api.nvim_win_get_var, win, name) == value then
      return win
    end
  end
end


local function close_preview_window(winnr, bufnrs)
  vim.schedule(function()
    -- exit if we are in one of ignored buffers
    if bufnrs and vim.tbl_contains(bufnrs, api.nvim_get_current_buf()) then
      return
    end

    local augroup = 'preview_window_' .. winnr
    pcall(api.nvim_del_augroup_by_name, augroup)
    pcall(api.nvim_win_close, winnr, true)
  end)
end


local function close_preview_autocmd(events, winnr, bufnrs)
  local augroup = api.nvim_create_augroup('preview_window_' .. winnr, {
    clear = true,
  })

  -- close the preview window when entered a buffer that is not
  -- the floating window buffer or the buffer that spawned it
  api.nvim_create_autocmd('BufEnter', {
    group = augroup,
    callback = function()
      close_preview_window(winnr, bufnrs)
    end,
  })

  if #events > 0 then
    api.nvim_create_autocmd(events, {
      group = augroup,
      buffer = bufnrs[2],
      callback = function()
        close_preview_window(winnr)
      end,
    })
  end
end


local function make_floating_popup_options(_, height, opts)
  validate({
    opts = { opts, 't', true },
  })
  opts = opts or {}
  validate({
    ['opts.offset_x'] = { opts.offset_x, 'n', true },
    ['opts.offset_y'] = { opts.offset_y, 'n', true },
  })

  return {
    col = 0,
    height = height,
    focusable = opts.focusable,
    relative = "editor",
    row = vim.o.lines - height,
    style = 'minimal',
    width = vim.o.columns,
    border = "none",
    zindex = opts.zindex or 50,
  }
end



local function open_floating_preview(contents, syntax, opts, height)
  validate({
    contents = { contents, 't' },
    syntax = { syntax, 's', true },
    opts = { opts, 't', true },
  })
  opts = opts or {}
  opts.wrap = opts.wrap ~= false -- wrapping by default
  opts.stylize_markdown = opts.stylize_markdown ~= false and vim.g.syntax_on ~= nil
  opts.focus = opts.focus ~= false
  opts.close_events = opts.close_events or { 'CursorMoved', 'CursorMovedI', 'InsertCharPre' }

  local bufnr = api.nvim_get_current_buf()

  -- check if this popup is focusable and we need to focus
  if opts.focus_id and opts.focusable ~= false and opts.focus then
    -- Go back to previous window if we are in a focusable one
    local current_winnr = api.nvim_get_current_win()
    if npcall(api.nvim_win_get_var, current_winnr, opts.focus_id) then
      api.nvim_command('wincmd p')
      return bufnr, current_winnr
    end
    do
      local win = find_window_by_var(opts.focus_id, bufnr)
      if win and api.nvim_win_is_valid(win) and vim.fn.pumvisible() == 0 then
        -- focus and return the existing buf, win
        api.nvim_set_current_win(win)
        api.nvim_command('stopinsert')
        return api.nvim_win_get_buf(win), win
      end
    end
  end

  -- check if another floating preview already exists for this buffer
  -- and close it if needed
  local existing_float = npcall(api.nvim_buf_get_var, bufnr, 'lsp_floating_preview')
  if existing_float and api.nvim_win_is_valid(existing_float) then
    api.nvim_win_close(existing_float, true)
  end

  local floating_bufnr = api.nvim_create_buf(false, true)
  local do_stylize = syntax == 'markdown' and opts.stylize_markdown


  if do_stylize then
    -- applies the syntax and sets the lines to the buffer
    contents = util.stylize_markdown(floating_bufnr, contents, opts)
  else
    if syntax then
      api.nvim_buf_set_option(floating_bufnr, 'syntax', syntax)
    end
    api.nvim_buf_set_lines(floating_bufnr, 0, -1, true, contents)
  end
  api.nvim_buf_set_lines(floating_bufnr, 0, -1, true, contents)

  -- Compute size of float needed to show (wrapped) lines
  if opts.wrap then
    opts.wrap_at = opts.wrap_at or api.nvim_win_get_width(0)
  else
    opts.wrap_at = nil
  end

  local float_option = make_floating_popup_options(nil, height, opts)
  local floating_winnr = api.nvim_open_win(floating_bufnr, false, float_option)
  if do_stylize then
    api.nvim_win_set_option(floating_winnr, 'conceallevel', 2)
    api.nvim_win_set_option(floating_winnr, 'concealcursor', 'n')
  end
  -- disable folding
  api.nvim_win_set_option(floating_winnr, 'foldenable', false)
  -- soft wrapping
  api.nvim_win_set_option(floating_winnr, 'wrap', opts.wrap)

  api.nvim_buf_set_option(floating_bufnr, 'modifiable', false)
  api.nvim_buf_set_option(floating_bufnr, 'bufhidden', 'wipe')
  api.nvim_buf_set_keymap(
    floating_bufnr,
    'n',
    'q',
    '<cmd>bdelete<cr>',
    { silent = true, noremap = true, nowait = true }
  )
  close_preview_autocmd(opts.close_events, floating_winnr, { floating_bufnr, bufnr })

  -- save focus_id
  if opts.focus_id then
    api.nvim_win_set_var(floating_winnr, opts.focus_id, bufnr)
  end
  api.nvim_buf_set_var(bufnr, 'lsp_floating_preview', floating_winnr)

  return floating_bufnr, floating_winnr
end



function M.hover(_, result, ctx, config)
  config = config or {}
  config.focus_id = ctx.method
  if api.nvim_get_current_buf() ~= ctx.bufnr then
    -- Ignore result since buffer changed. This happens for slow language servers.
    return
  end
  if not (result and result.contents) then
    if config.silent ~= true then
      vim.notify('No information available')
    end
    return
  end
  local markdown_lines = util.convert_input_to_markdown_lines(result.contents)
  markdown_lines = util.trim_empty_lines(markdown_lines)




  if vim.tbl_isempty(markdown_lines) then
    if config.silent ~= true then
      vim.notify('No information available')
    end
    return
  end
  return open_floating_preview(markdown_lines, 'markdown', config, 12)
end

function M.signature_help(_, result, ctx, config)
  config = config or {}
  config.focus_id = ctx.method
  if api.nvim_get_current_buf() ~= ctx.bufnr then
    -- Ignore result since buffer changed. This happens for slow language servers.
    return
  end
  -- When use `autocmd CompleteDone <silent><buffer> lua vim.lsp.buf.signature_help()` to call signatureHelp handler
  -- If the completion item doesn't have signatures It will make noise. Change to use `print` that can use `<silent>` to ignore
  if not (result and result.signatures and result.signatures[1]) then
    if config.silent ~= true then
      print('No signature help available')
    end
    return
  end
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  local triggers =
      vim.tbl_get(client.server_capabilities, 'signatureHelpProvider', 'triggerCharacters')
  local ft = api.nvim_buf_get_option(ctx.bufnr, 'filetype')
  local lines, hl = util.convert_signature_help_to_markdown_lines(result, ft, triggers)
  lines = util.trim_empty_lines(lines)
  if vim.tbl_isempty(lines) then
    if config.silent ~= true then
      print('No signature help available')
    end
    return
  end
  local fbuf, fwin = open_floating_preview(lines, 'markdown', config, 2)
  if hl then
    api.nvim_buf_add_highlight(fbuf, -1, 'LspSignatureActiveParameter', 0, unpack(hl))
  end
  return fbuf, fwin
end

return M;
