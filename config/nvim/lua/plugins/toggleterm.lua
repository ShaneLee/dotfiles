return {
  "akinsho/toggleterm.nvim",
  cmd = { "ToggleTerm", "TermExec" },
  keys = { "<C-\\>" },
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
  end,
}
