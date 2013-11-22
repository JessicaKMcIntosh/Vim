" Vim color file
" Maintainer: Jessica McIntosh <JessicaKMcIntosh@gmail.com>
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
let g:colors_name = "jessica"

" GUI
highlight Boolean       guifg=DarkRed       guibg=Black
highlight Character     guifg=LightRed      guibg=Black
highlight ColorColumn                       guibg=#101010           gui=none
highlight Comment       guifg=LightBlue                             gui=none
highlight Constant      guifg=Red                                   gui=none
highlight Conditional   guifg=Yellow                                gui=none
highlight Cursor        guifg=Black         guibg=Green
highlight CursorLine    guifg=NONE          guibg=NONE              gui=underline
highlight CursorColumn                      guibg=#303030           gui=none
highlight DiffAdd       guifg=LightGrey     guibg=DarkBlue
highlight DiffChange                        guibg=DarkMagenta
highlight DiffDelete    guifg=DarkGrey      guibg=DarkCyan
highlight DiffText      guifg=LightGrey     guibg=Red
highlight Error         guifg=White         guibg=Red               gui=bold
highlight Exception     guifg=Yellow                                gui=underline
highlight Float         guifg=LightRed                              gui=underline
highlight Folded        guifg=LightCyan     guibg=Black             gui=none
highlight FoldColumn    guifg=LightGreen    guibg=#202020           gui=none
highlight Ignore        guifg=White                                 gui=bold
highlight Identifier    guifg=Cyan                                  gui=none
highlight Keyword       guifg=DarkMagenta                           gui=none
highlight LineNr        guifg=Blue          guibg=#202020           gui=none
highlight Normal        guifg=LightGrey     guibg=Black
highlight Number        guifg=LightRed                              gui=underline
highlight Operator      guifg=Brown                                 gui=none
highlight Pmenu         guifg=Black         guibg=LightGrey         gui=none
highlight PmenuSel      guifg=Black         guibg=LightMagenta      gui=none
highlight PreProc       guifg=LightMagenta                          gui=none
highlight Search        guifg=Black         guibg=Yellow
highlight SignColumn    guifg=LightGrey     guibg=#202020           gui=none
highlight Special       guifg=Magenta                               gui=none
highlight Statement     guifg=Yellow                                gui=none
highlight StatusLine    guifg=LightBlue     guibg=Black
highlight StatusLineNC  guifg=LightRed      guibg=Black
highlight String        guifg=LightRed      guibg=Black
highlight Todo          guifg=Black         guibg=Yellow
highlight Type          guifg=LightGreen                            gui=none
highlight WarningMsg    guifg=Red                                   gui=bold
highlight User7         guifg=Green
highlight User8         guifg=Orange                                gui=bold
highlight User9         guifg=Red                                   gui=bold
highlight VertSplit     guifg=LightBlue     guibg=Black

" Console
highlight Boolean       ctermfg=DarkRed     ctermbg=Black
highlight Character     ctermfg=Red         ctermbg=Black
highlight ColorColumn                       ctermbg=DarkGrey        cterm=none
highlight Comment       ctermfg=Blue
highlight Constant      ctermfg=DarkRed
highlight Conditional   ctermfg=Yellow
highlight Cursor        ctermfg=Black       ctermbg=Green
highlight CursorLine    ctermfg=NONE        ctermbg=NONE            cterm=underline
highlight CursorColumn                      ctermbg=LightGrey
highlight DiffAdd       ctermfg=LightGrey   ctermbg=DarkBlue
highlight DiffChange                        ctermbg=DarkMagenta
highlight DiffDelete    ctermfg=DarkGrey    ctermbg=DarkCyan
highlight DiffText      ctermfg=LightGrey   ctermbg=Red
highlight Error         ctermfg=White       ctermbg=Red             cterm=bold
highlight Exception     ctermfg=Yellow                              cterm=underline
highlight Float         ctermfg=Red                                 cterm=underline
highlight Folded        ctermfg=LightCyan   ctermbg=Black           cterm=none
highlight FoldColumn    ctermfg=LightGreen  ctermbg=DarkGrey        cterm=none
highlight Ignore        ctermfg=White                               cterm=bold
highlight Identifier    ctermfg=Cyan                                cterm=none
highlight Keyword       ctermfg=DarkMagenta
highlight LineNr        ctermfg=Blue        ctermbg=Black           cterm=none
highlight Normal        ctermfg=LightGrey
highlight Number        ctermfg=Red                                 cterm=underline
highlight Operator      ctermfg=Brown
highlight Pmenu         ctermfg=Black       ctermbg=LightGrey       cterm=none
highlight PmenuSel      ctermfg=Black       ctermbg=LightMagenta    cterm=none
highlight PreProc       ctermfg=Magenta
highlight Search        ctermfg=Black       ctermbg=Yellow
highlight SignColumn    ctermfg=LightGrey   ctermbg=DarkGrey        cterm=none
highlight Special       ctermfg=Magenta
highlight Statement     ctermfg=Yellow
highlight StatusLine    ctermfg=LightBlue   ctermbg=Black
highlight StatusLineNC  ctermfg=LightRed    ctermbg=Black
highlight String        ctermfg=Red         ctermbg=Black
highlight Todo          ctermfg=Black       ctermbg=Yellow
highlight Type          ctermfg=Green
highlight WarningMsg    ctermfg=Red                                 cterm=bold
highlight User7         ctermfg=Green
highlight User8         ctermfg=Yellow                              cterm=bold
highlight User9         ctermfg=Red                                 cterm=bold
highlight VertSplit     ctermfg=LightBlue   ctermbg=Black
