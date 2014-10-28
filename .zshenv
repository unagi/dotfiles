export PATH=$HOME/.pyenv/bin:$HOME/.rbenv/bin:/usr/local/bin:$PATH:~/bin
which rbenv > /dev/null
if [ $? -eq 0 ]; then
    eval "$(rbenv init -)"
fi
which pyenv > /dev/null
if [ $? -eq 0 ]; then
    eval "$(pyenv init -)"
fi

