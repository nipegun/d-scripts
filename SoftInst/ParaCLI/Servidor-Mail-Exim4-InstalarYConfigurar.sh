#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

------
# Script de NiPeGun para instalar y configurar exim4 en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-Mail-Exim4-InstalarYConfigurar.sh | bash
------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

# Determinar la versión de Debian

   if [ -f /etc/os-release ]; then
       # Para systemd y freedesktop.org
       . /etc/os-release
       cNomSO=$NAME
       cVerSO=$VERSION_ID
   elif type lsb_release >/dev/null 2>&1; then
       # linuxbase.org
       cNomSO=$(lsb_release -si)
       cVerSO=$(lsb_release -sr)
   elif [ -f /etc/lsb-release ]; then
       # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       cNomSO=$DISTRIB_ID
       cVerSO=$DISTRIB_RELEASE
   elif [ -f /etc/debian_version ]; then
       # Para versiones viejas de Debian.
       cNomSO=Debian
       cVerSO=$(cat /etc/debian_version)
   else
       # Para el viejo uname (También funciona para BSD)
       cNomSO=$(uname -s)
       cVerSO=$(uname -r)
   fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de exim4 para Debian 7 (Wheezy)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "-----------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación de exim4 para Debian 8 (Jessie)..."
  echo "-----------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de exim4 para Debian 9 (Stretch)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de exim4 para Debian 10 (Buster)..."
  
  echo ""

  apt-get -y install exim4
  apt-get -y install courier-imap

  # Crear la carpeta mail en cada carpeta de usuario
  maildirmake /etc/skel/Maildir
  maildirmake ~root/Maildir
  chown root:root ~root/Maildir -R

  # Reconfigurar Exim4
  dpkg-reconfigure exim4-config

  # Generar el certificado SSL
  /usr/share/doc/exim4-base/examples/exim-gencert
          
  # Activar TLS
  echo "MAIN_TLS_ENABLE = true" > /etc/exim4/exim4.conf.localmacros
  echo "tls_on_connect_ports = 465" >> /etc/exim4/exim4.conf.localmacros
  sed -i -e "s|SMTPLISTENEROPTIONS=''|SMTPLISTENEROPTIONS='-oX 465:25:587 -oP /var/run/exim4/exim.pid'|g" /etc/default/exim4
  echo "MAIN_TLS_ENABLE = yes" >> /etc/exim4/exim4.conf.template
  echo "tls_on_connect_ports=465" >> /etc/exim4/exim4.conf.template
  echo "rfc1413_query_timeout = 0s" >> /etc/exim4/exim4.conf.template
          
  # Instalar el daemon SaslAuth
  apt-get -y install sasl2-bin
  sed -i -e 's|START=no|START=yes|g' /etc/default/saslauthd
  adduser Debian-exim sasl
          
  # Borrar 7 líneas después de "# plain_saslauthd_server:"
  sed -i -e '/# plain_saslauthd_server:/{n;N;N;N;N;N;N;N;d}' /etc/exim4/exim4.conf.template
          
  # Descomentar la línea "# plain_saslauthd_server:" y agregar el resto de líneas antes borradas pero ahora descomentadas
  sed -i -e 's|# plain_saslauthd_server:|\
    plain_saslauthd_server: \
    driver = plaintext \
    public_name = PLAIN \
    server_condition = ${if saslauthd{{$auth2}{$auth3}}{1}{0}} \
    server_set_id = $auth2 \
    server_prompts = : \
    .ifndef AUTH_SERVER_ALLOW_NOTLS_PASSWORDS \
    server_advertise_condition = ${if eq{$tls_in_cipher}{}{}{*}} \
    .endif|g' /etc/exim4/exim4.conf.template
          
  # Configurar IMAP
  rm -rf /etc/courier/*.pem
  make-ssl-cert /usr/share/ssl-cert/ssleay.cnf /etc/courier/imapd.pem
  service courier-imap restart
  service courier-imap-ssl restart
  service courier-authdaemon restart

  netstat -atupln | grep 465
          
  # Instalar y configurar SpamAssassin
  apt-get -y install spamassassin
  systemctl enable spamassassin.service
          
  echo ""
  echo "Sistema instalado."
  echo ""
  echo "Para crear un usuario sin acceso al shell ejecuta:"
  echo "/root/scripts/d-scripts/UsuarioNuevoSinShell.sh"
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de exim4 para Debian 11 (Bullseye)..."
  
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi

