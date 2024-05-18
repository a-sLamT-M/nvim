-- [[ Basic Keymaps ]]
local M = {}
local utils = require('lmt_default.utils')

function M.init()
	local map = vim.keymap;
	local _map = function(type, keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end
		map.set(type, keys, func, { desc = desc })
	end

	local imap = function(keys, func, desc)
		_map('i', keys, func, desc)
	end

	local vmap = function(keys, func, desc)
		_map('v', keys, func, desc)
	end

	local nmap = function(keys, func, desc)
		_map('n', keys, func, desc);
	end
	local map_all = function(keys, func, desc)
		nmap(keys, func, desc)
		vmap(keys, func, desc)
		imap(keys, func, desc)
	end
	vim.cmd('source ' .. vim.env.HOME .. '/.vimrc')

	-- redo
	map.set('n', '<C-A-z>', '<C-r>')
	map.set('v', '<C-A-z>', '<C-r>')
	map.set('i', '<C-A-z>', '<C-r>')


	-- Keymaps for better default experience
	-- See `:help vim.keymap.set()`
	map.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

	-- Remap for dealing with word wrap
	map.set('n', 'i', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
	map.set('n', 'k', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
	-- Diagnostic keymaps
	map.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
	map.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
	map.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
	map.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

	-- netrw
	map.set('n', '<leader>pv', vim.cmd.Ex)
	map.set('n', '<leader>q', vim.cmd.Ex)

	-- telescope
	local function telescope_live_grep_open_files()
		require('telescope.builtin').live_grep {
			grep_open_files = true,
			prompt_title = 'Live Grep in Open Files',
		}
	end

	map.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
	map.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
	map.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
	map.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
	map.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
	map.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
	map.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
	map.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
	map.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
	map.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

	vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
	-- vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
	vim.keymap.set('n', '<leader>/', function()
		-- You can pass additional configuration to telescope to change theme, layout, etc.
		require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
			winblend = 10,
			previewer = false,
		})
	end, { desc = '[/] Fuzzily search in current buffer' })



	-- Harpoon
	local harpoon = require('harpoon')

	vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
	vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

	vim.keymap.set("n", "<C-1>", function() harpoon:list():select(1) end)
	vim.keymap.set("n", "<C-2>", function() harpoon:list():select(2) end)
	vim.keymap.set("n", "<C-3>", function() harpoon:list():select(3) end)
	vim.keymap.set("n", "<C-4>", function() harpoon:list():select(4) end)


	-- undotree
	nmap("<leader>u", vim.cmd.UndotreeToggle)

	-- visual mode
	vim.keymap.set("v", "K", ":m '>+1<CR>gv=gv")
	vim.keymap.set("v", "I", ":m '<-2<CR>gv=gv")

	-- reformat
	imap("<C-A-l>", function ()
		vim.lsp.buf.format({
			async = true
		}) 
		utils.to_normal()
	end)

	-- reformat
	nmap("<C-A-l>", function ()
		vim.lsp.buf.format({
			async = true
		})
	end)

	-- panes
	nmap("<leader>sh", function ()
		vim.api.nvim_command("split h")
	end)

	nmap("<leader>sv", function ()
		vim.api.nvim_command("split v")
	end)

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "netrw",
		callback = function ()
			vim.keymap.set('n', 'i', 'k', {buffer = true})
		end
	})
end

-- lsp
function M.map_lsp_keys(event)
	local __map = function(keys, func, desc)
		vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
	end
	-- Lesser used LSP functionality
	__map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
	__map('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
	__map('<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, '[W]orkspace [L]ist Folders')
	__map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
	__map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
	__map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
	__map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
	__map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
	__map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
	__map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
	__map('<leader>r', vim.lsp.buf.code_action, '[C]ode [A]ction')
	__map('h', vim.lsp.buf.hover, 'Hover Documentation')
	__map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
	__map('<C-h>', vim.lsp.buf.signature_help, 'Signature Documentation')
end



return M;
