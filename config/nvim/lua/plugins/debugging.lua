return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio"
  },
  config = function()
    require("dap-python").setup("debugpy-adapter") -- or python3 instead of debugpy-adapter
    
    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
    
    vim.keymap.set('n', '<Leader>db', dap.toggle_breakpoint() {})
    vim.keymap.set('n', '<Leader>dc', dap.continue() {})
  end
}
