filetype indent plugin on
syntax on
set gfn=Vera\ Sans\ Mono:h16
set nocompatible
set incsearch
set autoindent
set showmatch
set ignorecase
set magic
set nowrapscan
set optimize
set report=0
set shell=/bin/bash
set shiftwidth=4
set tabstop=8
set expandtab
""Convert all tabs typed to spaces
"set number
set taglength=32
set wrapmargin=0
hi Search		term=reverse	ctermfg=white	ctermbg=red	guifg=white	guibg=Red
""PI below is "<option>-p"
nnoremap π :set invpaste paste?<CR>
set pastetoggle=π
set showmode
