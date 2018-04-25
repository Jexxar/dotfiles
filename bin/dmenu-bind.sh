#!/bin/bash
exe=`dmenu_path | dmenu_run -l 5 -i -fn ubuntu-8 -nb '#EEEEEE' -nf '#474747' -sb '#868686' -sf '#FEFEFE'` 
eval "exec ${exe}"
