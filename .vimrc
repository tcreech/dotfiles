" set up a few basic items
filetype plugin indent on
syntax enable
syntax on
se nu
set visualbell
set autochdir

" set up tabs (these are tailored toward RTM coding conventions)
set tabstop=3
set expandtab
" set smarttab
set shiftwidth=3
set shiftround
set autoindent

" set up higlighting of extra spaces and real tab characters so they can be
" spotted and removed.
au InsertEnter,BufReadPost,FileReadPost * match ExtraWhiteSpace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/
" au BufReadPost,FileReadPost * match Tab /	/
highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
" highlight Tab ctermbg=blue guibg=blue
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
" autocmd ColorScheme * highlight Tab ctermbg=blue guibg=blue

" Make a menu available with F4 even without X, so that certain plugins can be
" used.
source $VIMRUNTIME/menu.vim
set wildmenu
set cpo-=<
set wcm=<C-Z>
map <F4> :emenu <C-Z>

" set up a pretty statusline
set hlsearch
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2

" If our version supports it, use a reddish statusline in insert mode, and a
" blueish one outside of insert mode.
if version >= 700
   au InsertEnter * hi StatusLine term=reverse ctermbg=white ctermfg=darkred gui=undercurl guisp=Magenta
   au InsertLeave,BufReadPost,FileReadPost * hi StatusLine term=reverse ctermfg=darkblue ctermbg=white gui=bold,reverse
endif

" finally, select my fav color scheme
colors ron
highlight Normal ctermbg=black ctermfg=gray

