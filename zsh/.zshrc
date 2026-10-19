# Portable shell settings. Machine-specific access setup lives outside Git.
if (( $+commands[brew] )); then
  eval "$(brew shellenv)"
elif [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
typeset -g DEV_SETUP_BREW_PREFIX=${HOMEBREW_PREFIX:-/opt/homebrew}

if [[ -r ${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  autoload -Uz compinit && compinit
  [[ ! -r "$DEV_SETUP_BREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme" ]] || source "$DEV_SETUP_BREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"
fi

HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt share_history hist_expire_dups_first hist_ignore_dups hist_verify
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

[[ ! -r "$HOME/.config/zsh/local.zsh" ]] || source "$HOME/.config/zsh/local.zsh"
# A personal Mac needs no local file or NVM installation for Node-based tools.
if ! (( $+commands[node] )) && [[ -x "$DEV_SETUP_BREW_PREFIX/opt/node@24/bin/node" ]]; then
  export PATH="$DEV_SETUP_BREW_PREFIX/opt/node@24/bin:$PATH"
fi
if [[ -r "$HOME/.bash_completions/caa-kubectx.sh" ]]; then
  autoload -Uz bashcompinit && bashcompinit
  source "$HOME/.bash_completions/caa-kubectx.sh"
fi

alias ro='rg'
alias tn='tmux new-session -A -s'
alias ta='tmux attach -t'
if (( $+commands[eza] )); then
  alias ls='eza --icons=always'
  alias ll='eza --icons=always --long --git'
  alias la='eza --icons=always --long --all --git'
fi
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
  alias cd='z'
fi
if (( $+commands[fzf] )); then
  # Ctrl-R: history; Ctrl-T: files. Leave Option shortcuts for AeroSpace.
  export FZF_ALT_C_COMMAND=''
  eval "$(fzf --zsh)"
fi

# Resolve the symlink so theme files are found alongside this repo's .zshrc.
typeset -g DEV_SETUP_ZSH_DIR=${${(%):-%x}:A:h}
source "$DEV_SETUP_ZSH_DIR/prompt-theme.zsh"

[[ ! -r "$DEV_SETUP_BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] || source "$DEV_SETUP_BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
# Load highlighting last, after all other line-editor widgets.
[[ ! -r "$DEV_SETUP_BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] || source "$DEV_SETUP_BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
