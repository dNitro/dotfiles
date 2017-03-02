" User completion function
setlocal completefunc=jquerycomplete#CompleteSelector
call jsomni#init()

" Remove . from keywords
setlocal isk-=.

cnoreabbrev <expr> grunt getcmdtype() ==# ":" && getcmdline() == 'grunt' ? '!clear; grunt' : 'grunt'
cnoreabbrev <expr> node getcmdtype() ==# ":" && getcmdline() == 'node' ? '!clear; node %' : 'node'

" Custom surrounds
let b:surround_{char2nr('c')} = "/*\r*/"               " comment
let b:surround_{char2nr('s')} = "${\r}"                " inline template
let b:surround_{char2nr('l')} = "console.log(\r)"      " log
let b:surround_{char2nr('i')} = "(function() {\r})();" " iife
let b:surround_{char2nr('j')} = "function() {\r}"      " function

setlocal foldtext=MyFoldText()
function! NeatFoldText()
    let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
    let lines_count = v:foldend - v:foldstart + 1
    let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
    let foldchar = matchstr(&fillchars, 'fold:\zs.')
    let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
    let foldtextend = lines_count_text . repeat(foldchar, 8)
    let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
    return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction

function! MyFoldText()
    if getline(v:foldstart) =~ 'controller'
  let line = v:foldstart
  let method = matchstr(getline(line+1), '\w\+\ze'',$')
  let path = matchstr(getline(line+2), '''.*\ze'',$')
  return v:folddashes . ' ' . method . ' ' . path
  else
    return NeatFoldText()
  endif
endfunction

setlocal foldmethod=syntax
" setlocal foldmarker={,}
