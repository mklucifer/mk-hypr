vim.g.mapleader = " "

-- buffers
vim.keymap.set("n", "<leader>n", ":bn<cr>")
vim.keymap.set("n", "<leader>p", ":bp<cr>")
vim.keymap.set("n", "<leader>x", ":bd<cr>")

-- Load up file in Markdown view
vim.keymap.set("n", "<leader>mp", ":MarkdownPreviewToggle<cr>")

-- Toggle comments on or off
vim.keymap.set({"n", "v"}, "<leader>/", ":CommentToggle<cr>")

-- Copy to clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
