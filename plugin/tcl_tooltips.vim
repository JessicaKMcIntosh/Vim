" Tcl Tool Tooltip/Balloon Plugin
" vim:foldmethod=marker
" File:         tcl_tooltip.vim
" Last Changed: 2011-09-07
" Maintainer:   Lorance Stinson @ Gmail ...
" Version:      0.1
" License:      Public Domain
"
" Install:       in ~/.vim/plugin or ~/vimfiles/plugin
"
" Description:
" Displays a tooltip when the cursor hovers over a TCL command or variable.
" When the buffer is written will also scan for all proc definitions.
" A tooltip will thus be displayed for all procedures in the file.
" See :help balloon for details.

" Only process the plugin once. {{{1
if exists("g:loaded_tcl_tooltip") || &cp || !has('balloon_eval')
    finish
endif
let g:loaded_tcl_tooltip = 1

" Function to return the tooltip text. {{{1
function! TclTooltipExpr()
    let l:word = v:beval_text
    let l:descr = []
    if has_key(s:tcl_commands, l:word)
        let l:descr = s:tcl_commands[l:word]
    elseif has_key(b:tcl_procs_local, l:word)
        let l:descr = b:tcl_procs_local[l:word]
    elseif has_key(s:tcl_variables, l:word)
        let l:descr = [s:tcl_variables[l:word]]
    else
        let l:descr = spellsuggest(spellbadword(v:beval_text)[0], 5, 0 )
    endif
    return join(l:descr, has("balloon_multiline") ? "\n" : " ")
endfunction

" Scan the current buffer for prodecures. {{{1
function! TclTooltipProcScan()
    let b:tcl_procs_local = {}
    let l:eof = line('$')
    let l:lnum = 1
    let l:blank = 0
    " Scan for procedure definitions.
    while l:lnum <= l:eof
        let l:line = getline(l:lnum)
        if len(l:line) == 0
            let l:blank = l:lnum
            let l:lnum = l:lnum + 1
            continue
        endif
        let l:matches = matchlist(l:line, '^\s*proc\s\+\(::\w\+::\)*\(\(\S\+\)\s\+.*\)\(\s\+{\s*$\)\?')
        if len(l:matches) != 0
            " Save the procedure.
            let l:proc = l:matches[3]
            let b:tcl_procs_local[l:proc] = []
            call extend(b:tcl_procs_local[l:proc],[l:matches[2], ''])
            " Try to find the description.
            let l:def_lnum = l:blank + 1
            while l:def_lnum < l:lnum && l:def_lnum > l:lnum - 30
                call add(b:tcl_procs_local[l:proc], getline(l:def_lnum))
                let l:def_lnum = l:def_lnum + 1
            endwhile
        endif
        let l:lnum = l:lnum + 1
    endwhile
endfunction

" Setup the balloon options for the current buffer. {{{1
function! TclTooltipsSet()
    " Set the balloonexpr for the buffer if not already set.
    if !exists("b:loaded_tcl_tooltip_buffer")
        let b:loaded_tcl_tooltip_buffer = 1

        " Balloon settings.
        setlocal bexpr=TclTooltipExpr()
        setlocal ballooneval

        " Callback to update the procedure list.
        au BufWritePost * call TclTooltipProcScan()

        " Initialize the local procedure list.
        call TclTooltipProcScan()
    endif
endfunction

" Setup the tooltips and auto command. {{{1
function! TclTooltipsSetup()
    " Check every file to see if it is a Tcl file.
    au BufReadPost,BufNewFile,FileType * if &ft == 'tcl' | call TclTooltipsSet() | endif
endfunction

call TclTooltipsSetup()

