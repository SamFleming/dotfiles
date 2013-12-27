let mapleader = "\\"

" let g:DisableAutoPHPFolding = 1

set nocompatible
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
source ~/.vim/bundles

"set hidden
set history=1000

runtime macros/matchit.vim

"if exists('+colorcolumn')
    "set colorcolumn=120 " Color the 120th column differently
"endif

set wildmenu
"set wildmode=list:longest

set backupdir=~/.vim/tmp
set directory=~/.vim/tmp

set rnu

"set backspace=indent,eol,start

syntax on
"filetype off
filetype plugin indent on
au BufNewFile,BufRead *.tpl setlocal ft=html.twig

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

set ttimeoutlen=50

if &term =~ "xterm" || &term =~ "screen"
    " as of March 2013, with current iTerm (1.0.0.20130319), tmux (1.8)
    " and Vim (7.3, with patches 1-843), this is all I need:
    let g:CommandTCancelMap     = ['<ESC>', '<C-c>']

    " when I originally started using Command-T inside a terminal,
    " I used to need these as well:
    let g:CommandTSelectNextMap = ['<C-j>', '<ESC>OB']
    let g:CommandTSelectPrevMap = ['<C-k>', '<ESC>OA']
endif

if ! has('gui_running')
    set ttimeoutlen=10
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=0
        au InsertLeave * set timeoutlen=1000
    augroup END
endif

cd ~/Sites

" Some file types should wrap their text
"function! s:setupWrapping()
    "set wrap
    "set linebreak
    "set textwidth=72
    "set nolist
"endfunction

"if has("autocmd")
    " Make sure all mardown files have the correct filetype set and setup wrapping
    "au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} setf markdown
    "au FileType markdown call s:setupWrapping()

    " Treat JSON files like JavaScript
    "au BufNewFile,BufRead *.json set ft=javascript

    " make Python follow PEP8 for whitespace ( http://www.python.org/dev/peps/pep-0008/ )
    "au FileType python setlocal softtabstop=4 tabstop=4 shiftwidth=4

    " Remember last location in file, but not for commit messages.
    " see :help last-position-jump
    "au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
                "\| exe "normal! g`\"" | endif
"endif

"if has("gui_running")
    "if has("autocmd")
        "" Automatically resize splits when resizing MacVim window
        "autocmd VimResized * wincmd =
    "endif
"endif

" NERDCommenter mappings
if has("gui_macvim") && has("gui_running")
    map <D-/> <plug>NERDCommenterToggle
    imap <D-/> <Esc><plug>NERDCommenterToggle
else
    map <leader>cc <plug>NERDCommenterToggle
endif

" Command-T exclusions
set wildignore+=app/cache/*,vendor/*,nbproject/*,*~
"nmap <silent> <leader>\ :NERDTreeToggle<CR>
nmap <silent> <leader>\ :NERDTreeTabsToggle<CR>

" Disable auto folding
let g:DisableAutoPHPFolding = 1
"let php_folding=0

" FOR STATUSLINE
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
set guifont=Monaco\ for\ Powerline:h13
set guioptions=aAce
"
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
set laststatus=2 " Always display the statusline in all windows
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)

" window
nmap <leader>swh :topleft  vnew<CR>
nmap <leader>swl :botright vnew<CR>
nmap <leader>swk :topleft  new<CR>
nmap <leader>swj :botright new<CR>

" buffer
nmap <leader>sh :leftabove  vnew<CR>
nmap <leader>sl :rightbelow vnew<CR>
nmap <leader>sk :leftabove  new<CR>
nmap <leader>sj :rightbelow new<CR>

" split navigation
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-h> <C-w>h
nmap <C-l> <C-w>l

function! MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
    "Mark destination
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe g:markedWinNum . "wincmd w"
    "Switch to source and shuffle dest->source
    let markedBuf = bufnr( "%" )
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' curBuf
    "Switch to dest and shuffle source->dest
    exe curNum . "wincmd w"
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' markedBuf 
endfunction

nmap <silent> <leader>mw :call MarkWindowSwap()<CR>
nmap <silent> <leader>pw :call DoWindowSwap()<CR>

" TagBar
nmap <D-r> :TagbarToggle<CR>
nmap <leader>r :TagbarToggle<CR>
let g:tagbar_autofocus = 1

" Trim whitespaces on save
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd FileType c,css,html,twig,cpp,java,php,ruby,python autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

nmap <leader>s :set list!<CR>

let g:UltiSnipsSnippetDirectories=["UltiSnips", "snippets"]
"let g:UltiSnipsExpandTrigger="<c-j>"

inoremap {<cr> {<cr>}<c-o>O
inoremap [<cr> [<cr>]<c-o>O
inoremap (<cr> (<cr>)<c-o>O

noremap <silent> <Leader>w :call ToggleWrap()<CR>
function! ToggleWrap()
    if &wrap
        echo "Wrap OFF"
        setlocal nowrap
        set virtualedit=all
        silent! nunmap <buffer> <Up>
        silent! nunmap <buffer> <Down>
        silent! nunmap <buffer> <Home>
        silent! nunmap <buffer> <End>
        silent! iunmap <buffer> <Up>
        silent! iunmap <buffer> <Down>
        silent! iunmap <buffer> <Home>
        silent! iunmap <buffer> <End>
    else
        echo "Wrap ON"
        setlocal wrap linebreak nolist
        set virtualedit=
        setlocal display+=lastline
        noremap  <buffer> <silent> <Up>   gk
        noremap  <buffer> <silent> <Down> gj
        noremap  <buffer> <silent> <Home> g<Home>
        noremap  <buffer> <silent> <End>  g<End>
        inoremap <buffer> <silent> <Up>   <C-o>gk
        inoremap <buffer> <silent> <Down> <C-o>gj
        inoremap <buffer> <silent> <Home> <C-o>g<Home>
        inoremap <buffer> <silent> <End>  <C-o>g<End>
    endif
endfunction
