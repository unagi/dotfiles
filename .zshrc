autoload -U compinit
compinit

bindkey -v

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt share_history

setopt auto_pushd

setopt correct
setopt list_packed

autoload predict-on
predict-on

alias ls='ls --color'
alias grep='grep --color=auto'
