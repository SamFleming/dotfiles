let mapleader = "\\"

set nocompatible

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'jistr/vim-nerdtree-tabs'
Bundle 'kien/ctrlp.vim'
Bundle 'altercation/vim-colors-solarized'
Bundle 'stephpy/vim-yaml'
Bundle 'editorconfig/editorconfig-vim'
Bundle 'tpope/vim-surround'
Bundle 'arnaud-lb/vim-php-namespace'
"Bundle 'xolox/vim-misc'
"Bundle 'xolox/vim-easytags'
"Bundle 'SirVer/ultisnips'
Bundle 'tobyS/vmustache'
Bundle 'tobyS/pdv'
Bundle 'evidens/vim-twig'
"Bundle 'othree/html5.vim'
Bundle 'mattn/emmet-vim'
Bundle 'chriskempson/base16-vim'
Bundle 'tpope/vim-fugitive'

set hidden
set history=1000

set wildmenu

set noswapfile
set nobackup
set nowb

set rnu
set relativenumber number

syntax on
filetype plugin indent on
au BufNewFile,BufRead *.tpl setlocal ft=html.twig
au BufNewFile,BufRead *.twig.html setlocal ft=html.twig

"set nohlsearch
set hlsearch
"set incsearch
nmap <silent> <space> :silent :nohlsearch<CR>

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
set backspace=indent,eol,start
set complete-=i
set smarttab
set nrformats-=octal
set incsearch
" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif

set ruler
set showcmd

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

set encoding=utf8
let base16colorspace=256  " Access colors present in 256 colorspace"
set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors"
execute "set background=".$BACKGROUND
execute "colorscheme ".$THEME

" color codeschool
" set background=dark
" colorscheme solarized
" let g:molokai_original=1
" colorscheme molokai
" colorscheme gotham

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

nmap <leader>s :set list!<CR>

inoremap {<cr> {<cr>}<c-o>O
inoremap [<cr> [<cr>]<c-o>O
inoremap (<cr> (<cr>)<c-o>O

imap <F3> <C-R>=strftime("%I:%M:%S")<CR>

" CtrlP Settings
let g:ctrlp_map = '<leader>t'
set wildignore+=app/cache/*,vendor/*,nbproject/*,*~
set wildignore+=*/app/cache/*,*/vendor/*,*/nbproject/*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=tmp/**
set wildignore+=log/**
set wildignore+=*.png,*.jpg,*.gif,*.pdf,*.eot,*.ttf,*.woff
set wildignore+=*sess_*
set wildignore+=node_modules/*

" NerdTree settings
nmap <silent> <leader>\ :NERDTreeTabsToggle<CR>

let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:NERDTreeWinSize = 30

" Solarized Settings
let g:solarized_termcolors=256
call togglebg#map("<F2>")

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

inoremap <Leader>u <C-O>:call PhpInsertUse()<CR>
noremap <Leader>u :call PhpInsertUse()<CR>

let g:easytags_async = 1

let g:pdv_template_dir = $HOME ."/.vim/bundle/pdv/templates_snip"
nnoremap <buffer> <leader>pd :call pdv#DocumentWithSnip()<CR>

" Toggle spell check
nmap <leader>ss :setlocal spell!<CR>

nnoremap <Leader>r :%s/\<<C-r><C-w>\>/

nmap <silent> <leader>cc <Plug>NERDCommenterToggle

set showtabline=2 " always show tabs in gvim, but not vim
" set up tab labels with tab number, buffer name, number of windows
function! GuiTabLabel()
  let label = ''
  let bufnrlist = tabpagebuflist(v:lnum)
  " Add '+' if one of the buffers in the tab page is modified
  for bufnr in bufnrlist
    if getbufvar(bufnr, "&modified")
      let label = '+'
      break
    endif
  endfor
  " Append the tab number
  let label .= v:lnum.': '
  " Append the buffer name
  let name = bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
  if name == ''
    " give a name to no-name documents
    if &buftype=='quickfix'
      let name = '[Quickfix List]'
    else
      let name = '[No Name]'
    endif
  else
    " get only the file name
    let name = fnamemodify(name,":t")
  endif
  let label .= name
  " Append the number of windows in the tab page
  let wincount = tabpagewinnr(v:lnum, '$')
  return label . '  [' . wincount . ']'
endfunction
set guitablabel=%{GuiTabLabel()}
