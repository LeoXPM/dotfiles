#!/bin/bash

# Bloqueo de seguridad: yay no permite ejecutarse como root
if [ "$EUID" -eq 0 ]; then
    echo "Error: No ejecutes este script como root ni con sudo."
    exit 1
fi

DOTFILES_DIR="$HOME/dotfiles"
AUR_LIST="$DOTFILES_DIR/aur.txt"

echo "=========================================="
echo "  Instalando temas de Rofi     "
echo "=========================================="
sleep 2

# 1. Clona el repositorio con los temas
git clone https://github.com/lr-tech/rofi-themes-collection.git

# 2. Crea el directorio de temas locales de Rofi (si no existe)
mkdir -p ~/.local/share/rofi/themes/

# 3. Copia todos los archivos .rasi a tu directorio local
cp rofi-themes-collection/themes/*.rasi ~/.local/share/rofi/themes/

rm -r rofi-themes-collection


echo "=========================================="
echo "  Instalando Vim Plugins     "
echo "=========================================="
sleep 2

VIM_PLUG_FILE="$TARGET_HOME/.vim/autoload/plug.vim"
if [ ! -f "$VIM_PLUG_FILE" ]; then
    curl -fLo "$VIM_PLUG_FILE" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +PlugInstall +qall
    echo "Plugins de Vim instalados."
else
    echo "vim-plug ya está instalado."
fi
echo "=========================================="
echo "  Instalando NeoVim Plugins     "
echo "=========================================="
sleep 2

nvim --headless "+Lazy! sync" +qa

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

