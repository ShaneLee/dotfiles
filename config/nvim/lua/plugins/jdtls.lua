return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
  config = function()
    -- Ensure the jdtls launcher and its debug adapter are installed via
    -- Mason. jdtls itself is started manually per-buffer (not through
    -- mason-lspconfig's ensure_installed in lua/plugins/lsp.lua), and
    -- java-debug-adapter is a plain jar bundle wired into it via
    -- init_options in after/ftplugin/java.lua, not an LSP server itself.
    local ok, registry = pcall(require, "mason-registry")
    if ok then
      for _, name in ipairs({ "jdtls", "java-debug-adapter" }) do
        local installed_ok, pkg = pcall(registry.get_package, name)
        if installed_ok and not pkg:is_installed() then
          pkg:install()
        end
      end
    end

    -- The JUnit test-runner (vscode-java-test) bundle is deliberately
    -- *not* Mason-managed -- see util/java_test_bundles.lua for the full
    -- story on why (ASM version drift between jdtls and java-test releases,
    -- plus Mason itself serving stale cached jar content in practice) and
    -- what to do if this ever needs re-pinning. Fetched (once, cached
    -- after) into stdpath("data") rather than committed into this repo, so
    -- the dotfiles repo itself stays free of binary blobs.
    require("util.java_test_bundles").ensure_installed(
      vim.fn.stdpath("data") .. "/java-test-bundles/" .. require("util.java_test_bundles").VERSION
    )
  end,
}
