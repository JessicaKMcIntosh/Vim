" =============================================================================
" File:         tcldocs.vim (global plugin)
" Last Changed: Fri Nov 22 05:02 AM 2013 EST
" Maintainer:   Jessica K McIntosh AT gmail DOT com
" License:      Vim License
" =============================================================================


" Initialization.
" Allow user to avoid loading this plugin and prevent loading twice.
if exists('loaded_tcldocs')
    finish
endif

let loaded_tcldocs = 1

" Make sure the Tcl Docs can be found.
if exists('tcldocs_path')
    let s:tcldocs_path = g:tcldocs_path
else
    let s:tcldocs_path = expand('<sfile>:p:h:h') . '/tcldocs'
endif
let s:tcldocs_path = expand(s:tcldocs_path)

" Make sure the docs actually exist.
if !filereadable(s:tcldocs_path . "/tcl.txt")
    echoe "Unable to locate the Tcl Docs in '" . s:tcldocs_path . "' or they are not readable."
    finish
endif

" Easy access commands.
:command! -nargs=? TclDoc call <SID>TclDocs(<f-args>)

" Key mappings.
if !hasmapto('<Plug>TclDocsNormal')
    nmap <silent> <unique> <Leader>td <Plug>TclDocsNormal
endif
if !hasmapto('<Plug>TclDocsVisual')
    vmap <silent> <unique> <Leader>td <Plug>TclDocsVisual
endif
if !hasmapto('<Plug>TclDocsAsk')
    nmap <silent> <unique> <Leader>TD <Plug>TclDocsAsk
endif

" Plug mappings for the key mappings.
nmap <silent> <unique> <script> <Plug>TclDocsNormal      :call <SID>TclDocs(expand("<cword>"))<CR>
vmap <silent> <unique> <script> <Plug>TclDocsVisual     y:call <SID>TclDocs('<c-r>"')<CR>
nmap <silent> <unique> <script> <Plug>TclDocsAsk         :call <SID>TclDocs()<CR>

" Ask for text to lookup.
function <SID>TclDocsAsk()
    let l:string = input('Enter the word to lookup: ')
    return l:string
endfunction

" Display help on Tcl word.
function <SID>TclDocs(...)
    if a:0 == 0
        let l:word = <SID>TclDocsAsk()
    else
        let l:word = a:1
    endif

    let l:file_name = "tcl.txt"

    " Try to lookup the word.
    if l:word != '' && filereadable(s:tcldocs_path . "/" . l:word . ".txt")
        let l:file_name = l:word . ".txt"
    else
        echomsg 'Unable to locate the TCL documentation for: ' . l:word
        return
    endif

    " Display the text.
    call <SID>TclDocsWindow(l:file_name)
endfunction

" Display the fie.
" Split the window or use the existing split to display the text.
" Taken from asciitable.vim by Jeffrey Harkavy.
function <SID>TclDocsWindow(file)
    let s:vheight = 19
    let s:vwinnum=bufnr('_TclDocs_')
    if getbufvar(s:vwinnum, 'TclDocs')=='TclDocs'
        let s:vwinnum=bufwinnr(s:vwinnum)
    else
        let s:vwinnum=-1
    endif
    
    if s:vwinnum >= 0
        " if already exist
        if s:vwinnum != bufwinnr('%')
          exe "normal \<c-w>" . s:vwinnum . 'w'
        endif
        setlocal modifiable
        silent %d _
    else
        execute s:vheight.'split _TclDocs_'
    
        setlocal noswapfile
        setlocal buftype=nowrite
        setlocal bufhidden=delete
        setlocal nonumber
        setlocal nowrap
        setlocal norightleft
        setlocal foldcolumn=0
        setlocal nofoldenable
        setlocal modifiable
        let b:TclDocs='TclDocs'
    endif

    for line in readfile(s:tcldocs_path . "/" . a:file)
        silent put = line
    endfor
    goto 1
    setlocal nomodifiable
    set ft=man
endfunction
