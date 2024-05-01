#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Calibre en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-Calibre-Instalar.sh | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    exit
  fi

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

if [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Calibre para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Calibre para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Calibre para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Calibre para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo "  Actualizando el contenido de los repositorios..." 
echo ""
  apt-get -y update

  echo ""
  echo "  Instalando los paquetes necesarios..." 
echo ""
  apt-get -y install xdg-utils wget xz-utils python xvfb imagemagick

  mkdir /root/SoftInst/Calibre
  cd /root/SoftInst/Calibre
  wget --no-check-certificate https://download.calibre-ebook.com/linux-installer.sh
  sh /root/SoftInst/Calibre/linux-installer.sh

  echo "[Unit]"                                             > /etc/systemd/system/calibre-server.service
  echo " Description=Servidor Calibre"                     >> /etc/systemd/system/calibre-server.service
  echo " After=network.target"                             >> /etc/systemd/system/calibre-server.service
  echo ""                                                  >> /etc/systemd/system/calibre-server.service
  echo "[Service]"                                         >> /etc/systemd/system/calibre-server.service
  echo " Type=simple"                                      >> /etc/systemd/system/calibre-server.service
  echo " User=root"                                        >> /etc/systemd/system/calibre-server.service
  echo " Group=root"                                       >> /etc/systemd/system/calibre-server.service
  echo ' ExecStart=/opt/calibre/calibre-server "/Calibre"' >> /etc/systemd/system/calibre-server.service
  #echo ' ExecStart=/opt/calibre/calibre-server "/Calibre" --enable-auth --access-log /Calibre/Access.log' >> /etc/systemd/system/calibre-server.service
  echo ""                                                  >> /etc/systemd/system/calibre-server.service
  echo "[Install]"                                         >> /etc/systemd/system/calibre-server.service
  echo " WantedBy=default.target"                          >> /etc/systemd/system/calibre-server.service

  systemctl enable calibre-server

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Calibre para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  # Instalar paquetes necesarios
    apt-get -y install xdg-utils
    apt-get -y install wget
    apt-get -y install xz-utils
    apt-get -y install python
    apt-get -y install xvfb
    apt-get -y install imagemagick
    apt-get -y install libopengl0

  # Descargar el instalador
    mkdir /root/SoftInst/Calibre
    cd /root/SoftInst/Calibre
    wget --no-check-certificate https://download.calibre-ebook.com/linux-installer.sh
    sh /root/SoftInst/Calibre/linux-installer.sh

  # Crear el servicio
    echo "[Unit]"                                             > /etc/systemd/system/calibre-server.service
    echo " Description=Servidor Calibre"                     >> /etc/systemd/system/calibre-server.service
    echo " After=network.target"                             >> /etc/systemd/system/calibre-server.service
    echo ""                                                  >> /etc/systemd/system/calibre-server.service
    echo "[Service]"                                         >> /etc/systemd/system/calibre-server.service
    echo " Type=simple"                                      >> /etc/systemd/system/calibre-server.service
    echo " User=root"                                        >> /etc/systemd/system/calibre-server.service
    echo " Group=root"                                       >> /etc/systemd/system/calibre-server.service
    echo ' ExecStart=/opt/calibre/calibre-server "/Calibre"' >> /etc/systemd/system/calibre-server.service
    echo ""                                                  >> /etc/systemd/system/calibre-server.service
    echo "[Install]"                                         >> /etc/systemd/system/calibre-server.service
    echo " WantedBy=default.target"                          >> /etc/systemd/system/calibre-server.service

  # Activar el servicio
    systemctl enable calibre-server --now

  # Notificar fin del script
    echo ""
    echo "  El servidor Calibre se ha instalado correctamente."
    echo ""
    echo "  Si quieres activar la autenticación, modifica el archivo /etc/systemd/system/calibre-server.service"
    echo "  y lanza el servidor de la siguiente manera:"
    echo ""
    echo '    ExecStart=/opt/calibre/calibre-server "/Calibre" --enable-auth --access-log "/Calibre/Access.log"'
    echo ""
    echo "  Una vez iniciado con autenticación activada, para gestionar los usuarios deberás:"
    echo "    1 - Parar el servidor, con:"
    echo "      systemctl stop calibre-server"
    echo "    2 - Lanzar el comando de administración de usuarios, con:"
    echo "      calibre-server --manage-users"
    echo "    3 - Volver a lanzar el servidor, con:"
    echo "      systemctl start calibre-server"
    echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Calibre para Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  # Instalar paquetes necesarios
    apt-get -y install xdg-utils
    apt-get -y install wget
    apt-get -y install xz-utils
    apt-get -y install python
    apt-get -y install xvfb
    apt-get -y install imagemagick
    apt-get -y install libopengl0

  # Descargar el instalador
    mkdir /root/SoftInst/Calibre
    cd /root/SoftInst/Calibre
    wget --no-check-certificate https://download.calibre-ebook.com/linux-installer.sh
    sh /root/SoftInst/Calibre/linux-installer.sh

  # Crear el servicio
    echo "[Unit]"                                             > /etc/systemd/system/calibre-server.service
    echo " Description=Servidor Calibre"                     >> /etc/systemd/system/calibre-server.service
    echo " After=network.target"                             >> /etc/systemd/system/calibre-server.service
    echo ""                                                  >> /etc/systemd/system/calibre-server.service
    echo "[Service]"                                         >> /etc/systemd/system/calibre-server.service
    echo " Type=simple"                                      >> /etc/systemd/system/calibre-server.service
    echo " User=root"                                        >> /etc/systemd/system/calibre-server.service
    echo " Group=root"                                       >> /etc/systemd/system/calibre-server.service
    echo ' ExecStart=/opt/calibre/calibre-server "/Calibre"' >> /etc/systemd/system/calibre-server.service
    echo ""                                                  >> /etc/systemd/system/calibre-server.service
    echo "[Install]"                                         >> /etc/systemd/system/calibre-server.service
    echo " WantedBy=default.target"                          >> /etc/systemd/system/calibre-server.service

  # Activar el servicio
    systemctl enable calibre-server --now

  # Notificar fin del script
    echo ""
    echo "  El servidor Calibre se ha instalado correctamente."
    echo ""
    echo "  Si quieres activar la autenticación, modifica el archivo /etc/systemd/system/calibre-server.service"
    echo "  y lanza el servidor de la siguiente manera:"
    echo ""
    echo '    ExecStart=/opt/calibre/calibre-server "/Calibre" --enable-auth --access-log "/Calibre/Access.log"'
    echo ""
    echo "  Una vez iniciado con autenticación activada, para gestionar los usuarios deberás:"
    echo "    1 - Parar el servidor, con:"
    echo "      systemctl stop calibre-server"
    echo "    2 - Lanzar el comando de administración de usuarios, con:"
    echo "      calibre-server --manage-users"
    echo "    3 - Volver a lanzar el servidor, con:"
    echo "      systemctl start calibre-server"
    echo ""
    echo "  Para acceder a la web de calibre desde localhost ingresa a:"
    echo "    http://127.0.0.1:8080 o http://localhost:8080"
    echo ""

fi

