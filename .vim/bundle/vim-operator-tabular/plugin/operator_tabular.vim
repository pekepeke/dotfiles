if v:version < 700
  echoerr "does not work this version of Vim(' . v:version . ')'
  finish
elseif exists('g:loaded_operator_tabular')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

call operator#user#define('md_tabularize_tsv'        , 'operator#tabular#markdown#tabularize_tsv')
call operator#user#define('md_tabularize_csv'        , 'operator#tabular#markdown#tabularize_csv')
call operator#user#define('md_untabularize_tsv'      , 'operator#tabular#markdown#untabularize_tsv')
call operator#user#define('md_untabularize_csv'      , 'operator#tabular#markdown#untabularize_csv')

call operator#user#define('textile_tabularize_tsv'   , 'operator#tabular#textile#tabularize_tsv')
call operator#user#define('textile_tabularize_csv'   , 'operator#tabular#textile#tabularize_csv')
call operator#user#define('textile_untabularize_tsv' , 'operator#tabular#textile#untabularize_tsv')
call operator#user#define('textile_untabularize_csv' , 'operator#tabular#textile#untabularize_csv')

call operator#user#define('backlog_tabularize_tsv'   , 'operator#tabular#backlog#tabularize_tsv')
call operator#user#define('backlog_tabularize_csv'   , 'operator#tabular#backlog#tabularize_csv')
call operator#user#define('backlog_untabularize_tsv' , 'operator#tabular#backlog#untabularize_tsv')
call operator#user#define('backlog_untabularize_csv' , 'operator#tabular#backlog#untabularize_csv')


let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_operator_tabular = 1

" vim: foldmethod=marker
" __END__ {{{1
