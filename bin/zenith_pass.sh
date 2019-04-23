#!/usr/bin/env bash
ENTRY=`zenity --password --username --text="Entre com o usuário e senha" --title=Authentication`

#ENTRY=`zenity --password`

case $? in
         0)
	 	echo "User Name: `echo $ENTRY | cut -d'|' -f1`"
	 	echo "Password : `echo $ENTRY | cut -d'|' -f2`"
		;;
         1)
                echo "Stop login.";;
        -1)
                echo "An unexpected error has occurred.";;
esac
