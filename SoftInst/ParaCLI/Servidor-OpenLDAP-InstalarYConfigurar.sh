#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar el servidor OpenLDAP en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-OpenLDAP-InstalarYConfigurar.sh | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'


vIPPropia=$(hostname -I)
vNombreServidor="servidoroldap"
vDominio="lan"
vExtDominio="local"

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org 
     . /etc/os-release
     cNomSO=$NAME
     cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # linuxbase.org
     cNomSO=$(lsb_release -si)
     cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release
     . /etc/lsb-release
     cNomSO=$DISTRIB_ID
     cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
     cNomSO=Debian
     cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD)
     cNomSO=$(uname -s)
     cVerSO=$(uname -r)
  fi

if [ $cVerSO == "7" ]; then

  echo ""

  echo "  Iniciando el script de instalación del servidor OpenLDAP en Debian 7 (Wheezy)..."

  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""

  echo "  Iniciando el script de instalación del servidor OpenLDAP en Debian 8 (Jessie)..."

  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor OpenLDAP en Debian 9 (Stretch)..."
  echo "---------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor OpenLDAP en Debian 10 (Buster)..."
  echo "---------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "---------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor OpenLDAP en Debian 11 (Bullseye)..."
  echo "---------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Modificando el archivo /etc/hostname..."
  echo ""
  echo "$vNombreServidor" > /etc/hostname

  echo ""
  echo "  Modificando el archivo /etc/hosts..."
  echo ""
  echo "$vIPPropia $vNombreServidor.$vDominio.$vExtDominio" >> /etc/hosts

  echo ""
  echo "  Instalando paquetes..."
  echo ""
  apt-get -y update
  apt-get -y install slapd
  apt-get -y install ldap-utils
  
  echo ""
  echo "  Reconfigurando slapd..."
  echo ""
  dpkg-reconfigure slapd

  echo ""
  echo "  Mostrando información del servidor..."
  echo ""
  slapcat

  echo ""
  echo "  Agregando unidades organizativas..."
  echo ""
  mkdir -p /root/OpenLDAP/ 2> /dev/null
  echo "dn: ou=tecnicos,dc=$vDominio,dc=$vExtDominio"  > /root/OpenLDAP/UnidadesOrganizativas.ldif
  echo "objectClass: organizationalUnit"              >> /root/OpenLDAP/UnidadesOrganizativas.ldif
  echo "ou: tecnicos"                                 >> /root/OpenLDAP/UnidadesOrganizativas.ldif
  echo ""                                             >> /root/OpenLDAP/UnidadesOrganizativas.ldif
  echo "dn: ou=usuarios,dc=$vDominio,dc=$vExtDominio" >> /root/OpenLDAP/UnidadesOrganizativas.ldif
  echo "objectClass: organizationalUnit"              >> /root/OpenLDAP/UnidadesOrganizativas.ldif
  echo "ou: usuarios"                                 >> /root/OpenLDAP/UnidadesOrganizativas.ldif
  ldapadd -x -D cn=admin,dc=$vDominio,dc=$vExtDominio -W -f /root/OpenLDAP/UnidadesOrganizativas.ldif

  echo ""
  echo "  Mostrando unidades organizativas del servidor OpenLDAP..."
  echo ""
  ldapsearch -xLLL -b "dc=$vDominio,dc=$vExtDominio" ou | grep ou:

  echo ""
  echo "  Agregando usuarios..."
  echo ""
  mkdir -p /root/OpenLDAP/ 2> /dev/null
  echo "dn: uid=pedroaguirre,ou=tecnicos,dc=$vDominio,dc=$vExtDominio"  > /root/OpenLDAP/Usuarios.ldif
  echo "objectClass: inetOrgPerson"                                    >> /root/OpenLDAP/Usuarios.ldif
  echo "objectClass: posixAccount"                                     >> /root/OpenLDAP/Usuarios.ldif
  echo "cn: Pedro"                                                     >> /root/OpenLDAP/Usuarios.ldif # Requerido si hay inetOrgPerson y posixAccount
  echo "sn: Aguirre"                                                   >> /root/OpenLDAP/Usuarios.ldif # Requerido si hay inetOrgPerson
  echo "uid: pedroaguirre"                                             >> /root/OpenLDAP/Usuarios.ldif # Requerido si hay posixAccount
  echo "uidNumber: 2000"                                               >> /root/OpenLDAP/Usuarios.ldif # Requerido si hay posixAccount
  echo "gidNumber: 10000"                                              >> /root/OpenLDAP/Usuarios.ldif # Requerido si hay posixAccount
  echo "homeDirectory: /home/pedroaguirre"                             >> /root/OpenLDAP/Usuarios.ldif # Requerido si hay posixAccount
  echo ""                                                              >> /root/OpenLDAP/Usuarios.ldif # Debe haber una línea vacía entre dn y dn
  echo "dn: uid=juanoria,ou=usuarios,dc=$vDominio,dc=$vExtDominio"     >> /root/OpenLDAP/Usuarios.ldif
  echo "objectClass: inetOrgPerson"                                    >> /root/OpenLDAP/Usuarios.ldif
  echo "objectClass: posixAccount"                                     >> /root/OpenLDAP/Usuarios.ldif
  echo "cn: Juan"                                                      >> /root/OpenLDAP/Usuarios.ldif # Requerido si hay inetOrgPerson y posixAccount
  echo "sn: Oria"                                                      >> /root/OpenLDAP/Usuarios.ldif # Requerido si hay inetOrgPerson
  echo "uid: juanoria"                                                 >> /root/OpenLDAP/Usuarios.ldif # Requerido si hay posixAccount
  echo "uidNumber: 2001"                                               >> /root/OpenLDAP/Usuarios.ldif # Requerido si hay posixAccount
  echo "gidNumber: 10001"                                              >> /root/OpenLDAP/Usuarios.ldif # Requerido si hay posixAccount
  echo "homeDirectory: /home/juanoria"                                 >> /root/OpenLDAP/Usuarios.ldif # Requerido si hay posixAccount
  echo "loginShell: /bin/bash"                                         >> /root/OpenLDAP/Usuarios.ldif # Atributo no obligatorio de posixAccount
  echo "userPassword: 12345678"                                        >> /root/OpenLDAP/Usuarios.ldif # Atributo no obligatorio de posixAccount
  echo "mail: juanoria@gmail.com"                                      >> /root/OpenLDAP/Usuarios.ldif # Atributo no obligatorio de inetOrgPerson
  echo "displayName: Juan Oria"                                        >> /root/OpenLDAP/Usuarios.ldif # Atributo no obligatorio de inetOrgPerson
  ldapadd -x -D cn=admin,dc=$vDominio,dc=$vExtDominio -W -f /root/OpenLDAP/Usuarios.ldif

  echo ""
  echo "  Mostrando usuarios del servidor OpenLDAP..."
  echo ""
  ldapsearch -xLLL -b "dc=$vDominio,dc=$vExtDominio" dn | cut -d ',' -f1 | grep uid

  echo ""
  echo "  Instalando LAM (LDAP Account Manager)..."
  echo ""
  apt-get -y install ldap-account-manager

fi

