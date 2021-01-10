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

" Required:
filetype plugin indent off

NeoBundleCheck

syntax on
set number
set cursorline
set ts=2 sts=2 sw=2 expandtab 
set timeoutlen=1000 ttimeoutlen=0
"set lazyredraw

" Python PEP 8
au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent fileformat=unix

" Map W to write 
command W write

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
    exec ':! tsc -p tsconfig.json% && node ' . expand('%:r') . '.js'
  elseif expand('%:e') ==? 'hs'
    exec ':! ghc -o %:r % && ./%:r && rm %:r && rm %:r.hi && rm %:r.o'
  endif
endfunction

""""""""""""""""""""""""""""""""""
" Test file based on file type.
""""""""""""""""""""""""""""""""""
noremap <F3> :call Test_cmd()<cr>

function Test_cmd() 
  execute ':w'
  if expand('%:e') ==? 'py'
    exec ':! python %' 
  elseif expand('%:e') ==? 'go'
    exec ':! go test'
  endif
endfunction

" Just testing this for now
autocmd FileType java inoremap ;p private void test() 
