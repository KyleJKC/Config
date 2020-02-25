" _   _         __     _____ __  __
"| \ | | ___  __\ \   / /_ _|  \/  |
"|  \| |/ _ \/ _ \ \ / / | || |\/| |
"| |\  |  __/ (_) \ V /  | || |  | |
"|_| \_|\___|\___/ \_/  |___|_|  |_|

"编辑器设置

if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !git clone https://gitee.com/kylejkc/Vim-Plug.git ~/.vim/autoload
	autocmd VimEnter * PlugInstall --sync | source ~/.config/nvim/init.vim
endif

"------------

"综合设置

set number
set relativenumber
set scrolloff=5

"添加鼠标操控
set mouse=a
"将Leader键设置为空格
let mapleader=" "
let g:mapleader=" "


"上下左右移动
noremap w k
noremap s j
noremap a h
noremap d l 
noremap <C-w> kkkk
noremap <C-s> jjjj
noremap rr gg
noremap R G
"新建，保存与退出
noremap <LEADER>sq :wq<CR>
noremap Q :q<CR>
noremap S :w<CR>
noremap <LEADER>qa :qa<CR>
noremap <C-q> :qa<CR>
noremap <LEADER>rc :e ~/.config/nvim/init.vim<CR>
noremap <LEADER>si :source ~/.config/nvim/init.vim<CR>
noremap <LEADER>pi :PlugInstall<CR>
noremap <LEADER>pu :PlugUpdate<CR>
noremap <LEADER>n :new<CR>
"编辑操作
noremap e i
noremap c d
map <LEADER>sc :set spell!<CR>
"输入法切换配置
let g:input_toggle = 0
function! Fcitx2en()
let s:input_status = system("fcitx-remote")
if s:input_status == 2
let g:input_toggle = 1
let l:a = system("fcitx-remote -c")
endif
endfunction

function! Fcitx2zh()
let s:input_status = system("fcitx-remote")
if s:input_status != 2 && g:input_toggle == 1
let l:a = system("fcitx-remote -o")
let g:input_toggle = 0
endif
endfunction

autocmd InsertLeave * call Fcitx2en()
autocmd InsertEnter * call Fcitx2zh()

"------------

"语言配置

"运行语言脚本
noremap l :call CompileRunGcc()<CR>
func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'cpp'
		set splitbelow
		:sp 
                exec "!g++ -std=c++11 % -Wall -o %<"
		:term ./%<
	elseif &filetype == 'java'
		exec "!javac %"
		exec "!time java %<"
	elseif &filetype == 'sh'
		:!time bash %
	elseif &filetype == 'python'
		set splitbelow
		:sp
		:term python3 %
	elseif &filetype == 'html'
		silent! exec "!".g:mkdp_browser." % &"
	elseif &filetype == 'markdown'
		exec "MarkdownPreview"
	elseif &filetype == 'tex'
		silent! exec "VimtexStop"
		silent! exec "VimtexCompile"
	elseif &filetype == 'dart'
		CocCommand flutter.run
	elseif &filetype == 'go'
		set splitbelow
		:sp
		:term go run %
	endif
endfunc

"当创建C++文件时，自动生成配置

autocmd BufNewFile *.cpp exec ":call SetTitle()"
func SetTitle()
if expand("%:e") == "cpp" 
         call setline(1,"/*")
         call setline(2,"*******************************************************************")
         call setline(3,"Author:                KyleJKC")
         call setline(4,"Date:                  ".strftime("%Y-%m-%d"))
         call setline(5,"FileName：             ".expand("%"))
         call setline(6,"Copyright (C):         ".strftime("%Y")." All rights reserved")
         call setline(7,"********************************************************************")
         call setline(8,"*/")
         call setline(9,"#include<iostream>")
         call setline(10,"")
         call setline(11,"int main(int argc, const char *argv[]){")
         call setline(12,"")
         call setline(13,"  return0;")
         call setline(14,"}")
endif
endfunc
autocmd BufNewFile * normal G'

"------------

"功能插件设置

"Coc补全设置
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

