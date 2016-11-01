" Language:    scssScript
" Maintainer:  Mick Koch <mick@kochm.co>
" URL:         http://github.com/kchmck/vim-scss-script
" License:     WTFPL

if exists('b:did_ftplugin')
  finish
endif

let b:did_ftplugin = 1
call scss#ScssSetUpVariables()

setlocal formatoptions-=t formatoptions+=croql
setlocal comments=:# commentstring=#\ %s
setlocal omnifunc=scsscomplete#CompleteSCSS
setlocal suffixesadd+=.scss

" Create custom augroups.
augroup scssBufUpdate | augroup END
augroup scssBufNew | augroup END

" Enable scss compiler if a compiler isn't set already.
if !len(&l:makeprg)
  compiler scss
endif

" Switch to the window for buf.
function! s:SwitchWindow(buf)
  exec bufwinnr(a:buf) 'wincmd w'
endfunction

" Create a new scratch buffer and return the bufnr of it. After the function
" returns, vim remains in the scratch buffer so more set up can be done.
function! s:ScratchBufBuild(src, vert, size)
  if a:size <= 0
    if a:vert
      let size = winwidth(bufwinnr(a:src)) / 2
    else
      let size = winheight(bufwinnr(a:src)) / 2
    endif
  endif

  if a:vert
    vertical belowright new
    exec 'vertical resize' size
  else
    belowright new
    exec 'resize' size
  endif

  setlocal bufhidden=wipe buftype=nofile nobuflisted noswapfile nomodifiable
  nnoremap <buffer> <silent> q :hide<CR>

  return bufnr('%')
endfunction

" Replace buffer contents with text and delete the last empty line.
function! s:ScratchBufUpdate(buf, text)
  " Move to the scratch buffer.
  call s:SwitchWindow(a:buf)

  " Double check we're in the scratch buffer before overwriting.
  if bufnr('%') != a:buf
    throw 'unable to change to scratch buffer'
  endif

  setlocal modifiable
    silent exec '% delete _'
    silent put! =a:text
    silent exec '$ delete _'
  setlocal nomodifiable
endfunction

" Parse the output of scss into a qflist entry for src buffer.
function! s:ParsescssError(output, src, startline)
  " scss error is always on first line?
  let match = matchlist(a:output,
  \                     '^\(\f\+\|\[stdin\]\):\(\d\):\(\d\): error: \(.\{-}\)' . "\n")

  if !len(match)
    return
  endif

  " Consider the line number from scss as relative and add it to the beginning
  " line number of the range the command was called on, then subtract one for
  " zero-based relativity.
  call setqflist([{'bufnr': a:src, 'lnum': a:startline + str2nr(match[2]) - 1,
  \                'type': 'E', 'col': str2nr(match[3]), 'text': match[4]}], 'r')
endfunction

" Reset source buffer variables.
function! s:scssCompileResetVars()
  " Variables defined in source buffer:
  "   b:scss_compile_buf: bufnr of output buffer
  " Variables defined in output buffer:
  "   b:scss_src_buf: bufnr of source buffer
  "   b:scss_compile_pos: previous cursor position in output buffer

  let b:scss_compile_buf = -1
endfunction

function! s:scssWatchResetVars()
  " Variables defined in source buffer:
  "   b:scss_watch_buf: bufnr of output buffer
  " Variables defined in output buffer:
  "   b:scss_src_buf: bufnr of source buffer
  "   b:scss_watch_pos: previous cursor position in output buffer

  let b:scss_watch_buf = -1
endfunction

function! s:scssRunResetVars()
  " Variables defined in scssRun source buffer:
  "   b:scss_run_buf: bufnr of output buffer
  " Variables defined in scssRun output buffer:
  "   b:scss_src_buf: bufnr of source buffer
  "   b:scss_run_pos: previous cursor position in output buffer

  let b:scss_run_buf = -1
endfunction

" Clean things up in the source buffers.
function! s:scssCompileClose()
  " Switch to the source buffer if not already in it.
  silent! call s:SwitchWindow(b:scss_src_buf)
  call s:scssCompileResetVars()
endfunction

function! s:scssWatchClose()
  silent! call s:SwitchWindow(b:scss_src_buf)
  silent! autocmd! scssAuWatch * <buffer>
  call s:scssWatchResetVars()
endfunction

function! s:scssRunClose()
  silent! call s:SwitchWindow(b:scss_src_buf)
  call s:scssRunResetVars()
