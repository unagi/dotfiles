export PATH=$HOME/.pyenv/bin:/usr/local/bin:$PATH
rbenv -v > /dev/null
if [ $? -eq 0 ]; then
    eval "$(rbenv init -)"
fi
pyenv -v > /dev/null
if [ $? -eq 0 ]; then
    eval "$(pyenv init -)"
fi

