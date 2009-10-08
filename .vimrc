filetype plugin indent on
syntax enable
syntax on
se nu

set tabstop=8
set expandtab
set smarttab
set shiftwidth=3
set shiftround
set autoindent

au InsertEnter,BufReadPost,FileReadPost * match ExtraWhiteSpace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/
au BufReadPost,FileReadPost * match Tab /	/
highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
highlight Tab ctermbg=blue guibg=blue
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
autocmd ColorScheme * highlight Tab ctermbg=blue guibg=blue

source $VIMRUNTIME/menu.vim
set wildmenu
set cpo-=<
set wcm=<C-Z>
map <F4> :emenu <C-Z>

set hlsearch
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2
colors ron
