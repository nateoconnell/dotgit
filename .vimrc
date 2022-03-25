" Bram's recommendation for proper .vimrc start
"  see :help defaults.vim and read $VIMRUNTIME/defaults.vim
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

" PLUGIN LOADING {{{1
" Import vim bundles
"  https://github.com/tpope/vim-pathogen
"execute pathogen#infect()
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
  augroup END
endif

" Save a loaded session automatically on exit
"augroup save_session
"  autocmd!
"  if !empty(v:this_session)
"    autocmd VimLeavePre * execute "mksession! " .. v:this_session
"  endif
"augroup END

" Set line numbers
set number
set relativenumber

" New lines start with same indentation as previous line
set autoindent

" Enable automatic folding with {x3 markers
"  The {x3 marker is the default fold marker in vim
set foldmethod=marker

" Set appropriate text colors for dark background
set background=dark

" Turn off search string highlighting
set nohlsearch

" Set default whitespace preferences
set expandtab shiftwidth=2 softtabstop=2

" Text wrap related settings
set sidescroll=5
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
" TABLINE {{{1
set tabline=%!MyTabLine()
function MyTabLine()
  let s = '' " complete tabline goes here
  " loop through each tab page
  for t in range(tabpagenr('$'))
    " select the highlighting for the buffer names
    if t + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    " empty space
    let s .= ' '
    " set the tab page number (for mouse clicks)
    let s .= '%' . (t + 1) . 'T'
    " set page number string
    let s .= t + 1 . ' '
    " get buffer names and statuses
    let n = ''  "temp string for buffer names while we loop and check buftype
    let m = 0 " &modified counter
    let bc = len(tabpagebuflist(t + 1))  "counter to avoid last ' '
    " loop through each buffer in a tab
    for b in tabpagebuflist(t + 1)
      " buffer types: quickfix gets a [Q], help gets [H]{base fname}
      " others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
      if getbufvar( b, "&buftype" ) == 'help'
        let n .= '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )
      elseif getbufvar( b, "&buftype" ) == 'quickfix'
        let n .= '[Q]'
      else
        let n .= pathshorten(bufname(b))
      endif
      " check and ++ tab's &modified count
      if getbufvar( b, "&modified" )
        let m += 1
      endif
      " no final ' ' added...formatting looks better done later
      if bc > 1
        let n .= ' '
      endif
      let bc -= 1
    endfor
    " add modified label [n+] where n pages in tab are modified
    if m > 0
      let s.= '+ '
    endif
    " add buffer names
    if n == ''
      let s .= '[No Name]'
    else
      let s .= n
    endif
    " switch to no underlining and add final space to buffer list
    let s .= ' '
  endfor
  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'
  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999XX'
  endif
  return s
endfunction
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

" Toggle scrollbind
nnoremap <leader>sb :windo set scrollbind!<CR>
inoremap <leader>sb <Esc>:windo set scrollbind!<CR>a

