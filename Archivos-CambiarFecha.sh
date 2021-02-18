#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para cambiar la fecha a todas las carpetas y archivos dentro de una carpeta dada
#------------------------------------------------------------------------------------------------------

FechaDeseada=201701011010.10
Carpeta="/var/tmp/"

find $CarpetaDeseada -type d -print -exec touch -t $FechaDeseada {} \;
find $CarpetaDeseada -type f -print -exec touch -t $FechaDeseada {} \;

