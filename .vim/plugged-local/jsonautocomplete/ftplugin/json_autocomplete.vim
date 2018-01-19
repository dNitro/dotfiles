" json_autocomplete.vim : Map alphabetic keys to Insert comma.
" Version               : 0.1
" Maintainer            : Ali Zarifkar <ali.zarifkar@gamil.com>
" Last modified         : 2017 May 18 at 7:06:24 PM PM
" License               : This script is released under the Vim License.

" check if script is already loaded
if exists("b:loaded_json_autocomplete")  || &cp
   finish "stop loading the script
endif
let b:loaded_json_autocomplete=1

"####### key mappings #######
" Insert mode mappings
augroup mapping
  au!
  au InsertEnter <buffer> call <SID>mapForMappingDriven()
augroup END

" Map o to insert comma
nnoremap <buffer> o :call json_autocomplete#insetBefore()<CR>o

"####### functions #######
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
      if key == '"' || key == ''''
        execute printf('inoremap <buffer> <silent> %s %s%s<Left><C-r>=<SID>commaInserter(2)<CR>',
              \        '"', '"', '"')
      else
        execute printf('inoremap <buffer> <silent> %s %s<C-r>=<SID>commaInserter(1)<CR>',
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
    if key == '"'
      execute 'inoremap <buffer> <silent> ' . key . " <C-R>=AutoPairsInsert('".key."')<CR>"
    endif
    if key == ''''
        execute 'imap <buffer> <silent> ' . key . ' "'
    endif
  endfor
  let s:keysMappingDriven = []
endfunction

func! s:insertComma()
  return setline(line('.'), substitute(getline('.'), '\s*$', ',', ''))
endfunc

func! s:commaInserter(n)
  let b:curLineLength = len(matchstr(getline('.'), '^\s*\zs.*'))
  let b:curLineFirstChar = matchstr(getline('.'), '^\s*\zs.')
  if b:curLineLength == a:n && b:curLineFirstChar =~ '[a-zA-Z0-9_$\"]'
    let b:nextLine = getline(nextnonblank(line('.')+1))
    echom 'nextnonblank: ' . b:nextLine
    let b:nextLineFirstChar = matchstr(b:nextLine, '^\s*\zs.')
    echom 'b:nextLineFirstChar: ' . b:nextLineFirstChar
    if b:nextLineFirstChar !~ '[\]}]'
      call s:insertComma()
    endif
    call s:unmapForMappingDriven()
    return ''
  endif
  call s:unmapForMappingDriven()
  return ''
endfunc

func! json_autocomplete#insetBefore()
  echo ''
  let b:currentLineLastChar = matchstr(getline('.'), '\zs.\ze\s*$')
  if b:currentLineLastChar =~ '[{\[(,]' || b:currentLineLastChar == ''
    return ''
  else
    call s:insertComma()
  endif
endfunc
