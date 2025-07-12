#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar VaultWarden en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/VaultWarden-InstalarYConfigurar.sh | bash
#
# Ejecución remota sin caché:
#  curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/VaultWarden-InstalarYConfigurar.sh | bash
#
# Ejecución remota con parámetros:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/VaultWarden-InstalarYConfigurar.sh | bash -s Parámetro1 Parámetro2
# ----------

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    exit
  fi

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

if [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de VaultWarden para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de VaultWarden para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de VaultWarden para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de VaultWarden para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de VaultWarden para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de VaultWarden para Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  # Instalar Rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash
    source $HOME/.cargo/env

  # Salir de la sesion
    exit

  # Instalar dependencias
    apt update
    apt install -y build-essential
    apt install -y git
    apt install -y libssl-dev
    apt install -y pkg-config
    apt install -y libsqlite3-dev
    apt install -y nginx
    apt install -y certbot

  # Compilar vaultWarden desde el código fuente con backend SQLite
    mkdir -p /root/SoftInst/VaultWarden/
    cd /root/SoftInst/VaultWarden/
    git clone https://github.com/dani-garcia/vaultwarden.git
    mv vaultwarden Fuente
    cd Fuente
    cargo build --features sqlite --release

  # Crear carpetas para guardar los datos
    mkdir -p /var/lib/vaultwarden
    cd /var/lib/vaultwarden
    mkdir -p data
    wget https://raw.githubusercontent.com/dani-garcia/vaultwarden/main/.env.template
    mv .env.template .env

  # Instalar el entorno web
    cd /var/lib/vaultwarden
    # Determinar última versión
      vUltVers=$(curl -sL https://github.com/dani-garcia/bw_web_builds/releases/latest | sed 's->->\n-g' | grep tag | grep tree | sed 's-href=-\n-g' | grep '/' | cut -d'"' -f2 | cut -d'/' -f5)
    wget https://github.com/dani-garcia/bw_web_builds/releases/download/$vUltVers/bw_web_$vUltVers.tar.gz
    tar -xvf bw_web_$vUltVers.tar.gz
    rm bw_web_$vUltVers.tar.gz

  # Configurar VaultWarden
    echo "DATA_FOLDER=data /var/lib/vaultwarden/.env"  > /var/lib/vaultwarden/.env
    echo "DATABASE_URL=data/db.sqlite3"               >> /var/lib/vaultwarden/.env
    echo "PUSH_ENABLED=true"                          >> /var/lib/vaultwarden/.env
    echo "PUSH_INSTALLATION_ID=CHANGEME"              >> /var/lib/vaultwarden/.env      # source this id from https://bitwarden.com/host
    echo "PUSH_INSTALLATION_KEY-CHANGEME"             >> /var/lib/vaultwarden/.env     # source this key from https://bitwarden.com/host
    echo "LOG_FILE=data/vaultwarden.log"              >> /var/lib/vaultwarden/.env
    echo "LOG_LEVEL=error"                            >> /var/lib/vaultwarden/.env
    echo "DOMAIN=https://static.<your-ip-in-reverse>.clients.your-server.de" >> /var/lib/vaultwarden/.env
    echo "ROCKET_ADDRESS=127.0.0.1"                   >> /var/lib/vaultwarden/.env
    echo "ROCKET_PORT=8000"                           >> /var/lib/vaultwarden/.env
    echo "SMTP_HOST=smtp.domain.tld"                  >> /var/lib/vaultwarden/.env  # CHANGE THIS
    echo "SMTP_FROM=vaultwarden@domain.tld"           >> /var/lib/vaultwarden/.env
    echo "SMTP_PORT=587"                              >> /var/lib/vaultwarden/.env
    echo "SMTP_SECURITY=starttls"                     >> /var/lib/vaultwarden/.env
    echo "SMTP_USERNAME=username"                     >> /var/lib/vaultwarden/.env
    echo "SMTP_PASSWORD=password"                     >> /var/lib/vaultwarden/.env
    echo "SMTP_TIMEOUT=15"                            >> /var/lib/vaultwarden/.env

  # Copiar el archivo compilado
    cp /root/SoftInst/VaultWarden/Fuente/target/release/vaultwarden /usr/local/bin/vaultwarden

  # Asignar permiso de ejecución
    chmod +x /usr/local/bin/vaultwarden

  # Agregar el usuario y cambiar propiedad al nuevo usuario
    useradd -m -d /var/lib/vaultwarden vaultwarden
    chown -R vaultwarden:vaultwarden /var/lib/vaultwarden

  # Crear el servicio
    echo "[Unit]"                                                    > /etc/systemd/system/vaultwarden.service
    echo "Description=Bitwarden Server (Rust Edition)"              >> /etc/systemd/system/vaultwarden.service
    echo "Documentation=https://github.com/dani-garcia/vaultwarden" >> /etc/systemd/system/vaultwarden.service
    echo ""                                                         >> /etc/systemd/system/vaultwarden.service
    echo "After=network.target"                                     >> /etc/systemd/system/vaultwarden.service
    echo ""                                                         >> /etc/systemd/system/vaultwarden.service
    echo "[Service]"                                                >> /etc/systemd/system/vaultwarden.service
    echo "User=vaultwarden"                                         >> /etc/systemd/system/vaultwarden.service
    echo "Group=vaultwarden"                                        >> /etc/systemd/system/vaultwarden.service
    echo "ExecStart=/usr/local/bin/vaultwarden"                     >> /etc/systemd/system/vaultwarden.service
    echo "LimitNOFILE=1048576"                                      >> /etc/systemd/system/vaultwarden.service
    echo "LimitNPROC=64"                                            >> /etc/systemd/system/vaultwarden.service
    echo "PrivateTmp=true"                                          >> /etc/systemd/system/vaultwarden.service
    echo "PrivateDevices=true"                                      >> /etc/systemd/system/vaultwarden.service
    echo "ProtectHome=true"                                         >> /etc/systemd/system/vaultwarden.service
    echo "ProtectSystem=strict"                                     >> /etc/systemd/system/vaultwarden.service
    echo "WorkingDirectory=/var/lib/vaultwarden"                    >> /etc/systemd/system/vaultwarden.service
    echo "ReadWriteDirectories=/var/lib/vaultwarden"                >> /etc/systemd/system/vaultwarden.service
    echo "AmbientCapabilities=CAP_NET_BIND_SERVICE"                 >> /etc/systemd/system/vaultwarden.service
    echo ""                                                         >> /etc/systemd/system/vaultwarden.service
    echo "[Install]"                                                >> /etc/systemd/system/vaultwarden.service
    echo "WantedBy=multi-user.target"                               >> /etc/systemd/system/vaultwarden.service

  # Activar e iniciar el servicio
    systemctl daemon-reload
    systemctl enable vaultwarden
    systemctl start vaultwarden

  # Configurar nginx como proxy inverso
    echo 'upstream vaultwarden-default {'                                       > /etc/nginx/sites-available/vaultwarden.conf
    echo '  zone vaultwarden-default 64k;'                                     >> /etc/nginx/sites-available/vaultwarden.conf
    echo '  server 127.0.0.1:8000;'                                            >> /etc/nginx/sites-available/vaultwarden.conf
    echo '  keepalive 2;'                                                      >> /etc/nginx/sites-available/vaultwarden.conf
    echo '}'                                                                   >> /etc/nginx/sites-available/vaultwarden.conf
    echo ''                                                                    >> /etc/nginx/sites-available/vaultwarden.conf
    echo 'map $http_upgrade $connection_upgrade {'                             >> /etc/nginx/sites-available/vaultwarden.conf
    echo '    default upgrade;'                                                >> /etc/nginx/sites-available/vaultwarden.conf
    echo '    ''      "";'                                                     >> /etc/nginx/sites-available/vaultwarden.conf
    echo '}'                                                                   >> /etc/nginx/sites-available/vaultwarden.conf
    echo ''                                                                    >> /etc/nginx/sites-available/vaultwarden.conf
    echo 'server {'                                                            >> /etc/nginx/sites-available/vaultwarden.conf
    echo '    listen 80;'                                                      >> /etc/nginx/sites-available/vaultwarden.conf
    echo '    server_name static.<your-ip-in-reverse>.clients.your-server.de;' >> /etc/nginx/sites-available/vaultwarden.conf
    echo ''                                                                    >> /etc/nginx/sites-available/vaultwarden.conf
    echo '    client_max_body_size 525M;'                                      >> /etc/nginx/sites-available/vaultwarden.conf
    echo ''                                                                    >> /etc/nginx/sites-available/vaultwarden.conf
    echo '    location / {'                                                    >> /etc/nginx/sites-available/vaultwarden.conf
    echo '      proxy_http_version 1.1;'                                       >> /etc/nginx/sites-available/vaultwarden.conf
    echo '      proxy_set_header Upgrade $http_upgrade;'                       >> /etc/nginx/sites-available/vaultwarden.conf
    echo '      proxy_set_header Connection $connection_upgrade;'              >> /etc/nginx/sites-available/vaultwarden.conf
    echo '      proxy_set_header Host $host;'                                  >> /etc/nginx/sites-available/vaultwarden.conf
    echo '      proxy_set_header X-Real-IP $remote_addr;'                      >> /etc/nginx/sites-available/vaultwarden.conf
    echo '      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;'  >> /etc/nginx/sites-available/vaultwarden.conf
    echo '      proxy_set_header X-Forwarded-Proto $scheme;'                   >> /etc/nginx/sites-available/vaultwarden.conf
    echo ''                                                                    >> /etc/nginx/sites-available/vaultwarden.conf
    echo '      proxy_pass http://vaultwarden-default;'                        >> /etc/nginx/sites-available/vaultwarden.conf
    echo '    }'                                                               >> /etc/nginx/sites-available/vaultwarden.conf
    echo ''                                                                    >> /etc/nginx/sites-available/vaultwarden.conf
    echo '}'                                                                   >> /etc/nginx/sites-available/vaultwarden.conf
    ln -s /etc/nginx/sites-available/vaultwarden.conf /etc/nginx/sites-enabled/vaultwarden.conf
    nginx -t                       # check if the configuration is valid
    certbot --nginx                # make sure to choose redirect to https option

fi
