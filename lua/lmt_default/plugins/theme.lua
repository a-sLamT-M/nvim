
function SetTheme(color)
  color = color or "vscode"
  vim.cmd.colorscheme(color)
  vim.api.nvim_set_hl(0, "Normal", { bg = "none"})
  vim.api.nvim_set_hl(0, "NormalFLoat", { bg = "none"})
end


return {
  {
      'Mofiqul/vscode.nvim',
      lazy = false,
      config = function()
        SetTheme("vscode")
      end,
  },
}
