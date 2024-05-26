-- NOTE: This is where your plugins related to LSP can be installed.
--  The configuration is done below. Search for lspconfig to find it below.
return {
	-- LSP Configuration & Plugins
	'neovim/nvim-lspconfig',
	dependencies = { -- Automatically install LSPs to stdpath for neovim
		{
			'VonHeikemen/lsp-zero.nvim',
			'williamboman/mason.nvim',
			config = true
		}, 'williamboman/mason-lspconfig.nvim', -- Useful status updates for LSP
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{
			'j-hui/fidget.nvim',
			opts = {}
		}, -- Additional lua configuration, makes nvim stuff amazing!
		'hrsh7th/nvim-cmp', 'folke/neodev.nvim'
	},
	config = function()
		require('mason').setup()
			-- Create your keybindings here...
		require('neodev').setup()

		local remap = require("lmt_default.remap")

		vim.api.nvim_create_autocmd('LspAttach', {
			group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
			callback = function(event)
				remap.map_lsp_keys(event)
				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--    See `:help CursorHold` for information about when this is executed
				--
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.server_capabilities.documentHighlightProvider then
					local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
					vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})
				end
			end
		})


		local on_attach = function(_, bufnr)
			-- NOTE: Remember that lua is a real programming language, and as such it is possible
			-- to define small helper and utility functions so you don't have to repeat yourself
			-- many times.
			--
			-- In this case, we create a function that lets us more easily define mappings specific
			-- for LSP related items. It sets the mode, buffer and description for us each time.
			local nmap = function(keys, func, desc)
				if desc then
					desc = 'LSP: ' .. desc
				end

				vim.keymap.set('n', keys, func, {
					buffer = bufnr,
					desc = desc
				})
			end


			-- Create a command `:Format` local to the LSP buffer
			vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
				vim.lsp.buf.format()
			end, {
				desc = 'Format current buffer with LSP'
			})
		end

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

		local mason_lspconfig = require 'mason-lspconfig'
		local servers = {
			-- clangd = {},
			-- gopls = {},
			-- pyright = {},
			-- rust_analyzer = {},
			-- tsserver = {}, html = { filetypes = { 'html', 'twig', 'hbs'} },

			lua_ls = {
				Lua = {
					workspace = {
						checkThirdParty = false
					},
					telemetry = {
						enable = false
					}
					-- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
					-- diagnostics = { disable = { 'missing-fields' } },
				}
			},

			pyright = {},
			jdtls = {},
			intelephense = {},
			tsserver = {},
			volar = {}
		}
		mason_lspconfig.setup {
			ensure_installed = vim.tbl_keys(servers)
		}

		mason_lspconfig.setup_handlers { function(server_name)
			if server_name == "jdtls" then 
				return;
			end
			require('lspconfig')[server_name].setup {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = servers[server_name],
				filetypes = (servers[server_name] or {}).filetypes
			}
		end }

		local cmp = require 'cmp'
		local luasnip = require 'luasnip'
		require('luasnip.loaders.from_vscode').lazy_load()
		luasnip.config.setup {}

		cmp.setup {
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end
			},
			completion = {
				completeopt = 'menu,menuone,noinsert'
			},
			mapping = cmp.mapping.preset.insert {
				['<C-n>'] = cmp.mapping.select_next_item(),
				['<C-p>'] = cmp.mapping.select_prev_item(),
				['<C-b>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete {},
				['<CR>'] = cmp.mapping.confirm {
					behavior = cmp.ConfirmBehavior.Replace,
					select = true
				},
				['<Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { 'i', 's' }),
				['<S-Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { 'i', 's' })
			},
			sources = { {
				name = 'nvim_lsp'
			}, {
				name = 'luasnip'
			}, {
				name = 'path'
			} }
		}
	end
};
