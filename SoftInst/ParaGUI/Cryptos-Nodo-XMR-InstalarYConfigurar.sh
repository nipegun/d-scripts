#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

---
#  Script de NiPeGun para instalar y configurar la cadena de bloques de Monero (XMR)
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaGUI/Cryptos-Nodo-XMR-InstalarYConfigurar.sh | bash
---

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

UsuarioNoRoot="nipegun"

echo ""
echo -e "${cColorVerde}------------------------------------------------------------------------${cFinColor}"
echo -e "${cColorVerde}  Iniciando el script de instalación de la cadena de bloques de XMR...${cFinColor}"
echo -e "${cColorVerde}------------------------------------------------------------------------${cFinColor}"
echo ""

echo ""
echo "  Descargando el archivo comprimido de la última release..."
echo ""
# Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "  wget no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install wget
    echo ""
  fi
mkdir -p /root/SoftInst/Cryptos/XMR/ 2> /dev/null
rm -rf /root/SoftInst/Cryptos/XMR/*
wget https://downloads.getmonero.org/gui/linux64 -O /root/SoftInst/Cryptos/XMR/monero.tar.bz2
#wget https://downloads.getmonero.org/cli/linux64 -O /root/SoftInst/Cryptos/XMR/monero.tar.bz2

echo ""
echo "  Descomprimiendo el archivo..."
echo ""
# Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "  tar no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update
    apt-get -y install tar
    echo ""
  fi
tar xjfv /root/SoftInst/Cryptos/XMR/monero.tar.bz2 -C /root/SoftInst/Cryptos/XMR/
rm -rf /root/SoftInst/Cryptos/XMR/monero.tar.bz2

echo ""
echo "  Preparando la carpeta final..."
echo ""
mkdir -p /home/$UsuarioNoRoot/Cryptos/XMR/bin/ 2> /dev/null
find /root/SoftInst/Cryptos/XMR/ -type d -name monero* -exec cp -r {}/. /home/$UsuarioNoRoot/Cryptos/XMR/bin/ \;
rm -rf /root/SoftInst/Cryptos/XMR/*
mkdir -p /home/$UsuarioNoRoot/.config/monero-project/ 2> /dev/null
echo "[General]"                                       > /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
echo "account_name=$UsuarioNoRoot"                    >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
echo "askPasswordBeforeSending=true"                  >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
echo "autosave=true"                                  >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
echo "autosaveMinutes=10"                             >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
echo "blackTheme=true"                                >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
echo "blockchainDataDir=/home/$UsuarioNoRoot/.monero" >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
echo "checkForUpdates=true"                           >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
echo "customDecorations=true"                         >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
echo "fiatPriceEnabled=true"                          >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
echo "fiatPriceProvider=kraken"                       >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
echo "language=Espa\xf1ol"                            >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
echo "language_wallet=Espa\xf1ol"                     >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
echo "locale=es_ES"                                   >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
echo "lockOnUserInActivity=true"                      >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
echo "lockOnUserInActivityInterval=1"                 >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
echo "transferShowAdvanced=true"                      >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
echo "useRemoteNode=false"                            >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf
echo "walletMode=2"                                   >> /home/$UsuarioNoRoot/.config/monero-project/monero-core.conf

echo ""
echo "  Instalando paquetes necesarios para ejecutar la cartera..."
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
  echo "  Agregando monerod a los ComandosPostArranque..."
  echo ""
  echo "su $UsuarioNoRoot -c '/home/"$UsuarioNoRoot"/scripts/c-scripts/xmr-daemon-iniciar.sh'" >> /root/scripts/ComandosPostArranque.sh

# Icono de lanzamiento en el menú gráfico
  echo ""
  echo "  Agregando la aplicación gráfica al menú..."
  echo ""
  mkdir -p /home/$UsuarioNoRoot/.local/share/applications/ 2> /dev/null
  echo "[Desktop Entry]"                                                    > /home/$UsuarioNoRoot/.local/share/applications/xmr.desktop
  echo "Name=xmr GUI"                                                      >> /home/$UsuarioNoRoot/.local/share/applications/xmr.desktop
  echo "Type=Application"                                                  >> /home/$UsuarioNoRoot/.local/share/applications/xmr.desktop
  echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/xmr-gui-iniciar.sh"    >> /home/$UsuarioNoRoot/.local/share/applications/xmr.desktop
  echo "Terminal=false"                                                    >> /home/$UsuarioNoRoot/.local/share/applications/xmr.desktop
  echo "Hidden=false"                                                      >> /home/$UsuarioNoRoot/.local/share/applications/xmr.desktop
  echo "Categories=Cryptos"                                                >> /home/$UsuarioNoRoot/.local/share/applications/xmr.desktop
  #echo "Icon="                                                            >> /home/$UsuarioNoRoot/.local/share/applications/xmr.desktop
  gio set /home/$UsuarioNoRoot/.local/share/applications/xmr.desktop "metadata::trusted" yes

# Autoejecución gráfica de monero
  echo ""
  echo "  Creando el archivo de autoejecución de monero-wallet-gui para el escritorio..."
  echo ""
  mkdir -p /home/$UsuarioNoRoot/.config/autostart/ 2> /dev/null
  echo "[Desktop Entry]"                                                 > /home/$UsuarioNoRoot/.config/autostart/xmr.desktop
  echo "Name=xmr GUI"                                                   >> /home/$UsuarioNoRoot/.config/autostart/xmr.desktop
  echo "Type=Application"                                               >> /home/$UsuarioNoRoot/.config/autostart/xmr.desktop
  echo "Exec=/home/$UsuarioNoRoot/scripts/c-scripts/xmr-gui-iniciar.sh" >> /home/$UsuarioNoRoot/.config/autostart/xmr.desktop
  echo "Terminal=false"                                                 >> /home/$UsuarioNoRoot/.config/autostart/xmr.desktop
  echo "Hidden=false"                                                   >> /home/$UsuarioNoRoot/.config/autostart/xmr.desktop
  gio set /home/$UsuarioNoRoot/.config/autostart/xmr.desktop "metadata::trusted" yes

# Reparación de permisos
  chmod +x /home/$UsuarioNoRoot/Cryptos/XMR/bin/*
  chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R

# Parar el daemon
  chmod +x /home/$UsuarioNoRoot/scripts/c-scripts/xmr-daemon-parar.sh
  su $UsuarioNoRoot -c "/home/$UsuarioNoRoot/scripts/c-scripts/xmr-daemon-parar.sh"

