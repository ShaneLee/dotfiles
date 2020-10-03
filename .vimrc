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

""""""""""""""""""""""""""""""""""
" Turn off arrow keys
""""""""""""""""""""""""""""""""""
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

noremap <C-s> :CtrlP<cr>

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
    exec ':!./%'
  elseif expand('%:e') ==? 'cpp'
    exec ':! make % && ./%'
  elseif expand('%:e') ==? 'go'
    exec ':! go run  %'
  elseif expand('%:e') ==? 'rs'
    exec ':! cargo run  %'
  elseif expand('%:e') ==? 'c'
    exec ':! gcc  % && ./a.out && rm a.out'
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
