"set ttimeoutlen=50

"if &term =~ "xterm" || &term =~ "screen"
    " as of March 2013, with current iTerm (1.0.0.20130319), tmux (1.8)
    " and Vim (7.3, with patches 1-843), this is all I need:
    "let g:CommandTCancelMap     = ['<ESC>', '<C-c>']

    " when I originally started using Command-T inside a terminal,
    " I used to need these as well:
    "let g:CommandTSelectNextMap = ['<C-j>', '<ESC>OB']
    "let g:CommandTSelectPrevMap = ['<C-k>', '<ESC>OA']
"endif

"if ! has('gui_running')
    "set ttimeoutlen=10
    "augroup FastEscape
        "autocmd!
        "au InsertEnter * set timeoutlen=0
        "au InsertLeave * set timeoutlen=1000
    "augroup END
"endif

" Command-T exclusions
"set wildignore+=app/cache/*,vendor/*,nbproject/*,*~
"set wildignore+=*sass-cache*
"set wildignore+=*DS_Store*
"set wildignore+=tmp/**
"set wildignore+=log/**
"set wildignore+=*.png,*.jpg,*.gif,*.pdf,*.eot,*.ttf,*.woff
"set wildignore+=*sess_*
"set wildignore+=node_modules/*
