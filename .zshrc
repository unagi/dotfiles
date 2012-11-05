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

setopt print_eight_bit

PS1='%{
%}%F{green}(%n@%m)[%h]%f %F{yellow}%{%}%~%{%}%f
$ '

case "${OSTYPE}" in
    freebsd*|darwin*)
        alias ls='ls -GF'
        ;;
    *)
        alias ls='ls -F --color=auto'
        ;;
esac
alias grep='grep --color=auto'

# for local settings
[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine

