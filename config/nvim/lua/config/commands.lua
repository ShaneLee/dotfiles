-- Typo-tolerant command aliases + UUID command, ported from dotfiles/.vimrc

local function alias(name, target)
  vim.api.nvim_create_user_command(name, target, {})
end

alias("WQ", "wq")
alias("Wq", "wq")
alias("W", "w")
alias("Q", "q")

vim.api.nvim_create_user_command("Ggu", function(opts)
  vim.cmd('!zsh -c "source ~/.zshrc && ggu ' .. (opts.args ~= "" and opts.args or "") .. '"')
end, { nargs = "?" })

-- %% expands to the current buffer's directory in cmdline mode
vim.keymap.set("c", "%%", function()
  return vim.fn.expand("%:h") .. "/"
end, { expr = true })
