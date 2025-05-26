-- plugins/dap.lua
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = { "williamboman/mason.nvim", "jay-babu/mason-nvim-dap.nvim" },
    config = function()
      require("mason-nvim-dap").setup {
        ensure_installed = { "python", "js-debug-adapter" },
      }
      local dap = require("dap")
      -- Python adapter
      dap.adapters.python = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/bin/python",
        args = { "-m", "debugpy.adapter" },
      }
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            return vim.fn.getenv("VIRTUAL_ENV")
              and vim.fn.getcwd() .. "/.venv/bin/python"
              or "python"
          end,
        },
      }
    end,
  },
}

