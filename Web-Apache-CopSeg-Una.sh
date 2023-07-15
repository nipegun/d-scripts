#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para hacer copia de seguridad interna de un servidor web con Apache
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Web-Apache-CopSeg-Una.sh | bash
# ----------

vWeb="hacks4geeks.com"
vBDNombre=""
vBDUsuario=""
vBDPass=""
vUsuarioHome=""

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

FechaDeEjecCopSegInt=$(date +A%Y-M%m-D%d@%T)

# Borrar copias anteriores
  echo ""
  echo "  Borrando todas las copias de seguridad anteriores..." 
echo ""
  rm /CopSegInt/* -R

# Ejecutar copia
  echo ""
  echo -e "${cColorVerde}  Ejecutando copia de seguridad interna...${cFinColor}"
  echo ""

  # Archivos de la Web
    mkdir -p /CopSegInt/$FechaDeEjecCopSegInt/ArchivosDeLaWeb/
    zip -r   /CopSegInt/$FechaDeEjecCopSegInt/ArchivosDeLaWeb/$Web.zip /var/www/$Web/

  # Base de datos de la web
    mkdir -p /CopSegInt/$FechaDeEjecCopSegInt/BaseDeDatosDeLaWeb/
    ebdd $vBDNombre $vBDPass $vBDUsuario /CopSegInt/$FechaDeEjecCopSegInt/BaseDeDatosDeLaWeb/$vWeb.sql

  # Apache2
    mkdir -p /CopSegInt/$FechaDeEjecCopSegInt/DiscoDuro/etc/apache2/conf-available/
    mkdir -p /CopSegInt/$FechaDeEjecCopSegInt/DiscoDuro/etc/apache2/sites-available/
    cp /etc/apache2/conf-available/remoteip.conf /CopSegInt/$FechaDeEjecCopSegInt/DiscoDuro/etc/apache2/conf-available/
    cp /etc/apache2/sites-available/*            /CopSegInt/$FechaDeEjecCopSegInt/DiscoDuro/etc/apache2/sites-available/

  # Interfaces
    mkdir -p /CopSegInt/$FechaDeEjecCopSegInt/DiscoDuro/etc/network/
    cp /etc/network/interfaces /CopSegInt/$FechaDeEjecCopSegInt/DiscoDuro/etc/network/

  # Resto /etc
    cp /etc/hostname    /CopSegInt/$FechaDeEjecCopSegInt/DiscoDuro/etc/
    cp /etc/rc.local    /CopSegInt/$FechaDeEjecCopSegInt/DiscoDuro/etc/
    cp /etc/resolv.conf /CopSegInt/$FechaDeEjecCopSegInt/DiscoDuro/etc/

  # /home/$vUsuarioHome
    mkdir -p /CopSegInt/$FechaDeEjecCopSegInt/DiscoDuro/home/$vUsuarioHome/
    rsync -a --delete /home/$vUsuarioHome/ /CopSegInt/$FechaDeEjecCopSegInt/DiscoDuro/home/$vUsuarioHome

  # LetsEncrypt
    echo ""
    echo "Creando copia de seguridad de los certificados de LetsEncrypt..."    echo ""
    mkdir -p /CopSegInt/$FechaDeEjecCopSegInt/DiscoDuro/etc/letsencrypt/
    cp -r /etc/letsencrypt/* /CopSegInt/$FechaDeEjecCopSegInt/DiscoDuro/etc/letsencrypt/

# Cambiar permisos de la copia de seguridad ya hecha
  chown $vUsuarioHome:$vUsuarioHome /CopSegInt/ -R

echo ""
echo -e "${cColorVerde}  Fin del proceso de copia de seguridad...${cFinColor}"
echo ""
