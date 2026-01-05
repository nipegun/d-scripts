#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar Flectra en el DockerCE de Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Dockers/10050-10051-Flectra.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Dockers/10050-10051-Flectra.sh | sed 's-sudo--g' | bash
#
# Comando 1: sudo docker run -d --restart=always --name db -e POSTGRES_USER=flectra -e POSTGRES_PASSWORD=flectra postgres:14
# Comando 2: sudo docker run -d --restart=always --name Flectra -p 7073:7073 -v /path/to/config:/etc/flectra --link db:db -t flectrahq/flectra:latest"
#
# Enlace: https://hub.docker.com/r/flectrahq/flectra
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
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Flectra en el DockerCE de Debian...${cFinColor}"
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
  menu=(dialog --radiolist "¿Donde quieres instalar Flectra?:" 22 76 16)
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
        echo -e "${cColorVerde}  Instalando Flectra en un ordenador o máquina virtual...${cFinColor}"
        echo ""
 
        # Crear el script iniciador
          echo ''
          echo '    Creando el script iniciador...'
          echo ''
          echo '#!/bin/bash'                                                                    | sudo tee    /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo ''                                                                               | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo 'docker run -d --restart=always                                              \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  --name FlectraDB                                                          \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  -e POSTGRES_DB=flectra                                                    \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  -e POSTGRES_USER=flectra                                                  \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  -e POSTGRES_PASSWORD=flectra                                              \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  -v /Contenedores/Flectra/var/lib/postgresql/data:/var/lib/postgresql/data \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  postgres:14'                                                                  | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo ''                                                                               | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo 'docker run -d --restart=always                                              \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  --name Flectra                                                            \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  -p 10050:7073                                                             \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  -e TZ=Europe/Madrid                                                       \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  -v /Contenedores/Flectra/etc/flectra:/etc/flectra                         \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  -v /Contenedores/Flectra/var/lib/flectra:/var/lib/flectra                 \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  --link FlectraDB:db                                                       \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  flectrahq/flectra:latest'                                                     | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          sudo chmod +x                                                                                       /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          sed -i 's|\\\\|\\|g'                                                                                /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh

        # Crear carpetas
          sudo mkdir -p /Contenedores/Flectra/var/lib/postgresql/data 2> /dev/null
          sudo mkdir -p /Contenedores/Flectra/etc/flectra             2> /dev/null
          sudo mkdir -p /Contenedores/Flectra/var/lib/flectra         2> /dev/null
          sudo mkdir -p /root/scripts/ParaEsteDebian                  2> /dev/null

        # Insertar el script iniciador en los comandos post arranque
          echo ""
          echo "    Insertando el script iniciador en los ComandosPostArranque..."
          echo ""
          echo "/root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh" | sudo tee -a /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

        # Iniciar el docker por primera vez
          echo ""
          echo "    Iniciando el container por primera vez..."
          echo ""
          sudo /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          sleep 10
          docker exec Flectra /opt/flectra/server/flectra-bin -d flectra -i base --stop-after-init --db_host=db --db_port=5432 --db_user=flectra --db_password=flectra
          docker restart Flectra

        # Notificar fin de ejecución del script
          echo ""
          echo "  Script de instalación del Docker de Flectra, finalizado."
          echo ""

      ;;

      2)

        echo ""
        echo -e "${cColorVerde}  Instalando Flectra en un contenedor LXC...${cFinColor}"
        echo ""

        # Crear el script iniciador
          echo ''
          echo '    Creando el script iniciador...'
          echo ''
          echo '#!/bin/bash'                                                            | sudo tee    /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo ''                                                                       | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo 'docker run -d --restart=always                                      \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  --name FlectraDB                                                  \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  -e POSTGRES_DB=flectra                                            \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  -e POSTGRES_USER=flectra                                          \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  -e POSTGRES_PASSWORD=flectra                                      \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  -v /Host/Flectra/var/lib/postgresql/data:/var/lib/postgresql/data \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  postgres:14'                                                          | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo ''                                                                       | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo 'docker run -d --restart=always                                      \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  --name Flectra                                                    \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  -p 10050:7073                                                     \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  -e TZ=Europe/Madrid                                               \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  -v /Host/Flectra/etc/flectra:/etc/flectra                         \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  -v /Host/Flectra/var/lib/flectra:/var/lib/flectra                 \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  --link FlectraDB:db                                               \\' | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          echo '  flectrahq/flectra:latest'                                             | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          sudo chmod +x                                                                               /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          sed -i 's|\\\\|\\|g'                                                                        /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh

        # Crear carpetas
          sudo mkdir -p /Host/Flectra/var/lib/postgresql/data 2> /dev/null
          sudo mkdir -p /Host/Flectra/etc/flectra             2> /dev/null
          sudo mkdir -p /Host/Flectra/var/lib/flectra         2> /dev/null
          sudo mkdir -p /root/scripts/ParaEsteDebian          2> /dev/null

        # Insertar el script iniciador en los comandos post arranque
          echo ""
          echo "    Insertando el script iniciador en los ComandosPostArranque..."
          echo ""
          echo "/root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh" | sudo tee -a /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

        # Iniciar el docker por primera vez
          echo ""
          echo "    Iniciando el container por primera vez..."
          echo ""
          sudo /root/scripts/ParaEsteDebian/DockerCE-Cont-Flectra-Iniciar.sh
          sleep 10
          docker exec Flectra /opt/flectra/server/flectra-bin -d flectra -i base --stop-after-init --db_host=db --db_port=5432 --db_user=flectra --db_password=flectra
          docker restart Flectra

        # Notificar fin de ejecución del script
          echo ""
          echo "  Script de instalación del Docker de Flectra, finalizado."
          echo ""

      ;;

    esac

  done
