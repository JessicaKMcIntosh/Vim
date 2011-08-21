" Vim syntax file
" Language:     SQL with SQLite and other additions.
" Maintainer:   Lorance Stinson <Lorance Stinson AT gmail DOT com>
" Last Change:  Sun, Aug 21, 2011

" More complete SQL matching with error reporting.
" Only matches types inside 'CREATE TABLE ();'.
" Highlights functions. Unknown functions are an error.
" Based on the SQL syntax files that come with Vim.

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore

" All non-contained SQL syntax.
syn cluster sqlALL          contains=TOP

" Various error conditions.
syn match   sqlError        "\<\w\+("           " Not a known function.
syn match   sqlError        ")"                 " Lonely closing paren.
syn match   sqlError        ",\(\_\s*[;)]\)\@=" " Comma before a paren or semicolon.
syn match   sqlError        " $"                " Space at the end of a line.
" Comma before certain words.
syn match   sqlError        ",\_\s*\(\<\(asc\|desc\|exists\|for\|from\)\>\)\@="
syn match   sqlError        ",\_\s*\(\<\(group by\|into\|limit\|order\)\>\)\@="
syn match   sqlError        ",\_\s*\(\<\(table\|using\|where\)\>\)\@="

" Special words.
syn keyword sqlSpecial      false null true

" Keywords
syn keyword sqlKeyword      access add after aggregate as asc authorization
syn keyword sqlKeyword      begin by cache cascade check cluster collate
syn keyword sqlKeyword      collation column compress conflict connect connection
syn keyword sqlKeyword      constraint current cursor database debug decimal
syn keyword sqlKeyword      default desc each else elsif escape exception
syn keyword sqlKeyword      exclusive explain external file for foreign from function
syn keyword sqlKeyword      group having identified if immediate increment index
syn keyword sqlKeyword      initial inner into is join key left level loop
syn keyword sqlKeyword      maxextents mode modify nocompress nowait object of
syn keyword sqlKeyword      off offline on online option order outer pctfree
syn keyword sqlKeyword      primary privileges procedure public references
syn keyword sqlKeyword      referencing release resource return role row
syn keyword sqlKeyword      rowlabel rownum rows schema session share size
syn keyword sqlKeyword      start successful synonym then to transaction trigger
syn keyword sqlKeyword      uid user using validate values view virtual whenever
syn keyword sqlKeyword      where with
syn match   sqlKeyword      "\<glob\>"
" Do special things with CREATE TABLE ( below.
syn match   sqlKeyword      "\<table\>"

" SQLite Pragmas - Treat them as keywords.
syn keyword sqlKeyword      auto_vacuum automatic_index cache_size
syn keyword sqlKeyword      case_sensitive_like checkpoint_fullfsync
syn keyword sqlKeyword      collation_list compile_options count_changes
syn keyword sqlKeyword      database_list default_cache_size
syn keyword sqlKeyword      empty_result_callbacks encoding foreign_key_list
syn keyword sqlKeyword      foreign_keys freelist_count full_column_names
syn keyword sqlKeyword      fullfsync ignore_check_constraints
syn keyword sqlKeyword      incremental_vacuum index_info index_list
syn keyword sqlKeyword      integrity_check journal_mode journal_size_limit
syn keyword sqlKeyword      legacy_file_format locking_mode max_page_count
syn keyword sqlKeyword      page_count page_size parser_trace quick_check
syn keyword sqlKeyword      read_uncommitted recursive_triggers
syn keyword sqlKeyword      reverse_unordered_selects schema_version
syn keyword sqlKeyword      secure_delete short_column_names synchronous
syn keyword sqlKeyword      table_info temp_store temp_store_directory
syn keyword sqlKeyword      user_version vdbe_listing vdbe_trace
syn keyword sqlKeyword      wal_autocheckpoint wal_checkpoint writable_schema

" Operators
syn keyword sqlOperator     all and any between case distinct elif else end
syn keyword sqlOperator     exists if in intersect is like match matches not
syn keyword sqlOperator     or regexp some then union unique when

" Functions - Only valid with a '(' after them.
syn match   sqlFunction     "\<\(abs\|acos\|asin\|atan2\?\|avg\|cardinality\)(\@="
syn match   sqlFunction     "\<\(cast\|changes\|char_length\|character_length\)(\@="
syn match   sqlFunction     "\<\(coalesce\|cos\|count\|\(date\)\?\(time\)\?\)(\@="
syn match   sqlFunction     "\<\(exp\|filetoblob\|filetoclob\|glob\|group_concat\)(\@="
syn match   sqlFunction     "\<\(hex\|ifnull\|initcap\|isnull\|julianday\|last_insert_rowid\)(\@="
syn match   sqlFunction     "\<\(length\|log10\|logn\|lower\|lpad\|ltrin\|max\|min\)(\@="
syn match   sqlFunction     "\<\(mod\|nullif\|octet_length\|pow\|quote\|random\)(\@="
syn match   sqlFunction     "\<\(range\|replace\|root\|round\|rpad\|sin\|soundex\)(\@="
syn match   sqlFunction     "\<\(sqrtstdev\|strftime\|substr\|substring\|sum\|sysdate\|tan\)(\@="
syn match   sqlFunction     "\<\(to_char\|to_date\|total\|trim\|trunc\|typeof\)(\@="
syn match   sqlFunction     "\<\(upper\|variance\)(\@="

