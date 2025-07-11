vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Open file browser
vim.keymap.set("n", "-", ":Oil --float<cr>", {desc="Open parent directory in Oil"})

-- Copy to clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], {desc="Copy to clipboard"})

-- Comment/Uncomment lines
vim.keymap.set({"n", "v"}, "<leader>/", ":CommentToggle<cr>", {desc="Comment/Uncomment lines"})
