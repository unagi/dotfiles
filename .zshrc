if [ -x /usr/local/bin/brew ]; then
    BREW_PREFIX=`brew --prefix`
    fpath=($BREW_PREFIX/share/zsh/functions(N) $BREW_PREFIX/share/zsh/site-functions(N) $fpath)
    [[ -f `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
fi

autoload -U compinit
compinit

bindkey -v

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt share_history

setopt auto_pushd
setopt pushd_ignore_dups

setopt auto_list
setopt list_packed

setopt print_eight_bit

autoload -U colors
colors
PS1='%{
%}%F{green}(%n@%m)[%h]%f %F{yellow}%{%}%~%{%}%f
$ '

case "${OSTYPE}" in
    freebsd*|darwin*)
        alias ls='gls --color'
        eval `gdircolors -b`
        ;;
    *)
        alias ls='ls -F --color=auto'
        ;;
esac
alias grep='grep --color=auto'

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# for local settings
[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine

