###
# Autoload zsh modules when they are referenced
###
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile
autoload -U compinit
compinit

###
# setup options
###
# use share_history instead of setopt APPEND_HISTORY         # appends history to .zsh_history
setopt AUTO_CD                # cd if no matching command
setopt AUTO_PARAM_SLASH       # adds slash at end of tabbed dirs
setopt CHECK_JOBS             # check bg jobs on exit
setopt CORRECT                # corrects spelling
setopt CORRECT_ALL            # corrects spelling
setopt EXTENDED_GLOB          # globs #, ~ and ^
setopt EXTENDED_HISTORY       # saves timestamps on history
setopt GLOB_DOTS              # find dotfiles easier
setopt HASH_CMDS              # save cmd location to skip PATH lookup
setopt HIST_EXPIRE_DUPS_FIRST # expire duped history first
setopt HIST_NO_STORE          # don't save 'history' cmd in history
setopt INC_APPEND_HISTORY     # append history as command are entered
setopt LIST_ROWS_FIRST        # completion options left-to-right, top-to-bottom
setopt LIST_TYPES             # show file types in list
setopt MARK_DIRS              # adds slash to end of completed dirs
setopt NUMERIC_GLOB_SORT      # sort numerically first, before alpha
setopt PROMPT_SUBST           # sub values in prompt (though it seems to work anyway haha)
setopt RM_STAR_WAIT           # pause before confirming rm *
setopt SHARE_HISTORY          # share history between open shells


###
# Setup vars
###
PATH=~/bin:./bin:/usr/local/bin:/usr/local/mysql/bin:/opt/local/bin:/opt/local/sbin:/usr/local/sbin:/opt/local/lib/postgresql83/bin:$PATH
export PATH
TZ="Australia/Sydney"

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
HOSTNAME="`hostname`"
REPORTTIME=120 # print elapsed time when more than 10 seconds

export PAGER='less'
export SHELL="/bin/zsh"
export RUBYLIB="~/projects/scripts/lib"
export EDITOR="emacsclient"
export GIT_EDITOR="emacsclient"
export NODE_PATH="/usr/local/lib/node"

if [[ `uname` == "Darwin" ]] then
  export CLICOLOR=1
  export LSCOLORS=gxfxcxdxbxegedabagacad
else
  alias ls='ls --color'
  export LS_COLORS="di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=:ow=:"
fi

###
# Emacs shortcut keys
###
bindkey -e
# use bash word select so it splits on /, dots, etc
autoload -U select-word-style
select-word-style bash

###
# ssh host completion
###
zstyle -e ':completion:*:(ssh|scp):*' hosts 'reply=(
  ${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) \
       /dev/null)"}%%[# ]*}//,/ }
  ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
)'


###
# Aliases
### 

# general helpers
alias l="ls -laFhG"
alias m="mate ."
alias mw="mate -w"
alias myip="ifconfig | grep 192.168 || ifconfig | grep 10.32"
alias psg="ps ax | grep -i "
alias wget="wget -c"
alias top="top -o cpu"
alias mtop="top -o rsize"
alias sr="screen -r"
alias all_rw="sudo find . -type d -exec sudo chmod 0777 {} \; && sudo find . -type f -exec sudo chmod 0666 {} \;"
alias port="nice port"
alias less="less -r"

#db helpers
alias mystart="sudo /opt/local/share/mysql5/mysql/mysql.server start"
alias mystop="sudo /opt/local/share/mysql5/mysql/mysql.server stop"
alias pgstart="sudo /opt/local/etc/LaunchDaemons/org.macports.postgresql83-server/postgresql83-server.wrapper start"
alias pgstop="sudo /opt/local/etc/LaunchDaemons/org.macports.postgresql83-server/postgresql83-server.wrapper stop"

