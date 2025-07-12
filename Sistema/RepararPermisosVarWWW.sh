#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para reparar los permisos de la carpeta /var/www
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

FechaDeEjec=$(date +A%YM%mD%d@%T)

# Asignar propiedad de todo el contenido al usuario www-data
echo ""
chown www-data:www-data /var/www -R
echo "..."
# Poner los permisos correctos a carpetas
echo ""
find /var/www -type d -exec chmod 755 {} \;
echo "..."
# Poner los permisos correctos a archivos
echo ""
find /var/www -type f -exec chmod 644 {} \;
echo "..."
# Asignar la propiedad de /var/root al usuario root. (Necesario para enjaular Webs por SFTP)
echo ""
chown root:root /var/www
echo "..."
echo ""
echo "La reparación de permisos se terminó de ejecutar el $FechaDeEjec" >> /var/log/RepPermisos.log
echo -e "${cColorVerde}  Proceso de reparación de permisos de /var/www, finalizado.${cFinColor}"
echo ""

