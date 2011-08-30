" Vim color file
" Maintainer: Lorance Stinson <LoranceStinson@gmail.com>
" Last Change: Wed, Aug 10, 2011
" grey on black
" I dislike every color theme I've found, they all have quirks or look like
" crap on the GUI or Terminal if they look good on the other.
" I tried to make this consistent between GUI and Terminal.
" The aim was for the original Vim default colors.

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "lorance"

" GUI
highlight Comment       guifg=LightBlue                             gui=none
highlight Constant      guifg=LightRed                              gui=none
highlight Conditional   guifg=Yellow                                gui=none
highlight Cursor        guifg=Black         guibg=Green
highlight CursorLine    guifg=NONE          guibg=NONE              gui=underline
highlight DiffAdd       guifg=LightGrey     guibg=DarkBlue
highlight DiffChange                        guibg=DarkMagenta
highlight DiffDelete    guifg=DarkGrey      guibg=DarkCyan
highlight DiffText      guifg=LightGrey     guibg=Red
highlight Error         guifg=White         guibg=Red               gui=bold
highlight Ignore        guifg=White                                 gui=bold
highlight Identifier    guifg=Cyan                                  gui=none
highlight Keyword       guifg=DarkMagenta                           gui=none
highlight Normal        guifg=LightGrey     guibg=Black
highlight Operator      guifg=Brown                                 gui=none
highlight Pmenu         guifg=LightGrey     guibg=Black             gui=none
highlight PmenuSel      guifg=Black         guibg=LightMagenta      gui=none
highlight PreProc       guifg=LightMagenta                          gui=none
highlight Search        guifg=Black         guibg=Yellow
highlight Special       guifg=LightMagenta                          gui=none
highlight Statement     guifg=Yellow                                gui=none
highlight StatusLine    guifg=LightBlue     guibg=Black
highlight StatusLineNC  guifg=LightRed      guibg=Black
highlight Todo          guifg=Black         guibg=Yellow
highlight Type          guifg=LightGreen                            gui=none
highlight WarningMsg    guifg=Red                                   gui=bold

" Console
highlight Comment       ctermfg=Blue
highlight Constant      ctermfg=Red
highlight Conditional   ctermfg=Yellow
highlight Cursor        ctermfg=Black       ctermbg=Green
highlight CursorLine    ctermfg=NONE        ctermbg=NONE            cterm=underline
highlight DiffAdd       ctermfg=LightGrey   ctermbg=DarkBlue
highlight DiffChange                        ctermbg=DarkMagenta
highlight DiffDelete    ctermfg=DarkGrey    ctermbg=DarkCyan
highlight DiffText      ctermfg=LightGrey   ctermbg=Red
highlight Error         ctermfg=White       ctermbg=Red             cterm=bold
highlight Ignore        ctermfg=White                               cterm=bold
highlight Identifier    ctermfg=Cyan                                cterm=none
highlight Keyword       ctermfg=DarkMagenta
highlight Normal        ctermfg=LightGrey
highlight Operator      ctermfg=Brown
highlight Pmenu         ctermfg=LightGrey   ctermbg=Black           cterm=none
highlight PmenuSel      ctermfg=Black       ctermbg=LightMagenta    cterm=none
highlight PreProc       ctermfg=Magenta
highlight Search        ctermfg=Black       ctermbg=Yellow
highlight Special       ctermfg=Magenta
highlight Statement     ctermfg=Yellow
highlight StatusLine    ctermfg=LightBlue   ctermbg=Black
highlight StatusLineNC  ctermfg=LightRed    ctermbg=Black
highlight Todo          ctermfg=Black       ctermbg=Yellow
highlight Type          ctermfg=Green
highlight WarningMsg    ctermfg=Red                                 cterm=bold
