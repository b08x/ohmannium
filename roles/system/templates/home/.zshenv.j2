local _old_path="$PATH"

# Local config
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local

if [[ $PATH != $_old_path ]]; then
  # `colors` isn't initialized yet, so define a few manually
  typeset -AHg fg fg_bold
  if [ -t 2 ]; then
    fg[red]=$'\e[31m'
    fg_bold[white]=$'\e[1;37m'
    reset_color=$'\e[m'
  else
    fg[red]=""
    fg_bold[white]=""
    reset_color=""
  fi

  cat <<MSG >&2
${fg[red]}Warning:${reset_color} your \`~/.zshenv.local' configuration seems to edit PATH entries.
Please move that configuration to \`.zshrc.local' like so:
  ${fg_bold[white]}cat ~/.zshenv.local >> ~/.zshrc.local && rm ~/.zshenv.local${reset_color}

(called from ${(%):-%N:%i})e

MSG
fi

unset _old_path

useditor() {
  export EDITOR="$@"
  export GIT_EDITOR="$@"
  export SVN_EDITOR="$@"
  export GIT_EDITOR="$@"
}

export TEMP="/tmp"

export TERM="xterm-256color"
export TERMINAL="xterm-256color"
export TERMCMD="$TERMINAL"

export NO_AT_BRIDGE=1
export QT_SCALE_FACTOR=1.0
export QT_FONT_DPI=96
export QT_QPA_PLATFORMTHEME=qt5ct
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

export LADSPA_PATH="/usr/lib/ladspa"
export LADSPA_RDF_PATH="/usr/share/ladspa/rdf"
export ECASOUND=ecasound
export RAY_PARENT_SCRIPT_DIR="$HOME/Sessions/ray-scripts"

if [[ ! -n $EDITOR ]]; then useditor micro; fi

if [ -x "$(command -v google-chrome-stable)" ]; then
export BROWSER="google-chrome-stable"
fi

if [ -x "$(command -v most)" ]; then
export PAGER=most
fi

if [ -x $(command -v hostname) ]; then
export HOSTNAME=$(hostname)
fi

# gum options
export GUM_SPIN_SPINNER="pulse"
export GUM_SPIN_ALIGN="right"
export GUM_SPIN_SHOW_OUTPUT=true
export GUM_SPIN_SPINNER_FOREGROUND=033
export GUM_SPIN_TITLE_FOREGROUND=024

export GUM_CHOOSE_CURSOR="> "
export GUM_CHOOSE_CURSOR_PREFIX="[ ] "
export GUM_CHOOSE_SELECTED_PREFIX="[✓] "
export GUM_CHOOSE_UNSELECTED_PREFIX="[ ] "
export GUM_CHOOSE_CURSOR_FOREGROUND=046
export GUM_CHOOSE_ITEM_FOREGROUND=045
export GUM_CHOOSE_SELECTED_FOREGROUND=027

export GUM_CONFIRM_PROMPT_FOREGROUND=027
export GUM_CONFIRM_SELECTED_FOREGROUND=064
export GUM_CONFIRM_UNSELECTED_FOREGROUND=010

# fzf options
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' --color='bg:#141414,bg+:#3F3F3F,info:#BDBB72,border:#6B6B6B,spinner:#98BC99' --color='hl:#719872,fg:#bbb12a,header:#719872,fg+:#D9D9D9' --color='pointer:#E12672,marker:#E17899,prompt:#98BEDE,hl+:#98BC99''
