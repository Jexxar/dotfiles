#!/usr/bin/env bash

# common functions for pipe menus
# required awk, bc

# urlencode <string>
function urlencode() {
    local old_lc_collate=$LC_COLLATE
    LC_COLLATE=C
    
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
    
    LC_COLLATE=$old_lc_collate
}

# Using awk and hexdump
function url_encode() {
    local encodedurl="$1";
    
    #[ ! -x "/usr/bin/hexdump" ] && { return; }
   
    encodedurl=$(echo $encodedurl | hexdump -v -e '1/1 "%02x\t"' -e '1/1 "%_c\n"' | LANG=C awk '
     $1 == "20"                    { printf("%s",   "+"); next } # space becomes plus
     $1 ~  /0[adAD]/               {                      next } # strip newlines
     $2 ~  /^[a-zA-Z0-9.*()\/-]$/  { printf("%s",   $2);  next } # pass through what we can
                                   { printf("%%%s", $1)        } # take hex value of everything else
    ')
    echo -e "$encodedurl"
}

# raw urlencode for GNU systems only
function rawurlencode() {
    local string="${1}"
    echo -e "$string" | od -An -tx1 | tr ' ' % | xargs printf "%s"
    #echo -ne "$string" | tr -d '\n' | xxd -plain  | sed 's/\(..\)/%\1/g'
}

# urldecode <string>
function urldecode() {
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

function esc_enc() {
    local aux="$*"
    local daux=""
    # only escape if string needs it
    case "$aux" in    # only escape if string needs it
        *\&*|*\<*|*\>*|*\"*|*\'*)
            #daux=$( echo "$aux" | sed "s/\&/\&amp;/g;s/</\&lt;/g;s/>/\&gt;/g;s/\"/\&quot;/g;s/'/\&apos;/g;" | sed 's/\&apos;/\&apos;\&quot;\&apos;\&quot;\&apos;/g;' )
            daux=$( echo "$aux" | sed "s/\&/\&amp;/g;s/</\&lt;/g;s/>/\&gt;/g;s/\"/\&quot;/g;s/'/\&apos;/g;" )
        ;;
        *) daux=$aux;;
    esac
    echo "$daux"
    return 0
}

function esc_space() {
    local aux="$*"
    local daux=""
    daux=$(echo "$aux" | sed "s/ /\\\ /g;")
    echo "$daux"
    return 0
}

# find JPG type icon path
function findJPGPath(){
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo ""
        return 1
    fi
    local iconJPG="${2}.jpg"
    cd "${1}"
    find . -name "${iconJPG}" | grep "16" | cut -c 2- | tail -n 1
    return 0
}

# find PNG type icon path
function findPNGPath(){
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo ""
        return 1
    fi
    local iconPNG="${2}.png"
    cd "${1}"
    find . -name "${iconPNG}" | grep "16" | cut -c 2- | tail -n 1
    return 0
}

# find SVG type icon path
function findSVGPath(){
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo ""
        return 1
    fi
    local iconSVG="${2}.svg"
    cd "${1}"
    find . -name "${iconSVG}" | cut -c 2- | tail -n 1
    return 0
}

function findIconThemeName(){
    local tn=""
    tn=$(gsettings get org.mate.interface icon-theme | tr -d "'")
    [ -z "$tn" ] && tn=$(gsettings get org.gnome.desktop.interface icon-theme | tr -d "'")
    echo "$tn"
    return 0
}

function findIconThemePath(){
    if [ -z "$1" ]; then
        echo ""
        return 1
    fi
    local tn="$1"
    local tp=""
    tp="/usr/share/icons/$tn"
    
    if [ -d "$tp" ]; then
        echo "$tp"
        return 0
    else
        tp="$HOME/.icons/$tn"
        if [ -d "$tp" ]; then
            echo "$tp"
            return 0
        fi
    fi
    echo ""
    return 1
}

function FindIconPath(){
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo ""
        return 1
    fi
    
    local tp="$2"
    local nip=""
    
    nip=$(findSVGPath "$tp" "${1}")
    [ -z "$nip" ] && nip=$(findPNGPath "$tp" "${1}")
    [ -z "$nip" ] && nip=$(findJPGPath "$tp" "${1}")
    if [ -z "$nip" ]; then
        echo ""
        return 1
    fi
    
    echo "$tp$nip"
    return 0
}

function FallbackiconPath(){
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo ""
        return 1
    fi
    
    local tp="$2"
    local seaDirs=( $(grep "nherit" "$tp/index.theme" | cut -d"=" -f2 | xargs -d ",") )
    local tp=""
    local iconPath=""
    
    for i in "${seaDirs[@]}"; do
        tp=$(findIconThemePath "$i");
        iconPath=$(FindIconPath "$1" "$tp");
        #echo "o i = $i e o tp = $tp e o iconName=$1  e o iconPath = $iconPath"
        if [ ! -z "$iconPath" ]; then
            echo "$iconPath"
            return 0
        fi
    done
    echo ""
    return 1
}

function iconPath(){
    if [ -z "$1" ]; then
        echo ""
        return 1
    fi
    
    local themePath=""
    local iconPath=""
    local themeName=""
    
    themeName=$(findIconThemeName)
    themePath=$(findIconThemePath "$themeName")
    
    if [ -z "$themePath" ]; then
        echo ""
        return 1
    fi
    
    iconPath=$(FindIconPath "$1" "$themePath");
    
    if [ -z "$iconPath" ]; then
        iconPath=$(FallbackiconPath "$1" "$themePath")
        if [ -z "$iconPath" ]; then
            echo ""
            return 1
        fi
    fi
    
    echo "$iconPath"
    return 0
}

function awkRound () {
    awk 'BEGIN{printf "%."'$1'"f\n", "'$2'"}'
}

function menuBegin() {
    echo "<openbox_pipe_menu>"
}

function menuEnd() {
    echo "</openbox_pipe_menu>"
}

function menuSep() {
    if [ -z "$1" ]; then
        echo "<separator />"
    else
        echo "<separator label=\"$*\"/>"
    fi
}

function menuItem() {
    if [ ! -z "$3" ]; then
        echo "<item label=\"$1\" icon=\"$(iconPath "$3")\">  <action name=\"Execute\"><command>$2</command></action> </item>"
    elif [ ! -z "$2" ]; then
        echo "<item label=\"$1\"> <action name=\"Execute\"><command>$2</command></action> </item>"
    else
        echo "<item label=\"$1\"/>"
    fi
}

function subMenuBegin() {
    if [ ! -z "$3" ]; then
        echo "<menu id=\"$1\" icon=\"$(iconPath "$3")\" label=\"$2\" >"
    elif [ ! -z "$2" ]; then
        echo "<menu id=\"$1\" label=\"$2\">"
    fi
}

function subMenuActionExec() {
    if [ ! -z "$1" ]; then
        echo "<action name=\"Execute\">"
        echo "<execute> $1 </execute>"
        echo "</action>"
    fi
}

function subMenuExec() {
    if [ ! -z "$4" ]; then
        echo "<menu id=\"$1\" icon=\"$(iconPath "$4")\" label=\"$2\" execute=\"$3\" />"
    elif [ ! -z "$3" ]; then
        echo "<menu id=\"$1\" label=\"$2\" execute=\"$3\" />"
    fi
}

function subMenuEnd() {
    echo "</menu>"
}

