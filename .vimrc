" File          : .vimrc
" Description   : vim text editor configuration file
" Maintainer    : dNitro <ali.zarifkar AT gmail DOT com>
" Last modified : 2018 Apr 25 at 9:43:19 PM
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
if s:windows && s:gvim
    set runtimepath-=~/vimfiles
    set runtimepath^=~/.vim
    set runtimepath-=~/vimfiles/after
    set runtimepath+=~/.vim/after
endif
" no need to this just make a symlink from .vim to vimfiles
" ln -s .vim vimfiles

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
  " Plug '~/.vim/plugged-local/jsomni'
  Plug '~/.vim/plugged-local/jsonautocomplete'
  Plug '~/.vim/plugged-local/dbnext.vim'
  " Plug '~/.vim/plugged-local/vim-autocomplpop'
  " Plug '~/.vim/plugged-local/completor.vim'
  Plug '~/.vim/plugged-local/vim-sass'
  Plug '~/.vim/plugged-local/vison'
  Plug '~/.vim/plugged-local/vim-pug-complete'
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
  Plug 'skywind3000/asyncrun.vim'
  "-2 Edit -------------------------------------------------------------------
  Plug 'chrisbra/NrrwRgn'
  command! -nargs=* -bang -range -complete=filetype NN
            \ :<line1>,<line2> call nrrwrgn#NrrwRgn('',<q-bang>)
            \ | set filetype=<args>
  Plug 'editorconfig/editorconfig-vim'
  " Plug 'Raimondi/delimitMate'
  Plug 'jiangmiao/auto-pairs'
  " let g:AutoPairsFlyMode = 0
  " let g:AutoPairsMapBS = 0
  " let g:AutoPairsMapCh = 0
  let g:AutoPairsMapCR = 0
  Plug 'fadein/vim-FIGlet'
  Plug 'qwertologe/nextval.vim'
  function! CookUltisnips(info)
    if a:info.status == 'installed' || a:info.force
      !sed -i -e "s/if trigger.lower() == '<tab>':/if trigger.lower() == '':/" ~/.vim/plugged/ultisnips/pythonx/UltiSnips/snippet_manager.py
    endif
  endfunction
  " Plug 'SirVer/ultisnips', { 'do': function('CookUltisnips') }
  Plug 'SirVer/ultisnips'
  Plug 'KabbAmine/vCoolor.vim'
  Plug 'iandoe/vim-osx-colorpicker'
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
  Plug 'chriskempson/base16-vim'
  Plug 'altercation/vim-colors-solarized'
  Plug 'morhetz/gruvbox'
  " Plug 'ryanoasis/vim-devicons'
  Plug 'mhinz/vim-startify'
  "-2 Lang -------------------------------------------------------------------
  Plug 'posva/vim-vue'
  Plug 'iloginow/vim-stylus'
  " Plug 'suan/vim-instant-markdown', { 'for': 'markdown' }
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
  " Plug 'ternjs/tern_for_vim', { 'do': function('CookTern') }
  Plug 'pangloss/vim-javascript'
  Plug 'digitaltoad/vim-pug', { 'for': ['jade', 'pug'] }
  " Plug 'dNitro/vim-pug-complete', { 'for': ['jade', 'pug'] }
  " Plug 'cosminadrianpopescu/vim-sql-workbench'
  " let g:sw_exe = 'C:\Users\Davoud\Downloads\Compressed\Workbench-Build122\sqlwbconsole.exe'
  " let g:sw_config_dir = 'C:\Users\Davoud\.sqlworkbench'
  Plug 'vim-scripts/sqlserver.vim'
  let g:dbext_default_profile_mySQLServer  = 'type=SQLSRV:integratedlogin=1:srvname=DESKTOP-5DH60RL:dbname=sinamin_db_avl_tms'
  " let g:dbext_default_profile_mydb = 'type=SQLSRV:user=sa:srvname=DESKTOP-5DH60RL:dbname=sinamin_db_avl_tms'
  "-2 Lint -------------------------------------------------------------------
  Plug 'w0rp/ale'
  "-2 Git --------------------------------------------------------------------
  Plug 'mattn/webapi-vim'
  Plug 'mattn/gist-vim'
  let g:github_user='dnitro'
  let g:gist_api_url='https://api.github.com/'
  let g:gist_post_private = 1
  let g:gist_show_privates = 1
  Plug 'tpope/vim-fugitive'
  Plug 'sjl/splice.vim', { 'on': 'SpliceInit' }
  "-2 Auto Complete ----------------------------------------------------------
  Plug 'maralla/completor.vim', { 'do': 'make js' }
  let g:completor_min_chars = 0
  " let g:completor_python_binary = "/usr/bin/python3"
  let g:completor_completion_delay = 0
  let g:completor_refresh_always = 0
  " let g:completor_select_first = 1
  let g:completor_disable_ultisnips = 1
  let g:completor_html_omni_trigger = '(<|<[a-zA-Z][a-zA-Z1-6]*\s+|="|"\s+)$'
  let g:completor_css_omni_trigger = '([\w-]+|@[\w-]*|[\w-]+:\s*[\w-]*|\S\s+)$'
  let g:completor_stylus_omni_trigger = '(@)$'
  let g:completor_scss_omni_trigger = '([\w-]+|@[\w-]*|[\w-]+:\s*[\w-]*|\S\s+|&:)$'
  let g:completor_pug_omni_trigger = '(^\s*\w*|\S\s+|\(|=''|\.|\#)$'
  " let g:completor_json_omni_trigger = '(^\s*\w*)$'
  let g:completor_json_omni_trigger = '(\s*\w*)$'
  "==-------------------------------------------------------------------------
  call plug#end()
