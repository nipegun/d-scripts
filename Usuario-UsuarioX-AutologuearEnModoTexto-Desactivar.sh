#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.


#  Script de NiPeGun para desactivar el logueo automático del usuariox en modo texto (terminal no gráfico)
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Usuario-UsuarioX-AutologuearEnModoTexto-Desactivar.sh | bash


# Se debe reemplazar la línea
# ExecStart=-/sbin/agetty --noclear -a usuariox %I $TERM
# por
# ExecStart=-/sbin/agetty -o '-p -- \\u' --noclear %I $TERM
# en el archivo
# /lib/systemd/system/getty@.service
#
# Nota:
# -o '-p -- \\u' es para que pida el password

# Esta solución es temporal y puede que se revierta en alguna actualización del sistema

## Borrar la línea que empieza por ExecStart
   sed -i '/^ExecStart/d' /lib/systemd/system/getty@.service
## Reemplazar la línea Type=idle por la línea de ejecucion, un saldo de línea y nuevamente type idle
   sed -i -e 's|Type=idle|ExecStart=-/sbin/agetty -o '"'-p -- \\\\\\\u'"' --noclear %I $TERM\nType=idle|g' /lib/systemd/system/getty@.service

