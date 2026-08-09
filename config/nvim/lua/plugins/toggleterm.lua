return {
  "akinsho/toggleterm.nvim",
  cmd = { "ToggleTerm", "TermExec" },
  keys = { "<C-\\>", "<C-'>", "<leader>'" },
  opts = {
    open_mapping = [[<c-\>]],
    direction = "float",
    shell = "/bin/zsh",
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    -- Match the global <C-h/j/k/l> window-nav mappings inside terminal buffers,
    -- and make it quick to drop back to Normal mode.
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "term://*toggleterm#*",
      callback = function(args)
        local map_opts = { buffer = args.buf }
        vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], map_opts)
        vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W><C-h>]], map_opts)
        vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W><C-j>]], map_opts)
        vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W><C-k>]], map_opts)
        vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W><C-l>]], map_opts)
      end,
    })

    -- A dedicated, persistent terminal for the `ai` alias (nvim-native
    -- counterpart to the tmux popup in bin/tmux-popup): toggling it closed
    -- doesn't kill the underlying job, just hides the window, so the
    -- conversation survives until this nvim instance quits. Scoped to this
    -- one nvim process only -- unlike the tmux version, it won't survive
    -- nvim exiting/crashing and isn't reachable from any other pane/session.
    -- `zsh -ic` (not a plain `cmd = "ai"`) is needed because toggleterm spawns
    -- via `termopen()`, which runs the command through a non-interactive
    -- `zsh -c`, and .zshrc (where the alias lives) is only sourced for
    -- interactive shells.
    local Terminal = require("toggleterm.terminal").Terminal
    local ai_term = Terminal:new({
      cmd = "zsh -ic 'ai'",
      direction = "float",
      hidden = true,
    })
    for _, lhs in ipairs({ "<C-'>", "<leader>'" }) do
      vim.keymap.set({ "n", "t" }, lhs, function()
        ai_term:toggle()
      end, { desc = "Toggle persistent ai (Claude) terminal" })
    end
  end,
}
