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

reboot
