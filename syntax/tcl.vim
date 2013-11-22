" Vim syntax file for Tcl language
" Language:     Tcl (NO Tk)
" Maintained:   Jessica K McIntosh AT gmail DOT com
" Last Changed: Fri Nov 22 05:13 AM 2013 EST
" Filenames:    *.tcl
" GitHub Home:  https://github.com/JessicaKMcIntosh/Vim
"
" Based on the Tcl.vim script by SM Smithfield.
" See vim.org for the original.
"
" I ripped out all the Tk stuff, I don't use it.
" I am working on updating, simplifying and fixing some strange bugs.
" Additions are being made for Jim TCL extensions.
" This file is very much a work in progress.
"
" ------------------------------------------------------------------------
" Note: Procedure Name Color
" Procedure names in the 'proc' command are highlighted as 'Operator'.
" In my Vim setup this is orange. Most color schemes do not make 'Operator'
" stand out clearly. To change the procedure color alter the 'tclProcName'
" definition below. I suggest string for a good substiture.
" The line resembles:
"   HiLink tclProcName       Operator
" ------------------------------------------------------------------------
"
" To diable highlighting words that start with an underscore as errors set the
" variable g:tcl_syntax_underscore to a true value. eg.
"   let g:tcl_syntax_underscore=1

" -------------------------
if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif
" -------------------------

" -------------------------
" Pod Include:
" -------------------------
" unlet tcl_include_pod " Disable Perl POD highlighting.
" let tcl_include_pod=1 " Enable Perl POD highlighting.

" Include Perl POD as embedded documentation.
" POD documentation can be embedded inside two containers:
"   if {0} {}   - Acts like a comment.
"   pod_doc {}  - A dummy procedure that does nothing.
" POD must be properly formatted per the POD specification.
"
"#  POD Embedding procedure.
"#  Does nothing, allows POD to be easily embedded.
"proc pod_doc {args} {
"    return
"}
"
"# Example of embedded POD documentation.
"pod_doc {
"=head1 POD
"
"Sample POD documentation embedded in Tcl.
"
"=cut
"}
if exists("tcl_include_pod")
    if exists("b:current_syntax")
        unlet b:current_syntax
    endif
    syn include @PerlPod syntax/pod.vim
endif

" Define this early for functions that do it all.
if version >= 508 || !exists("s:did_tcl_syn_inits")
    if version <= 508
        let s:did_tcl_syn_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif
endif

" -------------------------
" Functions:
" -------------------------

" Creates syntax highlighting for a predicate and its keywords.
"   word        The word to highlight.
"   group       The name for this group.
"               Also changes the syntax group.
"               Used to match switches for a subcommand.
"   keywords    The keywords to highlight as a pattern.
function s:pred_w_switches(word, group, keywords)
    let l:syn_group = 'tcl' . a:word . 'Options'
    let l:contains = l:syn_group
    let l:group = a:group
    let l:syn = 'tclSubcommand'
    if a:group == ''
        let l:group = 'tclPredicates'
        let l:syn = 'tclPrimary'
    endif
    execute 'syn region' l:group 'contained transparent matchgroup=' . l:syn ' keepend'
          \ 'start=+\<' . a:word . '\>+ matchgroup=NONE skip=+\\$+ end=+}\|]\|;\|$\|--+'
          \ 'contains=' . l:syn_group . ',@tclOpts'
    execute 'syn match' l:syn_group 'contained' a:keywords
    execute 'HiLink' l:syn_group  'tclOption'
    return l:syn_group
endfunction

" Creates syntax highlighting for a predicate and its subcommands.
"   word        The word to highlight.
"   incl        Group to include in the region. 
"               Used to point to switches for a subcommand.
"   keywords    The keywords to highlight as a string.
function s:pred_w_subcmd(word, incl, keywords)
    let l:syn_group = 'tcl' . a:word . 'Options'
    let l:contains = l:syn_group
    if a:incl != ''
        let l:contains = l:syn_group . ',' . a:incl
    endif
    execute 'syn region tclPredicates contained transparent matchgroup=tclPrimary keepend'
          \ 'start=+\<' . a:word . '\>+ matchgroup=NONE skip=+\\$+ end=+}\|]\|;\|$+'
          \ 'contains=' . l:contains . ',@tclOpts'
    execute 'syn keyword' l:syn_group 'contained' a:keywords
    execute 'HiLink' l:syn_group 'tclSubcommand'
    return l:syn_group
endfunction

