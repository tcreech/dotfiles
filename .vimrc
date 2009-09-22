syntax on
se nu
set tabstop=8
set expandtab
set smarttab
set shiftwidth=3
set shiftround
set autoindent
au InsertEnter * match ExtraWhiteSpace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/
highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
colors ron
set hlsearch
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2
au BufReadPost,FileReadPost * syntax match Tab /	/
hi Tab gui=underline guifg=blue ctermbg=blue

:source $VIMRUNTIME/menu.vim
:set wildmenu
:set cpo-=<
:set wcm=<C-Z>
:map <F4> :emenu <C-Z>
