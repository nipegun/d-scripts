#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  SCRIPT DE NIPEGUN PARA MEDIR LA VELOCIDAD DE ESCRITURA DEL DISCO DE SISTEMA
#  LA ESCRITURA SE EFECTÚA SOBRE LA CARPETA /tmp/ POR LO QUE ES NECESARIO QUE
#  /tmp/ NO ESTÉ MONTADA DESDE OTRO DISCO QUE NO SEA EL QUE TIENE EL SISTEMA
# ----------

echo ""
echo "Midiendo la velocidad para copiar 100MB en partes de 1MB:"
echo ""
dd if=/dev/zero of=/tmp/archivodeprueba conv=fdatasync bs=1M count=100; rm -f /tmp/archivodeprueba

echo ""
echo "Midiendo la velocidad para copiar 1GB en partes de 1MB:"
echo ""
dd if=/dev/zero of=/tmp/archivodeprueba conv=fdatasync bs=1M count=1000; rm -f /tmp/archivodeprueba

echo ""
echo "Midiendo la velocidad para copiar 1GB de una sola vez:"
echo""
dd if=/dev/zero of=/tmp/archivodeprueba conv=fdatasync bs=1G count=1; rm -f /tmp/archivodeprueba
echo ""

