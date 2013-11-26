call pathogen#infect()
syntax on
filetype plugin indent on

set hidden
set nocompatible
set laststatus=2
set encoding=utf-8
set t_Co=256

" set background=dark
colorscheme hemisu

set tabstop=2
set shiftwidth=2
set autoindent
set laststatus=2
set showtabline=2
set nowrap
set wildmode=longest,list
set wildmenu

:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

set expandtab
let mapleader=","

set showcmd

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

set winwidth=84
" We have to have a winheight bigger than we want to set winminheight. But if
" we set winheight to be huge before winminheight, the winminheight set will
" fail.
set winheight=10
set winminheight=10
set winheight=999

function! ResCur()
    if line("'\"") <= line("$")
      normal! g`"
      return 1
    endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

"Use TAB to complete when typing words, else inserts TABs as usual.
""Uses dictionary and source files to find matching words to complete.

"See help completion for source,
""Note: usual completion is on <C-n> but more trouble to press all the time.
"Never type the same word twice and maybe learn a new spellings!
""Use the Linux dictionary when spelling is in doubt.
"Window users can copy the file to their machine.
function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction
:inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
:set dictionary="/usr/dict/words"

" Yank text to the OS X clipboard
noremap <leader>y "*y
noremap <leader>yy "*Y

" Preserve indentation while pasting text from the OS X clipboard
noremap <leader>p :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>

" fixes rvm scripting from zsh
set shell=/bin/sh

noremap <leader><leader> <C-^>
map <leader>gr :topleft :split config/routes.rb<CR>
map <leader>gg :topleft :split Gemfile<CR>
" Open files with <leader>f
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
" Open files, limited to the directory of the current file, with <leader>gf
" " This requires the %% mapping found below.
map <leader>gf :CommandTFlush<cr>\|:CommandT %%<cr>
map <leader>gv :CommandTFlush<cr>\|:CommandT app/views<cr>
map <leader>gc :CommandTFlush<cr>\|:CommandT app/controllers<cr>
map <leader>gm :CommandTFlush<cr>\|:CommandT app/models<cr>
map <leader>gh :CommandTFlush<cr>\|:CommandT app/helpers<cr>
map <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
map <leader>gp :CommandTFlush<cr>\|:CommandT app/replicators<cr>
map <leader>gs :CommandTFlush<cr>\|:CommandT public/stylesheets<cr>

map <leader>t :CommandTFlush<cr>\|:CommandT ~/Dropbox/text<cr>

map <leader>i :topleft :split ~/Dropbox/text/inbox.markdown<CR>
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

map <leader>g :Gstatus<CR>

func! WordProcessorMode() 
  setlocal formatoptions=1 
  setlocal noexpandtab 
  map j gj 
  map k gk
  setlocal spell spelllang=en_us 
  set complete+=s
  set formatprg=par
  setlocal wrap 
  setlocal linebreak 
endfunc

let b:dispatch = 'bundle exec rspec %'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

" for dispatch
autocmd FileType java let b:dispatch = 'javac %'
autocmd FileType ruby let b:dispatch = 'bundle exec rspec %'
autocmd FileType cucumber let b:dispatch = 'bundle exec cucumber %'

" scratchpad
map <Leader>sc :sp ~/Dropbox/notes/scratch.txt<CR>
map <Leader>to :sp ~/Dropbox/notes/todo.mdown<CR>
map <C-s> <esc>:w<CR>
imap <C-s> <esc>:w<CR>
map <Leader>j :e ~/Dropbox/docs/2013.markdown<CR>
map <Leader>w :!bundle exec cucumber --profile wip<CR>
