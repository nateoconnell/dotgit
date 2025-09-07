" Bram's recommendation for proper .vimrc start
"  see :help defaults.vim and read $VIMRUNTIME/defaults.vim
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

" ALE {{{1
" Settings for plugin 'dense-analysis/ale'
"  See ':help ale' for configuration details

" Enable completion where available.
" This setting must be set before ALE is loaded.
"
" You should not turn this setting on if you wish to use ALE as a completion
" source for other completion plugins, like Deoplete.
let g:ale_completion_enabled = 1

" Always show sign column to avoid text jitter
let g:ale_sign_column_always = 1

" Set LSP server or linter if not used by default
let g:ale_linters = {
\   'python': ['pylsp'],
\}

" Set global and file type specific fixers
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'terraform': ['terraform'],
\}
" }}}
" PLUGIN LOADING {{{1
" Packages stored in ~/.vim/pack
"  See ':help packages' and ':help plugin'
" Alternatively, use vim-plug to manage plugins
"   https://github.com/junegunn/vim-plug
call plug#begin()
Plug 'hashivim/vim-terraform', { 'for': ['hcl', 'terraform'] }
Plug 'lifepillar/vim-gruvbox8'
Plug 'dense-analysis/ale'
Plug 'preservim/nerdtree'
Plug 'gergap/vim-ollama'
call plug#end()
" }}}
" FEATURE SETTINGS {{{1 
" Yank to clipboard
if has("clipboard")
  set clipboard=unnamed " copy to the system clipboard

  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif

" WSL clip.exe incorporation
let s:clip = '/mnt/c/Windows/system32/clip.exe'
if executable(s:clip)
  augroup WSLclip
    autocmd!
    autocmd TextYankPost * call system(s:clip, @")
    " Remove trailing ^M characters after pasting from Windows clipboard
    autocmd TextChanged * silent! '[,']s/\r$//e
  augroup END
endif

" Set line numbers
set number
set relativenumber

" New lines start with same indentation as previous line
set autoindent

" Enable mouse support
set mouse=a
set ttymouse=sgr

" Enable automatic folding with {x3 markers
"  The {x3 marker is the default fold marker in vim
set foldmethod=marker

" Use termguicolors if available
if has('termguicolors')
  " see ':help xterm-true-color' for explanation
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Set appropriate text colors for dark background
set background=dark

" Set colorscheme.
colorscheme gruvbox8

" Turn off search string highlighting
set nohlsearch

" Set default whitespace preferences
set expandtab shiftwidth=2 softtabstop=2

" Text wrap related settings
set sidescroll=5

" Use ALE omnifunc. Requires 'dense-analysis/ale' plugin
set omnifunc=ale#completion#OmniFunc

" Don't open preview-window with omnifunc code completion
"set completeopt-=preview
" }}}
" STATUSLINE {{{1
"Enable statusline always with laststatus=2
set laststatus=2
set statusline=%.65f		" Path to the file, maxwid 65 characters
set statusline+=%m		" modified flag
set statusline+=\ \|\ 		" separator
set statusline+=FileType:	" label
set statusline+=%y		" filetype indicator
set statusline+=%=		" shift to right
set statusline+=Char:\          " label
set statusline+=%b\ 0x%B        " char under cursor ascii and hex value
set statusline+=\ \|\ 		" separator
set statusline+=Col:		" label
set statusline+=%c		" current column 3 char pad
set statusline+=%V		" virt column 3 char pad
set statusline+=\ \|\ 		" separator
set statusline+=Line:		" label
set statusline+=%4l\ 		" current line 4 char pad
set statusline+=of		" separator/label
set statusline+=%4L\ 		" total lines 4 char pad
set statusline+=(%p%%)		" percentage through file
" }}}
" KEY REMAPPING {{{1 
" Set mapleader and localleader keys
let mapleader = ","
let maplocalleader = ";"

" Open help tab
nnoremap <leader>ht :help<CR><C-w>T:help<Space>

" Open vimrc for editing
nnoremap <leader>ev :tabedit $MYVIMRC<CR>
inoremap <Leader>ev <Esc>:tabedit $MYVIMRC<CR>

" Source vimrc
nnoremap <leader>sv :source $MYVIMRC<CR>

" Exit insert mode
inoremap jk <Esc>

" Toggle relativenumber
inoremap <leader>rn <Esc>:set relativenumber!<CR>a
nnoremap <leader>rn :set relativenumber!<CR>

" Toggle text wrapping
inoremap <leader>wr <Esc>:set wrap!<CR>a
nnoremap <leader>wr :set wrap!<CR>

" Toggle paste mode
inoremap <leader>sp <C-O>:set paste<CR>
nnoremap <leader>sp :set paste!<CR>:set paste?<CR>

" Enable familiar new tab
noremap <leader>t <Esc>:tabnew<CR>
noremap <leader>T <Esc>:tabedit<Space>

