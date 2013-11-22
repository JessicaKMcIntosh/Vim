" Vim indent file
" Language:     AWK
" From:         Perl indent file.
" Author:       Jessica K McIntosh AT gmail DOT com
"
" The default AWK indention file was overly complex and simply didn't work. So
" I adapted the Perl indention file for AWK.

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal indentexpr=GetAWKIndent()
setlocal indentkeys+=0=,0),0],0=or,0=and

let s:cpo_save = &cpo
set cpo-=C

function! GetAWKIndent()
    " Get the line to be indented
    let cline = getline(v:lnum)

    " This causes strangeness. Disabled.
    "" Don't reindent coments on first column
    "if cline =~ '^#.'
        "return 0
    "endif

    " Now get the indent of the previous line.

    " Find a non-blank line above the current line.
    let lnum = prevnonblank(v:lnum - 1)
    " Hit the start of the file, use zero indent.
    if lnum == 0
        return 0
    endif
    let line = getline(lnum)
    let ind = indent(lnum)

    " Indent blocks enclosed by {}, (), or []
    if line =~ '[{\[(]\s*\(#[^)}\]]*\)\?$'
        let ind = ind + &sw
    endif
    if cline =~ '^\s*[)}\]]'
        let ind = ind - &sw
    endif

    return ind
    echo ind
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save

