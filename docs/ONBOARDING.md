# Onboard a personal Mac

This setup works without the work laptop's local settings. Clone it anywhere;
symlinks are calculated from the checkout's actual path, not a fixed username.
Apple Silicon is the validated target. The scripts also locate Intel Homebrew,
but an Intel Mac has not been exercised with this configuration.

## Prerequisites

1. Install Apple's Command Line Tools if Git is missing: `xcode-select --install`.
2. Install Homebrew using the instructions at https://brew.sh.
3. Install/open Codex separately and sign in with your personal account. Do not
   bring over work credentials or work MCP configuration.
4. Clone this repository. After the `ghostty` branch is merged into `main`:

   ```bash
   mkdir -p ~/pers
   git clone https://github.com/omgyukiel/dev-setup.git ~/pers/dev-setup
   cd ~/pers/dev-setup
   ```

   Before the merge, use:

   ```bash
   git clone --branch ghostty https://github.com/omgyukiel/dev-setup.git ~/pers/dev-setup
   ```
   Private repository access, if applicable, requires your own GitHub sign-in.

## Let Codex do the setup

Open the cloned folder as the project in Codex and send:

> Set up this personal Mac using this repo. Read AGENTS.md and docs/ONBOARDING.md.
> Inspect existing configs, preserve local settings, then run the bootstrap and
> readiness checks. Do not install or copy work-specific tools or credentials.
> Help me finish the macOS permission steps, then walk me through docs/PRACTICE.md.

AGENTS.md gives Codex project instructions; the prompt supplies the setup request.
The instructions are local to this repo and are not symlinked into global Codex
settings. See the [official instructions guide](https://learn.chatgpt.com/docs/agent-configuration/agents-md).

## Or run setup yourself

```bash
bash scripts/bootstrap.sh
python3 scripts/verify-setup.py --packages --personal
```

The bootstrap:

- Installs shared Brewfile dependencies without upgrading already installed tools.
- Clones missing Oh My Zsh, Powerlevel10k, and TPM; existing clones are left alone.
- Links all six configs, backing up replaced files under
  `~/.local/state/dev-setup/backups/`.
- Installs tmux plugins directly from public URLs without a credential helper, leaving live sessions alone.
- Prepares LazyVim from the recorded lockfile, installs its language tools and
  syntax parsers, and saves diagnostics under `~/.local/state/dev-setup/`.
- Leaves `~/.config/zsh/local.zsh` alone. A personal Mac does not need that file.

`--skip-packages` skips Homebrew installation when dependencies are already
available. `--skip-editor` defers Neovim setup; rerun without that option later.
Network access is required for package/plugin downloads. Downloads and external
package registries may fail independently; errors point to local diagnostic logs.

Node 24 is provided by Homebrew for editor/npm tools. The shell uses it only when
no Node is already available, so a working NVM configuration retains priority.
`uv` is included for Python projects; it can download a project Python when needed.
The Nerd Font cask supplies icon glyphs. If icons show squares, use Ghostty's font
picker/list to select `MesloLGS Nerd Font`; the saved font size and colors remain
independent. No global Git username or email is assumed: configure your personal
identity yourself before committing projects.

## Finish the interactive steps

1. Open Ghostty and a new shell. If your account is not using zsh, run
   `chsh -s /bin/zsh` yourself and reopen the terminal.
2. Open AeroSpace. Enable it in **System Settings → Privacy & Security → Accessibility**.
3. Run `python3 scripts/verify-setup.py --packages --apps --personal`.
4. Work through docs/PRACTICE.md to check fonts, navigation, clipboard, and workflow.

The setup does not grant OS permissions or change login items outside the saved
AeroSpace `start-at-login` configuration. Opening AeroSpace activates that config.

## Ghostty tabs and AeroSpace

Native macOS tabs may appear as separate windows to a tiling manager. The default
workflow here is one native Ghostty tab per window, with tmux windows as tabs.
No forced-floating rule is installed. Ghostty documents potential workarounds at
https://ghostty.org/docs/help/macos-tiling-wms if native tabs are preferred later.

## Recovery and reruns

- Running the bootstrap again preserves matching links and existing plugin clones.
- Config backups stay outside Git. To restore a previous config, remove its
  symlink and move the corresponding backup back to the original location.
- The bootstrap does not uninstall tools, reset SSH agents, authenticate work
  services, or merge/push changes automatically.
- Keep this checkout in place: moving/deleting it breaks existing absolute links.
  If you move it, rerun `bash scripts/link-configs.sh --all` from its new location.
- Run the readiness checker after pulling changes. Re-run the bootstrap if the
  package list or plugin dependencies changed.
