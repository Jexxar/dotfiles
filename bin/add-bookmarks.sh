#!/usr/bin/env bash
PN=`basename "$0"`          # Program name

function hhelp {
    echo "usage: $1 "
    echo "   Add URLs in the foxy bookmark engine."
    echo "   Use foxy for further retrieve and manage bookmarks."
    echo " "
}

if [ ! $(command -v foxy) ]; then
    hhelp $PN
    exit 0
fi

#Games
foxy -a "https://www.friv.com/" @Games @friv
foxy -a "https://warpportal.com/" @Games @warpportal
foxy -a "https://www.callofwar.com/" @Games @callofwar
foxy -a "https://www.5.deltawars.com/" @Games @deltawars
foxy -a "https://github.com/igorko/flare-mod-noname" @Games @flare-mod-noname

#Desktop
foxy -a "http://conky.sourceforge.net/variables.html" @Desktop @conky-variables
foxy -a "http://www.makeuseof.com/" @Desktop @makeuseof
foxy -a "https://www.maketecheasier.com/" @Desktop @maketecheasier
foxy -a "https://github.com/eti0/dots" @Desktop @eti0-dots
foxy -a "https://github.com/addy-dclxvi/Openbox-Theme-Collections" @Desktop @addy-dclxvi/Openbox-Theme-Collections
foxy -a "https://sempreupdate.com.br/" @Desktop @sempreupdate
foxy -a "https://github.com/dylanaraps/openbox-patched" @Desktop @openbox-patched
foxy -a "https://github.com/rafaelmardojai/firefox-gnome-theme" @Desktop @firefox-gnome-theme
foxy -a "https://github.com/vinceliuice" @Desktop @vinceliuice
foxy -a "https://github.com/superna9999/urftopdf" @Desktop @urftopdf
foxy -a "https://github.com/lingtalfi/bashmanager" @Desktop @bashmanager
foxy -a "https://github.com/gautam1858/python-awesome" @Desktop @python-awesome
foxy -a "https://github.com/microhobby" @Desktop @microhobby
foxy -a "https://github.com/elenapan/dotfiles" @Desktop @elenapan-dotfiles
foxy -a "https://wiki.archlinux.org/index.php/Touchpad_Synaptics" @Desktop @Touchpad-Synaptics
foxy -a "https://github.com/pyllyukko/user.js/" @Desktop @pyllyukko-user-js
foxy -a "http://www.noobslab.com/" @Desktop @noobslab
foxy -a "https://www.myce.com/" @Desktop @myce
foxy -a "https://www.addictivetips.com/" @Desktop @addictivetips
foxy -a "https://paraisolinux.com/pseudo-tiling-en-openbox/" @Desktop @pseudo-tiling-en-openbox
foxy -a "https://superuser.com/questions/900315/is-there-any-way-i-can-force-firefox-to-not-cache-redirects-301-and-302" @Desktop @force-firefox-to-not-cache
foxy -a "https://www.lifewire.com/beginners-guide-to-conky-4043352" @Desktop @beginners-guide-to-conky
foxy -a "http://terminal.sexy/" @Desktop @terminal-sexy
foxy -a "http://dotshare.it/" @Desktop @dotshare-it
foxy -a "http://www.softpanorama.org/index.shtml" @Desktop @softpanorama


