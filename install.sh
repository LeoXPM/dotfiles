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
xdg-user-dirs-update

DOTFILES_DIR="$TARGET_HOME/dotfiles"

echo "Iniciando la instalación de dotfiles con Stow..."

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

echo "Configurando plugins de Vim..."

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
nvim --headless "+Lazy! sync" +qa
echo "Plugins de Neovim instalados."

echo "Descargando temas para Rofi"
# 1. Clona el repositorio con los temas
git clone https://github.com/lr-tech/rofi-themes-collection.git

# 2. Crea el directorio de temas locales de Rofi (si no existe)
mkdir -p ~/.local/share/rofi/themes/

# 3. Copia todos los archivos .rasi a tu directorio local
cp rofi-themes-collection/themes/*.rasi ~/.local/share/rofi/themes/

rm -r rofi-themes-collection

echo "Reiniciando Instalacion."

reboot
