#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar Scanopy en el DockerCE de Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Dockers/10020-10021-Scanopy.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Dockers/10020-10021-Scanopy.sh | sed 's-sudo--g' | bash
#
# Comando: docker run -d --restart=always --name Scanopy -p 3000:3000 scanopyai/scanopy:latest
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
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Scanopy en el DockerCE de Debian...${cFinColor}"
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
  menu=(dialog --radiolist "¿Donde quieres instalar Scanopy?:" 22 76 16)
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
        echo -e "${cColorVerde}  Instalando Scanopy en un ordenador o máquina virtual...${cFinColor}"
        echo ""

        # Crear el script iniciador
          echo ''
          echo '    Creando el script iniciador...'
          echo ''
          echo '#!/bin/bash'                                                                               | sudo tee    /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo ''                                                                                          | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo 'docker run -d  --restart=always                                                        \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  --name scanopy-daemon                                                                \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  --network host                                                                       \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  --privileged                                                                         \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_LOG_LEVEL=info                                                            \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_SERVER_PORT=60072                                                         \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_DAEMON_PORT=60073                                                         \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_SERVER_URL=http://127.0.0.1:60072                                         \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_PORT=60073                                                                \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_BIND_ADDRESS=0.0.0.0                                                      \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_NAME=scanopy-daemon                                                       \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_HEARTBEAT_INTERVAL=30                                                     \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_MODE=Push                                                                 \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -v /Contenedores/Scanopy/root/.config/daemon:/root/.config/daemon                    \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -v /var/run/docker.sock:/var/run/docker.sock:ro                                      \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  ghcr.io/scanopy/scanopy/daemon:latest'                                                   | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo ''                                                                                          | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo 'docker run -d  --restart=always                                                        \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  --name scanopy-postgres                                                              \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  --network scanopy                                                                    \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e POSTGRES_DB=scanopy                                                               \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e POSTGRES_USER=postgres                                                            \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e POSTGRES_PASSWORD=password                                                        \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -v /Contenedores/Scanopy/var/lib/postgresql/data:/var/lib/postgresql/data            \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  postgres:17-alpine'                                                                      | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo ''                                                                                          | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo 'docker run -d  --restart=always                                                        \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  --name scanopy-server                                                                \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  --network scanopy                                                                    \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -p 60072:60072                                                                       \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_LOG_LEVEL=info                                                            \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_SERVER_PORT=60072                                                         \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_DAEMON_PORT=60073                                                         \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_DATABASE_URL=postgresql://postgres:password@scanopy-postgres:5432/scanopy \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_WEB_EXTERNAL_PATH=/app/static                                             \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_PUBLIC_URL=http://localhost:60072                                         \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_INTEGRATED_DAEMON_URL=http://172.17.0.1:60073                             \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -v /Contenedores/Scanopy/data:/data                                                  \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  ghcr.io/scanopy/scanopy/server:latest'                                                   | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          sudo chmod +x                                                                                                  /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          sed -i 's|\\\\|\\|g'                                                                                           /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh

        # Crear carpetas
          sudo mkdir -p /Contenedores/Scanopy/root/.config/daemon     2> /dev/null
          sudo mkdir -p /Contenedores/Scanopy/var/lib/postgresql/data 2> /dev/null
          sudo mkdir -p /Contenedores/Scanopy/data                    2> /dev/null
          sudo mkdir -p /root/scripts/ParaEsteDebian                  2> /dev/null

        # Insertar el script iniciador en los comandos post arranque
          echo ""
          echo "    Insertando el script iniciador en los ComandosPostArranque..."
          echo ""
          echo "/root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh" | sudo tee -a /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

        # Iniciar el docker por primera vez
          echo ""
          echo "    Iniciando el container por primera vez..."
          echo ""
          sudo /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh

        # Notificar fin de ejecución del script
          echo ""
          echo "  Script de instalación del Docker de Scanopy, finalizado."
          echo ""

      ;;

      2)

        echo ""
        echo -e "${cColorVerde}  Instalando Scanopy en un contenedor LXC...${cFinColor}"
        echo ""

        # Crear el script iniciador
          echo ''
          echo '    Creando el script iniciador...'
          echo ''
          echo '#!/bin/bash'                                                                               | sudo tee    /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo ''                                                                                          | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo 'docker run -d  --restart=always                                                        \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  --name scanopy-daemon                                                                \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  --network host                                                                       \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  --privileged                                                                         \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_LOG_LEVEL=info                                                            \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_SERVER_PORT=60072                                                         \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_DAEMON_PORT=60073                                                         \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_SERVER_URL=http://127.0.0.1:60072                                         \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_PORT=60073                                                                \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_BIND_ADDRESS=0.0.0.0                                                      \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_NAME=scanopy-daemon                                                       \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_HEARTBEAT_INTERVAL=30                                                     \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_MODE=Push                                                                 \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -v /Host/Scanopy/root/.config/daemon:/root/.config/daemon                            \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -v /var/run/docker.sock:/var/run/docker.sock:ro                                      \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  ghcr.io/scanopy/scanopy/daemon:latest'                                                   | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo ''                                                                                          | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo 'docker run -d  --restart=always                                                        \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  --name scanopy-postgres                                                              \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  --network scanopy                                                                    \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e POSTGRES_DB=scanopy                                                               \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e POSTGRES_USER=postgres                                                            \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e POSTGRES_PASSWORD=password                                                        \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -v /Host/Scanopy/var/lib/postgresql/data:/var/lib/postgresql/data                    \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  postgres:17-alpine'                                                                      | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo ''                                                                                          | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo 'docker run -d  --restart=always                                                        \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  --name scanopy-server                                                                \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  --network scanopy                                                                    \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -p 60072:60072                                                                       \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_LOG_LEVEL=info                                                            \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_SERVER_PORT=60072                                                         \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_DAEMON_PORT=60073                                                         \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_DATABASE_URL=postgresql://postgres:password@scanopy-postgres:5432/scanopy \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_WEB_EXTERNAL_PATH=/app/static                                             \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_PUBLIC_URL=http://localhost:60072                                         \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -e SCANOPY_INTEGRATED_DAEMON_URL=http://172.17.0.1:60073                             \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  -v /Host/Scanopy/data:/data                                                          \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          echo '  ghcr.io/scanopy/scanopy/server:latest'                                                   | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          sudo chmod +x                                                                                                  /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh
          sed -i 's|\\\\|\\|g'                                                                                           /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh

        # Crear carpetas
          sudo mkdir -p /Host/Scanopy/root/.config/daemon     2> /dev/null
          sudo mkdir -p /Host/Scanopy/var/lib/postgresql/data 2> /dev/null
          sudo mkdir -p /Host/Scanopy/data                    2> /dev/null
          sudo mkdir -p /root/scripts/ParaEsteDebian          2> /dev/null

        # Insertar el script iniciador en los comandos post arranque
          echo ""
          echo "    Insertando el script iniciador en los ComandosPostArranque..."
          echo ""
          echo "/root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh" | sudo tee -a /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

        # Iniciar el docker por primera vez
          echo ""
          echo "    Iniciando el container por primera vez..."
          echo ""
          sudo /root/scripts/ParaEsteDebian/DockerCE-Cont-Scanopy-Iniciar.sh

        # Notificar fin de ejecución del script
          echo ""
          echo "  Script de instalación del Docker de Scanopy, finalizado."
          echo ""

      ;;

    esac

  done
