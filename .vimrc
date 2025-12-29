set number
set relativenumber
filetype plugin indent on
set shiftwidth=4
set softtabstop=4
set tabstop=4
set smartindent
set backspace=indent,eol,start
set noshowmode
set clipboard=unnamedplus

syntax on

let mapleader = " "

imap jk <Esc>

nnoremap <leader>sf :Files<CR>
nnoremap <leader>sH:History<CR>
nnoremap <leader><space> :Buffers<CR>
nnoremap <leader>sq :CList<CR>    " For quickfix list
nnoremap <leader>sh :Helptags<CR>

" Grep current string
nnoremap <leader>ss :Rg <C-r><C-w><CR>

" Grep input string (fzf prompt)
nnoremap <leader>sg :Rg<Space>

" Grep for current file name (without extension)
nnoremap <leader>sc :execute 'Rg ' . expand('%:t:r')<CR>

" Find files in your Vim config
nnoremap <leader>si :Files ~/.vim<CR>
