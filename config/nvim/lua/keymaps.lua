vim.g.mapleader = " "
vim.keymap.set("n", "<leader>n", ":bn<cr>")
vim.keymap.set("n", "<leader>p", ":bp<cr>")
vim.keymap.set("n", "<leader>x", ":bd<cr>")

vim.keymap.set("n", "<leader>mp", ":MarkdownPreviewToggle<cr>")
vim.keymap.set({"n", "v"}, "<leader>/", ":CommentToggle<cr>")
