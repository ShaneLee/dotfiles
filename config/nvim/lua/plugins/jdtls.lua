return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    -- Ensure the jdtls launcher is installed via Mason. It's intentionally not
    -- part of mason-lspconfig's ensure_installed (see lua/plugins/lsp.lua) since
    -- it's started manually per-buffer here, not through the generic handler.
    local ok, registry = pcall(require, "mason-registry")
    if ok then
      local installed_ok, pkg = pcall(registry.get_package, "jdtls")
      if installed_ok and not pkg:is_installed() then
        pkg:install()
      end
    end
  end,
}
