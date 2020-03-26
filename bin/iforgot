#!/usr/bin/env bash
# This bash source file is for functions showing you
# samples of code that you always forget.

# <<EOF expands heredoc, <<"EOF" leaves it as is.

iforgot-htmlize-my-code() {
    echo "man code2html"
}

iforgot-mount-options-for-my-flash-stick() {
    echo "mount -t vfat -o user,rw,fmask=0111,dmask=0000,codepage=866,nls=iso8859-5,utf8,noexec"
}

iforgot-uname-opts() {
    for i in a s n r v m p i o; do
        echo -e "\t-$i\t`uname -$i`"
    done
}

iforgot-check-gcc-options() {
    set -x
    gcc -Q -march=atom --help=target | grep fpmath
    gcc -Q --help=optimizers | grep enable
    set +x
}

iforgot-xkb-opts-retrieval-from-gnome2() {
    set -x
    gconftool-2 -R /desktop/gnome/peripherals/keyboard/kbd
    set +x
}

iforgot-xkb-opts() {
    set -x
    most /usr/share/X11/xkb/rules/evdev.lst
    set +x
}

iforgot-android-screenshot-via-sdk() {
    echo "ddms"
}

iforgot-load-all-possible-sensors-modules() {
cat <<"EOF"
for i in `modprobe -l | sed -rn 's|.*/hwmon/([^/]+)$|\1|p'`; do
    modprobe $i
done
EOF
}

iforgot-fsck-force-check() {
    echo -e "\\t touch /forcefsck"
}

iforgot-make-a-debug-build() {
cat <<"EOF"
FEATURES="ccache nostrip" \
    USE="debug" \
    CFLAGS="…-ggdb" \
    CXXFLAGS="<CFLAGS>" \
    emerge $package
OR
    gdb --pid <pid>
    thread apply all bt
EOF
}

iforgot-read-via-x0() {
cat <<"EOF"
while IFS= read -r -d $'\0'; do
    echo "$REPLY"
done <  <(find -type f -print0)

(-d '' also works since \0 is a marker for an empty string.)
EOF
}

iforgot-where-is-my-completion() {
cat <<"EOF"
eselect bashcomp list --global
eselect bashcomp enable --global base
eselect bashcomp enable --global man
eselect bashcomp enable --global gentoo
env-update && . /etc/profile
EOF
}

iforgot-what-is-that-window-class() {
    echo -e "\\txprop"
}

iforgot-what-to-do-if-something-messed-the-fonts() {
cat <<"EOF"
xset +fp /usr/share/fonts/terminus && xset fp rehash
EOF
}