" Dictionary of Tcl commands. {{{1
let s:tcl_commands = {
    \ 'after':       ['after - Execute a command after a time delay',
    \                 '',
    \                 'after ms',
    \                 'after ms ?script script script ...?',
    \                 'after cancel id',
    \                 'after cancel script script script ...',
    \                 'after idle ?script script script ...?',
    \                 'after info ?id?'],
    \ 'append':      ['append - Append to variable',
    \                 '',
    \                 'append varName ?value value value ...?'],
    \ 'apply':       ['apply - Apply an anonymous function',
    \                 '',
    \                 'apply func ?arg1 arg2 ...?'],
    \ 'array':       ['array - Manipulate array variables',
    \                 '',
    \                 'array option arrayName ?arg arg ...?'],
    \ 'bgerror':     ['bgerror - Command invoked to process background errors',
    \                 '',
    \                 'bgerror message'],
    \ 'binary':      ['binary - Insert and extract fields from binary strings',
    \                 '',
    \                 'binary format formatString ?arg arg ...?',
    \                 'binary scan string formatString ?varName varName ...?'],
    \ 'break':       ['break - Abort looping command',
    \                 '',
    \                 'break'],
    \ 'case':        ['case - Evaluate one of several scripts, depending on a given value',
    \                 '',
    \                 'case string ?in? patList body ?patList body ...?',
    \                 'case string ?in? {patList body ?patList body ...?}'],
    \ 'catch':       ['catch - Evaluate script and trap exceptional returns',
    \                 '',
    \                 'catch script ?resultVarName? ?optionsVarName?'],
    \ 'cd':          ['cd - Change working directory',
    \                 '',
    \                 'cd ?dirName?'],
    \ 'chan':        ['chan - Read, write and manipulate channels',
    \                 '',
    \                 'chan option ?arg arg ...?'],
    \ 'clock':       ['clock - Obtain and manipulate dates and times',
    \                 '',
    \                 'package require Tcl 8.5',
    \                 'clock add timeVal ?count unit...? ?-option value?',
    \                 'clock clicks ?-option?',
    \                 'clock format timeVal ?-option value...?',
    \                 'clock microseconds',
    \                 'clock milliseconds',
    \                 'clock scan inputString ?-option value...?',
    \                 'clock seconds'],
    \ 'close':       ['close - Close an open channel',
    \                 '',
    \                 'close channelId'],
    \ 'concat':      ['concat - Join lists together',
    \                 '',
    \                 'concat ?arg arg ...?'],
    \ 'continue':    ['continue - Skip to the next iteration of a loop',
    \                 '',
    \                 'continue'],
    \ 'dde':         ['dde - Execute a Dynamic Data Exchange command',
    \                 '',
    \                 'package require dde 1.3',
    \                 'dde servername ?-force? ?-handler proc? ?--? ?topic?',
    \                 'dde execute ?-async? service topic data',
    \                 'dde poke service topic item data',
    \                 'dde request ?-binary? service topic item',
    \                 'dde services service topic',
    \                 'dde eval ?-async? topic cmd ?arg arg ...?'],
    \ 'dict':        ['dict - Manipulate dictionaries',
    \                 '',
    \                 'dict option arg ?arg ...?'],
    \ 'encoding':    ['encoding - Manipulate encodings',
    \                 '',
    \                 'encoding option ?arg arg ...?'],
    \ 'eof':         ['eof - Check for end of file condition on channel',
    \                 '',
    \                 'eof channelId'],
    \ 'error':       ['error - Generate an error',
    \                 '',
    \                 'error message ?info? ?code?'],
    \ 'eval':        ['eval - Evaluate a Tcl script',
    \                 '',
    \                 'eval arg ?arg ...?'],
    \ 'exec':        ['exec - Invoke subprocesses',
    \                 '',
    \                 'exec ?switches? arg ?arg ...?'],
    \ 'exit':        ['exit - End the application',
    \                 '',
    \                 'exit ?returnCode?'],
    \ 'expr':        ['expr - Evaluate an expression',
    \                 '',
    \                 'expr arg ?arg arg ...?'],
    \ 'fblocked':    ['fblocked  -  Test whether the last input operation exhausted all available input',
    \                 '',
    \                 'fblocked channelId'],
    \ 'fconfigure':  ['fconfigure - Set and get options on a channel',
    \                 '',
    \                 'fconfigure channelId',
    \                 'fconfigure channelId name',
    \                 'fconfigure channelId name value ?name value ...?'],
    \ 'fcopy':       ['fcopy - Copy data from one channel to another',
    \                 '',
    \                 'fcopy inchan outchan ?-size size? ?-command callback?'],
    \ 'file':        ['file - Manipulate file names and attributes',
    \                 '',
    \                 'file option name ?arg arg ...?'],
    \ 'fileevent':   ['fileevent  -  Execute  a  script  when  a  channel  becomes readable or writable',
    \                 '',
    \                 'fileevent channelId readable ?script?',
    \                 'fileevent channelId writable ?script?'],
    \ 'filename':    ['filename - File name conventions supported by Tcl commands'],
    \ 'flush':       ['flush - Flush buffered output for a channel',
    \                 '',
    \                 'flush channelId'],
    \ 'for':         ['for - "For" loop',
    \                 '',
    \                 'for start test next body'],
    \ 'foreach':     ['foreach - Iterate over all elements in one or more lists',
    \                 '',
    \                 'foreach varname list body',
    \                 'foreach varlist1 list1 ?varlist2 list2 ...? body'],
    \ 'format':      ['format - Format a string in the style of sprintf',
    \                 '',
    \                 'format formatString ?arg arg ...?'],
    \ 'gets':        ['gets - Read a line from a channel',
    \                 '',
    \                 'gets channelId ?varName?'],
    \ 'glob':        ['glob - Return names of files that match patterns',
    \                 '',
    \                 'glob ?switches? pattern ?pattern ...?'],
    \ 'global':      ['global - Access global variables',
    \                 '',
    \                 'global varname ?varname ...?'],
    \ 'history':     ['history - Manipulate the history list',
    \                 '',
    \                 'history ?option? ?arg arg ...?'],
    \ 'if':          ['if - Execute scripts conditionally',
    \                 '',
    \                 'if  expr1  ?then?  body1  elseif  expr2  ?then? body2 elseif ... ?else? ?bodyN?'],
    \ 'incr':        ['incr - Increment the value of a variable',
    \                 '',
    \                 'incr varName ?increment?'],
    \ 'info':        ['info - Return information about the state of the Tcl interpreter',
    \                 '',
    \                 'info option ?arg arg ...?'],
    \ 'interp':      ['interp - Create and manipulate Tcl interpreters',
    \                 '',
    \                 'interp subcommand ?arg arg ...?'],
    \ 'join':        ['join - Create a string by joining together list elements',
    \                 '',
    \                 'join list ?joinString?'],
    \ 'lappend':     ['lappend - Append list elements onto a variable',
    \                 '',
    \                 'lappend varName ?value value value ...?'],
    \ 'lassign':     ['lassign - Assign list elements to variables',
    \                 '',
    \                 'lassign list varName ?varName ...?'],
    \ 'lindex':      ['lindex - Retrieve an element from a list',
    \                 '',
    \                 'lindex list ?index...?'],
    \ 'linsert':     ['linsert - Insert elements into a list',
    \                 '',
    \                 'linsert list index element ?element element ...?'],
    \ 'list':        ['list - Create a list',
    \                 '',
    \                 'list ?arg arg ...?'],
    \ 'llength':     ['llength - Count the number of elements in a list',
    \                 '',
    \                 'llength list'],
    \ 'load':        ['load - Load machine code and initialize new commands',
    \                 '',
    \                 'load fileName',
    \                 'load fileName packageName',
    \                 'load fileName packageName interp'],
    \ 'lrange':      ['lrange - Return one or more adjacent elements from a list',
    \                 '',
    \                 'lrange list first last'],
    \ 'lrepeat':     ['lrepeat - Build a list by repeating elements',
    \                 '',
    \                 'lrepeat number element1 ?element2 element3 ...?'],
    \ 'lreplace':    ['lreplace - Replace elements in a list with new elements',
    \                 '',
    \                 'lreplace list first last ?element element ...?'],
    \ 'lreverse':    ['lreverse - Reverse the order of a list',
    \                 '',
    \                 'lreverse list'],
    \ 'lsearch':     ['lsearch - See if a list contains a particular element',
    \                 '',
    \                 'lsearch ?options? list pattern'],
    \ 'lset':        ['lset - Change an element in a list',
    \                 '',
    \                 'lset varName ?index...? newValue'],
    \ 'lsort':       ['lsort - Sort the elements of a list',
    \                 '',
    \                 'lsort ?options? list'],
    \ 'memory':      ['memory - Control Tcl memory debugging capabilities',
    \                 '',
    \                 'memory option ?arg arg ...?'],
    \ 'namespace':   ['namespace - create and manipulate contexts for commands and variables',
    \                 '',
    \                 'namespace ?subcommand? ?arg ...?'],
    \ 'open':        ['open - Open a file-based or command pipeline channel',
    \                 '',
    \                 'open fileName',
    \                 'open fileName access',
    \                 'open fileName access permissions'],
    \ 'package':     ['package - Facilities for package loading and version control',
    \                 '',
    \                 'package forget ?package package ...?',
    \                 'package ifneeded package version ?script?',
    \                 'package names',
    \                 'package present package ?requirement...?',
    \                 'package present -exact package version',
    \                 'package provide package ?version?',
    \                 'package require package ?requirement...?',
    \                 'package require -exact package version',
    \                 'package unknown ?command?',
    \                 'package vcompare version1 version2',
    \                 'package versions package',
    \                 'package vsatisfies version requirement...',
    \                 'package prefer ?latest|stable?'],
    \ 'pid':         ['pid - Retrieve process identifiers',
    \                 '',
    \                 'pid ?fileId?'],
    \ 'pkg_mkIndex': ['pkg_mkIndex - Build an index for automatic loading of packages',
    \                 '',
    \                 'pkg_mkIndex ?-direct?  ?-lazy?  ?-load pkgPat? ?-verbose? dir ?pattern pattern ...?'],
    \ 'proc':        ['proc - Create a Tcl procedure',
    \                 '',
    \                 'proc name args body'],
    \ 'puts':        ['puts - Write to a channel',
    \                 '',
    \                 'puts ?-nonewline? ?channelId? string'],
    \ 'pwd':         ['pwd - Return the absolute path of the current working directory',
    \                 '',
    \                 'pwd'],
    \ 're_syntax':   ['re_syntax - Syntax of Tcl regular expressions'],
    \ 'read':        ['read - Read from a channel',
    \                 '',
    \                 'read ?-nonewline? channelId',
    \                 'read channelId numChars'],
    \ 'refchan':     ['refchan - Command handler API of reflected channels, version 1',
    \                 '',
    \                 'cmdPrefix option ?arg arg ...?'],
    \ 'regexp':      ['regexp - Match a regular expression against a string',
    \                 '',
    \                 'regexp ?switches? exp string ?matchVar? ?subMatchVar subMatchVar ...?'],
    \ 'registry':    ['registry - Manipulate the Windows registry',
    \                 '',
    \                 'package require registry 1.1',
    \                 'registry option keyName ?arg arg ...?'],
    \ 'regsub':      ['regsub  -  Perform  substitutions  based  on regular expression pattern matching',
    \                 '',
    \                 'regsub ?switches? exp string subSpec ?varName?'],
    \ 'rename':      ['rename - Rename or delete a command',
    \                 '',
    \                 'rename oldName newName'],
    \ 'return':      ['return - Return from a procedure, or set return code of a script',
    \                 '',
    \                 'return ?result?',
    \                 'return ?-code code? ?result?',
    \                 'return ?option value ...? ?result?'],
    \ 'scan':        ['scan - Parse string using conversion specifiers in the style of sscanf',
    \                 '',
    \                 'scan string format ?varName varName ...?'],
    \ 'seek':        ['seek - Change the access position for an open channel',
    \                 '',
    \                 'seek channelId offset ?origin?'],
    \ 'set':         ['set - Read and write variables',
    \                 '',
    \                 'set varName ?value?'],
    \ 'socket':      ['socket - Open a TCP network connection',
    \                 '',
    \                 'socket ?options? host port',
    \                 'socket -server command ?options? port'],
    \ 'source':      ['source - Evaluate a file or resource as a Tcl script',
    \                 '',
    \                 'source fileName',
    \                 'source -encoding encodingName fileName                                  |'],
    \ 'split':       ['split - Split a string into a proper Tcl list',
    \                 '',
    \                 'split string ?splitChars?'],
    \ 'string':      ['string - Manipulate strings',
    \                 '',
    \                 'string option arg ?arg ...?'],
    \ 'subst':       ['subst - Perform backslash, command, and variable substitutions',
    \                 '',
    \                 'subst ?-nobackslashes? ?-nocommands? ?-novariables? string'],
    \ 'switch':      ['switch - Evaluate one of several scripts, depending on a given value',
    \                 '',
    \                 'switch ?options? string pattern body ?pattern body ...?',
    \                 'switch ?options? string {pattern body ?pattern body ...?}'],
    \ 'Tcl':         ['Tcl - Tool Command Language',
    \                 '',
    \                 'Summary of Tcl language syntax.'],
    \ 'tclvars':     ['tclvars - Variables used by Tcl'],
    \ 'tell':        ['tell - Return current access position for an open channel',
    \                 '',
    \                 'tell channelId'],
    \ 'time':        ['time - Time the execution of a script',
    \                 '',
    \                 'time script ?count?'],
    \ 'trace':       ['trace  -  Monitor  variable accesses, command usages and command executions',
    \                 '',
    \                 'trace option ?arg arg ...?'],
    \ 'unknown':     ['unknown - Handle attempts to use non-existent commands',
    \                 '',
    \                 'unknown cmdName ?arg arg ...?'],
    \ 'unload':      ['unload - Unload machine code',
    \                 '',
    \                 'unload ?switches? fileName',
    \                 'unload ?switches? fileName packageName',
    \                 'unload ?switches? fileName packageName interp'],
    \ 'unset':       ['unset - Delete variables',
    \                 '',
    \                 'unset ?-nocomplain? ?--? ?name name name ...?'],
    \ 'update':      ['update - Process pending events and idle callbacks',
    \                 '',
    \                 'update ?idletasks?'],
    \ 'uplevel':     ['uplevel - Execute a script in a different stack frame',
    \                 '',
    \                 'uplevel ?level? arg ?arg ...?'],
    \ 'upvar':       ['upvar - Create link to variable in a different stack frame',
    \                 '',
    \                 'upvar ?level? otherVar myVar ?otherVar myVar ...?'],
    \ 'variable':    ['variable - create and initialize a namespace variable',
    \                 '',
    \                 'variable ?name value...? name ?value?'],
    \ 'vwait':       ['vwait - Process events until a variable is written',
    \                 '',
    \                 'vwait varName'],
    \ 'while':       ['while - Execute script repeatedly as long as a condition is met',
    \                 '',
    \                 'while test body'],
    \ }

