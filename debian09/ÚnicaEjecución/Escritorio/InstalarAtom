#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------
#  Script de NiPeGun para instalar Atom en Debian 9
#-------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

echo ""
echo "  Instalando Atom..."
echo ""
apt-get update
apt-get -y install gdebi wget
mkdir -p /root/paquetes/atom
cd /root/paquetes/atom
URLArchivoDebConTag=$(curl --silent  https://github.com/atom/atom/releases/latest | cut -d\" -f2)
PalabraNueva="download"
URLArchivoDeb="${URLArchivoDebConTag/tag/$PalabraNueva}" 
wget --no-check-certificate $URLArchivoDeb/atom-amd64.deb
gdebi atom-amd64.deb

