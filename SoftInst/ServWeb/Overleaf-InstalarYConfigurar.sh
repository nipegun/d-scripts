#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Overleaf en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ServWeb/Overleaf-InstalarYConfigurar.sh | bash
#
# Ejecución remota como root:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ServWeb/Overleaf-InstalarYConfigurar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ServWeb/Overleaf-InstalarYConfigurar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

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

# Ejecutar comandos dependiendo de la versión de Debian detectada

  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Overleaf para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Overleaf para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Crear el menú
      # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install dialog
          echo ""
        fi
      menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 80 16)
        opciones=(
          1 "Instalar con los paquetes básicos"                           on
          2 "  Agregar algunos paquetes extra"                            on
          3 "  Agregar absolutamente todos los paquetes (tarda bastante)" off
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Instalando con los paquetes básicos..."
              echo ""

              # Clonar el repositorio
                cd /opt
                sudo rm -rf /opt/overleaf
                # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
                    echo ""
                    sudo apt-get -y update
                    sudo apt-get -y install git
                    echo ""
                  fi
               sudo git clone --branch master https://github.com/overleaf/toolkit.git ./overleaf
                echo -e "overleaf|overleaf" | sudo adduser overleaf
                sudo chown -R overleaf:overleaf /opt/overleaf
      
              # Inicializar el entorno local de Overleaf con la opción --tls para habilitar TLS:
                cd /opt/overleaf
                sudo bin/init --tls
                echo ""
                echo "  Certificado autofirmado guardado como       /opt/overleaf/config/nginx/certs/overleaf_certificate.pem"
                echo "  Clave pública correspondiente guardada como /opt/overleaf/config/nginx/certs/overleaf_key.pem"

              # Configura las variables de entorno para ejecutar Overleaf Community Edition detrás del proxy TLS de Nginx
                sudo sed -i -e 's|# OVERLEAF_BEHIND_PROXY=true|OVERLEAF_BEHIND_PROXY=true|g'   /opt/overleaf/config/variables.env
                sudo sed -i -e 's|# OVERLEAF_SECURE_COOKIE=true|OVERLEAF_SECURE_COOKIE=true|g' /opt/overleaf/config/variables.env

              # NGINX
                vIPHost=$(hostname -I | sed 's- --g')
                #sudo sed -i -e 's|# OVERLEAF_IMAGE_NAME=sharelatex/sharelatex|OVERLEAF_IMAGE_NAME=overleaf/overleaf|g' /opt/overleaf/config/overleaf.rc
                sudo sed -i -e 's|NGINX_ENABLED=false|NGINX_ENABLED=true|g'                                            /opt/overleaf/config/overleaf.rc
                sudo sed -i -e "s|NGINX_HTTP_LISTEN_IP=127.0.1.1|NGINX_HTTP_LISTEN_IP=$vIPHost|g"                      /opt/overleaf/config/overleaf.rc
                sudo sed -i -e "s|NGINX_TLS_LISTEN_IP=127.0.1.1|NGINX_TLS_LISTEN_IP=$vIPHost|g"                        /opt/overleaf/config/overleaf.rc

              # Personalización
                sudo sed -i -e 's|OVERLEAF_APP_NAME="Our Overleaf Instance"|OVERLEAF_APP_NAME="Overleaf"|g'                                                  /opt/overleaf/config/variables.env
                sudo sed -i -e 's|# OVERLEAF_SITE_URL=http://overleaf.example.com|OVERLEAF_SITE_URL=http://overleaf.example.com|g'                           /opt/overleaf/config/variables.env
                sudo sed -i -e 's|# OVERLEAF_NAV_TITLE=Our Overleaf Instance|OVERLEAF_NAV_TITLE=Nuestra instancia de Overleaf|g'                             /opt/overleaf/config/variables.env
                sudo sed -i -e 's|# OVERLEAF_HEADER_IMAGE_URL=http://somewhere.com/mylogo.png|OVERLEAF_HEADER_IMAGE_URL=https://es.overleaf.com/logo.png|g'  /opt/overleaf/config/variables.env
                sudo sed -i -e 's|# OVERLEAF_ADMIN_EMAIL=support@example.com|OVERLEAF_ADMIN_EMAIL=support@example.com|g'                                     /opt/overleaf/config/variables.env

              # Levantar todos los servicios en background
                cd /opt/overleaf
                # Comprobar si el paquete docker-compose está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s docker-compose 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo -e "${cColorRojo}    El paquete docker-compose no está instalado. Iniciando su instalación...${cFinColor}"
                    echo ""
                    sudo apt-get -y update
                    sudo apt-get -y install docker-compose
                    echo ""
                  fi
                sudo bin/up -d

              # Notificar fin de ejecución del script
                sleep 5
                echo ""
                echo "  Ejecución del script, finalizada."
                echo ""
                echo "  Conéctate a la web https://$vIPHost/launchpad para crear la cuenta de administrador"
                echo ""

            ;;

            2)

              echo ""
              echo "  Agregando algunos paquetes extra..."
              echo ""
              # ragged2e
                sudo docker exec -it sharelatex bash -c "tlmgr install ragged2e && tlmgr update --self --all"

            ;;

            3)

              echo ""
              echo "  Agregando absolutamente todos los paquetes (va a tardar UN BUEN rato)..."
              echo ""

              # Instalar el esquema de paquetes completo
                sudo docker exec -it sharelatex bash -c "wget https://mirror.ctan.org/systems/texlive/tlnet/update-tlmgr-latest.sh"
                sudo docker exec -it sharelatex bash -c "sh update-tlmgr-latest.sh"
                sudo docker exec -it sharelatex bash -c "tlmgr --version"
                sudo docker exec -it sharelatex bash -c "tlmgr update --self --all"
                sudo docker exec -it sharelatex bash -c "tlmgr install scheme-full"

              # Guuardar los cambios en una nueva imagen
                sudo docker commit sharelatex overleaf:scheme-full

              # Crear el archivo override para que docker compose cargue la nueva imagen, en vez de la vieja
                echo "---"                             | sudo tee    /opt/overleaf/lib/docker-compose.override.yml
                echo "services:"                       | sudo tee -a /opt/overleaf/lib/docker-compose.override.yml
                echo "  sharelatex:"                   | sudo tee -a /opt/overleaf/lib/docker-compose.override.yml
                echo "    image: overleaf:scheme-full" | sudo tee -a /opt/overleaf/lib/docker-compose.override.yml
                sudo chown -R overleaf:overleaf /opt/overleaf

              # Finalmente, parar todas las imagenes de overlead, borrar el contenedor original y re-arrancar con la imagen nueva
                cd /opt/overleaf
                sudo bin/stop
                sudo bin/docker-compose rm -f sharelatex
                sudo bin/up -d

              # Notificar fin de ejecución del script
                sleep 5
                echo ""
                echo "  Ejecución del script, finalizada."
                echo ""
                vIPHost=$(ip -4 addr show eth0 | grep inet | cut -d' ' -f6 | cut -d/ -f1 | sed 's- --g')
                echo "  Conéctate a la web https://$vIPHost/launchpad para crear la cuenta de administrador"
                echo ""

            ;;

        esac

    done

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Overleaf para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Overleaf para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Overleaf para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Overleaf para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Overleaf para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
