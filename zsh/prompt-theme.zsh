# Load the original wizard configuration, then optionally apply only colors.
function _dev_setup_prompt_apply() {
  [[ ! -r "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"
  if [[ "$DEV_SETUP_PROMPT_THEME" == tokyo-night ]]; then
    source "$DEV_SETUP_ZSH_DIR/themes/tokyo-night.zsh"
  fi
  (( ! $+functions[p10k] )) || p10k reload
  return 0
}

# Persist the choice outside Git; the saved wizard config stays unchanged.
function prompt-theme() {
  if (( $# != 1 )) || [[ "$1" != (original|tokyo-night) ]]; then
    print 'Usage: prompt-theme original|tokyo-night'
    return 1
  fi
  mkdir -p "$HOME/.config/zsh" || return
  print -r -- "$1" >| "$HOME/.config/zsh/prompt-theme" || return
  typeset -g DEV_SETUP_PROMPT_THEME=$1
  _dev_setup_prompt_apply
}

typeset -g DEV_SETUP_PROMPT_THEME=tokyo-night
if [[ -r "$HOME/.config/zsh/prompt-theme" ]]; then
  DEV_SETUP_PROMPT_THEME=$(<"$HOME/.config/zsh/prompt-theme")
fi
[[ "$DEV_SETUP_PROMPT_THEME" == (original|tokyo-night) ]] || DEV_SETUP_PROMPT_THEME=tokyo-night
_dev_setup_prompt_apply
