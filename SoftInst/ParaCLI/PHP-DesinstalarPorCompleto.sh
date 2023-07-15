#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para actualizar el PHP por defecto de Stretch a la última versión disponible
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/PHP-DesinstalarPorCompleto.sh | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

echo ""
echo -e "${cColorVerde}Desinstalando PHP por completo...${cFinColor}"
echo ""

NroPHP=$(php -v | head -1 | cut -d " " -f 2 | cut -c 1-3)
echo "La versión de PHP instalada en el sistema es: $NroPHP"

# Hacer una lista de los paquetes php actualmente instalados
apt list --installed | grep php > /var/tmp/PHPInstalled.list
sed -i 's/\/.*//' /var/tmp/PHPInstalled.list
sed -i -e 's|phpmyadmin||g' /var/tmp/PHPInstalled.list
echo ""
echo "Los paquetes relacionados con PHP actualmente instalados en el sistema son:"
echo ""
cat /var/tmp/PHPInstalled.list
echo ""

# Preparar el script para borrar los paquetes instalados
rm -rf /var/tmp/PaquetesPHPaBorrar.sh
mv /var/tmp/PHPInstalled.list /var/tmp/PaquetesPHPaBorrar.sh
sed -i -e 's/^/apt-get -y purge /' /var/tmp/PaquetesPHPaBorrar.sh
chmod +x /var/tmp/PaquetesPHPaBorrar.sh

# Borrar los paquetes PHP instalados
/var/tmp/PaquetesPHPaBorrar.sh
apt-get -y autoremove

