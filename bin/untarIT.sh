#!/bin/bash
numberArgs=$#

#zenity --error --text="$#"
if [ $? -gt 0 ]; then
    zenity --error --text="No files found"
    exit 1
fi
#zenity --error --text="$numberArgs"
#zenity --list --text="$@"

for (( i=1; i<=$numberArgs; i++ )); do
    #"# ${1##*/}"
    #zenity --error --text="$i";
    test="# ${1##*/}"
    #zenity --error --text="${1}";
    #zenity --error --text="$test";

    n=0
    while case "$test" in (*tar.gz*)
        tar -zxvf "${1}";
        #zenity --error --text="$test";
        test=${test#*tar.gz};;(*) ! :
        ;;
    esac; do n=$(($n+1)); done

    n=0
    while case "$test" in (*tgz*)
        tar -zxvf "${1}";
        #zenity --error --text="$test";
        test=${test#*tgz};;(*) ! :
        ;;
    esac; do n=$(($n+1)); done

    n=0
    while case "$test" in (*tar.bz2*)
        tar -jxvf "${1}";
        #zenity --error --text="$test";
        test=${test#*tar.bz2};;(*) ! :
        ;;
    esac; do n=$(($n+1)); done
    
    n=0
    while case "$test" in (*tar.xz*)
        tar -Jxvf "${1}";
        #zenity --error --text="$test";
        test=${test#*tar.xz};;(*) ! :
        ;;
    esac; do n=$(($n+1)); done
    
    #sleep 0.5 
    shift 1
done

#for f in *.tar.gz; do echo "$f";  done
#for f in *.tar.gz; do echo "$f"; tar -zxvf "$f"; done
#for f in *.tgz; do echo "$f"; tar -zxvf "$f"; done
#for f in *.tar.bz2; echo "$f"; do tar -jxvf "$f"; done
#for f in *.tar.xz; echo "$f"; do tar -Jxvf "$f"; done

#zenity --info --text="Done!"

