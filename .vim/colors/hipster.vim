" vim: tw=0 ts=4 sw=4
" Vim color file
"
" A gui color scheme intended to recreate the default color scheme on a
" 16-color terminal emulator using background=dark.
"
" Maintainer:   Tim Creech <tcreech@umd.edu>
" Last Change:  2014 Aug 17

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "hipster"
hi Normal               guifg=#eeeeec   guibg=#000000
hi NonText              guifg=#729fcf gui=bold
hi comment              guifg=#34e2e2 gui=bold
hi constant    guifg=#ad7fa8 gui=bold
hi statement    guifg=#fce94f   gui=bold
hi preproc              guifg=#729fcf gui=bold
hi type                 guifg=#8ae234   gui=bold
hi special              guifg=#ef2929 gui=bold
hi LineNr               guifg=#fce94f gui=bold
hi ShowMarksHL guifg=cyan guibg=lightblue gui=bold
hi clear Visual
hi Visual               gui=reverse
