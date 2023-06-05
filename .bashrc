
### BASHRC  ###


### SOME-RANDOM-STUFF ###

[[ $- != *i* ]] && return

### ALIAS ###

alias ls='exa -lah'
alias ..='cd ..'
alias grep='grep --color=auto'
alias cat='bat'

### PROMPTS ###

GREEN="\[$(tput setaf 2)\]"
RESET="\[$(tput sgr0)\]"
PS1="${GREEN}\W ${RESET}> "

### EXPORTS ###

export PATH=/home/$USER/Dmenu-scripts:$PATH
export PATH=/home/$USER/bin:$PATH
export MANPAGER=bat
export BROWSER=brave
export PDF_OPENER=zathura

### VI-MODE ###

#set -o vi

### OTHER STUFF ###

#[ -n "$XTERM_VERSION" ] && transset-df --id "$WINDOWID" >/dev/null

### END ###
