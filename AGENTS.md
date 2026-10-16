# Working on this Mac setup

This repository is the source of truth for a personal macOS development setup.
Read README.md and docs/ONBOARDING.md before onboarding a machine. Use
docs/PRACTICE.md when teaching the workflow; the owner is learning tmux.

## Onboarding

- Confirm the machine is a Mac, locate this checkout, and inspect existing config
  links and local settings before running setup.
- Run `bash scripts/bootstrap.sh` for an authorized full setup. It installs the
  Brewfile without upgrading existing packages, clones missing shell/TPM managers,
  links configs with backups, and prepares the pinned Neovim environment.
- The bootstrap does not install Homebrew or Command Line Tools, grant macOS
  permissions, change login shell, Git identity, credentials, or launch GUI apps.
  Help the user complete those explicit prerequisites as needed.
- On a personal Mac, leave `~/.config/zsh/local.zsh` absent. No employer account,
  VPN, private registry, YubiKey, SSH key, or cloud CLI is required.
- On an existing work Mac, preserve that optional local file exactly. Do not copy
  it, SSH/OCI/Docker credentials, environment files, or tokens into this repo.
- Validate with `python3 scripts/verify-setup.py --packages`; after the user opens
  AeroSpace and enables Accessibility, also use `--apps`.
- Report what actually passed and what requires a person or a separate Mac.
  Never describe an isolated HOME check as a pristine operating-system install.

## Maintaining configs

- Edit the linked repo files. Keep machine-specific setup outside Git.
- Keep Option shortcuts for AeroSpace, Ctrl-B as the tmux prefix, and Ctrl-H/J/K/L
  for Neovim/tmux navigation. Use tmux windows as tabs inside a single Ghostty tab.
- Preserve the saved Powerlevel10k layout; make color changes in the overlay.
- Do not replace the Neovim lockfile with unrequested plugin updates. The bootstrap
  uses a scratch lockfile for first-start setup and restores the recorded pins.
- Keep the personal baseline small. Add packages to Brewfile or Brewfile.shell
  and document their purpose. No work-only dependencies in those manifests.
- No unit-test files or test framework in this dotfiles repo. If needed, exercise
  migration/backup behavior in disposable directories outside the checkout.
- Readiness checks are in scripts/verify-setup.py; they are diagnostics, not tests.
- Before committing, check the diff, validate modified config syntax, inspect for
  secrets/machine-specific paths, and verify active links. Commit or push only
  when the user requests it; do not merge their branch on their behalf.

Official background on repository instructions:
https://learn.chatgpt.com/docs/agent-configuration/agents-md
