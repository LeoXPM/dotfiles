#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PYENV_ROOT="$HOME/.pyenv"
export HISTCONTROL=ignorespace
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

alias disk='lsblk -f && df -h'
alias l='ls -F'
alias ll='ls -lhF'
alias la='ls -lahF'
alias lr='ls -lahCFR'
alias update='sudo pacman -Syu --needed && yay -Syu --needed'
alias ins='sudo pacman -S --needed'
alias clean='sudo pacman -Sc && yay -Sc'
#alias hoy='mkdir -p $(date +%Y/%m/%d) && cd $(date +%Y/%m/%d)'
alias hoy='echo $(date +%Y/%m/%d)'
alias py='source .venv/bin/activate'
alias vb='vim ~/.bashrc'
alias sb='source ~/.bashrc'
alias vsx='vim ~/.config/sxhkd/sxhkdrc'
alias vbsp='vim ~/.config/bspwm/bspwmrc'
alias c='clear'
alias bin='cd ~/.local/bin && ls ~/.local/bin'
alias pp='xclip -selection clipboard -o'
alias reboot='shutdown -r now'
alias es='sudo localectl set-x11-keymap es'
alias vff='vim ~/.config/fastfetch/config.jsonc'
alias pmain="python main.py"
alias pbar='pkill polybar && ~/.config/polybar/launch.sh &'
alias ff='clear && fastfetch && ls -F'
alias keys='cat ~/.config/sxhkd/sxhkdrc'
alias name='xprop | grep WM_CLASS'
alias search='pacman -Ss'
alias nvidia='watch -n 2 nvidia-smi'

s() {
    sleep $1m && pplay ~/Música/Alerts/mixkit-clear-announce-tones-2861.wav && echo "Alarma finalizada! - $1m"
}

nvim_clean() {
    local share_dir="$HOME/.local/share/nvim"
    local state_dir="$HOME/.local/state/nvim"
    local cache_dir="$HOME/.cache/nvim"
    local config_dir="$HOME/.config/nvim"
    local lock_file="$config_dir/lazy-lock.json"

    echo -e "\033[1;33mSelecciona el modo de limpieza:\033[0m"
    echo "1) Limpieza de Caché y Plugins (Arregla errores de instalación)"
    echo "2) Reinicio TOTAL (Mueve tu config actual a backup y limpia todo)"
    echo "3) Cancelar"
    read -p "Opción [1-3]: " opcion

    case $opcion in
        1)
            echo -e "\n\033[1;34m[..] Borrando caché, estado y plugins...\033[0m"
            rm -rf "$share_dir" "$state_dir" "$cache_dir"
            
            if [ -f "$lock_file" ]; then
                echo -e "\033[1;34m[..] Borrando lazy-lock.json...\033[0m"
                rm "$lock_file"
            fi
            
            echo -e "\033[1;32m[OK] Limpieza completada. Abre nvim para reinstalar plugins.\033[0m"
            ;;
        2)
            echo -e "\n\033[1;34m[..] Borrando caché, estado y plugins...\033[0m"
            
	    if [ -d "$config_dir" ]; then
                timestamp=$(date +%Y%m%d_%H%M%S)
                backup_name="nvim.bak.$timestamp"
                echo -e "\033[1;34m[..] Moviendo configuración actual a ~/.config/$backup_name...\033[0m"
                mv "$config_dir" "$HOME/linux/config/$backup_name"
            fi
            
            rm -rf "$config_dir" "$share_dir" "$state_dir" "$cache_dir"
	    
            echo -e "\033[1;32m[OK] NeoVim está como nuevo. Configuración antigua respaldada.\033[0m"
            ;;
        *)
            echo "Operación cancelada."
            ;;
    esac
}

off() {
    echo "Limpiando entorno..."

    # 1. Matar terminales de XFCE
    if pgrep -x "brave" > /dev/null; then
        echo "Cerrando terminales..."
        pkill -x "brave"
    fi

    pkill -x "mpv"

    sleep 1

    echo "Entorno limpio."

    shutdown -h now
}

export PATH="$HOME/.local/bin:$PATH"
export TERM=xterm-kitty