" -------------------------
" Basics:
" -------------------------
" see Note in :h /\@=
syn match   tclKeywordGroup contained "\([^\[{ ]\)\@<!\w\+" contains=@tclKeywords
syn region  tclWord1        contained start=+[^\[#{}"\]]\&\S+ skip=+\\$+ end=+}\|]\|;\|$+ contains=@tclStuff
syn region  tclWord0        contained start=+[^#]\&\S+ end=+\s\|$+ contains=@tclWord0Clstr skipwhite nextgroup=@tclWord1Cluster
syn region  tclQuotes       contained extend keepend matchgroup=tclQuotes start=+\(\\\)\@<!"+ end=+"+ skip=+\(\\\)\@<!\\"\|\(\\\\\\\)\@<!\\"\|\\\\+ contains=@tclQuotesClstr,tclBrackets,tclVariable
syn region  tclBrackets     contained extend keepend matchgroup=tclBracketsHighlight start=+\(\\\)\@<!\[+ end=+]+ skip=+\(\\\)\@<!\\]+ contains=@tclCommandClstr
syn region  tclBraces       contained extend keepend matchgroup=tclBracesHighlight start=+\(\\\)\@<!{+  end=+}+ skip=+$\|\(\\\)\@<!\\}+ contains=@tclCommandClstr,tclComment
syn region  tclFoldBraces   contained extend keepend fold matchgroup=tclBracesHighlight start=+\(\\\)\@<!{+ end=+}+ skip=+$\|\(\\\)\@<!\\}+ contains=@tclCommandClstr
syn match   tclSemiColon    contained ";\s*" skipwhite nextgroup=@tclCommandClstr
syn region  tclComment      contained extend keepend start=+^\s*\#+ms=e-1 start=+\([;{]\s*\)\@<=\#+ end="\\\s\+$\|$" skip=+\\$+ contains=tclTodo,tclCommentTitle,@tclLContinue,@Spell
syn match   tclCommentTitle contained "\(#\s*\)\@<=\u[[:alnum:][:space:]]\+:"
syn match   tclNamespace    "::\([^: ]\+::\)*"
syn match   tclEndOpts      contained "--"

syn region  tclCommand      start=+[^;]\&.+ skip=+\\$+ end=+;\|$+ contains=@tclCommandClstr

syn match   tclStart        "\%^\s*#!.*$"
syn region  tclStart        start="\%^\s*#!/bin/sh"  end="^\s*exec.*$"

syn match   tclBraceError   "}"
syn match   tclBracketError "]"
syn match   tclIfError      contained "\s\+[\[(].*"

" Embedded Perl POD documentation.
syn region perlPODProc      contained start=+^pod_doc\s*{$+ skip=+$\|\(\\\)\@<!\\}+ end=+^\s*}$+ contains=@PerlPod,@Spell,tclTodo

" -------------------------
" Clusters:
" -------------------------
syn cluster tclKeywords     contains=tclPrimary,tclPredicates,tclKeyword,tclConditional,tclRepeat,tclLabel,tclMagicName
" ------------------
syn cluster tclBits         contains=PerlPODProc,tclBraces,tclBrackets,tclComment,tclExpand,@tclLContinue,tclNumber,tclQuotes,tclSpecial,tclSemiColon,tclNamespace,tclUnderscore
syn cluster tclStuff        contains=@tclBits,tclVariable,tclREClassGroup
syn cluster tclOpts         contains=tclEndOpts,@tclStuff
syn cluster tclWord0Clstr   contains=@tclStuff
syn cluster tclWord1Clstr   contains=tclWord1,tclSecondary,tclConditional,@tclStuff
syn cluster tclQuotesClstr  contains=tclSpecial,@tclLContinue,@Spell
syn cluster tclLContinue    contains=tclLContinueOk,tclLContinueError
syn cluster tclCommandClstr contains=@tclKeywords,tclWord0,tclComment



" -------------------------
" Tcl: Syntax
" -------------------------
syn keyword tclKeyword      contained append apply auto_execok auto_import auto_load auto_mkindex auto_qualify auto_reset cd close concat eof exit error fblocked flush format gets global http incr join lappend lassign lindex linsert llength lmap load lrepeat lreplace lreverse lset namespace parray pid pkg_mkIndex proc pwd registry rename scan set split tclLog tcl_endOfWord tcl_findLibrary tcl_startOfNextWord tcl_startOfPreviousWord tcl_wordBreakAfter tcl_wordBreakBefore tell time unknown upvar variable vwait skipwhite nextgroup=tclPred
syn keyword tclMagicName    contained argc argv argv0 auto_index auto_oldpath auto_path env errorCode errorInfo tcl_interactive tcl_libpath tcl_library tlc_patchlevel tcl_pkgPath tcl_platform tcl_precision tcl_rcFileName tcl_rcRsrcName tcl_traceCompile tcl_traceExec tcl_version
" ------------------
syn region  tclPred         contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=@tclStuff

" CONDITIONALS
syn keyword tclPrimary      contained if skipwhite nextgroup=tclIfError,tclIfCommentStart,tclExpression,@tclStuff
syn keyword tclConditional  contained elseif skipwhite nextgroup=tclExpression,@tclStuff
syn keyword tclConditional  contained else then

