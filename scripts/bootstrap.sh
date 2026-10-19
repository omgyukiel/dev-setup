#!/usr/bin/env bash
set -euo pipefail
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
skip_packages=0
skip_editor=0
for arg in "$@"; do
  case "$arg" in
    --skip-packages) skip_packages=1 ;;
    --skip-editor) skip_editor=1 ;;
    -h|--help)
      printf 'Usage: scripts/bootstrap.sh [--skip-packages] [--skip-editor]\n'
      printf 'Install shared Mac tools, clone missing plugin managers, link configs, and prepare Neovim.\n'
      exit 0 ;;
    *) printf 'Unknown option: %s\n' "$arg" >&2; exit 1 ;;
  esac
done
[[ "$(uname -s)" == Darwin ]] || { printf 'This setup targets macOS.\n' >&2; exit 1; }
command -v git >/dev/null || { printf 'Install Command Line Tools: xcode-select --install\n' >&2; exit 1; }
if ! command -v brew >/dev/null; then
  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "$candidate" ]]; then eval "$("$candidate" shellenv)"; break; fi
  done
fi
command -v brew >/dev/null || { printf 'Install Homebrew from https://brew.sh first, then rerun.\n' >&2; exit 1; }
eval "$(brew shellenv)"
if [[ "$skip_packages" -eq 0 ]]; then
  brew bundle install --no-upgrade --file="$repo_root/Brewfile"
fi
# Use a standalone Node for setup; leave the user's active NVM configuration alone.
export PATH="$(brew --prefix)/opt/node@24/bin:$PATH"
for tool in tmux nvim node; do
  command -v "$tool" >/dev/null || { printf 'Missing tool: %s. Run without --skip-packages.\n' "$tool" >&2; exit 1; }
done
clone_missing() {
  local url="$1" target="$2"
  if [[ -e "$target/.git" ]] && git -C "$target" rev-parse --verify HEAD >/dev/null 2>&1; then
    printf 'ok: %s already installed\n' "$target"
  elif [[ -e "$target" || -L "$target" ]]; then
    printf 'Existing non-Git path needs review: %s\n' "$target" >&2; return 1
  else
    mkdir -p "$(dirname "$target")"
    GIT_TERMINAL_PROMPT=0 git -c credential.helper= clone --depth 1 "$url" "$target"
  fi
}
clone_missing https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
clone_missing https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
clone_missing https://github.com/tmux-plugins/tpm.git "$HOME/.tmux/plugins/tpm"
bash "$repo_root/scripts/link-configs.sh" --all

# Clone public plugin URLs directly. TPM's downloader includes credentials in
# its fallback URL, which can consult Keychain even for public repositories.
while IFS= read -r plugin; do
  [[ -n "$plugin" ]] || continue
  clone_missing "https://github.com/$plugin.git" "$HOME/.tmux/plugins/${plugin##*/}"
done < <(sed -n "s/^set -g @plugin '\([^']*\)'.*/\1/p" "$repo_root/tmux/tmux.conf")

task_tmp="$(mktemp -d "${TMPDIR:-/tmp}/dev-setup-bootstrap.XXXXXXXX")"
cleanup() { rm -rf "$task_tmp"; }
trap cleanup EXIT

if [[ "$skip_editor" -eq 0 ]]; then
  state_dir="$HOME/.local/state/dev-setup"
  mkdir -p "$state_dir"
  # First-start dependency discovery can refresh lazy's lockfile. Use a scratch
  # copy and restore the original pins on the second pass, leaving Git untouched.
  export DEV_SETUP_LAZY_LOCKFILE="$task_tmp/lazy-lock.json"
  for pass in 1 2; do
    cp "$repo_root/nvim/lazy-lock.json" "$DEV_SETUP_LAZY_LOCKFILE"
    if ! nvim --headless '+Lazy! restore' +qa >"$state_dir/editor-restore-$pass.log" 2>&1; then
      printf 'Editor restore failed; see %s/editor-restore-%s.log\n' "$state_dir" "$pass" >&2
      exit 1
    fi
  done
  if ! nvim --headless "+luafile $repo_root/scripts/setup-editor.lua" >"$state_dir/editor-setup.log" 2>&1; then
    printf 'Editor setup failed; see %s/editor-setup.log\n' "$state_dir" >&2
    exit 1
  fi
fi
printf '\nSetup complete. Run: python3 scripts/verify-setup.py --packages\n'
printf 'Open Ghostty, start a new shell, and grant AeroSpace Accessibility access.\n'
printf 'Personal Mac: no local Oracle file, VPN, or work credentials are needed.\n'
