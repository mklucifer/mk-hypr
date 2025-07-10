return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio"
  },
  config = function()
    local dap = require("dap)
    vim.keymap.set('n', '<Leader>db', dap.toggle_breakpoint() {})
    vim.keymap.set('n', '<Leader>dc', dap.continue() {})
  end
}
