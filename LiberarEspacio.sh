#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# -----------
#  Script de NiPeGun para liberar espacio en Linux
# -----------

# Eliminar del cache los paquetes .deb con versiones anteriores
# a los de los programas que tienes instalados.
apt-get autoclean

# Eliminar todos los paquetes del cache. El único inconveniente que podría resultar
# es que si quieres reinstalar un paquete, tienes que volver a descargarlo.
apt-get clean

# Borrar los paquetes huérfanos, o las dependencias que quedan instaladas después
# de haber instalado una aplicación y luego eliminarla, por lo que ya no son necesarias.
apt-get autoremove

