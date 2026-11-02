#!/bin/bash

# Bloqueo de seguridad: yay no permite ejecutarse como root
if [ "$EUID" -eq 0 ]; then
    echo "Error: No ejecutes este script como root ni con sudo."
    exit 1
fi

DOTFILES_DIR="$HOME/dotfiles"
AUR_LIST="$DOTFILES_DIR/aur.txt"

echo "=========================================="
echo "  Instalación de Paquetes AUR con yay     "
echo "=========================================="
sleep 2

# Instalar yay si no existe
if ! command -v yay &> /dev/null; then
    echo ">> Instalando yay..."
    cd /tmp || exit
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin || exit
    makepkg -si --noconfirm
    cd "$HOME" || exit
    rm -rf /tmp/yay-bin
    echo ">> yay instalado correctamente."
else
    echo ">> yay ya está instalado en el sistema."
fi

# Instalar los paquetes de la lista
if [ -f "$AUR_LIST" ]; then
    echo ">> Comenzando descarga y compilación de paquetes..."
    sleep 2
    yay -S --needed --noconfirm --answerclean None --answerdiff None $(<"$AUR_LIST")
else
    echo ">> Error: No se encontró el archivo $AUR_LIST"
    exit 1
fi

echo "=========================================="
echo "  ¡Instalación de AUR finalizada!         "
echo "=========================================="
