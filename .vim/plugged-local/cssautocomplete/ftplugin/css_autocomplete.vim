" css_autocomplete.vim  : automatically Inserts semicolon on hitting first alphabetic charachter on every line.
" Version    		    : 0.1
" Maintainer 		    : Ali Zarifkar <ali.zarifkar@gmail.com>
" Last modified  		: 2016 Oct 23 at 15:47:26 PM
" License      		    : This script is released under the Vim License.

" check if script is already loaded
if exists("b:loaded_css_autocomplete")  || &cp
   finish "stop loading the script
endif
let b:loaded_css_autocomplete=1

" ######## KEY MAPPINGS #########
" Insert mode mappings
augroup mapping
  au!
  au InsertEnter <buffer> call <SID>mapForMappingDriven()
augroup END

" ######## FUNCTIONS #########
function! s:mapForMappingDriven()
  if match(getline('.'), '^\s*$') > -1
	call s:unmapForMappingDriven()
	let s:keysMappingDriven = [
		  \ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
		  \ 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
		  \ 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
		  \ 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
		  \ ]
	for key in s:keysMappingDriven
	  execute printf('inoremap <buffer> <silent> %s %s<C-r>=<SID>insertSemiColon()<CR>',
			\        key, key)
	endfor
  endif
endfunction

function! s:unmapForMappingDriven()
  if !exists('s:keysMappingDriven')
	return
  endif
  for key in s:keysMappingDriven
	execute 'iunmap <buffer> ' . key
  endfor
  let s:keysMappingDriven = []
endfunction

func! s:insertSemiColon()
	let b:curLineLength = len(matchstr(getline('.'), '^\s*\zs.*'))
	let b:curLineFirstChar = matchstr(getline('.'), '^\s*\zs.')
	if b:curLineLength == 1 && b:curLineFirstChar =~ '[a-zA-Z]'
		call setline(line('.'), substitute(getline('.'), '\s*$', ';', ''))
	endif
	call s:unmapForMappingDriven()
	return ''
endfunc

" vim:noet:sw=4:ts=4:ft=vim
