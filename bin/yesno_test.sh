#!/bin/bash
 
#####################################
##### FUNCTIONS
#####################################
 
# --------------------------------
#  a Yes No question function using a while loop
# --------------------------------
function YesNoQuestion () {
    Usage="Usage : YesNoQuestion <Question> <default answer>"
    if (( "$#" != "2" )) ; then
        echo -e "${Usage}" && return 1
    fi
 
    local question="${1}"
    local default="${2}"
    local yes_RETVAL="0"
    local no_RETVAL="3"
    local RETVAL=""
    local answer=""
 
    while true ; do
        read -p "${question} (${default}) ? " answer
 
        case ${answer:=${default}} in # This where we define (and use) the default value for $answer
            Y|y|YES|yes|Yes )
                RETVAL=${yes_RETVAL} && \
                break                  # This is how we get off the loop
                ;;
            N|n|NO|no|No )
                RETVAL=${no_RETVAL} && \
                break
                ;;
            * )
                echo "Please provide a valid answer (y or n)"   # Note the lack of "break" here
                ;;                                              #+ which keep us inside the loop
        esac                                                    #+ until a valid answer if given
    done
    return ${RETVAL}
}

# --------------------------------
# a Yes No question function using a select loop
# --------------------------------
function SelectYesNo () {
    Usage="Usage : SelectYesNo <Question> <default answer>"
    if (( "$#" != "2" )) ; then
        echo -e "${Usage}" && return 1
    fi
    
    local old_PS3="${PS3}"
    local PS3='---> '
    local question="${1}"
    local default="${2}"
    local yes_RETVAL="0"
    local no_RETVAL="3"
    local cancel_RETVAL="4"
    local RETVAL=""
    local answer=""

    echo "${question} ? (${default})"
    select answer in "Yes" "No" "Cancel"; do
        case ${answer} in
            Yes ) 
                RETVAL="${yes_RETVAL}" && break
                ;;
            No )
                RETVAL="${no_RETVAL}" && break
                ;;
            Cancel ) 
                RETVAL="${cancel_RETVAL}" && break
                ;;
            * ) 
                echo "Please provide a valid answer (1,2 or 3)"
        esac
    done
    PS3="${old_PS3}"
    return ${RETVAL}
}
 
#####################################
##### MAIN
#####################################
 
echo "> Question yes no demo..."
echo
YesNoQuestion "Do you like it" "yes"
Yesno_RETVAL="$?"
if [[ ${Yesno_RETVAL} -eq 0 ]] ; then
    # run the YES action here
    echo "yes> ... "
elif [[ ${Yesno_RETVAL} -eq 3 ]] ; then
    # run the NO action here
    echo "no> ... "
else
    # error handling here
    echo "error> ... "
fi
echo " "
echo "> ... demo finished"

echo "> Selection yes no demo..."
echo
SelectYesNo "Do you like it" "yes"
Yesno_RETVAL="$?"
if [[ ${Yesno_RETVAL} -eq 0 ]] ; then
    # run the YES action here
    echo "yes> ... "
elif [[ ${Yesno_RETVAL} -eq 3 ]] ; then
    # run the NO action here
    echo "no> ... "
elif [[ ${Yesno_RETVAL} -eq 4 ]] ; then
    # run the NO action here
    echo "cancel> ... "
else
    # error handling here
   echo "error> ... "
fi
echo " "
echo "demo finished"
echo "> ... exiting script" && exit 0