" Vim Compiler File
" Compiler: perlcritic
" Maintainer: Scott Peshak <speshak@gmail.com>
" Last Change: 2006 Dec 19

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

"execute 'CompilerSet makeprg=perlcritic\ -verbose\ 1\ -' . g:perlcritic_compiler_level . '\ %'
execute 'CompilerSet makeprg=perlcritic\ -verbose\ \"\\%f:\\%l:\\%c:\\%m.\ \\%e.\ (\\%s)\\n\"\ -' . g:perlcritic_compiler_level . '\ %'
CompilerSet errorformat=%f:%l:%c:%m

let &cpo = s:cpo_save
unlet s:cpo_save
