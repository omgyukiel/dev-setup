#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

link_wezterm=0
link_zsh=0

usage() {
  cat <<'EOF'
Usage: scripts/link-configs.sh [--with-wezterm] [--with-zsh] [--all]

Links the portable dev-setup configs into $HOME.

Defaults:
  - AeroSpace
  - tmux

Optional:
  --with-wezterm  Also link WezTerm
  --with-zsh      Also link .zshrc and .p10k.zsh
  --all           Link everything above
EOF
}

backup_path_for() {
  local target="$1"
  local backup="${target}.pre-dev-setup-link.bak"
  local counter=1

  while [[ -e "$backup" || -L "$backup" ]]; do
    backup="${target}.pre-dev-setup-link.${counter}.bak"
    counter=$((counter + 1))
  done

  printf '%s\n' "$backup"
}

ensure_link() {
  local source="$1"
  local target="$2"
  local backup

  mkdir -p "$(dirname "$target")"

  if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$source" ]]; then
    printf 'ok: %s already points to %s\n' "$target" "$source"
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    backup="$(backup_path_for "$target")"
    mv "$target" "$backup"
    printf 'backup: %s -> %s\n' "$target" "$backup"
  fi

  ln -s "$source" "$target"
  printf 'link: %s -> %s\n' "$target" "$source"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --with-wezterm)
      link_wezterm=1
      ;;
    --with-zsh)
      link_zsh=1
      ;;
    --all)
      link_wezterm=1
      link_zsh=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown argument: %s\n\n' "$1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

ensure_link "$repo_root/tmux/tmux.conf" "$HOME/.tmux.conf"
ensure_link "$repo_root/aerospace/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"

if [[ "$link_wezterm" -eq 1 ]]; then
  ensure_link "$repo_root/wezterm/wezterm.lua" "$HOME/.wezterm.lua"
fi

if [[ "$link_zsh" -eq 1 ]]; then
  ensure_link "$repo_root/zsh/.zshrc" "$HOME/.zshrc"
  ensure_link "$repo_root/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
fi
