local M = {}

function M.to_normal()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, true, true), 'n', true)
end


function M.to_visual()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>v', true, true, true), 'n', true)
end

return M
