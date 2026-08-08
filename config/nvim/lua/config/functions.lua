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

--- List project files the same way Telescope/fzf does ($FZF_DEFAULT_COMMAND).
local function project_file_list()
  if not vim.env.FZF_DEFAULT_COMMAND then
    return {}
  end
  local files = vim.fn.systemlist(vim.env.FZF_DEFAULT_COMMAND)
  if vim.v.shell_error ~= 0 then
    return {}
  end
  return files
end

--- Open the project file named exactly `target` (basename match). Single
--- match: opens it directly. Multiple matches: opens a Telescope picker
--- pre-filled so the user can disambiguate. Returns true if it navigated
--- anywhere, false if there was no match at all.
local function goto_single_file(target)
  local matches = {}
  for _, f in ipairs(project_file_list()) do
    if vim.fn.fnamemodify(f, ":t") == target then
      table.insert(matches, f)
    end
  end

  if #matches == 1 then
    vim.cmd("edit " .. vim.fn.fnameescape(matches[1]))
    return true
  elseif #matches > 1 then
    require("telescope.builtin").find_files({ default_text = target })
    return true
  end
  return false
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

--- True when the current buffer looks like a Cucumber JUnit runner class
--- (@RunWith(Cucumber.class) or a JUnit5 @Suite with @IncludeEngines("cucumber")).
local function is_cucumber_runner()
  return vim.fn.search([[@RunWith(Cucumber\.class)\|IncludeEngines(.cucumber.)]], "nw") > 0
end

--- Build the shell command to run a Java test, preferring a gradle
--- wrapper/gradle over maven when the project has one (searched upward
--- from the current file). method_name may be nil to run the whole class.
local function java_test_command(class_name, method_name)
  local gradlew = vim.fn.findfile("gradlew", ".;")
  local gradle_build = gradlew == ""
    and (vim.fn.findfile("build.gradle", ".;") ~= "" and vim.fn.findfile("build.gradle", ".;")
      or vim.fn.findfile("build.gradle.kts", ".;"))
    or ""

  if gradlew ~= "" or gradle_build ~= "" then
    local gradle_bin = gradlew ~= "" and vim.fn.fnamemodify(gradlew, ":p") or "gradle"
    local pattern = method_name and ("*." .. class_name .. "." .. method_name) or ("*." .. class_name)
    local cmd = string.format('!%s test --tests "%s"', gradle_bin, pattern)
    -- Avoid instantiating a Cucumber JUnit runner (and running the whole
    -- feature suite as a side effect) when targeting an unrelated class.
    if not is_cucumber_runner() then
      cmd = cmd .. " -PexcludeCucumber"
    end
    return cmd
  end

  if method_name then
    return "!mvn test -Dcheckstyle.skip=true -Dtest=" .. class_name .. "#" .. method_name
  end
  return "!mvn test -Dcheckstyle.skip=true -Dtest=" .. class_name
end

--- Find the test function enclosing the cursor and run just that one;
--- falls back to whole file/dir (test_cmd) if the cursor isn't inside a
--- recognizable test. Ported from TestUnderCursor() in .vimrc, plus a
--- neovim-only addition: if the current buffer is a source file (not a
--- test file) and its test file exists in the project, jump there instead
--- of trying to run tests against the source file.
function M.test_under_cursor()
  vim.cmd("write")
  local ext = vim.fn.expand("%:e")

  if ext == "py" then
    local base = vim.fn.expand("%:t:r")
    local is_test_file = base:match("^test_") or base:match("_test$")
    if not is_test_file then
      if goto_single_file("test_" .. base .. ".py") then
        return
      end
      if goto_single_file(base .. "_test.py") then
        return
      end
    end
    M.run_python_test_under_cursor()
  elseif ext == "java" then
    local class_name = vim.fn.expand("%:t:r")
    if not class_name:match("Test$") then
      if goto_single_file(class_name .. "Test.java") then
        return
      end
    end
    M.run_java_test_under_cursor()
  else
    M.test_cmd()
  end
end

