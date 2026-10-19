# Shared reference, available both inside and outside tmux.
function tmux-help() {
  command cat "$DEV_SETUP_ZSH_DIR/../tmux/shortcuts.txt"
}

# A session option survives detach/attach and is shared by all its panes.
# Run before the instant prompt so this output does not trigger a P10k warning.
function _dev_setup_tmux_welcome() {
  [[ -o interactive && -n "$TMUX" && -n "$TMUX_PANE" ]] || return 0
  local session shown
  session=$(command tmux display-message -p -t "$TMUX_PANE" '#{session_id}' 2>/dev/null) || return 0
  shown=$(command tmux show-options -qv -t "$session" @dev_setup_shortcuts_shown 2>/dev/null) || return 0
  [[ "$shown" != 1 ]] || return 0
  command tmux set-option -t "$session" @dev_setup_shortcuts_shown 1 2>/dev/null || return 0
  tmux-help
}
_dev_setup_tmux_welcome
unfunction _dev_setup_tmux_welcome