iforgot-extended-regex-purpose() {
    set -x
    shopt -s extglob && abc='000123' && echo ${abc##+(0)}
    set +x
}

iforgot-how-to-trace-and-debug() {
cat <<EOF
# Trace library and system calls:
strace -p PID
ltrace -p PID
# Look for opened files of process with pid PID
ls -l /proc/PID/fd/*
# Kill a process to see its core
kill -11 PID
EOF
}

iforgot-bookmarks-in-manpages() {
cat <<"EOF"
man -P 'most -p \"^\s+Colors\"' eix
EOF
}

iforgot-git-new-repo() {
cat <<"EOF"
git init
git remote add origin git@example.com:project_team.git ssh://git@example.com:port/reponame.git
git add .
git commit -m "fgsfds"
git push origin refs/heads/master:refs/heads/master
EOF
}

iforgot-select-figlet-font-for-me() {
cat <<"EOF"
echo '' > ~/cool_fonts
for i in `ls /usr/share/figlet/*flf`; do
    clear
    echo $i
    figlet -f $i -c 12345
    figlet -f $i -c 67890
    read -n1
    [ $REPLY = 'y' ] && echo $i>>~/cool_fonts
done
cat ~/cool_fonts
EOF
}

iforgot-draw-me-cool-figlet-fonts() {
cat <<"EOF"
for i in `cat ~/cool_fonts`; do
    echo $i
    figlet -f $i -c 12345
    figlet -f $i -c 67890
done
EOF
}

iforgot-chroot-procedure() {
cat <<"EOF"
mount -t proc none /mnt/chroot/proc
mount --rbind /sys /mnt/chroot/sys
mount --rbind /dev /mnt/chroot/dev
[linux32] chroot /mnt/chroot /bin/bash

    env-update && source /etc/profile
    export PS1="(chroot) $PS1"
    # mount /boot /usr etc.
    …
    exit

umount -l /mnt/chroot/proc
umount -l /mnt/chroot/dev{/pts,/shm}
umount -l /mnt/chroot/sys
EOF
}

iforgot-ordinary-user-groups() {
    echo -e "\tuseradd -m -G audio,cdrom,games,plugdev,cdrw,floppy,portage,usb,video,wheel -s /bin/bash username"
}

# SMART
iforgot-smart-immediate-check() {
    echo -e "\tsmartctl -H /dev/sdX"
}

iforgot-smart-selftest-short-now() {
    echo -e "\tsmartctl -t short /dev/sdX"
}

iforgot-smart-selftest-long-now() {
    echo -e "\tsmartctl -t long /dev/sdX"
}

iforgot-smart-selftest-long-later() {
    echo -e "\tsmartctl -t long -s L/../.././23"
}

iforgot-smart-selftest-sheduling-syntax() {
    echo -e "\t man -P\"most -p'^\s+-s REGEXP'\" smartd.conf"
}

iforgot-mark-bad-sector-with-badblocks() {
cat <<"EOF"
If situation looks like this
# smartctl -a /dev/sda
SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
…
  5 Reallocated_Sector_Ct   0x0033   099   099   036    Pre-fail  Always       -       61
…
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       1
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       1
…

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed: read failure       20%     22638         1670581106

    Then seeking for a badblock will look like that

badblocks -vs -b512 /dev/sda 1670581106 1670581106

-v – verbose, 
-s shows progress, 
-b is block size, 512 since 1670581106 is an LBA, i.e. sector address and sectors are usually are 512 bytes long.

First address is the end of the range where badblocks seek, and the last one  points at the start of the range. 
Also there are useful -n and -w options which mutually exclude themselves
-n safely rewrites block’s contents
-w rewrites it with binary patterns and causes data loss. 
By default badblocks does only read-only check (that works for me).

If it confirms the sector is truly bad, then we need to get the address in blocks on your partition,
the offset, an pass it as the number of block as your filesystem understands, usually it is multiple of 512, e.g. 4096.

fdisk /dev/sda
    
   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *          63       80324       40131   83  Linux
/dev/sda2           80325   104952644    52436160   83  Linux
/dev/sda3       104952645   109161674     2104515   83  Linux
/dev/sda4       109162496  1953525167   922181336   83  Linux

So, the problem LBA belongs to /dev/sda4, now get the offset on that partition.

echo 'scale=3;(1690581106-109162496)/8' | bc results in 195177326.25

Fraction part means it is the second sector of eight in that block. (Since one block of 4096 bytes contains 8*512 bytes sectors, 1/8 is 0.125 and 2/8 is 0.25)
The formula is:

<bad_LBA> - <start_LBA_of_its_partition> / (<fs_block_size> / <sector_size>)

So, produce the list:

echo '(1690581106-109162496)/8' | bc > /tmp/bb_list

And call e2fsck

umount /<mountpoint for partiton with bad LBA>
e2fsck -l /tmp/bb_list /dev/sdX

If e2fsck called with -L option instead of -l, the passed file will rewrite all the list of badblocks contained in the filesystem.
That list can be checked with:

dumpe2fs -b /dev/sda4
EOF
}

# Wi-Fi
iforgot-wifi-connect() {
cat <<"EOF"
iwconfig wlp2s0 essid <point name> mode managed key s: <password>
ifconfig wlp2s0 <ip address> netmask <mask>
EOF
}

iforgot-wifi-scan() {
    echo -e "\tiwlist wlp2s0 scanning"
}

iforgot-ffmpeg-2-pass-vbr-encoding() {
cat <<"EOF"
ffmpeg -y -i "$input_file" -an -pass 1 -threads 3 \
       -vcodec libx264 -vpre slow_firstpass "$tmpfile"

ffmpeg -y -i "$input-file" \
       -acodec libfaac -ar 44100 -ab 192k \
       -pass 2 -threads 3 \
       -vcodec libx264 -b 2000k -vpre slow "$tmpfile" "$output-file"
EOF
}

iforgot-tee-usage() {
cat <<"EOF"
wget -O - http://example.com/dvd.iso | tee dvd.iso | sha1sum > dvd.sha1
wget -O - http://example.com/dvd.iso | tee >(sha1sum > dvd.sha1) >(md5sum > dvd.md5) > dvd.iso
tardir=your-pkg-M.N
tar chof - "$tardir" | tee >(gzip -9 -c > your-pkg-M.N.tar.gz) | bzip2 -9 -c > your-pkg-M.N.tar.bz2
EOF
}

iforgot-emoji-drawing() {
cat <<"EOF"
▽△　▲▼    sankaku
☆★＊      hoshi
〆        shime
米※       kome
益        yaku

⚈д⚈ ⌕…⌕ °ヮ° ´Д` ╭(＾▽＾)╯ /(⌃ o ⌃)\ ╰(^◊^)╮ ◜(◙д◙)◝

キタ━━━(゜∀゜)━━━!!!!!   ‘It’s here’, Kitaa!, a general expression
                        of excitement that something has appeared
                        or happened or ‘I came’.
(・∀・)~mO               Flash of intuition
m9(・∀・)                NO U
ヽ(°Д°)ﾉ
(╬♉益♉)ﾉ
Ԍ──┤ﾕ(#◣д◢)
(☞ﾟヮﾟ)☞
( `-´)>                 Salute
(*ﾟﾉOﾟ)<ｵｵｵｵｫｫｫｫｫｫｫｰｰｰｰｰｲ!  Calling out, "Ooooi!"
Σ(゜д゜;)             Shocked
(*´Д`)ﾊｧﾊｧ               Erotic stirring, haa haa
(ﾟДﾟ;≡;ﾟДﾟ)
（･∀･)つ⑩
щ(ﾟДﾟщ)(屮ﾟДﾟ)屮          Come on
（・Ａ・)                ‘That’s bad’
(*⌒▽⌒*)
＼| ￣ヘ￣|／＿＿＿＿＿＿＿θ☆( *o*)/    Kick
(l'o'l)                 Shocked
(╯°ロ°）╯  ┻━━┻
┬──┬ ﻿ノ( ゜-゜ノ)
EOF
}

iforgot-sed-newline-simple-removal() {
cat<<"EOF"
    echo -e '1\n2\n3\n4\n5' | sed -rn '1h; 2,$ H; ${x;s/\n/---/g;p}'
EOF
}

iforgot-diff-patch() {
    echo -e "\tdiff -u file1 file2"
}

iforgot-gpg-privkey() {
cat <<"EOF"
Very good! 
Now, like I said above, using this is pretty much like using a “regular” GPG keypair; the only exception is when signing other people’s keys, 
or add or revoking subordinate keys. For this you build a command pointing to the two locations. 
For example,
    gpg --homedir /media/Secure/dotgnupg/ \
        --keyring ~/.gnupg/pubring.gpg \
        --secret-keyring ~/.gnupg/secring.gpg \
        --trustdb-name ~/.gnupg/trustdb.gpg \
        --edit-key MYKEYID

should allow you to add or revoke subordinate keypairs, or do any other operation that requires the private master key. You should keep in mind though, that changes to keys other than your own will be done on your “everyday” GPG folder (~/.gnupg), but changes to your own key—adding a new subkey, for example—will be done on the secure location (/media/Secure/dotgnupg). After doing such a change, you must export your key (in the example to the file aux.asc), and re-import it to the everyday GPG folder:

    gpg --homedir /media/Secure/dotgnupg/ \
        --output aux.asc \
        --armor \
        --export MYKEYID
    gpg --import aux.asc
    rm aux.asc
EOF
}

iforgot-io-monitoring() {
    echo "iotop"
}

iforgot-last-argument-passed-to-shell() {
    echo 'echo !$'
}

iforgot-qemu-create-image() {
cat <<EOF
qemu-img create -f qcow2 -o
        compat=1.1,
        cluster_size=512,
        preallocation=metadata,
        lazy_refcounts=on
    <filename> <size>
EOF
}

iforgot-du-sort() {
    echo -e '\tdu -hsx * | sort -h'
}

iforgot-fonts-list() {
    echo -e '\tfc-list'
}

iforgot-fsck-with-progressbar() {
cat<<EOF
fsck -C -l /dev/sdb3 -- -c -f -y
       \  \    \          \  \  \_ autoyes
        \  \    \          \  \_ check even if fs looks clean
         \  \    \          \_ check for bad blocks
          \  \    \_ partition with filesystem
           \  \_ lock the whole-disk device by an exclusive flock(2)
            \_ use progressbar/completion for checkers that support it
              (generally ext2/3/4)
EOF
}

iforgot-completion-keys() {
cat<<"EOF"
"\e@": complete-hostname
"\e{": complete-into-braces
"\e~": complete-username
"\e$": complete-variable
EOF
}

iforgot-shell-colours() {
cat <<"EOF"
There are only 8 colors in general. From man terminfo:
Color     #define         Value   RGB
black     COLOR_BLACK       0     0, 0, 0
red       COLOR_RED         1     max,0,0
green     COLOR_GREEN       2     0,max,0
yellow    COLOR_YELLOW      3     max,max,0
blue      COLOR_BLUE        4     0,0,max
magenta   COLOR_MAGENTA     5     max,0,max
cyan      COLOR_CYAN        6     0,max,max
white     COLOR_WHITE       7     max,max,max

Escape sequence to set a color is \e[00;3xm, where x is 0–7.
Some interesting capabilities:
EOF
    echo -e '   - \e[0;1mbold:\e[00m \\e[0;1m (in normal terminals bold replaced\n    with bright version of a color);'
    echo -e '   - \e[0;4munderline:\e[00m \\e[0;4m (dont expect that the line will be\n      of same color as the char above it);'
    echo -e '   - \e[07;36mreverse:\e[00m \\e[0;7m (background and foreground);'
    echo -e '   - stop: \\e[00m.\n'
    echo -e '   Example of \\e[01;32m\e[01;32mbold green text\e[00m\\e[00m.'

cat <<"EOF"
As far as I know, there’s no way to query the colors of the terminal emulator. 
You can change them with \e]4;NUMBER;#RRGGBB\a (where NUMBER is the terminal color number (0–7 for light colors, 8–15 for bright colors)
and #RRGGBB is a hexadecimal RGB color value) if your terminal supports that sequence (reference: ctlseqs). —http://unix.stackexchange.com/a/1772/10075
See also http://misc.flogisoft.com/bash/tip_colors_and_formatting
EOF
}

iforgot-webm-conversion() {
cat <<"EOF"
ffmpeg -threads 4 -i input.mov -acodec libvorbis -ac 2 -b:a 192k -ar 44100 -b:v 1000k -s 640x360 output.webm
EOF
}

iforgot-x264-conversion() {
cat <<EOF
ffmpeg -threads 4 -i input.mov -acodec libfaac -b:a 96k -vcodec libx264 -vpre slower -vpre main -level 21 -refs 2 -b:v 345k -bt 345k -threads 0 -s 640x360 output.mp4
EOF
}

iforgot-image-conversion() {
cat <<EOF
ffmpeg  -y -threads 4 -pattern_type glob \
        -framerate 1/5 -i "file_name_000*.png" \
        -c:v libvpx -r 1 -pix_fmt yuv420p out.webm

https://trac.ffmpeg.org/wiki/Create%20a%20video%20slideshow%20from%20images
EOF
}

iforgot-clean-gentoo() {
cat <<EOF
# Remove unnecessary packages
1. emerge -av --depclean
# …distfiles except matching by exact installed version
    and those downloaded earlier than two days ago.
    2w [eeks] 3m [onth] also accepted.
2. eclean-dist -d -t2d
# Remove binary packages
3. eclean packages
EOF
}

iforgot-cut-video-with-ffmpeg() {
cat <<EOF
ffmpeg -y -threads 8 -i in.webm -ss 00:00:01 -t 00:02:22 -async 1 -b:v 500k out.webm

+crop
    -filter:v "crop=WIDTH:HEIGHT:X_OFFSET:Y_OFFSET"

Webm issues: it ifnores -b:v -minrate -maxrate and -crf. Use -qmin and -qmax.
    ffmpeg -y -threads 8 -async 1 \
        -i /home/video/anime/\[ReinForce\]\ Ergo\ Proxy\ \(BDRip\ 1920x1080\ x264\ FLAC\)/\[ReinForce\]\ Ergo\ Proxy\ -\ 11\ \(BDRip\ 1920x1080\ x264\ FLAC\).mkv  -ss 00:00:00 \
        -t 00:00:15.849 -b:v 12M -crf 4 -minrate 12M -maxrate 12M -qmin 0 -qmax 0 -vf scale=1280:720 /tmp/out.webm
EOF
}

iforgot-catenate-video-with-ffmpeg() {
cat <<EOF
find . -iname "part*.webm" | sort >files
ffmpeg -y -threads 8 -f concat -i files -c copy -async 1 out.webm
EOF
}

iforgot-create-video-from-image-sequence-with-ffmpeg() {
cat <<EOF
ffmpeg -y -framerate 1/5 -pattern_type glob_sequence -i "./[Commie] Psycho-Pass 2 - 08 [A844F60A]_%*.png" -c:v libvpx -b:v 500k -r 30 -pix_fmt yuv420p out.webm && mpv out.webm'
Actually, someday they should fix -pattern_type glob and '*.png' and '%d'
EOF
}

iforgot-record-my-desktop() {
    set -x
    man -P"most -p'^\s*X11 grabbing'" ffmpeg
    set +x
}

iforgot-check-own-process-memory() {
cat <<EOF
pmap from procps.
# pmap -d `pidof X`
Writeable — this is it.
EOF
}

iforgot-commie-check-whats-up() {
    echo -e "\t.blame <what>"
}

iforgot-firefox-settings() {
cat <<EOF
See ~/.mozilla/profile.default/user.js
To check:
    about:cache
    about:cache?device=memory

In case of troubles with SWF
   echo 'application/x-shockwave-flash       swf swfl' > .mime.types
EOF
}


iforgot-mpv-crunchyroll-streaming() {
cat <<EOF
# requires ffmpeg to be compiled with networking and rtmp
mpv --ytdl http://www.crunchyroll.com/parasyte-the-maxim-/episode-1-metamorphosis-662583
EOF
}


iforgot-audio-recording() {
cat <<EOF
Record:
    arecord -f cd -t wav `date +s`.wav

Conversion to MP3 VBR
     ffmpeg -i 19122014.wav -codec:a libmp3lame -qscale:a 9 output.mp3
                                                          ^
                                                      lame quality

 lame    Avg    b/rate range  ffmpeg
option  kbit/s     kbit/s     option

-b 320   320      320 CBR     -b:a 320k (non VBR. NB this is 32KB/s, or its max)
-V 0     245      220-260     -q:a 0 (NB this is VBR from 22 to 26 KB/s)
-V 1     225      190-250     -q:a 1
-V 2     190      170-210     -q:a 2
-V 3     175      150-195     -q:a 3
-V 4     165      140-185     -q:a 4
-V 5     130      120-150     -q:a 5
-V 6     115      100-130     -q:a 6
-V 7     100       80-120     -q:a 7
-V 8      85       70-105     -q:a 8
-V 9      65        45-85     -q:a 9
EOF
}

iforgot-wcpe-station-time-zone-difference() {
    echo "-3"
}

iforgot-libreoffice-writer-images() {
cat <<"EOF"
When an image is inserted in a libreoffice writer document, lowriter uses 90 dpi by default. 
Thus, importing SVG file in GIMP it’s necesary to set corresponding dpi and count appropriate width according to that. 
GIMP advises 1000px width by default, but that gives 282.24 mm of width after import to libreoffice. 
ESPD doc width excluding fields is 180 mm. 
After import to lowriter, in the document body image will look awry even if you guess the 100 % scale right. 
But it only seems like it, after the export to PDF with lossless image compression it’ll look as it should.
EOF
}

iforgot-libreoffice-pdf-export() {
cat <<"EOF"
take off flag  embedding ODT when sending to potential employer.
set flag for PDF/A-1a, that format is for docs to be stored for a long term. Fonts are embedded.
EOF
}

iforgot-pdf-split() {
    echo -e '\t$ gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -dFirstPage=1 -dLastPage=4 -sOutputFile=outputT4.pdf T4.pdf'
}

iforgot-pdf-grep() {
cat <<"EOF"
find /path -name '*.pdf' -exec sh -c 'pdftotext "{}" - | grep --with-filename --label="{}" --color "your pattern"' \;
EOF
}

iforgot-ffmpeg-add-image-to-video() {
cat<<"EOF"
# Add five seconds of video
ffmpeg -loop 1 -f image2 -i image.png -r 30 -t 5 image.webm
# Create input file for ffmpeg
find -iname "*.webm" -printf "file '%p'\n" | sort >inp
# Catenating the files
ffmpeg -f concat -i inp -codec copy output.webm
EOF
}

iforgot-voip-via-netcat() {
cat <<"EOF"
(read; echo; rec --buffer 17 -q -w -s -r 48000 -c 1 -t raw -)|netcat -u -l -p 8888|(read; play -w -s -r 48000 --buffer 17 -t raw -)
(echo; rec --buffer 17 -q -w -s -r 48000 -c 1 -t raw -)|netcat -u 10.0.0.1 8888|(read; play -w -s -r 48000 --buffer 17 -t raw -)
EOF
}

iforgot-wget-mirror-site() {
cat <<"EOF"
wget --mirror --convert-links --adjust-extension --page-requisites --no-parent http://example.org'
or shorter:
wget -mkEpnp http://example.org
EOF
}

iforgot-wifi-why-it-doesnt-work() {
cat <<"EOF"
card is requiring CONFIG_CFG802011_WEXT=y
card is hw/soft bloced: rfkill list
card is in wrong CRDA region: iw reg get/set <AA>
EOF
}

iforgot-file-copier-with-progress-bar() {
cat <<"EOF"
Usage: rsync -vau
EOF
}

iforgot() {
    local keywords="$@"
    local myself=$0
    local out_file="/tmp/iforgot.txt"
    local searched=""
    local underwhat=""
    local astat=($(</proc/$$/stat))    # create an array
    local ppid=${astat[3]}
    local underwhat=$(ps -p $ppid -o comm=)
    [ "$keywords" ] || {
        keywords=$(yad --list --text="Choose one option" --title="Make a Choice" --center\
                     --on-top --height=360 --width=360 --separator="" --column="What have you forgot, darling?"\
                     `grep "^iforgot-" $myself | sed -e "s/iforgot-//g" -e "s/() {//g"| sort`)
        #read -p 'What have you forgot, darling? > '
        #local keywords="$REPLY"
        echo "Thanks, also you can use parameters to this function, like"
        echo -e "\tiforgot <what>\n"
    }
    if [ $? -gt 0 ] || [ -z "$keywords" ]; then
        return 1
    fi
    
    if [ -f "$out_file" ]; then
        rm -f "$out_file"
    fi

    for keyword in $keywords; do
        searched=$(declare -F | sed -nr 's/^declare -f (iforgot-.*'$keyword'.*)/\1/p') ;
        echo "$searched" > "$out_file"
        echo -e "\n" >> "$out_file"
        echo "$searched"
        eval "$searched" ;
        eval "$searched" >> "$out_file" ;
    done
    if [ -f "$out_file" ] && [ "$underwhat" != "bash" ]; then
        xdg-open "$out_file"
    fi
}

# call arguments verbatim:
iforgot $@ 
