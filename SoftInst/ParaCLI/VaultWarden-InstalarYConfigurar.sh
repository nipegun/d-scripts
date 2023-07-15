#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.



https://gist.github.com/heinoldenhuis/f8164f73e5bff048e76fb4fff2e824e1






# ----------
#  Script de NiPeGun para instalar y configurar VaultWarden en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/VaultWarden-InstalarYConfigurar.sh | bash
#
#  Ejecución remota sin caché:
#  curl -s -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/VaultWarden-InstalarYConfigurar.sh | bash
#
#  Ejecución remota con parámetros:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/VaultWarden-InstalarYConfigurar.sh | bash -s Parámetro1 Parámetro2
# ----------

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}" >&2
    exit 1
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
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de VaultWarden para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de VaultWarden para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de VaultWarden para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de VaultWarden para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de VaultWarden para Debian 11 (Bullseye)...${cFinColor}"
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
    echo "    Creando el usuario vaultwarden..."
    echo ""
    adduser vaultwarden
    #echo ""
    #echo "    Asignando contraseña al usuario bitwarden..."
    #echo ""
    #passwd vaultwarden
    echo ""
    echo "    Creando el grupo docker..."
    echo ""
    groupadd docker
    echo ""
    echo "    Agregando el usuario vaultwarden al grupo docker..."
    echo ""
    usermod -aG docker vaultwarden
    echo ""
    echo "    Creando la carpeta de instalación para vaultwarden..."
    echo ""
    mkdir /opt/vaultwarden
    chmod -R 700 /opt/vaultwarden
    chown -R vaultwarden:vaultwarden /opt/vaultwarden

  # Instalar bitwarden desde el script oficial
    echo ""
    echo "    Instalando el docker de BitWarden..."
    echo ""
    docker pull vaultwarden/server:latest
    docker run -d --name vaultwarden -v /vw-data/:/data/ -p 80:80 vaultwarden/server:latest

  # Agregando bitwarden a los ComandosPostArranque
    echo ""                                    >> /root/scripts/ComandosPostArranque.sh
    echo "# Iniciar BitWarden"                 >> /root/scripts/ComandosPostArranque.sh
    echo "  /opt/bitwarden/bitwarden.sh start" >> /root/scripts/ComandosPostArranque.sh
    echo ""                                    >> /root/scripts/ComandosPostArranque.sh

fi
