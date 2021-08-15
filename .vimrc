" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" source ~/.vimrc.before if it exists.
if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif

" ================ General Config ====================

set number                      " Line numbers are good
set backspace=indent,eol,start  " Allow backspace in insert mode
set history=1000                " Store lots of :cmdline history
set showcmd                     " Show incomplete cmds down the bottom
set showmode                    " Show current mode down the bottom
set showmatch                   " Show matching brackets
set gcr=a:blinkon0              " Disable cursor blink
set autoread                    " Reload files changed outside vim
set belloff=all                 " Turns off Bell
set encoding=UTF-8              " Set character encoding
set lazyredraw                  " Redraw only when we need to
set termguicolors               " Enable 256 color mode

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

"turn on syntax highlighting
syntax on

" Change leader to a comma because the backslash is too far away
" That means all \x commands turn into ,x
" The mapleader has to be set before vundle starts loading all
" the plugins.
let mapleader=","

" ==================== Plugins ======================

" download vim-plug if missing
if empty(glob("~/.vim/autoload/plug.vim"))
  silent! execute '!curl --create-dirs -fsSLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * silent! PlugInstall
endif

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-commentary' " Comment stuff out. Use gcc to comment out a line.
Plug 'tpope/vim-fugitive'   " Fugitive is the premier Vim plugin for Git.
Plug 'tpope/vim-surround'   " All about surroundings: parentheses, brackets, quotes, XML tags, and more.

Plug 'airblade/vim-gitgutter'

Plug 'preservim/nerdtree'

Plug 'majutsushi/tagbar'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'arcticicestudio/nord-vim'

Plug 'ryanoasis/vim-devicons'

" Initialize plugin system
call plug#end()

" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb

" ================ Persistent Undo ==================

" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo') && isdirectory(expand('~').'/.vim/backups')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

" =========== Restore Last Position =================

" When reopening a file, move the cursor to the last
" edit position.
autocmd BufReadPost * 
  \ if line("'\"") > 1 && line("'\"") <= line("$") | 
  \   exe "normal! g'\"" | 
  \ endif

" =========== Strip Trailing Spaces =================

autocmd FileType css,java,js,php 
    \ autocmd BufWritePre <buffer> %s/\s\+$//e

" ================ Completion =======================

set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildmode=list:longest
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/cache/**
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

set pumheight=20

" ================ Indentation ======================

set autoindent
set tabstop=4
set shiftwidth=4
set smartindent
set smarttab
set expandtab

filetype plugin on
filetype indent on

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:.

set linebreak    "Wrap lines at convenient points
set nowrap

" ================ Folds ============================

set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================ NERDTree =========================

" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
  \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ================ Search ===========================

set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital

" ================ Security ==========================

set modelines=0
set nomodeline

" ================ Shortcuts =========================

" NERDTree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Fuzzy File Search
nnoremap <C-p> :FZF<CR>

" Tagbar Objects
nnoremap <C-o> :TagbarToggle<CR>

" ================ Tagbar ============================

let g:tagbar_autofocus = 1  " Move cursor to tagbar when opened
let g:tagbar_compact = 2    " Don't show the short help

" ================ Theme =============================

let g:airline_powerline_fonts = 1

if filereadable(expand("~/.vim/plugged/nord-vim/colors/nord.vim"))
  colorscheme nord
endif

" ================ Tweaks ============================

" Avoid accidental encryption when exiting Vim
cmap X^M x^M
