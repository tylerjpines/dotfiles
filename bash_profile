# Pull in local config settings

if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi

if [ -d ~/anaconda ]; then
    eval "$(register-python-argcomplete conda)"
fi

if [ -d ~/.dir_colors ]; then
    eval `dircolors ~/.dir_colors/dircolors.ansi-dark`
fi

PATH=""
# Required for colors in ~/.dir_colors
if [ -d /usr/local/Cellar/coreutils/ ]; then
    PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
    alias ls="ls -A --color=auto"
fi

if [ -d /Applications/Sublime\ Text.app/Contents/SharedSupport/bin ]; then
    SUBLPATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin"
    PATH="$SUBLPATH:$PATH"
fi

# User specific environment and startup programs
PATH="$PATH:$HOME/bin:/opt/local/bin:/opt/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/rt/bin"

# Setting PATH for Python 3.5
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:${PATH}"

# Setting PATH for Python 2.7
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"

# added by Anaconda2 4.4.0 installer
PATH="/Users/tpines/anaconda/bin:$PATH"


# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export PATH
export MANPATH
export EDITOR='subl'
export PS1='\u@\H[\[\e[37m\]\A\[\e[m\]][$?]: \[\e[34m\]\W\[\e[0m\]\n\$ '

ssh-add -A

# Exercism script
if [ -f ~/.config/exercism/exercism_completion.bash ]; then
  . ~/.config/exercism/exercism_completion.bash
fi

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
alias jump='ssh -A tpines@jump.adnxs.net'
alias dev='ssh -A tpines.devnxs.net'
alias greenhouse='ssh -A greenhouse-dev.adnxs.net'
alias steam="wine /Users/tpines/.wine/drive_c/Program\ Files\ \(x86\)/Steam/Steam.exe -no-dwrite"
alias facetime_fix="sudo killall VDCAssistant"

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

# helper function to mount greenhouse
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

#mount greenhouse on terminal startup
alias dev_mount="gmount_connect $DEV_NAME $DEV && gmount_connect $GH_NAME $GH"
dev_mount

function pull() { scp tpines@jump.adnxs.net:"$@" ~/Desktop/TEMP ;}