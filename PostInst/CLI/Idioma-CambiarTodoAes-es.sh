#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para cambiar el idioma del sistema y del teclado a sólo español
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/Idioma-CambiarTodoAes-es.sh | bash
# ----------

# Definir variables de color
  vColorAzul="\033[0;34m"
  vColorAzulClaro="\033[1;34m"
  vColorVerde='\033[1;32m'
  vColorRojo='\033[1;31m'
  vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org
    . /etc/os-release
    OS_NAME=$NAME
    OS_VERS=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # linuxbase.org
    OS_NAME=$(lsb_release -si)
    OS_VERS=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release
    . /etc/lsb-release
    OS_NAME=$DISTRIB_ID
    OS_VERS=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    OS_NAME=Debian
    OS_VERS=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD)
    OS_NAME=$(uname -s)
    OS_VERS=$(uname -r)
  fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de cambio de idioma a español en Debian 7 (Wheezy)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de cambio de idioma a español en Debian 8 (Jessie)...${vFinColor}"
  echo ""

  # Poner que sólo se genere el español de España cuando se creen locales
    echo "es_ES.UTF-8 UTF-8" > /etc/locale.gen

  # Compilar los locales borrando primero los existentes y dejando nada más que el español de España
    apt-get -y update && apt-get -y install locales
    locale-gen --purge es_ES.UTF-8

  # Modificar el archivo /etc/default/locale reflejando los cambios
    echo 'LANG="es_ES.UTF-8"'   > /etc/default/locale
    echo 'LANGUAGE="es_ES:es"' >> /etc/default/locale

  # Poner el teclado en español de España
    echo 'XKBMODEL="pc105"'   > /etc/default/keyboard
    echo 'XKBLAYOUT="es"'    >> /etc/default/keyboard
    echo 'XKBVARIANT=""'     >> /etc/default/keyboard
    echo 'XKBOPTIONS=""'     >> /etc/default/keyboard
    echo ''                  >> /etc/default/keyboard
    echo 'BACKSPACE="guess"' >> /etc/default/keyboard
    echo ''                  >> /etc/default/keyboard

  # Notificar cambios
    echo ""
    echo -e "${vColorAzulClaro}    Cambios realizados.${vFinColor}"
    echo -e "${vColorAzulClaro}    Debes reiniciar el sistema para que los cambios tengan efecto.${vFinColor}"
    echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de cambio de idioma a español en Debian 9 (Stretch)...${vFinColor}"
  echo ""

  # Poner que sólo se genere el español de España cuando se creen locales
    echo "es_ES.UTF-8 UTF-8" > /etc/locale.gen

  # Compilar los locales borrando primero los existentes y dejando nada más que el español de España
    apt-get -y update && apt-get -y install locales
    locale-gen --purge es_ES.UTF-8

  # Modificar el archivo /etc/default/locale reflejando los cambios
    echo 'LANG="es_ES.UTF-8"'   > /etc/default/locale
    echo 'LANGUAGE="es_ES:es"' >> /etc/default/locale

  # Poner el teclado en español de España
    echo 'XKBMODEL="pc105"'   > /etc/default/keyboard
    echo 'XKBLAYOUT="es"'    >> /etc/default/keyboard
    echo 'XKBVARIANT=""'     >> /etc/default/keyboard
    echo 'XKBOPTIONS=""'     >> /etc/default/keyboard
    echo ''                  >> /etc/default/keyboard
    echo 'BACKSPACE="guess"' >> /etc/default/keyboard
    echo ''                  >> /etc/default/keyboard

  # Notificar cambios
    echo ""
    echo -e "${vColorAzulClaro}    Cambios realizados.${vFinColor}"
    echo -e "${vColorAzulClaro}    Debes reiniciar el sistema para que los cambios tengan efecto.${vFinColor}"
    echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de cambio de idioma a español en Debian 10 (Buster)...${vFinColor}"
  echo ""

  # Poner que sólo se genere el español de España cuando se creen locales
    echo "es_ES.UTF-8 UTF-8" > /etc/locale.gen

  # Compilar los locales borrando primero los existentes y dejando nada más que el español de España
    apt-get -y update && apt-get -y install locales
    locale-gen --purge es_ES.UTF-8

  # Modificar el archivo /etc/default/locale reflejando los cambios
    echo 'LANG="es_ES.UTF-8"'   > /etc/default/locale
    echo 'LANGUAGE="es_ES:es"' >> /etc/default/locale

  # Poner el teclado en español de España
    echo 'XKBMODEL="pc105"'   > /etc/default/keyboard
    echo 'XKBLAYOUT="es"'    >> /etc/default/keyboard
    echo 'XKBVARIANT=""'     >> /etc/default/keyboard
    echo 'XKBOPTIONS=""'     >> /etc/default/keyboard
    echo ''                  >> /etc/default/keyboard
    echo 'BACKSPACE="guess"' >> /etc/default/keyboard
    echo ''                  >> /etc/default/keyboard

  # Notificar cambios
    echo ""
    echo -e "${vColorVerde}    Cambios realizados.${vFinColor}"
    echo -e "${vColorVerde}    Debes reiniciar el sistema para que los cambios tengan efecto.${vFinColor}"
    echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de cambio de idioma a español en Debian 11 (Bullseye)...${vFinColor}"
  echo ""

  # Poner que sólo se genere el español de España cuando se creen locales
    echo "es_ES.UTF-8 UTF-8" > /etc/locale.gen

  # Compilar los locales borrando primero los existentes y dejando nada más que el español de España
    apt-get -y update && apt-get -y install locales
    locale-gen --purge es_ES.UTF-8

  # Modificar el archivo /etc/default/locale reflejando los cambios
    echo 'LANG="es_ES.UTF-8"'   > /etc/default/locale
    echo 'LANGUAGE="es_ES:es"' >> /etc/default/locale

  # Poner el teclado en español de España
    echo 'XKBMODEL="pc105"'   > /etc/default/keyboard
    echo 'XKBLAYOUT="es"'    >> /etc/default/keyboard
    echo 'XKBVARIANT=""'     >> /etc/default/keyboard
    echo 'XKBOPTIONS=""'     >> /etc/default/keyboard
    echo ''                  >> /etc/default/keyboard
    echo 'BACKSPACE="guess"' >> /etc/default/keyboard
    echo ''                  >> /etc/default/keyboard

  # Notificar cambios
    echo ""
    echo -e "${vColorVerde}    Cambios realizados.${vFinColor}"
    echo -e "${vColorVerde}    Debes reiniciar el sistema para que los cambios tengan efecto.${vFinColor}"
    echo ""

