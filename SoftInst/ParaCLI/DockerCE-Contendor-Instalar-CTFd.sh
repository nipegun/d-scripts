#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar CTFd en el DockerCE de Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/DockerCE-Contenedor-Instalar-CTFd.sh | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  #if [ $(id -u) -ne 0 ]; then     # Sólo comprueba si es root
  if [[ $EUID -ne 0 ]]; then       # Comprueba si es root o sudo
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse con privilegios de administrador (como root o con sudo).${cFinColor}"
    echo ""
    exit
  fi

# Crear el menú
  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo "    El paquete dialog no está instalado. Iniciando su instalación..."
      echo ""
      apt-get -y update && apt-get -y install dialog
      echo ""
    fi
  menu=(dialog --timeout 5 --checklist "¿Donde quieres instalar CTFd?:" 22 76 16)
    opciones=(
      1 "En un ordenador o máquina virtual" on
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
          echo -e "${cColorVerde}  Instalando CTFd en un ordenador o máquina virtual...${cFinColor}"
          echo ""
          mkdir -p /Contenedores/CTFd/data 2> /dev/null

          echo ""
          echo "  Creando el comando para iniciar el contenedor docker..."
          echo ""
          echo '#!/bin/bash'                                        > /root/scripts/ParaEsteDebian/DockerCE-Cont-TheHive-Iniciar.sh
          echo ""                                                  >> /root/scripts/ParaEsteDebian/DockerCE-Cont-TheHive-Iniciar.sh
          echo "docker run -d --restart=always                 \\" >> /root/scripts/ParaEsteDebian/DockerCE-Cont-TheHive-Iniciar.sh
          echo "  --name CTFd                                  \\" >> /root/scripts/ParaEsteDebian/DockerCE-Cont-TheHive-Iniciar.sh
          echo "  -p 8000:8000                                 \\" >> /root/scripts/ParaEsteDebian/DockerCE-Cont-TheHive-Iniciar.sh
          echo "  -v /Contenedores/CTFd/data:/data             \\" >> /root/scripts/ParaEsteDebian/DockerCE-Cont-TheHive-Iniciar.sh
          echo "  -v /var/run/docker.sock:/var/run/docker.sock \\" >> /root/scripts/ParaEsteDebian/DockerCE-Cont-TheHive-Iniciar.sh
          echo "  ctfd/ctfd:latest"                                >> /root/scripts/ParaEsteDebian/DockerCE-Cont-TheHive-Iniciar.sh
          chmod +x                                                    /root/scripts/ParaEsteDebian/DockerCE-Cont-TheHive-Iniciar.sh

          echo ""
          echo "  Creando el comando post arranque..."
          echo ""
          echo "/root/scripts/ParaEsteDebian/DockerCE-Cont-CTFd-Iniciar.sh" >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

          echo ""
          echo "  Iniciando el container por primera vez..."
          echo ""
          /root/scripts/ParaEsteDebian/DockerCE-Cont-CTFd-Iniciar.sh

        ;;

        2)

          echo ""
          echo -e "${cColorVerde}  Instalando CTFd en un contenedor LXC...${cFinColor}"
          echo ""
          mkdir -p /Host/CTFd/data 2> /dev/null

          echo ""
          echo "  Creando el comando para iniciar el contenedor docker..."
          echo ""
          echo '#!/bin/bash'                                        > /root/scripts/ParaEsteDebian/DockerCE-Cont-CTFd-Iniciar.sh
          echo ""                                                  >> /root/scripts/ParaEsteDebian/DockerCE-Cont-CTFd-Iniciar.sh
          echo "docker run -d --restart=always -it                 \\" >> /root/scripts/ParaEsteDebian/DockerCE-Cont-CTFd-Iniciar.sh
          echo "  --name CTFd                                  \\" >> /root/scripts/ParaEsteDebian/DockerCE-Cont-CTFd-Iniciar.sh
          echo "  -v /var/run/docker.sock:/var/run/docker.sock \\" >> /root/scripts/ParaEsteDebian/DockerCE-Cont-CTFd-Iniciar.sh
          echo "  -v /Host/CTFd/data:/data                     \\" >> /root/scripts/ParaEsteDebian/DockerCE-Cont-CTFd-Iniciar.sh
          echo "  -p 8000:8000                                 \\" >> /root/scripts/ParaEsteDebian/DockerCE-Cont-CTFd-Iniciar.sh
          echo "  ctfd/ctfd:latest"                                >> /root/scripts/ParaEsteDebian/DockerCE-Cont-CTFd-Iniciar.sh
          chmod +x                                                    /root/scripts/ParaEsteDebian/DockerCE-Cont-CTFd-Iniciar.sh

          echo ""
          echo "  Creando el comando post arranque..."
          echo ""
          echo "/root/scripts/ParaEsteDebian/DockerCE-Cont-CTFd-Iniciar.sh" >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

          echo ""
          echo "  Iniciando el container por primera vez..."
          echo ""
          /root/scripts/ParaEsteDebian/DockerCE-Cont-CTFd-Iniciar.sh

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


