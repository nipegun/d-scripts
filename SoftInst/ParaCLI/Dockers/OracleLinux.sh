#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar OracleLinux en el DockerCE de Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Dockers/OracleLinux.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Dockers/OracleLinux.sh | sed 's-sudo--g' | bash
# ----------

VerOLDeseada=8

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OracleLinux en el DockerCE de Debian...${cFinColor}"
  echo ""

# Crear el menú
  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo "   "
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install dialog
      echo ""
    fi
  menu=(dialog --checklist "¿Donde quieres instalar OracleLinux?:" 22 76 16)
    opciones=(
      1 "En un ordenador o máquina virtual" off
      2 "En un contenedor LXC de Proxmox"   off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo -e "${cColorVerde}  Instalando OracleLinux en un ordenador o máquina virtual...${cFinColor}"
          echo ""
          sudo mkdir -p /Contenedores/OracleLinux/data 2> /dev/null

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
        
      esac

    done

