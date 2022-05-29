#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar el servidor web con apache2 en Debian
#
#  Ejecución remota
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-Web-apache2-InstalarYConfigurar.sh | bash
#------------------------------------------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

vCarpetaAProteger="/var/www/html/_/logs"
vNombreDeUsuario="nipegun"

echo ""
echo "  Creando el archivo para almacenar las contraseñas..."
echo ""
htpasswd -c /etc/apache2/.htpasswd $vNombreDeUsuario

# Para crear nuevos usuarios le quitamos la -c
# -c sólo se usa la primera vez

echo ""
echo "  Creando el archvivo .htaccess"
echo ""
touch $vCarpetaAProteger/.htaccess 2> /dev/null
echo "AuthType Basic"                       > $vCarpetaAProteger/.htaccess
echo 'AuthName "Password Required"'        >> $vCarpetaAProteger/.htaccess
echo "Require valid-user"                  >> $vCarpetaAProteger/.htaccess
echo "AuthUserFile /etc/apache2/.htpasswd" >> $vCarpetaAProteger/.htaccess

chown www-data:www-data $vCarpetaAProteger/.htaccess

