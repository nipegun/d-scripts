#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear el archivo con las instrucciones de reparación de permisos del sistema
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/Permisos-PrepararReparacion.sh | bash
# ----------

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
  vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${vColorAzulClaro}  Iniciando script para crear el script de reparación de permisos...${vFinColor}"
  echo ""

# Crear el script de reparación de permisos
  mkdir -p /root/scripts/EsteDebian/ 2> /dev/null
  echo '#!/bin/bash'                                                                                    > /root/scripts/EsteDebian/RepararPermisos.sh
  echo ""                                                                                              >> /root/scripts/EsteDebian/RepararPermisos.sh
  echo 'vFechaDeEjecucion=$(date +a%Ym%md%d@%T)'                                                       >> /root/scripts/EsteDebian/RepararPermisos.sh
  echo ""                                                                                              >> /root/scripts/EsteDebian/RepararPermisos.sh
  echo 'echo "La reparación de permisos se ejecutó el $vFechaDeEjecucion" >> /var/log/RepPermisos.log' >> /root/scripts/EsteDebian/RepararPermisos.sh
  echo ""                                                                                              >> /root/scripts/EsteDebian/RepararPermisos.sh
  echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS DE REPARACIÓN DE PERMISOS A EJECUTAR"              >> /root/scripts/EsteDebian/RepararPermisos.sh
  echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"            >> /root/scripts/EsteDebian/RepararPermisos.sh
  echo ""                                                                                              >> /root/scripts/EsteDebian/RepararPermisos.sh
  echo 'echo ""'                                                                                       >> /root/scripts/EsteDebian/RepararPermisos.sh
  echo 'echo "  Reparando permisos..."'                                                                >> /root/scripts/EsteDebian/RepararPermisos.sh
  echo 'echo ""'                                                                                       >> /root/scripts/EsteDebian/RepararPermisos.sh
  echo 'echo "    Reparando permisos web..."'                                                          >> /root/scripts/EsteDebian/RepararPermisos.sh
  echo 'echo ""'                                                                                       >> /root/scripts/EsteDebian/RepararPermisos.sh
  echo "chown -R www-data:www-data /var/www"                                                           >> /root/scripts/EsteDebian/RepararPermisos.sh
  echo "find /var/www -type d -exec chmod 755 {} \;"                                                   >> /root/scripts/EsteDebian/RepararPermisos.sh
  echo "find /var/www -type f -exec chmod 644 {} \;"                                                   >> /root/scripts/EsteDebian/RepararPermisos.sh
  echo "chown root:root /var/www # Necesario para enjaular las cuentas"                                >> /root/scripts/EsteDebian/RepararPermisos.sh
  chmod 700                                                                                               /root/scripts/EsteDebian/RepararPermisos.sh