" REPEAT
" syn keyword tclRepeat       contained for skipwhite nextgroup=tclForStart,@tclStuff
syn keyword tclRepeat       contained for skipwhite nextgroup=tclForStart
syn match   tclForStart     contained extend "\s*{[^}]\{-}}" contains=@tclCommandClstr skipwhite nextgroup=tclExpression,@tclStuff
syn keyword tclRepeat       contained while skipwhite nextgroup=tclExpression,@tclStuff
syn keyword tclRepeat       contained foreach skipwhite nextgroup=tclPred
syn keyword tclRepeat       contained break continue
syn keyword tclLabel        contained default

" EXPRESSION - that presumes to be an expression, occurs in expr, conditional, loops, etc...
syn keyword tclPrimary      contained expr skipwhite nextgroup=tclExpression
syn match   tclExpression   contained "\\" skipwhite skipnl nextgroup=tclExpression contains=tclLContinueOk
syn match   tclExpression   contained extend "\\\s\+$" contains=tclLContinueError
syn region  tclExpression   contained extend start=+[^ {\\]+ skip=+\\$+ end=+}\|]\|;\|$+me=e-1 contains=tclMaths,@tclStuff
" NOTE: must include '\s*' in start, for while etc don't work w/o it, I think
" this is because matching the whitespace allows the expression to supercede
" the other regions
syn region  tclExpression   contained keepend extend matchgroup=tclBracesExpression start=+\s*{+ end=+}+ skip=+$\|\\}+ contains=tclMaths,@tclStuff
syn keyword tclMaths        contained abs acos asin atan atan2 bool ceil cos cosh double entier exp floor fmod hypot int isqrt log log10 max min pow rand round sin sinh sqrt srand tan tanh wide
syn keyword tclMaths        contained ne eq in ni
syn match   tclMaths        contained "[()^%~<>!=+*\-|&?:/]"

" IF - permits use of if{0} {} commenting idiom
syn region  tclIfComment    contained extend keepend matchgroup=Comment start=+\(\\\)\@<!{+  skip=+$\|\\}+ end=+}+ contains=@PerlPod,tclIfComment,tclTodo,@Spell
syn match   tclIfCommentStart contained extend  "\s*\(0\|{0}\)" skipwhite nextgroup=tclIfComment

" Variable name highlighting.
syn keyword tclPrimary      contained append foreach incr lappend lset set skipwhite nextgroup=tclVarName
syn match   tclVarName      contained "\a\S\+" skipwhite contains=@tclStuff
syn keyword tclPrimary      contained global variable skipwhite nextgroup=tclVarNames
syn match   tclVarNames     contained "\a.\+\($\|;\)" skipwhite contains=@tclStuff,tclVarName

" PROC - proc name hilite AND folding
syn keyword tclPrimary      contained proc _proc skipwhite nextgroup=tclProcName
" type-name-args-script pattern
syn match   tclProcType     contained "\S\+" skipwhite nextgroup=tclProcName
syn match   tclProcName     contained "\S\+" skipwhite contains=tclNamespace nextgroup=tclProcArgs
syn region  tclProcArgs     contained extend keepend excludenl matchgroup=tclBracesArgs start=+\(\\\)\@<!{+ end=+}+ skip=+$\|\(\\\)\@<!\\}+ skipwhite nextgroup=tclFoldBraces

" Underscore leader. Make it stand out.
if !exists('g:tcl_syntax_underscore')
    syn match   tclUnderscore   contained "\<_\w\+\>" skipwhite
endif


" -------------------------
" Tcl: Syntax - Bits
" -------------------------
syn keyword tclTodo         contained TODO XXX
syn match   tclNumber       contained "\<\d\+\(u\=l\=\|lu\|f\|L\)\>"
syn match   tclNumber       contained "\<\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\=\>"
syn match   tclNumber       contained "\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"
syn match   tclNumber       contained "\<\d\+e[-+]\=\d\+[fl]\=\>"
syn match   tclNumber       contained "0x[0-9a-f]\+\(u\=l\=\|lu\)\>"
syn match   tclVariable     contained "\$\(\(:\{2,}\)\?\([[:alnum:]_]*::\)*\)[[:alnum:]_]*"
syn region  tclVariable     contained start=+\$\(\(:\{2,}\)\?\([[:alnum:]_]*::\)*\)[[:alnum:]_]\+(+ skip=+\\)+ end=+)+ contains=@tclStuff
syn match   tclVariable     contained extend "${[^}]*}"
syn match   tclSpecial      contained "\\\d\d\d\=\|\\."
syn match   tclLContinueOk  contained "\\$" " transparent
syn match   tclLContinueError contained "\\\s\+$" excludenl
syn match   tclExpand       contained extend "{expand}"
syn match   tclExpand       contained extend "{\*}"
syn match   tclREClassGroup contained extend +\(\\\)\@<!\[^\?\[:\(\w\+\|[<>]\):]_\?]+  contains=tclREClass
syn keyword tclREClass      contained alpha upper lower digit xdigit alnum print blank space punct graph cntrl 



" -------------------------
" Tcl: Syntax - Keyword Predicates
" -------------------------
 