"Changes设置
let g:changes_autocmd=1
let g:changes_use_icons = 0
" let g:changes_respect_SignColumn = 1
let g:changes_sign_text_utf8 = 1

" let g:changes_linehi_diff = 1
" hi ChangesSignTextAdd ctermbg=yellow ctermfg=black guibg=green
" hi ChangesSignTextDel ctermbg=white  ctermfg=black guibg=red
" hi ChangesSignTextCh  ctermbg=black  ctermfg=white guibg=blue

"NeoFormat设置
map <LEADER>fm :Neoformat<CR>
"FZF模糊搜索设置
" 调用 Rg 进行搜索，包含隐藏文件
" 此命令依赖 ripgrep，ripgrep 安装请参照 https://github.com/BurntSushi/ripgrep
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
 
" 在当前目录搜索文件
nnoremap <Leader>f :Files<CR>
" 切换 Buffer
nnoremap <Leader>b :Buffers<CR>
" 在当前所有加载的 Buffer 中搜索包含目标词的所有行
nnoremap <Leader>l :Lines<CR>
" 在当前 Buffer 中搜索包含目标词的所有行
nnoremap <Leader>bl :BLines<CR>
" 在 Vim 打开的历史文件中搜索，相当于是在 MRU 中搜索
nnoremap <Leader>h :History<CR>

"MarkdownPreview设置
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1
let g:mkdp_refresh_slow = 0
let g:mkdp_command_for_global = 0
let g:mkdp_open_to_the_world = 0
let g:mkdp_open_ip = ''
let g:mkdp_browser = 'chromium'
let g:mkdp_echo_preview_url = 0
let g:mkdp_browserfunc = ''
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {}
    \ }
