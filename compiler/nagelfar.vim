" Vim compiler file
" Compiler:	tcl (Uses Nagelfar to check Syntax)
" Maintainer:	Lorance Stinson AT Gmail...
" Last Change:	2011-09-13

" Nagelfar can be downloaded from <http://nagelfar.berlios.de/>
" By default executes 'nagelfar.tcl'.
" Set g:nagelfar_file to the location of the 'nagelfar.tcl' file
" and it will be executed using tclsh.

if exists("current_compiler")
  finish
endif
let current_compiler = "tcl"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

" Make sure the continuation lines below do not cause problems in
" compatibility mode.
let s:cpo_save = &cpo
set cpo-=C

if exists('g:nagelfar_file')
    let s:nagelfar_cmd='tclsh\ ' . g:nagelfar_file
else
    let s:nagelfar_cmd='nagelfar.tcl'
endif

execute 'CompilerSet makeprg=' . s:nagelfar_cmd . '\ -H\ %'

CompilerSet errorformat=
    \%I%f:\ %l:\ N\ %m,
    \%f:\ %l:\ %t\ %m,
    \%-GChecking\ file\ %f

" Restore the saved compatibility options.
let &cpo = s:cpo_save
