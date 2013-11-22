" Script:           emacskeys.vim
" Author:           Jessica K McIntosh AT gmail DOT com
" Requires:         Vim 7
" License:          Public Domain
" Purpose:          Emacs like keys for insert mode.

if exists('loaded_emacskeys')
  finish
endif
let loaded_emacskeys = 1

" Disable windows Alt key mappings.
set winaltkeys=no

" Start and end of the line.
inoremap <unique> <c-a>                 <Esc>I
inoremap <unique> <c-e>                 <Esc>A

" Backward and Foward by word.
inoremap <unique> <silent> <A-b>        <Esc>bi
inoremap <unique> <silent> <A-f>        <Esc>Ea

" Delete word.
inoremap <unique> <silent> <A-d>        <Esc>ldwgi

" Backward and Foward by character.
inoremap <unique> <silent> <C-b>        <Esc>i
inoremap <unique> <silent> <C-f>        <Esc>la

" Backward and Forward delete character.
inoremap <unique> <silent> <C-h>        <Esc>xi
inoremap <unique> <silent> <C-d>        <Esc>lxi

" Upper and Lower case a word.
inoremap <unique> <silent> <A-u>        <Esc>lgUwea
inoremap <unique> <silent> <A-l>        <Esc>lguwea

" vim:ft=vim :
