" Vim Compiler File
" Compiler: perlcritic
" Maintainer: Jessica K McIntosh AT gmail DOT com
" Original Author: Scott Peshak <speshak@gmail.com>

" Description:
" Compiler plugin to check Perl files with perlcritic.
" To use excute ':compiler perlcritic' them use ':make' or ':lmake'.
" See ':help make' in Vim for details.

if exists("current_compiler")
	finish
endif
let current_compiler = "perlcritic"

if exists(":CompilerSet") != 2 
	command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

if !exists('g:perlcritic_compiler_level')
    let g:perlcritic_compiler_level = 3
endif

" Changed output format and made the check level an option.
execute 'CompilerSet makeprg=perlcritic\ -verbose\ \"\\%f:\\%l:\\%c:\\%m.\ \\%e.\ (\\%s)\\n\"\ -' . g:perlcritic_compiler_level . '\ %'
CompilerSet errorformat=%f:%l:%c:%m

let &cpo = s:cpo_save
unlet s:cpo_save
