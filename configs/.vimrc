" Vundle vim package manager:
set nocompatible

filetype off

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

Plugin 'scrooloose/nerdtree'
Plugin 'ryanoasis/vim-devicons'

Plugin 'majutsushi/tagbar'
Plugin 'jakedouglas/exuberant-ctags'

" https://draculatheme.com/vim/
Plugin 'dracula/vim'
call vundle#end()

filetype plugin indent on

" Tabs:
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set textwidth=100

" line numbers
set number
:nmap <C-L> :set invnumber<CR>

" Theme:
colorscheme dracula

" NOT SURE WHAT THESE DO....
set wildmenu
set ruler

" highlight the current line
set cursorline

" highlight and ignocre case on search
set ignorecase
set hlsearch

" show matching brackets
set showmatch

" enable syntax highlighting
syntax enable

" enable 256 colors palette in gnome terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

" always show the status line
set laststatus=2
set cmdheight=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" map nerdtree and tagbar
map <C-n> :NERDTreeToggle<CR>
map <C-m> :TagbarToggle<CR>
