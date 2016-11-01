"Vim JavaScript Omni Completion
"Maintainer:  Ali Zarifkar <ali.zarifkar@gmail.com>
"Last Change: 2016/03/02
"Version:     0.1.0
"License:     MIT
"URL:         https://www.github.com

function! jsomni#init()
  let b:old_omnifunc = &omnifunc
  set omnifunc=jsomni#complete
endfunction

function! jsomni#complete(findstart, base)
  if a:findstart
    let line = getline('.')
    let start = col('.') - 1
    let compl_begin = col('.') - 2
    let b:compl_context = getline('.')[0:compl_begin]
    let lineNum = line('.')
    while start >= 0 && line[start - 1] =~ '\k'
      let start -= 1
    endwhile
"   let startBlock = searchpair('{', '', '}', 'bnW")
"   let startBlockLine = getline(startBlock)
"   let startArg = searchpair('(', '', ')', 'bnW')
"   let endArg = searchpair('(', '', ')', 'nW')
"   let startArgLine = getline(startArg)
"   if startBlock != 0 && startBlockLine !~ '\%(function\).\{-}{$'
"   if startBlockLine =~ '\%(css(\).\{-}{$'
"     let b:methodcomplete = 1
"     if lineNum == startBlock
"       let b:compl_context = matchstr(getline('.')[0:compl_begin], ':\s*['']\zs[^'']*$')
"     endif
"     return start
"   elseif startArg != 0 && startArg == endArg && startArgLine !~ '\%(function\).\{-}('
"   if startArgLine =~ 'addEventListener('
"     let b:argcomplete = 1
"     let b:argcomplete = 1
"     let b:compl_context = matchstr(getline('.')[0:compl_begin], '['']\\zs[^'']\\{-}$')
"     return start
    if b:old_omnifunc != ''
      execute "let start = " . b:old_omnifunc . "(a:findstart, a:base)"
    endif
    return start
  else
    if exists("b:compl_context")
      let line = b:compl_context
      unlet! b:compl_context
    else
      let line = a:base
    endif
"   if exists("b:methodcomplete")
"     unlet! b:methodcomplete
"     return jsomni#methodcomplete(0, line)
"   endif
"   if exists("b:argcomplete")
"     unlet! b:argcomplete
"     return jsomni#argcomplete(0, line)
"   endif
    let res = []
    let res2 = []
    let borders = {}
    let parens = strridx(line, '(')
"   let comma = strridx(line, ',')
    let brace = strridx(line, '{')
    let colon = strridx(line, ':')
    let bracket = strridx(line, '[')

    if brace > -1
      let borders[brace] = "brace"
    endif
    if bracket > -1
      let borders[bracket] = "bracket"
    endif
    if colon > -1
      let borders[colon] = "colon"
    endif
    if parens > -1
      let borders[parens] = "parens"
    endif
"   if comma > -1
"     let borders[comma] = "comma"
"   endif
    if len(borders) == 0 || borders[max(keys(borders))] == 'brace'
      let startBlock = searchpair('{', '', '}', "bnW")
      let startBlockLine = getline(startBlock)
      if startBlock != 0 && startBlockLine !~ '\%(function\|if\|else\|try\).\{-}{$'
        let startBlock = searchpair("{", "", "}", "bnW")
        let startBlockLine = getline(startBlock)
        let parentMethod = matchstr(startBlockLine, "\\k\\+\\ze({")
        execute "let list = jsomni#". &filetype ."#getlist(parentMethod)"
        let enteredValue = matchstr(line, "[a-zA-Z0-9_$]\\+$")
        echom enteredValue
        if !empty(list) && type(list[0]) == type({})
          for m in list
            if m['word'] =~? '^'.enteredValue
              call add(res, extend(m, {'icase': 1}))
            elseif m['word'] =~? enteredValue
              call add(res2, extend(m, {'icase': 1}))
            endif
          endfor
        else
          for m in list
            if m =~? '^'.enteredValue
              call add(res, {'word': m, 'menu': '(str)', 'icase': 1})
            elseif m =~? enteredValue
              call add(res2, {'word': m, 'menu': '(str)', 'icase': 1})
            endif
          endfor
        endif
"       return sort(res, 'i')
      elseif b:old_omnifunc != ''
        execute "let res = " . b:old_omnifunc . "(a:findstart, a:base)"
      endif
      return res2 + res
    elseif borders[max(keys(borders))] =~ '^\%(parens\|bracket\)$'
      let cline = getline('.')
      let pattern = '\k\zs('
      let col = col('.')
      let end = -1
      let index = match(cline, pattern, end)

      while index >= 0 && index < col
        let end = index
        let index = match(cline, pattern, index + 1)
      endwhile

      if end == -1
        return []
      endif

      let candidates = cline[0 : end-1]
      let start = match(candidates, '\(\k\+\.\)\?[a-zA-Z0-9_\-$]\+$')
      let end = strlen(candidates)
      let method = candidates[start : end]
      execute "let list = jsomni#". &filetype ."#getlist(method)"
       let enteredValue = matchstr(line, "'\\zs[^']\\{-}$")
    " let expr = 'v:val =~? '."'^".escape(enteredValue, '\\/.*$^~[]')."'"
    " let list = filter(deepcopy(list), expr)
      echom a:base
      for m in list
        if m =~? '^'.enteredValue
          call add(res, {'word': m, 'menu': '(str)', 'icase': 1})
        elseif m =~? enteredValue
          call add(res2, {'word': m, 'menu': '(str)', 'icase': 1})
        endif
      endfor
      if len(res + res2) == 0
        if b:old_omnifunc != ''
          execute "let res = " . b:old_omnifunc . "(a:findstart, a:base)"
        endif
      endif
