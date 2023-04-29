#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para actualizar Debian
# ----------

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

echo ""
echo -e "${vColorAzulClaro}  Iniciando el script de actualización del sistema operativo...${vFinColor}"
echo ""

echo ""
echo "    Reparando permisos de la carpeta /tmp/ ..."
echo ""
chmod 1777 /tmp

echo ""
echo "    Ejecutando apt-get update..."
echo ""
apt-get -y update

echo ""
echo "    Ejecutando apt-get -y upgrade..."
echo ""
apt-get -y --allow-downgrades upgrade

echo ""
echo "    Ejecutando apt-get -y dist-upgrade..."
echo ""
apt-get -y --allow-downgrades dist-upgrade

echo ""
echo "    Ejecutando apt-get -y autoremove..."
echo ""
apt-get -y autoremove

echo ""
echo -e "${vColorVerde}    Script para actualizar el sistema operativo, finalizado.${vFinColor}"
echo ""