endif

" Enable filetype detection, plugin and indent
filetype plugin indent on

" Syntax highlighting
syntax on
set background=dark
colorscheme solarized
" colorscheme base16-ocean
" colorscheme base16-mocha
if !s:macvim || !s:gvim
  " set term=xterm
  set t_Co=256
  let &t_AB="\e[48;5;%dm"
  let &t_AF="\e[38;5;%dm"
  colorscheme gruvbox
  inoremap <Char-0x07F> <BS>
  nnoremap <Char-0x07F> <BS>
endif
"=============================================================================
"-[ MACVIM ]==================================================================
if s:macvim || s:gvim
  " set guifont=Source_Code_Pro_Semibold:h9:i
  set guifont=Consolas:h9:b:i
  " set guifont=Source_Code_Pro_Semibold:h10
  set guioptions=ae

  set belloff=all
  " colorscheme solarized
  colorscheme base16-ocean
endif
"=============================================================================
"-[ SETTING ]=================================================================
"set shell=/bin/zsh               " Use zsh as default shell
set shell=C:/WINDOWS/system32/bash.exe "Use bash as default shell in windows
set shellslash                   " Be consistent with shell slashes
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
  if !has('nvim')
    set ttymouse=xterm2            " Fall back to xterm2 mouse
  endif
end
set completeopt=menuone,noinsert " Popupmenu menuone and noinsert
set complete-=i                  " disable scanning included files
set complete-=t                  " disable searching tags
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
if !has('nvim')
  set viminfo='100,/1000,:1000,<50,s100,h,c,n~/.vim/tmp/viminfo " Increase ' / : history
endif
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
if !has('nvim')
  set ttyscroll=3          " When scrolling is slow
