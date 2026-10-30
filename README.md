# renegade.vim

Simple featherweight alternative to
[fugitive](https://github.com/tpope/vim-fugitive).

- `<Leader>gl` git log (works on visual selection)
- `<Leader>gb` git blame the current file in a new tab
- `<Leader>go` git show object (hash) under the cursor (use in log/blame window)
- `<Leader>ga` git add the current file
- `<Leader>gr` git restore the current file
- `<Leader>gd` git diff the current file side by side (see `:Relative` below)
- `<Leader>gs` git status in quickfix list (see `:Report` below)
- `<Leader>gcr` code review current branch (see `:Review` below)

These mappings leverage commands:

- `:R` works like `:r !` and:
  - outputs to a scratch buffer in a new window
  - accepts modifiers like `:tab` and `:vert`
  - accepts a count to put the cursor on that line; e.g. `:.R git blame %`
    blames the current file and starts the cursor on the current line
  - sets the temporary buffer's `filetype=git` (use `:R!` to skip that)
- `:Range` is a wrapper around `:R` that accepts a range and replaces any
  `<`/`>` in the command with start/end of range e.g. `:Range git log -L <,>:%`
  in visual mode to see the history of selected lines
- `:Relative [revision]` to show `revision` (default is `HEAD`) of the current
  file in a vertical split and diff them
- `:Report[!] [revision]` to load the quickfix list with changed files
  since `revision` (default is `HEAD`). Use `!` to include untracked files
- `:Review [revision]` combos `:Report` with `:cdo Relative` to open a diff
  in a new tab for each changed file since `revision` (default is `HEAD`)

## Why?

- fugitive is bloated
- it also leaves behind a lot of garbage buffers (check `:ls!`);
  the `:R` buffer gets wiped out when you leave it
- `:term` always wraps text so diff and blame don't work
- `:term` has reflow issues when resizing windows
- `:term` has limited scrollback so log always needs `-n` for big repos
- vim is already great at working with text, so just put git's output in vim
