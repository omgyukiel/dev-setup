# Mac development setup

Working configs for this Apple Silicon Mac. The files in this repository are the
source of truth: edit them here, and the apps read them through symlinks.

## Configs

| Source | Active location |
| --- | --- |
| `ghostty/config.ghostty` | `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty` |
| `zsh/.zshrc` | `~/.zshrc` |
| `zsh/.p10k.zsh` | `~/.p10k.zsh` |
| `tmux/tmux.conf` | `~/.tmux.conf` |
| `aerospace/aerospace.toml` | `~/.config/aerospace/aerospace.toml` |
| `nvim/` | `~/.config/nvim` |

Ghostty uses the saved `niji` theme, 15pt text, 95% opacity, balanced padding,
and a transparent title bar. It adds no custom shortcuts. Powerlevel10k's saved
Classic two-line prompt is kept separately from its optional Tokyo Night color
overlay. LazyVim uses Tokyo Night Moon, and tmux uses PowerKit's Tokyo Night theme.

## Restore on another Mac

Install Homebrew first, then run these from the cloned repository:

```bash
brew bundle --file=Brewfile
```

The shell uses Oh My Zsh with Powerlevel10k. If they are absent, install them:

```bash
git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
git clone --depth 1 https://github.com/romkatv/powerlevel10k.git \
  "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
```

Install MesloLGS NF or another Nerd Font if icons are missing. MesloLGS NF is
already installed on this Mac. Keep zsh as the login shell; Homebrew Bash is a
dependency of the tmux status theme.

Link the configs:

```bash
bash scripts/link-configs.sh --all
```

The default command without flags links Ghostty, tmux, AeroSpace and Neovim.
`--with-zsh` or `--all` also links the shell; `--only-zsh` links just the shell.
Re-running the script leaves correct links alone. Existing files/directories
are moved to `~/.local/state/dev-setup/backups/`, outside Git.

Install tmux plugins if TPM is absent:

```bash
git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
tmux new -s dev
```

Inside tmux, press Ctrl-B, release, then Shift-I. TPM installs the navigation,
PowerKit, resurrect and continuum plugins listed in `tmux/tmux.conf`.

Launch AeroSpace and grant **System Settings → Privacy & Security → Accessibility**
permission. The saved config starts it at login and keeps workspaces 1–9 plus
`secondary` available, with the latter assigned to a secondary monitor when present.

Open `nvim` to bootstrap LazyVim. The lockfile records plugin versions; use
`:Lazy restore` to restore those versions. JSON, Markdown, Python and TOML extras
are enabled. `:Mason` manages language tools; this Mac has pyright, ruff, JSON and
Lua language servers, markdownlint-cli2, markdown-toc, stylua and shfmt installed.
Run `:checkhealth lazyvim` to verify editor dependencies.

## Local settings and credentials

The tracked `.zshrc` optionally sources `~/.config/zsh/local.zsh`. That file stays
outside this repository and is never modified by the link script. On this Mac
it holds NVM, SCM agent startup, OCI/OSSH settings, oke-connect, kubeconfig handling
and Rancher Desktop PATH integration. On another Mac, recreate it for the tools
configured there; the Brewfile covers the shared terminal/editor tools only.

SSH keys, OCI credentials, Docker credentials, application profiles and tokens
stay in their existing locations. Never copy them into this repository. Local
backups, logs, environment files, key files and credential files are ignored.

## Shell and prompt

- `ls`: eza icons; `ll`: long listing with Git status; `la`: also hidden files.
- `z keyword` / `cd keyword`: jump to directories learned from previous visits.
- `zi`: interactively choose a learned directory.
- Right Arrow at the end of input accepts the gray command suggestion.
- Up/Down searches history matching the prefix already typed.
- Ctrl-R opens fuzzy history; Ctrl-T inserts selected file paths.
- Tab completes normally; `**` then Tab invokes fuzzy completion where supported.
- `ro` aliases `rg`; `bat` and `fd` are also installed.

```zsh
prompt-theme original
prompt-theme tokyo-night
```

The theme choice persists in `~/.config/zsh/prompt-theme`, outside Git. Both choices
use the saved layout, segments, clock format, icons and transient prompt from
`zsh/.p10k.zsh`. Running `p10k configure` edits that linked file; review its Git diff
afterward. Ghostty's appearance settings are independent of the prompt colors.

## Keyboard layers and sessions

Option belongs to AeroSpace, Ctrl-B is the tmux prefix, and Ctrl-H/J/K/L navigates
Neovim splits and adjacent tmux panes. The fzf Option-C shortcut is disabled.

```bash
tmux new -s dev
tmux attach -t dev
```

Detach with Ctrl-B then D. Save a layout with Ctrl-B then Ctrl-S; restore with
Ctrl-B then Ctrl-R. Continuum saves every 15 minutes while the tmux status bar
runs and restores the last saved layout on tmux server start. This restores the
session layout rather than arbitrary processes at their previous execution state.

See [WORKFLOWS.md](WORKFLOWS.md) for the daily shortcuts.

## Verify changes

```bash
brew bundle check --file=Brewfile
bash -n scripts/link-configs.sh
zsh -n zsh/.zshrc
ghostty +validate-config
aerospace reload-config --no-gui --dry-run --warnings-as-errors
git diff --check
```

Reload Ghostty with Cmd-Shift-Comma, start a new shell, and reload running tmux
with `tmux source-file ~/.tmux.conf` after editing its config. Changes are live
through the symlinks; commits record the version to restore on future devices.
