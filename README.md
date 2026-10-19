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

## Restore on a personal Mac

Install Apple's Command Line Tools and Homebrew, clone this repo, then run:

```bash
bash scripts/bootstrap.sh
python3 scripts/verify-setup.py --packages --personal
```

The bootstrap installs shared packages without upgrading existing tools, clones
missing Oh My Zsh/Powerlevel10k/TPM, links configs with backups, and prepares the
pinned Neovim environment. It does not need a work account, VPN, or Oracle tools.
Open AeroSpace and grant Accessibility access, then add `--apps` to verification.

- [Personal-Mac onboarding and a ready-to-paste Codex prompt](docs/ONBOARDING.md)
- [Guided practice: tmux, Neovim, shell helpers, and AeroSpace](docs/PRACTICE.md)
- [Codex repository instructions](AGENTS.md)
- [Validation evidence and limits](docs/VALIDATION.md)

`bash scripts/link-configs.sh --all` relinks configs without installing packages.
The default link command includes Ghostty, tmux, AeroSpace and Neovim; `--only-zsh`
links just the shell. Correct links are left alone. Replaced files/directories
are backed up outside Git under `~/.local/state/dev-setup/backups/`.

The baseline includes `btop` for Mac resource monitoring, `tldr` (from `tlrc`) for
short command examples, `uv` for Python projects, Node 24 for editor tooling, and
a Nerd Font for icon glyphs. A working local NVM runtime takes priority over the
Homebrew Node fallback. No global Git identity is set by this setup.

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
Neovim splits and adjacent tmux panes. The fzf Option-C shortcut is disabled. Prefer tmux windows as tabs inside one
native Ghostty tab when using AeroSpace; see the onboarding guide for why.

```bash
tmux new -s dev
tmux attach -t dev
```

Detach with Ctrl-B then D. Save a layout with Ctrl-B then Ctrl-S; restore with
Ctrl-B then Ctrl-R. Continuum saves every 15 minutes while the tmux status bar
runs and restores the last saved layout on tmux server start. This restores the
session layout rather than arbitrary processes at their previous execution state.

Tmux selections can be copied to the macOS clipboard with tmux-yank. New splits
inherit the current pane's directory.

Start with [docs/PRACTICE.md](docs/PRACTICE.md), then use
[WORKFLOWS.md](WORKFLOWS.md) as the daily reference.

## Verify changes

```bash
python3 scripts/verify-setup.py --packages --apps
```

Reload Ghostty with Cmd-Shift-Comma, start a new shell, and reload running tmux
with `tmux source-file ~/.tmux.conf` after editing its config. Changes are live
through the symlinks; commits record the version to restore on future devices.
