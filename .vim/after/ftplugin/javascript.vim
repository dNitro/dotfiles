" User completion function
" setlocal completefunc=jquerycomplete#CompleteSelector

" Remove . from keywords
setlocal isk-=.

cnoreabbrev <expr> grunt getcmdtype() ==# ":" && getcmdline() == 'grunt' ? '!clear; grunt' : 'grunt'
if has('win32') || has('win64') && has('terminal')
  cnoreabbrev <expr> node getcmdtype() ==# ":" && getcmdline() == 'node' ? 'vert terminal node %' : 'node'
elseif has('win32') || has('win64')
    cnoreabbrev <expr> node getcmdtype() ==# ":" && getcmdline() == 'node' ? '!node %' : 'node'
else
  cnoreabbrev <expr> node getcmdtype() ==# ":" && getcmdline() == 'node' ? '!clear; node %' : 'node'
endif

" Lint entire buffer or visual selected lines
command! -buffer -range=% Lint let myview = winsaveview() |
  \ execute <line1> . "," . <line2> . "!js-beautify -s 2" |
  \ call winrestview(myview)

" Test with configed test command in package.json
command! Test !npm test

" Run entire buffer or visual selected lines
command! Run vert terminal node %

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
    let endend = '... ' . substitute(getline(v:foldend), '^\s*', '', 'g') . ' '
    " let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line . endend, 0, (winwidth(0)*2)/3)
    let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel) . line . endend, 0, (winwidth(0)*2)/3)
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
  elseif expand('%') =~ '.*\%(Test\|Spec\).js'
      let line = v:foldstart
      let message = matchstr(getline(line),'''\zs.*\ze'', function')
      return v:folddashes . ' [' . message . '] '
  else

    return NeatFoldText()
  endif
endfunction

setlocal foldmethod=syntax
" setlocal foldmarker={,}
