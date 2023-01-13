#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para comprobar si un servidor MariaDB está caido y, si eso, 
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/MariaDB-Servidor-ComprobarYLevantar.sh | bash -s URL Servicio
#
#  Ejemplo:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/MariaDB-Servidor-ComprobarYLevantar.sh | bash -s https://nightly.odoo.com/odoo.key Odoo
# ----------

vEstadoServBD=$(systemctl status mariadb.service | grep "atus:" | cut -d'"' -f2)

if [[ $vEstadoServBD == "MariaDB server is down" ]]; then
  echo ""
  echo "  El servidor MariaDB está caido. Intentando levantarlo..."
  echo ""
  systemctl start mariadb
fi

