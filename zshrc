###################################
####### ZSH configurations ########
###################################

ZSH_THEME="agnoster"

plugins=(
    git
    docker
    osx
    sublime
    zsh-autosuggestions
)

if [ -d ~/.oh-my-zsh ]; then
    echo "ZSH found"
    export ZSH=/Users/tpines/.oh-my-zsh
    source $ZSH/oh-my-zsh.sh    
fi

# SSH
ssh-add -A

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='st'
fi

# Anodot work
if [ -d ~/repos/anodot-forwarder/ ]; then
    export PYTHONPATH="/Users/tpines/repos/anodot-forwarder/app_anodot-forwarder/kapybara"
fi
if [ -d ~/Documents/repos/appnexus/anodot-forwarder/ ]; then
    export PYTHONPATH="~/Documents/repos/appnexus/anodot-forwarder/app_anodot-forwarder/kapybara"
fi

###################################
####### LS COLOR SETTINGS #########
###################################

if [ -d /usr/local/Cellar/coreutils/ ]; then
    PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
    alias ls="ls -A --color=auto"
fi

if [ -d ~/.dir_colors ]; then
    eval `gdircolors ~/.dir_colors/dircolors.ansi-dark`
fi

###################################
####### PATH Modifications ########
###################################
# User specific environment and startup programs
PATH="$PATH:$HOME/bin:/opt/local/bin:/opt/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin"

# Setting PATH for Python 3.6
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"

export PATH
export MANPATH="/usr/local/man:$MANPATH"
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a"

###################################
############ ALIASES ##############
###################################

alias zrc="st ~/.zshrc"
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias lsi="ls -liA --color=auto"
alias lth="ls -lthA --color=auto"
alias lsh="ls -lhSA --color=auto"
alias psg='ps -aux | grep'
alias hg='history | grep'
alias gvq='grep -v \?'.

# AppNexus aliases
alias mkstart='minikube delete ; minikube start --memory 2048 --cpus 2 --insecure-registry=docker.artifactory.dev.adnxs.net'
alias jump='ssh -A tpines@jump.adnxs.net'
alias dev='ssh -A tpines.devnxs.net'
alias anodot_dev='ssh -A 2313.tpines.user.nym2.adnxs.net'
alias facetime_fix="sudo killall VDCAssistant"

# Terjira aliases
alias ji="jira issue"
alias jil="jira issue ls"
alias jio="jira issue open"
alias jpl="jira project ls"
alias jsl="jira sprint ls -b=1606"
alias jsa="jira sprint active -b 1606 -a ALL"
alias jbb="jira board backlog -b 1606"

###################################
####### Password Getter ###########
###################################
#function that pull password from keychain items
get_pass () {
    security 2>&1 >/dev/null find-generic-password -g -s $1 | awk -F'"' '{printf $2}'
}

#loads password stored in your keychain to paste buffer
PastePass () {
    get_pass $1 | pbcopy
}

#prints password stored in your keychain to terminal
PrintPass () {
    echo "`get_pass $1`"
}

###################################
######### REMOTE SERVERS ##########
###################################
function tojump () {
  scp $1 jump.adnxs.net:/home/tpines;
    return 0
}

# Pulls from jump to desktop
function pull() {
    scp tpines@jump.adnxs.net:"$@" ~/Desktop/TEMP ;
}


DEV="tpines.devnxs.net:/home/tpines"
DEV_NAME="tpines_dev_home"

# Helper function to mount devbox
# NOTE: this detects Pulse VPN using *static* IP
# IP will need to be updated from /etc/hosts if it changes
function gmount_connect(){
    if netstat -nr | grep 68.67  > /dev/null; then
        echo "VPN DETECTED"
        if [ ! -d ~/$1 ]; then
            mkdir -p ~/$1;
            mount | grep osxfusefs | grep $1 > /dev/null; [ $? -ne 0 ] && sshfs -ovolname=$1 $2 ~/$1
            echo "$1 MOUNTED"
        elif [ -d ~/$1 ] && [ ! "`ls -A ~/$1`" ]; then
            echo "FOUND EMPTY $1";
            umount $1;
            rmdir ~/$1;
            mkdir -p ~/$1;
            mount | grep osxfusefs | grep $1 > /dev/null; [ $? -ne 0 ] && sshfs -ovolname=$1 $2 ~/$1
            echo "$1 MOUNTED"
        else
            echo "$1 ALREADY MOUNTED"
        fi
    else
        echo "NO VPN DETECTED"
        if [ -d ~/$1 ] && [ ! "`ls -A ~/$1`" ]; then
            umount $1;
            rmdir ~/$1;
            echo "REMOVED $1"
        else
            echo "NO DEV FOLDERS FOUND"
        fi
    fi
}

# Mount devbox on terminal startup
alias dev_mount="gmount_connect $DEV_NAME $DEV"
dev_mount

# Quick shortcut to open folder on devbox in Sublime
function code(){
    if [ ! -d ~/tpines_dev_home/repos/$1 ]; then
        echo ""
        echo "Folder \"$1\" is empty"
        echo ""
    else
        eval "st ~/tpines_dev_home/repos/$1";
    fi
}