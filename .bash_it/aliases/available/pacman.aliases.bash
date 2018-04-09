cite 'about-alias'
about-alias 'pacman abbreviations'

# Pacman/Yaourt Commands
alias psyu="sudo pacman -Syu"
alias p='sudo pacman'
alias pu='sudo pacman -Syu'
alias pa='sudo pacman -Sy'
alias pq='sudo pacman -Q'
alias pdiff='sudo pacdiff'
alias pp='sudo powerpill'
alias ppu='sudo powerpill -Syu'
alias ppa='sudo powerpill -Sy'

alias pacfind='sudo find /!(mnt|sys|run|dev|proc|srv) -name '\''*.pacnew'\'' -or -name '\''*.pacsave'\'' -or -name '\''*.pacorig'\'''

#To get a list of installed packages sorted by size, which may be useful when freeing space on your hard drive:
alias hspac="expac -H M '%m\t%n' | sort -h"

#To list the download size of several packages (leave packages blank to list all packages):
alias dspac="expac -S -H M '%k\t%n'"

#To list explicitly installed packages not in base nor base-devel with size and description:
alias nbspac='expac -H M "%011m\t%-20n\t%10d" $(comm -23 <(pacman -Qqen | sort) <(pacman -Qqg base base-devel | sort)) | sort -n'

#list the 10 last installed packages
alias lastpac="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n 10"

#List explicitly installed packages not in the base or base-devel groups:
alias pqnbas='comm -23 <(pacman -Qeq | sort) <(pacman -Qgq base base-devel | sort)'

#List all installed packages unrequired by other packages, and which are not in the base or base-devel groups:
alias pnreq="expac -HM '%-20n\t%10d' $(comm -23 <(pacman -Qqt | sort) <(pacman -Qqg base base-devel | sort))"

#To list all development/unstable packages, run:
alias pindev="pacman -Qq | awk '/^.+(-cvs|-svn|-git|-hg|-bzr|-darcs)$/'"

# Find out which files make up the most of that package.
alias pqfiles="pacman -Qlq package | grep -v '/$' | xargs du -h | sort -h"

#For recursively removing orphans and their configuration files:
alias pacrmv='sudo pacman -Rns $(pacman -Qtdq)'