endif
set lazyredraw           " To avoid scrolling problems
set regexpengine=1       " Use older but faster regex engine
syntax sync maxlines=100 " Slow machines
" Indent ---------------------------------------------------------------------
set smartindent          " Autoindenting when starting a new line
set autoindent           " Do autoindentation smart
" Statusline -----------------------------------------------------------------
set laststatus=2         " Always show the status line and format it like:
set statusline=%<%F%m%r%h%w%=\ %Y\ \|\ %{&ff}\ \|\ line\ %l\/%L
if !empty(glob("$HOME/.vim/plugged/vim-fugitive/plugin/fugitive.vim"))
  set statusline+=\ %{fugitive#statusline()}         " Fugitive in statusline
endif
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
  set clipboard^=unnamed,unnamedplus
else
  set clipboard^=unnamed,unnamedplus
endif
"=============================================================================
"-[ MAPPINGS ]================================================================
" Quickly changee font size in gui with + and - in normal mode
command! Bigger  :let &guifont = substitute(&guifont, 'h\zs\d\+\ze:', '\=submatch(0)+1', '')
command! Smaller :let &guifont = substitute(&guifont, 'h\zs\d\+\ze:', '\=submatch(0)-1', '')
nnoremap + :Bigger<CR>
nnoremap - :Smaller<CR>

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

" Map Ctrl-w to remove [{('" in pairs
inoremap <expr> <C-w> strpart(getline('.'), col('.')-2, 1) =~ '[{(\[''"]' ? "\<C-r>=AutoPairsDelete()\<CR>" : "\<C-w>"

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

" Run, Test, Lint
nnoremap <leader>r :Run<CR>
nnoremap <leader>t :Test<CR>
nnoremap <leader>l :Lint<CR>


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
" now we have support for terminal in all version not only nvim
" if has('nvim')
  " if &buftype == 'terminal'
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-l> <C-\><C-n><C-w>l
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <leader>e <C-\><C-n>
  " endif
" endif
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
iab esle else
iab naem name
iab nvarcahr nvarchar
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
        \ . strftime("%Y %b %d at %X") . '/g'
endfunction
"=============================================================================
function! Exec(command)
    if v:version == 800
        :put =execute(a:command)
    else
        redir =>output
        silent exec a:command
        redir END
        let @o = output
        execute "put o"
    endif
endfunction!

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
                       \| let b:nrrw_aucmd_create = "wincmd j|wincmd k|wincmd ="
                       \| let b:nrrw_aucmd_close  = "call ale#Queue(0)"

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

" NeoVim
if has('nvim')
  augroup terminal
    au!
    au BufWinEnter,WinEnter term://* startinsert
    au BufLeave term://* stopinsert
  augroup END
endif

augroup colorscheme
  au!
  au ColorScheme *
              \| highlight SignColumn guibg=NONE ctermbg=NONE ctermfg=NONE guifg=NONE
              \| highlight ALEErrorSign guibg=NONE ctermbg=NONE guifg=#dc322f ctermfg=02
              \| highlight ALEWarningSign guibg=NONE ctermbg=NONE guifg=#e9a226 ctermfg=01
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
  au BufNewFile,BufRead *.ejs setlocal ft=html
  au BufNewFile,BufRead *.sql SQLSetType sqlserver.vim
augroup END
"=============================================================================
"-[ PLUGINS ]=================================================================
"-2 commentary ----------------------------------------------------------------
xmap <leader>c  <Plug>Commentary
nmap <leader>c  <Plug>Commentary
omap <leader>c  <Plug>Commentary
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

" Center screen when we are within last 1/3 of buffer
" startinsert in to complete command otherwise endif will inserted at end
augroup ultisnips
  autocmd!
  autocmd User UltiSnipsEnterFirstSnippet if (winline() * 3 >= (winheight(0) * 2))
                                            \| norm! zz
                                            " \| startinsert
                                        \| endif
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
" comment temporarily to use their keybinding for run, comment
" let g:vcoolor_map = '<leader>c'
" let g:vcool_ins_rgb_map = '<leader>r'
let g:vcool_ins_hsl_map = '<leader>h'
let g:vcool_ins_rgba_map = '<leader>a'
"-2 vim-multiple-cursors -----------------------------------------------------
" Esc won't be canceling the multiple cursors
let g:multi_cursor_exit_from_insert_mode = 0

" Also in visual mode
let g:multi_cursor_exit_from_visual_mode = 0

" controlling highlight color of multiple cursor
highlight multiple_cursors_cursor term=reverse cterm=reverse gui=reverse
highlight link multiple_cursors_visual Visual

"conevert highlights ( * or g* or / ) to multiple cursors
nnoremap <silent> <M-j> :MultipleCursorsFind <C-R>/<CR>
vnoremap <silent> <M-j> :MultipleCursorsFind <C-R>/<CR>

" Called once right before you start selecting multiple cursors
" function! Multiple_cursors_before()
"   if exists(':AcpLock')==2
"     exe 'AcpLock'
"   endif
" endfunction

" Called once only when the multiple selection is canceled (default <Esc>)
" function! Multiple_cursors_after()
"   if exists(':AcpUnlock')==2
"     exe 'AcpUnlock'
"   endif
" endfunction
"-2 delimitMate --------------------------------------------------------------
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1
"-2 Emmet --------------------------------------------------------------------
let g:user_emmet_leader_key=','
let g:user_emmet_settings = {
            \'html': {
            \'comment_type': 'lastonly'
            \}
          \}
"-2 vim-expand-region --------------------------------------------------------
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
"-2 tern-for-vim -------------------------------------------------------------
set noshowmode  "disable showmode to show preview information in bottom
" let tern_show_argument_hints = 'on_move'
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
"-2 Startify -----------------------------------------------------------------
hi StartifyBracket guifg=#586e75 ctermfg=240
hi StartifyFile    guifg=#2aa198 ctermfg=147
hi StartifyFooter  guifg=#586e75 ctermfg=240
hi StartifyHeader  guifg=#586e75 ctermfg=114
hi StartifyNumber  guifg=#6c71c4 ctermfg=215
hi StartifyPath    guifg=#586e75 ctermfg=245
hi StartifySlash   guifg=#586e75 ctermfg=240
hi StartifySpecial ctermfg=240
hi StartifySection guifg=#cb4b16
let g:startify_files_number = 7
let g:startify_bookmarks = [ {'c': '~/.vimrc'}, '~/.zshrc' ]
function! s:filter_header(lines) abort
        let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
        let centered_lines = map(copy(a:lines),
            \ 'repeat(" ", ((&columns-4) / 2) - (longest_line / 2)) . v:val')
        return centered_lines
    endfunction
let g:startify_custom_header = s:filter_header(startify#fortune#cowsay())
let g:startify_custom_footer =
       \ s:filter_header(['', "   Vim is charityware. Please read ':help uganda'.", ''])

augroup startify
  autocmd!
  autocmd User Startified setlocal cursorline
augroup END
"-2 ale ----------------------------------------------------------------------
" let g:ale_sign_error = ''
" let g:ale_sign_warning = ''
" let g:ale_statusline_format = [' %d', '%d', ' ok']
let g:ale_sign_error = '»'
let g:ale_sign_warning = '!'
let g:ale_statusline_format = ['»%d', '!%d', 'ok']
let g:ale_lint_on_save = 1 " Only run linters when i save files
let g:ale_lint_on_text_changed = 0 " Disable default behaviour
let g:ale_lint_on_enter = 0  " Dont run on file opening
highlight SignColumn guibg=NONE ctermbg=NONE ctermfg=NONE guifg=NONE
highlight ALEErrorSign guibg=NONE ctermbg=NONE guifg=#dc322f ctermfg=02
highlight ALEWarningSign guibg=NONE ctermbg=NONE guifg=#e9a226 ctermfg=01
" Navigate between errors quickly
nnoremap <silent> <C-k> <Plug>(ale_previous_wrap)
nnoremap <silent> <C-j> <Plug>(ale_next_wrap)
"=============================================================================
"-1 vim:foldmethod=marker:foldmarker="-,"==:foldlevel=0
