vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Open file browser
vim.keymap.set("n", "-", ":Oil --float<cr>", { desc = "Open parent directory in Oil" })

-- Copy to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to clipboard" })

-- Comment/Uncomment lines
vim.keymap.set({ "n", "v" }, "<leader>/", ":CommentToggle<cr>", { desc = "Comment/Uncomment lines" })

-- Get diagnostics info in a floating window
vim.keymap.set("n", "gl", function()
	vim.diagnostic.open_float()
end, { desc = "Show diagnostic in floating window" })

-- Format code
vim.keymap.set("n", "<leader>cf", function()
	require("conform").format()
end, { desc = "Format current file" })
