" Custom neovim init config
let mapleader =","

" Check if minimalist vim plugin manager is installed
if !filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
    echo "Downloading junegunn/vim-plug to manage plugins..."
    silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
    silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
    autocmd VimEnter * PlugInstall
endif

" Jump to the next placeholder in the doc
map ,, :keepp /<++><CR>ca<
imap ,, <esc>:keepp /<++><CR>ca<

" Start plugin management section
call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'tpope/vim-surround' "Easy add parentheses, quotes and tags like cs'', ds'', ysiw''
Plug 'preservim/nerdtree' "File system explorer
Plug 'junegunn/goyo.vim' "Distraction free, hides UI elements
Plug 'jreybert/vimagit' "Git interaction
Plug 'vimwiki/vimwiki' "Personal wiki system inside nvim
Plug 'vim-airline/vim-airline' "Enhance statusline
Plug 'tpope/vim-commentary' "Simplifies commenting lines using gc command
Plug 'ap/vim-css-color' "Highlight CSS code in colors
Plug 'morhetz/gruvbox'            " Gruvbox color scheme plugin
Plug 'vim-airline/vim-airline-themes'  " Airline Gruvbox theme for the status line
Plug 'MeanderingProgrammer/render-markdown.nvim' "Markdown render
Plug 'nvim-tree/nvim-web-devicons' "Developer icons
call plug#end()

" Set window title with the name of the current file
set title
" Set light background, useful for dark text
set bg=dark
" Set Gruvbox color scheme
colorscheme gruvbox

" Enable Gruvbox Airline theme
let g:airline_theme='gruvbox'

" Jump code blocks
" set go=a
" Use mouse for all modes
set mouse=a
" Disable highlighting of search results
set nohlsearch
" Use system clipboard
set clipboard+=unnamedplus
" Hide INSERT or VISUAL mode banner
set noshowmode
" Hide ruler, cursor position
set noruler
" Hide status bar
set laststatus=0
" Hide display text of the command
set noshowcmd
" Set semitransparent cursor line
set cursorline


" Some basics:
nnoremap c "_c
filetype plugin on
syntax on
set encoding=utf-8
set number relativenumber

" Enable autocompletion
set wildmode=longest,list,full
" Disables automatic commenting on newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Perform dot commands over visual blocks
vnoremap . :normal .<CR>
" Goyo plugin makes text more readable when writing prose
map <leader>f :Goyo \| set bg=light \| set linebreak<CR>
" Spell-check set to <leader>o, 'o' for 'orthography'
map <leader>o :setlocal spell! spelllang=es<CR>
" Splits open at the bottom and right, which is non-retarded, unlike vim defaults
set splitbelow splitright

" Nerd tree
map <leader>n :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'

" vim-airline
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.colnr = ' C:'
let g:airline_symbols.linenr = ' L:'
let g:airline_symbols.maxlinenr = '☰ '

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Replace ex mode with gq
map Q gq

" Check file in shellcheck
map <leader>s :!clear && shellcheck -x %<CR>

" Replace all is aliased to S
nnoremap S :%s//g<Left><Left>

" Compile document, be it groff/LaTeX/markdown/etc.
map <leader>c :w! \| !compiler "%:p"<CR>

" Open corresponding .pdf/.html or preview
map <leader>p :!opout "%:p"<CR>

" Runs a script that cleans out tex build files whenever I close out of a .tex file
autocmd VimLeave *.tex !texclear %

" Ensure files are read as what I want:
let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
map <leader>v :VimwikiIndex<CR>
let g:vimwiki_list = [{'path': '~/.local/share/nvim/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
autocmd BufRead,BufNewFile *.tex set filetype=tex

" Save file as sudo on files that require root permission
"cabbrev w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!


" Automatically deletes all trailing whitespace and newlines at end of file on save. & reset cursor position
autocmd BufWritePre * let currPos = getpos(".")
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e
autocmd BufWritePre *.[ch] %s/\%$/\r/e " add trailing newline for ANSI C standard
autocmd BufWritePre *neomutt* %s/^--$/-- /e " dash-dash-space signature delimiter in emails
autocmd BufWritePre * cal cursor(currPos[1], currPos[2])

" When shortcut files are updated, renew bash and lf configs with new material:
autocmd BufWritePost bm-files,bm-dirs !shortcuts

" Run xrdb whenever Xdefaults or Xresources are updated.
autocmd BufRead,BufNewFile Xresources,Xdefaults,xresources,xdefaults set filetype=xdefaults
autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %

" Recompile dwmblocks on config edit (removed for Qtile)
" No need for any compilation, but you may want to trigger Qtile reload instead.
" Example: Triggering Qtile's reconfiguration from Neovim
autocmd BufWritePost ~/.config/qtile/config.py !qtile cmd restart

" Turns off highlighting on the bits of code that are changed
if &diff
    highlight! link DiffText MatchParen
endif

" Function for toggling the bottom status bar
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction
nnoremap <leader>h :call ToggleHiddenAll()<CR>

" Load command shortcuts generated from bm-dirs and bm-files via shortcuts script.
" Here leader is ";".
" So ":vs ;cfz" will expand into ":vs /home/<user>/.config/zsh/.zshrc"
" if typed fast without the timeout.
silent! source ~/.config/nvim/shortcuts.vim
