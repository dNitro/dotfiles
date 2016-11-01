let s:ajaxSelectors = [
  \ { 'word': 'animated', 'menu': '(ext)' },
  \ { 'word': 'button', 'menu': '(ext)' },
  \ { 'word': 'checkbox', 'menu': '(ext)' },
  \ { 'word': 'checked', 'menu': '(css)' },
  \ { 'word': 'contains', 'menu': '()' },
  \ { 'word': 'disabled', 'menu': '(css)' },
  \ { 'word': 'empty', 'menu': '(css)' },
  \ { 'word': 'eq', 'menu': '()' },
  \ { 'word': 'even', 'menu': '(ext)' },
  \ { 'word': 'file', 'menu': '(ext)' },
  \ { 'word': 'first-child', 'menu': '(css)' },
  \ { 'word': 'first-of-type', 'menu': '(css)' },
  \ { 'word': 'first', 'menu': '(ext)' },
  \ { 'word': 'focus', 'menu': '(css)' },
  \ { 'word': 'gt', 'menu': '()' },
  \ { 'word': 'has', 'menu': '()' },
  \ { 'word': 'header', 'menu': '(ext)' },
  \ { 'word': 'hidden', 'menu': '(ext)' },
  \ { 'word': 'image', 'menu': '(ext)' },
  \ { 'word': 'input', 'menu': '(ext)' },
  \ { 'word': 'lang', 'menu': '()' },
  \ { 'word': 'last-child', 'menu': '(css)' },
  \ { 'word': 'last-of-type', 'menu': '(css)' },
  \ { 'word': 'last', 'menu': '(ext)' },
  \ { 'word': 'lt', 'menu': '()' },
  \ { 'word': 'not', 'menu': '()' },
  \ { 'word': 'nth-child', 'menu': '()' },
  \ { 'word': 'nth-last-child', 'menu': '()' },
  \ { 'word': 'nth-last-of-type', 'menu': '()' },
  \ { 'word': 'nth-of-type', 'menu': '()' },
  \ { 'word': 'odd', 'menu': '(ext)' },
  \ { 'word': 'only-child', 'menu': '(css)' },
  \ { 'word': 'only-of-type', 'menu': '(css)' },
  \ { 'word': 'paretn', 'menu': '(ext)' },
  \ { 'word': 'password', 'menu': '(ext)' },
  \ { 'word': 'radio', 'menu': '(ext)' },
  \ { 'word': 'reset', 'menu': '(ext)' },
  \ { 'word': 'root', 'menu': '(css)' },
  \ { 'word': 'submit', 'menu': '(ext)' },
  \ { 'word': 'target', 'menu': '(css)' },
  \ { 'word': 'text', 'menu': '(ext)' },
  \ { 'word': 'visible', 'menu': '(ext)' }
  \]
let s:tagSelectors = split("a abbr acronym address area b base bdo big blockquote body br button caption cite code col colgroup dd del dfn div dl dt em fieldset form head h1 h2 h3 h4 h5 h6 hr html i img input ins kbd label legend li link map meta noscript object ol optgroup option p param pre q samp script select small span strong style sub sup table tbody td textarea tfoot th thead title tr tt ul var")

function! jquerycomplete#CompleteSelector(findstart, base)
  if a:findstart
    " locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    let curline = line('.')
    let compl_begin = col('.') - 2
    " Bit risky but JS is rather limited language and local chars shouldn't
    " fint way into names
    while start >= 0 && line[start - 1] =~ '\k'
      let start -= 1
    endwhile
    let selector = searchpair('$(''', '', ''')', 'bnW')
    if selector != 0 && selector <= curline
      let start = col('.') - 1
      let b:tagcompl = 1
      while start >= 0 && line[start - 1] =~ '\k'
        let start -= 1
      endwhile
      let b:after = line[compl_begin :]
      let b:compl_context = matchstr(getline('.')[0:compl_begin], '^\s*\$(''\zs.*$')
    endif
    return start
  else
    if exists("b:compl_context")
      let line = b:compl_context
      let after = b:after
      unlet! b:compl_context
    else
      let line = a:base
    endif

    let res = []
    let res2 = []
    let borders = {}

    let squarebracket = strridx(line, '[')
    let colon = strridx(line, ':')
    let paren = strridx(line, '(')


    if squarebracket > -1
      let borders[squarebracket] = "squarebracket"
    endif
    if colon > -1
      let borders[colon] = "colon"
    endif
    if paren > -1
      let borders[paren] = "paren"
    endif

    if len(borders) == 0
      let entered_selector = matchstr(line, '[a-zA-Z]*$')
      for m in s:tagSelectors
        if m =~? '^'.entered_selector
          call add(res, m)
        elseif m =~? entered_selector
          call add(res2, m)
        endif
      endfor
      return res + res2
    elseif borders[max(keys(borders))] == 'colon'
      let entered_value = matchstr(line, '.\{-}\%(\$(''\)[a-zA-Z ]*:\zs[a-zA-Z]*$')
      for m in s:ajaxSelectors
        if m['word'] =~? '^'.entered_value
          call add(res, m)
        elseif m['word'] =~? entered_value
          call add(res2, m)
        endif
      endfor
      return res + res2
    elseif borders[max(keys(borders))] =~ '^\%(squarebracket\|paren\)$'
      return []
    endif
    let entered_selector = matchstr(line, '[a-zA-Z]*$')
    for m in s:tagSelectors
      if m =~? '^'.entered_selector
        call add(res, m)
      elseif m =~? entered_selector
        call add(res2, m)
      endif
    endfor
    return res + res2
  endif
endfunction
