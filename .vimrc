" Shane's vimrc - Refactored
"
"==============================================================================
" Basic Setup
"==============================================================================
set nocompatible " Be iMproved

"==============================================================================
" Plugin Management (vim-plug)
"   - Run :PlugInstall to install plugins
"   - Run :PlugUpdate to update plugins
"   - Run :PlugClean to remove unused plugins
"==============================================================================
" Auto-install vim-plug if not found
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs '.
    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'akhaku/vim-java-unused-imports'
Plug 'w0rp/ale'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'lervag/vimtex'

call plug#end()

"==============================================================================
" Global Settings
"==============================================================================
syntax on
filetype plugin indent on " Enable filetype detection, plugins, and indentation

set hlsearch
set incsearch
set number relativenumber
set cursorline
set ts=2 sts=2 sw=2 expandtab
set ttimeoutlen=0
set smartcase
set smartindent
set ignorecase
set complete-=i
set splitright
set autoread " If a file is changed outside of vim, automatically reload it
set noerrorbells
set shell=/bin/zsh
set iskeyword-=_ "Set _ as a word boundary
set hidden " don't unload buffers when switching

"==============================================================================
" Plugin Configuration
"==============================================================================
" FZF / Ripgrep
let $RIPGREP_CONFIG_PATH = $HOME . '/.ripgreprc'
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git"'
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store,*/vendor,*.iml,*.class,*/target/*,*.pyc,*__init__*,*/__pycache__,tags,*.o,*.pdf,*.jpg,*.mp3,*.m4a,*.mp4,*.ico,*.png,*.webp,*.svg,*.jpeg,*.avif

if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden
  set grepformat=%f:%l:%c:%m
endif

" Goyo (distraction-free writing)
let g:goyo_width = 120

" Vimtex (LaTeX)
let g:vimtex_view_method='skim'
let g:vimtex_compiler_method = 'latexmk'

"==============================================================================
" Mappings
"==============================================================================
let mapleader=","

" FZF
nnoremap <C-p> :Files<CR>

" Leader Mappings
nnoremap <leader>h :nohlsearch<CR>
nnoremap <leader><space> :call FindFileByWord()<cr>
nnoremap <leader>l mqggVGgq'q " Reformat entire file (uses formatprg)
nnoremap <leader>g :silent grep<space>
nnoremap <leader>gg :Goyo<cr>
nnoremap <leader>s :%s/
nnoremap <leader>w :call SearchCurrentWord()<cr>
nnoremap <leader>c :cclose<cr>
nnoremap <leader><cr> :call File_name_cmd()<cr>
nnoremap <leader>r :call File_cmd()<cr>
nnoremap <leader>t :call TestUnderCursor()<cr>
nnoremap <C-t> :call TestUnderCursor()<cr>
nnoremap <leader>n :call RenameFile()<cr>
nnoremap <leader>ac :%y+<cr> " Copy whole file
nnoremap <leader>jq :%!jq .<cr> " Format JSON
nnoremap <leader>ot :r `rn_template`<cr> :execute "normal kdd"<cr>
nnoremap <leader>u :read !zsh -c "source ~/.zshrc && ggu 1"<CR>

" Buffer navigation
nnoremap <leader>[ :bp<return>
nnoremap <leader>] :bn<return>
nnoremap <BS><BS> :bd<return>

" Split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Tab navigation
nnoremap <tab> :bp<CR>
nnoremap <s-tab> :bn<CR>

" Visual mode mappings
vnoremap <leader>w y :Rg <C-R>0<cr>
xnoremap <silent> <Leader>u :<C-u>call InsertUUIDsVisual()<CR>

" Other mappings
noremap Q <Nop> " Disable Ex mode
inoremap jj <Esc>

" Delete cucumber column (takes a count)
let @c = 'F|df|i|ea ajl'

" Command mode remappings
cnoremap %% <C-R>=expand('%:h').'/'<cr>
:command WQ wq
:command Wq wq
:command W w
:command Q q

" Turn off arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

"==============================================================================
" IDE Specific (IdeaVim)
"==============================================================================
if has('ide')
  "Specific remappings for idea vim
  nnoremap <BS><BS> <Nop>
  map <leader>r :action Run <cr>
  map <leader>t :action RunClass <cr>
  map <leader>d :action Debug <cr>
  map <leader>b :action ToggleLineBreakpoint <cr>
  map <leader>l :action Run <cr>
  map <leader>f :action FindInPath <cr>
  map <leader>gl :action GoToLastTab <cr>
  map <leader>gi :action GotoImplementation <cr>
  inoremap <leader>cc private static final Clock CLOCK = Clock.fixed(Instant.parse("2020-06-04T14:30:30.000Z"), ZoneId.of("UTC"));
