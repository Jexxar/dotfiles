#! /bin/bash
if [ $UID -gt 999 ]; then
    export PATH="~/bin:~/.local/bin:/usr/local/bin:/usr/local/sbin:$PATH"
else
    export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
fi