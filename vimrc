call pathogen#infect()
syntax on
filetype plugin indent on

set nocompatible
set laststatus=2
set encoding=utf-8
set t_Co=256

set background=light
colorscheme solarized

" let g:vtroom_use_vimux = 1

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

" some vimux mappings
" map rp :PromptVimTmuxCommand

" Run last command executed by RunVimTmuxCommand
" map rl :RunLastVimTmuxCommand
"
" " Inspect runner pane
" map ri :InspectVimTmuxRunner
"
" " Close all other tmux panes in current window
map <leader>r :CloseVimTmuxPanes<CR>
"
" " Interrupt any command running in the runner pane
" map rs :InterruptVimTmuxRunner
