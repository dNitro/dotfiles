" File          : .vimrc
" Description   : vim text editor configuration file
" Maintainer    : dNitro <ali.zarifkar AT gmail DOT com>
" Last modified : 2016 Nov 22 at 01:49:49 AM
" License       : MIT

"-[ BASE ]====================================================================
" Be IMproved
set nocompatible

" Variables
let s:mac = has('mac')
let s:macvim = has('gui_macvim')
let s:windows = has('win32') || has('win64')
let s:gvim = has('gui_running')

" Add $HOME/.vim to windows runtimepath
if s:windows
  set rtp+=~/.vim
endif

" Plugin Management
if !filereadable(expand("~/.vim/autoload/plug.vim"))
  echo "Installing vim-plug and plugins. Restart vim after finishing the process."
  execute "!curl -fLo "
    \ . expand("~/.vim/autoload/plug.vim", 1)
    \ . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall
endif

silent! if plug#begin('~/.vim/plugged')

  if s:mac
    let g:plug_url_format = 'git@github.com:%s.git'
  else
    let $GIT_SSL_NO_VERIFY = 'true'
  endif
  "-2 Libs -------------------------------------------------------------------
  Plug 'git-mirror/vim-l9'
  "-2 Locals -----------------------------------------------------------------
  Plug '~/.vim/plugged-local/cssautocomplete'
  Plug '~/.vim/plugged-local/javascriptautocomplete'
  Plug '~/.vim/plugged-local/jsomni'
  Plug '~/.vim/plugged-local/jsonautocomplete'
  " Plug '~/.vim/plugged-local/vim-autocomplpop'
  Plug '~/.vim/plugged-local/vim-sass'
  Plug '~/.vim/plugged-local/vison'
  "-2 Explore ----------------------------------------------------------------
  Plug 'ctrlpvim/ctrlp.vim', { 'on': '<Plug>(ctrlp)' }
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  augroup nerd_loader
    autocmd!
    autocmd VimEnter * silent! autocmd! FileExplorer
    autocmd BufEnter,BufNew *
          \  if isdirectory(expand('<amatch>'))
          \|   call plug#load('nerdtree')
          \|   execute 'autocmd! nerd_loader'
          \| endif
  augroup END
  if v:version >= 703
    Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
  endif
  Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }
  Plug 'justinmk/vim-gtfo'
  Plug 'christoomey/vim-tmux-navigator'
  function! CookDispatch(info)
    if a:info.status == 'installed' || a:info.force
      !sed -i -e "s/-l '.height.'/-h/" ./autoload/dispatch/tmux.vim
    endif
  endfunction
  Plug 'tpope/vim-dispatch', { 'do': function('CookDispatch') }
  "-2 Edit -------------------------------------------------------------------
  Plug 'editorconfig/editorconfig-vim'
  " Plug 'Raimondi/delimitMate'
  Plug 'jiangmiao/auto-pairs'
  let g:AutoPairsFlyMode = 1
  let g:AutoPairsMapBS = 0
  let g:AutoPairsMapCh = 0
  Plug 'fadein/vim-FIGlet'
  Plug 'qwertologe/nextval.vim'
  function! CookUltisnips(info)
    if a:info.status == 'installed' || a:info.force
      !sed -i -e "s/if trigger.lower() == '<tab>':/if trigger.lower() == '':/" ~/.vim/plugged/ultisnips/pythonx/UltiSnips/snippet_manager.py
    endif
  endfunction
  Plug 'SirVer/ultisnips', { 'do': function('CookUltisnips') }
  Plug 'KabbAmine/vCoolor.vim'
  Plug 'tpope/vim-commentary'
  Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)',
                                         \ 'EasyAlign',
                                         \ '<Plug>(LiveEasyAlign)',
                                         \ 'LiveEasyAlign'] }
  Plug 'terryma/vim-expand-region'
  Plug 'terryma/vim-multiple-cursors'
  Plug 'sickill/vim-pasta'
  Plug 'tpope/vim-surround'
  Plug 'triglav/vim-visual-increment'
  "-2 UI ---------------------------------------------------------------------
  Plug 'altercation/vim-colors-solarized'
  Plug 'morhetz/gruvbox'
  Plug 'ryanoasis/vim-devicons'
  "-2 Lang -------------------------------------------------------------------
  Plug 'suan/vim-instant-markdown', { 'for': 'markdown' }
  Plug 'mattn/emmet-vim'
  Plug 'othree/html5.vim'
  Plug 'JulesWang/css.vim'
  function! CookTern(info)
    if a:info.status == 'installed' || a:info.force
      !npm install
      !cp -rp ~/.vim/plugged-local/tern/defs/* ./node_modules/tern/defs/
      !cp -rp ~/.vim/plugged-local/tern/plugin/* ./node_modules/tern/plugin/
      !patch ./script/tern.py < ~/.vim/plugged-local/tern/tern.patch
    endif
  endfunction
  Plug 'ternjs/tern_for_vim', { 'do': function('CookTern') }
  Plug 'pangloss/vim-javascript'
  Plug 'digitaltoad/vim-pug', { 'for': ['jade', 'pug'] }
  Plug 'dNitro/vim-pug-complete', { 'for': ['jade', 'pug'] }
  "-2 Lint -------------------------------------------------------------------
  Plug 'scrooloose/syntastic'
  "-2 Git --------------------------------------------------------------------
  Plug 'sjl/splice.vim', { 'on': 'SpliceInit' }
  "-2 Auto Complete ----------------------------------------------------------
  Plug 'maralla/completor.vim', { 'do': 'make js' }
  let g:completor_min_chars = 0
  let g:completor_select_first = 1
  let g:completor_disable_ultisnips = 1
  let g:completor_html_omni_trigger = '(<|<[a-zA-Z][a-zA-Z1-6]*\s+|="|"\s+)$'
  let g:completor_css_omni_trigger = '([\w-]+|@[\w-]*|[\w-]+:\s*[\w-]*|\S\s+)$'
  let g:completor_pug_omni_trigger = '(^\s*\w*|\S\s+|\(|=''|\.|\#)$'
  let g:completor_json_omni_trigger = '(^\s*\w*)$'
  "==-------------------------------------------------------------------------
  call plug#end()
endif

" Enable filetype detection, plugin and indent
filetype plugin indent on

" Syntax highlighting
syntax on
if !s:macvim || !s:gvim
  set t_Co=256
endif
set background=dark
colorscheme gruvbox
"=============================================================================
"-[ MACVIM ]==================================================================
if s:macvim || s:gvim
  set guifont=Consolas\ Italic:h13
  set guioptions=aem
  set belloff=all
  colorscheme solarized
endif
"=============================================================================
"-[ SETTING ]=================================================================
set encoding=utf-8               " Encode all files in utf-8
set backspace=indent,eol,start   " Backspace over everything
set nowrap                       " No line wrapping
" set colorcolumn=79               " `
" set textwidth=78                 " |
" set formatoptions=tcq            " > line wrapping
" set linebreak                    " |
" set showbreak=>                  " |
" set breakindent                  " ,
set mouse=a                      " Use mouse
if has("mouse_sgr")
  set ttymouse=sgr               " SGR mouse if available
else
  set ttymouse=xterm2            " Fall back to xterm2 mouse
end
set completeopt=menuone,noinsert " Popupmenu menuone and noinsert
set timeoutlen=140               " Lower the timeout
set hidden                       " Change buffers without saving
set history=1000                 " Increase history from default 50 to 1000 line
set visualbell t_vb=             " No beep nor flash
set showcmd                      " Show command in bottom right
set number                       " Show lines numbers
set noswapfile                   " No swap files
set backupdir=~/.vim/tmp/backup  " Store backups here
set undofile                     " Save undo history between Vim invocations
set undodir=~/.vim/tmp/undo      " Store undo history here
if !isdirectory(&backupdir)      " `
  call mkdir(&backupdir, "p")    " |
endif                            " > Create those folders if they don't already exist.
if !isdirectory(&undodir)        " |
  call mkdir(&undodir, "p")      " |
endif                            " ,
set viminfo='100,/1000,:1000,<50,s100,h,c,n~/.vim/tmp/viminfo " Increase ' / : history
set tags=./tags,tags;            " Search current and parent dirs to find tags file
set termbidi                     " Terminal is responsible for bidi (bidirectional text)
set modeline                     " Apply vim setting locally if available
set modelines=1                  " Consider setting from Last line
set wildmenu                     " More useful command-line completion
set wildmode=list:longest        " Insert longest common text
set wildignore+=.DS_Store        " Ignore this file and folders
set wildignore+=*/vendor/*,*/bower_components/*,*/node_modules/*
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
set wildignore+=*/.sass-cache/*,*/log/*,*/tmp/*,*/build/*,*/ckeditor/*,*/doc/*,*/source_maps/*,*/dist/*
let mapleader = ","              " Let leader key to , instead of default \
" performance ----------------------------------------------------------------
set synmaxcol=500        " Don't highlight lines longer than 500 character
set ttyfast              " U got a fast terminal
set ttyscroll=3          " When scrolling is slow
set lazyredraw           " To avoid scrolling problems
set regexpengine=1       " Use older but faster regex engine
syntax sync maxlines=100 " Slow machines
" Indent ---------------------------------------------------------------------
set smartindent          " Autoindenting when starting a new line
set autoindent           " Do autoindentation smart
" Statusline -----------------------------------------------------------------
set laststatus=2         " Always show the status line and format it like:
set statusline=%F%m%r%h%w%=\ [%Y]\ [%{&ff}]\ [%04l,%04v]\ [%p%%]\ [%L]
" Search and Replace ---------------------------------------------------------
set incsearch            " Set incremental searching
set hlsearch             " Highlight searching
set ignorecase           " Case insensitive search
set smartcase            " Treat uppercase letters as upper
" Whitespace -----------------------------------------------------------------
" I use editorconfig to manage whitespace; Uncomment if you don't.
" set tabstop=2            " Tabs are 2 spaces
" set expandtab            " Replace tabs with &tabstop spaces
" set shiftwidth=2         " Shift lines left/right &tabstop spaces with <<, >>
" set softtabstop=2        " Tab jumps and Backspace deletes 2 space
" List mode ------------------------------------------------------------------
set listchars=tab:▸\ ,trail:•,extends:>,precedes:<,nbsp:.,eol:¬
hi SpecialKey guifg=#ffffff ctermfg=gray
hi NonText guifg=#666666 ctermfg=gray
" Vertical split -------------------------------------------------------------
set fillchars+=vert:│ " Change vertical split character to long bar (U+2502)
" Remove the background of bar
hi VertSplit cterm=NONE ctermfg=4 guibg=NONE guifg=#268bd2
"=============================================================================
"-[ CURSOR SHAPE ]============================================================
" Change cursor shape (iterm|tmux)
if exists('$ITERM_PROFILE')
  if exists('$TMUX')
    let &t_SI .= "\<Esc>[3 q"
    let &t_EI .= "\<Esc>[0 q"
  else
    let &t_SI .= "\<Esc>]50;CursorShape=1\x7"
    let &t_EI .= "\<Esc>]50;CursorShape=0\x7"
  endif
endif
"=============================================================================
"-[ PASTE MODE ]==============================================================
" Paste in INSERT mode without explicitly turning paste mode on/off
if exists('$TMUX')
  let &t_SI .= "\<Esc>Ptmux;\<Esc>\<Esc>[?2004h\<Esc>\\"
  let &t_EI .= "\<Esc>Ptmux;\<Esc>\<Esc>[?2004l\<Esc>\\"
else
  let &t_SI .= "\<Esc>[?2004h"
  let &t_EI .= "\<Esc>[?2004l"
endif

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

" Paste in NORMAL mode without explicitly turning paste mode on/off
if s:macvim
  set clipboard=
else
  set clipboard^=unnamed,unnamedplus
endif
"=============================================================================
"-[ MAPPINGS ]================================================================
" Insert empty line without leaving normal mode in command window (q:) and ... act normal
nnoremap <expr> <CR> (empty(&buftype) && !empty(bufname(''))) ? ":\<C-u>call append(line('.'), repeat([''], v:count1))\<CR>j": "\<CR>"

" Clear last search highlighting. :<Backspace> to get rid of :noh shown in the commandline
nnoremap <Esc> :noh<return><Esc>:<Backspace>

" Placeholders - places where you want to add text to the template, fast
nnoremap <silent> <tab> /<+.\{-1,}+><cr>c/+>/e<cr>

" Use shift+tab to select last popupmenu item
if s:macvim || s:gvim
  inoremap <expr> <S-Tab> "\<C-p>\<C-p>\<C-y>"
else
  inoremap <expr> [Z "\<C-p>\<C-p>\<C-y>"
endif

" Buffer Stuff
" List buffers and go to them whether with number or name
nnoremap bl :ls<CR>:b<Space>
" Go to next buffer
nnoremap <leader>g :bn<CR>
" Go to previous buffer
nnoremap <leader>s :bp<CR>

" Tags
" Jump to the definition
nnoremap <leader>t :tag /<c-r>=expand('<cword>')<cr><cr>
" Preview of the definition
nnoremap <leader>w :ptag /<c-r>=expand('<cword>')<cr><cr>

" Space to enter command mode
noremap <space> :

" Use j and k also for wraped lines
nnoremap j gj
nnoremap k gk

" Y yanks from the cursor to the end of the line, instead of being a synonym for yy
nnoremap Y y$

" Make X like D into a black hole
nnoremap X "_D

" Swap behavior of ' and ` for easier typing
nnoremap ' `
nnoremap ` '

" Easier window navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Up and down arrow keys for numerical increament and decreament
nnoremap <Up> <c-a>
nnoremap <Down> <c-x>
if s:macvim || s:gvim
  nnoremap <S-Up> 10<c-a>
  nnoremap <S-Down> 10<c-x>
endif

" On Return if pumvisible select Popupmenu item otherwise act as Autopairs return
imap <expr> <CR> pumvisible() ? "\<C-y>" : "\<cr>\<Plug>AutoPairsReturn"

" Move the cursor while in insert mode without using the arrow keys
inoremap <C-h> <Left>
" inoremap <expr> <C-j> pumvisible() ? "j" : "\<C-j>"
" inoremap <expr> <C-k> pumvisible() ? "k" : "\<C-k>"
inoremap <C-l> <right>

" Use j and k to move between popupmenu items
" inoremap <expr> k pumvisible() ? "\<C-p>" : "k"
" inoremap <expr> j pumvisible() ? "\<C-n>" : "j"

" Copy visual selection to clipboard
vnoremap Y "+y

" Jump back and forth fast in command line
cnoremap <C-b> <S-Left>
cnoremap <C-e> <S-Right>
cnoremap <C-$> <End>
cnoremap <C-^> <Home>

" Smooth listing
cnoremap <expr> <CR> <SID>CCR()
"=============================================================================
"-[ ABBREVIATIONS ]===========================================================
"Spelling corrects.
iab teh the
iab Teh The
iab cah cha
"=============================================================================
"-[ FUNCTIONS ]===============================================================
"-2 Response to CR in command mode gracefully (smooth listing) ---------------
" http://vi.stackexchange.com/a/9161/7976
function! s:CCR()
  if getcmdtype() == ":"
      let cmdline = getcmdline()
          if cmdline =~ '\v\C^(dli|il)' | return "\<CR>:" . cmdline[0] . "jump  " . split(cmdline, " ")[1] . "\<S-Left>\<Left>"
      elseif cmdline =~ '\v\C^(cli|lli)' | return "\<CR>:silent " . repeat(cmdline[0], 2) . "\<Space>"
      elseif cmdline =~ '\C^changes' | set nomore | return "\<CR>:sil se more|norm! g;\<S-Left>"
      elseif cmdline =~ '\C^ju' | set nomore | return "\<CR>:sil se more|norm! \<C-o>\<S-Left>"
      elseif cmdline =~ '\C^ol' | set nomore | return "\<CR>:sil se more|e #<"
      elseif cmdline =~ '\C^undol' | return "\<CR>:u "
      elseif cmdline =~ '\C^ls' | return "\<CR>:b\<space>"
      elseif cmdline =~ '/#$' | return "\<CR>:"
      else | return "\<CR>" | endif
  else | return "\<CR>" | endif
endfunction
"-2 Load template and patterns belong to that template -----------------------
function! LoadTemplate(extension)
  silent! :execute '0r ~/.vim/template/'. a:extension. '.tpl'
  silent! execute 'source ~/.vim/template/'.a:extension.'.patterns.tpl'
endfunction
"-2 SuperTab -------------------------------------------------------------------
function! Tabino()
    echo ""
    call UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res == 0
      if pumvisible()
          " return "\<C-p>\<C-n>"
          return "\<C-y>"
      elseif &filetype == 'html' &&
        \ search('></', 'nW') > 0 ||
        \ search('""', 'nW') > 0 ||
        \ search ('<[^<> /]*>\n^\s*$', 'nW') > 0
        return "\<esc>:call emmet#moveNextPrev(0)\<cr>"
      else
        return "\<tab>"
      endif
    else
      exec "snoremap <silent> " . g:UltiSnipsExpandTrigger . " <Esc>:call UltiSnips#ExpandSnippetOrJump()<cr>"
    endif
  return ""
endfunction
"-2 Refresh NERDTree -----------------------------------------------------------
function! LiveNerd()
  let l:winnr = winnr()
  call g:NERDTree.CursorToTreeWin()
  call b:NERDTree.root.refresh()
  call b:NERDTree.root.refreshFlags()
  call NERDTreeRender()
  exec l:winnr . 'wincmd w'
endfunction
"-2 Insert the current date and time -------------------------------------------
function! LastMod()
  if line("$") > 10
    let l = 10
  else
    let l = line("$")
  endif
  exe '1,' . l . 'g/Last modified\s*:/s/Last modified\(\s*\):\(\s*\).*/Last modified\1:\2'
        \ . strftime("%Y %b %d at %X %p") . '/g'
