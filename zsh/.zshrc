# Homebrew
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Completion
autoload -U compinit && compinit

if autoload -U +X bashcompinit; then
  bashcompinit
  [[ -r "${HOME}/.bash_completions/caa-kubectx.sh" ]] && source "${HOME}/.bash_completions/caa-kubectx.sh"
fi

# History setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# Arrow-key history search
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# Shell niceties, guarded so a missing package does not break startup.
[[ -r /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -r /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Eza (better ls)
if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons=always"
fi

# Zoxide (better cd)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias cd="z"
fi

# Disabled for this Ghostty setup:
# - Powerlevel10k instant prompt/theme and ~/.p10k.zsh
# - Old /Users/klevu SCM/Rancher Desktop paths
