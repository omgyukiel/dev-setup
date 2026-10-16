# Daily shortcuts

## Ghostty

- Cmd-T opens a new tab; Cmd-W closes the current surface, with confirmation when needed.
- Cmd-Plus / Cmd-Minus changes text size; Cmd-0 resets it.
- Cmd-Shift-Comma reloads the config.
- Use tmux for splits; Ghostty keeps its default keyboard shortcuts.

## tmux

Press Ctrl-B, release, then the listed key unless shown otherwise.

| Key | Action |
| --- | --- |
| `\|` / `-` | Split right / below |
| `x` | Kill the current pane; confirm with `y` |
| `h/j/k/l` | Resize left/down/up/right |
| `m` | Zoom or unzoom the current pane |
| `c` | New window |
| `n` / `p` | Next / previous window |
| `w` / `s` | Choose a window / session |
| `,` | Rename window |
| `d` | Detach; reconnect with `tmux attach -t NAME` |
| `r` | Reload config |
| Ctrl-S / Ctrl-R | Save / restore session layout |
| Shift-I | Install configured TPM plugins |
| `[` | Enter vi copy mode; `v` selects and `y` copies to the macOS clipboard |

Ctrl-H/J/K/L (without the prefix) moves left/down/up/right across panes. Inside
Neovim, it moves through editor splits first, then into tmux panes at the edge.
Continuum autosaves every 15 minutes while the status bar runs; restoring layout
does not resume arbitrary processes or remote connections at their previous state.

## AeroSpace

- Option-H/J/K/L focuses adjacent windows; add Shift to move windows instead.
- Option-1…9 changes workspace; Option-Shift-1…9 sends the current window there.
- Option-/ toggles tile orientation; Option-Comma toggles accordion orientation.
- Option-Tab switches to the previous workspace.
- Option-Shift-Tab selects `secondary`; Option-Shift-S sends a window there.
- Option-Shift-Minus / Option-Shift-Equal resizes the selected container.
- Option-Shift-Semicolon enters service mode: `r` resets the layout, `f` toggles
  floating, and Escape reloads config and returns to normal mode.
- In service mode, Backspace closes every other window on the current workspace.

## LazyVim

Space is the leader key. Use Ctrl-H/J/K/L in normal mode for split/pane navigation.

- Space-E opens the file explorer; Space-Shift-E opens it at the current directory.
- Space-F-F finds project files; Space-F-Shift-F finds files in the current directory.
- Space-Comma switches buffers.
- `gcc` comments a line; select lines and use `gc` to comment the selection.
- Space-C-P opens Markdown preview.
- Space-C-V selects a Python virtual environment.
- `gd` goes to a definition when a language server is attached.
- `:Lazy` manages plugins; `:Mason` manages language tools.

## Zsh

- `ls`, `ll`, `la`: icon listings, long listings, and hidden files.
- `z keyword` / `cd keyword`: jump to a learned directory; `zi`: interactive chooser.
- Right Arrow at the end of input accepts the gray autosuggestion.
- Up/Down searches history matching the prefix already typed.
- Ctrl-R searches history with fzf; Ctrl-T inserts file paths.
- Ctrl-A / Ctrl-E moves to the beginning / end of input; Ctrl-W deletes a word.
- Outside tmux, Ctrl-K clears after the cursor. Inside tmux it navigates up.
- `prompt-theme original` restores saved prompt colors; `prompt-theme tokyo-night`
  applies the color overlay with the same layout.

## Search

```bash
rg 'needle'
rg -S 'needle'                 # smart case; plain rg is case-sensitive
rg -n -C3 'needle' -g '*.ts'    # line numbers, context, file filter
rg --files -g '*.py' | fzf     # choose among matching file paths
fd pattern
bat path/to/file
```

Oracle and Kubernetes helpers are machine-specific and load from
`~/.config/zsh/local.zsh` when configured.

## Resource monitoring

Run `btop` to view this Mac's CPU, memory, disks, network activity and processes.
Press `q` to quit. Keep it in a tmux window named `monitor` while other windows
remain available for editing and shell commands.

For a guided walkthrough, follow [docs/PRACTICE.md](docs/PRACTICE.md). Use `tldr tmux`,
`tldr rg`, or `tldr tar` for short command examples; the first lookup downloads
the page cache.