" SPECIAL CASE: predicate can contain a command 
syn region  tclListPred     contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=@tclCommandClstr
syn keyword tclPrimary      contained eval list skipwhite nextgroup=tclListPred


" SPECIAL CASE: contains a command and a level
syn region  tclUplevelPred  contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=@tclCommandClstr
syn match   tclUplevelLevel contained "\S\+" contains=@tclCommandClstr skipwhite nextgroup=tclUplevelPred
syn keyword tclPrimary      contained uplevel skipwhite nextgroup=tclUplevelLevel


" SPECIAL CASE: FOLDING
syn keyword tclPrimary                  contained namespace skipwhite nextgroup=tclNamespacePred
syn keyword tclNamespaceCmds            contained children code current delete eval exists forget inscope origin parent path qualifiers tail unknown upvar
syn region  tclNamespacePred            contained keepend fold start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclNamespaceCmds,tclNamespaceEnsemble,@tclStuff
syn match   tclNamespaceExportOptsGroup contained "-\a\+" contains=tclNamespaceExportOpts
syn keyword tclNamespaceExportOpts      contained clear force command variable
syn region  tclNamespaceExportPred      contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclNamespaceExportOptsGroup,@tclStuff
syn keyword tclNamespaceCmds            contained export import which skipwhite nextgroup=tclNamespaceExportPred
syn match   tclNamespaceEnsembleExistsOptsGroup contained "-\a\+" contains=tclNamespaceEnsembleExistsOpts
syn keyword tclNamespaceEnsembleExistsOpts      contained map prefixes subcommands unknown command namespace
syn region  tclNamespaceEnsembleExistsPred      contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclNamespaceEnsembleExistsOptsGroup,@tclStuff
syn keyword tclNamespaceEnsembleCmds    contained exists create configure skipwhite nextgroup=tclNamespaceEnsembleExistsPred
syn region  tclNamespaceEnsemblePred    contained keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclNamespaceEnsembleCmds,@tclStuff
syn keyword tclNamespaceEnsemble        contained ensemble skipwhite nextgroup=tclNamespaceEnsemblePred

" Predicates with switches.
call s:pred_w_switches('catch',     '','"-\(\(no\)\?\(break\|continue\|eval\|exit\|signal\)\)\>"')
call s:pred_w_switches('exec',      '','"-\(keepnewline\|ignorestderr\)\>"')
call s:pred_w_switches('fconfigure','','"-\(blocking\|buffering\|buffersize\|encoding\|eofchar\|error\|translation\)\>"')
call s:pred_w_switches('fcopy',     '','"-\(size\|command\)\>"')
call s:pred_w_switches('glob',      '','"-\(directory\|join\|nocomplain\|path\|tails\|types\)\>"')
call s:pred_w_switches('lsearch',   '','"-\(exact\|glob\|regexp\|sorted\|all\|inline\|not\|ascii\|dictionary\|integer\|nocase\|real\|decreasing\|increasing\|subindices\|start\|index\)\>"')
call s:pred_w_switches('lsort',     '','"-\(ascii\|dictionary\|integer\|real\|increasing\|decreasing\|indicies\|nocase\|unique\|command\|index\)\>"')
call s:pred_w_switches('open',      '','"-\(mode\|handshake\|queue\|timeout\|ttycontrol\|ttystatus\|xchar\|pollinterval\|sysbuffer\|lasterror\)\>"')
call s:pred_w_switches('puts',      '','"-\(nonewline\)\>"')
call s:pred_w_switches('read',      '','"-\(nonewline\)\>"')
call s:pred_w_switches('regexp',    '','"-\(about\|expanded\|indices\|line\|linestop\|lineanchor\|nocase\|all\|inline\|start\)\>"')
call s:pred_w_switches('regsub',    '','"-\(all\|expanded\|line\|linestop\|nocase\|start\)\>"')
call s:pred_w_switches('return',    '','"-\(code\|errorcode\|errorinfo\|level\|options\)\>"')
call s:pred_w_switches('socket',    '','"-\(server\|myaddr\|myport\|async\|myaddr\|error\|sockname\|peername\)\>"')
call s:pred_w_switches('source',    '','"-\(encoding\)\>"')
call s:pred_w_switches('subst',     '','"-\(nocommands\|novariables\|nobackslashes\)\>"')
call s:pred_w_switches('switch',    '','"-\(exact\|glob\|regexp\|nocase\|matchvar\|indexvar\)\>"')
call s:pred_w_switches('unload',    '','"-\(nocomplain\|keeplibrary\)\>"')
call s:pred_w_switches('unset',     '','"-\(nocomplain\)\>"')

" Predicates with sub commands.
call s:pred_w_subcmd('after',       '','cancel idle info')
call s:pred_w_subcmd('binary',      '','format scan decode encode')
call s:pred_w_subcmd('encoding',    '','convertfrom convertto names system')
call s:pred_w_subcmd('fileevent',   '','readable writable')
call s:pred_w_subcmd('info',        '','args body cmdcount commands complete default exists frame functions globals hostname level library loaded locals nameofexecutable patchlevel procs script sharedlibextension tclversion vars')
call s:pred_w_subcmd('lrange',      '','start end')
call s:pred_w_subcmd('memory',      '','active break info init onexit tag trace validate')
call s:pred_w_subcmd('seek',        '','start current end')
call s:pred_w_subcmd('update',      '','idletasks')

