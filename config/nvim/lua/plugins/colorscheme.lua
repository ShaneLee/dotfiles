return {
  "ellisonleao/gruvbox.nvim",
  enabled = true,
  lazy = false,
  priority = 1000,
  config = function()
    require("gruvbox").load()
  end,
}
