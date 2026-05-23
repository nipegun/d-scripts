#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Overleaf en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Overleaf-InstalarYConfigurar.sh | bash
#
# Ejecución remota como root:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Overleaf-InstalarYConfigurar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Overleaf-InstalarYConfigurar.sh | nano -
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
                #vIPHost=$(hostname -I | sed 's- --g')
                vIPHost="$(ip -4 route get 1.1.1.1 | sed -n 's/.* src \([0-9.]*\).*/\1/p' | head -n 1)"
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

              # Instalar y activar docker
                sudo apt-get -y install docker.io
                sudo systemctl enable docker
                sudo systemctl start docker

              # Levantar todos los servicios en background
                # Comprobar si el paquete docker-compose está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s docker-compose 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo -e "${cColorRojo}    El paquete docker-compose no está instalado. Iniciando su instalación...${cFinColor}"
                    echo ""
                    sudo apt-get -y update
                    sudo apt-get -y install docker-compose
                    echo ""
                  fi
                # Detectar si se está dentro de un contenedor systemd-nspawn
                  if [[ "$(systemd-detect-virt 2>/dev/null)" == "systemd-nspawn" ]]; then
                    echo ""
                    echo "  Detectado contenedor systemd-nspawn. Procediendo con las modificaciones..."
                    echo ""
                    sudo mkdir -p /etc/systemd/system/docker.service.d/
                    echo '[Service]'                                         | sudo tee    /etc/systemd/system/docker.service.d/override.conf
                    echo 'Environment=DOCKER_ALLOW_IPV6_ON_IPV4_INTERFACE=1' | sudo tee -a /etc/systemd/system/docker.service.d/override.conf
                    sudo systemctl daemon-reload
                    sudo systemctl restart docker
                    sed -i "s#test: echo 'db.stats().ok' | \${MONGOSH} localhost:27017/test --quiet#test: \${MONGOSH} localhost:27017/test --quiet --eval 'db.stats().ok'#" /opt/overleaf/lib/docker-compose.mongo.yml
                    grep -q '^SIBLING_CONTAINERS_ENABLED=' /opt/overleaf/config/overleaf.rc && sed -i 's/^SIBLING_CONTAINERS_ENABLED=.*/SIBLING_CONTAINERS_ENABLED=false/' /opt/overleaf/config/overleaf.rc || echo 'SIBLING_CONTAINERS_ENABLED=false' >> /opt/overleaf/config/overleaf.rc
                    # Corregir forwarding y hacerlo persistente
                      sudo mkdir -p /root/scripts/ParaEsteDebian
                      echo '#!/bin/bash'                                                                                                                                                                                                                                                     | sudo tee    /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo ''                                                                                                                                                                                                                                                                | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo 'set -euo pipefail'                                                                                                                                                                                                                                               | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo ''                                                                                                                                                                                                                                                                | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo 'vBridge="$(docker network inspect overleaf_default --format "{{.Id}}" | cut -c1-12)"'                                                                                                                                                                            | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo 'vInterface="$(ip -o -4 route show default | sed -n "s/^default.* dev \([^ ]*\).*/\1/p" | head -n 1)"'                                                                                                                                                            | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo ''                                                                                                                                                                                                                                                                | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo 'if [[ -z "$vBridge" ]]; then'                                                                                                                                                                                                                                    | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo '  echo "No se pudo detectar la bridge de Docker para overleaf_default"'                                                                                                                                                                                           | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo '  exit 1'                                                                                                                                                                                                                                                        | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo 'fi'                                                                                                                                                                                                                                                              | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo ''                                                                                                                                                                                                                                                                | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo 'if [[ -z "$vInterface" ]]; then'                                                                                                                                                                                                                                 | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo '  echo "No se pudo detectar la interfaz de salida por defecto"'                                                                                                                                                                                                   | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo '  exit 1'                                                                                                                                                                                                                                                        | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo 'fi'                                                                                                                                                                                                                                                              | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo ''                                                                                                                                                                                                                                                                | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo 'nft list chain inet filter forward | grep -Fq "iifname \"br-${vBridge}\" oifname \"${vInterface}\" accept" || nft insert rule inet filter forward iifname "br-${vBridge}" oifname "${vInterface}" accept'                                                        | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo 'nft list chain inet filter forward | grep -Fq "iifname \"${vInterface}\" oifname \"br-${vBridge}\" ct state established,related accept" || nft insert rule inet filter forward iifname "${vInterface}" oifname "br-${vBridge}" ct state related,established accept' | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo 'nft list chain inet filter forward | grep -Fq "iifname \"br-${vBridge}\" oifname \"br-${vBridge}\" accept" || nft insert rule inet filter forward iifname "br-${vBridge}" oifname "br-${vBridge}" accept'                                                        | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      sudo chmod +x /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      sudo /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo /root/scripts/ParaEsteDebian/CorregirForwarding.sh | sudo tee -a /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
                  fi
                cd /opt/overleaf && sudo bin/up -d

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
                docker exec -i sharelatex bash -lc 'vAnioTeXLive="$(basename "$(kpsewhich -var-value=SELFAUTOPARENT)")"; tlmgr option repository "https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/${vAnioTeXLive}/tlnet-final" && tlmgr install ragged2e'

            ;;

            3)

              echo ""
              echo "  Agregando absolutamente todos los paquetes (va a tardar UN BUEN rato)..."
              echo ""

              # Instalar el esquema de paquetes completo
                sudo docker exec -i sharelatex bash -lc 'vAnioTeXLive="$(basename "$(kpsewhich -var-value=SELFAUTOPARENT)")"; tlmgr option repository "https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/${vAnioTeXLive}/tlnet-final"; tlmgr install scheme-full'

              # Guardar los cambios en una nueva imagen
                vAnioTeXLive="$(sudo docker exec -i sharelatex bash -lc 'basename "$(kpsewhich -var-value=SELFAUTOPARENT)"')"
                vImagenOverleafPersonalizada="overleaf:texlive-full-${vAnioTeXLive}"
                sudo docker commit sharelatex "$vImagenOverleafPersonalizada"

              # Crear el archivo override para que docker compose cargue la nueva imagen, en vez de la vieja
                echo "---"                                      | sudo tee    /opt/overleaf/config/docker-compose.override.yml
                echo "services:"                                | sudo tee -a /opt/overleaf/config/docker-compose.override.yml
                echo "  sharelatex:"                            | sudo tee -a /opt/overleaf/config/docker-compose.override.yml
                echo "    image: $vImagenOverleafPersonalizada" | sudo tee -a /opt/overleaf/config/docker-compose.override.yml
                sudo chown overleaf:overleaf /opt/overleaf/config/docker-compose.override.yml

              # Recrear únicamente el contenedor sharelatex con la imagen nueva
                cd /opt/overleaf
                sudo bin/docker-compose up -d --force-recreate sharelatex

              # Verificar que sharelatex está usando la imagen personalizada
                sudo docker inspect sharelatex --format 'Image={{.Config.Image}}'

              # Verificar que scheme-full sigue instalado dentro del nuevo contenedor
                sudo docker exec -i sharelatex bash -lc 'tlmgr info scheme-full | grep -E "package:|installed:"'

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
                #vIPHost=$(hostname -I | sed 's- --g')
                vIPHost="$(ip -4 route get 1.1.1.1 | sed -n 's/.* src \([0-9.]*\).*/\1/p' | head -n 1)"
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

              # Instalar y activar docker
                sudo apt-get -y install docker.io
                sudo systemctl enable docker
                sudo systemctl start docker

              # Levantar todos los servicios en background
                # Comprobar si el paquete docker-compose está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s docker-compose 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo -e "${cColorRojo}    El paquete docker-compose no está instalado. Iniciando su instalación...${cFinColor}"
                    echo ""
                    sudo apt-get -y update
                    sudo apt-get -y install docker-compose
                    echo ""
                  fi
                # Detectar si se está dentro de un contenedor systemd-nspawn
                  if [[ "$(systemd-detect-virt 2>/dev/null)" == "systemd-nspawn" ]]; then
                    echo ""
                    echo "  Detectado contenedor systemd-nspawn. Procediendo con las modificaciones..."
                    echo ""
                    sudo mkdir -p /etc/systemd/system/docker.service.d/
                    echo '[Service]'                                         | sudo tee    /etc/systemd/system/docker.service.d/override.conf
                    echo 'Environment=DOCKER_ALLOW_IPV6_ON_IPV4_INTERFACE=1' | sudo tee -a /etc/systemd/system/docker.service.d/override.conf
                    sudo systemctl daemon-reload
                    sudo systemctl restart docker
                    sed -i "s#test: echo 'db.stats().ok' | \${MONGOSH} localhost:27017/test --quiet#test: \${MONGOSH} localhost:27017/test --quiet --eval 'db.stats().ok'#" /opt/overleaf/lib/docker-compose.mongo.yml
                    grep -q '^SIBLING_CONTAINERS_ENABLED=' /opt/overleaf/config/overleaf.rc && sed -i 's/^SIBLING_CONTAINERS_ENABLED=.*/SIBLING_CONTAINERS_ENABLED=false/' /opt/overleaf/config/overleaf.rc || echo 'SIBLING_CONTAINERS_ENABLED=false' >> /opt/overleaf/config/overleaf.rc
                    # Corregir forwarding y hacerlo persistente
                      sudo mkdir -p /root/scripts/ParaEsteDebian
                      echo '#!/bin/bash'                                                                                                                                                                                                                                                     | sudo tee    /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo ''                                                                                                                                                                                                                                                                | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo 'set -euo pipefail'                                                                                                                                                                                                                                               | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo ''                                                                                                                                                                                                                                                                | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo 'vBridge="$(docker network inspect overleaf_default --format "{{.Id}}" | cut -c1-12)"'                                                                                                                                                                            | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo 'vInterface="$(ip -o -4 route show default | sed -n "s/^default.* dev \([^ ]*\).*/\1/p" | head -n 1)"'                                                                                                                                                            | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo ''                                                                                                                                                                                                                                                                | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo 'if [[ -z "$vBridge" ]]; then'                                                                                                                                                                                                                                    | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo '  echo "No se pudo detectar la bridge de Docker para overleaf_default"'                                                                                                                                                                                           | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo '  exit 1'                                                                                                                                                                                                                                                        | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo 'fi'                                                                                                                                                                                                                                                              | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo ''                                                                                                                                                                                                                                                                | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo 'if [[ -z "$vInterface" ]]; then'                                                                                                                                                                                                                                 | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo '  echo "No se pudo detectar la interfaz de salida por defecto"'                                                                                                                                                                                                   | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo '  exit 1'                                                                                                                                                                                                                                                        | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo 'fi'                                                                                                                                                                                                                                                              | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo ''                                                                                                                                                                                                                                                                | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo 'nft list chain inet filter forward | grep -Fq "iifname \"br-${vBridge}\" oifname \"${vInterface}\" accept" || nft insert rule inet filter forward iifname "br-${vBridge}" oifname "${vInterface}" accept'                                                        | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo 'nft list chain inet filter forward | grep -Fq "iifname \"${vInterface}\" oifname \"br-${vBridge}\" ct state established,related accept" || nft insert rule inet filter forward iifname "${vInterface}" oifname "br-${vBridge}" ct state related,established accept' | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo 'nft list chain inet filter forward | grep -Fq "iifname \"br-${vBridge}\" oifname \"br-${vBridge}\" accept" || nft insert rule inet filter forward iifname "br-${vBridge}" oifname "br-${vBridge}" accept'                                                        | sudo tee -a /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      sudo chmod +x /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      sudo /root/scripts/ParaEsteDebian/CorregirForwarding.sh
                      echo /root/scripts/ParaEsteDebian/CorregirForwarding.sh | sudo tee -a /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
                  fi
                cd /opt/overleaf && sudo bin/up -d

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
                docker exec -i sharelatex bash -lc 'vAnioTeXLive="$(basename "$(kpsewhich -var-value=SELFAUTOPARENT)")"; tlmgr option repository "https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/${vAnioTeXLive}/tlnet-final" && tlmgr install ragged2e'

            ;;

            3)

              echo ""
              echo "  Agregando absolutamente todos los paquetes (va a tardar UN BUEN rato)..."
              echo ""

              # Instalar el esquema de paquetes completo
                sudo docker exec -i sharelatex bash -lc 'vAnioTeXLive="$(basename "$(kpsewhich -var-value=SELFAUTOPARENT)")"; tlmgr option repository "https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/${vAnioTeXLive}/tlnet-final"; tlmgr install scheme-full'

              # Guardar los cambios en una nueva imagen
                vAnioTeXLive="$(sudo docker exec -i sharelatex bash -lc 'basename "$(kpsewhich -var-value=SELFAUTOPARENT)"')"
                vImagenOverleafPersonalizada="overleaf:texlive-full-${vAnioTeXLive}"
                sudo docker commit sharelatex "$vImagenOverleafPersonalizada"

              # Crear el archivo override para que docker compose cargue la nueva imagen, en vez de la vieja
                echo "---"                                      | sudo tee    /opt/overleaf/config/docker-compose.override.yml
                echo "services:"                                | sudo tee -a /opt/overleaf/config/docker-compose.override.yml
                echo "  sharelatex:"                            | sudo tee -a /opt/overleaf/config/docker-compose.override.yml
                echo "    image: $vImagenOverleafPersonalizada" | sudo tee -a /opt/overleaf/config/docker-compose.override.yml
                sudo chown overleaf:overleaf /opt/overleaf/config/docker-compose.override.yml

              # Recrear únicamente el contenedor sharelatex con la imagen nueva
                cd /opt/overleaf
                sudo bin/docker-compose up -d --force-recreate sharelatex

              # Verificar que sharelatex está usando la imagen personalizada
                sudo docker inspect sharelatex --format 'Image={{.Config.Image}}'

              # Verificar que scheme-full sigue instalado dentro del nuevo contenedor
                sudo docker exec -i sharelatex bash -lc 'tlmgr info scheme-full | grep -E "package:|installed:"'

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
