-- Lua ports of the Vimscript functions from dotfiles/.vimrc "Functions" section

local M = {}

--- Insert a Java Instant.parse(...) snippet with the current UTC time.
function M.insert_current_time()
  local current_time = os.date("!%Y-%m-%dT%H:%M:%SZ")
  vim.fn.append(
    vim.fn.line("."),
    string.format('private static final Instant NOW = Instant.parse("%s");', current_time)
  )
end

--- Generate `count` UUIDs via the user's `ggu` zsh function and return them as a list.
local function generate_uuids(count)
  local out = vim.fn.system(string.format('zsh -c "source ~/.zshrc && ggu %d"', count))
  local uuids = {}
  for line in out:gmatch("[^\r\n]+") do
    table.insert(uuids, line)
  end
  return uuids
end

--- Normal-mode: insert one UUID at the cursor.
function M.insert_uuid()
  local uuids = generate_uuids(1)
  if uuids[1] then
    vim.api.nvim_put({ uuids[1] }, "c", true, true)
  end
end

--- Visual-mode: insert one UUID per selected line, at the start column of the selection.
function M.insert_uuids_visual()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_line, start_col = start_pos[2], start_pos[3]
  local num_lines = end_pos[2] - start_line + 1

  local uuids = generate_uuids(num_lines)
  for i, uuid in ipairs(uuids) do
    local lnum = start_line + i - 1
    local line_content = vim.fn.getline(lnum)
    local updated = line_content:sub(1, start_col - 1) .. uuid .. line_content:sub(start_col)
    vim.fn.setline(lnum, updated)
  end
end

--- Rename the current file (saveas + delete old file), same as :RenameFile.
function M.rename_file()
  local old_name = vim.fn.expand("%")
  local new_name = vim.fn.input("New file name: ", old_name, "file")
  if new_name ~= "" and new_name ~= old_name then
    vim.cmd("saveas " .. vim.fn.fnameescape(new_name))
    vim.fn.delete(old_name)
    vim.cmd("redraw!")
  end
end

--- Search for the word under the cursor via Telescope grep_string (replaces :Rg <cword>).
--- Temporarily treats `_` as part of a keyword, matching the original SearchCurrentWord().
function M.search_current_word()
  local saved_iskeyword = vim.bo.iskeyword
  vim.bo.iskeyword = vim.bo.iskeyword .. ",_"
  local word = vim.fn.expand("<cword>")
  vim.bo.iskeyword = saved_iskeyword

  require("telescope.builtin").grep_string({ search = word })
end

--- Visual-mode equivalent: grep the visually selected text.
function M.search_visual_selection()
  local saved = vim.fn.getreg("v")
  vim.cmd('normal! gv"vy')
  local text = vim.fn.getreg("v")
  vim.fn.setreg("v", saved)
  require("telescope.builtin").grep_string({ search = text })
end

--- Find a file whose name matches the word under the cursor, filtered to the current
--- buffer's extension, via Telescope (replaces FindFileByWord()/fzf).
function M.find_file_by_word()
  local saved_iskeyword = vim.bo.iskeyword
  vim.bo.iskeyword = vim.bo.iskeyword .. ",_"
  local word = vim.fn.expand("<cword>")
  vim.bo.iskeyword = saved_iskeyword

  if word == "" then
    vim.notify("No word under cursor", vim.log.levels.WARN)
    return
  end

  local ext = vim.fn.expand("%:e")
  local target = ext ~= "" and (word .. "." .. ext) or word

  require("telescope.builtin").find_files({ default_text = target })
end

--- Per-filetype "run current file" dispatch table (ported from File_cmd()).
local executors = {
  py = "!python3 %",
  js = "!node %",
  scala = "!scala %",
  sh = "!chmod +x % && ./%",
  [""] = "!chmod +x % && ./%",
  cpp = "!g++ % && ./a.out && rm a.out",
  go = "!go run %",
  rs = "!cargo run %",
  c = "!gcc % && ./a.out && rm a.out",
  tcl = "!tclsh %",
  ts = "!tsc % && node %:r.js && rm %:r.js",
  hs = "!ghc -o %:r % && ./%:r && rm %:r && rm %:r.hi && rm %:r.o",
  md = "!glow %",
  cmd = "!glow %",
}

function M.file_cmd()
  vim.cmd("write")
  local ext = vim.fn.expand("%:e")

  if ext == "java" then
    if vim.fn.expand("%"):lower() == "main.java" then
      vim.cmd("!javac % && java main && rm *.class")
    else
      vim.cmd("!mvn test -Dcheckstyle.skip=true -Dtest=" .. vim.fn.expand("%:t:r") .. "Test")
    end
    return
  end

  local cmd = executors[ext]
  if cmd then
    vim.cmd(cmd)
  else
    vim.notify("No executor defined for filetype: " .. ext, vim.log.levels.WARN)
  end
end

function M.file_name_cmd()
  vim.cmd("write")
  if vim.fn.expand("%:e"):lower() == "py" then
    vim.cmd("!python3 main.py")
  end
end

--- Per-filetype test runner dispatch table (ported from Test_cmd()).
local testers = {
  py = "!pytest tests",
  go = "!go test",
}

function M.test_cmd()
  vim.cmd("write")
  local ext = vim.fn.expand("%:e")
  local cmd = testers[ext]
  if cmd then
    vim.cmd(cmd)
  else
    vim.notify("No tester defined for filetype: " .. ext, vim.log.levels.WARN)
  end
end

return M
