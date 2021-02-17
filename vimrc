call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-rails'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'thoughtbot/vim-rspec'
Plug 'mileszs/ack.vim'
Plug 'scrooloose/nerdtree'
Plug 'kchmck/vim-coffee-script'
Plug 'posva/vim-vue'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-dispatch'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
call plug#end()


" silence mismatching rspec versions
let g:rspec_command = "!bundle exec rspec {spec}"
let g:tmuxline_preset = 'minimal'

syntax on
filetype plugin indent on

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

set background=light
colorscheme solarized
set termguicolors

set hidden
set nocompatible
set encoding=utf-8
set t_Co=256

set tabstop=2
set shiftwidth=2
set autoindent
set linebreak
set nonumber

" turn on hybrid relative numbers
" set number relativenumber
" set nu rnu

set wildmode=longest,list
set wildmenu
set nowrap

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

nmap j gj
nmap k gk

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
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif
augroup END

au BufRead, BufNewFile *.md setlocal textwidth=80

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
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

set laststatus=2
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

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

map <Leader>w :!bundle exec cucumber --profile wip<CR>
map <Leader>r :call RunCurrentSpecFile()<CR>
map <Leader>R :call RunNearestSpec()<CR>

" Run a given vim command on the results of fuzzy selecting from a given shell
" command. See usage below.
function! SelectaCommand(choice_command, selecta_args, vim_command)
  try
    silent let selection = system(a:choice_command . " | selecta " . a:selecta_args)
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . selection
endfunction

" Find all files in all non-dot directories starting in the working directory.
" Fuzzy select one of those. Open the selected file with :e.
nnoremap <leader>f :FZF<cr>
nnoremap <C-p> :FZF<cr>
nnoremap <leader>m :call SelectaCommand("find ~/Dropbox/me/* -type f", "", ":e")<cr>
nnoremap <CR> :nohlsearch<CR>

" recognize .md as markdown files
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

nmap ; :Buffers<CR>
nmap <Leader>t :NERDTreeToggle<CR>

" use silver searcher instead of ack
let g:ackprg = 'ag --vimgrep'

" map FZF interactive searching via ag
nmap <Leader>a :Ag<CR>

" close the quickfix window no matter where you are
nmap <Leader>c :cclose<CR>
