if exists("g:loaded_renegade") || &cp
	finish
endif
let g:loaded_renegade = 1

silent! nnoremap <unique> <Leader>gl :R git log <Up>
silent! vnoremap <unique> <Leader>gl :Range git log -L <,>:% <Up>
silent! nnoremap <unique> <Leader>go :R git show <C-R><C-W>
silent! nnoremap <unique> <Leader>gb :tab .R git blame --date short %<CR>
silent! nnoremap <unique> <Leader>gs :cexpr Rstatus()<CR>
silent! nnoremap <unique> <Leader>gd :diffthis<CR>
			\:vert .R git show HEAD:./%<CR>
			\:diffthis<CR>

command -count -nargs=+ -complete=file R
	\ exe '<mods> new +setl\ ft='..(<count> > 0 ? &ft : 'git')
	\|exe 'file R'..bufnr() <q-args>
	\|exe 'silent r !' <q-args>
	\|1d _
	\|setl buftype=nofile bufhidden=wipe nomodifiable
	\|<count>

command -range -nargs=+ -complete=file Range
	\ let args = substitute(<q-args>, '<', <line1>, 'g')
	\|let args = substitute(args,     '>', <line2>, 'g')
	\|exe 'R' args

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
