# Daily Shortcut Playbook

Quick reference for the keyboard flows that compound productivity across tmux, AeroSpace, WezTerm, and the Zsh + Powerlevel10k shell.

## tmux

- Pane tiling: `Ctrl-b |` (split right) / `Ctrl-b -` (split down) to lay out logs vs. editors in seconds.
- Resize nudges: hold `Ctrl-b` then tap `h`/`j`/`k`/`l` to grow/shrink panes in 5-cell steps; zoom a pane with `Ctrl-b m` when deep-diving.
- Instant reload: `Ctrl-b r` after editing `~/.tmux.conf` to apply tweaks without leaving the session.
- Session attach in cwd: inside an existing pane hit `Ctrl-b M-c` to open/attach a session rooted where you already are (great for project-specific multiplexers).
- Morning resume: let tmux-continuum restore your layout, then cycle windows with `Ctrl-b n`/`Ctrl-b p` and use tmux's built-in pane selectors when needed.

## AeroSpace

- Workspace grid: `Alt-1`..`Alt-9` switches between numbered workspaces; `Alt-Shift-1`..`Alt-Shift-9` sends the focused app to a numbered workspace.
- Focus vs. move: `Alt-h/j/k/l` focuses adjacent windows; add `Shift` to move the current app to a neighbor slot.
- Layout flip: `Alt-/` forces tile mode; `Alt-,` toggles accordion stacks when you need vertical code reviews.
- Secondary display: `Alt-Shift-Tab` jumps to the dedicated `secondary` workspace, `Alt-Shift-S` sends the focused window there, and `Alt-Tab` bounces between current and previous workspace.
- Layout reset: `Alt-Shift-;` enters service mode, then `r` flattens workspace trees or `backspace` closes all but the active window.

## WezTerm

- Tabbed tasking: `Cmd-T` opens a new tab with your Powerlevel10k prompt already themed; rotate through tabs with the macOS shortcuts `Cmd-Shift-[` / `Cmd-Shift-]`.
- Visual clarity toggles: exploit the 0.8 opacity + blur—stack WezTerm panes over docs without losing readability.
- Font legibility: `Cmd-=` / `Cmd--` temporarily adjusts the 19pt Meslo NF size during screen shares; reset with `Cmd-0`.

## Terminal Input Editing

- Line bounds: `Ctrl-a` jumps to the beginning of the input; `Ctrl-e` jumps to the end.
- Word movement: `Option-b` or `Option-Left` moves back one word; `Option-f` or `Option-Right` moves forward one word. AeroSpace uses `Alt-h/j/k/l`, so arrows are the safer word-movement habit.
- Word deletion: `Ctrl-w` or `Option-Backspace` deletes the previous word; `Option-d` deletes the next word.
- Line deletion: `Ctrl-u` clears before the cursor/current input; `Ctrl-k` clears after the cursor.
- History search: `Ctrl-r` opens reverse search through command history.

## Zsh + Powerlevel10k

- Directory jumps: `z <keyword>` teleports via zoxide (replace built-in `cd`); pair with `tmux attach -t $(basename $PWD)` after landing.
- Smarter listings: `ls` auto-expands to `eza --icons=always` so you get git status and file types at a glance.
- Git context: lean on the prompt’s VCS segment—branch state is always visible; transient prompt keeps history tidy right after enter.
- Kubernetes helpers: `caa-kubectx` completion + the prompt’s kube context indicator (if enabled in `.p10k.zsh`) guards against staging/prod mix-ups.

## ripgrep

- Core search: `rg 'needle'` recursively scans the current directory with smart case sensitivity (uppercase forces exact case, lowercase matches both).
- Path filters: add `-g '*.ts'` or `-g '!node_modules'` to narrow the scan to the files you care about while skipping bulky deps.
- Context slices: use `-n` to show line numbers, `-C3` for three lines of context, and `--stats` when you want a quick hit rate summary.
- Fast refines: combine ripgrep with keyboard nav—`rg pattern | fzf` for interactive filtering, or jump straight to files via `rg --files -g '*.py'`.

## Daily Scenarios

- **Cluster triage sprint:** Use AeroSpace workspace `Alt-3` for kube dashboards. Inside WezTerm, split tmux panes (`Ctrl-b |` and `Ctrl-b -`) for `kubectl get pods -w`, logs, and live `oci` CLI. When an outage hits, zoom the offending pane (`Ctrl-b m`), grab context, then unzoom to continue sweeping.
- **Agent dev loop:** Workspace `Alt-1` houses code. Run Neovim + tests in tmux panes; left pane auto-reloads `pytest -f`, right pane hosts the agent process, bottom pane for Git. Use `Alt-Shift-h/l` to move the focused app in the layout, or `Alt-Shift-Tab` to jump to the dedicated secondary-display workspace.
- **Release prep:** Workspace `Alt-4` handles release branches. Spawn a fresh tmux session (`tmux new -s release -c ~/dev/<repo>`) via `Ctrl-b M-c`. Track checklists in tab 2, `helm upgrade` dry runs in tab 3; rely on tmux-resurrect to recover if the laptop reboots mid-release.
- **Morning ramp-up:** After login, AeroSpace autostarts and tmux-continuum revives yesterday’s sessions. Run `exec zsh` in WezTerm to refresh the shell, then `Ctrl-b n` / `Ctrl-b p` to skim overnight panes. Use `Alt-Tab` to flip between current and last workspace while triaging notifications.
- **Context clean-up:** When windows sprawl, hit `Alt-Shift-;` then `backspace` in AeroSpace to close all but the active window; follow with `Ctrl-b &` inside tmux to kill stray windows, keeping your session lean.

Keep this file next to the configs for quick recall—update it any time you add bindings or refine routines.
