###################################
####### ZSH configurations ########
###################################

ZSH_THEME="agnoster"
DEFAULT_USER="tpines"

plugins=(
    git
    docker
    osx
    sublime
    zsh-autosuggestions
    kubectl
)

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Preferred editor for local and remote sessions

# SSH
if [ "$SSH_CONNECTION" ]; then
    echo "REMOTE SSH DETECTED"
    export EDITOR="vim"
    export PATH=$PATH:/usr/local/go/bin/:~/go/bin/:~/repos/resources_scripts/scripts/:~/repos/tools_helm-chart-generator
    alias mkstart='sudo -E minikube delete ; sudo -E minikube start --memory 120240 --cpus 6 --vm-driver=none --insecure-registry=docker.artifactory.dev.adnxs.net --kubernetes-version v1.9.0'
else
    ssh-add -A
    echo "LOCAL DETECTED"
    export EDITOR="subl"
    eval 'git config --global core.editor "subl -n -w"'
    alias mkstart='minikube delete ; minikube start --memory 2048 --cpus 2 --insecure-registry=docker.artifactory.dev.adnxs.net'
fi

if [ -d ~/.oh-my-zsh ]; then
    echo "ZSH found"
    export ZSH=~/.oh-my-zsh
    source $ZSH/oh-my-zsh.sh
    autoload -U colors && colors
fi

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# Retrive tools
if [ -f ~/repos/tpines_scripts/utilities.sh ]; then
    source ~/repos/tpines_scripts/utilities.sh
else
    echo "WARNING: No utilities.sh found"
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

if [[ -d /usr/local/Cellar/coreutils/ ]]; then
    PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
    alias ls="ls -A --color=auto"
    if [[ -d ~/.dir_colors ]]; then
        eval `gdircolors ~/.dir_colors/dircolors.ansi-dark`
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    eval `dircolors ~/.dir_colors/dircolors.ansi-dark`
    alias ls="ls -GA"
elif [[ "$OSTYPE" == "linux"* ]]; then
    eval `dircolors ~/.dir_colors/dircolors.ansi-dark`
    alias ls="ls -A --color=auto"
fi

###################################
###### PROMPT Modifications #######
###################################

# Prompt tools for git & kubernetes

function gcb() {
        current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [ $? -eq 0 ]
        then
                echo git:$current_branch
        else
                echo ""
        fi
}
function kcc() {
    current_kubectx=$(grep current-context: ~/.kube/config 2>/dev/null | awk '{print $2}' 2>/dev/null)
        if [ $? -eq 0 ]
        then
                echo $fg[blue]$'\u2388' $fg[yellow]$current_kubectx$reset_color
        else
                echo ""
        fi
}
function acc() {
    current_ankhctx=$(grep current-context: ~/.ankh/config 2>/dev/null | awk '{print $2}' 2>/dev/null)
        if [ $? -eq 0 ]
        then
                echo $fg[orange]$'\u2605' $fg[yellow]$current_ankhctx$reset_color
        else
                echo ""
        fi
}

PROMPT="$PROMPT ($(kcc)) ($(acc)) "


###################################
######## PATH/PROMPT Mods #########
###################################

# User specific environment and startup programs
PATH="$PATH:$HOME/bin:/opt/local/bin:/opt/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin"

# Setting PATH for Python 3.6
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"

# Setting PATH for Python 2.7
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"

export PATH
export MANPATH="/usr/local/man:$MANPATH"
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a"

###################################
############ ALIASES ##############
###################################
alias dev='ssh -A tpines.devnxs.net'
alias dano='ssh -A 2313.tpines.user.nym2.adnexus.net'
alias dkub='ssh -A 2572.tpines.user.nym2.adnexus.net'
alias facetime_fix="sudo killall VDCAssistant"
alias log='git log --graph --full-history --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s" --color'

alias zrc='"${EDITOR:-vi}" ~/.zshrc'
alias bp='"${EDITOR:-vi}" ~/.bash_profile'
alias sbp="source ~/.bash_profile"
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias hg='history | grep'
alias lsi="ls -liA"
alias lth="ls -lthA"
alias lsh="ls -lhSA"
alias psg='ps -aux | grep'
alias hg='history | grep'
alias gvq='grep -v \?'
alias ..="cd ../"
alias ....="cd ../../"

# Terjira aliases
alias ji="jira issue"
alias jil="jira issue ls"
alias jio="jira issue open"
alias jpl="jira project ls"
alias jsl="jira sprint ls -b=1606"
alias jsa="jira sprint active -b 1606 -a ALL"
alias jbb="jira board backlog -b 1606"

###################################
######### REMOTE SERVERS ##########
###################################

DEV="tpines.devnxs.net:/home/tpines"
DEV_NAME="tpines_dev_home"
KUB="2572.tpines.user.nym2.adnexus.net:/home/tpines"
KUB_NAME="tpines_kub_home"

# Helper function to mount devbox
# NOTE: this detects Pulse VPN using *static* IP
# IP will need to be updated from /etc/hosts if it changes
function gmount_connect(){
    if netstat -nr | grep 68.67  > /dev/null; then
        echo "VPN DETECTED"
        if [[ ! -d ~/$1 ]]; then
            mkdir -p ~/$1;
            mount | grep osxfusefs | grep $1 > /dev/null; [ $? -ne 0 ] && sshfs -ovolname=$1 $2 ~/$1
            echo "$1 MOUNTED"
        elif [[ -d ~/$1 ]] && [[ ! "`ls -A ~/$1`" ]]; then
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
        if [[ -d ~/$1 ]] && [[ ! "`ls -A ~/$1`" ]]; then
            umount $1;
            rmdir ~/$1;
            echo "REMOVED $1"
        else
            echo "NO DEV FOLDERS FOUND"
        fi
    fi
}

# Mount devbox on terminal startup
alias dev_mount="gmount_connect $1 $2"
dev_mount $DEV_NAME $DEV
dev_mount $KUB_NAME $KUB


# Quick shortcut to open folder on devbox in Sublime
function code(){
    if [[ ! -d ~/tpines_dev_home/repos/$1 ]]; then
        echo ""
        echo "Folder \"$1\" is empty"
        echo ""
    else
        eval "st ~/tpines_dev_home/repos/$1"
    fi
}
