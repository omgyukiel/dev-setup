# Setup validation

Validated on 2026-10-16 on the Apple Silicon work Mac, with a separate empty
HOME used to exercise the personal-Mac flow. No unit tests or test framework
are stored in this repository. Migration checks used disposable directories.

## Passed

- `brew bundle install --no-upgrade --file=Brewfile`: all 21 manifest entries
  were satisfied, including the Nerd Font, Node 24, uv, btop, and tlrc.
- `python3 scripts/verify-setup.py --packages --apps`: installed tools, six
  config links, syntax, plugin managers, tmux plugins, editor report, Ghostty
  config, AeroSpace config, and Git whitespace checks all passed.
- `scripts/bootstrap.sh --skip-packages` in an empty temporary HOME with a
  minimal environment: fresh public clones of Oh My Zsh, Powerlevel10k, TPM,
  and the configured tmux plugins; complete Neovim setup; exit status 0.
- Personal readiness verification with `--personal`: passed with no
  `~/.config/zsh/local.zsh` or copied work credentials.
- Personal interactive Zsh on a real pseudo-terminal: prompt, autosuggestions,
  highlighting, zoxide, fzf, and aliases loaded. Node came from the Homebrew
  Node 24 fallback; no OCI profile or active OKE cluster was inherited.
- Both editor setup reports: no missing plugins, all eight language/formatting
  tools installed, 26 requested syntax parsers available, and tmux navigation loaded.
  The repository's original Neovim plugin lockfile was not changed by bootstrap.
- Temporary migration checks: backups of files/directories/broken links,
  preservation of local settings, repeat-run idempotency, and relocating a
  checkout into a path containing spaces.
- Tmux clipboard binding: copy-mode `y` uses `copy-pipe-and-cancel pbcopy`.
  Theme and continuum autosave hooks coexist in the status bar.
- Existing work shell: NVM remains active and the optional local work integration
  still loads. Public plugin bootstrapping avoids Keychain credential-helper access.
- `tldr tmux`: first-use page cache download completed and command examples rendered.

## Limits and manual checks

This was not a pristine macOS install or a separate physical personal Mac. The
empty HOME used this Mac's installed Homebrew packages, system tools, apps and
OS permissions. Intel support is implemented through Homebrew prefix discovery
but has not been validated on an Intel Mac.

On the new Mac, install Command Line Tools and Homebrew first, sign into Codex
with the intended personal account, open AeroSpace and grant Accessibility, then
run the bootstrap and readiness checker there. Package and plugin downloads need
internet access; upstream versions can change after this validation date.

Font rendering, clipboard pasting into a real app, display arrangement, and the
feel of the shortcuts should be checked with docs/PRACTICE.md. No reboot or
live-session destruction was used to test tmux restoration. Resurrect restores
layouts and supported commands; it does not checkpoint arbitrary running processes.
