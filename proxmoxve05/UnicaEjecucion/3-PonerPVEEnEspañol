#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------
#  Script de NiPeGun para poner ProxmoxVE en español
#-----------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

# Actualizar
apt-get -y update

# Activar el locale en español de España UTF-8 descomentando
# la línea que empiece por "# es_ES.UTF-8" en /etc/locale.gen
sed -i 's/^# *\(es_ES.UTF-8\)/\1/' /etc/locale.gen

# Generar los nuevos locales activados en /etc/locale.gen
locale-gen

# Modificar el archivo /etc/default/locale reflejando los cambios
echo -e 'LANG="es_ES.UTF-8"\nLANGUAGE="es_ES:es"\n' > /etc/default/locale

echo -e "${ColorVerde}El idioma del sistema ha cambiado.${FinColor}"
echo -e "${ColorVerde}Es necesario cerrar la sesión para que los cambios surjan efecto.${FinColor}"

