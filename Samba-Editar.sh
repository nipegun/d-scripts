#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ------------
#  Script de NiPeGun para editar la configuración del demonio dhcpd
# ------------

echo ""
echo "Editando el archivo de configuración..."
echo ""
nano /etc/samba/smb.conf

echo ""
echo "Indicando al servicio que vuelva a cargar el archivo de configuración..."
echo ""
service smbd reload

echo ""
echo "Estado del servicio:"
echo ""
service smbd status