else
  nnoremap <leader>rr :source ~/.vimrc <cr>
  nnoremap <leader>ts :set spell! spelllang=en_gb<cr>
  nnoremap <leader>f :Rg<space>
endif

"==============================================================================
" Autocommands
"==============================================================================
augroup MyVimrc
  " Clear all previous autocommands in this group
  autocmd!

  " Automatically open quickfix window after grep
  autocmd QuickFixCmdPost grep cwindow

  " Jump to last known position when reopening a file
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") && &ft !~# 'commit' |
    \   exe "normal! g`\"" |
    \ endif

  " --- Filetype Detection ---
  autocmd BufRead,BufNewFile *.feature setfiletype cucumber
  autocmd BufRead,BufNewFile *.zconfig setfiletype zsh
  autocmd BufRead,BufNewFile *.config  setfiletype sh
  autocmd BufRead,BufNewFile *.ejs     setfiletype html
  autocmd BufRead,BufNewFile *.cmd     setfiletype markdown
  autocmd BufRead,BufNewFile *.j2      setfiletype yaml

  " --- Templates ---
  autocmd BufNewFile *.sh 0r ~/.bin/dotfiles/skeletons/bash.sh
  autocmd BufNewFile *.py 0r ~/.bin/dotfiles/skeletons/python.py
augroup END

"==============================================================================
" Functions
"==============================================================================

" --- Persistent Undo ---
if has('persistent_undo')
  set undodir=~/.vim/undo
  set undofile
  silent !mkdir -p ~/.vim/undo
endif

" --- UUID Generation ---
command! -nargs=? Ggu execute '!zsh -c "source ~/.zshrc && ggu ' . <q-args> . '"'

function! InsertUUIDsVisual()
  let lines = line("'>") - line("'<") + 1
  let uuids = split(system('zsh -c "source ~/.zshrc && ggu ' . lines . '"'), "\n")
  let start_col = col("'<")
  let lnum = line("'<")
  for uuid in uuids
    if uuid !=# ''
      let line_content = getline(lnum)
      let updated_line = line_content[:start_col - 2] . uuid . line_content[start_col - 1:]
      call setline(lnum, updated_line)
      let lnum += 1
    endif
  endfor
endfunction

" --- Time Insertion ---
function! InsertCurrentTime()
    let current_time = strftime("%Y-%m-%dT%H:%M:%SZ")
    call append(line('.'), 'private static final Instant NOW = Instant.parse("' . current_time . '");')
endfunction
nnoremap <leader>nt :call InsertCurrentTime()<CR>

" --- Angular Navigation ---
function! OpenTemplate()
  :call search('templateUrl')
  :call search('html')
  normal gf
endfunction

function! OpenAngularSpec()
  let new_file = substitute(expand("%"), '\.\(ts\|html\)', '\.spec\.ts', '')
  exec ':e ' . new_file
endfunction

" --- Java Helpers ---
function! FinalField()
  normal 0ea final
  normal jj
endfunction

" --- Search ---
function! SearchCurrentWord()
  let saved_iskeyword = &iskeyword
  try
    set iskeyword+=_
    execute 'Rg ' . expand('<cword>')
  finally
    let &iskeyword = saved_iskeyword
  endtry
endfunction

" --- Find File By Word Under Cursor ---
function! FindFileByWord()
  let saved_iskeyword = &iskeyword
  set iskeyword+=_
  let word = expand('<cword>')
  let &iskeyword = saved_iskeyword

  if word ==# ''
    echo 'No word under cursor'
    return
  endif

  let ext = expand('%:e')
  let target = ext !=# '' ? word . '.' . ext : word

  call fzf#run(fzf#wrap({
  \ 'source': $FZF_DEFAULT_COMMAND,
  \ 'sink': 'e',
  \ 'options': ['--select-1', '--exit-0', '--query', target . '$']
  \ }))
endfunction

" --- File Execution ---
noremap <F2> :call File_cmd()<cr>
function! File_cmd()
  execute ':w'
  let s:executors = {
  \   'py':    '!python3 %',
  \   'js':    '!node %',
  \   'scala': '!scala %',
  \   'sh':    '!chmod +x % && ./%',
  \   '':      '!chmod +x % && ./%',
  \   'cpp':   '!g++ % && ./a.out && rm a.out',
  \   'go':    '!go run %',
  \   'rs':    '!cargo run %',
  \   'c':     '!gcc % && ./a.out && rm a.out',
  \   'tcl':   '!tclsh %',
  \   'ts':    '!tsc % && node ' . expand('%:r') . '.js && rm ' . expand('%:r') . '.js',
  \   'hs':    '!ghc -o %:r % && ./%:r && rm %:r && rm %:r.hi && rm %:r.o',
  \   'java':  expand('%') ==? 'main.java'
  \          ? '!javac % && java main && rm *.class'
  \          : '!mvn test -Dcheckstyle.skip=true -Dtest=' . expand('%:t:r') . 'Test',
  \   'md':    '!glow %',
  \   'cmd':   '!glow %',
  \ }
  let s:ext = expand('%:e')
  if has_key(s:executors, s:ext)
    exec s:executors[s:ext]
  else
    echo "No executor defined for filetype: " . s:ext
  endif
