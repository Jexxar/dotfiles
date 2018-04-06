#!/bin/bash
#exe=`dmenu_path | dmenu_run  -l 5  -i  -fn sans-8 -nb '#EEEEEE' -nf '#474747' -sb '#868686' -sf '#FEFEFE'` #&& eval "exec $exe"
#echo "$exe"
####!/bin/bash
exe=`dmenu_path | dmenu -b -nb '#151617' -nf '#d8d8d8' -sb '#d8d8d8' -sf '#151617'` && eval "exec $exe"