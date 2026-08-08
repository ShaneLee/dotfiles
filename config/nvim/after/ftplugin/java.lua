-- Per-buffer jdtls setup. jdtls doesn't fit the normal global lspconfig
-- pattern (each project needs its own workspace dir + root-relative import
-- order), so it's started here rather than through lsp.lua.

vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true
vim.bo.textwidth = 100

local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then
  return
end

local jdtls_cmd = vim.fn.exepath("jdtls")
if jdtls_cmd == "" then
  -- Mason hasn't finished installing jdtls yet (first run); nothing to attach to.
  return
end

local root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts" })
if not root_dir then
  return
end

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-" .. project_name

-- Mason's jdtls package bundles a Lombok agent jar; without loading it as a
-- javaagent, jdtls can't see Lombok-generated methods (getters/setters/
-- builders/etc.) and reports them as errors. --jvm-arg is the jdtls launcher
-- wrapper's supported way to pass through raw JVM options (must use `=`).
local cmd = { jdtls_cmd, "-data", workspace_dir }
local lombok_jar = vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar"
if vim.uv.fs_stat(lombok_jar) then
  table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok_jar)
end

require("jdtls").start_or_attach({
  cmd = cmd,
  root_dir = root_dir,
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  settings = {
    java = {
      signatureHelp = { enabled = true },
      completion = {
        importOrder = require("util.jdtls_settings").import_order(root_dir),
      },
      configuration = {
        updateBuildConfiguration = "interactive",
      },
    },
  },
  on_attach = function(_, bufnr)
    -- Ported from the old .vim/ftplugin/java.vim FinalField(): insert `final`
    -- before the word under the cursor, then move down 2 lines.
    vim.keymap.set("n", "<leader>fa", function()
      vim.cmd("normal! 0ea final")
      vim.cmd("normal! jj")
    end, { buffer = bufnr })

    vim.keymap.set(
      "i",
      "<leader>cc",
      'private static final Clock CLOCK = Clock.fixed(Instant.parse("2020-06-04T14:30:30.000Z"), ZoneId.of("UTC"));',
      { buffer = bufnr }
    )
  end,
})

-- Organize imports on save (replaces the old vim-java-unused-imports plugin:
-- unused/missing imports now show as LSP diagnostics, fixed here automatically
-- on save, or manually via <leader>ca for other code actions).
--
-- jdtls's own organize_imports() applies the edit asynchronously, which lands
-- *after* :write already flushed the old content to disk (leaving the buffer
-- dirty again right after saving). Requesting synchronously in BufWritePre
-- applies the edit before the write proceeds, so the saved file is correct.
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.java",
  callback = function(args)
    local clients = vim.lsp.get_clients({ bufnr = args.buf, name = "jdtls" })
    if #clients == 0 then
      return
    end
    local client = clients[1]
    -- `0` is the "current window" sentinel here, not a bufnr (matches jdtls's
    -- own make_code_action_params helper, which this mirrors).
    local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
    params.context = { diagnostics = {} }
    local resp = client:request_sync("java/organizeImports", params, 2000, args.buf)
    if resp and resp.result then
      vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
    end
  end,
})
