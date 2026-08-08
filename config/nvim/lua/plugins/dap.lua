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

      -- dap-repl ships with no syntax highlighting of its own, so the
      -- "✓ testName"/"✗ testName" lines jdtls's junit runner prints per
      -- result (see lua/jdtls/junit.lua) render as plain text. A `:syntax
      -- match` rule doesn't survive here -- dap.repl.open() re-triggers
      -- FileType on every call as part of its window setup, and Neovim's
      -- own filetype->syntax machinery resets buffer syntax state deep
      -- inside that dance (no traceable :syntax clear, just gone by the
      -- time open() returns). Extmarks applied per line as text arrives
      -- sidestep the legacy syntax engine entirely, so nothing can reset
      -- them from under us.
      local test_line_ns = vim.api.nvim_create_namespace("dap_repl_test_lines")
      local function highlight_test_lines(buf, firstline, new_lastline)
        for lnum = firstline, new_lastline - 1 do
          local line = vim.api.nvim_buf_get_lines(buf, lnum, lnum + 1, false)[1]
          local hl_group
          if line then
            if vim.startswith(line, "✓") then
              hl_group = "DiagnosticOk"
            elseif vim.startswith(line, "✗") then
              hl_group = "DiagnosticError"
            end
          end
          if hl_group then
            vim.api.nvim_buf_set_extmark(buf, test_line_ns, lnum, 0, {
              end_row = lnum + 1,
              hl_group = hl_group,
              hl_eol = true,
            })
          end
        end
      end

      -- q closes the dap-repl window. Normal-mode only, so it doesn't
      -- interfere with actually typing an expression into the prompt.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dap-repl",
        callback = function(args)
          vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = args.buf })

          -- open() re-fires FileType on every call, so guard against
          -- attaching this listener to the same buffer more than once.
          if vim.b[args.buf].dap_repl_test_colors_attached then
            return
          end
          vim.b[args.buf].dap_repl_test_colors_attached = true
          vim.api.nvim_buf_attach(args.buf, false, {
            on_lines = function(_, buf, _, firstline, _, new_lastline)
              highlight_test_lines(buf, firstline, new_lastline)
            end,
          })
        end,
      })
    end,
  },
}
