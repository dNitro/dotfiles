" User completion function
setlocal completefunc=jquerycomplete#CompleteSelector

" Remove . from keywords
set isk-=.

cnoreabbrev <expr> grunt getcmdtype() ==# ":" && getcmdline() == 'grunt' ? '!clear; grunt' : 'grunt'
cnoreabbrev <expr> node getcmdtype() ==# ":" && getcmdline() == 'node' ? '!clear; node %' : 'node'

" Custom surrounds
let b:surround_{char2nr('c')} = "/*\r*/"               " comment
let b:surround_{char2nr('s')} = "${\r}"                " inline template
let b:surround_{char2nr('l')} = "console.log(\r)"      " log
let b:surround_{char2nr('i')} = "(function() {\r})();" " iife
let b:surround_{char2nr('j')} = "function() {\r}"      " function
