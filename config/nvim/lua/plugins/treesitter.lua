-- nvim-treesitter's "main" branch (the current, actively-developed API as of
-- this writing) replaces the old `.configs` module with `.setup()`/`.install()`
-- plus an explicit `vim.treesitter.start()` per filetype.

-- Parser names (for :TSInstall) vs. filetype names (for the FileType autocmd)
-- differ for a few of these (vimdoc->help, bash->sh, tsx->typescriptreact).
local parsers = {
  "java", "python", "lua", "vim", "vimdoc", "bash",
  "json", "yaml", "markdown", "typescript", "tsx", "javascript",
}
local filetypes = {
  "java", "python", "lua", "vim", "help", "sh",
  "json", "yaml", "markdown", "typescript", "typescriptreact", "javascript",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter").setup()
    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = filetypes,
      callback = function(args)
        -- pcall guards the first-ever launch, where a parser may still be
        -- downloading/compiling asynchronously from the `install()` call above.
        if pcall(vim.treesitter.start, args.buf) then
          vim.wo.foldmethod = "expr"
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.bo[args.buf].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
        end
      end,
    })
  end,
}
