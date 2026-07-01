#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar BookStack en Debian
#
# Ejecución remota interactiva (puede requerir permisos sudo):
# curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/BookStack-InstalarYConfigurar.sh | bash
#
# Ejecución remota indicando dominio/IP (puede requerir permisos sudo):
# curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/BookStack-InstalarYConfigurar.sh | bash -s -- docs.midominio.com
#
# Ejecución remota como root interactiva (para sistemas sin sudo):
# curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/BookStack-InstalarYConfigurar.sh | sed 's-sudo--g' | bash
#
# Ejecución remota como root indicando dominio/IP (para sistemas sin sudo):
# curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/BookStack-InstalarYConfigurar.sh | sed 's-sudo--g' | bash -s -- docs.midominio.com
#
# Ejecución remota usando variable de entorno:
# BOOKSTACK_DOMINIO="docs.midominio.com" bash <(curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/BookStack-InstalarYConfigurar.sh)
#
# Bajar y editar directamente el archivo en nano:
# curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/BookStack-InstalarYConfigurar.sh | nano -
# ----------

# Definir constantes de color
cColorAzul='\033[0;34m'
cColorAzulClaro='\033[1;34m'
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'

# Para el color rojo también:
#echo "$(tput setaf 1)Mensaje en color rojo.
#$(tput sgr 0)"

cFinColor='\033[0m'

# Determinar la versión de Debian
if [ -f /etc/os-release ]; then
  # Para systemd y freedesktop.org.
  . /etc/os-release
  cNomSO=$NAME
  cVerSO=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
  # Para linuxbase.org.
  cNomSO=$(lsb_release -si)
  cVerSO=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
  # Para algunas versiones de Debian sin el comando lsb_release.
  . /etc/lsb-release
  cNomSO=$DISTRIB_ID
  cVerSO=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
  # Para versiones viejas de Debian.
  cNomSO=Debian
  cVerSO=$(cat /etc/debian_version)
else
  # Para el viejo uname (También funciona para BSD).
  cNomSO=$(uname -s)
  cVerSO=$(uname -r)
fi

cVerSO="${cVerSO%%.*}"