" Tab movement
noremap gl :tabmove-<CR>
noremap gr :tabmove+<CR>
noremap g0 :tabmove0<CR>
noremap g$ :tabmove$<CR>

" Window movement
nnoremap <c-h> <c-w><c-h>
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>

" Toggle scrollbind
nnoremap <leader>sb :windo set scrollbind!<CR>
inoremap <leader>sb <Esc>:windo set scrollbind!<CR>a

" Read in today's date
noremap <leader>da :r! date +\%Y\%m\%d<CR>kddE
inoremap <leader>da <Esc>:r! date +\%Y\%m\%d<CR>kddEa

" Quick save
noremap <leader>ww :w<CR>
inoremap <leader>ww <Esc>:w<CR>a

" Enable spellcheck
noremap <leader>ss :set spell!<CR>
inoremap <Leader>ss <Esc>:set spell!<CR>a

" Enable search highlighting
noremap <leader>hl :set hlsearch!<CR>

" Show tabs and trailing spaces
set listchars=tab:>~,space:.,trail:-,eol:$,nbsp:%,precedes:<,extends:>
noremap <Leader>sl :set list!<CR>
inoremap <Leader>sl <ESC>:set list!<CR>a

" Remove all trailing whitespace
noremap <Leader>ts :%s/\s\+$//g<CR>
inoremap <Leader>ts <C-O>:%s/\s\+$//g<CR>

" Toggle highlighting of 81st column
noremap <Leader>ec :exec "set colorcolumn=" . (&colorcolumn == "" ? "81" : "")<CR>
inoremap <Leader>ec <Esc>:exec "set colorcolumn=" . (&colorcolumn == "" ? "81" : "")<CR>a

" Toggle highlighting of current column
noremap <Leader>cc :set cursorcolumn!<CR>
inoremap <Leader>cc <ESC>:set cursorcolumn!<CR>a

" Open and close location list
noremap <Leader>lo :lopen<CR>
inoremap <Leader>lo <ESC>:lopen<CR>
noremap <Leader>lc :lclose<CR>
inoremap <Leader>lc <ESC>:lclose<CR>

" Delete blank lines in selection
vnoremap <leader>db :g/^\s*$/d<CR>

" Uppercase current WORD
inoremap <leader>U <C-O>viWU<Esc>Ea
nnoremap <leader>U viWUE

" Lowercase current WORD
inoremap <leader>u <C-O>viWu<Esc>Ea
nnoremap <leader>u viWuE

" Capitalize first letter of word
inoremap <leader>f <C-O>viw<Esc><C-O>`<<Esc>l~ea
nnoremap <leader>f viw<Esc>`<~e

" Capitalize first letter of WORD
inoremap <leader>F <C-O>viW<Esc><C-O>`<<Esc>l~Ea
nnoremap <leader>F viW<Esc>`<~E

" Replace spaces with underscores in visual area and vice versa
vnoremap <leader>su :s/\%V /_/g<CR>`<
vnoremap <leader>us :s/\%V_/ /g<CR>`<

