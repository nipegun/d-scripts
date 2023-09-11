#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar el nodo de Monero (XMR)
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-Nodo-XMR-InstalarYConfigurar.sh | bash
# ----------

vUsuarioNoRoot="nipegun"

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del nodo de Monero (XMR)...${cFinColor}"
  echo ""
  
# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo ""
    echo -e "${cColorRojo}    Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    echo ""
    exit
  fi

# Descargar el archivo comprimido con la última versión
  echo ""
  echo "    Descargando el archivo comprimido de la última release..."
  echo ""
  # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}      El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install wget
      echo ""
    fi
  mkdir -p /root/SoftInst/Cryptos/XMR/ 2> /dev/null
  rm -rf /root/SoftInst/Cryptos/XMR/*
  wget https://downloads.getmonero.org/gui/linux64 -O /root/SoftInst/Cryptos/XMR/monero.tar.bz2
  #wget https://downloads.getmonero.org/cli/linux64 -O /root/SoftInst/Cryptos/XMR/monero.tar.bz2

# Descomprimir el archivo
  echo ""
  echo "    Descomprimiendo el archivo..."
  echo ""
  # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}      El paquete tar no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install tar
      echo ""
    fi
  tar xjfv /root/SoftInst/Cryptos/XMR/monero.tar.bz2 -C /root/SoftInst/Cryptos/XMR/
  rm -rf /root/SoftInst/Cryptos/XMR/monero.tar.bz2

# Preparar la carpeta final
  echo ""
  echo "    Preparando la carpeta final..."
  echo ""
  mkdir -p /home/$vUsuarioNoRoot/Cryptos/XMR/bin/ 2> /dev/null
  find /root/SoftInst/Cryptos/XMR/ -type d -name monero* -exec cp -r {}/. /home/$vUsuarioNoRoot/Cryptos/XMR/bin/ \;
  rm -rf /root/SoftInst/Cryptos/XMR/*
  mkdir -p /home/$vUsuarioNoRoot/.config/monero-project/ 2> /dev/null
  echo "[General]"                                        > /home/$vUsuarioNoRoot/.config/monero-project/monero-core.conf
  echo "account_name=$vUsuarioNoRoot"                    >> /home/$vUsuarioNoRoot/.config/monero-project/monero-core.conf
  echo "askPasswordBeforeSending=true"                   >> /home/$vUsuarioNoRoot/.config/monero-project/monero-core.conf
  echo "autosave=true"                                   >> /home/$vUsuarioNoRoot/.config/monero-project/monero-core.conf
  echo "autosaveMinutes=10"                              >> /home/$vUsuarioNoRoot/.config/monero-project/monero-core.conf
  echo "blackTheme=true"                                 >> /home/$vUsuarioNoRoot/.config/monero-project/monero-core.conf
  echo "blockchainDataDir=/home/$vUsuarioNoRoot/.monero" >> /home/$vUsuarioNoRoot/.config/monero-project/monero-core.conf
  echo "checkForUpdates=true"                            >> /home/$vUsuarioNoRoot/.config/monero-project/monero-core.conf
  echo "customDecorations=true"                          >> /home/$vUsuarioNoRoot/.config/monero-project/monero-core.conf
  echo "fiatPriceEnabled=true"                           >> /home/$vUsuarioNoRoot/.config/monero-project/monero-core.conf
  echo "fiatPriceProvider=kraken"                        >> /home/$vUsuarioNoRoot/.config/monero-project/monero-core.conf
  echo "language=Espa\xf1ol"                             >> /home/$vUsuarioNoRoot/.config/monero-project/monero-core.conf
  echo "language_wallet=Espa\xf1ol"                      >> /home/$vUsuarioNoRoot/.config/monero-project/monero-core.conf
  echo "locale=es_ES"                                    >> /home/$vUsuarioNoRoot/.config/monero-project/monero-core.conf
  echo "lockOnUserInActivity=true"                       >> /home/$vUsuarioNoRoot/.config/monero-project/monero-core.conf
  echo "lockOnUserInActivityInterval=1"                  >> /home/$vUsuarioNoRoot/.config/monero-project/monero-core.conf
  echo "transferShowAdvanced=true"                       >> /home/$vUsuarioNoRoot/.config/monero-project/monero-core.conf
  echo "useRemoteNode=false"                             >> /home/$vUsuarioNoRoot/.config/monero-project/monero-core.conf
  echo "walletMode=2"                                    >> /home/$vUsuarioNoRoot/.config/monero-project/monero-core.conf

# Instalar dependencias
  echo ""
  echo "    Instalando dependencias..."
  echo ""
  apt-get -y install libxcb-icccm4
  apt-get -y install libxcb-image0
  apt-get -y install libxcb-keysyms1
  apt-get -y install libxcb-randr0
  apt-get -y install libxcb-render-util0
  apt-get -y install libxcb-xkb1
  apt-get -y install libxkbcommon-x11-0

# Autoejecución de Monero al iniciar el sistema
  echo ""
  echo "    Agregando monerod a los ComandosPostArranque..." 
  echo ""
  echo "su $vUsuarioNoRoot -c '/home/"$vUsuarioNoRoot"/scripts/c-scripts/xmr-daemon-iniciar.sh'" >> /root/scripts/ComandosPostArranque.sh

# Icono de lanzamiento en el menú gráfico
  echo ""
  echo "    Agregando la aplicación gráfica al menú..." 
  echo ""
  mkdir -p /home/$vUsuarioNoRoot/.local/share/applications/ 2> /dev/null
  echo "[Desktop Entry]"                                                  > /home/$vUsuarioNoRoot/.local/share/applications/xmr.desktop
  echo "Name=xmr GUI"                                                    >> /home/$vUsuarioNoRoot/.local/share/applications/xmr.desktop
  echo "Type=Application"                                                >> /home/$vUsuarioNoRoot/.local/share/applications/xmr.desktop
  echo "Exec=/home/$vUsuarioNoRoot/scripts/c-scripts/xmr-gui-iniciar.sh" >> /home/$vUsuarioNoRoot/.local/share/applications/xmr.desktop
  echo "Terminal=false"                                                  >> /home/$vUsuarioNoRoot/.local/share/applications/xmr.desktop
  echo "Hidden=false"                                                    >> /home/$vUsuarioNoRoot/.local/share/applications/xmr.desktop
  echo "Categories=Cryptos"                                              >> /home/$vUsuarioNoRoot/.local/share/applications/xmr.desktop
  #echo "Icon="                                                          >> /home/$vUsuarioNoRoot/.local/share/applications/xmr.desktop
  gio set /home/$vUsuarioNoRoot/.local/share/applications/xmr.desktop "metadata::trusted" yes

# Autoejecución gráfica de monero
  echo ""
  echo "    Creando el archivo de autoejecución de monero-wallet-gui para el escritorio..." 
  echo ""
  mkdir -p /home/$vUsuarioNoRoot/.config/autostart/ 2> /dev/null
  echo "[Desktop Entry]"                                                  > /home/$vUsuarioNoRoot/.config/autostart/xmr.desktop
  echo "Name=xmr GUI"                                                    >> /home/$vUsuarioNoRoot/.config/autostart/xmr.desktop
  echo "Type=Application"                                                >> /home/$vUsuarioNoRoot/.config/autostart/xmr.desktop
  echo "Exec=/home/$vUsuarioNoRoot/scripts/c-scripts/xmr-gui-iniciar.sh" >> /home/$vUsuarioNoRoot/.config/autostart/xmr.desktop
  echo "Terminal=false"                                                  >> /home/$vUsuarioNoRoot/.config/autostart/xmr.desktop
  echo "Hidden=false"                                                    >> /home/$vUsuarioNoRoot/.config/autostart/xmr.desktop
  gio set /home/$vUsuarioNoRoot/.config/autostart/xmr.desktop "metadata::trusted" yes

# Reparación de permisos
  chmod +x /home/$vUsuarioNoRoot/Cryptos/XMR/bin/*
  chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/ -R

# Parar el daemon
  chmod +x /home/$vUsuarioNoRoot/scripts/c-scripts/xmr-daemon-parar.sh
  su $vUsuarioNoRoot -c "/home/$vUsuarioNoRoot/scripts/c-scripts/xmr-daemon-parar.sh"

