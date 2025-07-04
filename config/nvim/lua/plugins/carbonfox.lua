return {
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    name = "nightfox",
    priority = 1000,

    config = function()
      require("nightfox").setup({
        options = {
          transparent = true,
        },
        palettes = {
          carbonfox = { -- bg0 = "#000000",  -- main background
                  bg1 = "#000000",  -- lighter sections
                  -- bg2 = "#000000",  -- panel, floating windows
                  -- bg3 = "#000000",  -- cursorline, statusline
                  -- bg4 = "#000000",  -- conceal / folded text
          },
        },
      })
      vim.cmd.colorscheme "carbonfox"
    end
  }
}