endfunction

" Compile the lines between startline and endline and put the result into buf.
function! s:scssCompileToBuf(buf, startline, endline)
  let src = bufnr('%')
  let input = join(getline(a:startline, a:endline), "\n")

  " scss doesn't like empty input.
  if !len(input)
    " Function should still return within output buffer.
    call s:SwitchWindow(a:buf)
    return
  endif

  " Pipe lines into scss.
  let output = system(g:scss_compiler .
  \                   ' ' . g:scss_make_options .
  \                   ' 2>&1', input)

  " Paste output into output buffer.
  call s:ScratchBufUpdate(a:buf, output)

  " Highlight as JavaScript if there were no compile errors.
  if v:shell_error
    call s:ParsescssError(output, src, a:startline)
    setlocal filetype=
  else
    " Clear the quickfix list.
    call setqflist([], 'r')
    setlocal filetype=css
  endif
endfunction

" Peek at compiled scssScript in a scratch buffer. We handle ranges like this
" to prevent the cursor from being moved (and its position saved) before the
" function is called.
function! s:scssCompile(startline, endline, args)
  if a:args =~ '\<watch\>'
    echoerr 'scssCompile watch is deprecated! Please use scssWatch instead'
    sleep 5
    call s:scssWatch(a:args)
    return
  endif

  " Switch to the source buffer if not already in it.
  silent! call s:SwitchWindow(b:scss_src_buf)

  " Bail if not in source buffer.
  if !exists('b:scss_compile_buf')
    return
  endif

  " Build the output buffer if it doesn't exist.
  if bufwinnr(b:scss_compile_buf) == -1
    let src = bufnr('%')

    let vert = exists('g:scss_compile_vert') || a:args =~ '\<vert\%[ical]\>'
    let size = str2nr(matchstr(a:args, '\<\d\+\>'))

    " Build the output buffer and save the source bufnr.
    let buf = s:ScratchBufBuild(src, vert, size)
    let b:scss_src_buf = src

    " Set the buffer name.
    exec 'silent! file [scssCompile ' . src . ']'

    " Clean up the source buffer when the output buffer is closed.
    autocmd BufWipeout <buffer> call s:scssCompileClose()
    " Save the cursor when leaving the output buffer.
    autocmd BufLeave <buffer> let b:scss_compile_pos = getpos('.')

    " Run user-defined commands on new buffer.
    silent doautocmd scssBufNew User scssCompile

    " Switch back to the source buffer and save the output bufnr. This also
    " triggers BufLeave above.
    call s:SwitchWindow(src)
    let b:scss_compile_buf = buf
  endif

  " Fill the scratch buffer.
  call s:scssCompileToBuf(b:scss_compile_buf, a:startline, a:endline)
  " Reset cursor to previous position.
  call setpos('.', b:scss_compile_pos)

  " Run any user-defined commands on the scratch buffer.
  silent doautocmd scssBufUpdate User scssCompile
endfunction

" Update the scratch buffer and switch back to the source buffer.
function! s:scssWatchUpdate()
  call s:scssCompileToBuf(b:scss_watch_buf, 1, '$')
  call setpos('.', b:scss_watch_pos)
  silent doautocmd scssBufUpdate User scssWatch
  call s:SwitchWindow(b:scss_src_buf)
endfunction

" Continually compile a source buffer.
function! s:scssWatch(args)
  silent! call s:SwitchWindow(b:scss_src_buf)

  if !exists('b:scss_watch_buf')
    return
  endif

  if bufwinnr(b:scss_watch_buf) == -1
    let src = bufnr('%')

    let vert = exists('g:scss_watch_vert') || a:args =~ '\<vert\%[ical]\>'
    let size = str2nr(matchstr(a:args, '\<\d\+\>'))

    let buf = s:ScratchBufBuild(src, vert, size)
    let b:scss_src_buf = src

    exec 'silent! file [scssWatch ' . src . ']'

    autocmd BufWipeout <buffer> call s:scssWatchClose()
    autocmd BufLeave <buffer> let b:scss_watch_pos = getpos('.')

    silent doautocmd scssBufNew User scssWatch

    call s:SwitchWindow(src)
    let b:scss_watch_buf = buf
  endif

  " Make sure only one watch autocmd is defined on this buffer.
  silent! autocmd! scssAuWatch * <buffer>

  augroup scssAuWatch
    " autocmd InsertLeave <buffer> call s:scssWatchUpdate() | redraw!
    autocmd BufWritePost <buffer> call s:scssWatchUpdate() | redraw!
  augroup END

  call s:scssWatchUpdate()
