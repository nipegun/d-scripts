#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar VaultWarden en el DockerCE de Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/DockerCE-Contenedor-Instalar-VaultWarden.sh | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # linuxbase.org
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD)
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación de VaultWarden en el DockerCE de Debian 7 (Wheezy)..." 
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de VaultWarden en el DockerCE de Debian 8 (Jessie)..." 
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de VaultWarden en el DockerCE de Debian 9 (Stretch)..." 
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de VaultWarden en el DockerCE de Debian 10 (Buster)..." 
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""
 
elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de VaultWarden en el DockerCE de Debian 11 (Bullseye)..." 
  echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de instalación de VaultWarden en el DockerCE de Debian 12 (Bookworm)..." 
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo "  dialog no está instalado. Iniciando su instalación..."
      echo ""
      apt-get -y update && apt-get -y install dialog
      echo ""
    fi
  menu=(dialog --checklist "¿Donde quieres instalar VaultWarden?:" 22 76 16)
    opciones=(
      1 "En un ordenador o máquina virtual" off
      2 "En un contenedor LXC de Proxmox" off
      3 "..." off
      4 "..." off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo -e "${cColorVerde}  Instalando VaultWarden en un ordenador o máquina virtual...${cFinColor}"
          echo ""
          mkdir -p /Contenedores/VaultWarden/data 2> /dev/null

          echo ""
          echo "  Creando el comando para iniciar el contenedor docker..."
          echo ""
          echo '#!/bin/bash'                                         > /root/scripts/DockerCE-Cont-Iniciar-VaultWarden.sh
          echo ""                                                   >> /root/scripts/DockerCE-Cont-Iniciar-VaultWarden.sh
          echo "docker run -d --restart=always                  \\" >> /root/scripts/DockerCE-Cont-Iniciar-VaultWarden.sh
          echo "  --name VaultWarden                            \\" >> /root/scripts/DockerCE-Cont-Iniciar-VaultWarden.sh
          echo "  -p 8080:80                                    \\" >> /root/scripts/DockerCE-Cont-Iniciar-VaultWarden.sh
          echo "  -v /var/run/docker.sock:/var/run/docker.sock  \\" >> /root/scripts/DockerCE-Cont-Iniciar-VaultWarden.sh
          echo "  -v /Contenedores/VaultWarden/data:/data       \\" >> /root/scripts/DockerCE-Cont-Iniciar-VaultWarden.sh
          echo "  vaultwarden:latest"                               >> /root/scripts/DockerCE-Cont-Iniciar-VaultWarden.sh
          chmod +x                                                     /root/scripts/DockerCE-Cont-Iniciar-VaultWarden.sh
              
          echo ""
          echo "  Creando el comando post arranque..."
          echo ""
          echo "/root/scripts/DockerCE-Cont-Iniciar-VaultWarden.sh" >> /root/scripts/ComandosPostArranque.sh
          echo ""
          echo "  Iniciando el container por primera vez..."
          echo ""
          /root/scripts/DockerCE-Cont-Iniciar-VaultWarden.sh

        ;;

        2)

          echo ""
          echo -e "${cColorVerde}  Instalando VaultWarden en un contenedor LXC...${cFinColor}"
          echo ""
          mkdir -p /Host/VaultWarden/data 2> /dev/null

          echo ""
          echo "  Creando el comando para iniciar el contenedor docker..."
          echo ""
          echo '#!/bin/bash'                                        > /root/scripts/DockerCE-Cont-Iniciar-VaultWarden.sh
          echo ""                                                  >> /root/scripts/DockerCE-Cont-Iniciar-VaultWarden.sh
          echo "docker run -d --restart=always                 \\" >> /root/scripts/DockerCE-Cont-Iniciar-VaultWarden.sh
          echo "  --name VaultWarden                           \\" >> /root/scripts/DockerCE-Cont-Iniciar-VaultWarden.sh
          echo "  -p 8080:80                                   \\" >> /root/scripts/DockerCE-Cont-Iniciar-VaultWarden.sh
          echo "  -v /var/run/docker.sock:/var/run/docker.sock \\" >> /root/scripts/DockerCE-Cont-Iniciar-VaultWarden.sh
          echo "  -v /Host/VaultWarden/data:/data              \\" >> /root/scripts/DockerCE-Cont-Iniciar-VaultWarden.sh
          echo "  vaultwarden:latest"                              >> /root/scripts/DockerCE-Cont-Iniciar-VaultWarden.sh
          chmod +x                                                    /root/scripts/DockerCE-Cont-Iniciar-VaultWarden.sh

          echo ""
          echo "  Creando el comando post arranque..."
          echo ""
          echo "/root/scripts/DockerCE-Cont-Iniciar-VaultWarden.sh" >> /root/scripts/ComandosPostArranque.sh

          echo ""
          echo "  Iniciando el container por primera vez..."
          echo ""
          /root/scripts/DockerCE-Cont-Iniciar-VaultWarden.sh

        ;;

        3)

          echo ""
          echo -e "${cColorVerde}  ...${cFinColor}"
          echo ""

        ;;

        4)

          echo ""
          echo -e "${cColorVerde}  ...${cFinColor}"
          echo ""

https://gist.github.com/heinoldenhuis/f8164f73e5bff048e76fb4fff2e824e1



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
    #echo "    Asignando contraseña al usuario bitwarden..."    #echo ""
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





        ;;
        
      esac

    done

fi
