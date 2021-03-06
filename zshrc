# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

###################################
####### ZSH configurations ########
###################################

ZSH_THEME="powerlevel10k/powerlevel10k"
DEFAULT_USER="tpines"

plugins=(
    git
    docker
    osx
    sublime
    zsh-autosuggestions
    kubectl
)

# SSH
if [ "$SSH_CONNECTION" ]; then
    echo "REMOTE SSH DETECTED"
    eval 'git config --global core.editor vim'
    alias mkstart='sudo -E minikube delete ; sudo -E minikube start --memory 120240 --cpus 6 --vm-driver=none --insecure-registry=docker.artifactory.dev.adnxs.net --kubernetes-version v1.9.0'
    alias docker='sudo -E docker'
    alias minikube='sudo -E minikube'
    export CHANGE_MINIKUBE_NONE_USER=true
    export PS1='[\[\e[0;33m\]\[\e[m\]\[\e[0;32m\]\h \w\[\e[m\]] [$(gcb)] $(kcc) $(acc)\[\e[m\]\n$ '
    export PATH=$PATH:/usr/local/go/bin/:~/go/bin/:~/repos/resources_scripts/scripts/:~/repos/tools_helm-chart-generator:~/repos/resources_rubiks-kube/bin
    export EDITOR="vim"
else
    if [[ -d ~/.oh-my-zsh/ ]]; then
            echo "ZSH found"
            export ZSH=~/.oh-my-zsh
            source $ZSH/oh-my-zsh.sh
            autoload -U colors && colors
    fi
    ssh-add -A
    echo "LOCAL DETECTED"
    export EDITOR="subl"
    eval 'git config --global core.editor "code --wait"'
    alias mkstart='minikube delete ; minikube start --memory 2048 --cpus 2 --insecure-registry=docker.artifactory.dev.adnxs.net'
fi

if [ -f ~/.bashrc ]; then
    if [ -n "$BASH" ]; then
        source ~/.bashrc
    fi
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Retrive tools
if [ -f ~/repos/tpines_scripts/utilities.sh ]; then
    source ~/repos/tpines_scripts/utilities.sh
else
    echo "No utilities.sh found"
fi

# Anodot work
if [ -d ~/repos/appnexus/anodot-forwarder/ ]; then
    export PYTHONPATH="/Users/tpines/repos/appnexus/anodot-forwarder/app_anodot-forwarder/kapybara"
fi
if [ -d ~/Documents/repos/appnexus/anodot-forwarder/ ]; then
    export PYTHONPATH="~/Documents/repos/appnexus/anodot-forwarder/app_anodot-forwarder/kapybara"
fi

###################################
####### LS COLOR SETTINGS #########
###################################

if [[ "$OSTYPE" == "linux"* ]]; then
    echo "Setting colors for Linux"
    eval `dircolors ~/.dir_colors/dircolors.ansi-dark`
    alias ls="ls -A --color=auto"
fi

###################################
###### PROMPT Modifications #######
###################################

# Prompt tools for kubernetes

function kcc() {
    current_kubectx=$(grep current-context: ~/.kube/config 2>/dev/null | awk '{print $2}' 2>/dev/null)
    if [ $? -eq 0 ]
    then
        echo "$fg[blue]\u2388 $fg[yellow]$current_kubectx$reset_color"
    else
        echo ""
    fi
}
function acc() {
    current_ankhctx=$(grep current-context: ~/.ankh/config 2>/dev/null | awk '{print $2}' 2>/dev/null)
    if [ $? -eq 0 ]
    then
        echo "$fg[orange]\u2605 $fg[yellow]$current_ankhctx$reset_color"
    else
        echo ""
    fi
}

PROMPT="$(kcc) $(acc)
$PROMPT"

###################################
######## PATH/PROMPT Mods #########
###################################

# User specific environment and startup programs
PATH="$PATH:$HOME/bin:/opt/local/bin:/opt/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin"

# Setting PATH for Python 3.6
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"

# Setting PATH for Python 2.7
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"

# VSCode
PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:${PATH}"

export PATH
export MANPATH="/usr/local/man:$MANPATH"
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a"

###################################
############ ALIASES ##############
###################################
alias dev='ssh -A tpines.devnxs.net'
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

DEV="2572.tpines.user.nym2.adnexus.net:/home/tpines"
DEV_NAME="tpines_dev_home"

function docker-purge(){
    list="$(docker ps --all -q -f status=exited)"
    if [ -n "$list" ]; then
        docker rm "$list" && \
        docker system prune -a;
    fi
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
