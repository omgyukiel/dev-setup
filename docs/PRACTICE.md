# Practice your Mac workflow

Start with exercise 1 and stop whenever you want. Use a throwaway tmux session;
none of these exercises needs a work account, cluster, server, or real project.

**Prefix → key** means press Ctrl-B, release both keys, then press the next key.
Plain Ctrl-H/J/K/L means hold Ctrl while pressing that letter. In Neovim, press
Escape first so you are in normal mode.

## 1. Create a session

If you are already inside tmux, use **prefix → d** to detach first. In Ghostty:

```zsh
tmux new -As practice
```

You should see a tmux status bar. This creates the named session or reconnects to
it if it already exists. `new` means new-session, `-A` means attach if it exists,
and `-s practice` gives the session its name. An optional `-c DIRECTORY` chooses
the starting folder for a newly created session; it does not relocate old panes.

Remember the hierarchy:

```text
Ghostty window
└── tmux session: practice
    ├── window: editor      ← behaves like a tab
    │   ├── pane: Neovim
    │   └── pane: shell
    └── window: monitor
        └── pane: btop
```

## 2. Create and name windows

1. **Prefix → ,**; type `editor` and press Enter.
2. Run `nvim` and leave it open.
3. **Prefix → c** creates another window in the same session.
4. Rename it `monitor` using **prefix → ,**.
5. Run `btop`. You should see this Mac's CPU, memory and process activity.

Use **prefix → p** and **prefix → n** to switch back and forth. Neovim and btop
keep running while hidden. **Prefix → w** opens a window picker; use arrows and
Enter. Windows start at index 0; **prefix → 0**, **prefix → 1**, etc. selects one.

Checkpoint: you have two windows under one session, not two Ghostty tabs.

## 3. Split a window into panes

1. Return to `editor`.
2. **Prefix → -** creates a shell below Neovim. Run `pwd` in it.
3. **Ctrl-K** moves up into Neovim; **Ctrl-J** moves back down.
4. In the lower shell, **prefix → |** splits right.
5. **Ctrl-H / Ctrl-L** moves left/right between the lower panes.
6. **Prefix → m** zooms the active pane; repeat to restore the layout.
7. **Prefix → h/j/k/l** resizes panes in that direction.

New splits inherit the selected pane's working directory. Neovim's Ctrl-H/J/K/L
first moves through its own splits, then crosses into tmux at the edge.

Checkpoint: one window has several visible panes; your `monitor` window is intact.

## 4. Close a pane, then detach and reconnect

Select an extra shell pane. **Prefix → x**, then `y`, closes only that pane.
Alternatively, type `exit` in its shell. Return to a pane you want to keep.

1. **Prefix → d** detaches without stopping the session.
2. Back at Ghostty's outer shell, run `tmux ls`.
3. Reconnect: `tmux attach -t practice`.

Checkpoint: your named windows and programs are still running. Detaching is
different from killing the session or shutting down the computer.

## 5. Copy text into the macOS clipboard

In a shell pane, run:

```zsh
printf 'clipboard practice\n'
```

Press **prefix → [** to enter vi copy mode. Move with arrows or h/j/k/l to the
printed text, press `v` to begin selecting, extend the selection, then press `y`.
The tmux-yank plugin copies it to the macOS clipboard. Paste into a scratch note
with Cmd-V. Escape exits copy mode if you want to cancel.

## 6. Learn sessions versus windows

Detach from `practice`, then run `tmux new -As second-practice`. Rename its only
window `scratch`. **Prefix → s** opens the session picker; switch back to
`practice`. Notice that `practice` still contains `editor` and `monitor`.

Use a session for each project, windows for tasks, and panes for simultaneous views.
Do not run a plain `tmux new` inside tmux: detach or use the session picker first.

## 7. Understand save and restore

In the practice session, use **prefix → Ctrl-S** to save a layout. **Prefix → Ctrl-R**
restores a saved layout; Continuum also saves automatically about every 15 minutes
while the tmux status bar runs and restores on server start.

Manual saves share the user's normal tmux-resurrect snapshot location. Skip this
exercise if you already have an important layout saved. A saved layout does not
resume arbitrary processes, shell credentials, or SSH connections at the exact
execution point. You do not need to reboot or kill the server to practice basics.

## 8. Try the shell helpers

Use a shell pane:

```zsh
mkdir -p /tmp/dev-setup-practice/alpha
cd /tmp/dev-setup-practice/alpha
cd ~
z alpha
ls
ll
```

`z alpha` should return to the folder you just visited. `zi` offers an interactive
directory chooser. Type part of a command you previously ran; Right Arrow at the
end accepts the gray suggestion. Up/Down searches matching command prefixes.

- **Ctrl-R:** fuzzy command history. Type a word, inspect the result, press Escape
  to cancel or Enter to put the selected command on the input line; review before
  pressing Enter again to execute it.
- **Ctrl-T:** choose a file path to insert into the current command; Escape cancels.
- `tldr tmux`: short command examples; the first lookup downloads the page cache.
- `prompt-theme original`, then `prompt-theme tokyo-night`: compare prompt colors.

Checkpoint: colors change, but the prompt layout and project windows stay the same.

## 9. Separate desktop windows from terminal panes

With Ghostty and another app open, use **Option-H/J/K/L** to focus desktop windows.
Within Ghostty, use **Ctrl-H/J/K/L** for tmux/Neovim panes. Use **Option-1…9** to
change AeroSpace workspaces. Move a window with **Option-Shift-1…9**, then follow
it with Option plus that number. Do not practice AeroSpace's close-other-windows
binding on a workspace containing important windows.

Checkpoint: AeroSpace arranges apps; tmux arranges terminal work inside Ghostty.
Create terminal tabs with **prefix → c** instead of Cmd-T when using this workflow.

## Cleanup

Detach first, then run these only when you are finished with the practice sessions:

```zsh
tmux kill-session -t practice
tmux kill-session -t second-practice
```

These commands stop everything inside those sessions. A missing-session message
just means it is already gone. Other tmux sessions are left alone. The scratch
folder can be removed later once you have left it; no cleanup is automatic.
