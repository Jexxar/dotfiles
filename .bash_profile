### Exports for session ###
if [ -f "$HOME/.profile" ]; then
    . "$HOME/.profile"
fi

### Include .bashrc if it exists  ###
if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi


