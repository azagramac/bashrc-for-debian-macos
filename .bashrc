# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

## Colorear la rama del repositorio
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

## Banner
# Colores
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
RESET="\033[0m"

# Última conexión (penúltima entrada de last)
LAST_LOGIN=$(last -n 2 $USER | tail -1 | awk '{print $4, $5, $6, $7}')
KERNEL_VERSION=$(uname -r)

# Obtener distribución y versión (para Debian)
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO_NAME=$NAME
else
    DISTRO_NAME="Desconocida"
fi

# Si es Debian, leer versión desde /etc/debian_version
if [[ "$DISTRO_NAME" == *"Debian"* ]] && [ -f /etc/debian_version ]; then
    DEBIAN_VERSION=$(cat /etc/debian_version)
    DISTRO="$DISTRO_NAME $DEBIAN_VERSION"
else
    DISTRO="$DISTRO_NAME"
fi

echo -e "\n${GREEN}🐧 $DISTRO${RESET}"
echo -e "${CYAN}🖥️  Kernel:${RESET} $KERNEL_VERSION"
echo -e "${CYAN}⏳ Tiempo activo: ${YELLOW}$(uptime -p)${RESET}"
echo -e "${CYAN}🕒 Última conexión:${RESET} $LAST_LOGIN"
echo -e "${CYAN}📅 Fecha y hora:${RESET} $(date)\n"

## Java Home
[ -z "$JAVA_HOME" ] && export JAVA_HOME=/usr/lib/jvm/default-java
export PATH="$JAVA_HOME/bin:$PATH"

## Android platform-tools
[ -z "$ANDROID_TOOLS" ] && export ANDROID_TOOLS="$HOME/.android/platform-tools"
case ":$PATH:" in
  *":$ANDROID_TOOLS:"*) ;;
  *) export PATH="$PATH:$ANDROID_TOOLS" ;;
esac

## Alias

# Mantenimiento del sistema
alias ordenar-menu="gsettings reset org.gnome.shell app-picker-layout"
alias update="sudo apt update && sudo apt upgrade"
alias limpiarApt="sudo apt clean && sudo apt autoclean"
alias liberarRam="sudo sync && sudo sysctl -w vm.drop_caches=3"

# Git
alias gitall="git pull && git add ."

# Android
alias android="adb devices | tail -2"

# Reiniciar servicios Docker por SSH
alias adguard-restart="ssh dietpi@master docker restart adguard"
#alias wireguard-restart="ssh dietpi@worker docker restart wireguard"

# Varios útiles
alias myip="curl http://checkip.amazonaws.com"
alias grabarssh="ssh dietpi@master | tee -a /tmp/ssh_dietpi.log"

# Ripear DVDs
alias ripdvd="dvdbackup -i /dev/sr0 -M -o /home/$USER/Vídeos/"


