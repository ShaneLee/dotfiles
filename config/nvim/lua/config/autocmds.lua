-- Ported from dotfiles/.vimrc "Autocommands" (augroup MyVimrc)

local group = vim.api.nvim_create_augroup("MyVimrc", { clear = true })

-- Open quickfix window after :grep
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = group,
  pattern = "grep",
  command = "cwindow",
})

-- Jump to last known cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  callback = function()
    if vim.bo.filetype:match("commit") then
      return
    end
    local mark = vim.fn.line("'\"")
    if mark > 0 and mark <= vim.fn.line("$") then
      vim.cmd('normal! g`"')
    end
  end,
})

-- Filetype detection
local ft_patterns = {
  { "*.feature", "cucumber" },
  { "*.zconfig", "zsh" },
  { "*.config", "sh" },
  { "*.ejs", "html" },
  { "*.cmd", "markdown" },
  { "*.j2", "yaml" },
}
for _, entry in ipairs(ft_patterns) do
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = group,
    pattern = entry[1],
    command = "setfiletype " .. entry[2],
  })
end

-- Templates for new files
vim.api.nvim_create_autocmd("BufNewFile", {
  group = group,
  pattern = "*.sh",
  command = "0r ~/.bin/dotfiles/skeletons/bash.sh",
})

vim.api.nvim_create_autocmd("BufNewFile", {
  group = group,
  pattern = "*.py",
  command = "0r ~/.bin/dotfiles/skeletons/python.py",
})
