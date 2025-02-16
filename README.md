# renegade.vim

A simple, featherweight (<50 SLOC) alternative to
[fugitive](https://github.com/tpope/vim-fugitive).

At the heart of the plugin is `:R` which works like `:r!`
but outputs to a new scratch window (accepting modifiers like `:tab`).

You can run the command directly or the predefined mappings that use it:

- `<Leader>gb` git blame the current file in a new tab
- `<Leader>gd` git diff the current file side by side
- `<Leader>gl` git log
- `<Leader>go` git show object (e.g. hash) under the cursor
               (use in log or blame output)

The plugin also sets `grepprg` and `path` when the cwd is in a git project so
you can `:grep` and `:find` tracked files (and avoid gitignored ones).

## Why?

- fugitive has more bells and whistles than I want
- it also leaves behind a lot of garbage buffers (check `:ls!`);
  the `:R` buffer gets wiped out when you leave it
- `:term` always wraps text so diff and blame don't work
- vim is already great at working with text, so just put git's output in vim

## Ideas

- `:R git status -s` and a macro for `:!git add <cWORD>`
- `:R git ls-files` and `gf` to edit a file in the window
- `:R` also accepts a count (like `:7R`) to start the cursor on that line in
  the new window (e.g. the included mapping does `:.R git blame %` to use the
  same line as the current file)
- `:R` isn't limited to git commands