endfunction
"=============================================================================

"-1[ AUTO COMMANDS ]==========================================================
" We should wrap autocmds in augroup, to close it first and run again to not
" slowing down vim
augroup general
  au!

  " Disable MatchParen
  au VimEnter * NoMatchParen

  " If file is empty, load template of that filetype if there is any
  au BufNewFile,BufRead * if line('$') == 1 && getline('1') == ''
                            \| silent! call LoadTemplate('%:e')
                            \| match Todo /<+.\{-1,}+>/
                       \| endif

  " Automatically change current directory to that of the file in the buffer
  au BufEnter * lcd %:p:h

  " Save on FocusLost
  au FocusLost * :silent! wall

  " Rearrage windows on resize
  au VimResized * :wincmd =

  " Make Tab SuperTab
  au InsertEnter * exec "inoremap " . g:UltiSnipsExpandTrigger . " <C-R>=Tabino()<cr>"

  " Disable line numbers in popupmenu Preview window
  autocmd WinEnter * if &pvw | setlocal nonu | endif

  " " Refresh NERDTree on CursorHold
  " au CursorHold * if exists("t:NERDTreeBufName")
  "                   \| silent! call LiveNerd()
  "              \| endif

  " AutoSave
  au InsertLeave,CursorHold * if empty(&buftype) && !empty(bufname(''))
                                \| silent! update
                           \| endif

  " Insert the current date and time when writing
  au BufWritePre,FileWritePre * ks | silent! call LastMod() | 's

