" User completion function
setlocal completefunc=jquerycomplete#CompleteSelector

" Remove . from keywords
set isk-=.

" On Return if pumvisible select Popupmenu item otherwise act as delimitMate return
imap <buffer> <expr> <CR> pumvisible() ? "\<C-y>" : "<Plug>delimitMateCR"

cnoreabbrev <expr> grunt getcmdtype() ==# ":" && getcmdline() == 'grunt' ? '!clear; grunt' : 'grunt'
cnoreabbrev <expr> node getcmdtype() ==# ":" && getcmdline() == 'node' ? '!clear; node %' : 'node'

" Custom surrounds
let b:surround_{char2nr('c')} = "/*\r*/"               " comment
let b:surround_{char2nr('s')} = "${\r}"                " inline template
let b:surround_{char2nr('l')} = "console.log(\r)"      " log
let b:surround_{char2nr('i')} = "(function() {\r})();" " iife
let b:surround_{char2nr('j')} = "function() {\r}"      " function
