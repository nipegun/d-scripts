#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar BitWarden en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/BitWarden-InstalarYConfigurar.sh | bash
#
# Ejecución remota sin caché:
#  curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/BitWarden-InstalarYConfigurar.sh | bash
#
# Ejecución remota con parámetros:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/BitWarden-InstalarYConfigurar.sh | bash -s Parámetro1 Parámetro2
# ----------

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
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
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de BitWarden para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de BitWarden para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de BitWarden para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de BitWarden para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de BitWarden para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de BitWarden para Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  # Desinstalar posibles versiones previas
    echo ""
    echo "    Desinstalando posibles versiones previas..."
    echo ""
    apt-get -y remove docker
    apt-get -y remove docker-engine
    apt-get -y remove docker.io
    apt-get -y remove containerd
    apt-get -y remove runc
    rm -rf /var/lib/docker
    rm -rf /var/lib/containerd
 
  # Agregar el repositorio de Docker
    echo ""
    echo "    Agregando repositorio de docker..."
    echo ""
    apt-get -y update
    apt-get -y install ca-certificates
    apt-get -y install curl
    apt-get -y install gnupg
    apt-get -y install lsb-release
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get -y update
    chmod a+r /etc/apt/keyrings/docker.gpg
    apt-get -y update

  # Instalar Docker Engine
    echo ""
    echo "    Instalando docker engine..."
    echo ""
    apt-get -y install docker-ce
    apt-get -y install docker-ce-cli
    apt-get -y install containerd.io
    apt-get -y install docker-compose-plugin
    # Comprobar que docker-engine se instaló
      # docker run hello-world

  # Crear usuario y grupo
    echo ""
    echo "    Creando el usuario bitwarden..."
    echo ""
    adduser bitwarden

    #echo ""
    #echo "    Asignando contraseña al usuario bitwarden..."
    #echo ""
    #passwd bitwarden

    echo ""
    echo "    Creando el grupo docker..."
    echo ""
    groupadd docker

    echo ""
    echo "    Agregando el usuario bitwarden al grupo docker..."
    echo ""
    usermod -aG docker bitwarden

    echo ""
    echo "    Creando la carpeta de instalación para bitwarden..."
    echo ""
    mkdir /opt/bitwarden
    chmod -R 700 /opt/bitwarden
    chown -R bitwarden:bitwarden /opt/bitwarden

  # Instalar bitwarden desde el script oficial
    echo ""
    echo "    Instalando BitWarden usando el script oficial..."
    echo ""
    cd /opt/bitwarden
    curl -Lso bitwarden.sh https://go.btwrdn.co/bw-sh && chmod 700 bitwarden.sh
    chown bitwarden:bitwarden /opt/bitwarden/ -R
    #./bitwarden.sh install
    su - bitwarden -c "/opt/bitwarden/bitwarden.sh install"

  # Agregando bitwarden a los ComandosPostArranque
    echo ""                                                        >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
    echo "# Iniciar BitWarden"                                     >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
    echo "  #/opt/bitwarden/bitwarden.sh start"                    >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
    echo '  su - bitwarden -c "/opt/bitwarden/bitwarden.sh start"' >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
    echo ""                                                        >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

  # Reparar que no se pueda crear la primera cuenta
    su - bitwarden -c "/opt/bitwarden/bitwarden.sh stop"
    vIDAdmin=$(docker images --filter=reference=bitwarden/admin --format "{{.ID}}")
    vIDMSSQL=$(docker images --filter=reference=bitwarden/mssql --format "{{.ID}}")
    docker image rm $vIDAdmin $vIDMSSQL
    su - bitwarden -c "/opt/bitwarden/bitwarden.sh updateself"
    su - bitwarden -c "/opt/bitwarden/bitwarden.sh update"
    su - bitwarden -c "/opt/bitwarden/bitwarden.sh start"

  # Notificar fin del ejecución del script
    echo ""
    echo "  Ejecución del script de instalación de Bitwarden, finalizada."
    echo ""
    echo "    La ID de instalación y la llave se han guardado en:"
    echo "      /opt/bitwarden/bwdata/env/global.override.env"
    echo ""
    echo "    Si necesitas hacer cambios adicionales en la configuración edita:"
    echo "      /opt/bitwarden/bwdata/config.yml"
    echo "    y luego ejecuta:"
    echo "      /opt/bitwarden/bitwarden.sh rebuild o /opt/bitwarden/bitwarden.sh update"
    echo ""
    echo "    Para actualizar Bitwarden, ejecuta:"
    echo "      /opt/bitwarden/bitwarden.sh updateself"
    echo "    y luego:"
    echo "      /opt/bitwarden/bitwarden.sh update"
    echo ""
    echo "    Para registrar la primera cuenta accede a:"
    echo "      $(cat /opt/bitwarden/bwdata/env/global.override.env | grep vault | cut -d'=' -f2)/#/register"
    echo ""

fi
