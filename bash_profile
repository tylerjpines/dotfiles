# Pull in local config settings

if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi

if [ -f ~/git-completion.bash ]; then
    source ~/git-completion.bash
fi

# set up Anaconda3 5.0.0
if [ -d ~/anaconda3 ]; then
    export PATH="/Users/tpines/anaconda3/bin:$PATH"
    #eval "$(register-python-argcomplete conda)"
fi

# Required for colors in ~/.dir_colors
if [ -d /usr/local/Cellar/coreutils/ ]; then
    PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
    alias ls="ls -A --color=auto"
fi

# User specific environment and startup programs
PATH="$PATH:$HOME/bin:/opt/local/bin:/opt/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/rt/bin"

# Setting PATH for Python 2.7
# PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"

if [ -d /Applications/Sublime\ Text.app/Contents/SharedSupport/bin ]; then
    SUBLPATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin"
    PATH="$PATH:$SUBLPATH"
fi

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export PATH
export MANPATH
export EDITOR='subl'
export PS1='\u@\H[\[\e[37m\]\A\[\e[m\]][$?]: \[\e[34m\]\W\[\e[0m\]\n\$ '

ssh-add -A

if [ -d ~/.dir_colors ]; then
    eval `gdircolors ~/.dir_colors/dircolors.ansi-dark`
fi

# Exercism script
if [ -f ~/.config/exercism/exercism_completion.bash ]; then
  . ~/.config/exercism/exercism_completion.bash
fi

# Standard CLI aliases
alias bp="subl .bash_profile"
alias sbp="source .bash_profile"
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias lsi="ls -liA"
alias lth="ls -lthA"
alias lsh="ls -lhSA"
alias psg='ps -aux | grep'
alias hg='history | grep'
alias gvq='grep -v \?'.

# AppNexus aliases
alias jump='ssh -A tpines@jump.adnxs.net'
alias dev='ssh -A tpines.devnxs.net'
alias greenhouse='ssh -A greenhouse-dev.adnxs.net'
alias facetime_fix="sudo killall VDCAssistant"

# Terjira aliases
alias ji="jira issue"
alias jil="jira issue ls"
alias jio="jira issue open"
alias jpl="jira project ls"
alias jsl="jira sprint ls -b=1382"
alias jsa="jira sprint active -b 1382 -a ALL"
alias jbb="jira board backlog -b 1382"
alias jano="jira issue jql \"'Epic Link' in (RAE-246) and status!=closed ORDER BY Rank ASC\""


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

function tojump () {
  scp $1 jump.adnxs.net:/home/tpines;
    return 0
}

DEV="tpines.devnxs.net:/home/tpines"
DEV_NAME="tpines_dev_home"
GH="greenhouse-dev.adnxs.net:/home/tpines"
GH_NAME="tpines_greenhouse_home"

# Helper function to mount greenhouse
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

# Mount greenhouse on terminal startup
alias dev_mount="gmount_connect $DEV_NAME $DEV && gmount_connect $GH_NAME $GH"
dev_mount

# Quick shortcut to open folder on devbox in Sublime
function code(){
    if [ ! -d ~/tpines_dev_home/repos/$1 ]; then
        echo ""
        echo "Folder \"$1\" is empty"
        echo ""
    else
        eval "subl ~/tpines_dev_home/repos/$1";
    fi
}

# Pulls from jump to desktop
function pull() {
	scp tpines@jump.adnxs.net:"$@" ~/Desktop/TEMP ;
}