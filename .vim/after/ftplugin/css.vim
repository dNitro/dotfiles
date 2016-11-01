" Map cr to select popupmenu item
imap <buffer> <expr> <CR> pumvisible() ? "\<C-y>" : "<Plug>delimitMateCR"

" Alphabetically sort CSS properties in file with :SortCSS
" http://stackoverflow.com/questions/3050797/how-to-alphabetize-a-css-file-in-vim
command! -buffer -bar -range=% SortCSS <line1>,<line2>g#\({\n\)\@<=#.,/}/sort | noh

" Find numerical values with left and right keys
function! AddSubtract(back)
  " let pattern = &nrformats =~ 'alpha' ? '[[:alpha:][:digit:]]' : '[[:digit:]]'
  call search('\d\.*\w*', 'w' . a:back)
endfunction
nnoremap <buffer> <silent> <Right> :<C-u>call AddSubtract('')<CR>
nnoremap <buffer> <silent> <Left> :<C-u>call AddSubtract('b')<CR>

" Don't pair {
let delimitMate_matchpairs = "(:),[:]"

" Also consider - as keyword
setlocal iskeyword+=-

" Fold {} blocks
setlocal foldmethod=marker
setlocal foldmarker={,}