" Add quotes, parentheses, etc around word/selection
nnoremap <leader>" viw<Esc>a"<Esc>bi"<Esc>lel
vnoremap <leader>" <Esc>`<i"<Esc>`>la"<Esc>
nnoremap <leader>' viw<Esc>a'<Esc>bi'<Esc>lel
vnoremap <leader>' <Esc>`<i'<Esc>`>la'<Esc>
nnoremap <leader>` viw<Esc>a`<Esc>bi`<Esc>lel
vnoremap <leader>` <Esc>`<i`<Esc>`>la`<Esc>
nnoremap <leader>( viw<Esc>a)<Esc>bi(<Esc>lel
vnoremap <leader>( <Esc>`<i(<Esc>`>la)<Esc>
nnoremap <leader>[ viw<Esc>a]<Esc>bi[<Esc>lel
vnoremap <leader>[ <Esc>`<i[<Esc>`>la]<Esc>
nnoremap <leader>{ viw<Esc>a}<Esc>bi{<Esc>lel
vnoremap <leader>{ <Esc>`<i{<Esc>`>la}<Esc>
nnoremap <leader>< viw<Esc>a><Esc>bi<<Esc>lel
vnoremap <leader>< <Esc>`<i<<Esc>`>la><Esc>
" }}}
" NERDTree {{{1
nnoremap <Leader>nt :NERDTreeToggle<CR>
nnoremap <Leader>nm :NERDTreeMirror<CR>
nnoremap <Leader>nf :NERDTreeFind<CR>
" }}}
" FILETYPE KEYMAPPINGS {{{1 
" Enable detection of filetypes and load 'ftplugin.vim' and 'indent.vim' in
"  'runtimepath'
filetype plugin indent on

" Jump to and replace target <++>
"  Used in tag creation below
noremap <localleader><Tab> /<++><CR>"_ca<
inoremap <localleader><Tab> <Esc>/<++><CR>"_ca<
vnoremap <localleader><Tab> <Esc>/<++><CR>"_ca<

" BB CODE {{{2
" Set filetype 
noremap <localleader>bb <Esc>:set filetype=bbcode<CR>

" Group autocommands so that they are not redundantly added every time vimrc
"  is sourced
augroup bbcodegroup

" Clear all previously set autocommands in this group
au!

" Tag shortcuts: either insert fillable tag structure in insert mode, or wrap
"  selected text with tags in visual mode
autocmd FileType bbcode inoremap <buffer> <LocalLeader>i [i][/i]<Space><++><Esc>F[i
autocmd FileType bbcode vnoremap <buffer> <LocalLeader>i <Esc>`>a[/i]<Esc>`<i[i]<Esc>`>
autocmd FileType bbcode inoremap <buffer> <LocalLeader>B [b][/b]<Space><++><Esc>F[i
autocmd FileType bbcode vnoremap <buffer> <LocalLeader>B <Esc>`>a[/b]<Esc>`<i[b]<Esc>`>
autocmd FileType bbcode inoremap <buffer> <LocalLeader>u [u][/u]<Space><++><Esc>F[i
autocmd FileType bbcode vnoremap <buffer> <LocalLeader>u <Esc>`>a[/u]<Esc>`<i[u]<Esc>`>
autocmd FileType bbcode inoremap <buffer> <LocalLeader>s [s][/s]<Space><++><Esc>F[i
autocmd FileType bbcode vnoremap <buffer> <LocalLeader>s <Esc>`>a[/s]<Esc>`<i[s]<Esc>`>
autocmd FileType bbcode inoremap <buffer> <LocalLeader>- [sub][/sub]<Space><++><Esc>F[i
autocmd FileType bbcode vnoremap <buffer> <LocalLeader>- <Esc>`>a[/sub]<Esc>`<i[sub]<Esc>`>
autocmd FileType bbcode inoremap <buffer> <LocalLeader>+ [sup][/sup]<Space><++><Esc>F[i
autocmd FileType bbcode vnoremap <buffer> <LocalLeader>+ <Esc>`>a[/sup]<Esc>`<i[sup]<Esc>`>

" Declare end of autocommand group
augroup END
" }}}
" HTML {{{2
" Set filetype
noremap <localleader>ht <Esc>:set filetype=html<CR>

" Group autocommands so that they are not redundantly added every time vimrc
"  is sourced
augroup htmlgroup

" Clear all previously set autocommands in this group
au!

" Tag shortcuts: either insert fillable tag structure in insert mode, or wrap
"  selected text with tags in visual mode
autocmd FileType html inoremap <buffer> <LocalLeader>1 <h1></h1><CR><CR><++><Esc>?</h1><CR>i
autocmd FileType html vnoremap <buffer> <LocalLeader>1 <Esc>`>a</h1><Esc>`<i<h1><Esc>`>
autocmd FileType html inoremap <buffer> <LocalLeader>i <em></em><Space><++><Esc>2F<i
autocmd FileType html vnoremap <buffer> <LocalLeader>i <Esc>`>a</em><Esc>`<i<em><Esc>`>
autocmd FileType html inoremap <buffer> <LocalLeader>B <strong></strong><Space><++><Esc>2F<i
autocmd FileType html vnoremap <buffer> <LocalLeader>B <Esc>`>a</strong><Esc>`<i<strong><Esc>`>
autocmd FileType html inoremap <buffer> <LocalLeader>u <u></u><Space><++><Esc>2F<i
autocmd FileType html vnoremap <buffer> <LocalLeader>u <Esc>`>a</u><Esc>`<i<u><Esc>`>
autocmd FileType html inoremap <buffer> <LocalLeader>p <p></p><CR><CR><++><Esc>?</p><CR>i
autocmd FileType html vnoremap <buffer> <LocalLeader>p <Esc>`>a</p><Esc>`<i<p><Esc>`>

autocmd FileType html inoremap <buffer> <LocalLeader><CR> <br /><CR>

autocmd FileType html inoremap <buffer> <LocalLeader>tr <tr><CR><--><CR><BS></tr><Esc>?<--><CR>"_ca<
autocmd FileType html vnoremap <buffer> <LocalLeader>tr <Esc>`<O<tr><Esc>`>o</tr><Esc>
autocmd FileType html inoremap <buffer> <LocalLeader>th <th><CR><--><CR><BS></th><Esc>?<--><CR>"_ca<
autocmd FileType html vnoremap <buffer> <LocalLeader>th <Esc>`<O<th><Esc>`>o</th><Esc>
autocmd FileType html inoremap <buffer> <LocalLeader>td <td><CR><--><CR><BS></td><Esc>?<--><CR>"_ca<
autocmd FileType html vnoremap <buffer> <LocalLeader>td <Esc>`<O<td><Esc>`>o</td><Esc>
autocmd FileType html inoremap <buffer> <LocalLeader>dv <div><CR><--><CR><BS></div><Esc>?<--><CR>"_ca<
autocmd FileType html vnoremap <buffer> <LocalLeader>dv <Esc>`<O<div><Esc>`>o</div><Esc>
autocmd FileType html inoremap <buffer> <LocalLeader>st <style><CR><--><CR><BS></style><Esc>?<--><CR>"_ca<
autocmd FileType html vnoremap <buffer> <LocalLeader>st <Esc>`<O<style><Esc>`>o</style><Esc>
autocmd FileType html inoremap <buffer> <LocalLeader>dst <div style= <-->><CR><++><CR><BS></div><Esc>?<--><CR>"_ca<
autocmd FileType html vnoremap <buffer> <LocalLeader>dst <Esc>`<O<div style= <-->><Esc>`>o</div><CR><++><Esc>?<--><CR>"_ca<

" Declare end of autocommand group
augroup END
" }}}
" MARKDOWN {{{2
" Set filetype
noremap <localleader>md <Esc>:set filetype=markdown<CR>

" Group autocommands so that they are not redundantly added every time vimrc
"  is sourced
augroup markdowngroup

" Clear all previously set autocommands in this group
au!

" Tag shortcuts: either insert fillable tag structure in insert mode, or wrap
"  selected text with tags in visual mode
autocmd FileType markdown inoremap <buffer> <LocalLeader>n ---<CR><CR>
autocmd FileType markdown inoremap <buffer> <LocalLeader>b ****<Space><++><Esc>F*hi
autocmd FileType markdown inoremap <buffer> <LocalLeader>s ~~~~<Space><++><Esc>F~hi
autocmd FileType markdown inoremap <buffer> <LocalLeader>e **<Space><++><Esc>F*i
autocmd FileType markdown inoremap <buffer> <LocalLeader>H ====<CR><++><Esc>kO
autocmd FileType markdown inoremap <buffer> <LocalLeader>i ![](<++>)<Space><++><Esc>F[a
autocmd FileType markdown inoremap <buffer> <LocalLeader>l [](<++>)<Space><++><Esc>F[a
autocmd FileType markdown inoremap <buffer> <LocalLeader>a <a name="<+1>"></a><++><Esc>?<+1><CR>"_ca<
autocmd FileType markdown inoremap <buffer> <LocalLeader>1 #<Space><CR><++><Esc>kA
autocmd FileType markdown inoremap <buffer> <LocalLeader>2 ##<Space><CR><++><Esc>kA
autocmd FileType markdown inoremap <buffer> <LocalLeader>3 ###<Space><CR><++><Esc>kA
autocmd FileType markdown inoremap <buffer> <LocalLeader>4 ####<Space><CR><++><Esc>kA
autocmd FileType markdown inoremap <buffer> <LocalLeader>5 #####<Space><CR><++><Esc>kA
autocmd FileType markdown inoremap <buffer> <LocalLeader>6 ######<Space><CR><++><Esc>kA
autocmd FileType markdown inoremap <buffer> <LocalLeader>d --------<CR>
autocmd FileType markdown inoremap <buffer> <LocalLeader>c ``<Space><++><Esc>F`i
autocmd FileType markdown inoremap <buffer> <LocalLeader>p ```<CR>```<CR><++><Esc>?`<CR>O

" Text object customization: ih represents the text in a markdown header, or
" the text right above the ==== or ---- line
autocmd FileType markdown onoremap <buffer> ih :<C-U>execute "normal! ?^\[==\|--\]\\+$\r:nohlsearch\rkV"<CR>
" ah represents the text around a header, or same as above, but including the
"  ==== or ---- line
autocmd FileType markdown onoremap <buffer> ah :<C-U>execute "normal! ?^\[==\|--\]\\+$\r:nohlsearch\rVk"<CR>

" Declare end of autocommand group
augroup END
" }}}
" SERVICENOW {{{2
" Set filetype 
noremap <localleader>sn <Esc>:set filetype=svcnow<CR>

" Group autocommands so that they are not redundantly added every time vimrc
"  is sourced
augroup svcnowgroup

" Clear all previously set autocommands in this group
au!

" Tag shortcuts: either insert fillable tag structure in insert mode, or wrap
"  selected text with tags in visual mode
autocmd FileType svcnow inoremap <buffer> <LocalLeader>i [code]<em></em>[/code]<Space><++><Esc>?</e<CR>i
autocmd FileType svcnow vnoremap <buffer> <LocalLeader>i <Esc>`>a</em>[/code]<Esc>`<i[code]<em><Esc>`>
autocmd FileType svcnow inoremap <buffer> <LocalLeader>B [code]<strong></strong>[/code]<Space><++><Esc>?</e<CR>i
autocmd FileType svcnow vnoremap <buffer> <LocalLeader>B <Esc>`>a</strong>[/code]<Esc>`<i[code]<strong><Esc>`>
autocmd FileType svcnow inoremap <buffer> <LocalLeader>p [code]<pre><code></code></pre>[/code]<Space><++><Esc>?</c<CR>i
autocmd FileType svcnow vnoremap <buffer> <LocalLeader>p <Esc>`>a</code></pre>[/code]<Esc>`<i[code]<pre><code><Esc>`> 

" Declare end of autocommand group
augroup END
" }}}
" YAML {{{2
" Set filetype
noremap <localleader>yl <Esc>:set filetype=yaml<CR>

" Group autocommands so that they are not redundantly added every time vimrc
"  is sourced
augroup yamlgroup

" Clear all previously set autocommands in this group
au!

" Set autotabbing behavior appropriately for yaml files
autocmd FileType yaml setlocal expandtab shiftwidth=2 softtabstop=2

" Tag shortcuts: either insert fillable tag structure in insert mode, or wrap
"  selected text with tags in visual mode
autocmd FileType yaml inoremap <buffer> <LocalLeader>{ {{ <+1> }}<++><Esc>?<+1><CR>"_ca<

" Declare end of autocommand group
augroup END
" }}}
" JSON {{{2
" Set filetype
noremap <localleader>jn <Esc>:set filetype=json<CR>

" Group autocommands so that they are not redundantly added every time vimrc
"  is sourced
augroup jsongroup

" Clear all previously set autocommands in this group
au!

" Set autotabbing and fold behavior
autocmd FileType json setlocal expandtab shiftwidth=2 softtabstop=2 foldmethod=syntax foldlevel=2

" Tag shortcuts: either insert fillable tag structure in insert mode, or wrap
"  selected text with tags in visual mode
autocmd FileType json inoremap <buffer> <LocalLeader>{ {<CR><+1><CR>}<++><Esc>?<+1><CR>"_ca<
autocmd FileType json inoremap <buffer> <LocalLeader>[ [<CR><+1><CR>]<++><Esc>?<+1><CR>"_ca<
autocmd FileType json inoremap <buffer> <LocalLeader>" "<+1>": <++><Esc>?<+1><CR>"_ca<

" Declare end of autocommand group
augroup END
" }}}
" JINJA {{{2
noremap <LocalLeader>jj <Esc>:set filetype=jinja<CR>

" Group autocommands so that they are not redundantly added every time vimrc
"  is sourced
augroup jinjagroup

" Clear all previously set autocommands in this group
au!

" Set autotabbing behavior appropriately for jinja files
autocmd FileType jinja setlocal expandtab shiftwidth=4 softtabstop=4

" Tag shortcuts: either insert fillable tag structure in insert mode, or wrap
"  selected text with tags in visual mode
autocmd FileType jinja inoremap <buffer> <LocalLeader>s {% set <+1> %}<ESC>?<+1><CR>"_ca<
autocmd FileType jinja inoremap <buffer> <LocalLeader>if {% if <+1> %}<CR><++><CR>{% endif %}<CR><++><Esc>?<+1><CR>"_ca<
autocmd FileType jinja inoremap <buffer> <LocalLeader>el {% else %}<CR>
autocmd FileType jinja inoremap <buffer> <LocalLeader>ef {% elif <+1> %}<CR><++><Esc>?<+1><CR>"_ca<
autocmd FileType jinja inoremap <buffer> <LocalLeader>fo {% for <+1> %}<CR><++><CR>{% endfor %}<CR><++><Esc>?<+1><CR>"_ca<
autocmd FileType jinja inoremap <buffer> <LocalLeader>{ {{ <+1> }}<++><Esc>?<+1><CR>"_ca<

" Declare end of autocommand group
augroup END
" }}}
" RUBY {{{2
noremap <LocalLeader>rb <Esc>:set filetype=ruby<CR>
noremap <LocalLeader>er <Esc>:set filetype=eruby<CR>

" Group autocommands so that they are not redundantly added every time vimrc
"  is sourced
augroup rubygroup

" Clear all previously set autocommands in this group
au!

" Set autotabbing behavior appropriately for ruby files
autocmd FileType ruby,eruby setlocal expandtab shiftwidth=2 softtabstop=2 foldmethod=syntax foldlevel=99

" Tag shortcuts: either insert fillable tag structure in insert mode, or wrap
"  selected text with tags in visual mode
autocmd FileType ruby,eruby inoremap <buffer> <LocalLeader>de def <+1><CR>end<ESC>?<+1><CR>"_ca<
autocmd FileType ruby,eruby inoremap <buffer> <LocalLeader>cl class <+1><CR>end<ESC>?<+1><CR>"_ca<
autocmd FileType ruby,eruby inoremap <buffer> <LocalLeader>ds describe <+1> do<CR><++><CR>end<ESC>?<+1><CR>"_ca<
autocmd FileType ruby,eruby inoremap <buffer> <LocalLeader>it it <+1> do<CR><++><CR>end<ESC>?<+1><CR>"_ca<
autocmd FileType ruby,eruby inoremap <buffer> <LocalLeader>do <+1> do<CR><++><CR>end<ESC>?<+1><CR>"_ca<
autocmd FileType ruby,eruby inoremap <buffer> <LocalLeader>[ ['<+1>']<++><ESC>?<+1><CR>"_ca<
autocmd FileType ruby,eruby inoremap <buffer> <LocalLeader>( ('<+1>')<++><ESC>?<+1><CR>"_ca<
autocmd FileType ruby,eruby inoremap <buffer> <LocalLeader>cn control '<+1>' do<CR>impact 1.0<CR>title '<++>'<CR>desc '<++>'<CR><++><CR>end<ESC>?<+1><CR>"_ca<

" Declare end of autocommand group
augroup END
" }}}
" JIRA {{{2
noremap <LocalLeader>jr <Esc>:set filetype=jira<CR>

" Group autocommands so that they are not redundantly added every time vimrc
"  is sourced
augroup jiragroup

" Clear all previously set autocommands in this group
au!

" Set autotabbing behavior appropriately for ruby files
autocmd FileType jira setlocal expandtab shiftwidth=2 softtabstop=2

" Tag shortcuts: either insert fillable tag structure in insert mode, or wrap
"  selected text with tags in visual mode
autocmd FileType jira inoremap <buffer> <LocalLeader>nf {noformat}<CR><+1><CR>{noformat}<CR><++><ESC>?<+1><CR>"_ca<
autocmd FileType jira vnoremap <buffer> <LocalLeader>nf <ESC>`>o{noformat}<ESC>`<O{noformat}<ESC>`>
autocmd FileType jira inoremap <buffer> <LocalLeader>bq {quote}<CR><+1><CR>{quote}<CR><++><ESC>?<+1><CR>"_ca<
autocmd FileType jira vnoremap <buffer> <LocalLeader>bq <ESC>`>o{quote}<ESC>`<O{quote}<ESC>`>
autocmd FileType jira inoremap <buffer> <LocalLeader>nt {noformat:title=<+1>}<CR><++><CR>{noformat}<CR><++><ESC>?<+1><CR>"_ca<
autocmd FileType jira vnoremap <buffer> <LocalLeader>nt <ESC>`>o{noformat}<ESC>`<O{noformat:title=}<C-O>i
autocmd FileType jira inoremap <buffer> <LocalLeader>co {code}<CR><+1><CR>{code}<CR><++><ESC>?<+1><CR>"_ca<
autocmd FileType jira vnoremap <buffer> <LocalLeader>co <ESC>`>o{code}<ESC>`<O{code}<ESC>`>
autocmd FileType jira inoremap <buffer> <LocalLeader>ct {code:title=<+1>}<CR><++><CR>{code}<CR><++><ESC>?<+1><CR>"_ca<
autocmd FileType jira vnoremap <buffer> <LocalLeader>ct <ESC>`>o{code}<ESC>`<O{code:title=}<C-O>i
autocmd FileType jira inoremap <buffer> <LocalLeader>1 h1.<Space>
autocmd FileType jira inoremap <buffer> <LocalLeader>2 h2.<Space>
autocmd FileType jira inoremap <buffer> <LocalLeader>3 h3.<Space>
autocmd FileType jira inoremap <buffer> <LocalLeader>4 h4.<Space>
autocmd FileType jira inoremap <buffer> <LocalLeader>5 h5.<Space>
autocmd FileType jira inoremap <buffer> <LocalLeader>6 h6.<Space>
autocmd FileType jira inoremap <buffer> <LocalLeader>th \|\|\|\|<++><Esc>2F\|i
autocmd FileType jira vnoremap <buffer> <LocalLeader>th <Esc>`>a\|\|<Esc>`<i\|\|<Esc>2f\|
autocmd FileType jira inoremap <buffer> <LocalLeader>nh \|\|<++><Esc>2F\|i
autocmd FileType jira vnoremap <buffer> <LocalLeader>nh <Esc>`>a\|\|<Esc>
autocmd FileType jira inoremap <buffer> <LocalLeader>tr \|\|<++><Esc>F\|i
autocmd FileType jira vnoremap <buffer> <LocalLeader>tr <Esc>`>a\|<Esc>`<i\|<Esc>f\|
autocmd FileType jira inoremap <buffer> <LocalLeader>nr \|<++><Esc>F\|i
autocmd FileType jira vnoremap <buffer> <LocalLeader>nr <Esc>`>a\|<Esc>
autocmd FileType jira inoremap <buffer> <LocalLeader>i __<Space><++><Esc>F_i
autocmd FileType jira vnoremap <buffer> <LocalLeader>i <Esc>`>a_<Esc>`<i_<Esc>`>
autocmd FileType jira inoremap <buffer> <LocalLeader>B **<Space><++><Esc>F*i
autocmd FileType jira vnoremap <buffer> <LocalLeader>B <Esc>`>a*<Esc>`<i*<Esc>`>
autocmd FileType jira inoremap <buffer> <LocalLeader>? ????<Space><++><Esc>2F?i
autocmd FileType jira vnoremap <buffer> <LocalLeader>? <Esc>`>a??<Esc>`<i??<Esc>`>
autocmd FileType jira inoremap <buffer> <LocalLeader>u ++<Space><++><Esc>?+\s<CR>i
autocmd FileType jira vnoremap <buffer> <LocalLeader>u <Esc>`>a+<Esc>`<i+<Esc>`>
autocmd FileType jira inoremap <buffer> <LocalLeader>s --<Space><++><Esc>F-i
autocmd FileType jira vnoremap <buffer> <LocalLeader>s <Esc>`>a-<Esc>`<i-<Esc>`>
autocmd FileType jira inoremap <buffer> <LocalLeader>- ~~<Space><++><Esc>F~i
autocmd FileType jira vnoremap <buffer> <LocalLeader>- <Esc>`>a~<Esc>`<i~<Esc>`>
autocmd FileType jira inoremap <buffer> <LocalLeader>+ ^^<Space><++><Esc>F^i
autocmd FileType jira vnoremap <buffer> <LocalLeader>+ <Esc>`>a^<Esc>`<i^<Esc>`>
autocmd FileType jira inoremap <buffer> <LocalLeader>m '{{}}'<Space><++><Esc>2F}i
autocmd FileType jira vnoremap <buffer> <LocalLeader>m <Esc>`>a}}'<Esc>`<i'{{<Esc>/}}'/e<CR>
autocmd FileType jira inoremap <buffer> <LocalLeader>aa []<Space><++><Esc>F]i
autocmd FileType jira vnoremap <buffer> <LocalLeader>aa <Esc>`>a]<Esc>`<i[<Esc>`>
autocmd FileType jira inoremap <buffer> <LocalLeader>at [<C-V>u7C<Esc>a<++>]<Space><++><Esc>F[a
autocmd FileType jira vnoremap <buffer> <LocalLeader>at <Esc>`>a<C-V>u7C<Esc>a]<Space><++><Esc>`<i[<C-O>f]

" Declare end of autocommand group
augroup END
" }}}
" HCL {{{2
noremap <LocalLeader>tf <Esc>:set filetype=terraform<CR>

" Group autocommands so that they are not redundantly added every time vimrc
"  is sourced
augroup hclgroup

" Clear all previously set autocommands in this group
au!

" Set default fold behavior
autocmd FileType hcl,terraform setlocal foldmethod=syntax foldlevel=99

" Tag shortcuts: either insert fillable tag structure in insert mode, or wrap
"  selected text with tags in visual mode

" Requires 'hashivim/vim-terraform' plugin
autocmd FileType hcl,terraform noremap <buffer> <LocalLeader>ff :TerraformFmt<CR>
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>ff <C-O>:TerraformFmt<CR>

" Native vim
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>te terraform {<CR>required_version = "<+1>"<CR>required_providers {<CR><++><CR>}<CR>}<++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>rp <+1> = {<CR>source = "<++>"<CR>version = "<++>"<CR>}<++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>pr provider "<+1>" {<CR>features {<++>}<CR>}<++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>re resource "<+1>" "<++>" {<CR><++><CR>}<++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>da data "<+1>" "<++>" {<CR><++><CR>}<++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>kv <+1> = <++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>ks <+1> = "<++>"<Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>kl <+1> = ["<++>"]<Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>km <+1> = {<CR><++><CR>}<++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>bl <+1> {<CR><++><CR>}<++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>de depends_on = [<CR><+1><CR>]<Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>fo for_each = 
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>lo lookup(<+1>, "<++>", <++>)<++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform vnoremap <buffer> <LocalLeader>lo xalookup(<+1>, "<+2>", null)<Esc>?<+1><CR>"_ca<<Esc>pvT.xi<BS><ESC>/<+2><CR>"_ca<<Esc>p$
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>tr try(<+1> != null ? <++> : [], <++>)<++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform vnoremap <buffer> <LocalLeader>tr xatry(<+1> != null ? <+2> : [], <+3>)<Esc>?<+1><CR>"_ca<<Esc>p/<+2><CR>"_ca<<Esc>p/<+3><CR>"_ca<<Esc>p$
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>li lifecycle {<CR><+1><CR>}<++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>ig ignore_changes = [<CR><+1><CR>]<++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>va variable "<+1>" {<CR>description = "<++>"<CR>type = <++><CR>default = <++><CR>}<++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>hh ########################################<CR># <+1><CR><BS>#######################################<CR><++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>vl validation {<CR>condition = <+1><CR>error_message = <++><CR>}<++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>ou output "<+1>" {<CR>description = "<++>"<CR>value = <++><CR>}<++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>mo module "<+1>" {<CR>source = "<++>"<CR>}<++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>dy dynamic "<+1>" {<CR>for_each = <++><CR>iterator = <++><CR>content {<CR><++><CR>}<CR>}<++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>iv <Esc>yiwea = ITER.value.<Esc>pa
autocmd FileType hcl,terraform vnoremap <buffer> <LocalLeader>iv yea = ITER.value.<Esc>p

" Declare end of autocommand group
augroup END
" }}}
" GO {{{2
" Set filetype
noremap <localleader>go <Esc>:set filetype=go<CR>

" Group autocommands so that they are not redundantly added every time vimrc
"  is sourced
augroup gogroup

" Clear all previously set autocommands in this group
au!

" Set autotabbing behavior appropriately for go files
autocmd FileType go setlocal foldmethod=syntax foldlevel=99 noexpandtab shiftwidth=0 softtabstop=0

" Tag shortcuts: either insert fillable tag structure in insert mode, or wrap
"  selected text with tags in visual mode

" Requires fatih/vim-go plugin
"autocmd FileType go noremap <buffer> <LocalLeader>ff :GoFmt<CR>
"autocmd FileType go inoremap <buffer> <LocalLeader>ff <C-O>:GoFmt<CR>

" Native vim
autocmd FileType go inoremap <buffer> <LocalLeader>fu func <+1> {<CR><++><CR>}<++><Esc>?<+1><CR>"_ca<

" Declare end of autocommand group
augroup END
" }}}
" PYTHON {{{2
" Set filetype
noremap <localleader>py <Esc>:set filetype=python<CR>

" Group autocommands so that they are not redundantly added every time vimrc
"  is sourced
augroup pythongroup

" Clear all previously set autocommands in this group
au!

" Set autotabbing behavior appropriately for python files
autocmd FileType python setlocal foldmethod=syntax foldlevel=99 shiftwidth=4 softtabstop=4

" Tag shortcuts: either insert fillable tag structure in insert mode, or wrap
"  selected text with tags in visual mode
autocmd FileType python noremap <buffer> <LocalLeader>de idef <+1>:<Esc>?<+1><CR>"_ca<
autocmd FileType python inoremap <buffer> <LocalLeader>de def <+1>:<Esc>?<+1><CR>"_ca<

" Declare end of autocommand group
augroup END
" }}}
" }}}
" ABBREVIATIONS {{{1 
" Use the <C-K> digraph functionality to insert the { and } characters without
"  actually creating the folds in this file: <C-K> (! = { and <C-K> !) = } in
"  insert mode
iabbrev z1 {{<C-K>(!1<--><CR>}}<C-K>!)<Esc>?<--<CR>"_ca<
iabbrev z2 {{<C-K>(!2<--><CR>}}<C-K>!)<Esc>?<--<CR>"_ca<
iabbrev z3 {{<C-K>(!3<--><CR>}}<C-K>!)<Esc>?<--<CR>"_ca<
" Not abbreviations, but related to creating folds. Wrap visually selected
"  text with fold markers.
vnoremap ,z1 <Esc>`>a<CR><C-K>!)}}<Esc>`<O <C-K>(!{{1<Esc>0i
vnoremap ,z2 <Esc>`>a<CR><C-K>!)}}<Esc>`<O <C-K>(!{{2<Esc>0i
vnoremap ,z3 <Esc>`>a<CR><C-K>!)}}<Esc>`<O <C-K>(!{{3<Esc>0i

" Insert fold and date
iabbrev lda <Esc>:r!date +\%Y\%m\%d<CR>kddA <C-K>(!{{1<1-><CR><C-K>!)}}<Esc>?<1-><CR>"_ca<
iabbrev sda <Esc>:r!date +\%Y\%m\%d<CR>kddA <C-K>(!{{2<1-><CR><C-K>!)}}<Esc>?<1-><CR>"_ca<

" Bash script start
iabbrev bscr #!/usr/bin/env bash<CR><CR># exit on errors, exit if unset variable encountered, propagate error exit<CR>#  status through pipes<CR>set -o errexit -o nounset -o pipefail<CR>

" Section separators
iabbrev [. [...]
iabbrev 4- ————————————————————————————————————————
iabbrev 8- ————————————————————————————————————————————————————————————————————————————————
iabbrev 4= ========================================
iabbrev 8= ================================================================================
iabbrev 4# ########################################
iabbrev 8# ################################################################################
iabbrev 4. ........................................
iabbrev 8. ................................................................................
" }}}