" Predicates with subcommands with switches.
call s:pred_w_switches('names',     'tclArrayNames','"-\(exact\|glob\|regexp\)\>"')
call s:pred_w_subcmd('array',       'tclArrayNames','anymore donesearch exists get nextelement set size startsearch statistics unset')

call s:pred_w_switches('add',       'tclClockOptions','"-\(base\|format\|gmt\|locale\|timezone\)\>"')
call s:pred_w_switches('clicks',    'tclClockOptions','"-\(base\|format\|gmt\|locale\|timezone\)\>"')
call s:pred_w_switches('format',    'tclClockOptions','"-\(base\|format\|gmt\|locale\|timezone\)\>"')
call s:pred_w_switches('scan',      'tclClockOptions','"-\(base\|format\|gmt\|locale\|timezone\)\>"')
call s:pred_w_subcmd('clock',       'tclClockOptions','microseconds milliseconds seconds')

call s:pred_w_switches('filter',    'tclDictFilter','"\<\(key\|script\|value\)\>"')
call s:pred_w_subcmd('dict',        'tclDictFilter','append create exists for get incr info keys lappend merge remove replace set size unset update values with')

syn keyword tclPrimary contained chan skipwhite nextgroup=tclChanPred
syn region  tclChanPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclChanCmds,@tclStuff
syn keyword tclChanCmds contained blocked close create eof event flush gets names pending postevent seek tell truncate skipwhite nextgroup=tclChanCmdsBlockedPred
syn region  tclChanCmdsBlockedPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=,@tclStuff
syn match   tclChanCmdsConfigureOptsGroup contained "-\a\+" contains=tclChanCmdsConfigureOpts
syn keyword tclChanCmdsConfigureOpts contained blocking buffering buffersize encoding eofchar translation
syn keyword tclChanCmds contained configure skipwhite nextgroup=tclChanCmdsConfigurePred
syn region  tclChanCmdsConfigurePred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclChanCmdsConfigureOptsGroup,@tclStuff skipwhite nextgroup=tclChanCmds
syn match   tclChanCmdsCopyOptsGroup contained "-\a\+" contains=tclChanCmdsCopyOpts
syn keyword tclChanCmdsCopyOpts contained size command
syn keyword tclChanCmds contained copy skipwhite nextgroup=tclChanCmdsCopyPred
syn region  tclChanCmdsCopyPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclChanCmdsCopyOptsGroup,@tclStuff skipwhite nextgroup=tclChanCmds
syn match   tclChanCmdsPutsOptsGroup contained "-\a\+" contains=tclChanCmdsPutsOpts
syn keyword tclChanCmdsPutsOpts contained nonewline
syn keyword tclChanCmds contained puts read skipwhite nextgroup=tclChanCmdsPutsPred
syn region  tclChanCmdsPutsPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclChanCmdsPutsOptsGroup,@tclStuff skipwhite nextgroup=tclChanCmds
syn keyword tclSecondary contained initialize finalize watch read write seek configure cget cgetall blocking skipwhite nextgroup=tclChanSUBInitializePred
syn region  tclChanSUBInitializePred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=@tclStuff

syn keyword tclPrimary contained file skipwhite nextgroup=tclFilePred
syn region  tclFilePred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclFileCmds,@tclStuff
syn keyword tclFileCmds contained channels dirname executable exists extension isdirectory isfile join link lstat mkdir mtime nativename normalize owned pathtype readable readlink rootname separator size split stat system tail volumes writable skipwhite nextgroup=tclFileCmdsChannelsPred
syn region  tclFileCmdsChannelsPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=,@tclStuff
syn match   tclFileCmdsAtimeOptsGroup contained "-\a\+" contains=tclFileCmdsAtimeOpts
syn keyword tclFileCmdsAtimeOpts contained time
syn keyword tclFileCmds contained atime skipwhite nextgroup=tclFileCmdsAtimePred
syn region  tclFileCmdsAtimePred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclFileCmdsAtimeOptsGroup,@tclStuff skipwhite nextgroup=tclFileCmds
syn match   tclFileCmdsCopyOptsGroup contained "-\a\+" contains=tclFileCmdsCopyOpts
syn keyword tclFileCmdsCopyOpts contained force
syn keyword tclFileCmds contained copy delete rename skipwhite nextgroup=tclFileCmdsCopyPred
syn region  tclFileCmdsCopyPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$\|--+ contains=tclFileCmdsCopyOptsGroup,@tclStuff skipwhite nextgroup=tclFileCmds
syn match   tclFileCmdsAttributesOptsGroup contained "-\a\+" contains=tclFileCmdsAttributesOpts
syn keyword tclFileCmdsAttributesOpts contained group owner permissions readonly archive hidden longname shortname system creator rsrclength
syn keyword tclFileCmds contained attributes skipwhite nextgroup=tclFileCmdsAttributesPred
syn region  tclFileCmdsAttributesPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclFileCmdsAttributesOptsGroup,@tclStuff skipwhite nextgroup=tclFileCmds

