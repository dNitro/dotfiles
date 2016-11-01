" javascript_autocompleoe.vim: Insert semicolon and inline lint js operators.
" Version:                     0.1
" Maintainer:                  Ali Zarifkar<ali.zarifkar@gamil.com>
" Last modified:               2016 Oct 28 at 01:14:25 AM
" License:                     This script is released under the Vim License.

" check if script is already loaded
if exists("b:loaded_javascript_autocomplete")  || &cp
   finish "stop loading the script
endif
let b:loaded_javascript_autocomplete=1

" ####### KEY MAPPINGS #######
let operators = ['=', '+', '-', '*', '/', '%', '<', '>', '!', '\\', '&']
for i in operators
  execute printf('inoremap <buffer> <silent> %s <c-r>=<SID>Space("%s")<cr>', i, i)
endfor

au InsertEnter <buffer> call <SID>mapForMappingDriven()

" Map o to insert [,;]
nnoremap <buffer> o :call javascript_autocomplete#insetBefore()<CR>o

" ####### FUNCTIONS #######
function! s:mapForMappingDriven()
  if match(getline('.'), '^\s*$') > -1
    call s:unmapForMappingDriven()
    let s:keysMappingDriven = [
          \ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
          \ 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
          \ 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
          \ 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
          \ '$', '_', '"', '''']
    for key in s:keysMappingDriven
      if key =~ '[''"]'
        execute printf('inoremap <buffer> <silent> %s %s%s<Left><C-r>=<SID>insertSemicol(2)<CR>',
              \        key, key, key)
      else
        execute printf('inoremap <buffer> <silent> %s %s<C-r>=<SID>insertSemicol(1)<CR>',
              \        key, key)
      endif
    endfor
  endif
endfunction

function! s:unmapForMappingDriven()
  if !exists('s:keysMappingDriven')
    return
  endif
  for key in s:keysMappingDriven
    execute 'iunmap <buffer> ' . key
    if key =~ '[''"]'
      execute 'imap <buffer> ' . key . ' <Plug>delimitMate' . key
    endif
  endfor
  let s:keysMappingDriven = []
endfunction

func! s:Spacer(operator)
   let c = strpart(getline('.'), col('.')-2, 1)
   let c2 = strpart(getline('.'), col('.')-3, 1)
   let nextChar = matchstr(getline('.'), '\%' . col('.') . 'c.')
   if (nextChar == ' ' && !s:inParens())
     call feedkeys("\<DEL>")
   endif
   if (c == ' ')
      if (c2 =~ '[+-]' && a:operator =~ '[+-]')
         return "\<BS>\<BS>\<BS>" . a:operator . a:operator
      elseif (c2 =~ '[!<>*%=+/\-&\|]')
         return "\<BS>" . a:operator . ' '
      elseif (a:operator =~ '[!]')
         return a:operator
      else
         return a:operator . ' '
      endif
   elseif (c =~ '[!<>*%=+/\-&\|]')
      return a:operator . ' '
   else
      return ' ' . a:operator . ' '
   endif
endfunc

function! s:inParens()
  let start = searchpair('(', '', ')', 'bnW')
  let cline = line('.')
  return (start != 0 && start == cline) ? 1 : 0
endfunction

func! s:IsInPattern()
   let flags = 'cnW'
   if search('/', flags) == line('.')
      let flags = 'bcnW'
      if search('/', flags) == line('.')
         return 1
      endif
   else
      return 0
   endif
endfunc

func! s:InComment()
  return stridx(synIDattr(synID(line('.'), col('.'), 0), 'name'), 'omment') != -1
endfunc

func! s:InString()
  return stridx(synIDattr(synID(line('.'), col('.')-1, 0), 'name'), 'tring') != -1
endfunc

func! s:Space(ope)
  echo ""
   if s:IsInPattern() || s:InComment() || s:InString()
      return a:ope
   endif
   return s:Spacer(a:ope)
endfunc

func! s:Eatchar(pat)
   let c = nr2char(getchar(0))
   return (c =~ a:pat) ? '' : c
endfunc

func! s:trim(string)
  return substitute(a:string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunc

func! s:getFutLine(lineNum, direction, limitLineNum)
  if (a:lineNum == a:limitLineNum)
      return ''
  endif
  return getline(a:lineNum + (1 * a:direction)) =~ '^\s*$' ? s:getFutLine(a:lineNum + (1 * a:direction), a:direction, a:limitLineNum) : getline(a:lineNum + (1 * a:direction))
endfunc

func! s:getPrevLine(lineNum)
  return s:getFutLine(a:lineNum, -1, 1)
endfunc

func! s:getNextLine(lineNum)
  return s:getFutLine(a:lineNum, 1, line('$'))
endfunc

func! s:insertSemiColon()
  return setline(line('.'), substitute(getline('.'), '\s*$', ';', ''))
endfunc

func! s:insertComma()
  return setline(line('.'), substitute(getline('.'), '\s*$', ',', ''))
endfunc

function! s:boomerang()
  let save_cursor = getcurpos()
  call search('}', 'W', line('$'))
  normal %
  let current = line('.')
  let l:varLineNum = search('^\s*var\s*.*$', 'W', search('{', 'W')-1)
  if l:varLineNum != current
    call setpos('.', save_cursor)
    return l:varLineNum
  endif
  call setpos('.', save_cursor)
endfunction

function! s:classget()
  let save_cursor = getcurpos()
  call search('}', 'W', line('$'))
  normal %
  let classl = line('.')
  call setpos('.', save_cursor)
  return classl
endfunction

func! s:inClass()
  let curline = line('.')
  let stylestart = searchpair('^class.*{', '', '}', "bnW")
  let styleend   = searchpair('^class.*{', '', '}', "nW")
  if stylestart != 0 && styleend != 0
    if stylestart <= curline && styleend >= curline
      return 1
    endif
  endif
  return 0
endfunc

func! s:isInClass()
  let startLine = searchpair('{', '', '}', 'bnW')
  let trimedStart = s:trim(getline(startLine))
  let startLineFirstWord = matchstr(trimedStart, '^\w\+\s*')
  if startLineFirstWord =~ '.*(.*)\s*{\|class\|static\|get\s\+.\+\s*(\|set\s\+.\+\s*('
    return 1
  endif
  return 0
endfunc

func! s:insertSemicol(n)
  let b:curLineLength = len(matchstr(getline('.'), '^\s*\zs.*'))
  let b:curLineFirstChar = matchstr(getline('.'), '^\s*\zs.')
  if b:curLineLength == a:n && b:curLineFirstChar =~ '[a-zA-Z0-9_$''\"]'
    let b:currentLineLastChar = matchstr(getline('.'), '\zs.\ze\s*$')
    let b:prevLine = s:getPrevLine(line('.'))
    let b:prevLineLastChar = matchstr(b:prevLine, '\zs.\ze\s*$')
    let b:nextLine = s:getNextLine(line('.'))
    let b:nextLineFirstChar = matchstr(b:nextLine, '^\s*\zs.')
    let b:nextLineLastChar = matchstr(b:nextLine, '\zs.\ze\s*$')
    if b:prevLineLastChar == ','
      if b:nextLineFirstChar =~ '[}\])]'
        let b:varLine = getline(s:boomerang())
        let b:varLineLastChar = matchstr(b:varLine, '\zs.\ze\s*$')
        if s:trim(b:prevLine) =~ '^var' || b:varLineLastChar == ',' || b:varLine =~ 'function'
          call s:insertSemiColon()
        else
          return ''
        endif
      elseif b:currentLineLastChar != ';'
        call s:insertComma()
      endif
    elseif b:prevLineLastChar =~ '[{\[(]' && b:prevLine !~ '\%(function\|if\|for\|while\|switch\|catch\|constructor\)\s*(' && b:prevLine !~ '\%(else\|try\|finally\)\s*{' && b:prevLine !~ '.\+(.*)\s*{'
      if b:nextLineFirstChar =~ '[}\])]'
        return ''
      elseif b:nextLineLastChar == ','
        call s:insertComma()
      elseif s:isInClass()
        return ''
      else
        call s:insertComma()
      endif
    elseif b:prevLineLastChar =~ '}'
      if s:isInClass()
        return ''
      else
        call s:insertSemiColon()
      endif
    else
      call s:insertSemiColon()
    endif
    call s:unmapForMappingDriven()
    return ''
  endif
  call s:unmapForMappingDriven()
  return ''
endfunc

func! s:isState()
  let b:startLine = searchpair('{', '', '}', "bnW")
  let b:startLineTrimmed = s:trim(getline(b:startLine))
  let b:startLineFirstWord = matchstr(b:startLineTrimmed, '^\zs\w\+\ze\s*')
  if b:startLineFirstWord =~ '^\%(function\|if\|else\|for\|while\|switch\|try\|catch\|finally\|constructor(\|get\|set\|static\)$' || b:startLineTrimmed =~ '^\%(.*:\)\@!\zs\s*\w\+('
    return 1
  endif
  return 0
endfunc

func! javascript_autocomplete#insetBefore()
  echo ''
  let b:currentLineLastChar = matchstr(getline('.'), '\zs.\ze\s*$')
  if b:currentLineLastChar =~ '[{}\[(,:;]' || b:currentLineLastChar == '' || s:InComment() || s:isState() || s:isInClass() || match(getline('.'), '^\s*$') > -1
    return ''
  else
    call s:insertComma()
  endif
endfunc
