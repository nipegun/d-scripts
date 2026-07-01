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
#echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
cFinColor='\033[0m'

# Determinar la versión de Debian
if [ -f /etc/os-release ]; then # Para systemd y freedesktop.org.
  . /etc/os-release
  cNomSO=$NAME
  cVerSO=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
  cNomSO=$(lsb_release -si)
  cVerSO=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then # Para algunas versiones de Debian sin el comando lsb_release.
  . /etc/lsb-release
  cNomSO=$DISTRIB_ID
  cVerSO=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then # Para versiones viejas de Debian.
  cNomSO=Debian
  cVerSO=$(cat /etc/debian_version)
else # Para el viejo uname (También funciona para BSD).
  cNomSO=$(uname -s)
  cVerSO=$(uname -r)
fi

# Ejecutar comandos dependiendo de la versión de Debian detectada
if [ "$cVerSO" == "13" ]; then

  echo ""
  echo -e "${cColorAzulClaro} Iniciando el script de instalación de BookStack para Debian 13 (x)...${cFinColor}"
  echo ""

  vLogPath="$(realpath "bookstack_install_$(date +%s).log")"
  vScriptUser="${SUDO_USER:-${USER:-root}}"
  vCurrentIp="$(ip -4 addr show scope global up | sed -n 's/.*inet \([0-9.]*\)\/.*/\1/p' | head -n 1)"
  vDbPass="$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 13)"
  vDominio="${1:-${BOOKSTACK_DOMINIO:-}}"
  cBookstackDir="/var/www/bookstack"
  cDbName="bookstack"
  cDbUser="bookstack"

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

    if [ -d "/etc/apache2/sites-enabled" ]; then
      fErrorOut "Este script está pensado para un servidor limpio. Ya existe configuración de Apache"
    fi

    if [ -d "/var/lib/mysql" ]; then
      fErrorOut "Este script está pensado para un servidor limpio. Ya existen datos de MySQL/MariaDB"
    fi
  }

  fRunPromptForDomainIfRequired() {
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
  }

  fRunPackageInstalls() {
    sudo apt-get update
    sudo apt-get -y install git
    sudo apt-get -y install unzip
    sudo apt-get -y install apache2
    sudo apt-get -y install curl
    sudo apt-get -y install mariadb-server
    sudo apt-get -y install php8.4
    sudo apt-get -y install php8.4-fpm
    sudo apt-get -y install php8.4-curl
    sudo apt-get -y install php8.4-mbstring
    sudo apt-get -y install php8.4-ldap
    sudo apt-get -y install php8.4-xml
    sudo apt-get -y install php8.4-zip
    sudo apt-get -y install php8.4-gd
    sudo apt-get -y install php8.4-mysql
  }

  fRunDatabaseSetup() {
    sudo systemctl start mariadb.service
    sleep 3
    sudo mysql -u root --execute="CREATE DATABASE ${cDbName};"
    sudo mysql -u root --execute="CREATE USER '${cDbUser}'@'localhost' IDENTIFIED BY '${vDbPass}';"
    sudo mysql -u root --execute="GRANT ALL ON ${cDbName}.* TO '${cDbUser}'@'localhost'; FLUSH PRIVILEGES;"
  }

  fRunBookstackDownload() {
    cd /var/www || fErrorOut "No se puede acceder a /var/www"

    sudo git clone https://github.com/BookStackApp/BookStack.git \
      --branch release \
      --single-branch \
      bookstack
  }

  fRunDownloadBookstackVendorFiles() {
    cd "$cBookstackDir" || fErrorOut "No se puede acceder a ${cBookstackDir}"

    sudo php bookstack-system-cli download-vendor
  }

  fRunUpdateBookstackEnv() {
    cd "$cBookstackDir" || fErrorOut "No se puede acceder a ${cBookstackDir}"

    sudo cp .env.example .env
    sudo sed -i.bak "s@APP_URL=.*\$@APP_URL=http://${vDominio}@" .env
    sudo sed -i.bak "s/DB_DATABASE=.*\$/DB_DATABASE=${cDbName}/" .env
    sudo sed -i.bak "s/DB_USERNAME=.*\$/DB_USERNAME=${cDbUser}/" .env
    sudo sed -i.bak "s/DB_PASSWORD=.*\$/DB_PASSWORD=${vDbPass}/" .env
    sudo php artisan key:generate --no-interaction --force
  }

  fRunBookstackDatabaseMigrations() {
    cd "$cBookstackDir" || fErrorOut "No se puede acceder a ${cBookstackDir}"

    sudo php artisan migrate --no-interaction --force
  }

  fRunSetApplicationFilePermissions() {
    cd "$cBookstackDir" || fErrorOut "No se puede acceder a ${cBookstackDir}"

    sudo chown -R "${vScriptUser}:www-data" ./
    sudo chmod -R 755 ./
    sudo chmod -R 775 bootstrap/cache public/uploads storage
    sudo chmod 740 .env
    sudo git config core.fileMode false
  }

  fRunConfigureApache() {
    sudo a2enmod rewrite proxy_fcgi setenvif
    sudo a2enconf php8.4-fpm

    {
      echo '<VirtualHost *:80>'
      echo " ServerName ${vDominio}"
      echo ''
      echo ' ServerAdmin webmaster@localhost'
      echo ' DocumentRoot /var/www/bookstack/public/'
      echo ''
      echo ' <Directory /var/www/bookstack/public/>'
      echo ' Options -Indexes +FollowSymLinks'
      echo ' AllowOverride None'
      echo ' Require all granted'
      echo ''
      echo ' <IfModule mod_rewrite.c>'
      echo ' <IfModule mod_negotiation.c>'
      echo ' Options -MultiViews -Indexes'
      echo ' </IfModule>'
      echo ''
      echo ' RewriteEngine On'
      echo ''
      echo ' RewriteCond %{HTTP:Authorization} .'
      echo ' RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]'
      echo ''
      echo ' RewriteCond %{REQUEST_FILENAME} !-d'
      echo ' RewriteCond %{REQUEST_URI} (.+)/$'
      echo ' RewriteRule ^ %1 [L,R=301]'
      echo ''
      echo ' RewriteCond %{REQUEST_FILENAME} !-d'
      echo ' RewriteCond %{REQUEST_FILENAME} !-f'
      echo ' RewriteRule ^ index.php [L]'
      echo ' </IfModule>'
      echo ' </Directory>'
      echo ''
      echo ' ErrorLog ${APACHE_LOG_DIR}/error.log'
      echo ' CustomLog ${APACHE_LOG_DIR}/access.log combined'
      echo '</VirtualHost>'
    } | sudo tee /etc/apache2/sites-available/bookstack.conf > /dev/null

    sudo a2dissite 000-default.conf
    sudo a2ensite bookstack.conf
    sudo systemctl restart apache2
    sudo systemctl start php8.4-fpm.service
  }

  fInfoMsg "Este script instala una instancia nueva de BookStack en Debian 13 Trixie."
  fInfoMsg "El log completo se guardará en: ${vLogPath}"
  fInfoMsg ""

  sleep 1

  fRunPreInstallChecks
  fRunPromptForDomainIfRequired

  fInfoMsg ""
  fInfoMsg "Instalando BookStack usando el dominio o IP: ${vDominio}"
  fInfoMsg ""

  sleep 1

  fRunStep "[1/8] Instalando paquetes del sistema..." fRunPackageInstalls
  fRunStep "[2/8] Preparando base de datos MariaDB..." fRunDatabaseSetup
  fRunStep "[3/8] Descargando BookStack en ${cBookstackDir}..." fRunBookstackDownload
  fRunStep "[4/8] Descargando dependencias PHP..." fRunDownloadBookstackVendorFiles
  fRunStep "[5/8] Creando y configurando archivo .env..." fRunUpdateBookstackEnv
  fRunStep "[6/8] Ejecutando migraciones iniciales..." fRunBookstackDatabaseMigrations
  fRunStep "[7/8] Configurando permisos..." fRunSetApplicationFilePermissions
  fRunStep "[8/8] Configurando Apache..." fRunConfigureApache

  fInfoMsg "----------------------------------------------------------------"
  fInfoMsg "Instalación finalizada. BookStack debería estar instalado."
  fInfoMsg "- Email por defecto: admin@admin.com"
  fInfoMsg "- Contraseña por defecto: password"
  fInfoMsg "- URL de acceso: http://${vCurrentIp}/ o http://${vDominio}/"
  fInfoMsg "- Ruta de instalación: ${cBookstackDir}"
  fInfoMsg "- Log de instalación: ${vLogPath}"
  fInfoMsg "----------------------------------------------------------------"

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
