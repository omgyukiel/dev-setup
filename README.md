# Dev Setup Snapshot

This directory mirrors the core productivity configs I rely on daily. Copy or symlink the files back into `$HOME` (or the noted paths) to restore the same shell, terminal, tiling, and multiplexer experience.

## Included Configs

- `tmux/tmux.conf`
  - Prefix remapped to `Ctrl-b`, ergonomic split bindings, vi-mode copy, mouse support.
  - Plug-in stack via TPM (`vim-tmux-navigator`, `tmux-resurrect`, `tmux-continuum`, `tokyo-night` theme).
- `aerospace/aerospace.toml`
  - Numbered workspace bindings (`alt-1`..`alt-9`, `alt-shift-1`..`alt-shift-9`) with Alt-based window movement controls.
  - Automatic launch at login, normalization tweaks, and smart workspace toggles.
- `wezterm/wezterm.lua`
  - Meslo Nerd Font at 19pt, Batman base scheme with custom Coolnight palette.
  - Translucent window background with macOS blur, tab bar enabled, and Option-as-Meta terminal editing.
- `zsh/.zshrc`
  - Powerlevel10k prompt, Rancher Desktop PATH, kubectx completion, autosuggestions, syntax highlighting.
  - Quality-of-life aliases (`ls`→`eza`), directory jumping via `zoxide`.
- `zsh/.p10k.zsh`
  - Generated 2026-03-05; defines the rainbow, two-line Powerlevel10k prompt used by `.zshrc`.
- `scripts/link-configs.sh`
  - Bootstraps symlinks into `$HOME`; defaults to the portable core (`tmux` + `aerospace`) and keeps optional configs opt-in.

## tmux Quick Reference

- `Ctrl-b c` creates a new window in the current session—keep focused projects isolated per window.
- `Ctrl-b w` opens an interactive window picker (arrow keys + enter) so you can hop directly to hidden windows 4+ without cycling.
- `Ctrl-b ,` renames the current window; use short context labels (`api`, `ops`, `docs`) to make the status line readable.
- `Ctrl-b s` lists sessions; hit enter to switch or `d` to detach the highlighted one without leaving your current client.
- `Ctrl-b {` / `Ctrl-b }` swaps the focused pane with the previous/next pane—handy for reordering without rebuilding splits.
- `Ctrl-b [` enters copy mode; use `v` + motion to select text and `y` to yank into the tmux buffer for paste into other panes.

## Restore Steps

1. Install dependencies: Homebrew packages for `tmux`, `aerospace`, `wezterm`, `zoxide`, `eza`, `powerlevel10k`, `zsh-autosuggestions`, `zsh-syntax-highlighting`.
2. Link the portable core configs back into place:
   ```bash
   bash scripts/link-configs.sh
   ```
   Optional:
   ```bash
   bash scripts/link-configs.sh --with-wezterm
   bash scripts/link-configs.sh --with-zsh
   bash scripts/link-configs.sh --all
   ```
   `zsh` is opt-in because `.zshrc` currently includes user-specific paths and shell startup behavior that may not belong on every Mac.
3. For tmux plugins run `tmux new -d` and `tmux run-shell ~/.tmux/plugins/tpm/bindings/install_plugins` or simply press `prefix + I` inside tmux.
4. Reload or restart each tool (`tmux source-file ~/.tmux.conf`, `aerospace reload-config`, `wezterm` relaunch, `exec zsh`).

_Last updated: 2026-05-20_
