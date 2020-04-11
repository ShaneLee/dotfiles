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

call neobundle#end()

" Required:
filetype plugin indent on

NeoBundleCheck

syntax on
set number
set tabstop=4
set shiftwidth=4
set cursorline


""""""""""""""""""""""""""""""""""
" Turn off arrow keys
""""""""""""""""""""""""""""""""""
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

noremap <C-s> :CtrlP<cr>
