" Language:    scssScript
" Maintainer:  Mick Koch <mick@kochm.co>
" URL:         http://github.com/kchmck/vim-scss-script
" License:     WTFPL

" Set up some common global/buffer variables.
function! scss#ScssSetUpVariables()
  " Path to scss executable
  if !exists('g:scss_compiler')
    let g:scss_compiler = 'scss'
  endif

  " Options passed to scss with make
  if !exists('g:scss_make_options')
    let g:scss_make_options = '-t expanded'
  endif

  " Path to cake executable
  if !exists('g:scss_cake')
    let g:scss_cake = 'cake'
  endif

  " Extra options passed to cake
  if !exists('g:scss_cake_options')
    let g:scss_cake_options = ''
  endif

  " Path to scsslint executable
  if !exists('g:scss_linter')
    let g:scss_linter = 'scsslint'
  endif

  " Options passed to scssLint
  if !exists('g:scss_lint_options')
    let g:scss_lint_options = ''
  endif

  " Pass the litscss flag to tools in this buffer if a litscss file is open.
  " Let the variable be overwritten so it can be updated if a different filetype
  " is set.
  if &filetype == 'litscss'
    let b:scss_litscss = ''
  else
    let b:scss_litscss = ''
  endif
endfunction

function! scss#ScssSetUpErrorFormat()
  CompilerSet errorformat=Error:\ In\ %f\\,\ %m\ on\ line\ %l,
                         \Error:\ In\ %f\\,\ Parse\ error\ on\ line\ %l:\ %m,
                         \SyntaxError:\ In\ %f\\,\ %m,
                         \%f:%l:%c:\ error:\ %m,
                         \%-G%.%#
endfunction
