if exists("g:loaded_renegade") || &cp
	finish
endif
let g:loaded_renegade = 1

command -count -nargs=+ -complete=file R
	\ <mods> new
	\|setl buftype=nofile bufhidden=wipe
	\|exe 'r !'<q-args>
	\|1d _
	\|filetype detect
	\|<count>

nnoremap <Leader>gb :tab .R git blame %<CR>
nnoremap <Leader>gl :tab R git log <Up>
nnoremap <Leader>go :R git show <cWORD><CR>
nnoremap <Leader>gd :vertical R git show HEAD:%<CR>
		\   :diffthis<CR><C-W>p:diffthis<CR>
