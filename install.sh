#!/bin/bash

# Detectar automáticamente qué usuario está ejecutando el script
TARGET_USER="$USER"
TARGET_HOME="$HOME"

# =========================================================================
# ACTIVAR MODO DEBUG Y REGISTRO
# =========================================================================
LOG_FILE="$TARGET_HOME/instalacion_dotfiles.log"
exec > >(tee -a "$LOG_FILE") 2>&1
set -x
# =========================================================================

# Bloqueo de seguridad: Evitar ejecución como root
if [ "$EUID" -eq 0 ]; then
    echo "Error: Este script no debe ejecutarse como root o con sudo."
    exit 1
fi

echo "Creando directorios para $TARGET_USER en $TARGET_HOME"
sleep 3
xdg-user-dirs-update

DOTFILES_DIR="$TARGET_HOME/dotfiles"

echo "Iniciando la instalación de dotfiles con Stow..."
sleep 3

cd "$DOTFILES_DIR" || exit
rm -f "$TARGET_HOME/.bashrc"

# Limpiar las carpetas de configuración que Arch pudo haber autogenerado
rm -rf "$TARGET_HOME/.config/bspwm"
rm -rf "$TARGET_HOME/.config/sxhkd"

# ... permisos de ejecución ...
chmod +x "$DOTFILES_DIR/bspwm/.config/bspwm/bspwmrc" 2>/dev/null
chmod +x "$DOTFILES_DIR/polybar/.config/polybar/launch.sh" 2>/dev/null
chmod +x "$DOTFILES_DIR/scripts/.local/bin/"* 2>/dev/null

# Stow usa dinámicamente el TARGET_HOME
stow --target="$TARGET_HOME" bash bspwm cava fastfetch kitty mpv nvim picom polybar rofi scripts sxhkd vim

echo "Dotfiles instalados correctamente."

echo "Instalando el helper de AUR (yay)..."
sleep 3
cd /tmp
# Condición para no compilar yay si ya está instalado en el sistema
if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si --noconfirm
    cd "$TARGET_HOME"
    rm -rf /tmp/yay-bin
    echo "yay instalado correctamente."
else
    echo "yay ya está instalado en el sistema, saltando compilación."
fi

echo "Instalando paquetes de AUR..."
sleep 3
yay -S --needed --noconfirm --answerclean None --answerdiff None $(<"$DOTFILES_DIR/aur.txt")

echo "Configurando plugins de Vim..."
sleep 3
VIM_PLUG_FILE="$TARGET_HOME/.vim/autoload/plug.vim"
if [ ! -f "$VIM_PLUG_FILE" ]; then
    curl -fLo "$VIM_PLUG_FILE" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +PlugInstall +qall
    echo "Plugins de Vim instalados."
else
    echo "vim-plug ya está instalado."
fi

echo "Configurando plugins de Neovim..."
sleep 3
nvim --headless "+Lazy! sync" +qa
echo "Plugins de Neovim instalados."
