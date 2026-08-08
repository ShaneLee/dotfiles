return {
  {
    "mfussenegger/nvim-dap",
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dapui = require("dapui")
      dapui.setup()

      -- Auto open/close the UI around a debug session, same as most IDEs.
      -- dap-repl is opened separately from dapui.open(): it's nvim-dap's own
      -- REPL buffer, not one of dapui's panels, and it's specifically where
      -- jdtls's junit runner (see lua/plugins/jdtls.lua) prints test results
      -- ("Tests finished. Results printed to dap-repl.") -- without this it
      -- never surfaces on its own, so the results are easy to miss entirely.
      local dap = require("dap")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
        require("dap.repl").open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close

      -- q closes the dap-repl window. Normal-mode only, so it doesn't
      -- interfere with actually typing an expression into the prompt.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dap-repl",
        callback = function(args)
          vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = args.buf })
        end,
      })
    end,
  },
}
