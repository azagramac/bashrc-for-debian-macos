# ~/.bash_profile - macOS Monterey (bash)
# ========================================

# 🔹 PATH personalizado
export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export BASH_SILENCE_DEPRECATION_WARNING=1
eval "$(/usr/local/bin/brew shellenv)"

# 🔹 Editor por defecto
export EDITOR="vim"

# 🔹 Historial más útil
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=5000
export HISTFILESIZE=10000
shopt -s histappend
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# 🔹 Prompt con rama Git
parse_git_branch() {
  git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

if [[ $EUID -eq 0 ]]; then
  PS1="\[\033[1;31m\]\u@\h:\w\[\033[1;33m\]\$(parse_git_branch)\[\033[0m\] # "
else
  PS1="\[\033[1;32m\]\u@\h:\w\[\033[1;34m\]\$(parse_git_branch)\[\033[0m\] \$ "
fi

# 🔹 Colores extra
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'
export LESS='-R'
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# 🔹 Alias básicos
alias ll="ls -lah"
alias la="ls -A"
alias l="ls -CF"
alias ..="cd .."
alias ...="cd ../.."
alias c="clear"
alias h="history"
alias j="jobs -l"

# 🔹 Redes y diagnósticos
alias ip="ipconfig getifaddr en0"
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias speedtest="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -"

# 🔹 Limpieza y mantenimiento
alias repararPermisos="diskutil resetUserPermissions / \$(id -u)"
alias limpiarCaches='rm -rf ~/Library/Caches/* && sudo rm -rf /Library/Caches/* && echo "✅ Cachés limpiadas"'
alias limpiarLogs='sudo rm -rf /private/var/log/* && echo "✅ Logs eliminados"'
alias mantenimientoDiario='sudo periodic daily weekly monthly && echo "✅ Scripts de mantenimiento ejecutados"'
alias limpiarDNS='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder && echo "🌐 DNS cache limpiado"'
alias verificarDisco="diskutil verifyVolume /"
alias repararDisco="diskutil repairVolume /"

# 🔹 Seguridad
alias bloquear="pmset displaysleepnow"

# 🔹 Ordenar apps del Launchpad
alias ordenarMenu='defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock'

# 🔹 Git helpers
alias gs="git status"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"
alias gl="git log --oneline --graph --decorate"
alias gitall="git pull && git add ."

# 🔹 Homebrew
if command -v brew &>/dev/null; then
  export PATH="$(brew --prefix)/bin:$PATH"
  export PATH="$(brew --prefix)/sbin:$PATH"
  alias brewu="brew update && brew upgrade && brew cleanup"
fi

# =========================================
# ACTUALIZACIONES DEL SISTEMA
# =========================================
alias actualizarListar='softwareupdate -l'
alias actualizarSistema='sudo softwareupdate -i -a'
alias actualizarMac='sudo softwareupdate -i -a && brew update && brew upgrade && mas upgrade && brew cleanup && echo "✅ Mac actualizado"'

# =========================================
# BANNER AL INICIAR TERMINAL
# =========================================
HOSTNAME=$(hostname)
OS_INFO="$(sw_vers -productName) $(sw_vers -productVersion)"
USER_NAME=$USER
DATE_NOW=$(date)
DISK_FREE=$(df -h / | awk 'NR==2 {print $4}')

# Batería detallada
BATTERY_INFO=$(pmset -g batt | grep -Eo "\d+%;.*")
BATTERY_PERCENT=$(echo "$BATTERY_INFO" | grep -o "[0-9]\{1,3\}%")
BATTERY_STATUS=$(echo "$BATTERY_INFO" | awk -F';' '{print $2}' | xargs)
case $BATTERY_STATUS in
  *discharging*) BATTERY_ICON="🔋" ;;
  *charging*)    BATTERY_ICON="⚡️" ;;
  *charged*)     BATTERY_ICON="✅" ;;
  *)             BATTERY_ICON="🔌" ;;
esac

# RAM usada
RAM_USED=$(vm_stat | perl -ne '/page size of (\d+)/ and $size=$1;
   /Pages active.+?(\d+)/ and $a=$1;
   /Pages wired.+?(\d+)/ and $w=$1;
   /Pages speculative.+?(\d+)/ and $s=$1;
   END{printf "%.2f GB", ($a+$w+$s)*$size/1024/1024/1024}')

# CPU load alineado
CPU_LOAD=$(uptime | awk -F'load averages:' '{gsub(/^ +| +$/,"",$2); printf "%-15s", $2}')

# Colores para banner
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
RED="\033[1;31m"
RESET="\033[0m"

echo -e "💻  ${GREEN}$HOSTNAME${RESET} - ${YELLOW}$OS_INFO${RESET}"
echo -e "👤  ${CYAN}Usuario:${RESET} $USER_NAME${RESET}"
echo -e "🔋  ${CYAN}Batería:${RESET} ${RED}$BATTERY_ICON ${YELLOW}$BATTERY_PERCENT${RESET} (${CYAN}$BATTERY_STATUS${RESET})"
echo -e "🧠  ${CYAN}RAM usada:${RESET} $RAM_USED"
echo -e "⚙️   ${CYAN}CPU load:${RESET} $CPU_LOAD"
echo -e "💾  ${CYAN}Espacio libre:${RESET} $DISK_FREE"
echo -e "📅  ${CYAN}Fecha:${RESET} $DATE_NOW"

