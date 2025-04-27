syntax on
set number
set relativenumber

if v:version < 802
    packadd! dracula
endif
colorscheme dracula

" Ctrl+Z Undo
nnoremap <C-z> u

" Visual Block rebound to Alt+V (since Ctrl+V is paste in my kitty cfg)
nnoremap <M-v> <C-v>


