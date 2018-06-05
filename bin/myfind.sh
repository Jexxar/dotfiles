#!/bin/bash

if [[ -n $(find . -name ${1} -print0) ]]; then
    find . -name ${1} -ls ;
else
	echo "Arquivo nao encontrado";
fi

