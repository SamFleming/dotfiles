<<<<<<< HEAD
let mapleader = "\\"

set nocompatible
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
so ~/.vim/bundles.vim

so ~/.vim/settings.vim

set hidden
set history=1000

runtime macros/matchit.vim

"if exists('+colorcolumn')
    "set colorcolumn=120 " Color the 120th column differently
"endif

set wildmenu
"set wildmode=list:longest

set noswapfile
set nobackup
set nowb

set rnu
set relativenumber number

"set backspace=indent,eol,start

syntax on
"filetype off
filetype plugin indent on
au BufNewFile,BufRead *.tpl setlocal ft=html.twig
au BufNewFile,BufRead *.twig.html setlocal ft=html.twig

"set nohlsearch
"set hlsearch
"set incsearch
"nmap <silent> <space> :silent :nohlsearch<CR>

"set listchars=tab:>-,trail:·,eol:$
"nmap <silent> <leader>w :set nolist!<CR>

set visualbell

set expandtab " tabs to spaces
set tabstop=4  " 4 spaces to a tab
set shiftwidth=4 " 4 spaces to a tab
set softtabstop=4
set smarttab
set autoindent
set showmatch
set smartindent

"function! Tab_Or_Complete()
    "if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
        "return "\<C-N>"
    "else
        "return "\<Tab>"
    "endif
"endfunction
":inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
":set dictionary="/usr/dict/words"

"set cursorline

"vnoremap <Tab> >gv
"vnoremap <S-Tab> <gv

" color codeschool
"colorscheme solarized
let g:molokai_original=1
colorscheme molokai
"colorscheme gotham

if has("gui_running")
    "set transparency=0

    " Remove the toolbar and menu bar
    set guioptions-=T
    set guioptions-=m

    " Map command-[ and command-] to indenting or outdenting
    " while keeping the original selection in visual mode
    vmap <D-]> >gv
    vmap <D-[> <gv

    nmap <D-]> >>
    nmap <D-[> <<

    omap <D-]> >>
    omap <D-[> <<

    imap <D-]> <Esc>>>i
    imap <D-[> <Esc><<i
else
    " Map command-[ and command-] to indenting or outdenting
    " while keeping the original selection in visual mode
    vmap <A-]> >gv
    vmap <A-[> <gv

    nmap <A-]> >>
    nmap <A-[> <<

    omap <A-]> >>
    omap <A-[> <<

    imap <A-]> <Esc>>>i
    imap <A-[> <Esc><<i
endif

if has('mouse')
    set mouse=a
    if &term =~ "xterm" || &term =~ "screen"
        " as of March 2013, this works:
        set ttymouse=xterm2
        
        " previously, I found that ttymouse was getting reset, so had
        " to reapply it via an autocmd like this:
        autocmd VimEnter,FocusGained,BufEnter * set ttymouse=xterm2
    endif
endif

" Disable auto folding
let g:DisableAutoPHPFolding = 1
"let php_folding=0

nmap <leader>s :set list!<CR>

inoremap {<cr> {<cr>}<c-o>O
inoremap [<cr> [<cr>]<c-o>O
inoremap (<cr> (<cr>)<c-o>O

imap <F3> <C-R>=strftime("%I:%M:%S")<CR>
=======
" Use the Solarized Dark theme
set background=dark
colorscheme solarized
let g:solarized_termtrans=1

" Make Vim more useful
set nocompatible
" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
" Enhance command-line completion
set wildmenu
" Allow cursor keys in insert mode
set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Optimize for fast terminal connections
set ttyfast
" Add the g flag to search/replace by default
set gdefault
" Use UTF-8 without BOM
set encoding=utf-8 nobomb
" Change mapleader
let mapleader=","
" Don’t add empty newlines at the end of files
set binary
set noeol
" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif

" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Respect modeline in files
set modeline
set modelines=4
" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure
" Enable line numbers
set number
" Enable syntax highlighting
syntax on
" Highlight current line
set cursorline
" Make tabs as wide as two spaces
set tabstop=2
" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list
" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
" Highlight dynamically as pattern is typed
set incsearch
" Always show status line
set laststatus=2
" Enable mouse in all modes
set mouse=a
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the cursor position
set ruler
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd
" Use relative line numbers
if exists("&relativenumber")
	set relativenumber
	au BufReadPost * set relativenumber
endif
" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Automatic commands
if has("autocmd")
	" Enable file type detection
	filetype on
	" Treat .json files as .js
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
	" Treat .md files as Markdown
	autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif
>>>>>>> mathias/master
