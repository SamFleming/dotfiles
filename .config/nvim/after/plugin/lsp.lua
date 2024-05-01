local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({buffer = bufnr})
end)

lsp_zero.setup_servers({'tsserver'})

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
-- local cmp_select = {behavior = cmp.SelectBehavior.Select}
-- local cmp_mappings = lsp_zero.defaults.cmp_mappings({
-- 	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
-- 	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
-- 	['<C-y>'] = cmp.mapping.confirm({ select = true }),
-- 	['<C-Space>'] = cmp.mapping.complete(),
-- })
cmp.setup({
	mapping = cmp.mapping.preset.insert({
		-- Enter to confirm completion
		['<CR>'] = cmp.mapping.confirm({select = false}),

		-- Ctrl+Space to trigger completion menu
		['<C-Space>'] = cmp.mapping.complete(),

		-- Navigate between snippet placeholder
		['<C-f>'] = cmp_action.luasnip_jump_forward(),
		['<C-b>'] = cmp_action.luasnip_jump_forward(),

		-- Scroll up and down in the completion documentation
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
	})
})

require("mason").setup()
require("mason-lspconfig").setup {
	ensure_installed = {
		'tsserver',
		'eslint',
		'lua_ls',
		'intelephense',
		'bashls',
		'cssls',
		'cucumber_language_server',
		'dockerls',
		'docker_compose_language_service',
		'graphql',
		'html',
		'jsonls',
		'autotools_ls',
		'marksman'
	},

	handlers = {
		lsp_zero.default_setup,
	},
}

-- require('lspconfig').intelephense.setup({})