#Dev
foxy -a "http://matt.might.net/articles/ssh-hacks/" @Dev @matt-might-ssh-hacks
foxy -a "https://firejail.wordpress.com/features-3/" @Dev @firejail-features
foxy -a "http://krypted.com/commands/linux-bash-commands/" @Dev @krypted-linux-bash-commands
foxy -a "http://www.greenend.org.uk/rjk/tech/shellmistakes.html" @Dev @greenend-shellmistakes
foxy -a "https://aticleworld.com/" @Dev @aticleworld
foxy -a "http://zhar.net/" @Dev @zhar
foxy -a "https://linuxconfig.org/bash-scripting-tutorial" @Dev @bash-scripting-tutorial
foxy -a "https://www.ibm.com/support/knowledgecenter/pt-br/SSEPGG_10.1.0/com.ibm.db2.luw.qb.server.doc/doc/t0008238.html" @Dev @ibm-knowledgecenter
foxy -a "http://www.devpy.me/" @Dev @devpy
foxy -a "http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02" @Dev @opengroup-onlinepubs
foxy -a "http://coldattic.info/post/7/" @Dev @coldattic
foxy -a "https://aticleworld.com/flexible-array-member/" @Dev @aticleworld-flexible-array-member
foxy -a "https://www.quirksmode.org/html5/tests/video.html" @Dev @html5-tests-video
foxy -a "https://blog.famzah.net/" @Dev @famzah
foxy -a "http://tldp.org/LDP/abs/html/index.html" @Dev @ldp-org-LDP-index
foxy -a "http://www.dns-sd.org/ServiceTypes.html" @Dev @dns-sd-org-ServiceTypes
foxy -a "http://www.networkinghowtos.com/howto/category/linux/" @Dev @networkinghowtos
foxy -a "https://software-carpentry.org/lessons/" @Dev @software-carpentry
foxy -a "http://www.tekdefense.com/" @Dev @tekdefense
foxy -a "https://open-cobol.sourceforge.io/faq/" @Dev @open-cobol
foxy -a "http://thehackernews.com/" @Dev @thehackernews
foxy -a "https://ibcomputing.com/" @Dev @ibcomputing
foxy -a "https://opensource.com/article/19/7/get-modular-python-functions" @Dev @get-modular-python-functions
foxy -a "https://vitux.com/compiling-your-first-qt-program-in-ubuntu/" @Dev @your-first-qt-program-in-ubuntu
foxy -a "http://bytefreaks.net/tag/bash" @Dev @bytefreaks
foxy -a "https://devhints.io/bash" @Dev @devhints
foxy -a "https://wiki.bash-hackers.org/commands/classictest" @Dev @bash-hackers
foxy -a "https://www.panix.com/~elflord/unix/bash-tute.html" @Dev @bash-tute
foxy -a "http://www.shelldorado.com/scripts/categories.html" @Dev @shelldorado
foxy -a "https://mywiki.wooledge.org/BashPitfalls" @Dev @BashPitfalls
foxy -a "http://mywiki.wooledge.org/BashFAQ/098" @Dev @BashFAQ
foxy -a "https://www.shellhacks.com/" @Dev @shellhacks
foxy -a "https://stackpointer.io/" @Dev @stackpointer


#Distros
foxy -a "https://externos.io/download" @Distros @externos
foxy -a "https://nixos.org/" @Distros @nixos
foxy -a "https://www.digi77.com/linux-kodachi/" @Distros @linux-kodachi
foxy -a "https://www.funtoo.org/Install#Live_CD" @Distros @funtoo
foxy -a "http://rauldipeas.gitlab.io/radix/" @Distros @radix
foxy -a "https://redis.io/" @Distros @redis
foxy -a "http://www.lynx.com/products/real-time-operating-systems/lynxos-rtos/" @Distros @lynxos-rtos
foxy -a "https://crunchbangplusplus.org/" @Distros @crunchbangplusplus
foxy -a "https://www.bunsenlabs.org/installation.html" @Distros @bunsenlabs
foxy -a "https://www.linux.com/learn/intro-to-linux/2018/2/namib-linux-makes-arch-linux-dream-new-users" @Distros @namib-linux
foxy -a "https://erikdubois.be/" @Distros @Arcolinux
foxy -a "https://forum.archlabslinux.com/" @Distros @Archlabs


