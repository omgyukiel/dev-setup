# Portable shell settings. Machine-specific access setup lives outside Git.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

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
  [[ ! -r /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme ]] || source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
fi

HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt share_history hist_expire_dups_first hist_ignore_dups hist_verify
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

[[ ! -r "$HOME/.config/zsh/local.zsh" ]] || source "$HOME/.config/zsh/local.zsh"
if [[ -r "$HOME/.bash_completions/caa-kubectx.sh" ]]; then
  autoload -Uz bashcompinit && bashcompinit
  source "$HOME/.bash_completions/caa-kubectx.sh"
fi

alias ro='rg'
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

[[ ! -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] || source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# Load highlighting last, after all other line-editor widgets.
[[ ! -r /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] || source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
