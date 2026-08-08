-- Ported from dotfiles/.vimrc "Mappings", plus new LSP/telescope/gitsigns bindings

local fn = require("config.functions")
local map = vim.keymap.set

-- Telescope-backed fuzzy find (replaces :Files via fzf)
map("n", "<C-p>", function() require("telescope.builtin").find_files() end)
map("n", "<leader>f", function() require("telescope.builtin").live_grep() end)

map("n", "<leader>h", "<cmd>nohlsearch<CR>")
map("n", "<leader><space>", fn.find_file_by_word)

-- Reformat: filetype-aware, falls back to the original formatprg macro (gg VG gq)
local function format_buffer()
  local ft = vim.bo.filetype
  if ft == "java" then
    vim.lsp.buf.format({ async = false })
  elseif ft == "python" then
    local ok, conform = pcall(require, "conform")
    if ok then
      conform.format({ lsp_fallback = false })
    end
  else
    vim.cmd('normal! mqggVGgq`q')
  end
end
map("n", "<leader>l", format_buffer)

map("n", "<leader>g", ":silent grep ", { silent = false })
map("n", "<leader>gg", "<cmd>Goyo<CR>")
map("n", "<leader>s", ":%s/", { silent = false })
map("n", "<leader>w", fn.search_current_word)
map("v", "<leader>w", fn.search_visual_selection)
map("n", "<leader>c", "<cmd>cclose<CR>")
map("n", "<leader><CR>", fn.file_name_cmd)
map("n", "<leader>r", fn.file_cmd)
map("n", "<leader>t", fn.test_under_cursor)
map("n", "<C-t>", fn.test_under_cursor)
map("n", "<leader>n", fn.rename_file)
map("n", "<leader>ac", ":%y+<CR>")
map("n", "<leader>jq", ":%!jq .<CR>")
map("n", "<leader>nt", fn.insert_current_time)
map("n", "<leader>u", fn.insert_uuid)
map("v", "<leader>u", fn.insert_uuids_visual)

-- Go-to-definition with ctags fallback (repurposed from redundant buffer-nav)
--
-- :tag throws E426 ("Tag not found") when the word under the cursor isn't in
-- the tags file, which without pcall surfaces as a raw error message instead
-- of failing quietly (noticeable in non-Java files, where there's no LSP to
-- take the primary path and this fallback runs on every press). When that
-- happens, fall through to the same word/grep search <leader>w uses, so the
-- key still does *something* useful instead of just failing silently.
local function try_tag_jump(word)
  local ok = pcall(vim.cmd, "tag " .. word)
  if not ok then
    vim.notify("No tag found for '" .. word .. "', searching instead", vim.log.levels.INFO)
    fn.search_current_word()
  end
end

local function goto_definition()
  if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
    vim.lsp.buf.definition()
  else
    local word = vim.fn.expand("<cword>")
    if word ~= "" then
      try_tag_jump(word)
    end
  end
end
map("n", "<leader>]", goto_definition)

-- Jump back from a <leader>]/<C-]> jump: pop the tag stack (undoes the last
-- go-to-definition/references jump) if there is one, else fall back to
-- <C-o> (older position in the plain jumplist).
local function jump_back()
  local ok = pcall(vim.cmd, "pop")
  if not ok then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>", true, false, true), "n", false)
  end
end
map("n", "<leader>[", jump_back)

-- <C-]>: go to definition, unless the cursor is already sitting on the
-- definition, in which case show all usages/references instead (Telescope
-- picker). Falls back to ctags (plain jump, no "already there" smarts) when
-- no LSP client is attached.
local function goto_definition_or_references()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    local word = vim.fn.expand("<cword>")
    if word ~= "" then
      try_tag_jump(word)
    end
    return
  end

  local client = clients[1]
  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
  vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result)
    if err or not result or vim.tbl_isempty(result) then
      return
    end

    local target = result[1] or result
    local target_uri = target.uri or target.targetUri
    local target_range = target.range or target.targetSelectionRange

    local already_there = target_uri == vim.uri_from_bufnr(0)
      and target_range.start.line == vim.fn.line(".") - 1

    if already_there then
      require("telescope.builtin").lsp_references()
    else
      vim.lsp.util.show_document(target, client.offset_encoding, { reuse_win = true, focus = true })
    end
  end)
end
map("n", "<C-]>", goto_definition_or_references)

map("n", "<leader>ca", vim.lsp.buf.code_action)

-- Buffer navigation
map("n", "<Tab>", "<cmd>bp<CR>")
map("n", "<S-Tab>", "<cmd>bn<CR>")
map("n", "<BS><BS>", "<cmd>bd<CR>")

-- Split navigation
map("n", "<C-J>", "<C-W><C-J>")
map("n", "<C-K>", "<C-W><C-K>")
map("n", "<C-L>", "<C-W><C-L>")
map("n", "<C-H>", "<C-W><C-H>")

-- Turn off arrow keys
map("", "<Up>", "<Nop>")
map("", "<Down>", "<Nop>")
map("", "<Left>", "<Nop>")
map("", "<Right>", "<Nop>")

map("n", "Q", "<Nop>")
map("i", "jj", "<Esc>")

-- Cucumber column delete macro
vim.fn.setreg("c", "F|df|i|ea ajl")

-- Non-"IDE" extras from .vimrc's `else` branch (ideavim only applies in the has('ide') branch)
map("n", "<leader>rr", "<cmd>source $MYVIMRC<CR>")
map("n", "<leader>ts", "<cmd>set spell! spelllang=en_gb<CR>")

-- Gitsigns: current-line blame
map("n", "<leader>gb", function() require("gitsigns").toggle_current_line_blame() end)
map("n", "<leader>gB", function() require("gitsigns").blame_line({ full = true }) end)

-- DAP: breakpoint toggle. Currently only wired to an adapter for Java
-- (see after/ftplugin/java.lua's jdtls.setup_dap()), used by <leader>td's
-- "debug nearest test" there, but kept global so other languages can pick
-- it up for free once they get an adapter.
map("n", "<leader>b", function() require("dap").toggle_breakpoint() end)
