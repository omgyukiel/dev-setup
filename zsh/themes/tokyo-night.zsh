# Tokyo Night-inspired colors for the saved Classic Powerlevel10k layout.
# Palette: https://github.com/folke/tokyonight.nvim
# This is a custom color overlay, not an upstream Powerlevel10k preset.
typeset -g POWERLEVEL9K_BACKGROUND='#24283b'
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND='#bb9af7'
typeset -g POWERLEVEL9K_DIR_FOREGROUND='#7aa2f7'
typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND='#a9b1d6'
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND='#7dcfff'
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#9ece6a'
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#7aa2f7'
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#e0af68'
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND='#9ece6a'
typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND='#9ece6a'
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND='#f7768e'
typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND='#f7768e'
typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND='#f7768e'
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='#9ece6a'
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='#f7768e'
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#e0af68'
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND='#7dcfff'
typeset -g POWERLEVEL9K_TIME_FOREGROUND='#a9b1d6'
typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND='#bb9af7'
typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#bb9af7'
typeset -g POWERLEVEL9K_NVM_FOREGROUND='#9ece6a'

# The wizard's custom Git formatter embeds colors; adapt its output without
# changing branch/status logic or the saved wizard file.
if (( $+functions[my_git_formatter] )); then
  functions[_dev_setup_original_git_formatter]=$functions[my_git_formatter]
  function my_git_formatter() {
    _dev_setup_original_git_formatter "$@"
    my_git_format=${my_git_format//\%246F/\%F\{#a9b1d6\}}
    my_git_format=${my_git_format//\%244F/\%F\{#565f89\}}
    my_git_format=${my_git_format//\%76F/\%F\{#9ece6a\}}
    my_git_format=${my_git_format//\%178F/\%F\{#e0af68\}}
    my_git_format=${my_git_format//\%39F/\%F\{#7aa2f7\}}
    my_git_format=${my_git_format//\%196F/\%F\{#f7768e\}}
  }
fi
