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
silent! nnoremap <unique> <Leader>go :R git show <C-R><C-W>
silent! nnoremap <unique> <Leader>gs :cexpr Rstatus()<CR>
silent! nnoremap <unique> <Leader>gd :diffthis<CR>
			\:vertical R git show HEAD:./%<CR>
			\:diffthis<CR>

function Rstatus()
	" gather the new files first
	let result = systemlist('git status --porcelain -u')
				\->filter('v:val =~ "^??"')
				\->map('v:val[3:].."|1| [New file]"')
	let diff = systemlist('git -P diff -U0')
	for i in range(len(diff))
		if diff[i] !~ '^+++ b'
			continue
		endif
		let f = diff[i][6:]
		let l = matchstr(diff[i+1], '+\d\+')[1:]
		let m = diff[i+2]
		call add(result, f..'|'..l..'| '..m)
	endfor
	return result
endfunction
