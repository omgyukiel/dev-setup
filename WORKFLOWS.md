# Daily Shortcut Playbook

Quick reference for the keyboard flows that compound productivity across tmux, AeroSpace, WezTerm, and the Zsh + Powerlevel10k shell.

## tmux

- Pane tiling: `Ctrl-a |` (split right) / `Ctrl-a -` (split down) to lay out logs vs. editors in seconds.
- Resize nudges: hold `Ctrl-a` then tap `h`/`j`/`k`/`l` to grow/shrink panes in 5-cell steps; zoom a pane with `Ctrl-a m` when deep-diving.
- Instant reload: `Ctrl-a r` after editing `~/.tmux.conf` to apply tweaks without leaving the session.
- Session attach in cwd: inside an existing pane hit `Ctrl-a M-c` to open/attach a session rooted where you already are (great for project-specific multiplexers).
- Morning resume: let tmux-continuum restore your layout, then cycle windows with `Ctrl-a n`/`Ctrl-a p` and use `vim-tmux-navigator` (Alt-h/j/k/l) to hop between Neovim splits and tmux panes seamlessly.

## AeroSpace

- Workspace grid: `Alt-1`..`Alt-9` (numeric) for primary contexts (chat, docs, dashboards), alphabetical `Alt-A`..`Alt-Z` for ad-hoc sandboxes.
- Focus vs. move: `Alt-h/j/k/l` to focus adjacent windows; add `Shift` to push the current app to a neighbor slot.
- Layout flip: `Alt-/` forces tile mode; `Alt-,` toggles accordion stacks when you need vertical code reviews.
- Monitor shuttling: `Alt-Shift-Tab` cycles the entire workspace to the next display; follow with `Alt-Tab` to bounce back if you overshoot.
- Layout reset: `Alt-Shift-;` enters service mode, then `r` to flatten overstretched trees back to a clean grid.

## WezTerm

- Tabbed tasking: `Cmd-T` opens a new tab with your Powerlevel10k prompt already themed; rotate through tabs with the macOS shortcuts `Cmd-Shift-[` / `Cmd-Shift-]`.
- Visual clarity toggles: exploit the 0.8 opacity + blur—stack WezTerm panes over docs without losing readability.
- Font legibility: `Cmd-=` / `Cmd--` temporarily adjusts the 19pt Meslo NF size during screen shares; reset with `Cmd-0`.

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

- **Cluster triage sprint:** Use AeroSpace workspace `Alt-3` for kube dashboards. Inside WezTerm, split tmux panes (`Ctrl-a |` and `Ctrl-a -`) for `kubectl get pods -w`, logs, and live `oci` CLI. When an outage hits, zoom the offending pane (`Ctrl-a m`), grab context, then unzoom to continue sweeping.
- **Agent dev loop:** Workspace `Alt-1` houses code. Run Neovim + tests in tmux panes; left pane auto-reloads `pytest -f`, right pane hosts the agent process, bottom pane for Git. Use `Alt-Shift-h/l` in AeroSpace to throw the entire WezTerm window between monitors during pair sessions.
- **Release prep:** Workspace `Alt-R` dedicated to release branches. Spawn a fresh tmux session (`tmux new -s release -c ~/dev/<repo>`) via `Ctrl-a M-c`. Track checklists in tab 2, `helm upgrade` dry runs in tab 3; rely on tmux-resurrect to recover if the laptop reboots mid-release.
- **Morning ramp-up:** After login, AeroSpace autostarts and tmux-continuum revives yesterday’s sessions. Run `exec zsh` in WezTerm to refresh the shell, then `Ctrl-a n` / `Ctrl-a p` to skim overnight panes. Use `Alt-Tab` to flip between current and last workspace while triaging notifications.
- **Context clean-up:** When windows sprawl, hit `Alt-Shift-;` then `backspace` (service mode) in AeroSpace to close all but the active window; follow with `Ctrl-a &` inside tmux to kill stray windows, keeping your session lean.

Keep this file next to the configs for quick recall—update it any time you add bindings or refine routines.
