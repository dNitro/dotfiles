" Description   : html filetype specific configurations
" Maintainer    : Ali Zarifakr <ali.zarifar@gmail.com>
" Last modified : 2016 Nov 26 at 00:40:18 AM

"-1[ Vanilla ]================================================================
" Load the current buffer in Browser - Mac OS X
nnoremap ff :call Browse("/Applications/Firefox.app")<CR>
nnoremap hs :call Browse('/Applications/Google\ Chrome.app')<CR>
nnoremap gb :call Browse("/Applications/Safari.app")<CR>

" Return gracefully
imap <buffer> <expr> <CR> <SID>Return()

"-1[ Plugins ]================================================================
"-2[ html5.vim ]--------------------------------------------------------------
" Don't include additional attributes
let g:html5_event_handler_attributes_complete = 0
let g:html5_rdfa_attributes_complete = 0
let g:html5_microdata_attributes_complete = 0
let g:html5_aria_attributes_complete = 0
"-2[ delimitMate ]------------------------------------------------------------
" Don't pair <
let delimitMate_matchpairs = "(:),[:],{:}"
"-2[ Emmet.vim ]--------------------------------------------------------------
" Emmet command line abbreviations
cabbrev <silent> navigation <C-r>=(getcmdtype()==#'@' && getcmdpos()==1 ? 'nav>ul>li*$#>a[href=# title=$#]{$#}' : 'navigation')<CR>
cabbrev <silent> radio <C-r>=(getcmdtype()==#'@' && getcmdpos()==1 ? '(input[type=radio id=$# name=radioGroup value=$#]+label[for=$#]{$#})*' : 'radio')<CR>
"==

"-1[ Helper Functions ]=======================================================
"-2 Open the current buffer in browser ---------------------------------------
function! Browse(browser)
  update
  if a:browser =~ 'Google'
    silent exe '!open ' . a:browser . ' %'
  else
    silent exe '!open -a ' . a:browser . ' %'
  endif
  redraw!
endfunction
"-2 Returns current html tag -------------------------------------------------
fun! s:GetTag()
  return matchstr(getline('.'), '<\/\@!\zs[^>]\{-}\ze\%(\s\|>\)')
endf
"-2 Cleanly return after autocompleting an html tag --------------------------
fun! s:Return()
  let tag = s:GetTag()
  if pumvisible()
    return "\<C-y>"
  elseif strpart(getline('.'), col('.')-1, 1) == '>' && match(getline('.'), '</'.tag.'>') == -1
    return "\<Right>\<C-j>"
  elseif strpart(getline('.'), col('.')-1, 1) == '>'
    return "\<Right>\<C-j>\<Esc>O"
  elseif tag != '' &&
              \ match(getline('.'), '</'.tag.'>') > -1 &&
              \ match(getline('.'), '</'.tag.'>') >= col('.') - 1
    return "\<C-j>\<Esc>O"
  else
    return "\<CR>\<Plug>AutoPairsReturn"
  endif
endf
"==
"=============================================================================

"-1 vim:foldmethod=marker:foldmarker="-,"==
