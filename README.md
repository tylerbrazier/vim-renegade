# renegade.vim

Simple featherweight (~60 line) alternative to
[fugitive](https://github.com/tpope/vim-fugitive).

- `<Leader>gb` git blame the current file in a new tab
- `<Leader>gd` git diff the current file side by side
- `<Leader>gl` git log (works on visual selection)
- `<Leader>go` git show object (hash) under the cursor (after log/blame)
- `<Leader>gq` quickfix changed files/lines (see `:Review` below)

These mappings leverage commands:

- `:R` works like `:r !` and:
  - outputs to a new scratch window
  - accepts modifiers like `:tab` and `:vert`
  - accepts a count to put the cursor on that line; e.g. `:.R git blame %`
    blames the current file and starts the cursor on the current line
- `:Range` is a wrapper around `:R` that accepts a range and replaces any
  `<`/`>` in the command with start/end of range e.g. `:Range git log -L <,>:%`
  in visual mode to see the history of selected lines
- `:Review[!] [file]` to load the quickfix list:
  - when no `[file]` is given, list each new/changed file;
    include `!` to list every change of those files
  - when `[file]` is given, list each of its changes (implies `!`)

## Why?

- fugitive is bloated
- it also leaves behind a lot of garbage buffers (check `:ls!`);
  the `:R` buffer gets wiped out when you leave it
- `:term` always wraps text so diff and blame don't work
- `:term` has reflow issues when resizing windows
- `:term` has limited scrollback so log always needs `-n` for big repos
- vim is already great at working with text, so just put git's output in vim

## Ideas

- `:R git ls-files` and `gf` to edit a file in the window
- `:R` isn't limited to git commands
