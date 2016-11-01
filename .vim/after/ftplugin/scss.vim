source ~/.vim/bundle/cssautocomplete/ftplugin/css_autocomplete.vim

" Set omnifunction same as css files
setlocal omnifunc=csscomplete#CompleteCSS

" Don't pair {
let delimitMate_matchpairs = "(:),[:]"

" Also consider - as keyword
setlocal iskeyword+=-

" Map cr to select popup item when pumvisible otherwise act as delimitMateCR
imap <buffer> <expr> <CR> pumvisible() ? "\<C-y>" : "<Plug>delimitMateCR"