" Read in today's date
noremap <Leader>da :r! date +\%Y\%m\%d<CR>kddE
inoremap <Leader>da <Esc>:r! date +\%Y\%m\%d<CR>kddEa

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
autocmd FileType markdown inoremap <buffer> <LocalLeader>a [](<++>)<Space><++><Esc>F[a
autocmd FileType markdown inoremap <buffer> <LocalLeader>1 #<Space><CR><++><Esc>kA
autocmd FileType markdown inoremap <buffer> <LocalLeader>2 ##<Space><CR><++><Esc>kA
autocmd FileType markdown inoremap <buffer> <LocalLeader>3 ###<Space><CR><++><Esc>kA
autocmd FileType markdown inoremap <buffer> <LocalLeader>4 ####<Space><CR><++><Esc>kA
autocmd FileType markdown inoremap <buffer> <LocalLeader>5 #####<Space><CR><++><Esc>kA
autocmd FileType markdown inoremap <buffer> <LocalLeader>6 ######<Space><CR><++><Esc>kA
autocmd FileType markdown inoremap <buffer> <LocalLeader>l --------<CR>
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
autocmd FileType jira inoremap <buffer> <LocalLeader>tr \|\|<++><Esc>F\|i
autocmd FileType jira vnoremap <buffer> <LocalLeader>tr <Esc>`>a\|<Esc>`<i\|<Esc>f\|
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
" Group autocommands so that they are not redundantly added every time vimrc
"  is sourced
augroup hclgroup

" Clear all previously set autocommands in this group
au!

" Set default fold behavior
autocmd FileType hcl,terraform setlocal foldmethod=syntax foldlevel=99

" Tag shortcuts: either insert fillable tag structure in insert mode, or wrap
"  selected text with tags in visual mode
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>te terraform {<CR>required_version = "<+1>"<CR>required_providers {<CR><++><CR>}<CR>}<++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>rp "<+1>" = {<CR>source = "<++>"<CR>version = "<++>"<CR>}<++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>pr provider "<+1>" {<CR>features {<++>}<CR>}<++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>re resource "<+1>" "<++>" {<CR><++><CR>}<++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>kv <+1> = <++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>ks <+1> = "<++>"<Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>kl <+1> = ["<++>"]<Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>km <+1> = {<CR><++><CR>}<++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>bl <+1> {<CR><++><CR>}<++><Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>de depends_on = [<CR><+1><CR>]<Esc>?<+1><CR>"_ca<
autocmd FileType hcl,terraform inoremap <buffer> <LocalLeader>fo for_each = {<CR><+1><CR>}<++><Esc>?<+1><CR>"_ca<

" Declare end of autocommand group
augroup END
" }}}
" }}}
" ABBREVIATIONS {{{1 
iabbrev sig Thank you,<CR>Nate O'Connell<CR>Automation Engineer
iabbrev nsig [1]. <++><CR><CR><CR>Thank you,<CR>Nate O'Connell<CR>Automation Engineer<CR><CR><CR>[1]

" Use the <C-K> digraph functionality to insert the { and } characters without
"  actually creating the folds in this file: <C-K> (! = { and <C-K> !) = } in
"  insert mode
iabbrev z1 <++> {{<C-K>(!1<--><CR>}}<C-K>!)<CR><Esc>?<--<CR>"_ca<
iabbrev z2 <++> {{<C-K>(!2<--><CR>}}<C-K>!)<CR><Esc>?<--<CR>"_ca<
iabbrev z3 <++> {{<C-K>(!3<--><CR>}}<C-K>!)<CR><Esc>?<--<CR>"_ca<
" Not abbreviations, but related to creating folds. Wrap visually selected
"  text with fold markers.
vnoremap ,z1 <Esc>`>a<CR><C-K>!)}}<Esc>`<O <C-K>(!{{1<Esc>0i
vnoremap ,z2 <Esc>`>a<CR><C-K>!)}}<Esc>`<O <C-K>(!{{2<Esc>0i
vnoremap ,z3 <Esc>`>a<CR><C-K>!)}}<Esc>`<O <C-K>(!{{3<Esc>0i

" Insert fold and date
iabbrev lda <Esc>:r!date +\%Y\%m\%d<CR>kddA <C-K>(!{{1<1-><CR><C-K>!)}}<Esc>?<1-><CR>"_ca<
iabbrev sda <Esc>:r!date +\%Y\%m\%d<CR>kddA <C-K>(!{{2<1-><CR><C-K>!)}}<Esc>?<1-><CR>"_ca<

" Bash script start
iabbrev bsc #!/usr/bin/env bash<CR><CR># exit on errors, exit if unset variable encountered, propagate error exit<CR>#  status through pipes<CR>set -o errexit -o nounset -o pipefail<CR>

" Section separators
iabbrev [. [...]
iabbrev 4- ————————————————————————————————————————
iabbrev 8- ————————————————————————————————————————————————————————————————————————————————
iabbrev 4= ========================================
iabbrev 8= ================================================================================
iabbrev 4. ........................................
iabbrev 8. ................................................................................
" }}}