#TechLinux
foxy -a "http://www.hardware.com.br/comunidade/tutorial-linux/801698/" @TechLinux @tutorial-linux
foxy -a "https://xanmod.org/" @TechLinux @xanmod
foxy -a "https://www.tecmint.com/install-owncloud-to-create-personal-storage-in-linux/" @TechLinux @install-owncloud
foxy -a "https://www.welivesecurity.com/br/2017/08/10/ameacas-para-o-linux/" @TechLinux @ameacas-para-o-linux
foxy -a "http://www.dobitaobyte.com.br/ubuntu-cuda-opencv-e-docker-em-um-dell-gaming-7000/" @TechLinux @ubuntu-cuda-opencv
foxy -a "https://www.linuxboot.org/" @TechLinux @linuxboot
foxy -a "https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units" @TechLinux @how-to-use-systemctl-digitalocean
foxy -a "https://sites.google.com/site/easylinuxtipsproject/" @TechLinux @easylinuxtipsproject
foxy -a "http://www.omgubuntu.co.uk/" @TechLinux @omgubuntu
foxy -a "http://www.cesareriva.com/speed-up-your-gnulinux-machine-with-preload-and-prelink/" @TechLinux @preload-and-prelink
foxy -a "http://cavepopo.hd.free.fr/wordpress/" @TechLinux @cavepopo-hd-free
foxy -a "https://www.logicaldoc.com/features" @TechLinux @
foxy -a "https://timoteobrasil.wordpress.com/2012/11/18/clonando-uma-maquina-virtual-para-uma-maquina-real/" @TechLinux @maquina-virtual-para-uma-maquina-real
foxy -a "https://forums.linuxmint.com/viewtopic.php?t=114904" @TechLinux @forums-linuxmint
foxy -a "https://proyectosbeta.net/" @TechLinux @proyectosbeta
foxy -a "http://www.cnblogs.com/lizunicon/p/3556943.html" @TechLinux @cnblogs
foxy -a "http://www.hardware.com.br/dicas/compartilhando-impressoras-linux.html" @TechLinux @compartilhando-impressoras-linux
foxy -a "https://www.tecmint.com/best-remote-linux-desktop-sharing-software/" @TechLinux @remote-linux-desktop-sharing
foxy -a "https://www.ubuntupit.com/linux-file-manager-top-10-reviewed-for-linux-users/" @TechLinux @inux-file-manager-top-10
foxy -a "http://www.cleuber.com.br/index.php/2015/07/29/como-converter-uma-imagem-dmg-em-iso-no-ubuntu" @TechLinux @imagem-dmg-em-iso
foxy -a "https://www.tecmint.com/graphicsmagick-image-processing-cli-tool-for-linux/" @TechLinux @graphicsmagick-image-processing
foxy -a "https://trinitytuts.com/tips/category/ubuntu/" @TechLinux @trinitytuts
foxy -a "https://itsfoss.com/things-to-do-after-installing-arch-linux/" @TechLinux @things-to-do-after-installing-arch-linux
foxy -a "http://www.davidpashley.com/" @TechLinux @davidpashley
foxy -a "https://help.ubuntu.com/community/Installation/UEFI-and-BIOS/stable-alternative" @TechLinux @UEFI-and-BIOS-ubuntu
foxy -a "http://linuxtechlab.com/" @TechLinux @linuxtechlab
foxy -a "http://www.cyrill-gremaud.ch/" @TechLinux @cyrill-gremaud
foxy -a "http://www.linuxmint.com.br" @TechLinux @linuxmint-br
foxy -a "https://scholar.google.com.br/schhp?hl=pt-BR&as_sdt=0" @TechLinux @schhp
foxy -a "http://www.geekpills.com/" @TechLinux @geekpills
foxy -a "https://darknetmatrix.wixsite.com/website" @TechLinux @darknetmatrix
foxy -a "https://www.linuxbuzz.com.br/2019/01/novo-recurso-do-mesa-permitira-que-gpus-mais-antigas-tenham-suporte-para-opengl-4-0.html" @TechLinux @opengl-4
foxy -a "https://ubuntuforums.org/showthread.php?t=2382293" @TechLinux @log-drm-inte-i915 
foxy -a "https://aurelio.net/shell/dialog/#menuloop" @TechLinux @
foxy -a "https://4fasters.com.br/2019/02/13/etc-nologin-qual-a-sua-funcao/" @TechLinux @etc-nologin
foxy -a "https://fullcirclemagazine.org/" @TechLinux @fullcirclemagazine
foxy -a "http://tipsonubuntu.com/" @TechLinux @tipsonubuntu
foxy -a "https://www.tiger-computing.co.uk/linux-tips-pipe-commands-status/" @TechLinux @inux-tips-pipe-commands-status
foxy -a "https://www.linuxquestions.org/questions/programming-9/find-command-return-true-if-a-file-was-found-881400/" @TechLinux @find-return-true
foxy -a "http://linuxcommand.org/lc3_wss0150.php" @TechLinux @linuxcommand
foxy -a "https://bugs.launchpad.net/ubuntu/+source/network-manager/+bug/241796" @TechLinux @network-manager-bug
foxy -a "https://www.thelinuxrain.com/" @TechLinux @thelinuxrain
foxy -a "https://sergioprado.org/" @TechLinux @sergioprado
foxy -a "http://www.unixcl.com/" @TechLinux @unixcl
foxy -a "https://iridakos.com/how-to/2019/05/16/remove-duplicate-lines-preserving-order-linux.html" @TechLinux @remove-duplicate-lines-preserving
foxy -a "https://landoflinux.com/index.html" @TechLinux @landoflinux
foxy -a "http://www.toontricks.com/" @TechLinux @toontricks
foxy -a "https://ryanstutorials.net/" @TechLinux @ryanstutorials
foxy -a "https://null-byte.wonderhowto.com/how-to/locate-exploit-devices-vulnerable-libssh-security-flaw-0189883/" @TechLinux @libssh-security-flaw
foxy -a "https://www.exploit-db.com/exploits/40136" @TechLinux @exploit-db
foxy -a "http://kwort.org/" @TechLinux @kwort
foxy -a "https://pkgs.org/" @TechLinux @pkgs
foxy -a "https://suckless.org/" @TechLinux @suckless
foxy -a "https://workaround.org/" @TechLinux @workaround
foxy -a "https://geekprudens.net/tec/" @TechLinux @geekprudens
foxy -a "http://andrwe.org/" @TechLinux @andrwe


