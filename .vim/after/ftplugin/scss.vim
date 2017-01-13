" Equip with css completions
source ~/.vim/plugged-local/cssautocomplete/ftplugin/css_autocomplete.vim

" Set omnifunction same as css files
setlocal omnifunc=csscomplete#CompleteCSS

" Don't pair {
let b:AutoPairs = {'(':')', '[':']',"'":"'",'"':'"', '`':'`'}

" Also consider - as keyword
setlocal iskeyword+=-
