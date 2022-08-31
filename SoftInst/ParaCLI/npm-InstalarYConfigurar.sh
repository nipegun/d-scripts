#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar Nginx Proxy Manager en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/npm-InstalarYConfigurar.sh | bash
#
#  Ejecución remota sin caché:
#  curl -s -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/npm-InstalarYConfigurar.sh | bash
# ----------

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}curl no está instalado. Iniciando su instalación...${vFinColor}"
    echo ""
    apt-get -y update && apt-get -y install curl
    echo ""
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    OS_NAME=$NAME
    OS_VERS=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    OS_NAME=$(lsb_release -si)
    OS_VERS=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    OS_NAME=$DISTRIB_ID
    OS_VERS=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    OS_NAME=Debian
    OS_VERS=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    OS_NAME=$(uname -s)
    OS_VERS=$(uname -r)
  fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de Nginx Proxy Manager para Debian 7 (Wheezy)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de Nginx Proxy Manager para Debian 8 (Jessie)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de Nginx Proxy Manager para Debian 9 (Stretch)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de Nginx Proxy Manager para Debian 10 (Buster)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de Nginx Proxy Manager para Debian 11 (Bullseye)...${vFinColor}"
  echo ""

  vCarpetaTemporal=$(mktemp -d)

  # Limpiar
    echo ""
    echo "  Limpiando el sistema..."
    echo ""
    apt-get -y remove --purge git
    apt-get -y remove --purge build-essential
    apt-get -y remove --purge libffi-dev
    apt-get -y remove --purge libssl-dev
    apt-get -y remove --purge python3-dev
    apt-get -y autoremove
    apt-get clean
    rm -rf vCarpetaTemporal
    rm -rf /root/.cache

  # Comprobar si hay una instalación previa y detener todos los servicios
    if [ -f /lib/systemd/system/npm.service ]; then
      echo ""
      echo "  Se ha encontrado una instalación previa. Deteniendo servicios..."
      echo ""
      systemctl stop openresty
      systemctl stop npm
    fi

  # Limpiar todo para la nueva instalación
    echo ""
    echo "  Se ha encontrado una instalación previa. Limpiando archivos..."
    echo ""
    rm -rf /app
    rm -rf /var/www/html
    rm -rf /etc/nginx
    rm -rf /var/log/nginx
    rm -rf /var/lib/nginx
    rm -rf /var/cache/nginx

  # Instalar dependencias
    echo ""
    echo "  Instalando dependencias..."
    echo ""
    apt-get -y install --no-install-recommends git
    apt-get -y install --no-install-recommends build-essential
    apt-get -y install --no-install-recommends libffi-dev
    apt-get -y install --no-install-recommends libssl-dev
    apt-get -y install --no-install-recommends python3-dev
    apt-get -y install --no-install-recommends gnupg
    apt-get -y install --no-install-recommends openssl
    apt-get -y install --no-install-recommends ca-certificates
    apt-get -y install --no-install-recommends apache2-utils
    apt-get -y install --no-install-recommends logrotate

  # Instalar Python
    echo ""
    echo "  Instalando y configurando Python..."
    echo ""
    apt-get -y -q install --no-install-recommends python3
    apt-get -y -q install --no-install-recommends python3-distutils
    apt-get -y -q install --no-install-recommends python3-venv
    python3 -m venv /opt/certbot/
    export PATH=/opt/certbot/bin:$PATH
    grep -qo "/opt/certbot" /etc/environment || echo "$PATH" > /etc/environment

  # Instalar certbot y sus dependencias de Python
    wget -qO - https://bootstrap.pypa.io/get-pip.py | python -
    # Determinar si se está instalando en 32 bits
      if [ "$(getconf LONG_BIT)" = "32" ]; then
        pip install --no-cache-dir -U cryptography==3.3.2
      fi
    pip install --no-cache-dir cffi certbot

  # Instalar openresty
    wget -qO - https://openresty.org/package/pubkey.gpg | apt-key add -
    vDistro=$(wget -t 1 -T 15 -q "http://openresty.org/package/$(cat /etc/*-release | grep -w ID | cut -d= -f2 | tr -d '"')/dists/" -O - | grep -o "$(cat /etc/*-release | grep -w VERSION_CODENAME | cut -d= -f2 | tr -d '"')" | head -n1 || true)
    echo "deb [trusted=yes] http://openresty.org/package/$(cat /etc/*-release | grep -w ID | cut -d= -f2 | tr -d '"') ${vDistro:-bullseye} openresty" | tee /etc/apt/sources.list.d/openresty.list
    apt-get -y update && apt-get install -y -q --no-install-recommends openresty

  # Instalar nodejs
    wget -qO - https://deb.nodesource.com/setup_16.x | bash -
    apt-get install -y -q --no-install-recommends nodejs
    npm install --global yarn

  # Obtener la última versión de Nginx Proxy Manager
    wget -t 1 -T 15 -q -O ./_latest_release https://github.com/NginxProxyManager/nginx-proxy-manager/releases/latest
    vUltVersNPM=$(basename $(cat ./_latest_release | grep -wo "NginxProxyManager/.*.tar.gz") .tar.gz | cut -d'v' -f2)

  # Descargar el código de nginx-proxy-manager
    wget -t 1 -T 15 -q -c https://github.com/NginxProxyManager/nginx-proxy-manager/archive/v"$vUltVersNPM".tar.gz -O - | tar -xz
    cd ./nginx-proxy-manager-$vUltVersNPM

  # Crear los enlaces simbólicos
    echo ""
    echo "  Creando los enlaces simbólicos..."
    echo ""
    ln -sf /usr/bin/python3                      /usr/bin/python
    ln -sf /opt/certbot/bin/pip                  /usr/bin/pip
    ln -sf /opt/certbot/bin/certbot              /usr/bin/certbot
    ln -sf /usr/local/openresty/nginx/sbin/nginx /usr/sbin/nginx
    ln -sf /usr/local/openresty/nginx/           /etc/nginx

  # Actualizar la versión de NPM en los archivos package.json
    echo ""
    echo "Actualizando la versión de NPM en los archivos package.json..."
    echo ""
    sed -i "s+0.0.0+$vUltVersNPM+g" backend/package.json
    sed -i "s+0.0.0+$vUltVersNPM+g" frontend/package.json

  # Adaptar los archivos de configuración de nginx a la configuración por defecto de openresty
    echo ""
    echo "  Adaptando los archivos de configuración de nginx a la configuración por defecto de openresty..."
    echo ""
    sed -i 's+^daemon+#daemon+g' docker/rootfs/etc/nginx/nginx.conf
    vConfNginx=$(find "$(pwd)" -type f -name "*.conf")
    for NGINX_CONF in $vConfNginx; do
      sed -i 's+include conf.d+include /etc/nginx/conf.d+g' "$NGINX_CONF"
    done

  # Copiar archivos runtime
    echo ""
    echo "  Copiando archivos runtime..."
    echo ""
    mkdir -p /var/www/html
    mkdir -p /etc/nginx/logs
    cp -r docker/rootfs/var/www/html/*                   /var/www/html/
    cp -r docker/rootfs/etc/nginx/*                      /etc/nginx/
    cp docker/rootfs/etc/letsencrypt.ini                 /etc/letsencrypt.ini
    cp docker/rootfs/etc/logrotate.d/nginx-proxy-manager /etc/logrotate.d/nginx-proxy-manager
    ln -sf /etc/nginx/nginx.conf /etc/nginx/conf/nginx.conf
    rm -f /etc/nginx/conf.d/dev.conf

  # Crear las carpetas requeridas
    echo ""
    echo "  Creando las carpetas requeridas..."
    echo ""
    mkdir -p /tmp/nginx/body
    mkdir -p /run/nginx
    mkdir -p /data/nginx
    mkdir -p /data/custom_ssl
    mkdir -p /data/logs
    mkdir -p /data/access
    mkdir -p /data/nginx/default_host
    mkdir -p /data/nginx/default_www
    mkdir -p /data/nginx/proxy_host
    mkdir -p /data/nginx/redirection_host
    mkdir -p /data/nginx/stream
    mkdir -p /data/nginx/dead_host
    mkdir -p /data/nginx/temp
    mkdir -p /var/lib/nginx/cache/public
    mkdir -p /var/lib/nginx/cache/private
    mkdir -p /var/cache/nginx/proxy_temp

  chmod -R 777 /var/cache/nginx
  chown root /tmp/nginx

  # Dynamically generate resolvers file, if resolver is IPv6, enclose in `[]`
    echo resolver "$(awk 'BEGIN{ORS=" "} $1=="nameserver" {print ($2 ~ ":")? "["$2"]": $2}' /etc/resolv.conf);" > /etc/nginx/conf.d/include/resolvers.conf

  # Generate dummy self-signed certificate.
    if [ ! -f /data/nginx/dummycert.pem ] || [ ! -f /data/nginx/dummykey.pem ]; then
      echo ""
      echo "  Generando el certificado SSL dummy..."
      echo ""
      openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -subj "/O=Nginx Proxy Manager/OU=Dummy Certificate/CN=localhost" -keyout /data/nginx/dummykey.pem -out /data/nginx/dummycert.pem
    fi

  # Copy app files
    echo ""
    echo "  Copiando los archivos de aplicación..."
    echo ""
    mkdir -p /app/global
    mkdir -p /app/frontend/images
    cp -r backend/* /app
    cp -r global/* /app/global

  # Build the frontend
    echo ""
    echo "  Construyendo el frontend.."
    echo ""
    cd ./frontend
    export NODE_ENV=development
    yarn install --network-timeout=30000
    yarn build
    cp -r dist/* /app/frontend
    cp -r app-images/* /app/frontend/images

  # Inicializar backend
    echo ""
    echo "  Inicializando backend..."
    echo ""
    rm -rf /app/config/default.json
    if [ ! -f /app/config/production.json ]; then
      echo '{'                                           > /app/config/production.json
      echo '  "database": {'                            >> /app/config/production.json
      echo '    "engine": "knex-native",'                >> /app/config/production.json
      echo '    "knex": {'                               >> /app/config/production.json
      echo '      "client": "sqlite3",'                  >> /app/config/production.json
      echo '      "connection": {'                       >> /app/config/production.json
      echo '        "filename": "/data/database.sqlite"' >> /app/config/production.json
      echo '      }'                                     >> /app/config/production.json
      echo '    }'                                       >> /app/config/production.json
      echo '  }'                                         >> /app/config/production.json
      echo '}'                                           >> /app/config/production.json
    fi
    cd /app
    export NODE_ENV=development
    yarn install --network-timeout=30000

  # Crear el servicio NPM
    echo ""
    echo "  Creando el servicio npm..."
    echo ""
    echo "[Unit]"                                                                                   > /lib/systemd/system/npm.service
    echo "Description=Nginx Proxy Manager"                                                         >> /lib/systemd/system/npm.service
    echo "After=network.target"                                                                    >> /lib/systemd/system/npm.service
    echo "Wants=openresty.service"                                                                 >> /lib/systemd/system/npm.service
    echo ""                                                                                        >> /lib/systemd/system/npm.service
    echo "[Service]"                                                                               >> /lib/systemd/system/npm.service
    echo "Type=simple"                                                                             >> /lib/systemd/system/npm.service
    echo "Environment=NODE_ENV=production"                                                         >> /lib/systemd/system/npm.service
    echo "ExecStartPre=-/bin/mkdir -p /tmp/nginx/body /data/letsencrypt-acme-challenge"            >> /lib/systemd/system/npm.service
    echo "ExecStart=/usr/bin/node index.js --abort_on_uncaught_exception --max_old_space_size=250" >> /lib/systemd/system/npm.service
    echo "WorkingDirectory=/app"                                                                   >> /lib/systemd/system/npm.service
    echo "Restart=on-failure"                                                                      >> /lib/systemd/system/npm.service
    echo ""                                                                                        >> /lib/systemd/system/npm.service
    echo "[Install]"                                                                               >> /lib/systemd/system/npm.service
    echo "WantedBy=multi-user.target"                                                              >> /lib/systemd/system/npm.service
    systemctl daemon-reload
    systemctl enable npm

  # Arrancar servicios
    echo ""
    echo "  Arrancando servicios..."
    echo ""
    systemctl start openresty
    systemctl start npm

  # Mostrar mensaje final
    vIPLocal=$(hostname -I | cut -f1 -d ' ')
    echo ""
    echo "  Instalación completa."
    echo ""
    echo "  Para conectarte a NPM accede a: http://${vIPLocal}:81"
    echo ""
    echo "  El mail por defecto es: admin@example.com"
    echo "  La contraseña por defecto es: changeme"
    echo ""
    echo "  La primera vez que te conectes te pedirá que los cambies."
    echo ""

fi

