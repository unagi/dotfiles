#                             _             _
#                            (_)           | |
#     _   _ _ __   __ _  __ _ _     _______| |__  _ __ ___
#    | | | | '_ \ / _` |/ _` | |   |_  / __| '_ \| '__/ __|
#    | |_| | | | | (_| | (_| | |  _ / /\__ \ | | | | | (__
#     \__,_|_| |_|\__,_|\__, |_| (_)___|___/_| |_|_|  \___|
#                        __/ |
#                       |___/

# -----------------
# About Environment
# -----------------
source ~/dotfiles/zsh.d/util

if [ -x /usr/local/bin/brew ]; then
    BREW_PREFIX=`brew --prefix`
    fpath=($BREW_PREFIX/share/zsh/functions(N) $BREW_PREFIX/share/zsh/site-functions(N) $fpath)
    load_if_exists `brew --prefix`/etc/autojump.sh

    # for Java
    export JAVA_HOME=/Library/Java/Home
    export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8
else
    load_if_exists /usr/share/autojump/autojump.zsh
fi

export EDITOR=vim

bindkey -v

setopt auto_pushd
setopt pushd_ignore_dups

setopt auto_list
setopt list_packed
setopt print_eight_bit

# ------------
# Docker
# ------------
if [ -x "/cygdrive/c/Program Files/Boot2Docker for Windows/start.sh" ]; then
    alias boot2docker="/cygdrive/c/Program\ Files/Boot2Docker\ for\ Windows/start.sh"
fi

# ------------
# Load plugins
# ------------
source ~/dotfiles/zsh.d/history
source ~/dotfiles/zsh.d/prompt
source ~/dotfiles/zsh.d/ssh-agent

# ----------------
# About Completion
# ----------------
autoload -U compinit
compinit -u
setopt magic_equal_subst
setopt hist_expand
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:default' menu select=1

# for local settings
load_if_exists ~/.zshrc.mine


# -------------
# About aliases
# -------------
case "${OSTYPE}" in
    freebsd*|darwin*)
        alias ls='gls --color'
        eval `gdircolors -b`
        alias svn='colorsvn'
        alias safari='open -a Safari'
        alias diff='colordiff'
        ;;
    cygwin*)
        export CYGWIN="tty nodosfilewarning"
        alias ls='ls -F --color=auto'
        alias knife='c:/opscode/chef/bin/knife'
        WINCMD=(ipconfig netstat ping tracert)
        for i in $WINCMD; do
            alias $i="cocot $i"
        done
        alias open='explorer'
        ;;
    linux-gnu*)
        alias diff='colordiff'
        alias ls='ls -F --color=auto'
        alias pbcopy='xsel --clipboard --input'
        alias pbpaste='xsel --clipboard --output'
        ;;
    *)
        alias ls='ls -F --color=auto'
        ;;
esac
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias be='bundle exec'
alias history='history 1'
alias reload='source ~/.zshrc'
