#1630360162
gtk-query-settings
#1633547996
detox -vr ./*
#1634070541
ip route list
#1634326881
mmv -m "Track\ *.mp3" "0#1.mp3"
#1635466689
ulimit -a
#1635643541
openssl s_client -servername $DOM -connect $DOM:$PORT | openssl x509 -noout -dates
#1636974941
./Google\ Meet 
#1640767242
xdg-mime query default application/pdf
#1640772215
xdg-mime query default x-scheme-handler/magnet
#1642460398
du -sc * |sort -g
#1644805908
vainfo
#1660818199
sudo service iptables save
#1663294247
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
#1664290564
sudo rkhunter --versioncheck
#1665099799
LC_ALL=C sudo -l
#1665540076
sudo iptables -L
#1665797706
sudo ntpdate -qu pool.ntp.br
#1665973947
mmv -c "Track\ *.mp3" "0#1.mp3"
#1667006708
XDG_UTILS_DEBUG_LEVEL=2 xdg-mime query default audio/x-mpegurl
#1667083391
sudo logrotate -f /etc/logrotate.conf 
#1667182086
jigdo-lite firmware-11.5.0-amd64-netinst.jigdo 
#1667791937
dpkg --get-selections 
#1667934420
sudo vigr
#1667934728
sudo vigr -s
#1668019658
sudo chown -cR usuario:usuario .
#1668077859
sudo tune2fs -l /dev/sda7
#1668649012
xev -event button | grep button
#1668811375
sudo dbus-cleanup-sockets
#1668842747
gtk-launch --help
#1669091687
sudo fuser -v /dev/snd/*
#1669094564
fuser -v /dev/snd/*
#1669282777
sudo -l
#1669325463
printenv DBUS_SESSION_BUS_ADDRESS
#1669425564
awk '{ print $0 }' /sys/class/power_supply/ADP*/online
#1669529349
gsettings get org.mate.power-manager sleep-display-ac
#1669606526
whereis xflux
#1669606829
dbus-update-activation-environment --all
#1669723537
sudo ufw app list
#1669725214
sudo ufw default allow outgoing
#1669725232
sudo ufw default deny incoming
#1669733601
eval \`dbus-launch --auto-syntax\`
#1669777530
systemctl --user show-environment -l 
#1670478340
xprop -root _NET_CURRENT_DESKTOP
#1680489598
smem -t -P py
#1680491890
sudo sysctl -p
#1680493114
smem -t -P google-chrome
#1680493124
smem -t -P chrome
#1683860043
lynx gopher://slackjeff.com.br
#1684824805
sudo ufw allow from 10.0.0.0/24 proto tcp to any port 80,443
#1686929507
sudo ufw allow from 10.0.0.0/24 proto udp to any port 853
#1686929574
sudo ufw allow from 10.0.0.0/24 proto tcp to any port 22
#1686929648
sudo ufw allow from 10.0.0.0/24 proto tcp to any port 53
#1686929682
sudo ufw allow from 10.0.0.0/24 proto tcp to any port 853
#1686929724
sudo ufw delete 5
#1686941289
sudo ufw status numbered
#1687993279
sudo systool -vm drm_kms_helper
#1688019321
sudo ufw deny from 192.168.0.1 to 224.0.0.1
#1688481705
jigdo-lite debian-testing-amd64-netinst.jigdo 
#1688605709
curl -sL https://nextdns.io/install
#1688606710
nextdns help
#1688606826
sudo nextdns config set -cache-size=10MB
#1688606876
sudo nextdns config set -max-ttl=5s
#1688607202
sudo nextdns start
#1688607210
sudo nextdns activate
#1688607236
ss -tulpan
#1688607385
dig +nocmd www.linux.com +noall +answer
#1688607421
dig @127.0.0.1 -p5333 +nocmd www.linux.com +noall +answer
#1688845097
dig +dnssec gnupg.net
#1689224529
systemctl --user status 
#1689275340
systemctl --user disable gvfs-gphoto2-volume-monitor.service
#1689720495
sudo grep -iR "tmpfiles-setup" /var/log/*.log
#1690217635
keychain --quiet --eval
#1690234853
smem -t -P librewolf
#1690247473
lwp-request -fm GET linux.org
#1690248253
sudo tc -s qdisc show dev wlp2s0
#1690308379
tc -s qdisc
#1690396379
loginctl show-session $(loginctl | grep "$USER" | awk '{print $1}') -p Type
#1690396493
loginctl show-session $(loginctl | grep "$USER" | awk '{print $1}')
#1690612833
sudo systemctl daemon-reload
#1690631900
nextdns config list
#1690631998
nextdns config set
#1690650479
sudo tc qdisc replace dev wlp2s0 root cake diffserv3 triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms raw overhead 0 
#1690650493
tc qdisc show
#1690962089
ping -M do -c 4 -M do www.debian.org
#1690990871
sudo nping --udp --traceroute -c 13 -p 53 scanme.nmap.org
#1690990925
sudo nping --udp --traceroute -c 13 -p 53 debian.org
#1691120156
sudo udevadm control --reload
#1691177691
amixer get Master | tail -n 1 | awk -F ' ' '{print $5}' | tr -d '[]%'
#1691515531
pgrep -a -u "${USER}" gpg-agent
#1691516505
eval `ssh-agent`
#1691541654
tail /var/log/syslog
#1691546863
sudo lsof +c 0 -i TCP -s TCP:LISTEN
#1691905402
tmux attach-session -t se01
#1691906965
sudo iptables-save 
#1691934352
tmux new -s se01
#1692062540
tput setaf 1
#1692070527
env | grep XDG
#1692070935
sudo systemctl restart lightdm
#1692129550
scm_prompt_char_info 
#1692207191
sudo systemctl stop nextdns 
#1692207206
sudo systemctl start nextdns 
#1692207360
sudo systemctl restart dnsmasq
#1692207376
sudo systemctl status dnsmasq
#1692208639
sudo systemctl status nextdns 
#1692211927
systemctl --user import-environment PATH DISPLAY XAUTHORITY
#1692300479
dig txt canonical.com
#1692587420
tune2fs -l /dev/sda6
#1692587431
sudo tune2fs -l /dev/sda6
#1692631710
sudo ss -plantu
#1692643914
sudo setfacl -m "u:syslog:rw-" /var/log/daemon.log 
#1692643939
sudo setfacl -m "g:adm:rw-" /var/log/daemon.log 
#1692644003
sudo setfacl -m "o:r--" /var/log/daemon.log 
#1692644023
sudo getfacl /var/log/daemon.log 
#1692644072
sudo setfacl -m "g:rw-" /var/log/daemon.log 
#1692644105
sudo setfacl -m "g:adm:rw-" /var/log/dmesg 
#1692644121
sudo setfacl -m "o:r--" /var/log/dmesg 
#1692644131
sudo getfacl /var/log/dmesg 
#1692649126
sudo xauth -f /root/.Xauthority add $(xauth list $DISPLAY)
#1693185895
curl ipinfo.io/ip
#1694037060
fuser -v /home/
#1694037214
sudo fuser -v /home/
#1694037282
sudo fuser -v /
#1696043562
ps -axf -weo pid,rss,pmem,vsize,uname:50,pcpu,start_time,state,group,cputime,session,nice,%cpu,%mem,bsdtime,user,command
#1696051288
ping -c 10 -s.2 canonical.com
#1699904286
sudo mount -o remount,size=128M /dev/shm
#1701959980
pulseaudio --cleanup-shm
#1702710586
sudo openvpn node-us-142.protonvpn.net.udp.ovpn 
#1703648489
find /sys/class/power_supply -name BAT* -exec cat {}/capacity \;
#1703847676
nc -vv -l -p 12345 -e /bin/bash
#1705618947
wget -q -O - checkip.dyndns.org
#1707544465
su -
#1711707677
sudo journalctl --flush --rotate && sudo journalctl --flush --rotate --vacuum-time=1s --vacuum-size=10K
#1711707686
sudo journalctl -xe
#1714647820
sudo ufw deny proto tcp from 192.168.0.1 to any port 32768:60999
#1714647870
sudo ufw deny proto udp from 192.168.0.1 to any port 32768:60999
#1714941607
sudo find /var/log/. -type f -name "*.log.*gz*" -ls
#1715757054
sudo find /var/log/. -type f -name "*.log.*gz*" -delete
#1715757078
sudo find /var/log/. -type f -name "*.log.*" -ls
#1715757086
#1715787939
sudo find /var/log/. -type f -name "*.gz*" -ls
#1715788099
sudo find /var/log/. -type f -name "*.gz*" -delete
#1715788134
sudo find /var/log/. -type f -name "*.1*" -ls
#1715788160
sudo find /var/log/. -type f -name "*.1*" -delete
#1715834066
sudo ufw allow from 192.168.0.0/24 proto tcp to any port 80,443
#1715834100
sudo ufw allow from 192.168.0.0/24 proto tcp to any port 853
#1715834117
sudo ufw allow from 192.168.0.0/24 proto tcp to any port 53
#1715834126
sudo ufw allow from 192.168.0.0/24 proto udp to any port 853
#1715834133
sudo ufw allow from 192.168.0.0/24 proto udp to any port 53
#1715834167
sudo ufw allow from 192.168.0.0/24 proto tcp to any port 22
#1715834759
sudo grep -E -o 'SRC=([0-9]{1,3}[\.]){3}[0-9]{1,3}' /var/log/ufw.log | awk -F'=' '{ print $2 }' | sort -u
#1715834787
sudo ufw show listening
#1716422519
dpkg --list | grep "rc"
#1716422828
dpkg --list | awk '$1 == "rc" {print $0}'
#1718516022
zramctl 
#1718528617
sudo  iotop -o -b | grep -i kworker
#1718755401
sudo iotop -oa
#1718770948
watch 'cat /proc/meminfo
#1718815726
xset -q | grep -A "^Pointer"
#1718817776
sudo modprobe -rv psmouse; sudo modprobe -v psmouse
#1718817846
mv /etc/modprobe.d/psmouse.conf  /root
#1718817975
libinput-list-devices 
#1718818066
udevadm info -q all -n /dev/input/event12
#1718832297
udevadm info -q all -n /dev/input/event7
#1719102856
LC_ALL=C vmstat
#1719105843
LC_ALL=C vmstat -a -S M
#1719106157
LC_ALL=C sudo systemctl list-unit-files | grep enabled
#1719106484
LC_ALL=C sudo cat /proc/zoneinfo 
#1719106732
LC_ALL=C sudo sysctl -a | grep vm.zone_reclaim_mode
#1719106897
LC_ALL=C sudo hdparm -t /dev/sda
#1719107028
LC_ALL=C sudo cat /sys/block/sda/queue/scheduler
#1719107899
LC_ALL=C sudo cat /sys/block/sda/queue/iosched/slice_idle
#1719107998
LC_ALL=C sudo wdctl 
#1719538377
sudo grep "" /sys/block/*/queue/scheduler
#1719717000
sudo systool -m i915 -av
#1719724492
sudo cat /proc/cmdline 
#1720167773
smem -t -P openbox
#1720197903
curl wttr.in?format=p1 | grep -v "HELP"
#1720426059
arping -bf -I wlp2s0 -s 192.168.0.100 -U 192.168.0.1
#1721468871
LC_ALL=C gpg --refresh-keys 
#1721469227
LC_ALL=C gpg --list-keys | awk '/^pub.* \[expired\: / {id=$2; sub(/^.*\//, "", id); print id}' | fmt -w 999 | sed 's/^/gpg --delete-keys /;'
#1721469367
gpg --list-keys | awk '/^pub.* \[expired\: / {id=$2; sub(/^.*\//, "", id); print id}' | fmt -w 999 | sed 's/^/gpg --delete-keys /;'
#1721860478
cat ultimate.txt | sed 's/local=\//==address==/g' | sed 's/\//\/127.0.0.1/g' | sed 's/==address==/address=\//' > ulttmp.txt
#1722146965
curl -L https://test.nextdns.io
#1722147692
sudo nextdns cache-keys
#1722149319
dig @127.0.0.1 -p5333 +nocmd +noall +answer canonical.com
#1722149474
dig @127.0.0.1 -p5333 +nocmd +noall +answer +multiline canonical.com
#1722303969
sudo systemctl restart nextdns 
#1722844813
nslookup webupd8.org
#1723013298
LC_ALL=C mpstat -P ALL
#1723015339
LC_ALL=C sensors
#1723171917
cat /proc/$(pgrep librewolf)/smaps | grep -i pss |  awk '{Total+=$2} END {print Total/1024" MB"}'
#1723172870
free -h && sudo sysctl -w vm.drop_caches=3 && sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches && free -h
#1723173160
dpkg -l | awk '/^rc/ {print $2}' | xargs --no-run-if-empty sudo dpkg --purge
#1723370265
LC_ALL=C sudo sysctl -p
#1723552027
dig +nocmd canonical.com +noall +answer
#1724293630
LC_ALL=C find . -maxdepth 1 -name "*" -ls | awk 'BEGIN { OFS="\t" }; {print $3,$5,$6,$7,$8,$9,$10,$11}'
#1726379858
sudo find /var/log/. -type f -name "*.log.*" -delete
#1728291739
systemctl list-unit-files --state=enabled
#1731128809
sudo dpkg --add-architecture i386
#1731311930
/home/usuario/Workspace/dev/shell/mysuspenduntil suspend "today 10:00" 
#1739880375
ps ax -weo pid,rss,vsize,uname:32,pcpu,start_time,state,group,nice,cputime,session,cmd
#1743237185
mpv --vo=help
#1744146088
affuse .local/share/vm/T1/T1.vmdk .local/var/vmdk
#1744146148
fdisl -l .local/var/vmdk/T1.vmdk.raw 
#1744146158
fdisk -l .local/var/vmdk/T1.vmdk.raw 
#1744146307
echo 2099200*512 | bc
#1744146639
mount -o ro,loop,offse=1074790400 .local/var/vmdk/T1.vmdk.raw .local/var/vmdisk
#1744146661
sudo mount -o ro,loop,offse=1074790400 .local/var/vmdk/T1.vmdk.raw .local/var/vmdisk
#1744146760
mount -o ro,loop,offset=1074790400 .local/var/vmdk/T1.vmdk.raw .local/var/vmdisk
#1744146766
sudo mount -o ro,loop,offset=1074790400 .local/var/vmdk/T1.vmdk.raw .local/var/vmdisk
#1744147443
sudo mkdir -p /mnt/vmdk
#1744147533
sudo losetup /dev/loop0 .local/share/vm/T1/T1.vmdk 
#1744147593
sudo parted /dev/loop0
#1744147949
sudo affuse .local/share/vm/T1/T1.vmdk /mnt/vmdk
#1744147983
sudo ls /mnt/vmdk 
#1744148021
sudo losetup /dev/loop0 /mnt/vmdk/T1.vmdk.raw
#1744148260
sudo losetup -o 1074790400 /dev/loop0 /dev/loop1
#1744148310
sudo losetup -o 1074790400 /dev/loop0 /dev/loop2
#1744148664
sudo losetup -o 1074790400 /mnt/vmdk/T1.vmdk.raw /dev/loop1
#1744149607
sudo losetup -o 1074790400 /mnt/vmdk/T1.vmdk.raw /dev/loop0
#1744149650
sudo mount -o ro,loop,offset=1074790400 /mnt/vmdk/T1.vmdk.raw /mnt/vmdisk
#1744151828
sudo umount /mnt/vmdisk/
#1744152074
sudo lsof -D /mnt/vmdisk/
#1744152159
sudo lsof +D /mnt/vmdisk/
#1744152206
sudo umount -d -f /mnt/vmdisk/
#1744152295
sudo fusermount -u /mnt/vmdk/T1.vmdk.raw
#1744591431
export PROMPT_COMMAND="__powerline_prompt_command;history -a; history -r;echo -e '\033]0;Terminal\007'"
#1744764537
dig domain.nxdomain +noall +answer +comments
#1744767758
dig +trace +cmd +all +answer +multiline canonical.com
#1745785453
sudo strace -p 2942 -s9999 -e trace= -e write=3
#1745786340
sudo lsof -w +E -p 2942 -ad 0-2
#1745787374
rkhunter --help
#1745790878
sudo rkhunter --check -sk