endfunction

" Run a snippet of scssScript between startline and endline.
function! s:scssRun(startline, endline, args)
  silent! call s:SwitchWindow(b:scss_src_buf)

  if !exists('b:scss_run_buf')
    return
  endif

  if bufwinnr(b:scss_run_buf) == -1
    let src = bufnr('%')

    let buf = s:ScratchBufBuild(src, exists('g:scss_run_vert'), 0)
    let b:scss_src_buf = src

    exec 'silent! file [scssRun ' . src . ']'

    autocmd BufWipeout <buffer> call s:scssRunClose()
    autocmd BufLeave <buffer> let b:scss_run_pos = getpos('.')

    silent doautocmd scssBufNew User scssRun

    call s:SwitchWindow(src)
    let b:scss_run_buf = buf
  endif

  if a:startline == 1 && a:endline == line('$')
    let output = system(g:scss_compiler .
    \                   ' ' . g:scss_make_options .
    \                   ' ' . fnameescape(expand('%')) .
    \                   ' ' . a:args)
  else
    let input = join(getline(a:startline, a:endline), "\n")

    if !len(input)
      return
    endif

    let output = system(g:scss_compiler .
    \                   ' ' . g:scss_make_options .
    \                   ' ' . a:args, input)
  endif

  call s:ScratchBufUpdate(b:scss_run_buf, output)
  " Highlight as JavaScript if there were no compile errors.
  if v:shell_error
    call s:ParsescssError(output, src, a:startline)
    setlocal filetype=
  else
    " Clear the quickfix list.
    call setqflist([], 'r')
    setlocal filetype=css
  endif
  call setpos('.', b:scss_run_pos)

  silent doautocmd scssBufUpdate User scssRun
endfunction

" Run scsslint on a file, and add any errors between startline and endline
" to the quickfix list.
function! s:scssLint(startline, endline, bang, args)
  let input = join(getline(a:startline, a:endline), "\n")

  if !len(input)
    return
  endif

  let output = system(g:scss_linter .
  \                   ' ' . a:args .
  \                   ' 2>&1', input)

  " Convert output into an array and strip off the csv header.
  let lines = split(output, "\n")[1:]
  let buf = bufnr('%')
  let qflist = []

  for line in lines
    let match = matchlist(line, '^stdin,\(\d\+\),\d*,\(error\|warn\),\(.\+\)$')

    " Ignore unmatched lines.
    if !len(match)
      continue
    endif

    " The 'type' will result in either 'E' or 'W'.
    call add(qflist, {'bufnr': buf, 'lnum': a:startline + str2nr(match[1]) - 1,
    \                 'type': toupper(match[2][0]), 'text': match[3]})
  endfor

  " Replace the quicklist with our items.
  call setqflist(qflist, 'r')

  " If not given a bang, jump to first error.
  if !len(a:bang)
    silent! cc 1
  endif
endfunction

" Complete arguments for scss* commands.
function! s:scssComplete(cmd, cmdline, cursor)
  let args = ['vertical']

  " If no partial command, return all possibilities.
  if !len(a:cmd)
    return args
  endif

  let pat = '^' . a:cmd

  for arg in args
    if arg =~ pat
      return [arg]
    endif
  endfor
endfunction

" Set initial state variables if they don't exist
if !exists('b:scss_compile_buf')
  call s:scssCompileResetVars()
endif

if !exists('b:scss_watch_buf')
  call s:scssWatchResetVars()
endif

if !exists('b:scss_run_buf')
  call s:scssRunResetVars()
endif

command! -buffer -range=% -bar -nargs=* -complete=customlist,s:scssComplete
\        ScssCompile call s:scssCompile(<line1>, <line2>, <q-args>)
command! -buffer -bar -nargs=* -complete=customlist,s:scssComplete
\        ScssWatch call s:scssWatch(<q-args>)
command! -buffer -range=% -bar -nargs=* ScssRun
\        call s:scssRun(<line1>, <line2>, <q-args>)
command! -buffer -range=% -bang -bar -nargs=* ScssLint
\        call s:scssLint(<line1>, <line2>, <q-bang>, <q-args>)