syn keyword tclPrimary contained history skipwhite nextgroup=tclHistoryPred
syn region  tclHistoryPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclHistoryCmds,@tclStuff
syn keyword tclHistoryCmds contained change clear event info keep nextid redo skipwhite nextgroup=tclHistoryCmdsChangePred
syn region  tclHistoryCmdsChangePred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=,@tclStuff
syn keyword tclHistoryCmdsAddCmds contained exec skipwhite nextgroup=tclHistoryCmdsAddCmdsExecPred
syn region  tclHistoryCmdsAddCmdsExecPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=,@tclStuff
syn keyword tclHistoryCmds contained add skipwhite nextgroup=tclHistoryCmdsAddPred
syn region  tclHistoryCmdsAddPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclHistoryCmdsAddCmds,@tclStuff skipwhite nextgroup=tclHistoryCmds

syn keyword tclPrimary contained package skipwhite nextgroup=tclPackagePred
syn region  tclPackagePred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclPackageCmds,@tclStuff
syn keyword tclPackageCmds contained forget ifneeded names provide unknown vcompare versions vsatisfies skipwhite nextgroup=tclPackageCmdsForgetPred
syn region  tclPackageCmdsForgetPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=,@tclStuff
syn match   tclPackageCmdsPresentOptsGroup contained "-\a\+" contains=tclPackageCmdsPresentOpts
syn keyword tclPackageCmdsPresentOpts contained exact
syn keyword tclPackageCmds contained present require skipwhite nextgroup=tclPackageCmdsPresentPred
syn region  tclPackageCmdsPresentPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclPackageCmdsPresentOptsGroup,@tclStuff skipwhite nextgroup=tclPackageCmds


syn keyword tclPrimary contained string skipwhite nextgroup=tclStringPred
syn region  tclStringPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclStringCmds,@tclStuff
syn keyword tclStringCmds contained bytelength first index last length range repeat replace reverse tolower totitle toupper trim trimleft trimright wordend wordstart skipwhite nextgroup=tclStringCmdsBytelengthPred
syn region  tclStringCmdsBytelengthPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=,@tclStuff
syn match   tclStringCmdsCompareOptsGroup contained "-\a\+" contains=tclStringCmdsCompareOpts
syn keyword tclStringCmdsCompareOpts contained nocase length
syn keyword tclStringCmds contained compare equal skipwhite nextgroup=tclStringCmdsComparePred
syn region  tclStringCmdsComparePred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclStringCmdsCompareOptsGroup,@tclStuff skipwhite nextgroup=tclStringCmds
syn match   tclStringCmdsMapOptsGroup contained "-\a\+" contains=tclStringCmdsMapOpts
syn keyword tclStringCmdsMapOpts contained nocase
syn keyword tclStringCmds contained map match   skipwhite nextgroup=tclStringCmdsMapPred
syn region  tclStringCmdsMapPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclStringCmdsMapOptsGroup,@tclStuff skipwhite nextgroup=tclStringCmds
syn match   tclStringCmdsIsClassAlnumOptsGroup contained "-\a\+" contains=tclStringCmdsIsClassAlnumOpts
syn keyword tclStringCmdsIsClassAlnumOpts contained strict failindex
syn keyword tclStringCmdsIsClass contained alnum alpha ascii boolean control digit double false graph integer list lower print punct space true upper wideinteger wordchar xdigit skipwhite nextgroup=tclStringCmdsIsClassAlnumPred
syn region  tclStringCmdsIsClassAlnumPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclStringCmdsIsClassAlnumOptsGroup,@tclStuff skipwhite nextgroup=tclStringCmdsIsClass
syn keyword tclStringCmds contained is skipwhite nextgroup=tclStringCmdsIsPred
syn region  tclStringCmdsIsPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclStringCmdsIsClass,@tclStuff skipwhite nextgroup=tclStringCmds

