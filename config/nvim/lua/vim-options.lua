vim.cmd("set number")
vim.cmd("set relativenumber")
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set cursorline")

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.cmd [[
      highlight Normal ctermbg=none guibg=none
      highlight NormalNC ctermbg=none guibg=none
      highlight EndOfBuffer ctermbg=none guibg=none
      highlight SignColumn ctermbg=none guibg=none
      highlight VertSplit ctermbg=none guibg=none
    ]]
  end
})


vim.g.mapleader = " "