augroup END

augroup vimrc
  au!
  " Source the vimrc file after saving it
  au BufWritePost .vimrc source $MYVIMRC
augroup END

augroup ftspecific
  au!
  " Disable automatic comment insertion
  au BufNewFile,BufRead * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
  au BufNewFile,BufRead *.scss UltiSnipsAddFiletypes css
  au BufNewFile,BufRead gulpfile.js UltiSnipsAddFiletypes javascript-gulp
  au BufNewFile,BufRead .jshintrc setlocal ft=json | Vison jshintrc.json
  au BufNewFile,BufRead .jscsrc setlocal ft=json | Vison jscsrc.json
  au BufNewFile,BufRead .babelrc setlocal ft=json | Vison babelrc.json
  au BufNewFile,BufRead .bowerrc setlocal ft=json | Vison bowerrc.json
  au BufNewFile,BufRead *.json Vison
  au BufNewFile,BufRead *{[tT]est,[sS]pec}.js UltiSnipsAddFiletypes javascript-mocha-bdd
augroup END
"=============================================================================
"-[ PLUGINS ]=================================================================
"-2 commentary ----------------------------------------------------------------
xmap <leader>e  <Plug>Commentary
nmap <leader>e  <Plug>Commentary
omap <leader>e  <Plug>Commentary
"-2 vim-devicons --------------------------------------------------------------
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:DevIconsEnableFolderExtensionPatternMatching = 1
"-2 NERDTree -----------------------------------------------------------------
" Toggle NERDTree window
if s:macvim " macvim
  noremap <F9> :NERDTreeToggle<CR>:echo ''<CR>
  inoremap <F9> <Esc>:NERDTreeToggle<CR>:echo ''<CR>