syn keyword tclPrimary contained trace skipwhite nextgroup=tclTracePred
syn region  tclTracePred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclTraceCmds,@tclStuff
syn keyword tclTraceCmds contained variable vdelete vinfo skipwhite nextgroup=tclTraceCmdsVariablePred
syn region  tclTraceCmdsVariablePred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=,@tclStuff
syn keyword tclTraceCmdsAddCmdsCommandCmds contained rename trace skipwhite nextgroup=tclTraceCmdsAddCmdsCommandCmdsRenamePred
syn region  tclTraceCmdsAddCmdsCommandCmdsRenamePred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=,@tclStuff
syn keyword tclTraceCmdsAddCmds contained command skipwhite nextgroup=tclTraceCmdsAddCmdsCommandPred
syn region  tclTraceCmdsAddCmdsCommandPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclTraceCmdsAddCmdsCommandCmds,@tclStuff skipwhite nextgroup=tclTraceCmdsAddCmds
syn keyword tclTraceCmds contained add remove info skipwhite nextgroup=tclTraceCmdsAddPred
syn region  tclTraceCmdsAddPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclTraceCmdsAddCmds,@tclStuff skipwhite nextgroup=tclTraceCmds
syn keyword tclTraceCmdsAddCmdsExecutionCmds contained enter leave enterstep leavestep skipwhite nextgroup=tclTraceCmdsAddCmdsExecutionCmdsEnterPred
syn region  tclTraceCmdsAddCmdsExecutionCmdsEnterPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=,@tclStuff
syn keyword tclTraceCmdsAddCmds contained execution skipwhite nextgroup=tclTraceCmdsAddCmdsExecutionPred
syn region  tclTraceCmdsAddCmdsExecutionPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclTraceCmdsAddCmdsExecutionCmds,@tclStuff skipwhite nextgroup=tclTraceCmdsAddCmds
syn keyword tclTraceCmds contained add remove info skipwhite nextgroup=tclTraceCmdsAddPred
syn region  tclTraceCmdsAddPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclTraceCmdsAddCmds,@tclStuff skipwhite nextgroup=tclTraceCmds
syn keyword tclTraceCmdsAddCmdsVariableCmds contained array read write unset skipwhite nextgroup=tclTraceCmdsAddCmdsVariableCmdsArrayPred
syn region  tclTraceCmdsAddCmdsVariableCmdsArrayPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=,@tclStuff
syn keyword tclTraceCmdsAddCmds contained variable skipwhite nextgroup=tclTraceCmdsAddCmdsVariablePred
syn region  tclTraceCmdsAddCmdsVariablePred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclTraceCmdsAddCmdsVariableCmds,@tclStuff skipwhite nextgroup=tclTraceCmdsAddCmds
syn keyword tclTraceCmds contained add remove info skipwhite nextgroup=tclTraceCmdsAddPred
syn region  tclTraceCmdsAddPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclTraceCmdsAddCmds,@tclStuff skipwhite nextgroup=tclTraceCmds

syn keyword tclPrimary contained interp skipwhite nextgroup=tclInterpPred
syn region  tclInterpPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclInterpCmds,@tclStuff
syn match   tclInterpCmdsCreateOptsGroup contained "-\a\+" contains=tclInterpCmdsCreateOpts
syn keyword tclInterpCmdsCreateOpts contained safe
syn keyword tclInterpCmds contained create skipwhite nextgroup=tclInterpCmdsCreatePred
syn region  tclInterpCmdsCreatePred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclInterpCmdsCreateOptsGroup,@tclStuff skipwhite nextgroup=tclInterpCmds
syn match   tclInterpCmdsInvokehiddenOptsGroup contained "-\a\+" contains=tclInterpCmdsInvokehiddenOpts
syn keyword tclInterpCmdsInvokehiddenOpts contained namespace global
syn keyword tclInterpCmds contained invokehidden skipwhite nextgroup=tclInterpCmdsInvokehiddenPred
syn region  tclInterpCmdsInvokehiddenPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclInterpCmdsInvokehiddenOptsGroup,@tclStuff skipwhite nextgroup=tclInterpCmds
syn match   tclInterpCmdsLimitOptsGroup contained "-\a\+" contains=tclInterpCmdsLimitOpts
syn keyword tclInterpCmdsLimitOpts contained command granularity milliseconds seconds value
syn keyword tclInterpCmds contained limit skipwhite nextgroup=tclInterpCmdsLimitPred
syn region  tclInterpCmdsLimitPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclInterpCmdsLimitOptsGroup,@tclStuff skipwhite nextgroup=tclInterpCmds
syn keyword tclInterpCmds contained alias aliases bgerror delete eval exists expose hide hidden issafe marktrusted recursionlimit share slaves target transfer skipwhite nextgroup=tclInterpCmdsAliasPred
syn region  tclInterpCmdsAliasPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=,@tclStuff
syn keyword tclSecondary contained aliases alias bgerror eval expose hide hidden issafe marktrusted recursionlimit skipwhite nextgroup=tclInterpSUBAliasesPred
syn region  tclInterpSUBAliasesPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=@tclStuff
syn keyword tclSecondary contained invokehidden skipwhite nextgroup=tclInterpSUBInvokehiddenPred
syn region  tclInterpSUBInvokehiddenPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclInterpSUBInvokehiddenOptsGroup,@tclStuff
syn match   tclInterpSUBInvokehiddenOptsGroup contained "-\a\+" contains=tclInterpSUBInvokehiddenOpts
syn keyword tclInterpSUBInvokehiddenOpts contained namespace global
syn keyword tclSecondary contained limit skipwhite nextgroup=tclInterpSUBLimitPred
syn region  tclInterpSUBLimitPred contained excludenl keepend start=+.+ skip=+\\$+ end=+}\|]\|;\|$+ contains=tclInterpSUBLimitOptsGroup,@tclStuff
syn match   tclInterpSUBLimitOptsGroup contained "-\a\+" contains=tclInterpSUBLimitOpts
syn keyword tclInterpSUBLimitOpts contained command granularity milliseconds seconds value

