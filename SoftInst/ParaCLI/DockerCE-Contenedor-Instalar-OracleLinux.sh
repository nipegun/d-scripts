#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar OracleLinux en el DockerCE de Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/DockerCE-Contenedor-Instalar-OracleLinux.sh | bash
# ----------

VerOLDeseada=8

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

## Determinar la versión de Debian

   if [ -f /etc/os-release ]; then
       # Para systemd y freedesktop.org
       . /etc/os-release
       cNomSO=$NAME
       cVerSO=$VERSION_ID
   elif type lsb_release >/dev/null 2>&1; then
       # linuxbase.org
       cNomSO=$(lsb_release -si)
       cVerSO=$(lsb_release -sr)
   elif [ -f /etc/lsb-release ]; then
       # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       cNomSO=$DISTRIB_ID
       cVerSO=$DISTRIB_RELEASE
   elif [ -f /etc/debian_version ]; then
       # Para versiones viejas de Debian.
       cNomSO=Debian
       cVerSO=$(cat /etc/debian_version)
   else
       # Para el viejo uname (También funciona para BSD)
       cNomSO=$(uname -s)
       cVerSO=$(uname -r)
   fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de OracleLinux en el DockerCE de Debian 7 (Wheezy)..."
  echo "--------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de OracleLinux en el DockerCE de Debian 8 (Jessie)..."
  echo "--------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de OracleLinux en el DockerCE de Debian 9 (Stretch)..."
  echo "---------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de OracleLinux en el DockerCE de Debian 10 (Buster)..."
  echo "---------------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""
 
elif [ $cVerSO == "11" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de OracleLinux en el DockerCE de Debian 11 (Bullseye)..."
  echo "-----------------------------------------------------------------------------------------------"
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "  dialog no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update && apt-get -y install dialog
     echo ""
   fi
  menu=(dialog --timeout 5 --checklist "¿Donde quieres instalar OracleLinux?:" 22 76 16)
    opciones=(
      1 "En un ordenador o máquina virtual" on
      2 "En un contenedor LXC de Proxmox" off
      3 "..." off
      4 "..." off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  clear

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo -e "${cColorVerde}  Instalando OracleLinux en un ordenador o máquina virtual...${cFinColor}"
          echo ""
          mkdir -p /Contenedores/OracleLinux/data 2> /dev/null

          echo ""
          echo "  Creando el comando para iniciar el contenedor docker..."
          echo ""
          echo '#!/bin/bash'                                        > /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh
          echo ""                                                  >> /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh
          echo "docker run -d --restart=always                 \\" >> /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh
          echo "  --name OracleLinux                           \\" >> /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh
          echo "  -p 22001:22                                  \\" >> /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh
          echo "  -p 1521:9444                                 \\" >> /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh
          echo "  -p 1630:1630                                 \\" >> /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh
          echo "  -v /var/run/docker.sock:/var/run/docker.sock \\" >> /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh
          echo "  -v /Contenedores/OracleLinux/data:/data      \\" >> /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh
          echo "  oraclelinux:$VerOLDeseada"                       >> /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh
          chmod +x                                                    /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh

          echo ""
          echo "  Creando el comando post arranque..."
          echo ""
          echo "/root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh" >> /root/scripts/ComandosPostArranque.sh

          echo ""
          echo "  Iniciando el container por primera vez..."
          echo ""
          /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh

        ;;

        2)

          echo ""
          echo -e "${cColorVerde}  Instalando OracleLinux en un contenedor LXC...${cFinColor}"
          echo ""
          mkdir -p /Host/OracleLinux/data 2> /dev/null

          echo ""
          echo "  Creando el comando para iniciar el contenedor docker..."
          echo ""
          echo '#!/bin/bash'                                        > /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh
          echo ""                                                  >> /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh
          echo "docker run -d --restart=always                 \\" >> /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh
          echo "  --name OracleLinux                           \\" >> /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh
          echo "  -v /var/run/docker.sock:/var/run/docker.sock \\" >> /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh
          echo "  -v /Host/OracleLinux/data:/data              \\" >> /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh
          echo "  -p 22001:22                                  \\" >> /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh
          echo "  -p 1521:9444                                 \\" >> /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh
          echo "  -p 1630:1630                                 \\" >> /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh
          echo "  oraclelinux:$VerOLDeseada"                       >> /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh
          chmod +x                                                    /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh

          echo ""
          echo "  Creando el comando post arranque..."
          echo ""
          echo "/root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh" >> /root/scripts/ComandosPostArranque.sh

          echo ""
          echo "  Iniciando el container por primera vez..."
          echo ""
          /root/scripts/DockerCE-Cont-OracleLinux-Iniciar.sh

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

        ;;
        
      esac

    done

fi

