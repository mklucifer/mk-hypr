return {
	"goolord/alpha-nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		vim.g.startuptime = vim.loop.hrtime()

		-- Set header
		dashboard.section.header.val = {
			[[                                                                       ]],
			[[                                                                     ]],
			[[       ████ ██████           █████      ██                     ]],
			[[      ███████████             █████                             ]],
			[[      █████████ ███████████████████ ███   ███████████   ]],
			[[     █████████  ███    █████████████ █████ ██████████████   ]],
			[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
			[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
			[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
			[[                                                                       ]],
		}

		dashboard.section.header.opts.hl = "AlphaHeader"

		vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#89bffa", bold = true })

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("e", "📄  New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("f", "🔍  Find file", ":Telescope find_files <CR>"),
			dashboard.button("c", "⚙️  Open Config (~/.config/nvim)", ":e ~/.config/nvim<CR>"),
			dashboard.button("l", "📦  Lazy Plugin Manager", ":Lazy<CR>"),
			dashboard.button("m", "🧱  Mason Package Manager", ":Mason<CR>"),
			dashboard.button("q", "🚪  Quit Neovim", ":qa<CR>"),
		}
		local function footer()
			-- Footer
			local datetime = os.date("   📅 %Y-%m-%d       ⏰ %H:%M:%S")

			-- Neovim
			local version = vim.version()
			local nvim_version =
			string.format("	  🧪 Neovim           v%d.%d.%d", version.major, version.minor, version.patch)

			-- Lazy
			local lazy_plugins = require("lazy").stats()
			local lazy_info = string.format("	  📦 Lazy Plugins     %d", lazy_plugins.count)

			-- Mason LSP
			local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
			local handle = io.popen("ls -1 " .. mason_path .. " 2>/dev/null | wc -l")
			local lsp_count = handle and handle:read("*n") or 0
			if handle then
				handle:close()
			end
			local mason_info = string.format("	  🔧 Mason LSPs       %d", lsp_count)

			return {
				"",
				datetime,
				"",
				nvim_version,
				"",
				lazy_info,
				"",
				mason_info,
				"",
			}
		end

		-- Set footer
		dashboard.section.footer.val = footer()
		dashboard.section.footer.opts = {
			position = "center",
		}
		dashboard.section.footer.opts.hl = "Constant"
		require("alpha").setup(dashboard.config)
		alpha.setup(dashboard.opts)

		vim.cmd([[
	    autocmd FileType alpha setlocal nofoldenable
	    ]])
	end,
}