endfunction

function! File_name_cmd()
  execute ':w'
  if expand('%:e') ==? 'py'
    exec ':!python3 main.py'
  endif
endfunction

" --- Test Execution ---
noremap <F3> :call Test_cmd()<cr>
function! Test_cmd()
  execute ':w'
  let s:testers = {
  \   'py': '!pytest tests',
  \   'go': '!go test',
  \ }
  let s:ext = expand('%:e')
  if has_key(s:testers, s:ext)
    exec s:testers[s:ext]
  else
    echo "No tester defined for filetype: " . s:ext
  endif
endfunction

" --- Run Test Under Cursor ---
" Finds the test method/function enclosing the cursor and runs just that
" one; falls back to Test_cmd() (whole file/dir) if the cursor isn't
" inside a recognizable test.
function! TestUnderCursor()
  execute ':w'
  let ext = expand('%:e')
  if ext ==# 'py'
    call s:RunPythonTestUnderCursor()
  elseif ext ==# 'java'
    call s:RunJavaTestUnderCursor()
  else
    call Test_cmd()
  endif
endfunction

function! s:RunPythonTestUnderCursor()
  let lnum = search('^\s*def\s\+test_\w*\s*(', 'bcnW')
  if lnum <= 0
    exec '!pytest tests'
    return
  endif

  let def_line = getline(lnum)
  let test_name = matchstr(def_line, '^\s*def\s\+\zstest_\w*\ze\s*(')
  let indent = matchstr(def_line, '^\s*')
  let class_name = ''

  if indent !=# ''
    let clnum = lnum - 1
    while clnum > 0
      let cline = getline(clnum)
      if cline =~# '^\S'
        let class_name = matchstr(cline, '^class\s\+\zs\w\+')
        break
      endif
      let clnum -= 1
    endwhile
  endif

  let target = expand('%')
  if class_name !=# ''
    let target .= '::' . class_name . '::' . test_name
  else
    let target .= '::' . test_name
  endif
  exec '!pytest ' . shellescape(target)
endfunction

" Prefer a gradle wrapper/gradle over maven when the project has one,
" searching upward from the current file. Returns the '!...' shell command
" to run for the given class (and optional method).
function! s:JavaTestCommand(class_name, method_name)
  let gradlew = findfile('gradlew', '.;')
  let gradle_build = gradlew ==# '' ? (findfile('build.gradle', '.;') !=# '' ? findfile('build.gradle', '.;') : findfile('build.gradle.kts', '.;')) : ''

  if gradlew !=# '' || gradle_build !=# ''
    let gradle_bin = gradlew !=# '' ? fnamemodify(gradlew, ':p') : 'gradle'
    let pattern = a:method_name !=# ''
      \ ? '*.' . a:class_name . '.' . a:method_name
      \ : '*.' . a:class_name
    return '!' . gradle_bin . ' test --tests "' . pattern . '"'
  endif

  if a:method_name !=# ''
    return '!mvn test -Dcheckstyle.skip=true -Dtest=' . a:class_name . '#' . a:method_name
  else
    return '!mvn test -Dcheckstyle.skip=true -Dtest=' . a:class_name
  endif
endfunction

function! s:RunJavaTestUnderCursor()
  let class_name = expand('%:t:r')
  let lnum = line('.')
  let method_name = ''

  while lnum > 0
    let line = getline(lnum)
    if line =~# '^\s*\%(public\|private\|protected\)\?\s*\%(static\s\+\)\?void\s\+\w\+\s*('
      let candidate = matchstr(line, '\<\w\+\ze\s*(')
      let alnum = lnum - 1
      let is_test = 0
      while alnum > 0
        let aline = getline(alnum)
        if aline =~# '^\s*@Test\>'
          let is_test = 1
          break
        elseif aline =~# '^\s*@\|^\s*$'
          let alnum -= 1
        else
          break
        endif
      endwhile
      if is_test
        let method_name = candidate
        break
      endif
    endif
    let lnum -= 1
  endwhile

  exec s:JavaTestCommand(class_name, method_name)
endfunction

" --- Cucumber Execution ---
function! CucumberIT()
  execute '!ct %'
endfunction

" --- File Renaming ---
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . shellescape(old_name)
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

" --- Contextual Tab ---
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col
        return "\<tab>"
    endif

    let char = getline('.')[col - 1]
    if char =~ '\k'
        return "\<c-p>"
    else
        return "\<tab>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>
