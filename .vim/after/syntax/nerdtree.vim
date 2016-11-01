let s:tree_up_dir_line = '.. (up a dir)'
syn match NERDTreeIgnore #\~#
exec 'syn match NERDTreeIgnore #\['.g:NERDTreeGlyphReadOnly.'\]#'

"highlighting for the .. (up dir) line at the top of the tree
execute "syn match NERDTreeUp #\\V". s:tree_up_dir_line ."#"

"quickhelp syntax elements
syn match NERDTreeHelpKey #" \{1,2\}[^ ]*:#ms=s+2,me=e-1
syn match NERDTreeHelpKey #" \{1,2\}[^ ]*,#ms=s+2,me=e-1
syn match NERDTreeHelpTitle #" .*\~#ms=s+2,me=e-1
syn match NERDTreeToggleOn #(on)#ms=s+1,he=e-1
syn match NERDTreeToggleOff #(off)#ms=e-3,me=e-1
syn match NERDTreeHelpCommand #" :.\{-}\>#hs=s+3
syn match NERDTreeHelp  #^".*# contains=NERDTreeHelpKey,NERDTreeHelpTitle,NERDTreeIgnore,NERDTreeToggleOff,NERDTreeToggleOn,NERDTreeHelpCommand

"highlighting for sym links
syn match NERDTreeLinkTarget #->.*# containedin=NERDTreeDir,NERDTreeFile
syn match NERDTreeLinkFile #.* ->#me=e-3 containedin=NERDTreeFile
syn match NERDTreeLinkDir #.*/ ->#me=e-3 containedin=NERDTreeDir

"highlighing for directory nodes and file nodes
syn match NERDTreeDirSlash #/# containedin=NERDTreeDir

exec 'syn match NERDTreeClosable #'.escape(g:NERDTreeDirArrowCollapsible, '~').'# containedin=NERDTreeDir,NERDTreeFile'
exec 'syn match NERDTreeOpenable #'.escape(g:NERDTreeDirArrowExpandable, '~').'# containedin=NERDTreeDir,NERDTreeFile'

let s:dirArrows = escape(g:NERDTreeDirArrowCollapsible, '~').escape(g:NERDTreeDirArrowExpandable, '~')
exec 'syn match NERDTreeDir #[^'.s:dirArrows.' ].*/#'
syn match NERDTreeExecFile  #^ .*\*\($\| \)# contains=NERDTreeRO,NERDTreeBookmark
exec 'syn match NERDTreeFile  #^[^"\.'.s:dirArrows.'] *[^'.s:dirArrows.']*# contains=NERDTreeLink,NERDTreeRO,NERDTreeBookmark,NERDTreeExecFile'

"highlighting for readonly files
exec 'syn match NERDTreeRO # *\zs.*\ze \['.g:NERDTreeGlyphReadOnly.'\]# contains=NERDTreeIgnore,NERDTreeBookmark,NERDTreeFile'

syn match NERDTreeFlags #^ *\zs\[.\]# containedin=NERDTreeFile,NERDTreeExecFile
syn match NERDTreeFlags #\[.\]# containedin=NERDTreeDir

syn match NERDTreeCWD #^[</].*$#

"highlighting for bookmarks
syn match NERDTreeBookmark # {.*}#hs=s+1

"highlighting for the bookmarks table
syn match NERDTreeBookmarksLeader #^>#
syn match NERDTreeBookmarksHeader #^>-\+Bookmarks-\+$# contains=NERDTreeBookmarksLeader
syn match NERDTreeBookmarkName #^>.\{-} #he=e-1 contains=NERDTreeBookmarksLeader
syn match NERDTreeBookmark #^>.*$# contains=NERDTreeBookmarksLeader,NERDTreeBookmarkName,NERDTreeBookmarksHeader

hi def link NERDTreePart Special
hi def link NERDTreePartFile Type
hi def link NERDTreeExecFile Title
hi def link NERDTreeDirSlash Identifier

hi def link NERDTreeBookmarksHeader statement
hi def link NERDTreeBookmarksLeader ignore
hi def link NERDTreeBookmarkName Identifier
hi def link NERDTreeBookmark normal

hi def link NERDTreeHelp String
hi def link NERDTreeHelpKey Identifier
hi def link NERDTreeHelpCommand Identifier
hi def link NERDTreeHelpTitle Macro
hi def link NERDTreeToggleOn Question
hi def link NERDTreeToggleOff WarningMsg

hi def link NERDTreeLinkTarget Type
hi def link NERDTreeLinkFile Macro
hi def link NERDTreeLinkDir Macro

hi def link NERDTreeDir Directory
hi def link NERDTreeUp Directory
hi def link NERDTreeFile Normal
hi def link NERDTreeCWD Statement
hi def link NERDTreeOpenable Title
hi def link NERDTreeClosable Title
hi def link NERDTreeIgnore ignore
"hi def link NERDTreeRO WarningMsg
hi def link NERDTreeBookmark Statement
hi def link NERDTreeFlags Number

hi def link NERDTreeCurrentNode Search

let s:rgb_map = {
  \   34: '#2B9C1A',
  \   69: '#2F4AA5',
  \  129: '#7600BC',
  \  135: '#af5fff',
  \  145: '#9D9D9D',
  \  208: '#C63920',
  \  161: '#A10047',
  \  220: '#E3DA28',
  \}
function! s:hi(extension, fg, bg)
  exe 'hi! '.a:extension.' ctermfg='.a:fg.' ctermbg='.a:bg.' guifg='.get(s:rgb_map, a:fg, 'NONE').' guibg='.get(s:rgb_map, a:bg, 'NONE')
  exe 'syn match '.a:extension.' #^\s\+.*'.a:extension.'\*\?\s\?\(\['.g:NERDTreeGlyphReadOnly.'\]\)\?$#'
endfunction

call s:hi('js', 220, 'NONE')
call s:hi('htm', 208, 'NONE')
call s:hi('html', 208, 'NONE')
call s:hi('css', 69, 'NONE')
call s:hi('vim', 34, 'NONE')
call s:hi('md', 129, 'NONE')
call s:hi('json', 145, 'NONE')
call s:hi('scss', 161, 'NONE')
call s:hi('php', 135, 'NONE')