#Others
foxy -a "https://whoer.net/" @Others @whoer
foxy -a "http://www.malware-traffic-analysis.net/" @Others @malware-traffic-analysis
foxy -a "https://ipleak.net/" @Others @ipleak
foxy -a "https://opencv.org/" @Others @opencv
foxy -a "https://www.hays.com.br/" @Others @hays
foxy -a "https://www.amsmeteors.org/" @Others @amsmeteors
foxy -a "https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Tips_and_Tricks" @Others @penSCAD-Tips-and-Tricks
foxy -a "https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/The_OpenSCAD_Language#Values_and_Data_Types" @Others @OpenSCAD-Language
foxy -a "https://filament2print.com/pt/blog/9_duvidas-temperatura-velocidade-pla-abs.html" @Others @temperatura-velocidade-pla-abs
foxy -a "https://www.youmagine.com/designs/bed-leveling-tramming-paralleling-test" @Others @bed-leveling-tramming
foxy -a "https://3dlab.com.br/propriedades-dos-materiais-para-impressora-3d/" @Others @materiais-para-impressora-3d
foxy -a "http://3dprintingninja.blogspot.com/2014/12/how-to-make-3d-model-from-image.html" @Others @3d-model-from-image
foxy -a "https://imaginariopuro.wordpress.com/2017/12/28/calculo-tornado-facil-1/" @Others @calculo-tornado-facil-1


#Social
foxy -a "http://facebook.com/" @Social @
foxy -a "https://fosstodon.org/web/getting-started" @Social @fosstodon
foxy -a "https://mewe.com/group/57f8f6f0236a6e490f9a0a81" @Social @mewe
foxy -a "https://www.linkedin.com/" @Social @linkedin
foxy -a "https://unsplash.com/" @Social @unsplash
foxy -a "https://wallhaven.cc/" @Social @wallhaven
foxy -a "http://vidadesuporte.com.br/" @Social @vidadesuporte
foxy -a "https://naomesmo.com.br/" @Social @naomesmo


#Reddit
foxy -a "https://reddit.com/r/photoshopbattles" @Reddit @photoshopbattles
foxy -a "https://reddit.com/r/openbox" @Reddit @openbox
foxy -a "https://reddit.com/r/archlinux" @Reddit @archlinux
foxy -a "https://reddit.com/r/unixporn" @Reddit @unixporn
foxy -a "https://reddit.com/r/news" @Reddit @news

#search-engine
foxy -a "https://duckduckgo.com/?t=canonical" @search-engine @duckduckgo
foxy -a "https://www.startpage.com/en/" @search-engine @startpage
foxy -a "https://www.google.com.br/" @search-engine @google
