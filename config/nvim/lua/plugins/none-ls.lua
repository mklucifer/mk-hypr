return {
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					-- code actions
					null_ls.builtins.code_actions.textlint,

					-- completion
					null_ls.builtins.completion.luasnip,

					-- formatters
					null_ls.builtins.formatting.astyle,
					null_ls.builtins.formatting.black,
					null_ls.builtins.formatting.clang_format,
					null_ls.builtins.formatting.cmake_format,
					null_ls.builtins.formatting.csharpier,
					null_ls.builtins.formatting.isort,
					null_ls.builtins.formatting.prettier,
					null_ls.builtins.formatting.pyink,
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.uncrustify,
					null_ls.builtins.formatting.usort,

					-- diagnostics
					null_ls.builtins.diagnostics.checkmake,
					null_ls.builtins.diagnostics.cmake_lint,
					null_ls.builtins.diagnostics.cppcheck,
					null_ls.builtins.diagnostics.mypy,
					null_ls.builtins.diagnostics.pylint,
					null_ls.builtins.diagnostics.semgrep,
					null_ls.builtins.diagnostics.zsh,
				},
			})

			vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format document" })
		end,
	},
}