" Dictionary of Tcl variables. {{{1
let s:tcl_variables = {
    \ 'env': "env - This variable is maintained by Tcl as an  array  whose  elements are  the environment variables for the process.  Reading an element will return the  value  of  the  corresponding  environment variable.   Setting an element of the array will modify the corresponding environment variable or create a new one if  it  does not  already exist.  Unsetting an element of env will remove the corresponding environment variable.  Changes to  the  env  array will  affect the environment passed to children by commands like exec.  If the entire env array is unset then Tcl will stop monitoring env accesses and will not update environment variables.",
    \ 'errorCode': "errorCode - This  variable  holds  the value of the -errorcode return option set by the most recent error that occurred in this  interpreter.  This  list  value  represents  additional  information about the error in a form that is easy  to  process  with  programs.   The first  element of the list identifies a general class of errors, and determines the format of the rest of the list.  The  following  formats  for  -errorcode return options are used by the Tcl core; individual applications may define additional formats.",
    \ 'errorInfo': "errorInfo - This  variable  holds  the value of the -errorinfo return option set by the most recent error that occurred in this  interpreter.  This string value will contain one or more lines identifying the Tcl commands and procedures that were being  executed  when  the most  recent  error  occurred.   Its contents take the form of a stack trace showing the various nested  Tcl  commands  that  had been invoked at the time of the error.",
    \ 'tcl_library': "tcl_library - This  variable holds the name of a directory containing the system library of Tcl scripts, such as those used for auto-loading.  The  value of this variable is returned by the info library command.  See the library manual entry for details of  the  facilities provided by the Tcl script library.  Normally each application or package will have its  own  application-specific  script library  in addition to the Tcl script library; each application should set a global  variable  with  a  name  like  $app_library (where  app  is the application's name) to hold the network file name for that  application's  library  directory.   The  initial value  of  tcl_library  is set when an interpreter is created by searching several different directories until one is found  that contains  an appropriate Tcl startup script.  If the TCL_LIBRARY environment variable exists, then  the  directory  it  names  is checked first.  If TCL_LIBRARY is not set or doesn't refer to an appropriate directory, then Tcl checks several other directories based  on  a  compiled-in  default location, the location of the binary containing  the  application,  and  the  current  working directory.",
    \ 'tcl_patchLevel': "tcl_patchLevel - When  an interpreter is created Tcl initializes this variable to hold a string giving the current patch level for  Tcl,  such  as 8.4.16  for  Tcl 8.4 with the first sixteen official patches, or 8.5b3 for the third beta release of Tcl 8.5.  The value of  this variable is returned by the info patchlevel command.",
    \ 'tcl_pkgPath': "tcl_pkgPath - This variable holds a list of directories indicating where packages are normally installed.  It is not  used  on  Windows.   It typically contains either one or two entries; if it contains two entries, the first is normally a directory  for  platform-dependent  packages (e.g., shared library binaries) and the second is normally a directory for  platform-independent  packages  (e.g., script  files).  Typically a package is installed as a subdirectory of one of the entries in $tcl_pkgPath. The  directories  in $tcl_pkgPath  are included by default in the auto_path variable, so they and their  immediate  subdirectories  are  automatically searched  for  packages  during package require commands.  Note: tcl_pkgPath is not intended to be modified by  the  application.  Its  value is added to auto_path at startup; changes to tcl_pkgPath are not reflected in auto_path.  If you want Tcl to  search additional  directories for packages you should add the names of those directories to auto_path, not tcl_pkgPath.",
    \ 'tcl_platform': "tcl_platform - This is an associative array whose elements contain  information about  the platform on which the application is running, such as the name of the operating system, its  current  release  number, and  the  machine's  instruction set.  The elements listed below will always be defined, but they may have empty strings as  values  if  Tcl  could  not  retrieve any relevant information.  In addition, extensions and applications may add additional  values to the array.  The predefined elements are:",
    \ 'tcl_precision': "tcl_precision - This  variable  controls  the  number of digits to generate when converting floating-point values to strings.  It defaults to  0.  Applications  should  not  change this value; it is provided for compatibility with legacy code.",
    \ 'tcl_rcFileName': "tcl_rcFileName - This variable is used during initialization to indicate the name of  a  user-specific startup file.  If it is set by applicationspecific initialization, then the Tcl startup  code  will  check for  the existence of this file and source it if it exists.  For example, for wish the variable is set to ~/.wishrc for Unix  and ~/wishrc.tcl for Windows.",
    \ 'tcl_traceCompile': "tcl_traceCompile - The  value of this variable can be set to control how much tracing information is displayed during  bytecode  compilation.   By default,  tcl_traceCompile  is  zero  and no information is displayed.  Setting tcl_traceCompile to 1 generates a one-line summary in stdout whenever a procedure or top-level command is compiled.  Setting it to 2 generates a detailed listing  in  stdout of  the  bytecode instructions emitted during every compilation.  his variable is useful in tracking down suspected problems with the Tcl compiler.  This  variable and functionality only exist if TCL_COMPILE_DEBUG was defined during Tcl's compilation.",
    \ 'tcl_traceExec': "tcl_traceExec - The value of this variable can be set to control how much  tracing  information  is  displayed  during  bytecode execution.  By default, tcl_traceExec is zero and no information is  displayed.  Setting  tcl_traceExec to 1 generates a one-line trace in stdout on each call to a Tcl procedure.  Setting it to  2  generates  a line of output whenever any Tcl command is invoked that contains the name of the command and its arguments.  Setting it to 3 produces  a  detailed  trace  showing  the result of executing each bytecode instruction.  Note that when tcl_traceExec is 2  or  3, commands  such  as set and incr that have been entirely replaced by a sequence of bytecode instructions are not  shown.   Setting this variable is useful in tracking down suspected problems with the bytecode compiler and interpreter.  This variable and functionality only exist if  TCL_COMPILE_DEBUG was defined during Tcl's compilation.",
    \ 'tcl_wordchars': "tcl_wordchars - The  value  of this variable is a regular expression that can be set to  control  what  are  considered  'word'  characters,  for instances  like  selecting  a word by double-clicking in text in Tk.  It is platform dependent.  On Windows, it defaults  to  \S, meaning  anything  but  a Unicode space character.  Otherwise it defaults to \w, which is any  Unicode  word  character  (number, letter, or underscore).",
    \ 'tcl_nonwordchars': "tcl_nonwordchars - The  value  of this variable is a regular expression that can be set to control what are considered  'non-word'  characters,  for instances  like  selecting  a word by double-clicking in text in Tk.  It is platform dependent.  On Windows, it defaults  to  \s, meaning  any  Unicode space character.  Otherwise it defaults to \W, which is anything but a Unicode word character (number, letter, or underscore).",
    \ 'tcl_version': "tcl_version - When  an interpreter is created Tcl initializes this variable to hold the version number for this version of Tcl in the form x.y.  Changes to x represent major changes with probable incompatibilities and changes to y  represent  small  enhancements  and  bug fixes  that  retain  backward  compatibility.  The value of this variable is returned by the info tclversion command.",
    \ 'argc': "argc - The number of arguments to tclsh or wish.",
    \ 'argv': "argv - Tcl list of arguments to tclsh or wish.",
    \ 'argv0': "argv0 - The script that tclsh or wish started executing (if it was specified) or otherwise the name by which tclsh or wish was invoked.",
    \ 'tcl_interactive': "tcl_interactive - Contains  1  if tclsh or wish is running interactively (no script was specified and standard input is a  terminal-like  device),  0 otherwise.",
    \ }