let g:mkdp_markdown_css = ''
let g:mkdp_highlight_css = ''
let g:mkdp_port = ''
let g:mkdp_page_title = '「${name}」'
autocmd Filetype markdown inoremap <buffer> ,f <Esc>/<++><CR>:nohlsearch<CR>"_c4l
autocmd Filetype markdown inoremap <buffer> ,w <Esc>/ <++><CR>:nohlsearch<CR>"_c5l<CR>
autocmd Filetype markdown inoremap <buffer> ,n ---<Enter><Enter>
autocmd Filetype markdown inoremap <buffer> ,b **** <++><Esc>F*hi
autocmd Filetype markdown inoremap <buffer> ,s ~~~~ <++><Esc>F~hi
autocmd Filetype markdown inoremap <buffer> ,i ** <++><Esc>F*i
autocmd Filetype markdown inoremap <buffer> ,d `` <++><Esc>F`i
autocmd Filetype markdown inoremap <buffer> ,c ```<Enter><++><Enter>```<Enter><Enter><++><Esc>4kA
autocmd Filetype markdown inoremap <buffer> ,m - [ ] <Enter><++><ESC>kA
autocmd Filetype markdown inoremap <buffer> ,p ![](<++>) <++><Esc>F[a
autocmd Filetype markdown inoremap <buffer> ,a [](<++>) <++><Esc>F[a
autocmd Filetype markdown inoremap <buffer> ,1 #<Space><Enter><++><Esc>kA
autocmd Filetype markdown inoremap <buffer> ,2 ##<Space><Enter><++><Esc>kA
autocmd Filetype markdown inoremap <buffer> ,3 ###<Space><Enter><++><Esc>kA
autocmd Filetype markdown inoremap <buffer> ,4 ####<Space><Enter><++><Esc>kA
autocmd Filetype markdown inoremap <buffer> ,l --------<Enter>

"NerdTree设置
let NERDTreeHighlightCursorline = 1       " 高亮当前行
let NERDTreeShowLineNumbers     = 1       " 显示行号
let NERDTreeShowHidden          = 1
" 忽略列表中的文件
let NERDTreeIgnore = [ '\.pyc$', '\.pyo$', '\.obj$', '\.o$', '\.egg$', '^\.git$', '^\.repo$', '^\.svn$', '^\.hg$' ]
" 启动 vim 时打开 NERDTree
"autocmd vimenter * NERDTree
" 当打开 VIM，没有指定文件时和打开一个目录时，打开 NERDTree
"autocmd StdinReadPre * let s:std_in = 1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
" 关闭 NERDTree，当没有文件打开的时候
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | end
 
" <leader>nt 打开 nerdtree 窗口，在左侧栏显示
map <leader>nt :NERDTreeToggle<CR>
" <leader>tc 关闭当前的 tab
map <leader>tc :tabc<CR>
" <leader>to 关闭所有其他的 tab
map <leader>to :tabo<CR>
" <leader>ts 查看所有打开的 tab
map <leader>ts :tabs<CR>
" <leader>tp 前一个 tab
map <leader>tp :tabp<CR>
" <leader>tn 后一个 tab
map <leader>tn :tabn<CR>

"Vim-go设置
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

"NerdCommenter设置
let g:NERDSpaceDelims            = 1                                    " 在注释符号后加一个空格
let g:NERDCompactSexyComs        = 1                                    " 紧凑排布多行注释
let g:NERDDefaultAlign           = 'left'                               " 逐行注释左对齐
let g:NERDAltDelims_java         = 1                                    " JAVA 语言使用默认的注释符号
let g:NERDCustomDelimiters       = {'c': {'left': '/*', 'right': '*/'}} " C 语言注释符号
let g:NERDCommentEmptyLines      = 1                                    " 允许空行注释
let g:NERDTrimTrailingWhitespace = 1                                    " 取消注释时删除行尾空格
let g:NERDToggleCheckAllLines    = 1                                    " 检查选中的行操作是否成功

"vim-cpp-enhanced-highlight设置
let g:cpp_class_scope_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_simple_template_highlight = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1

"auto-pairs设置
let g:AutoPairs = {',':' ','(':')', '[':']', '{':'}',"'":"'",'"':'"', "`":"`", '```':'```', '"""':'"""', "'''":"'''"} 

"Nerd-Tree设置
nmap <F2> :NERDTreeToggle<CR>

"------------

"美化插件设置

"Starify设置
let g:startify_custom_header = [
\' _   _           __   __                 ____            _', 
\'| | | |___  ___  \ \ / /__  _   _ _ __  | __ ) _ __ ____(_)____', 
\'| | | / __|/ _ \  \ V / _ \| | | |  __| |  _ \|  __/ _  | |  _ \', 
\'| |_| \__ \  __/   | | (_) | |_| | |    | |_) | | | (_| | | | | |', 
\' \___/|___/\___|   |_|\___/ \____|_|    |____/|_|  \____|_|_| |_|', 
\]

"Airline设置
let g:airline_theme="luna" 

"这个是安装字体后 必须设置此项" 
let g:airline_powerline_fonts = 1   

"打开tabline功能,方便查看Buffer和切换，这个功能比较不错"
"我还省去了minibufexpl插件，因为我习惯在1个Tab下用多个buffer"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

"设置切换Buffer快捷键"
nnoremap <C-N> :bn<CR>
nnoremap <C-P> :bp<CR>

" 关闭状态显示空白符号计数,这个对我用处不大"
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#symbol = '!'

" 在Gvim中我设置了英文用Hermit， 中文使用 YaHei Mono "
if has('win32')
  set guifont=Hermit:h13
  set guifontwide=Microsoft_YaHei_Mono:h12
endif

"------------

"插件列表（由Vim-Plug管理）

call plug#begin('~/.vim/plugged')
"美化插件
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'yggdroot/indentline'
Plug 'mhinz/vim-startify'
"主题插件
Plug 'arcticicestudio/nord-vim'
Plug 'w0ng/vim-hybrid'
Plug 'KKPMW/sacredforest-vim'
Plug 'connorholyday/vim-snazzy'
"功能插件
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install_sync() } }
Plug 'chrisbra/changesPlugin'
Plug 'sbdchd/neoformat'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'junegunn/fzf', { 'dir': '~/.vim/bundle/fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdtree'
Plug 'neoclide/coc.nvim',{'branch':'release'}
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'terryma/vim-multiple-cursors'
" Initialize plugin system
call plug#end()

"------------

"主题插件设置

set background=dark
colorscheme snazzy
"------------
