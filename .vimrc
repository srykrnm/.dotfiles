"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""               
"               
"               ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"               ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"               ██║   ██║██║██╔████╔██║██████╔╝██║     
"               ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║     
"                ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"                 ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"               
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ### GENERAL-SETTINGS ###

set nocompatible
filetype on
filetype plugin on
filetype indent on
syntax on
set number
set cursorline
"set cursorcolumn
"set clipboard=unnamedplus  
set noswapfile  
"set mouse=nicr
set shiftwidth=4
set tabstop=4
set expandtab
set nobackup
set scrolloff=10
set nowrap
set incsearch
set ignorecase
set smartcase
set showcmd
set showmode
set t_Co=256   
set noshowmode
set showmatch
set hlsearch
set history=1000
set wildmenu
set wildmode=list:longest

" ### MAPPINGS ###

let mapleader = " "

noremap <c-up> <c-w>+
noremap <c-down> <c-w>-
noremap <c-left> <c-w>>
noremap <c-right> <c-w><

noremap <leader>n :tabnew <cr>
noremap <leader>q :tabclose <cr>
noremap <leader>k :tabnext <cr>
noremap <leader>j :tabprev <cr>

noremap <leader>f :Lexplore <cr>

" ### VIMSCRIPT ###

autocmd Filetype html setlocal tabstop=2 shiftwidth=2 expandtab

augroup cursor_off
    autocmd!
    autocmd WinLeave * set nocursorline 
    autocmd WinEnter * set cursorline
augroup END

" ### STATUSLINE ###

" --> DEFAULT

"set statusline=
"set statusline+=\ %F\ %M\ %Y\ %R
"set statusline+=%=
"set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%
"hi StatusLine ctermbg=NONE cterm=NONE

" --> Lightline

set laststatus=2

let g:lightline = {
     \ 'colorscheme': 'darcula',
     \ }

" ### PLUGINS ###

call plug#begin('~/.vim/plugged')

 Plug 'itchyny/lightline.vim'
 Plug 'dracula/vim',{'as':'dracula'}

call plug#end()

" ### THEMING ###

colorscheme dracula
highlight Normal ctermbg=NONE

" ### END ###


