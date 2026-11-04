#!/bin/bash

# Bloqueo de seguridad: yay no permite ejecutarse como root
check_root() {
    if [ "$EUID" -eq 0 ]; then
        echo "Error: No ejecutes este script como root ni con sudo."
        exit 1
    fi
}

install_aur_packages() {
    echo "=========================================="
    echo "  Instalación de Paquetes AUR con yay     "
    echo "=========================================="
    sleep 1

    # Instalar yay si no existe
    if ! command -v yay &>/dev/null; then
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

    DOTFILES_DIR="$HOME/dotfiles"
    AUR_LIST="$DOTFILES_DIR/aur.txt"

    # Instalar los paquetes de la lista
    if [ -f "$AUR_LIST" ]; then
        echo ">> Comenzando descarga y compilación de paquetes..."
        sleep 1
        yay -S --needed --noconfirm --answerclean None --answerdiff None $(<"$AUR_LIST")
    else
        echo ">> Error: No se encontró el archivo $AUR_LIST"
        return 1
    fi
    echo "=========================================="
    echo "  ¡Instalación de AUR finalizada!         "
    echo "=========================================="
}

install_rofi_themes() {
    echo "=========================================="
    echo "  Instalando temas de Rofi                "
    echo "=========================================="
    sleep 1

    # 1. Clona el repositorio con los temas
    git clone https://github.com/lr-tech/rofi-themes-collection.git

    # 2. Crea el directorio de temas locales de Rofi (si no existe)
    mkdir -p ~/.local/share/rofi/themes/

    # 3. Copia todos los archivos .rasi a tu directorio local
    cp rofi-themes-collection/themes/*.rasi ~/.local/share/rofi/themes/

    rm -rf rofi-themes-collection
    echo ">> Temas de Rofi instalados con éxito."
}

install_vim_plugins() {
    echo "=========================================="
    echo "  Instalando Vim Plugins                  "
    echo "=========================================="
    sleep 1

    VIM_PLUG_FILE="$HOME/.vim/autoload/plug.vim"
    if [ ! -f "$VIM_PLUG_FILE" ]; then
        curl -fLo "$VIM_PLUG_FILE" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        vim +PlugInstall +qall
        echo ">> Plugins de Vim instalados."
    else
        echo ">> vim-plug ya está instalado."
    fi
}

install_neovim_plugins() {
    echo "=========================================="
    echo "  Instalando NeoVim Plugins y Mason       "
    echo "=========================================="
    sleep 1

    nvim --headless "+Lazy! sync" +qa
    nvim --headless "+MasonInstall debugpy basedpyright lua-language-server ruff stylua" +qa
    echo ">> Plugins y herramientas de NeoVim instaladas."
}

run_all() {
    install_aur_packages
    install_rofi_themes
    install_vim_plugins
    install_neovim_plugins
    echo "=========================================="
    echo "  ¡Instalación completa finalizada!       "
    echo "=========================================="
}

show_menu() {
    check_root
    while true; do
        clear
        echo "=========================================="
        echo "         MENÚ DE CONFIGURACIÓN            "
        echo "=========================================="
        echo "1) Instalar paquetes AUR (yay)"
        echo "2) Instalar temas de Rofi"
        echo "3) Instalar plugins de Vim"
        echo "4) Instalar plugins de NeoVim y Mason"
        echo "5) Ejecutar TODO (Todas las opciones)"
        echo "6) Salir"
        echo "=========================================="
        read -p "Selecciona una opción [1-6]: " option

        case $option in
        1)
            install_aur_packages
            read -p "Presiona Enter para continuar..."
            ;;
        2)
            install_rofi_themes
            read -p "Presiona Enter para continuar..."
            ;;
        3)
            install_vim_plugins
            read -p "Presiona Enter para continuar..."
            ;;
        4)
            install_neovim_plugins
            read -p "Presiona Enter para continuar..."
            ;;
        5)
            run_all
            read -p "Presiona Enter para continuar..."
            ;;
        6)
            echo "Saliendo del script..."
            exit 0
            ;;
        *)
            echo "Opción inválida. Por favor, selecciona un número del 1 al 6."
            sleep 2
            ;;
        esac
    done
}

# Ejecutar el menú principal
show_menu
