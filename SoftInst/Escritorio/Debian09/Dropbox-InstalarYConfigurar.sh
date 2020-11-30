#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------
#  Script de NiPeGun para instalar Dropbox en Debian 9
#-------------------------------------------------------

echo ""
echo "  Creando la carpeta para descargar el paquete..."
echo ""
mkdir -p ~/paquetes/dropbox/

echo ""
echo "  Descargando el paquete desde la web de Dropbox..."
echo ""
wget -O ~/paquetes/dropbox/dropbox.tar https://www.dropbox.com/download?plat=lnx.x86_64

echo ""
echo "  Descomprimiendo el paquete..."
echo ""
tar xzf ~/paquetes/dropbox/dropbox.tar -C ~/

echo ""
echo "  Descargando el script de python para controlar Dropbox desde la terminal"
echo ""
wget -O ~/scripts/DemonioDropbox.py "https://www.dropbox.com/download?dl=packages/dropbox.py"
chmod +x ~/scripts/DemonioDropbox.py

echo ""
echo "  Configurando dropbox para que se inicie con el sistema..."
echo ""
echo "~/scripts/DemonioDropbox.py start" >> /root/scripts/ComandosPostArranque.sh

echo ""
echo "  Arrancando el daemon por primera vez..."
echo ""
echo "  Toma nota de la url que te pondrá abajo porque deberás ingresar a ella"
echo "  desde un nbavegador en el que tengas iniciada la sesión de Dropbox"
echo "  para activar el dropbox que acabas de instalar."
echo ""
~/.dropbox-dist/dropboxd
echo ""
