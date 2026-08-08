-- Ported from dotfiles/.vimrc "Global Settings"

vim.g.mapleader = ","

local opt = vim.opt

opt.hlsearch = true
opt.incsearch = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.ttimeoutlen = 0
opt.smartcase = true
opt.smartindent = true
opt.ignorecase = true
opt.complete:remove("i")
opt.splitright = true
opt.autoread = true
opt.errorbells = false
opt.shell = "/bin/zsh"
opt.iskeyword:remove("_")
opt.hidden = true

-- FZF/ripgrep (kept for :grep / grepprg even though Telescope now drives fuzzy find)
vim.env.RIPGREP_CONFIG_PATH = vim.env.HOME .. "/.ripgreprc"
vim.env.FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git"'

opt.wildignore:append({
  "*/.git/*", "*/.hg/*", "*/.svn/*", "*/.idea/*", "*/.DS_Store", "*/vendor",
  "*.iml", "*.class", "*/target/*", "*.pyc", "*__init__*", "*/__pycache__",
  "tags", "*.o", "*.pdf", "*.jpg", "*.mp3", "*.m4a", "*.mp4", "*.ico",
  "*.png", "*.webp", "*.svg", "*.jpeg", "*.avif",
})

if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case --hidden"
  opt.grepformat = "%f:%l:%c:%m"
end

-- Goyo
vim.g.goyo_width = 120

-- Vimtex
vim.g.vimtex_view_method = "skim"
vim.g.vimtex_compiler_method = "latexmk"

-- Treesitter (lua/plugins/treesitter.lua) enables fold-by-expression, which
-- defaults to closing every fold (functions included) as soon as a file
-- opens. foldlevelstart=99 keeps everything open by default while leaving
-- manual folding (za/zc/zo) fully working.
opt.foldlevelstart = 99

-- Disable unused providers we don't use, without touching ones plugins may need
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Persistent undo (ported from .vimrc "Persistent Undo")
local undodir = vim.fn.expand("~/.vim/undo")
vim.fn.mkdir(undodir, "p")
opt.undodir = undodir
opt.undofile = true
