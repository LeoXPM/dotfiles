# Arch Linux + BSPWM Dotfiles

Este repositorio contiene mi entorno de instalación automatizada para Arch Linux utilizando archinstall, BSPWM y GNU Stow para la gestión de las configuraciones.


### Atención: Los archivos incluyen contraseñas y configuraciones de ejemplo. Es fundamental modificar los valores según tu hardware y necesidades de seguridad antes de ejecutar la instalación.


## Configuración (user_configuration.json)

El perfil base de instalación está ajustado con los siguientes parámetros:

* **Kernel:** Long-Term Support Kernel (`linux-lts`), para una mayor estabilidad.

* **Video:** Controladores de código abierto (All open-source).

* **Espejos** (Mirrors): Optimizados para mayor velocidad en el centro de México.

* **Almacenamiento:** Particionado automático para un solo disco (/dev/sda), sin encriptación.

* **Servicios:** Bluetooth y soporte de impresoras deshabilitados por defecto para mantener el sistema ligero.

* **Paquetería:** Incluye una selección de software personalizado, herramientas de desarrollo y utilidades para el gestor de ventanas.


## Credenciales (user_credentials.json)

El archivo de credenciales contiene accesos por defecto para pruebas en entornos virtuales:

    root = admin

    user = pass

Es obligatorio cambiar estos valores. Para mantener la seguridad y evitar guardar contraseñas en texto plano, debes generar el hash de tus contraseñas reales antes de pegarlas en el archivo JSON.

Genera el formato de cifrado correcto ejecutando este comando en cualquier terminal de Linux:

Bash:

    openssl passwd -6

Copia la cadena generada (que empezará con $6$) y pégala en los valores de tu archivo de credenciales.


# Uso e Instalación


## 1. Prepara tu medio de instalación

Asegúrate de tener tus archivos user_configuration.json y user_credentials.json guardados en la raíz de una memoria USB formateada en FAT32.


## 2. Inicia el entorno Live de Arch Linux

Arranca tu equipo usando la ISO oficial de Arch Linux. Una vez que te reciba la consola principal (letras rojas), identifica el nombre que el sistema le asignó a tu memoria USB ejecutando:

Bash:
    
    lsblk


## 3. Monta la memoria USB

Crea un punto de montaje y conecta la memoria (sustituye sdb1 por el identificador exacto de tu partición USB):

Bash:

    mkdir -p /mnt/usb
    mount /dev/sdb1 /mnt/usb


## 4. Ejecuta archinstall

Lanza el instalador nativo pasándole las rutas absolutas de tus archivos JSON como parámetros. Si la configuración es válida, la instalación y compilación comenzarán de forma completamente desatendida:

Bash:

    archinstall --config /mnt/usb/user_configuration.json --creds /mnt/usb/user_credentials.json

Una vez que termine, simplemente escribe reboot para reiniciar el equipo, retira tu memoria USB y disfruta de tu nuevo entorno.


# Script de post-instalación


Este script realiza las siguientes tareas:

* Descarga temas para Rofi.

* Instala plugins de Vim.

* Instala plugins de Neovim.

* Instala paquetería de AUR (aur.txt).


## 1. Entrar a la carpeta de dotfiles

Bash

    cd dotfiles


## 2. Dar permisos de ejecución al script

Bash

    chmod +x post_install.sh


## 3. Ejecutar instalador

Bash

    ./post_install.sh


### Nota: Algunos paquetes de AUR tienen que ser compilados desde el código fuente, por lo que este proceso puede tardar varios minutos.


# Instalación manual de temas visuales


## 1. Generar la carpeta de temas

Bash

    mkdir -p ~/.themes

## 2. Visitar [gnome-look.org]

## 3. Descargar los temas preferidos

## 4. Descomprimir los archivos directamente a la carpeta correspondiente

Bash

    for archivo in ~/Descargas/*.tar*; do tar -xvf "$archivo" -C ~/.themes/; done
