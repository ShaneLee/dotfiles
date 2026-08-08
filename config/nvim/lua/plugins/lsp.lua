return {
  {
    "williamboman/mason.nvim",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- cucumber_language_server's built-in defaults already look for features
      -- under src/test/**/*.feature and glue (step definitions) under
      -- src/test/**/*.java, which matches every Cucumber-JVM project on this
      -- machine with no extra settings needed -- *except* that its default
      -- root marker is just .git, which breaks for a Gradle/Maven module
      -- nested inside a larger monorepo (e.g. ~/dev/sorg/server, whose .git
      -- is two levels up at ~/dev/sorg): the globs then get evaluated from
      -- the wrong root and never reach the module's own src/test. Widening
      -- root_markers to also stop at a build file finds the actual module
      -- root first, same fix as jdtls uses in after/ftplugin/java.lua.
      vim.lsp.config("cucumber_language_server", {
        root_markers = { "pom.xml", "build.gradle", "build.gradle.kts", "mvnw", "gradlew", ".git" },
      })

      require("mason-lspconfig").setup({
        -- It attaches to filetype "cucumber", which config/autocmds.lua
        -- already maps *.feature to.
        ensure_installed = { "pyright", "ruff", "lua_ls", "cucumber_language_server" },
        -- jdtls is started manually per-buffer via nvim-jdtls in
        -- after/ftplugin/java.lua (needs custom root_dir/workspace/settings),
        -- so it must not be auto-enabled through the generic handler here.
        automatic_enable = { exclude = { "jdtls" } },
      })
    end,
  },
}