"     return sort(res, 'i')
      return res + res2
    elseif borders[max(keys(borders))] == 'colon'
      let cline = getline('.')
      let pattern = '\k\s*\zs:'
      let col = col('.')
      let end = -1
      let index = match(cline, pattern, end)

      while index >= 0 && index < col
        let end = index
        let index = match(cline, pattern, index + 1)
      endwhile

      if end == -1
        return []
      endif

      let candidates = cline[0 : end-1]
      let start = match(candidates, '\(\k\+\.\)\?[a-zA-Z0-9_\-$]\+$')
      let end = strlen(candidates)
      let method = candidates[start : end]
      execute "let list = jsomni#". &filetype ."#getlist(method)"
      let enteredValue = matchstr(line, "'\\zs[^']\\{-}$")
      " let expr = 'v:val =~? '."'^".escape(enteredValue, '\\/.*$^~[]')."'"
      " let list = filter(deepcopy(list), expr)
      for m in list
        if m =~? '^'.enteredValue
          call add(res, {'word': m, 'menu': '(str)', 'icase': 1})
        elseif m =~? enteredValue
          call add(res2, {'word': m, 'menu': '(str)', 'icase': 1})
        endif
      endfor
      if len(res + res2) == 0
        if b:old_omnifunc != ''
          execute "let res = " . b:old_omnifunc . "(a:findstart, a:base)"
        endif
      endif
"     return sort(res, 'i')
      return res + res2
"   let single_quote = match(line, '\\\\\\@<!''')
"   let double_quote = match(line, '\\\\\\@<!"')
"   if single_quote > -1
"     let borders[single_quote] = 'single_quote'
"   endif
"   if double_quote > -1
"     let borders[double_quote] = 'double_quote'
"   endif
"   if borders[max(keys(borders))] =~ '^\%(single_quote\|double_quote\)$'
    elseif b:old_omnifunc != ''
      execute "let res = " . b:old_omnifunc . "(a:findstart, a:base)"
    endif
    return res + res2
  endif
endfunction

function! jsomni#argcomplete(findstart, base)
  let line = getline('.')
  let pattern = '\k\zs('
  let col = col('.')
  let end = -1
  let index = match(line, pattern, end)

  while index >= 0 && index < col
    let end = index
    let index = match(line, pattern, index + 1)
  endwhile

  if end == -1
    return []
  endif

  let candidates = line[0 : end-1]
  let start = match(candidates, '\(\k\+\.\)\?[a-zA-Z0-9_\-$]\+$')
  let end = strlen(candidates)
  let method = candidates[start : end]
  let res = []
  let borders = {}

  let parens = strridx(a:base, '(')
  let comma = strridx(a:base, ',')

  if parens > -1
    let borders[parens] = "parens"
  endif
  if comma > -1
    let borders[comma] = "comma"
  endif

  if len(borders) == 0 || borders[max(keys(borders))] == 'comma'
    return []
  elseif borders[max(keys(borders))] == 'parens'
    execute "let list = jsomni#". &filetype ."#getlist(method)"
     let enteredValue = matchstr(a:base, "'\\zs[^']\\{-}$")
  " let expr = 'v:val =~? '."'^".escape(enteredValue, '\\/.*$^~[]')."'"
  " let list = filter(deepcopy(list), expr)
    echom a:base
    for m in list
      if m =~? '^'.enteredValue
        call add(res, m)
      endif
    endfor
    return sort(res, 'i')
  endif
endfunction

function! jsomni#methodcomplete(findstart, base)

  let res = []
  let borders = {}

  let brace = strridx(a:base, '{')
  let colon = strridx(a:base, ':')

  if brace > -1
    let borders[brace] = "brace"
  endif
  if colon > -1
    let borders[colon] = "colon"
  endif

  if len(borders) == 0 || borders[max(keys(borders))] == 'brace'
    let startBlock = searchpair("{", "", "}", "bnW")
    let startBlockLine = getline(startBlock)
    let parentMethod = matchstr(startBlockLine, "\\k\\+\\ze({")
    echom parentMethod
    execute "let list = jsomni#". &filetype ."#getlist(parentMethod)"
    let enteredValue = matchstr(a:base, "[a-zA-Z0-9_$]\\+$")
  elseif borders[max(keys(borders))] == 'colon'
    let line = getline('.')
    let pattern = '\k\s*\zs:'
    let col = col('.')
    let end = -1
    let index = match(line, pattern, end)

    while index >= 0 && index < col
      let end = index
      let index = match(line, pattern, index + 1)
    endwhile

    if end == -1
      return []
    endif

    let candidates = line[0 : end-1]
    let start = match(candidates, '\(\k\+\.\)\?[a-zA-Z0-9_\-$]\+$')
    let end = strlen(candidates)
    let method = candidates[start : end]
    execute "let list = jsomni#". &filetype ."#getlist(method)"
    let enteredValue = matchstr(a:base, "'\\zs[^']\\{-}$")
  endif
  " let expr = 'v:val =~? '."'^".escape(enteredValue, '\\/.*$^~[]')."'"
  " let list = filter(deepcopy(list), expr)
  for m in list
    if m =~? '^'.enteredValue
      call add(res, m)
    endif
  endfor
  return sort(res, 'i')
endfunction
