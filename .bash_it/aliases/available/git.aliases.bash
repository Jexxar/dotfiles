cite 'about-alias'
about-alias 'common git abbreviations'

# Aliases
# From http://blogs.atlassian.com/2014/10/advanced-git-aliases/
alias g='git'
alias ga='git add'
alias gall='git add -A'
alias gap='git add -p'
alias gb='git branch'
alias gba='git branch -a'
alias gbm='git branch -m'
alias gbt='git branch --track'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcb='git checkout -b'
alias gci='git commit --interactive'
alias gcl='git clone'
alias gclo='git clone'
alias gclean='git clean -fd'
alias gcm='git commit -v -m'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcom='git checkout master'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gct='git checkout --track'
alias gd='git diff'
alias gdel='git branch -D'
alias gdv='git diff -w "$@" | vim -R -'
alias get='git'
alias gexport='git archive --format zip --output'
alias gf='git fetch --all --prune'
alias gft='git fetch --all --prune --tags'
alias gftv='git fetch --all --prune --tags --verbose'
alias gfv='git fetch --all --prune --verbose'
alias gg="git log --graph --pretty=format:'%C(bold)%h%Creset%C(magenta)%d%Creset %s %C(yellow)<%an> %C(cyan)(%cr)%Creset' --abbrev-commit --date=relative"
alias ggs="gg --stat"
alias gl='git pull'
alias glg='git log --stat --max-count=5'
alias glgg='git log --graph --max-count=5'
alias gll='git log --graph --pretty=oneline --abbrev-commit'
alias glog="git log --format='%Cgreen%h%Creset %C(yellow)%an%Creset - %s' --graph"
alias glum='git pull upstream master'
alias gm="git merge"
alias gmu='git fetch origin -v; git fetch upstream -v; git merge upstream/master'
alias gmv='git mv'
alias gp='git push'
alias gpo='git push origin'
alias gpom='git push origin master'
alias gpp='git pull && git push'
alias gpr='git pull --rebase'
alias gpristine='git reset --hard && git clean -dfx'
alias gpu='git push --set-upstream'
alias gpull='git pull'
alias gr='git remote'
alias gra='git remote add'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
alias grm='git rm'
alias grv='git remote -v'
alias gs='git status'
alias gsa='git submodule add'
alias gsl="git shortlog -sn"
alias gss='git status -s'
alias gst='git status'
alias gsu='git submodule update --init --recursive'
alias gt="git tag"
alias gta="git tag -a"
alias gtd="git tag -d"
alias gtl="git tag -l"
alias gup='git fetch && git rebase'
alias gus='git reset HEAD'
alias gwc="git whatchanged"

# Show commits since last pull
alias gnew="git log HEAD@{1}..HEAD@{0}"

# Add uncommitted and unstaged changes to the last commit
alias gcaa="git commit -a --amend -C HEAD"
alias gcam="git commit -am"
alias gcsam="git commit -S -am"
alias ggui="git gui"
alias gstd="git stash drop"
alias gstl="git stash list"

case $OSTYPE in
  darwin*)
    alias gtls="git tag -l | gsort -V"
    ;;
  *)
    alias gtls='git tag -l | sort -V'
    ;;
esac
