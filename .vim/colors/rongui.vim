" vim: tw=0 ts=4 sw=4
" Vim color file
"
" The story of this color scheme is somewhat silly: it recreates (in the gui
" version of vim) the effect of using the 'ron' colorscheme with a 16-color
" terminal emulator set to use Tango colors. It turns out 'ron' is intended
" for gui vim itself, possibly not intended to be used at all with terminal
" vim. Oh well. I got really used to it and liked it and wanted to recreate
" the look in gui vim. This is the result.
"
" Maintainer:	Tim Creech <tcreech@umd.edu>
" Last Change:	2014 Aug 17

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "rongui"
hi Normal		guifg=#eeeeec	guibg=#000000
hi NonText		guifg=#729fcf gui=bold
hi comment		guifg=#34e2e2 gui=bold
hi constant    guifg=#ad7fa8 gui=bold
" hi identifier	guifg=cyan	gui=NONE
hi statement	guifg=#fce94f	gui=bold
hi preproc		guifg=#729fcf gui=bold
hi type			guifg=#8ae234	gui=bold
hi special		guifg=#ef2929 gui=bold
" hi ErrorMsg		guifg=Black	guibg=Red
" hi WarningMsg	guifg=Black	guibg=Green
" hi Error		guibg=Red
hi Todo			guifg=#000000	guibg=#edd400
" hi Cursor		guibg=#60a060 guifg=#00ff00
hi Search			guifg=#000000	guibg=#edd400
" hi IncSearch	gui=NONE guibg=steelblue
hi LineNr		guifg=#fce94f gui=bold
" hi title		guifg=darkgrey
hi ShowMarksHL guifg=cyan guibg=lightblue gui=bold
" hi StatusLineNC	gui=NONE guifg=lightblue guibg=darkblue
" hi StatusLine	gui=bold	guifg=cyan	guibg=blue
" hi label		guifg=gold2
" hi operator		guifg=orange
hi clear Visual
hi Visual		gui=reverse
" hi DiffChange   guibg=darkgreen
" hi DiffText		guibg=olivedrab
" hi DiffAdd		guibg=slateblue
" hi DiffDelete   guibg=coral
" hi Folded		guibg=gray30
" hi FoldColumn	guibg=gray30 guifg=white
" hi cIf0			guifg=gray
" hi diffOnly	guifg=red gui=bold
