#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para actualizar Debian
#
# Ejecución remota:
#   curl -sL x | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' x | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Indicar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de actualización del sistema operativo...${cFinColor}"
  echo ""

# Reparar permisos de /tmp
  echo ""
  echo "    Reparando permisos de la carpeta /tmp/ ..."
  echo ""
  chmod 1777 /tmp

# Actualizar lista de paquetes disponibles en los repositorios
  echo ""
  echo "    Actualizando lista de paquetes disponibles en los repositorios..."
  echo ""
  apt-get -y update

# Ejecutar upgrade
  echo ""
  echo "    Ejecutando apt-get -y upgrade..."
  echo ""
  apt-get -y --allow-downgrades upgrade

# Ejecutar dist-upgrade
  echo ""
  echo "    Ejecutando apt-get -y dist-upgrade..."
  echo ""
  apt-get -y --allow-downgrades dist-upgrade

# Borrar paquetes sobrantes innecesarios
  echo ""
  echo "    Ejecutando apt-get -y autoremove..."
  echo ""
  apt-get -y autoremove

# Notificar fin de ejecución del script
  echo ""
  echo -e "${cColorVerde}    Script para actualizar el sistema operativo, finalizado.${cFinColor}"
  echo ""

