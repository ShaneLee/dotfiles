-- Plugin Manager
vim.opt.runtimepath:prepend("~/.local/share/nvim/lazy/lazy.nvim")

require("lazy").setup({
  "tpope/vim-surround",
  "tpope/vim-fugitive",
  "tpope/vim-commentary",
  "nvim-telescope/telescope.nvim",
  "nvim-treesitter/nvim-treesitter",
  "jose-elias-alvarez/null-ls.nvim",
  "junegunn/goyo.vim",
  "lervag/vimtex",
  "prettier/vim-prettier",
  {
    "neoclide/coc.nvim",
    branch = "release"
  }
})


-- Basic Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0
vim.opt.autoread = true
vim.opt.errorbells = false
vim.opt.shell = "/bin/zsh"
vim.g.mapleader = ","


-- General Mappings
vim.keymap.set("n", "<leader>ac", ":%y+<CR>")
vim.keymap.set("n", "<leader>jq", ":%!jq .<CR>")
vim.keymap.set("n", "<leader>nt", ":lua InsertCurrentTime()<CR>")
vim.keymap.set("i", "jj", "<Esc>")

-- Split Navigation
vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
vim.keymap.set("n", "<C-L>", "<C-W><C-L>")
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")

-- Turn Off Arrow Keys
vim.keymap.set("", "<Up>", "<Nop>")
vim.keymap.set("", "<Down>", "<Nop>")
vim.keymap.set("", "<Left>", "<Nop>")
vim.keymap.set("", "<Right>", "<Nop>")


-- Autocommands
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python" },
  command = "set tabstop=4 shiftwidth=4 expandtab"
})

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.sh",
  command = "0r ~/.bin/dotfiles/skeletons/bash.sh"
})


function InsertCurrentTime()
  local current_time = os.date("!%Y-%m-%dT%H:%M:%SZ")
  vim.cmd("call append(line('.'), 'private static final Instant NOW = Instant.parse(\"" .. current_time .. "\");')")
end


