#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para borrar kernels viejos de Debian 9
# ----------

echo ""
echo "  Borrando todos los Kernels anteriores al 4.9.0-8..."
echo ""
apt-get -y purge linux-image-4.9.0-1-amd64 linux-headers-4.9.0-1-amd64
apt-get -y purge linux-image-4.9.0-2-amd64 linux-headers-4.9.0-2-amd64
apt-get -y purge linux-image-4.9.0-3-amd64 linux-headers-4.9.0-3-amd64
apt-get -y purge linux-image-4.9.0-4-amd64 linux-headers-4.9.0-4-amd64
apt-get -y purge linux-image-4.9.0-5-amd64 linux-headers-4.9.0-5-amd64
apt-get -y purge linux-image-4.9.0-6-amd64 linux-headers-4.9.0-6-amd64
apt-get -y purge linux-image-4.9.0-7-amd64 linux-headers-4.9.0-7-amd64

echo ""
echo "  Instalando el último kernel..."
echo ""
apt-get -y install linux-image-amd64

