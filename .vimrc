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

NeoBundle 'fatih/vim-go'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'leafgarland/typescript-vim'
NeoBundle 'peitalin/vim-jsx-typescript'
NeoBundle 'ludovicchabant/vim-gutentags'

call neobundle#end()

let g:ctrlp_custom_ignore = 'node_modules'
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store,*/vendor,*.iml,*.class,*/target/*,*.pyc,*__init__*,*/__pycache__,tags
let mapleader=","

" Required:
filetype plugin indent off

NeoBundleCheck

syntax on
set number
set cursorline
set ts=2 sts=2 sw=2 expandtab 
set timeoutlen=1000 ttimeoutlen=0
set smartcase
set ignorecase

" Set markdown width 
au BufRead,BufNewFile *.md setlocal textwidth=80

" Python PEP 8
au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent fileformat=unix

""""""""""""""""""""""""""""""""""
" Use ripgrep
""""""""""""""""""""""""""""""""""
if executable('rg')
  set grepprg=rg\ --vimgrep\ --hidden\ --glob
endif

""""""""""""""""""""""""""""""""""
" Search files using vim grep
""""""""""""""""""""""""""""""""""
function SearchFiles(value)
  vimgrep value `{ git ls-files & git ls-files --others }`
  cw
endfunction

command -nargs=1 SearchF call SearchFiles(<f-args>)

nnoremap <leader>g :grep<space>
nnoremap <leader>r :%s/
nnoremap <leader>f :SearchF<space>
nnoremap <leader>c :cclose<cr>
nnoremap <leader><cr> :call File_name_cmd()<cr>
nnoremap <leader>t :call Test_cmd()<cr>
nnoremap <leader>[ :bp<return>
nnoremap <leader>] :bn<return>


""""""""""""""""""""""""""""""""""
" Turn off arrow keys
""""""""""""""""""""""""""""""""""
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

""""""""""""""""""""""""""""""""""
" Insert mode remappings
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
  elseif expand('%:e') ==? 'cpp'
    exec ':! make % && ./%'
  elseif expand('%:e') ==? 'go'
    exec ':! go run  %'
  elseif expand('%:e') ==? 'rs'
    exec ':! cargo run  %'
  elseif expand('%:e') ==? 'c'
    exec ':! gcc  % && ./a.out && rm a.out'
  elseif expand('%:e') ==? 'ts'
    exec ':! tsc % && node ' . expand('%:r') . '.js && rm *.js'
  elseif expand('%:e') ==? 'hs'
    exec ':! ghc -o %:r % && ./%:r && rm %:r && rm %:r.hi && rm %:r.o'
  endif
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
    exec ':! python -m unittest discover' 
  elseif expand('%:e') ==? 'go'
    exec ':! go test'
  endif
endfunction

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

" Just testing this for now
autocmd FileType java inoremap ;p private void test() 

" Markdown commands 
autocmd FileType markdown inoremap <leader>1 #
autocmd FileType markdown inoremap <leader>2 ##
autocmd FileType markdown inoremap <leader>3 ###
autocmd FileType markdown inoremap <leader>4 ####
autocmd FileType markdown inoremap <leader>5 #####
autocmd FileType markdown inoremap <leader>6 ######
