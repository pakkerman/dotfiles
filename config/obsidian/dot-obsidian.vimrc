unmap <Space>
" Change navigating to display line
map j gj
map k gk
nmap $ g$
nmap ^ g^
nmap 0 g0
nmap V g$vg0o

inoremap jk <Esc>
inoremap jK <Esc>
inoremap Jk <Esc>
inoremap JK <Esc>

" I like using H and L for beginning/end of line
" Quickly remove search highlights
nmap <Space>ur :nohl

" Yank to system clipboard
" set clipboard=unnamed

" Go back and forward with Ctrl+O and Ctrl+I
" (make sure to remove default Obsidian shortcuts for these to work)
exmap go_back obcommand app:go-back
nmap <C-o> :go_back
exmap go_forward obcommand app:go-forward
nmap <C-i> :go_forward


exmap toggle_left_sidebar obcommand app:toggle-left-sidebar
nnoremap <Space>e :toggle_left_sidebar

exmap delete_file obcommand app:delete-file
nnoremap <Space>dd :delete_file

exmap go_to_def obcommand editor:follow-link
nnoremap gd :go_to_def

" followed from the instruction in https://github.com/esm7/obsidian-vimrc-support?tab=readme-ov-file#surround-text-with-surround
" with some modification to the keymap
exmap surround_link surround [[ ]]
exmap surround_double_quotes surround " "
exmap surround_single_quotes surround ' '
exmap surround_backticks surround ` `
exmap surround_brackets surround ( )
exmap surround_square_brackets surround [ ]
exmap surround_curly_brackets surround { }

map gsa[[ :surround_link
map gsa" :surround_double_quotes
map gsa' :surround_single_quotes
map gsa` :surround_backticks
map gsa( :surround_brackets
map gsa[ :surround_square_brackets
map gsa{ :surround_curly_brackets

map gsd( vi(dva(p
map gsd[ vi[dva[p
map gsd" vi"dva"p
map gsd' vi'dva'p
map gsd` vi`dva`p
map gsd{ vi{dva{p


" create markdown URL link
"
"
nnoremap vid :echo 123


" change zt to mimic with scrolloff=4
nnoremap zt zt4<C-y>
