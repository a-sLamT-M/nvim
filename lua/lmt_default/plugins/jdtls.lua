return {
	'mfussenegger/nvim-jdtls',
 	config = function ()
		local c = {
			cmd = { vim.fn.expand('~/.local/share/nvim/mason/bin/jdtls')},
			root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1])
		}

		if vim.fn.has('win32') or vim.fn.has('win64') then
			c.cmd = { vim.fn.expand('~/AppData/Local/nvim-data/mason/bin/jdtls.cmd')}
		end

 		require('jdtls').start_or_attach(c)
 	end,
}
