local M = {}
local refresh_diagnostics = function(bufnr)
	bufnr = bufnr or 0
	local namespace_id = vim.api.nvim_create_namespace("SidelineDiagnosticsNamespace");
	vim.api.nvim_buf_clear_namespace(bufnr, namespace_id, 0, -1)

	local cur_line = vim.fn.line('.') - 1;
	local cur_col = vim.fn.col('.')


	local diagnostics = vim.diagnostic.get(0, { lnum = cur_line })

	local operation = function(a, b)
		return a - b
	end

	if (cur_line - #diagnostics < 0) then
		operation = function(a, b)
			return a + b
		end
	end

	for i, diagnostic in pairs(diagnostics) do
		if ((diagnostic.col < cur_col) and (cur_col <= diagnostic.end_col)) then
			vim.api.nvim_buf_set_extmark(0, namespace_id, operation(cur_line, i), 0,
				{
					virt_text = {
						{ diagnostic.message,
							"SideLineErrorActive" } },
					virt_text_pos = "right_align"
				})
			goto continue
		end
		vim.api.nvim_buf_set_extmark(0, namespace_id, operation(cur_line, i), 0,
			{
				virt_text = {
					{ diagnostic.message,
						"SideLineErrorInactive" } },
				virt_text_pos = "right_align"
			})
		::continue::
	end
end


local on_attach = function(bufnr)
	vim.api.nvim_clear_autocmds({buffer = bufnr, group = "SidelineDiagnosticsAugroup"})
	vim.api.nvim_create_autocmd(
		{ "CursorMoved", "CursorMovedI", "DiagnosticChanged" },
		{
			buffer = bufnr,
			group = "SidelineDiagnosticsAugroup",
			callback = function()
				refresh_diagnostics(bufnr);
			end
		}
	)
end

M.setup = function()

	vim.api.nvim_set_hl(0, "SideLineErrorInactive", {fg = "#bf616a"})
	vim.api.nvim_set_hl(0, "SideLineErrorActive",   {fg = "#bf616a", bg = "#434c5e"})

	vim.api.nvim_create_augroup('SidelineDiagnosticsAugroup', { clear = true })
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			on_attach(args.buf)
		end,
	})
end

return M;
