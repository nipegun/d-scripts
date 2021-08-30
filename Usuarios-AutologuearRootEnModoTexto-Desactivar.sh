#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para desactivar el logueo automático del root en modo texto (terminal no gráfico)
#-------------------------------------------------------------------------------------------------------

# Se debe reemplazar la línea
# ExecStart=-/sbin/agetty -o '-p -- \\u' --noclear -a root %I $TERM
# por
# ExecStart=-/sbin/agetty -o '-p -- \\u' --noclear %I $TERM
# en el archivo
# /lib/systemd/system/getty@.service

sed -i -e 's|ExecStart=-/sbin/agetty -o '-p -- \\u' --noclear -a root %I $TERM|ExecStart=-/sbin/agetty -o '-p -- \\u' --noclear %I $TERM|g' /lib/systemd/system/getty@.service

## Borrar la línea que empieza por ExecStart
   sed -i '/^ExecStart/d' /lib/systemd/system/getty@.service
## Reemplazar la línea Type=idle por la línea de ejecucion, un saldo de línea y nuevamente type idle
   sed -i -e 's|Type=idle|ExecStart=-/sbin/agetty -o '"'-p -- \\\\\\\u'"' --noclear %I $TERM\nType=idle|g' /lib/systemd/system/getty@.service

