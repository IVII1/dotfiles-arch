#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'
PS1='[\u@\h \W]\$ '
export PATH="/home/ivo/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/ivo/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
