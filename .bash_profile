### Exports for session ###
if [ -f ~/.profile ]; then
    . ~/.profile
fi

### Include .bashrc if it exists  ###
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
