#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar los controladores de NVIDIA en Debian
# de forma que se pueda dar uso a los núcleos CUDA de la tarjeta gráfica
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-DeWeb-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-DeWeb-Instalar.sh | sudo 's---g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/Controladores/Controladores/Graficas-NVIDIA-Controladores-DeWeb-Instalar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-DeWeb-Instalar.sh | bash -s Parámetro1 Parámetro2
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "13" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 13 (x)...${cFinColor}"
  echo ""

  # Instalar paquetes para compilar
    echo ""
    echo "    Instalando paquetes para compilar..."
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install build-essential
    sudo apt-get -y install linux-headers-$(uname -r)
    sudo apt-get -y install dkms
    sudo apt-get -y install pkg-config
    sudo apt-get -y install libglvnd-dev

  # Blacklistear nouveau
    echo ""
    echo "    Blacklistear nouveau..."
    echo ""
    echo "blacklist nouveau"         | sudo tee    /etc/modprobe.d/blacklist-nouveau.conf
    echo "options nouveau modeset=0" | sudo tee -a /etc/modprobe.d/blacklist-nouveau.conf
    sudo update-initramfs -u -k all
    #sudo reboot

  # Descargar el instalador
    echo ""
    echo "    Descargando el instalador..."
    echo ""
    curl -L https://es.download.nvidia.com/XFree86/Linux-x86_64/550.144.03/NVIDIA-Linux-x86_64-550.144.03.run -o /tmp/nVidiaWebDriverInstall.run
    chmod +x /tmp/nVidiaWebDriverInstall.run

  # Parar entorno gráfico
    echo ""
    echo "    Parando entorno gráfico..."
    echo ""
    sudo systemctl stop gdm
    sudo systemctl stop sddm
    sudo systemctl stop lightdm

  # Ejecutar el instalador
    echo ""
    echo "    Ejecutando el instalador..."
    echo ""
    sudo sh /tmp/nVidiaWebDriverInstall.run

  # Comprobar la grñafica
    nvidia-smi

  # Instalar CUDA Toolkit
    #curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInst/Controladores/Graficas-NVIDIA-Controladores-CUDAToolkit-DeWeb-Instalar.sh | sudo bash

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  # Instalar paquetes para compilar
    echo ""
    echo "    Instalando paquetes para compilar..."
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install build-essential
    sudo apt-get -y install linux-headers-$(uname -r)
    sudo apt-get -y install dkms
    sudo apt-get -y install pkg-config
    sudo apt-get -y install libglvnd-dev

  # Blacklistear nouveau
    echo ""
    echo "    Blacklistear nouveau..."
    echo ""
    echo "blacklist nouveau"         | sudo tee    /etc/modprobe.d/blacklist-nouveau.conf
    echo "options nouveau modeset=0" | sudo tee -a /etc/modprobe.d/blacklist-nouveau.conf
    sudo update-initramfs -u -k all
    #sudo reboot

  # Descargar el instalador
    echo ""
    echo "    Descargando el instalador..."
    echo ""
    curl -L https://es.download.nvidia.com/XFree86/Linux-x86_64/550.144.03/NVIDIA-Linux-x86_64-550.144.03.run -o /tmp/nVidiaWebDriverInstall.run
    chmod +x /tmp/nVidiaWebDriverInstall.run

  # Parar entorno gráfico
    echo ""
    echo "    Parando entorno gráfico..."
    echo ""
    sudo systemctl stop gdm
    sudo systemctl stop sddm
    sudo systemctl stop lightdm

  # Ejecutar el instalador
    echo ""
    echo "    Ejecutando el instalador..."
    echo ""
    sudo sh /tmp/nVidiaWebDriverInstall.run

  # Comprobar la grñafica
    nvidia-smi

  # Instalar CUDA Toolkit
    #curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/PostInst/Controladores/Graficas-NVIDIA-Controladores-CUDAToolkit-DeWeb-Instalar.sh | sudo bash

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

fi