" SQLite Functions
syn match   sqlFunction     "\<\(last_insert_rowid\|load_extension\|randomblob\)(\@="
syn match   sqlFunction     "\<\(sqlite_compileoption_get\|sqlite_compileoption_used\)(\@="
syn match   sqlFunction     "\<\(sqlite_source_id\|sqlite_version\|sqlite_version\)(\@="
syn match   sqlFunction     "\<\(zeroblob\|ltrim\|rtrim\)(\@="
" SQLite Command Line Client Functions
syn match   sqlFunction     "^\.\w\+"

" Statements
syn keyword sqlStatement    alter analyze audit begin comment commit delete
syn keyword sqlStatement    drop execute explain grant insert lock noaudit
syn keyword sqlStatement    rename revoke rollback savepoint select set
syn keyword sqlStatement    truncate update vacuum
syn match   sqlStatement    "\<replace\>"
" Do special things with CREATE TABLE ( below.
syn match   sqlStatement    "\<create\>"

" SQLite Statements
syn keyword sqlStatement    attach detach indexed pragma reindex

" Types - Only matched inside 'CREATE TABLE ();'.
syn keyword sqlType         contained bigint bit blob bool boolean byte char
syn keyword sqlType         contained clob date datetime dec decimal enum
syn keyword sqlType         contained float int int8 integer interval long
syn keyword sqlType         contained longblob longtext lvarchar mediumblob
syn keyword sqlType         contained mediumint mediumtext money multiset nchar
syn keyword sqlType         contained number numeric nvarchar raw real rowid
syn keyword sqlType         contained serial serial8 set smallfloat smallint
syn keyword sqlType         contained smallint text time timestamp tinyblob
syn keyword sqlType         contained tinyint tinytext varchar varchar2 varray
syn keyword sqlType         contained year
syn match   sqlType         contained "\<\(character\|double\|varying\)\>"
syn match   sqlType         contained "\<character\s\+varying\>"
syn match   sqlType         contained "\<double\s\+precision\>"

" Strings
syn region sqlString        start=+"+  skip=+\\\\\|\\"+  end=+"+
syn region sqlString        start=+'+  skip=+\\\\\|\\'+  end=+'+
syn region sqlString        start=+`+  skip=+\\\\\|\\`+  end=+`+

" Numbers
syn match sqlNumber         "-\=\<[0-9]*\>"
syn match sqlNumber         "-\=\<[0-9]*\.[0-9]*\>"
syn match sqlNumber         "-\=\<[0-9][0-9]*e[+-]\=[0-9]*\>"
syn match sqlNumber         "-\=\<[0-9]*\.[0-9]*e[+-]\=[0-9]*\>"
syn match sqlNumber         "\<0x[abcdef0-9]*\>"

" Todo
syn keyword sqlTodo         contained DEBUG FIXME NOTE TODO XXX

" Comments
syn region sqlComment       start="/\*"  end="\*/" contains=sqlTodo
syn match  sqlComment       "--.*$" contains=sqlTodo

" Mark correct paren use. Different colors for different purposes.
syn region  sqlParens       transparent matchgroup=sqlParen start="(" end=")"
syn match   sqlParenEmpty   "()"
syn region  sqlParens       transparent matchgroup=sqlParenFunc start="\(\<\w\+\>\)\@<=(" end=")"

" Highlight types correctly inside 'CREATE TABLE ();' statements.
" All other SQL is properly highlighted as well.
syn region  sqlTypeParens   contained matchgroup=sqlType start="(" end=")" contains=@sqlALL
syn match   sqlTypeMatch    contained "\(\(^\|[,(]\)\s*[^ ,()]\+\s\+\)\@<=\w\+\(\s*([^)]\+)\)\?" contains=sqlType,sqlTypeParens
syn match   sqlTypeMatch    contained "\(\(^\|[,(]\)\s*\w\+\s\+\)\@<=character\s\+varying\s*([^)]\+)" contains=sqlType,sqlTypeParens
syn region  sqlTypeRegion   matchgroup=sqlParen start="\(create\s\+table\s\+[^(]\+\s\+\)\@<=(" end=")" contains=@sqlALL,sqlTypeMatch

" Stolen from sh.vim.
if !exists("sh_minlines")
  let sh_minlines = 200
endif
if !exists("sh_maxlines")
  let sh_maxlines = 2 * sh_minlines
endif
exec "syn sync minlines=" . sh_minlines . " maxlines=" . sh_maxlines

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_sql_syn_inits")
    if version < 508
        let did_sql_syn_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif

    HiLink sqlComment       Comment
    HiLink sqlError         Error
    HiLink sqlFunction      Function
    HiLink sqlKeyword       Special
    HiLink sqlNumber        Number
    HiLink sqlOperator      Operator
    HiLink sqlParen         Comment
    HiLink sqlParenEmpty    Operator
    HiLink sqlParenFunc     Function
    HiLink sqlSpecial       Keyword
    HiLink sqlStatement     Statement
    HiLink sqlString        String
    HiLink sqlTodo          Todo
    HiLink sqlType          Type

    delcommand HiLink
endif

let b:current_syntax = "sql"
