" Shane's vimrc
if 0 | endif

if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-commentary'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'leafgarland/typescript-vim'
NeoBundle 'peitalin/vim-jsx-typescript'
NeoBundle 'ludovicchabant/vim-gutentags'
NeoBundle 'akhaku/vim-java-unused-imports'
NeoBundle 'w0rp/ale'
NeoBundle 'junegunn/goyo.vim'
NeoBundle 'junegunn/fzf'
NeoBundle 'junegunn/fzf.vim'
NeoBundle 'lervag/vimtex'
NeoBundle 'prettier/vim-prettier'



call neobundle#end()

let g:ctrlp_open_multiple_files = 'ji'
let g:ctrlp_custom_ignore = 'node_modules'
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store,*/vendor,*.iml,*.class,*/target/*,*.pyc,*__init__*,*/__pycache__,tags,*.o,*.pdf,*.jpg,*.mp3,*.m4a,*.mp4,*.ico,*.png,*.webp,*.svg,*.jpeg,*.avif
let mapleader=","

let g:goyo_width = 120

let g:vimtex_view_method='skim'

" Required:
filetype plugin indent off
filetype plugin on

NeoBundleCheck

syntax on
set number relativenumber
set cursorline
set ts=2 sts=2 sw=2 expandtab 
set timeoutlen=1000 ttimeoutlen=0
set smartcase
set smartindent
set ignorecase
set complete-=i
set splitright
" If a file is changed outside of vim, automatically reload it without asking
set autoread
set noerrorbells
set shell=/bin/zsh
set iskeyword-=_ "Set _ as a word boundary

augroup filetypedetect
au! BufReadPre,BufReadPost,BufRead,BufNewFile *.feature setfiletype cucumber
au! BufReadPre,BufReadPost,BufRead,BufNewFile *.zconfig :setlocal filetype=zsh
au! BufReadPre,BufReadPost,BufRead,BufNewFile *.config :setlocal filetype=sh
au! BufReadPre,BufReadPost,BufRead,BufNewFile *.ejs setfiletype html
au! BufReadPre,BufReadPost,BufRead,BufNewFile *.cmd setfiletype markdown
au! BufReadPre,BufReadPost,BufRead,BufNewFile *.j2  setfiletype yaml
augroup END

command! -nargs=? Ggu execute '!zsh -c "source ~/.zshrc && ggu ' . <q-args> . '"'

function! InsertUUIDsVisual()
  " Get the number of selected lines
  let lines = line("'>") - line("'<") + 1

  " Generate the required number of UUIDs
  let uuids = split(system('zsh -c "source ~/.zshrc && ggu ' . lines . '"'), "\n")

  " Get the starting column
  let start_col = col("'<")

  " Insert UUIDs at the cursor position for each selected line
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

xnoremap <silent> <Leader>u :<C-u>call InsertUUIDsVisual()<CR>

function InsertCurrentTime()
    " Get the current time in ISO 8601 format
    let current_time = strftime("%Y-%m-%dT%H:%M:%SZ")

    " Insert the line with the current time as an Instant string
    call append(line('.'), 'private static final Instant NOW = Instant.parse("' . current_time . '");')
endfunction

" Map a key sequence to trigger the custom function
nnoremap <leader>nt :call InsertCurrentTime()<CR>

autocmd FileType html,xml set omnifunc=htmlcomplete#CompleteTags

" Templates
"
autocmd BufNewFile *.sh 0r ~/.bin/dotfiles/skeletons/bash.sh
autocmd BufNewFile *.py 0r ~/.bin/dotfiles/skeletons/python.py

" Set markdown width 
au BufRead,BufNewFile *.md setlocal textwidth=80
au BufRead,BufNewFile *.cmd setlocal textwidth=104
"
" Set yaml indenting
au FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
au FileType markdown setlocal ts=2 sts=2 sw=2 expandtab

" Python PEP 8
au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent fileformat=unix

" Set xml indenting
autocmd FileType xml setlocal shiftwidth=2 softtabstop=2 expandtab

cnoremap %% <C-R>=expand('%:h').'/'<cr>

" Reformat entire file
nnoremap <leader>l mqggVGgq'q

""""""""""""""""""""""""""""""""""
" Angular opens html template
""""""""""""""""""""""""""""""""""
function! OpenTemplate()
  :call search('templateUrl')
  :call search('html')
  normal gf
endfunction

""""""""""""""""""""""""""""""""""
" Angular opens spec
""""""""""""""""""""""""""""""""""
function! OpenAngularSpec()
  let new_file = substitute(expand("%"), '\.ts', '\.spec\.ts', '')
  let new_file = substitute(expand("%"), '\.html', '\.spec\.ts', '')
  exec ':e ' new_file
endfunction

""""""""""""""""""""""""""""""""""
" Java adds final to field
""""""""""""""""""""""""""""""""""
function! FinalField()
  normal 0ea final
  normal jj
endfunction

""""""""""""""""""""""""""""""""""
" Java autocmds
""""""""""""""""""""""""""""""""""
au FileType java setlocal ts=4 sts=4 sw=4 expandtab textwidth=100
au FileType java noremap <leader>iu :UnusedImports<cr>
au FileType java noremap <leader>ir :UnusedImportsRemove<cr>
au FileType java noremap <leader>ih :UnusedImportsReset<cr>
au FileType java noremap <leader>fa :call FinalField()<cr>
au FileType java inoremap <leader>cc private static final Clock CLOCK = Clock.fixed(Instant.parse("2020-06-04T14:30:30.000Z"), ZoneId.of("UTC"));
au FileType java inoremap <leader>csid <esc>:call read !csid