" -------------------------
" Highlights: - Basic
" -------------------------
HiLink tclStart          Special
HiLink tclLContinueOK    Special
HiLink tclLContinueError Error
HiLink tclBraceError     Error
HiLink tclBracketError   Error
HiLink tclIfError        Error
HiLink tclQuotes         String
HiLink tclNumber         Number
HiLink tclComment        Comment
HiLink tclIfComment      Comment
HiLink tclIfCommentStart Comment
HiLink tclCommentTitle   PreProc
HiLink tclSpecial        Special
HiLink tclTodo           Todo
HiLink tclExpand         Underlined
HiLink tclREClassGroup   Special
HiLink tclREClass        Special
HiLink tclKeyword        Statement
HiLink tclPrimary        Statement
HiLink tclConditional    Conditional
HiLink tclRepeat         Repeat
HiLink tclLabel          Label
HiLink tclOption         PreProc
HiLink tclSecondary      Type
HiLink tclSubcommand     Type
HiLink tclVariable       Identifier
HiLink tclEnsemble       Special
HiLink tclMaths          Special
HiLink tclProcName       Operator
HiLink tclVarName        Type
HiLink tclProcType       Bold
HiLink tclMagicName      tclKeyword
HiLink tclNamespace      tclSpecial


" -------------------------
" Highlights: - Extended
" -------------------------
HiLink tclChanCmds                      tclSubcommand
HiLink tclChanCmdsConfigureOpts         tclOption
HiLink tclChanCmdsCopyOpts              tclOption
HiLink tclChanCmdsPutsOpts              tclOption
HiLink tclClockCmds                     tclSubcommand
HiLink tclClockCmdsAddOpts              tclOption
HiLink tclDictCmds                      tclSubcommand
HiLink tclDictCmdsFilterOpts            tclOption
HiLink tclFileCmds                      tclSubcommand
HiLink tclFileCmdsAtimeOpts             tclOption
HiLink tclFileCmdsAttributesOpts        tclOption
HiLink tclFileCmdsCopyOpts              tclOption
HiLink tclHistoryCmds                   tclSubcommand
HiLink tclHistoryCmdsAddCmds            tclSubcommand
HiLink tclInterpCmds                    tclSubcommand
HiLink tclInterpCmdsCreateOpts          tclOption
HiLink tclInterpCmdsInvokehiddenOpts    tclOption
HiLink tclInterpCmdsLimitOpts           tclOption
HiLink tclInterpSUBInvokehiddenOpts     tclOption
HiLink tclInterpSUBLimitOpts            tclOption
HiLink tclPackageCmds                   tclSubcommand
HiLink tclPackageCmdsPresentOpts        tclOption
HiLink tclStringCmds                    tclSubcommand
HiLink tclStringCmdsCompareOpts         tclOption
HiLink tclStringCmdsIsClass             tclEnsemble
HiLink tclStringCmdsIsClassAlnumOpts    tclOption
HiLink tclStringCmdsMapOpts             tclOption
HiLink tclTraceCmds                     tclSubcommand
HiLink tclTraceCmdsAddCmds              tclSubcommand
HiLink tclTraceCmdsAddCmdsCommandCmds   tclSubcommand
HiLink tclTraceCmdsAddCmdsExecutionCmds tclSubcommand
HiLink tclTraceCmdsAddCmdsVariableCmds  tclSubcommand

" -------------------------
" Highlights: - Special Case
" -------------------------
HiLink tclNamespaceCmds                 tclSubcommand
HiLink tclNamespaceEnsemble             tclEnsemble
HiLink tclNamespaceEnsembleCmds         tclSubcommand
HiLink tclNamespaceEnsembleExistsOpts   tclOption
HiLink tclNamespaceExportOpts           tclOption

" -------------------------
" Highlights: - Braces, brackets and such
" -------------------------
HiLink tclBracketsHighlight             Comment
HiLink tclBracesHighlight               Operator
HiLink tclBracesArgs                    Type
HiLink tclBracesExpression              Special
HiLink tclEndOpts                       Type
HiLink tclKeywordPred                   tclKeyword
HiLink tclUnderscore                    ERROR

" Perl POD Documentation.
HiLink perlPODProc                      Comment

" -------------------------
" Cleanup:
" -------------------------
delcommand HiLink
delfunction s:pred_w_switches
delfunction s:pred_w_subcmd

" -------------------------
" Hoodage:
" -------------------------

let b:current_syntax = "tcl"
" override the sync commands from the other syntax files
syn sync clear
" syn sync minlines=300
syn sync fromstart

" -------------------------

" vim:ft=vim