else        " terminal.app and iTerm
  noremap <esc>[20~ :NERDTreeToggle<CR>:echo ''<CR>
  inoremap <esc>[20~ <Esc>:NERDTreeToggle<CR>:echo ''<CR>
endif

" NERDTree window close automatically on opening a file
let NERDTreeQuitOnOpen=1

" Single click to open dir & dbclick to open files
let NERDTreeMouseMode=2

" Show hidden files
let NERDTreeShowHidden=1

" Disables the 'Bookmarks' label 'Press ? for help' text
" let NERDTreeMinimalUI=1

" Which files the NERDTree should ignore
let NERDTreeIgnore=['\.sw.$', '\.DS_Store$', '\~$']
"-2 UltiSnips ----------------------------------------------------------------
" Speedup by making absolute path because this way UtiSnips will not look for
" snippets in &runtimepath
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']

" Mappings
let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
if s:macvim || s:gvim
  let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
else
  let g:UltiSnipsJumpBackwardTrigger="[Z" " <s-tab>
endif

" let g:UltiSnipsEdit to split your window verticaly
let g:UltiSnipsEditSplit="vertical"

augroup ultisnips
  autocmd!
  autocmd User UltiSnipsEnterFirstSnippet if (winline() * 3 >= winheight(0) * 2) | exe "norm! zza" | endif
augroup END

" Initial variables
let g:ulti_expand_res = 0
let g:ulti_expand_or_jump_res = 0
let g:ulti_jump_forwards_res = 0
"-2 vim-easy-align -----------------------------------------------------------
nmap ga <Plug>(LiveEasyAlign)
vmap <F5> <Plug>(LiveEasyAlign)
"-2 Tagbar -------------------------------------------------------------------
" Toggle Tagbar window
nmap <F8> :TagbarToggle<CR>

let g:tagbar_type_css = {
  \ 'ctagstype' : 'css',
  \ 'kinds' : [
  \   'v:variables',
  \   'c:classes',
  \   'i:ids',
  \   't:tags',
  \   'm:media',
  \   'f:fonts',
  \   'k:keyframes'
  \ ],
  \ 'sort' : 0,
  \ 'deffile' : '~/.vim/ctags/css.cnf'
  \ }
let g:tagbar_type_scss = {
  \ 'ctagstype' : 'css',
  \ 'kinds' : [
  \   'v:variables',
  \   'c:classes',
  \   'i:ids',
  \   't:tags',
  \   'm:media',
  \   'f:fonts',
  \   'k:keyframes'
  \ ],
  \ 'sort' : 0,
  \ 'deffile' : '~/.vim/ctags/css.cnf'
  \ }
"-2 VCoolor ------------------------------------------------------------------
let g:vcoolor_map = '<leader>c'
let g:vcool_ins_rgb_map = '<leader>r'
let g:vcool_ins_hsl_map = '<leader>h'
let g:vcool_ins_rgba_map = '<leader>a'
"-2 vim-multiple-cursors -----------------------------------------------------
" Esc won't be canceling the multiple cursors
let g:multi_cursor_exit_from_insert_mode = 0

" Also in visual mode
let g:multi_cursor_exit_from_visual_mode = 0

" Called once right before you start selecting multiple cursors
function! Multiple_cursors_before()
  if exists(':AcpLock')==2
    exe 'AcpLock'
  endif
endfunction

" Called once only when the multiple selection is canceled (default <Esc>)
function! Multiple_cursors_after()
  if exists(':AcpUnlock')==2
    exe 'AcpUnlock'
  endif
endfunction
"-2 delimitMate --------------------------------------------------------------
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1
"-2 Emmet --------------------------------------------------------------------
let g:user_emmet_leader_key=','
"-2 vim-expand-region --------------------------------------------------------
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
"-2 tern-for-vim -------------------------------------------------------------
set noshowmode  "disable showmode to show preview information in bottom
let tern_show_argument_hints = 'on_move'
let tern_ignorecase = 1
let tern_default_icon = '  '
let tern_icons = {
 \  'reserved':   '  ',
 \  'ecmascript': '  ',
 \  'browser':    '  ',
 \  'jQuery':     '  ',
 \  'requirejs':  '  ',
 \  'node':       '  ',
 \  'grunt':      '  ',
 \  'generator':  '  ',
 \  'lodash':     '  ',
 \  'ramda':      '  ',
 \  'qunit':      '  ',
 \  'jasmine':    '  ',
 \  'mocha':      '  ',
 \  'chai':       '  ',
 \  'sinon':      '  '
 \}
"-2 Syntastic ----------------------------------------------------------------
let g:syntastic_check_on_wq = 0 " Don't check when i do save&exit
"=============================================================================

"-1 vim:foldmethod=marker:foldmarker="-,"==:foldlevel=0
