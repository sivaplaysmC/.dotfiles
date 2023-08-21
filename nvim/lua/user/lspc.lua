local custom_lsp_handlers = require("user.custom_lsp_handlers")
local nvim_lsp = require('lspconfig')
-- local vim = require("vim")




-- local myGroup = vim.api.nvim_create_augroup('SidelineDiagnosticsAugroup', { clear = true })
-- vim.api.nvim_create_autocmd(
-- 	{ "CursorMoved", "CursorMovedI" },
-- 	{
-- 		buffer = 0,
-- 		callback = function()
-- 			on_init(0);
-- 		end
-- 	}
-- )


local servers = {
	'pyright',
	'tsserver',
	'cssls',
	'html',
	'tailwindcss',
	'lua_ls',
	'emmet_ls',
	'clangd',
	'rust_analyzer',
	'cmake',
	'glslls',
}

local setup = function()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {

		virtual_text = false,
		-- show signs
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "single",
			source = "always",
			header = "float",
			prefix = "",
		},
	}



	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = custom_lsp_handlers.hover

	vim.lsp.handlers["textDocument/signatureHelp"] = custom_lsp_handlers.signature_help
	-- vim.lsp.handlers["textDocument/publishDiagnostics"] = on_diagnostics
end

local function lsp_highlight_document(client)
	-- Set autocommands conditional on server_capabilities
	local status_ok, illuminate = pcall(require, "illuminate")
	if not status_ok then
		return
	end
	illuminate.on_attach(client)
	-- end
end



local on_attach = function(client, bufnr)
	require("nvim-navic").attach(client, bufnr)
	vim.cmd [[TSEnable highlight]]

	setup()                      


	require "lsp_signature".on_attach({
			floating_window = false,
			hint_prefix = " ",
			hint_inline = function()
				return false
			end,
			handler_opts = {
				border = "none"
			},
		},
		bufnr)


	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local opts = { noremap = true, silent = true }

	--[[ require('lsp_signature').on_attach():so; ]]
	buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	-- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<space>cf', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}
end


nvim_lsp['lua_ls'].setup {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME\\lua")] = true,
					[vim.fn.stdpath("config") .. "\\lua"] = true,
					["/usr/share/awesome/lib"] = true,
				},
			},
		},
	}
}



--[[--
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    ]]
--
--
