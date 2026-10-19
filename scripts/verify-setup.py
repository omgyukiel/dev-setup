#!/usr/bin/env python3
"""Read-only readiness checks; no work accounts or credentials are required."""
import argparse
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys

repo = Path(__file__).resolve().parents[1]
home = Path.home()
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--packages', action='store_true', help='Also check Homebrew manifest coverage')
parser.add_argument('--apps', action='store_true', help='Also validate Ghostty and the running AeroSpace app')
parser.add_argument('--personal', action='store_true', help='Require absence of machine-specific shell settings')
args = parser.parse_args()
failures = []

def check(condition, message):
    print(('PASS: ' if condition else 'FAIL: ') + message)
    if not condition:
        failures.append(message)

def run(command):
    return subprocess.run(command, text=True, capture_output=True)

brew = shutil.which('brew')
if not brew:
    brew = next((str(p) for p in [Path('/opt/homebrew/bin/brew'), Path('/usr/local/bin/brew')] if p.exists()), None)
if brew:
    prefix = run([brew, '--prefix']).stdout.strip()
    # Neovim has a Node runtime even when invoked outside an interactive NVM shell.
    os.environ['PATH'] = prefix + '/bin:' + os.environ.get('PATH', '')
    if not shutil.which('node'):
        os.environ['PATH'] = prefix + '/opt/node@24/bin:' + os.environ['PATH']
check(bool(brew), 'Homebrew is available')
for tool in ['git', 'zsh', 'tmux', 'nvim', 'node', 'npm', 'zoxide', 'eza', 'fzf', 'rg', 'bat', 'fd', 'btop', 'tldr', 'tree-sitter', 'lazygit', 'uv']:
    check(bool(shutil.which(tool)), tool + ' is available')

targets = {
    '.zshrc': 'zsh/.zshrc', '.p10k.zsh': 'zsh/.p10k.zsh', '.tmux.conf': 'tmux/tmux.conf',
    '.config/nvim': 'nvim', '.config/aerospace/aerospace.toml': 'aerospace/aerospace.toml',
    'Library/Application Support/com.mitchellh.ghostty/config.ghostty': 'ghostty/config.ghostty',
}
for target, source in targets.items():
    p = home / target
    check(p.is_symlink() and p.resolve() == repo / source, target + ' links to this checkout')

for relative in ['scripts/bootstrap.sh', 'scripts/link-configs.sh']:
    check(run(['/bin/bash', '-n', str(repo / relative)]).returncode == 0, relative + ' syntax')
for relative in ['zsh/.zshrc', 'zsh/.p10k.zsh', 'zsh/prompt-theme.zsh', 'zsh/tmux-help.zsh', 'zsh/themes/tokyo-night.zsh']:
    check(run(['/bin/zsh', '-n', str(repo / relative)]).returncode == 0, relative + ' syntax')
for relative in ['.oh-my-zsh', '.oh-my-zsh/custom/themes/powerlevel10k', '.tmux/plugins/tpm']:
    check((home / relative / '.git').exists(), relative + ' installed')
plugins = re.findall(r"^set -g @plugin '([^']+)'", (repo/'tmux/tmux.conf').read_text(), re.M)
for plugin in plugins:
    check((home/'.tmux/plugins'/plugin.rsplit('/', 1)[-1]/'.git').exists(), plugin + ' installed')

report_path = home/'.local/state/dev-setup/editor-setup.json'
try:
    report = json.loads(report_path.read_text())
    check(not report['errors'] and not report['missing_plugins'] and report['navigation']
          and all(report['tools'].values()) and report['parser_count'] > 0, 'editor setup report is successful')
except (OSError, ValueError, KeyError):
    check(False, 'editor setup report exists; run scripts/bootstrap.sh to create it')
if args.personal:
    check(not (home/'.config/zsh/local.zsh').exists(), 'personal setup needs no local/work shell file')
if args.packages and brew:
    result = run([brew, 'bundle', 'check', '--no-upgrade', '--file=' + str(repo/'Brewfile')])
    check(result.returncode == 0, 'Brewfile dependencies installed')
    if result.returncode:
        print(result.stdout + result.stderr)
if args.apps:
    ghostty = Path('/Applications/Ghostty.app/Contents/MacOS/ghostty')
    check(ghostty.exists() and run([str(ghostty), '+validate-config']).returncode == 0, 'Ghostty config validates')
    aero = shutil.which('aerospace')
    check(bool(aero) and run([aero, 'reload-config', '--no-gui', '--dry-run', '--warnings-as-errors']).returncode == 0,
          'AeroSpace running with valid config (requires Accessibility permission)')
check(run(['git', '-C', str(repo), 'diff', '--check']).returncode == 0, 'Git whitespace check')
print('\n' + (f'{len(failures)} check(s) failed.' if failures else 'All requested setup checks passed.'))
sys.exit(bool(failures))