function M.run_python_test_under_cursor()
  local lnum = vim.fn.search([[^\s*def\s\+test_\w*\s*(]], "bcnW")
  if lnum <= 0 then
    vim.cmd("!pytest tests")
    return
  end

  local def_line = vim.fn.getline(lnum)
  local test_name = def_line:match("^%s*def%s+(test_%w*)%s*%(")
  local indent = def_line:match("^%s*")
  local class_name = nil

  if indent ~= "" then
    local clnum = lnum - 1
    while clnum > 0 do
      local cline = vim.fn.getline(clnum)
      if cline:match("^%S") then
        class_name = cline:match("^class%s+(%w+)")
        break
      end
      clnum = clnum - 1
    end
  end

  local target = vim.fn.expand("%")
  if class_name then
    target = target .. "::" .. class_name .. "::" .. test_name
  else
    target = target .. "::" .. test_name
  end
  vim.cmd("!pytest " .. vim.fn.shellescape(target))
end

--- True when jdtls is attached *and* has actually activated the java-test
--- bundle wired in via init_options.bundles (see after/ftplugin/java.lua).
--- Mirrors the same executeCommandProvider check nvim-jdtls's own
--- fetch_candidates() does before calling test_nearest_method()/test_class(),
--- rather than just checking that those functions exist: the bundle can be
--- present on disk and still fail to activate server-side (e.g. an
--- OSGi dependency-version mismatch between jdtls and the java-test jars --
--- happened in practice, see the comment on the version pin in
--- lua/plugins/jdtls.lua), in which case calling them just prints a warning
--- and does nothing instead of running the test. Checking the actual
--- server-advertised commands means this falls back to the gradle/maven
--- shell command below whenever the fast path wouldn't really work, instead
--- of leaving <leader>t/<C-t> silently broken until that gets sorted out.
local function jdtls_test_runner_available()
  local clients = vim.lsp.get_clients({ bufnr = 0, name = "jdtls" })
  if #clients == 0 then
    return false
  end
  local provider = clients[1].server_capabilities.executeCommandProvider
  local commands = type(provider) == "table" and provider.commands or {}
  return vim.tbl_contains(commands, "vscode.java.test.search.codelens")
    or vim.tbl_contains(commands, "vscode.java.test.findTestTypesAndMethods")
end

function M.run_java_test_under_cursor()
  local class_name = vim.fn.expand("%:t:r")
  local lnum = vim.fn.line(".")
  local method_name = nil

  while lnum > 0 do
    local line = vim.fn.getline(lnum)
    -- matches optional access modifier/static, then "void name(" e.g.
    -- "public void foo(" or "static void foo(" or "void foo("
    local candidate = line:match("^%s*[%w%s]-void%s+([%w_]+)%s*%(")
    if candidate then
      local alnum = lnum - 1
      local is_test = false
      while alnum > 0 do
        local aline = vim.fn.getline(alnum)
        if aline:match("^%s*@Test") then
          is_test = true
          break
        elseif aline:match("^%s*@") or aline:match("^%s*$") then
          alnum = alnum - 1
        else
          break
        end
      end
      if is_test then
        method_name = candidate
        break
      end
    end
    lnum = lnum - 1
  end

  -- Prefer jdtls's own test runner: it compiles+runs directly against
  -- jdtls's incremental build output over DAP (the IntelliJ-style fast
  -- path), instead of shelling out to a fresh `gradlew test` process.
  -- Falls back to the gradle/maven shell command below when jdtls isn't
  -- attached yet or its bundles aren't installed.
  if jdtls_test_runner_available() then
    local jdtls = require("jdtls")
    -- console = "internalConsole" (rather than nvim-jdtls's default, which
    -- falls through to java-debug's own default of "integratedTerminal")
    -- routes test output through DAP's own output events straight into
    -- dap-repl, instead of java-debug asking nvim-dap to spawn a terminal
    -- via a runInTerminal reverse request -- which failed outright here:
    -- "Failed to launch debuggee in terminal ... TimeoutException: timeout".
    local opts = { config_overrides = { noDebug = true, console = "internalConsole" } }

    -- Opened here rather than relying on dap.listeners.after.event_initialized
    -- (see lua/plugins/dap.lua): that event doesn't reliably fire for noDebug
    -- "run" launches like this one, since there's nothing to configure
    -- breakpoints against -- so the auto-open there covers <leader>td
    -- (debug, below) but not this fast path.
    require("dap.repl").open()

    if method_name then
      jdtls.test_nearest_method(opts)
    else
      jdtls.test_class(opts)
    end
    return
  end

  vim.cmd(java_test_command(class_name, method_name))
end

return M
