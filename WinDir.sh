#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------
#  SCRIPT DE NIPEGUN PARA MOSTRAR DIRECTORIOS COMO EL DIR DE WINDOWS
#---------------------------------------------------------------------

varParam=" -lha1FX --group-directories-first --color=auto --time-style=long-iso"
echo ""
ls $varParam
echo ""