# Ejecutar comandos dependiendo de la versión de Debian detectada
if [ "$cVerSO" == "13" ]; then

  echo ""
  echo -e "${cColorAzulClaro} Iniciando el script de instalación de BookStack para Debian 13 (Trixie)...${cFinColor}"
  echo ""

  vLogPath="$(realpath "bookstack_install_$(date +%s).log")"
  vCurrentIp="$(ip -4 addr show scope global up | sed -n 's/.*inet \([0-9.]*\)\/.*/\1/p' | head -n 1)"
  vDbPass="$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 13)"
  vDominio="${1:-${BOOKSTACK_DOMINIO:-}}"
  vAppHost=""
  vApacheServerName=""
  vAppUrl=""

  cBookstackDir="/opt/bookstack"
  cBookstackUser="bookstack"
  cBookstackGroup="www-data"
  cDbName="bookstack"
  cDbUser="bookstack"
  cHttpPort="11080"
  cHttpsPort="11443"
  cPhpVersion="8.4"

  export DEBIAN_FRONTEND=noninteractive

  fErrorOut() {
    local pMensaje="$1"

    echo "ERROR: ${pMensaje}" | tee -a "$vLogPath" 1>&2
    exit 1
  }

  fInfoMsg() {
    local pMensaje="$1"

    echo "$pMensaje" | tee -a "$vLogPath"
  }

  fRunStep() {
    local pMensaje="$1"
    local pFuncion="$2"

    fInfoMsg "$pMensaje"

    if ! "$pFuncion" >> "$vLogPath" 2>&1; then
      fErrorOut "Ha fallado el paso: ${pMensaje}. Revisa el log: ${vLogPath}"
    fi
  }

  fRunPreInstallChecks() {
    if [ "$(id -u)" -ne 0 ]; then
      if ! command -v sudo >/dev/null 2>&1; then
        fErrorOut "sudo no está instalado. Ejecuta el script como root usando la forma con sed indicada al principio del script."
      fi

      if ! sudo -v; then
        fErrorOut "El usuario actual no tiene permisos sudo válidos"
      fi
    fi

    if [ -d "$cBookstackDir" ]; then
      if [ ! -d "$cBookstackDir/.git" ]; then
        if [ "$(find "$cBookstackDir" -mindepth 1 -maxdepth 1 | head -n 1)" ]; then
          fErrorOut "Ya existe ${cBookstackDir} y no parece una instalación Git de BookStack"
        fi
      fi
    fi

    if id "$cBookstackUser" >/dev/null 2>&1; then
      vUserHome="$(getent passwd "$cBookstackUser" | cut -d ':' -f 6)"

      if [ "$vUserHome" != "$cBookstackDir" ]; then
        fErrorOut "El usuario ${cBookstackUser} ya existe, pero su home es ${vUserHome}, no ${cBookstackDir}"
      fi
    fi

    if command -v ss >/dev/null 2>&1; then
      if ss -ltn | sed -n "s/.*:${cHttpPort} .*/1/p" | grep -q "1"; then
        fInfoMsg "Aviso: el puerto HTTP ${cHttpPort} ya aparece en uso. Si es Apache, se reiniciará al final."
      fi

      if ss -ltn | sed -n "s/.*:${cHttpsPort} .*/1/p" | grep -q "1"; then
        fInfoMsg "Aviso: el puerto HTTPS ${cHttpsPort} ya aparece en uso. Si es Apache, se reiniciará al final."
      fi
    fi
  }

  fRunPromptForDomainIfRequired() {
    if [ -z "$vCurrentIp" ]; then
      vCurrentIp="127.0.0.1"
    fi

    if [ -z "$vDominio" ]; then
      fInfoMsg ""
      fInfoMsg "Introduce el dominio o IP donde se alojará BookStack y pulsa [ENTER]."
      fInfoMsg "Ejemplos: mi-sitio.com, docs.mi-sitio.com o ${vCurrentIp}"

      if [ -e /dev/tty ]; then
        if ! read -r vDominio < /dev/tty; then
          fErrorOut "No se ha podido leer el dominio/IP desde la TTY. Ejecuta el script pasando el dominio/IP con: bash -s -- docs.midominio.com"
        fi
      else
        fErrorOut "No hay TTY disponible. Ejecuta el script pasando el dominio/IP con: bash -s -- docs.midominio.com"
      fi
    fi

    if [ -z "$vDominio" ]; then
      fErrorOut "Debes indicar un dominio o IP para ejecutar este script"
    fi

    vDominio="$(echo "$vDominio" | tr -d '[:space:]')"
    vDominio="$(echo "$vDominio" | sed 's@^https\?://@@')"
    vDominio="$(echo "$vDominio" | sed 's@[/?#].*$@@')"
    vDominio="$(echo "$vDominio" | sed 's@/$@@')"

    if [ -z "$vDominio" ]; then
      fErrorOut "El dominio/IP indicado no es válido"
    fi

    if echo "$vDominio" | grep -q '^\[.*\]'; then
      vAppHost="$(echo "$vDominio" | sed 's@^\(\[[^]]*\]\).*$@\1@')"
      vApacheServerName="$(echo "$vAppHost" | sed 's@^\[\(.*\)\]$@\1@')"
    else
      vNumDosPuntos="$(echo "$vDominio" | tr -cd ':' | wc -c | sed 's@ @@g')"

      if [ "$vNumDosPuntos" -eq 0 ]; then
        vAppHost="$(echo "$vDominio" | sed 's@:[0-9]\+$@@')"
        vApacheServerName="$vAppHost"
      elif [ "$vNumDosPuntos" -eq 1 ]; then
        vAppHost="$(echo "$vDominio" | sed 's@:[0-9]\+$@@')"
        vApacheServerName="$vAppHost"
      else
        vAppHost="[${vDominio}]"
        vApacheServerName="$vDominio"
      fi
    fi

    if [ -z "$vAppHost" ]; then
      fErrorOut "No se ha podido construir un host válido para APP_URL"
    fi

    if echo "$vAppHost" | grep -q '/'; then
      fErrorOut "El dominio/IP no debe contener rutas: ${vAppHost}"
    fi

    vAppUrl="https://${vAppHost}:${cHttpsPort}"
  }

  fRunPackageInstalls() {
    sudo apt-get update
    sudo apt-get -y install git
    sudo apt-get -y install unzip
    sudo apt-get -y install apache2
    sudo apt-get -y install curl
    sudo apt-get -y install ca-certificates
    sudo apt-get -y install ssl-cert
    sudo apt-get -y install mariadb-server
    sudo apt-get -y install php${cPhpVersion}
    sudo apt-get -y install php${cPhpVersion}-cli
    sudo apt-get -y install php${cPhpVersion}-fpm
    sudo apt-get -y install php${cPhpVersion}-curl
    sudo apt-get -y install php${cPhpVersion}-mbstring
    sudo apt-get -y install php${cPhpVersion}-ldap
    sudo apt-get -y install php${cPhpVersion}-xml
    sudo apt-get -y install php${cPhpVersion}-zip
    sudo apt-get -y install php${cPhpVersion}-gd
    sudo apt-get -y install php${cPhpVersion}-mysql
  }

  fRunCreateBookstackSystemUser() {
    if id "$cBookstackUser" >/dev/null 2>&1; then
      return 0
    fi

    sudo useradd \
      --system \
      --home-dir "$cBookstackDir" \
      --no-create-home \
      --shell /usr/sbin/nologin \
      "$cBookstackUser"
  }

  fRunDatabaseSetup() {
    sudo systemctl start mariadb.service

    sleep 3

    sudo mysql -u root --execute="CREATE DATABASE IF NOT EXISTS \`${cDbName}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    sudo mysql -u root --execute="CREATE USER IF NOT EXISTS '${cDbUser}'@'localhost' IDENTIFIED BY '${vDbPass}';"
    sudo mysql -u root --execute="ALTER USER '${cDbUser}'@'localhost' IDENTIFIED BY '${vDbPass}';"
    sudo mysql -u root --execute="GRANT ALL ON \`${cDbName}\`.* TO '${cDbUser}'@'localhost'; FLUSH PRIVILEGES;"
  }

  fRunBookstackDownload() {
    if [ -d "$cBookstackDir/.git" ]; then
      return 0
    fi

    cd /opt || fErrorOut "No se puede acceder a /opt"

    sudo git clone https://github.com/BookStackApp/BookStack.git \
      --branch release \
      --single-branch \
      bookstack
  }

  fRunDownloadBookstackVendorFiles() {
    cd "$cBookstackDir" || fErrorOut "No se puede acceder a ${cBookstackDir}"

    sudo php bookstack-system-cli download-vendor
  }

  fRunSetEnvValue() {
    local pClave="$1"
    local pValor="$2"

    cd "$cBookstackDir" || fErrorOut "No se puede acceder a ${cBookstackDir}"

    if sudo grep -q "^${pClave}=" .env; then
      sudo sed -i.bak "s@^${pClave}=.*\$@${pClave}=${pValor}@" .env
    else
      echo "${pClave}=${pValor}" | sudo tee -a .env > /dev/null
    fi
  }

  fRunUpdateBookstackEnv() {
    cd "$cBookstackDir" || fErrorOut "No se puede acceder a ${cBookstackDir}"

    if [ ! -f .env ]; then
      sudo cp .env.example .env
    fi

    fRunSetEnvValue "APP_URL" "${vAppUrl}"
    fRunSetEnvValue "APP_LANG" "es"
    fRunSetEnvValue "APP_AUTO_LANG_PUBLIC" "false"
    fRunSetEnvValue "DB_DATABASE" "${cDbName}"
    fRunSetEnvValue "DB_USERNAME" "${cDbUser}"
    fRunSetEnvValue "DB_PASSWORD" "${vDbPass}"

    sudo php artisan key:generate --no-interaction --force
  }

  fRunBookstackDatabaseMigrations() {
    cd "$cBookstackDir" || fErrorOut "No se puede acceder a ${cBookstackDir}"

    sudo php artisan migrate --no-interaction --force
  }

  fRunSetApplicationFilePermissions() {
    cd "$cBookstackDir" || fErrorOut "No se puede acceder a ${cBookstackDir}"

    sudo git config --global --add safe.directory "$cBookstackDir"
    sudo git -C "$cBookstackDir" config core.fileMode false

    sudo chown -R "${cBookstackUser}:${cBookstackGroup}" "$cBookstackDir"
    sudo chmod -R 755 "$cBookstackDir"
    sudo chmod -R 775 "$cBookstackDir/bootstrap/cache"
    sudo chmod -R 775 "$cBookstackDir/public/uploads"
    sudo chmod -R 775 "$cBookstackDir/storage"
    sudo chmod 740 "$cBookstackDir/.env"
  }

  fRunConfigureApachePorts() {
    {
      echo "Listen ${cHttpPort}"
      echo ""
      echo "<IfModule ssl_module>"
      echo "  Listen ${cHttpsPort}"
      echo "</IfModule>"
      echo ""
      echo "<IfModule mod_gnutls.c>"
      echo "  Listen ${cHttpsPort}"
      echo "</IfModule>"
    } | sudo tee /etc/apache2/ports.conf > /dev/null
  }

  fRunConfigureApacheServerName() {
    echo "ServerName ${vApacheServerName}" | sudo tee /etc/apache2/conf-available/bookstack-servername.conf > /dev/null

    sudo a2enconf bookstack-servername.conf
  }

  fRunConfigureApacheVirtualHost() {
    {
      echo "<VirtualHost *:${cHttpPort}>"
      echo "  ServerName ${vApacheServerName}"
      echo "  ServerAdmin webmaster@localhost"
      echo "  DocumentRoot ${cBookstackDir}/public/"
      echo ""
      echo "  <Directory ${cBookstackDir}/public/>"
      echo "    Options -Indexes +FollowSymLinks"
      echo "    AllowOverride None"
      echo "    Require all granted"
      echo ""
      echo "    <IfModule mod_rewrite.c>"
      echo "      <IfModule mod_negotiation.c>"
      echo "        Options -MultiViews -Indexes"
      echo "      </IfModule>"
      echo ""
      echo "      RewriteEngine On"
      echo ""
      echo "      RewriteCond %{HTTP:Authorization} ."
      echo "      RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]"
      echo ""
      echo "      RewriteCond %{REQUEST_FILENAME} !-d"
      echo "      RewriteCond %{REQUEST_URI} (.+)/$"
      echo "      RewriteRule ^ %1 [L,R=301]"
      echo ""
      echo "      RewriteCond %{REQUEST_FILENAME} !-d"
      echo "      RewriteCond %{REQUEST_FILENAME} !-f"
      echo "      RewriteRule ^ index.php [L]"
      echo "    </IfModule>"
      echo "  </Directory>"
      echo ""
      echo "  ErrorLog \${APACHE_LOG_DIR}/bookstack-http-error.log"
      echo "  CustomLog \${APACHE_LOG_DIR}/bookstack-http-access.log combined"
      echo "</VirtualHost>"
      echo ""
      echo "<VirtualHost *:${cHttpsPort}>"
      echo "  ServerName ${vApacheServerName}"
      echo "  ServerAdmin webmaster@localhost"
      echo "  DocumentRoot ${cBookstackDir}/public/"
      echo ""
      echo "  SSLEngine on"
      echo "  SSLCertificateFile /etc/ssl/certs/ssl-cert-snakeoil.pem"
      echo "  SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key"
      echo ""
      echo "  <Directory ${cBookstackDir}/public/>"
      echo "    Options -Indexes +FollowSymLinks"
      echo "    AllowOverride None"
      echo "    Require all granted"
      echo ""
      echo "    <IfModule mod_rewrite.c>"
      echo "      <IfModule mod_negotiation.c>"
      echo "        Options -MultiViews -Indexes"
      echo "      </IfModule>"
      echo ""
      echo "      RewriteEngine On"
      echo ""
      echo "      RewriteCond %{HTTP:Authorization} ."
      echo "      RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]"
      echo ""
      echo "      RewriteCond %{REQUEST_FILENAME} !-d"
      echo "      RewriteCond %{REQUEST_URI} (.+)/$"
      echo "      RewriteRule ^ %1 [L,R=301]"
      echo ""
      echo "      RewriteCond %{REQUEST_FILENAME} !-d"
      echo "      RewriteCond %{REQUEST_FILENAME} !-f"
      echo "      RewriteRule ^ index.php [L]"
      echo "    </IfModule>"
      echo "  </Directory>"
      echo ""
      echo "  ErrorLog \${APACHE_LOG_DIR}/bookstack-https-error.log"
      echo "  CustomLog \${APACHE_LOG_DIR}/bookstack-https-access.log combined"
      echo "</VirtualHost>"
    } | sudo tee /etc/apache2/sites-available/bookstack.conf > /dev/null
  }

  fRunConfigureApache() {
    sudo a2enmod rewrite proxy_fcgi setenvif ssl headers
    sudo a2enconf php${cPhpVersion}-fpm

    fRunConfigureApachePorts
    fRunConfigureApacheServerName
    fRunConfigureApacheVirtualHost

    sudo a2dissite 000-default.conf || true
    sudo a2dissite default-ssl.conf || true
    sudo a2ensite bookstack.conf

    sudo apache2ctl configtest

    sudo systemctl restart php${cPhpVersion}-fpm.service
    sudo systemctl restart apache2
    sudo systemctl enable apache2.service
    sudo systemctl enable php${cPhpVersion}-fpm.service
    sudo systemctl enable mariadb.service
  }

  fInfoMsg "Este script instala una instancia nueva de BookStack en Debian 13 Trixie."
  fInfoMsg "El log completo se guardará en: ${vLogPath}"
  fInfoMsg ""

  sleep 1

  fRunPreInstallChecks
  fRunPromptForDomainIfRequired

  fInfoMsg ""
  fInfoMsg "Instalando BookStack usando el dominio o IP: ${vApacheServerName}"
  fInfoMsg "APP_URL que se escribirá en .env: ${vAppUrl}"
  fInfoMsg ""

  sleep 1

  fRunStep "[1/10] Instalando paquetes del sistema..." fRunPackageInstalls
  fRunStep "[2/10] Creando usuario de sistema ${cBookstackUser}..." fRunCreateBookstackSystemUser
  fRunStep "[3/10] Preparando base de datos MariaDB..." fRunDatabaseSetup
  fRunStep "[4/10] Descargando BookStack en ${cBookstackDir}..." fRunBookstackDownload
  fRunStep "[5/10] Descargando dependencias PHP..." fRunDownloadBookstackVendorFiles
  fRunStep "[6/10] Creando y configurando archivo .env..." fRunUpdateBookstackEnv
  fRunStep "[7/10] Ejecutando migraciones iniciales..." fRunBookstackDatabaseMigrations
  fRunStep "[8/10] Configurando permisos..." fRunSetApplicationFilePermissions
  fRunStep "[9/10] Configurando Apache..." fRunConfigureApache

  fInfoMsg "----------------------------------------------------------------"
  fInfoMsg "Instalación finalizada. BookStack debería estar instalado."
  fInfoMsg "- Email por defecto: admin@admin.com"
  fInfoMsg "- Contraseña por defecto: password"
  fInfoMsg "- URL HTTP: http://${vAppHost}:${cHttpPort}/"
  fInfoMsg "- URL HTTPS: ${vAppUrl}/"
  fInfoMsg "- APP_URL configurado: ${vAppUrl}"
  fInfoMsg "- Ruta de instalación: ${cBookstackDir}"
  fInfoMsg "- Usuario de sistema: ${cBookstackUser}"
  fInfoMsg "- Home del usuario ${cBookstackUser}: ${cBookstackDir}"
  fInfoMsg "- Idioma configurado: español"
  fInfoMsg "- Log de instalación: ${vLogPath}"
  fInfoMsg "- Contraseña MariaDB de ${cDbUser}: guardada en ${cBookstackDir}/.env"
  fInfoMsg "----------------------------------------------------------------"
  fInfoMsg "Nota: HTTPS queda configurado con el certificado snakeoil/autofirmado de Debian."
  fInfoMsg "Para producción, cambia SSLCertificateFile y SSLCertificateKeyFile por certificados reales."

elif [ "$cVerSO" == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro} Iniciando el script de instalación de BookStack para Debian 12 (Bookworm)...${cFinColor}"
  echo ""
  echo ""
  echo -e "${cColorRojo} Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ "$cVerSO" == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro} Iniciando el script de instalación de BookStack para Debian 11 (Bullseye)...${cFinColor}"
  echo ""
  echo ""
  echo -e "${cColorRojo} Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ "$cVerSO" == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro} Iniciando el script de instalación de BookStack para Debian 10 (Buster)...${cFinColor}"
  echo ""
  echo ""
  echo -e "${cColorRojo} Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ "$cVerSO" == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro} Iniciando el script de instalación de BookStack para Debian 9 (Stretch)...${cFinColor}"
  echo ""
  echo ""
  echo -e "${cColorRojo} Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ "$cVerSO" == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro} Iniciando el script de instalación de BookStack para Debian 8 (Jessie)...${cFinColor}"
  echo ""
  echo ""
  echo -e "${cColorRojo} Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ "$cVerSO" == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro} Iniciando el script de instalación de BookStack para Debian 7 (Wheezy)...${cFinColor}"
  echo ""
  echo ""
  echo -e "${cColorRojo} Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

fi
