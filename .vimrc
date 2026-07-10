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
nnoremap <leader><space> :nohlsearch<CR>
nnoremap <leader>l mqggVGgq'q " Reformat entire file (uses formatprg)
nnoremap <leader>g :silent grep<space>
nnoremap <leader>gg :Goyo<cr>
nnoremap <leader>s :%s/
nnoremap <leader>w :call SearchCurrentWord()<cr>
nnoremap <leader>c :cclose<cr>
nnoremap <leader><cr> :call File_name_cmd()<cr>
nnoremap <leader>r :call File_cmd()<cr>
nnoremap <leader>t :call Test_cmd()<cr>
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