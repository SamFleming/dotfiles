set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-13.(%l,%c%V%)\ %P
set encoding=utf-8

if !has("gui_macvim")
    set guifont=Consolas\ for\ Powerline\ FixedD:h9
else
    set guifont=Monaco\ for\ Powerline:h13
endif

set guioptions=aAce
"
so ~/Library/Python/2.7/lib/python/site-packages/powerline/bindings/vim/plugin/powerline.vim
set laststatus=2 " Always display the statusline in all windows
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)

let g:Powerline_symbols = 'fancy'
