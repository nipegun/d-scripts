#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------------------
#  SCRIPT DE NIPEGUN PARA PONER LOS REPOSITORIOS COMPLETOS EN DEBIAN 9
#-----------------------------------------------------------------------

echo ""
echo "---------------------------------------"
echo "  PONIENDO LOS REPOSITORIOS COMPLETOS"
echo "---------------------------------------"
echo ""
cp /etc/apt/sources.list /etc/apt/sources.list.bak
echo "deb http://ftp.debian.org/debian/ stretch main contrib non-free" > /etc/apt/sources.list
echo "deb-src http://ftp.debian.org/debian/ stretch main contrib non-free" >> /etc/apt/sources.list
echo "" >> /etc/apt/sources.list
echo "deb http://ftp.debian.org/debian/ stretch-updates main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://ftp.debian.org/debian/ stretch-updates main contrib non-free" >> /etc/apt/sources.list
echo "" >> /etc/apt/sources.list
echo "deb http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list
echo "" >> /etc/apt/sources.list
echo ""

