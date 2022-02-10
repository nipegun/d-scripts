#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para monitorizar las conexiones xrdp
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/xrdp-Monitorear-Conexion.sh | bash
#---------------------------------------------------------------------------------------------------------

## Comprobar si el paquete disown está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s disown 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "  disown no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update
     apt-get -y install disown
     echo ""
   fi
touch /var/log/XRDPWatch.log
echo ""
echo "  Loqueando conexiones xrdp..."
echo ""
tail -f /var/log/xrdp.log | grep -E "onnected client"\|"onnection established"\|"ogin success" >> /var/log/XRDPWatch.log &
tail -f /var/log/xrdp-sesman.log | grep "reated session"                                       >> /var/log/XRDPWatch.log &


