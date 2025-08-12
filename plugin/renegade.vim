if exists("g:loaded_renegade") || &cp
	finish
endif
let g:loaded_renegade = 1

command -count -bang -nargs=+ -complete=file R
	\ if empty('<bang>') | <mods> new | else | enew | endif
	\|setl buftype=nofile bufhidden=wipe
	\|exe 'r !'<q-args>
	\|1d _
	\|filetype detect
	\|<count>

silent! nnoremap <unique> <Leader>gb :tab .R git blame --date short %<CR>
silent! nnoremap <unique> <Leader>gl :tab R git log <Up>
silent! nnoremap <unique> <Leader>go :R git show <cWORD><CR>
silent! nnoremap <unique> <Leader>gd :diffthis<CR>
			\:vertical R git show HEAD:./%<CR>
			\:diffthis<CR>
