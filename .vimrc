" 
" .vimrc
"

" history

set history=500

" fast save
nmap <leader>w :w!<cr>

" text settings

set nocompatible
set autoread
set noerrorbells
set novisualbell
set autoindent
set t_vb=
set tm=500

" swap files

set noswapfile
set nobackup
set nowb

" color scheme preference = solarized
syntax enable
set background=dark
set t_Co=16
let g:solarized_termcolors=256
colorscheme solarized

" tabs
set tabstop=4

" opens vim exactly where left off 
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" -- syntax settings 
" ---------------------------------------------------

" prolog
autocmd BufRead,BufNewFile *.pl set filetype=prolog
autocmd BufRead,BufNewFile *.pl set syntax=prolog.vim

" markdown
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile *.markdown set filetype=markdown

" sbt
autocmd BufRead,BufNewFile *.sbt set filetype=sbt
autocmd BufRead,BufNewFile *.sbt set syntax=sbt

" mips
autocmd BufRead,BufNewFile *.s set filetype=mips
autocmd BufRead,BufNewFile *.s set syntax=mips.vim

" for latex (specifically mactex) 
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_MultipleCompileFormats='pdf,dvi'
let g:Tex_CompileRule_pdf = 'mkdir -p tmp; pdflatex -output-directory tmp -interaction=nonstopmode $*; cp tmp/*.pdf .'
