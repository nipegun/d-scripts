#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar Heimdall en el DockerCE de Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Dockers/10010-10011-Heimdall.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Dockers/10010-10011-Heimdall.sh | sed 's-sudo--g' | bash
#
# Comando: docker run -d --restart=always --name Heimdall -p 80:80 -p 443:443 -e PUID=1000 -e PGID=1000 -e TZ=Europe/Madrid lscr.io/linuxserver/heimdall:latest
# ----------

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
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Heimdall en el DockerCE de Debian...${cFinColor}"
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
  menu=(dialog --radiolist "¿Donde quieres instalar Heimdall?:" 22 76 16)
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
        echo -e "${cColorVerde}  Instalando Heimdall en un ordenador o máquina virtual...${cFinColor}"
        echo ""

        # Crear carpetas
          sudo mkdir -p /Contenedores/Heimdall/data/   2> /dev/null
          sudo mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null

        # Crear el script iniciador
          echo ""
          echo "    Creando el script iniciador..."
          echo ""
          echo '#!/bin/bash'                                       | sudo tee    /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh
          echo ''                                                  | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh
          echo 'docker run -d --restart=always                 \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh
          echo '  --name Heimdall                              \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh
          echo '  -p 10010:80                                  \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh
          echo '  -p 10011:443                                 \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh
          echo '  -e PUID=1000                                 \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh
          echo '  -e PGID=1000                                 \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh
          echo '  -e TZ=Europe/Madrid                          \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh
          echo '  -v /Contenedores/Heimdall/config:/config     \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh
          echo '  lscr.io/linuxserver/heimdall:latest'             | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh
          sudo chmod +x                                                          /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh

        # Insertar el script iniciador en los comandos post arranque
          echo ""
          echo "    Insertando el script iniciador en los ComandosPostArranque..."
          echo ""
          echo "/root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh" | sudo tee -a /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

        # Iniciar el docker por primera vez
          echo ""
          echo "    Iniciando el container por primera vez..."
          echo ""
          sudo /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh

        # Notificar fin de ejecución del script
          echo ""
          echo "  Script de instalación del Docker de Heimdall, finalizado."
          echo ""

      ;;

      2)

        echo ""
        echo -e "${cColorVerde}  Instalando Heimdall en un contenedor LXC...${cFinColor}"
        echo ""

        # Crear carpetas
          sudo mkdir -p /Host/Heimdall/data 2> /dev/null
          sudo mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null

        # Crear el script iniciador
          echo ""
          echo "  Creando el script iniciador..."
          echo ""
          echo '#!/bin/bash'                                       | sudo tee    /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh
          echo ''                                                  | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh
          echo 'docker run -d --restart=always                 \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh
          echo '  --name Heimdall                              \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh
          echo '  -p 10010:80                                  \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh
          echo '  -p 10011:443                                 \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh
          echo '  -e PUID=1000                                 \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh
          echo '  -e PGID=1000                                 \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh
          echo '  -e TZ=Europe/Madrid                          \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh
          echo '  -v /Host/Heimdall/config:/config             \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh
          echo '  lscr.io/linuxserver/heimdall:latest'             | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh
          sudo chmod +x                                                          /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh

        # Insertar el script iniciador en los comandos post arranque
          echo ""
          echo "    Insertando el script iniciador en los ComandosPostArranque..."
          echo ""
          echo "/root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh" | sudo tee -a /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

        # Iniciar el docker por primera vez
          echo ""
          echo "    Iniciando el container por primera vez..."
          echo ""
          sudo /root/scripts/ParaEsteDebian/DockerCE-Cont-Heimdall-Iniciar.sh

        # Notificar fin de ejecución del script
          echo ""
          echo "  Script de instalación del Docker de Heimdall, finalizado."
          echo ""

      ;;

    esac

  done

