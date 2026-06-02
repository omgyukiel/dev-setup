#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
script_path="$repo_root/scripts/link-configs.sh"

assert_symlink() {
  local path="$1"
  local expected_target="$2"
  local actual_target

  if [[ ! -L "$path" ]]; then
    echo "expected symlink at $path"
    exit 1
  fi

  actual_target="$(readlink "$path")"
  if [[ "$actual_target" != "$expected_target" ]]; then
    echo "unexpected symlink target for $path: $actual_target"
    exit 1
  fi
}

test_default_links() {
  local test_home
  test_home="$(mktemp -d)"

  HOME="$test_home" "$script_path"

  assert_symlink "$test_home/.tmux.conf" "$repo_root/tmux/tmux.conf"
  assert_symlink "$test_home/.config/aerospace/aerospace.toml" "$repo_root/aerospace/aerospace.toml"

  [[ ! -e "$test_home/.wezterm.lua" ]] || {
    echo "wezterm should not be linked by default"
    exit 1
  }

  [[ ! -e "$test_home/.zshrc" ]] || {
    echo "zsh should not be linked by default"
    exit 1
  }
}

test_optional_links_and_backup() {
  local test_home
  test_home="$(mktemp -d)"

  mkdir -p "$test_home/.config/aerospace"
  printf 'old tmux\n' > "$test_home/.tmux.conf"
  printf 'old aerospace\n' > "$test_home/.config/aerospace/aerospace.toml"
  printf 'old wezterm\n' > "$test_home/.wezterm.lua"

  HOME="$test_home" "$script_path" --with-wezterm

  assert_symlink "$test_home/.tmux.conf" "$repo_root/tmux/tmux.conf"
  assert_symlink "$test_home/.config/aerospace/aerospace.toml" "$repo_root/aerospace/aerospace.toml"
  assert_symlink "$test_home/.wezterm.lua" "$repo_root/wezterm/wezterm.lua"

  [[ -f "$test_home/.tmux.conf.pre-dev-setup-link.bak" ]] || {
    echo "expected tmux backup"
    exit 1
  }

  [[ -f "$test_home/.config/aerospace/aerospace.toml.pre-dev-setup-link.bak" ]] || {
    echo "expected aerospace backup"
    exit 1
  }

  [[ -f "$test_home/.wezterm.lua.pre-dev-setup-link.bak" ]] || {
    echo "expected wezterm backup"
    exit 1
  }
}

test_default_links
test_optional_links_and_backup

echo "link-configs tests passed"