alias rs="./script/rails server"
alias rc="./script/rails console"
#alias rc="pry -r ./config/environment"
alias mdmu="rake db:migrate VERSION=0; rake db:migrate; rake db:test:clone"
alias mb="rake db:migrate && RAILS_ENV=test rake db:schema:load"
alias test_timer="rake TIMER=true 2>/dev/null | grep \" - \" | sort -r | head -n 20"
alias s="rspec --order random --profile 5"
alias sf="s --tag \~js spec"
alias spring="nocorrect spring"
alias c="bundle exec cucumber -f Cucumber::Formatter::ProgressPerFile"
alias cr="bundle exec cucumber --format rerun --out rerun.txt"
alias sc="bundle exec cucumber -p selenium"
alias rt="ctags -e **/*.rb"
alias rg="rake routes | grep -i"
alias be="nocorrect bundle exec"
alias bc="(bundle check || bundle install --path vendor/bundle)"
alias swr="source .rvmrc"
alias reports="RAILS_ENV=reports"
alias zt="zeus test"
alias zs="bc && RETRIES=1 nice zeus start"

# svn helpers
alias sst="svn st"
alias sup="svn up"
alias sci="svn ci -m "
alias si="svn propedit svn:ignore"
alias remove_missing='svn rm `svn st | grep \! | tr -d "! "`'
alias add_missing='svn add `svn st | grep \? | tr -d "? "`'
alias srp="svn propset svn:ignore '*.log' log/ && svn propset svn:ignore '*.db' db/ && svn propset svn:ignore 'schema.rb' db/"

# git helpers
alias git="nocorrect git"
alias gst='git status'
alias gl='git --no-pager log -n 1'
alias gup='git fetch --prune --tags origin && git rebase -p origin/$(git_current_branch)'
alias gmt='git mergetool'
alias gp='git push origin $(git_current_branch)'
alias gf='git fetch --prune --tags'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'
alias gpcd='git push && cap deploy'
alias gr="git reset --hard HEAD"
alias grn="git log --format=oneline  --abbrev-commit --no-merges"
alias st="gitx -c"
alias de="gitx develop"
alias gfs='git flow feature start'
alias gff='git flow feature finish'
alias gfr='git flow feature rebase'
alias gfc='git flow feature checkout'
alias gua='git config core.ignorecase true && gup && git config core.ignorecase false'
alias glc="git log -n 1 --pretty=format:%B | pbcopy"
alias hb="hub browse"
alias gco="git checkout"

function ghb() {
  hub browse -- commit/$1
}

function gdt() {
  git tag -d $1;
  git push origin :refs/tags/$1
}

function rake() {
  if [ -f bin/rake ]; then
      bin/rake --trace $1
  else
      rake --trace $1
  fi
}


function ss() {
  HEADLESS=on bin/rspec -P spec/**/*$1*_spec.rb -f d spec
}


#heroku helpers
alias hp="git push heroku master"
alias hl="heroku logs"

# work helpers
alias mc='memcached -I 5m -m 256 -vv'
alias pil='tail -f log/development.log log/bug_hunter.log log/resque.log log/wfm.log log/xero.log'
alias psd='git push staging'
alias h='nocorrect heroku'
alias hc="git --no-pager log --merges --pretty=format:'%Cred%h%Creset -%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%C(yellow)%d%Creset' --date=short production..master"
alias hdm="git --no-pager diff production master -- db/migrate"
alias pg="gem install bond what_methods benchmark-ips --install-dir vendor/bundle/ruby/2.1.0/"
alias pis='nocorrect pi_staging'
alias pip='nocorrect pi_production'
alias pia='nocorrect pi_alpha'

function pi_staging() {
  heroku $* --remote staging
}

function pi_production() {
  heroku $* --remote production
}

function pi_alpha() {
  heroku $* --remote launch
}

###
# get the name of the branch we are on
###
# parse_git_branch() {
#   git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
# }
function git_current_branch() {
  git symbolic-ref HEAD 2> /dev/null | sed -e 's/refs\/heads\///'
}
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}

#
# Delete local and remote git branch
#
gbd() {
  git branch -D $1
  git push origin :$1
}