elif [ $OS_VERS == "12" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de cambio de idioma a español en Debian 12 (Bookworm)...${vFinColor}"
  echo ""

  # Poner que sólo se genere el español de España cuando se creen locales
    echo "es_ES.UTF-8 UTF-8" > /etc/locale.gen

  # Compilar los locales borrando primero los existentes y dejando nada más que el español de España
    apt-get -y update
    apt-get -y install locales
    locale-gen --purge es_ES.UTF-8

  # Modificar el archivo /etc/default/locale reflejando los cambios
    echo 'LANG="es_ES.UTF-8"'   > /etc/default/locale
    echo 'LANGUAGE="es_ES:es"' >> /etc/default/locale

  # Poner el teclado en español de España
    echo 'XKBMODEL="pc105"'   > /etc/default/keyboard
    echo 'XKBLAYOUT="es"'    >> /etc/default/keyboard
    echo 'XKBVARIANT=""'     >> /etc/default/keyboard
    echo 'XKBOPTIONS=""'     >> /etc/default/keyboard
    echo ''                  >> /etc/default/keyboard
    echo 'BACKSPACE="guess"' >> /etc/default/keyboard
    echo ''                  >> /etc/default/keyboard

  # Notificar cambios
    echo ""
    echo -e "${vColorVerde}    Cambios realizados.${vFinColor}"
    echo -e "${vColorVerde}    Debes reiniciar el sistema para que los cambios tengan efecto.${vFinColor}"
    echo ""


fi