""""""""""""""""""""""""""""""""""
" Python autocmds
""""""""""""""""""""""""""""""""""

" Format the code
au FileType python setlocal formatprg=black\ -q\ -
au FileType python nnoremap <leader>l ggVGgq<C-o><C-o>

""""""""""""""""""""""""""""""""""
" Cucumber autocmds
""""""""""""""""""""""""""""""""""
autocmd FileType cucumber noremap <leader>r :call CucumberIT()<cr>
 
""""""""""""""""""""""""""""""""""
" Typescript autocmds
""""""""""""""""""""""""""""""""""
au FileType typescript nnoremap <leader>tt :call OpenTemplate()<cr>
au FileType typescript nnoremap <leader>gt :call OpenAngularSpec()<cr>


nnoremap <leader>g :grep<space>
nnoremap <leader>gg :Goyo<cr>
nnoremap <leader>s :%s/
nnoremap <leader>w :Rg <C-R><C-W><cr>
vnoremap <leader>w y :Rg <C-R>0<cr>
nnoremap <leader>c :cclose<cr>
nnoremap <leader><cr> :call File_name_cmd()<cr>
nnoremap <leader>[ :bp<return>
nnoremap <leader>] :bn<return>
nnoremap <BS><BS> :bd<return>
nnoremap <leader>r :call File_cmd()<cr>
nnoremap <leader>t :call Test_cmd()<cr>
noremap Q <Nop>
" Open the note template in the current buffer
nnoremap <leader>ot :r `rn_template`<cr> :execute "normal kdd"<cr>

" Delete cucumber column (takes a count)
let @c = 'F|df|i|��ajl'

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


" Copy whole file to clipboard
nnoremap <leader>ac :%y+<cr>

" Format JSON
nnoremap <leader>jq :%!jq .<cr>

""""""""""""""""""""""""""""""""""
" Easier split navigations 
""""""""""""""""""""""""""""""""""
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

""""""""""""""""""""""""""""""""""
" Turn off arrow keys
""""""""""""""""""""""""""""""""""
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
""""""""""""""""""""""""""""""""""

inoremap jj <Esc>

""""""""""""""""""""""""""""""""""
" Ex mode remappings
""""""""""""""""""""""""""""""""""
:command WQ wq
:command Wq wq
:command W w
:command Q q

""""""""""""""""""""""""""""""""""
" Execute file based on file type.
""""""""""""""""""""""""""""""""""
noremap <F2> :call File_cmd()<cr>

function File_cmd() 
  execute ':w'
  if expand('%:e') ==? 'py'
    exec ':! python3 %' 
  elseif expand('%:e') ==? 'js' 
    exec ':! node %'
  elseif expand('%:e') ==? 'scala' 
    exec ':! scala %'
  elseif expand('%:e') ==? 'sh'
    exec ':! chmod +x % && ./%'
  elseif expand('%:e') ==? ''
    exec ':! chmod +x % && ./%'
  elseif expand('%:e') ==? 'cpp'
    exec ':! g++  % && ./a.out && rm a.out'
  elseif expand('%:e') ==? 'go'
    exec ':! go run  %'
  elseif expand('%:e') ==? 'rs'
    exec ':! cargo run  %'
  elseif expand('%:e') ==? 'c'
    exec ':! gcc  % && ./a.out && rm a.out'
  elseif expand('%:e') ==? 'tcl'
    exec ':! gcc  % && ./a.out && rm a.out'
  elseif expand('%:e') ==? 'ts'
    exec ':! tsc % && node ' . expand('%:r') . '.js && rm *.js'
  elseif expand('%:e') ==? 'hs'
    exec ':! ghc -o %:r % && ./%:r && rm %:r && rm %:r.hi && rm %:r.o'
  elseif expand('%') ==? 'main.java'
    exec ':! javac % && java main && rm *.class'
  elseif expand('%:e') ==? 'java'
    exec ':! mvn test -Dcheckstyle.skip=true -Dtest=' . expand('%:t:r') . 'Test'
  elseif expand('%:e') ==? 'md'
    exec ':! glow %'
  elseif expand('%:e') ==? 'cmd'
    exec ':! glow %'
  endif
endfunction

""""""""""""""""""""""""""""""""""
" Execute CucumberIT
""""""""""""""""""""""""""""""""""
function CucumberIT() 
  execute'!ct %'
endfunction

""""""""""""""""""""""""""""""""""
" Execute specific file
""""""""""""""""""""""""""""""""""
function File_name_cmd() 
  execute ':w'
  if expand('%:e') ==? 'py'
    exec ':! python3 main.py' 
  endif
endfunction

""""""""""""""""""""""""""""""""""
" Test file based on file type.
""""""""""""""""""""""""""""""""""
noremap <F3> :call Test_cmd()<cr>

function Test_cmd() 
  execute ':w'
  if expand('%:e') ==? 'py'
    exec ':! pytest tests'
  elseif expand('%:e') ==? 'go'
    exec ':! go test'
  endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col
        return "\<tab>"
    endif

    let char = getline('.')[col - 1]
    if char =~ '\k'
        " There's an identifier before the cursor, so complete the identifier.
        return "\<c-p>"
    else
        return "\<tab>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>
nnoremap <tab> :bp<CR>
nnoremap <s-tab> :bn<CR>

" Markdown commands 
autocmd FileType markdown inoremap <leader>1 #
autocmd FileType markdown inoremap <leader>2 ##
autocmd FileType markdown inoremap <leader>3 ###
autocmd FileType markdown inoremap <leader>4 ####
autocmd FileType markdown inoremap <leader>5 #####
autocmd FileType markdown inoremap <leader>6 ######