#
# Run a command x times
# http://www.stefanoforenza.com/how-to-repeat-a-shell-command-n-times/
#
runx() {
    n=$1
    shift
    while [ $(( n -= 1 )) -ge 0 ]
    do
        "$@"
    done
}
alias runx='nocorrect runx'

r2() {
  bundle exec rspec $*; HEADLESS=on bundle exec rspec $*
}

###
# Called before prompt shown
###
echo $HOST
case $HOST in
    bradwilson.pascal.net.au)
        hostcolor=magenta
        ;;
    clamps)
        hostcolor=red
        ;;
    fry)
        hostcolor=cyan
        ;;
    *)
        hostcolor=green
        ;;
esac
function precmd {
  PS1="[%{$PR_MAGENTA%}%n%{$PR_NO_COLOR%}@%{$fg[$hostcolor]%}%U%m%u%{$PR_NO_COLOR%}:%{$PR_CYAN%}%2c %{$PR_RED%}($(git_current_branch))%{$PR_NO_COLOR%}]%(!.#.$) "
}

#RPS1="\$(rvm-prompt)$PR_MAGENTA(%D{%I:%M %p %d-%m-%y})$PR_NO_COLOR"


# some functions
function pdfman () {
    man -t $1 | open -a /Applications/Preview.app -f
}

case $TERM in
    *xterm*|ansi)
		function settab { print -Pn "\e]1;%n@%m: %~\a" }
		function settitle { print -Pn "\e]2;%n@%m: %~\a" }
		function chpwd { settab;settitle }
		settab;settitle
        ;;
esac

# if we're sshing in from emacs/tramp
if [ "$TERM" = "dumb" ]                                                                                            
then                                                                                                               
  unsetopt zle                                                                                                     
  unsetopt prompt_cr                                                                                               
  unsetopt prompt_subst                                                                                            
  #unfunction precmd                                                                                                
  #unfunction preexec                                                                                               
  PS1='$ '                                                                                                         
else
    autoload colors zsh/terminfo
    if [[ "$terminfo[colors]" -ge 8 ]]; then
        colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
        eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
        eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
        (( count = $count + 1 ))
    done
    PR_NO_COLOR="%{$terminfo[sgr0]%}"
fi               


if [ -s ~/.profile ] ; then
    source ~/.profile
fi

# # RVM
if [ -s ~/.rvm/scripts/rvm ] ; then 
    source ~/.rvm/scripts/rvm ;
#    rvm system;
fi

# Autojump
if [ -f /usr/local/bin/brew ]; then
  [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
  # if [ -f `brew --prefix`/etc/autojump ]; then
  #   . `brew --prefix`/etc/autojump
  # fi
elif [ -f /usr/share/autojump/autojump.sh ]; then
  .  /usr/share/autojump/autojump.sh
fi

###
# Bunch of stuff I haven't figured out if I need yet
###
bindkey '^r' history-incremental-search-backward
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history
bindkey "^[[H" beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[F"  end-of-line
bindkey "^[[4~" end-of-line
bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand

zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:processes' command 'ps -axw'
zstyle ':completion:*:processes-names' command 'ps -awxho command'
# Completion Styles
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
    
# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions
#
#NEW completion:
# 1. All /etc/hosts hostnames are in autocomplete
# 2. If you have a comment in /etc/hosts like #%foobar.domain,
#    then foobar.domain will show up in autocomplete!
zstyle ':completion:*' hosts $(awk '/^[^#]/ {print $2 $3" "$4" "$5}' /etc/hosts | grep -v ip6- && grep "^#%" /etc/hosts | awk -F% '{print $2}') 
# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
#zstyle ':completion:*:processes' command 'ps -o pid,s,nice,stime,args'
#zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
zstyle '*' hosts $hosts

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'
# the same for old style completion
#fignore=(.o .c~ .old .pro)

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:scp:*' tag-order \
   files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order \
   files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
   users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order \
   hosts-domain hosts-host users hosts-ipaddr
zstyle '*' single-ignored show


export GOPATH=$HOME/.gopath
export PATH=$HOME/.cabal/bin:$GOPATH/bin:$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

