call pathogen#infect()
syntax on
filetype plugin indent on

set nocompatible
set laststatus=2
set encoding=utf-8
set t_Co=256

set background=light
colorscheme solarized

  let g:vtroom_use_vimux = 1

set number
set nowrap
set tabstop=2
set shiftwidth=2
set expandtab

set list
set listchars=""
set listchars=tab:\ \
set listchars+=trail:.
set listchars+=extends:>
set listchars+=precedes:<

set backspace=indent,eol,start

set hlsearch
set incsearch
set ignorecase
set smartcase

set backupdir=~/.vim/_backup//
set directory=~/.vim/_temp//

vmap <A-]> >gv
vmap <A-[> <gv
