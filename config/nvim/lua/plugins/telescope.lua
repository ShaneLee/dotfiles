return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  cmd = "Telescope",
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    telescope.setup({
      defaults = {
        vimgrep_arguments = {
          "rg", "--color=never", "--no-heading", "--with-filename",
          "--line-number", "--column", "--smart-case", "--hidden",
          "--glob", "!.git",
        },
        -- Telescope's own defaults leave <C-j>/<C-k> as a no-op / preview-scroll
        -- in insert mode (only <C-n>/<C-p> and the arrows move the selection by
        -- default) -- rebind them to the more familiar vim-style up/down.
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          },
        },
      },
    })
    pcall(telescope.load_extension, "fzf")
  end,
}
