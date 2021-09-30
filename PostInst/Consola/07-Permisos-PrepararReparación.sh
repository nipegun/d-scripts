#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------------
#  Script de NiPeGun para crear el archivo con las instrucciones
#  de reparación de permisos del sistema
#-----------------------------------------------------------------

echo ""
echo "----------------------------------------------"
echo "  CREANDO EL ARCHIVO PARA METER LOS COMANDOS"
echo "----------------------------------------------"
echo ""
mkdir -p /root/scripts/ 2> /dev/null
echo '#!/bin/bash'                                                                                   > /root/scripts/RepararPermisos.sh
echo ""                                                                                             >> /root/scripts/RepararPermisos.sh
echo 'FechaDeEjecucion=$(date +A%YM%mD%d@%T)'                                                       >> /root/scripts/RepararPermisos.sh
echo ""                                                                                             >> /root/scripts/RepararPermisos.sh
echo 'echo "La reparación de permisos se ejecutó el $FechaDeEjecucion" >> /var/log/RepPermisos.log' >> /root/scripts/RepararPermisos.sh
echo ""                                                                                             >> /root/scripts/RepararPermisos.sh
echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS DE REPARACIÓN DE PERMISOS A EJECUTAR"             >> /root/scripts/RepararPermisos.sh
echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"           >> /root/scripts/RepararPermisos.sh
echo ""                                                                                             >> /root/scripts/RepararPermisos.sh
echo 'echo ""'                                                                                      >> /root/scripts/RepararPermisos.sh
echo 'echo "-------------------------"'                                                             >> /root/scripts/RepararPermisos.sh
echo 'echo "  Reparando permisos..."'                                                               >> /root/scripts/RepararPermisos.sh
echo 'echo "-------------------------"'                                                             >> /root/scripts/RepararPermisos.sh
echo 'echo ""'                                                                                      >> /root/scripts/RepararPermisos.sh
echo 'echo "Reparando permisos web..."'                                                             >> /root/scripts/RepararPermisos.sh
echo 'echo ""'                                                                                      >> /root/scripts/RepararPermisos.sh
echo "chown -R www-data:www-data /var/www"                                                          >> /root/scripts/RepararPermisos.sh
echo "find /var/www -type d -exec chmod 755 {} \;"                                                  >> /root/scripts/RepararPermisos.sh
echo "find /var/www -type f -exec chmod 644 {} \;"                                                  >> /root/scripts/RepararPermisos.sh
echo "chown root:root /var/www # Necesario para enjaular las cuentas"                               >> /root/scripts/RepararPermisos.sh
chmod 700                                                                                              /root/scripts/RepararPermisos.sh
