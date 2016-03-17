" lichee vimrc
"
" Maintainer:   lichee <licheebrick@163.com>
" Last change:  2016 Feb. 17

" ================ Important ================

set nocompatible

" ================ General Settings ================

"  epsilons
set backspace=indent,eol,start 
set confirm
set history=500
set ruler
set showcmd
set incsearch
set number
set cmdheight=2

set guifont=Menlo:h14

"  backup
if has("vms")   "about backup files
  set nobackup
else
  set backup
endif

"  smart Ctrl-U
inoremap <C-U> <C-G>u<C-U>   

"  mouse
if has('mouse')
  set mouse=a
endif

"  start filetype detection
filetype plugin indent on

"  hilight
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  set cul
  set go=
endif

"  Default Indent  
set smartindent
set autoindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" line breaking
set iskeyword+=_,$,@,%,#,-

" backup
set backupdir=~/.vim/tmp
set directory=~/.vim/tmp

" ================ Solarized ==============
syntax enable
colorscheme peachpuff
" ================ Chinese Encoding ===================

set fileencoding=utf-8
set fileencodings=utf-8,gb18030,utf-16,big5

set noimdisable
autocmd! InsertLeave * set imdisable|set iminsert=0
autocmd! InsertEnter * set noimdisable|set iminsert=0

" ================ Some abbr ================
abbr ==== =======================================
abbr ---- ---------------------------------------
abbr &&&& &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
abbr #### #######################################

" ================ New File Settings ================

autocmd BufNewFile *.c,*.h,*.cpp,*.[ch],*.sh,*.py exec ":call SetHeadInfo()"

func SetHeadInfo()
endfunc

" locate at end of file
autocmd BufNewFile * normal G

" ================ Indent Settings ================ 

autocmd BufNewFile * exec ":call SetIndent()"
autocmd BufRead * exec ":call SetIndent()"

func SetIndent()
	if &filetype == "make"
		set noexpandtab
	else
		set expandtab
	endif
endfunc

" ================ Paste ================ 

map<F10> <esc>:call Paste()<cr>
imap<F10> <esc>:call Paste()<cr>
vmap<F10> <esc>:call Paste()<cr>

function! Paste()
	set nosmartindent
	set noautoindent
	normal "+p
	set smartindent
	set noautoindent
endfunc

" ================ Debug && Compile && Run ================
" ! This part is copied from github.com/Azure-vani/runtime/.vimrc.d/ide.vim

function! Compile()
	exec "w"
	if &filetype == "cpp"
		exec "!g++ -g -o %< % -Wall"
	endif
	if &filetype == "c"
		exec "!gcc -g -o %< % -Wall"
	endif
	if &filetype == "pascal"
		exec "!fpc -g %"
	endif
	if &filetype == "tex" || &filetype == "plaintex" || &filetype == "context"
		exec "!xelatex %"
	endif
	if &filetype == "java"
		exec "!javac %"
	endif
	if &filetype == "dot"
		exec "!dot -o%<.ps -Tps %"
	endif
	if &filetype == "haskell"
		exec "!ghc --make -o %< %"
	endif
endfunc

function! Run()
	exec "w"
	if &filetype == "cpp" || &filetype == "pascal" || &filetype == "c" || &filetype == "haskell"
		exec "!./%<"
	endif
	if &filetype == "python"
		exec "!python %"
	endif
	if &filetype == "sh"
		exec "!bash %"
	endif
	if &filetype == "tex" || &filetype == "plaintex" || &filetype == "context"
		exec "!evince %<.pdf"
	endif
	if &filetype == "html"
		exec "!google-chrome %"
	endif
	if &filetype == "ruby"
		exec "!ruby %"
	endif
	if &filetype == "java"
		exec "!java %<"
	endif
	if &filetype == "dot"
		exec "!evince %<.ps"
	endif
endfunc

function! Debug()
	exec "w"
	if &filetype == "cpp" || &filetype == "pascal" || &filetype == "c"
		exec "!gdb %<"
	endif
	if &filetype == "python"
		exec "!python2 -m pdb %"
	endif
	if &filetype == "ruby"
		exec "!ruby -r debug %"
	endif
endfunc

imap<F5> <esc>:call Debug()<cr>
map<F5> <esc>:call Debug()<cr>
vmap<F5> <esc>:call Debug()<cr>

imap<C-F9> <esc>:call Run()<cr>
map<C-F9> <esc>:call Run()<cr>
vmap<C-F9> <esc>:call Run()<cr>

imap<F9> <esc>:call Compile()<cr>
map<F9> <esc>:call Compile()<cr>
vmap<F9> <esc>:call Compile()<cr>


if(has("win32") || has("win95") || has("win64") || has("win16"))
    let g:vimrc_iswindows=1
else
    let g:vimrc_iswindows=0
endif
autocmd BufEnter * lcd %:p:h


map <F12> :call Do_CsTag()<CR>
nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>:copen<CR>
nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:copen<CR>
nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>:copen<CR>
function Do_CsTag()
    let dir = getcwd()
    if filereadable("tags")
        if(g:iswindows==1)
            let tagsdeleted=delete(dir."\\"."tags")
        else
            let tagsdeleted=delete("./"."tags")
        endif
        if(tagsdeleted!=0)
            echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
            return
        endif
    endif
    if has("cscope")
        silent! execute "cs kill -1"
    endif
    if filereadable("cscope.files")
        if(g:iswindows==1)
            let csfilesdeleted=delete(dir."\\"."cscope.files")
        else
            let csfilesdeleted=delete("./"."cscope.files")
        endif
        if(csfilesdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
            return
        endif
    endif
    if filereadable("cscope.out")
        if(g:iswindows==1)
            let csoutdeleted=delete(dir."\\"."cscope.out")
        else
            let csoutdeleted=delete("./"."cscope.out")
        endif
        if(csoutdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
            return
        endif
    endif
    if(executable('ctags'))
        "silent!
        ""execute
        ""!ctags
        -R --c-types=+p --fields=+S *"
        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    endif
    if(executable('cscope') && has("cscope") )
        if(g:iswindows!=1)
            silent! execute "!find . -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' -o -name '*.cs' > cscope.files"
        else
            silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
        endif
        silent! execute "!cscope -b"
        execute "normal :"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
endfunction
