#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
link_zsh=0
only_zsh=0
backup_dir=""

usage() {
  cat <<'EOF'
Usage: scripts/link-configs.sh [--with-zsh | --only-zsh | --all]

Default: link Ghostty, tmux, AeroSpace, and Neovim.
  --with-zsh  Also link .zshrc and .p10k.zsh.
  --only-zsh  Link only .zshrc and .p10k.zsh.
  --all       Link every current config, including Zsh.

Existing targets are moved into ~/.local/state/dev-setup/backups/.
Machine-specific ~/.config/zsh/local.zsh is never changed.
EOF
}

ensure_link() {
  local source="$1" target="$2" backup
  [[ -e "$source" ]] || { printf 'Missing source: %s\n' "$source" >&2; return 1; }
  mkdir -p "$(dirname "$target")"
  if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$source" ]]; then
    printf 'ok: %s\n' "$target"
    return
  fi
  if [[ -e "$target" || -L "$target" ]]; then
    if [[ -z "$backup_dir" ]]; then
      mkdir -p "$HOME/.local/state/dev-setup/backups"
      backup_dir="$(mktemp -d "$HOME/.local/state/dev-setup/backups/links-XXXXXXXX")"
    fi
    backup="$backup_dir/${target#"$HOME/"}"
    mkdir -p "$(dirname "$backup")"
    mv "$target" "$backup"
    printf 'backup: %s -> %s\n' "$target" "$backup"
  fi
  ln -s "$source" "$target"
  printf 'link: %s -> %s\n' "$target" "$source"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --with-zsh|--all) link_zsh=1 ;;
    --only-zsh) link_zsh=1; only_zsh=1 ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown argument: %s\n' "$1" >&2; usage >&2; exit 1 ;;
  esac
  shift
done

if [[ "$only_zsh" -eq 0 ]]; then
  ensure_link "$repo_root/ghostty/config.ghostty" "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
  ensure_link "$repo_root/tmux/tmux.conf" "$HOME/.tmux.conf"
  ensure_link "$repo_root/aerospace/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"
  ensure_link "$repo_root/nvim" "$HOME/.config/nvim"
fi
if [[ "$link_zsh" -eq 1 ]]; then
  ensure_link "$repo_root/zsh/.zshrc" "$HOME/.zshrc"
  ensure_link "$repo_root/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
fi
