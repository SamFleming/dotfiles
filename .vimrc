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
