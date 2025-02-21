#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para cambiar el idioma del sistema y del teclado a sólo español
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/Idioma-CambiarTodoAes-es.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/PostInst/CLI/Idioma-CambiarTodoAes-es.sh | sed 's-sudo--g' | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    exit
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # linuxbase.org
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD)
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "13" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de cambio de idioma a español en Debian 13 (x)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "12" ]; then

  # Poner que sólo se genere el español de España cuando se creen locales
    sudo rm -f  /etc/locale.gen
    echo "es_ES.UTF-8 UTF-8" | sudo tee /etc/locale.gen

  # Compilar los locales borrando primero los existentes y dejando nada más que el español de España
    sudo apt-get -y update
    sudo apt-get -y install locales
    sudo locale-gen --purge es_ES.UTF-8

  # Modificar el archivo /etc/default/locale reflejando los cambios
    echo 'LANG="es_ES.UTF-8"'  | sudo tee    /etc/default/locale
    echo 'LANGUAGE="es_ES:es"' | sudo tee -a /etc/default/locale

  # Poner el teclado en español de España
    echo 'XKBMODEL="pc105"'  | sudo tee    /etc/default/keyboard
    echo 'XKBLAYOUT="es"'    | sudo tee -a /etc/default/keyboard
    echo 'XKBVARIANT=""'     | sudo tee -a /etc/default/keyboard
    echo 'XKBOPTIONS=""'     | sudo tee -a /etc/default/keyboard
    echo ''                  | sudo tee -a /etc/default/keyboard
    echo 'BACKSPACE="guess"' | sudo tee -a /etc/default/keyboard
    echo ''                  | sudo tee -a /etc/default/keyboard

  # Indicar idioma español de España para todos los usuarios
    echo ""                                                      | sudo tee    /etc/profile
    echo '# Poner idioma español de España a todos los usuarios' | sudo tee -a /etc/profile
    echo '  export LANG=es_ES.UTF-8'                             | sudo tee -a /etc/profile
    echo '  export LANGUAGE=es_ES:es'                            | sudo tee -a /etc/profile
    
    echo '  export LANG=es_ES.UTF-8'                             | sudo tee -a /etc/skel/.bashrc
    echo '  export LANGUAGE=es_ES:es'                            | sudo tee -a /etc/skel/.bashrc

  # Notificar cambios
    echo ""
    echo -e "${cColorAzulClaro}    Cambios realizados.${cFinColor}"
    echo -e "${cColorAzulClaro}    Debes reiniciar el sistema para que los cambios tengan efecto.${cFinColor}"
    echo ""

elif [ $cVerSO == "11" ]; then

  # Poner que sólo se genere el español de España cuando se creen locales
    sudo rm -f  /etc/locale.gen
    echo "es_ES.UTF-8 UTF-8" | sudo tee /etc/locale.gen

  # Compilar los locales borrando primero los existentes y dejando nada más que el español de España
    sudo apt-get -y update
    sudo apt-get -y install locales
    sudo locale-gen --purge es_ES.UTF-8

  # Modificar el archivo /etc/default/locale reflejando los cambios
    echo 'LANG="es_ES.UTF-8"'  | sudo tee    /etc/default/locale
    echo 'LANGUAGE="es_ES:es"' | sudo tee -a /etc/default/locale

  # Poner el teclado en español de España
    echo 'XKBMODEL="pc105"'  | sudo tee    /etc/default/keyboard
    echo 'XKBLAYOUT="es"'    | sudo tee -a /etc/default/keyboard
    echo 'XKBVARIANT=""'     | sudo tee -a /etc/default/keyboard
    echo 'XKBOPTIONS=""'     | sudo tee -a /etc/default/keyboard
    echo ''                  | sudo tee -a /etc/default/keyboard
    echo 'BACKSPACE="guess"' | sudo tee -a /etc/default/keyboard
    echo ''                  | sudo tee -a /etc/default/keyboard

  # Indicar idioma español de España para todos los usuarios
    echo ""                                                      | sudo tee    /etc/profile
    echo '# Poner idioma español de España a todos los usuarios' | sudo tee -a /etc/profile
    echo '  export LANG=es_ES.UTF-8'                             | sudo tee -a /etc/profile
    echo '  export LANGUAGE=es_ES:es'                            | sudo tee -a /etc/profile
    
    echo '  export LANG=es_ES.UTF-8'                             | sudo tee -a /etc/skel/.bashrc
    echo '  export LANGUAGE=es_ES:es'                            | sudo tee -a /etc/skel/.bashrc

  # Notificar cambios
    echo ""
    echo -e "${cColorAzulClaro}    Cambios realizados.${cFinColor}"
    echo -e "${cColorAzulClaro}    Debes reiniciar el sistema para que los cambios tengan efecto.${cFinColor}"
    echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de cambio de idioma a español en Debian 10 (Buster)...${cFinColor}"
  echo ""

  # Poner que sólo se genere el español de España cuando se creen locales
    sudo rm -f  /etc/locale.gen
    echo "es_ES.UTF-8 UTF-8" | sudo tee /etc/locale.gen

  # Compilar los locales borrando primero los existentes y dejando nada más que el español de España
    sudo apt-get -y update
    sudo apt-get -y install locales
    sudo locale-gen --purge es_ES.UTF-8

  # Modificar el archivo /etc/default/locale reflejando los cambios
    echo 'LANG="es_ES.UTF-8"'  | sudo tee    /etc/default/locale
    echo 'LANGUAGE="es_ES:es"' | sudo tee -a /etc/default/locale

  # Poner el teclado en español de España
    echo 'XKBMODEL="pc105"'  | sudo tee    /etc/default/keyboard
    echo 'XKBLAYOUT="es"'    | sudo tee -a /etc/default/keyboard
    echo 'XKBVARIANT=""'     | sudo tee -a /etc/default/keyboard
    echo 'XKBOPTIONS=""'     | sudo tee -a /etc/default/keyboard
    echo ''                  | sudo tee -a /etc/default/keyboard
    echo 'BACKSPACE="guess"' | sudo tee -a /etc/default/keyboard
    echo ''                  | sudo tee -a /etc/default/keyboard

  # Indicar idioma español de España para todos los usuarios
    echo ""                                                      | sudo tee    /etc/profile
    echo '# Poner idioma español de España a todos los usuarios' | sudo tee -a /etc/profile
    echo '  export LANG=es_ES.UTF-8'                             | sudo tee -a /etc/profile
    echo '  export LANGUAGE=es_ES:es'                            | sudo tee -a /etc/profile
    
    echo '  export LANG=es_ES.UTF-8'                             | sudo tee -a /etc/skel/.bashrc
    echo '  export LANGUAGE=es_ES:es'                            | sudo tee -a /etc/skel/.bashrc

  # Notificar cambios
    echo ""
    echo -e "${cColorAzulClaro}    Cambios realizados.${cFinColor}"
    echo -e "${cColorAzulClaro}    Debes reiniciar el sistema para que los cambios tengan efecto.${cFinColor}"
    echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de cambio de idioma a español en Debian 9 (Stretch)...${cFinColor}"
  echo ""

  # Poner que sólo se genere el español de España cuando se creen locales
    sudo rm -f  /etc/locale.gen
    echo "es_ES.UTF-8 UTF-8" | sudo tee /etc/locale.gen

  # Compilar los locales borrando primero los existentes y dejando nada más que el español de España
    sudo apt-get -y update
    sudo apt-get -y install locales
    sudo locale-gen --purge es_ES.UTF-8

  # Modificar el archivo /etc/default/locale reflejando los cambios
    echo 'LANG="es_ES.UTF-8"'  | sudo tee    /etc/default/locale
    echo 'LANGUAGE="es_ES:es"' | sudo tee -a /etc/default/locale

  # Poner el teclado en español de España
    echo 'XKBMODEL="pc105"'  | sudo tee    /etc/default/keyboard
    echo 'XKBLAYOUT="es"'    | sudo tee -a /etc/default/keyboard
    echo 'XKBVARIANT=""'     | sudo tee -a /etc/default/keyboard
    echo 'XKBOPTIONS=""'     | sudo tee -a /etc/default/keyboard
    echo ''                  | sudo tee -a /etc/default/keyboard
    echo 'BACKSPACE="guess"' | sudo tee -a /etc/default/keyboard
    echo ''                  | sudo tee -a /etc/default/keyboard

  # Indicar idioma español de España para todos los usuarios
    echo ""                                                      | sudo tee    /etc/profile
    echo '# Poner idioma español de España a todos los usuarios' | sudo tee -a /etc/profile
    echo '  export LANG=es_ES.UTF-8'                             | sudo tee -a /etc/profile
    echo '  export LANGUAGE=es_ES:es'                            | sudo tee -a /etc/profile
    
    echo '  export LANG=es_ES.UTF-8'                             | sudo tee -a /etc/skel/.bashrc
    echo '  export LANGUAGE=es_ES:es'                            | sudo tee -a /etc/skel/.bashrc

  # Notificar cambios
    echo ""
    echo -e "${cColorAzulClaro}    Cambios realizados.${cFinColor}"
    echo -e "${cColorAzulClaro}    Debes reiniciar el sistema para que los cambios tengan efecto.${cFinColor}"
    echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de cambio de idioma a español en Debian 8 (Jessie)...${cFinColor}"
  echo ""

  # Poner que sólo se genere el español de España cuando se creen locales
    sudo rm -f  /etc/locale.gen
    echo "es_ES.UTF-8 UTF-8" | sudo tee /etc/locale.gen

  # Compilar los locales borrando primero los existentes y dejando nada más que el español de España
    sudo apt-get -y update
    sudo apt-get -y install locales
    sudo locale-gen --purge es_ES.UTF-8

  # Modificar el archivo /etc/default/locale reflejando los cambios
    echo 'LANG="es_ES.UTF-8"'  | sudo tee    /etc/default/locale
    echo 'LANGUAGE="es_ES:es"' | sudo tee -a /etc/default/locale

  # Poner el teclado en español de España
    echo 'XKBMODEL="pc105"'  | sudo tee    /etc/default/keyboard
    echo 'XKBLAYOUT="es"'    | sudo tee -a /etc/default/keyboard
    echo 'XKBVARIANT=""'     | sudo tee -a /etc/default/keyboard
    echo 'XKBOPTIONS=""'     | sudo tee -a /etc/default/keyboard
    echo ''                  | sudo tee -a /etc/default/keyboard
    echo 'BACKSPACE="guess"' | sudo tee -a /etc/default/keyboard
    echo ''                  | sudo tee -a /etc/default/keyboard

  # Indicar idioma español de España para todos los usuarios
    echo ""                                                      | sudo tee    /etc/profile
    echo '# Poner idioma español de España a todos los usuarios' | sudo tee -a /etc/profile
    echo '  export LANG=es_ES.UTF-8'                             | sudo tee -a /etc/profile
    echo '  export LANGUAGE=es_ES:es'                            | sudo tee -a /etc/profile
    
    echo '  export LANG=es_ES.UTF-8'                             | sudo tee -a /etc/skel/.bashrc
    echo '  export LANGUAGE=es_ES:es'                            | sudo tee -a /etc/skel/.bashrc

  # Notificar cambios
    echo ""
    echo -e "${cColorAzulClaro}    Cambios realizados.${cFinColor}"
    echo -e "${cColorAzulClaro}    Debes reiniciar el sistema para que los cambios tengan efecto.${cFinColor}"
    echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de cambio de idioma a español en Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  # Poner que sólo se genere el español de España cuando se creen locales
    sudo rm -f  /etc/locale.gen
    echo "es_ES.UTF-8 UTF-8" | sudo tee /etc/locale.gen

  # Compilar los locales borrando primero los existentes y dejando nada más que el español de España
    sudo apt-get -y update
    sudo apt-get -y install locales
    sudo locale-gen --purge es_ES.UTF-8

  # Modificar el archivo /etc/default/locale reflejando los cambios
    echo 'LANG="es_ES.UTF-8"'  | sudo tee    /etc/default/locale
    echo 'LANGUAGE="es_ES:es"' | sudo tee -a /etc/default/locale

  # Poner el teclado en español de España
    echo 'XKBMODEL="pc105"'  | sudo tee    /etc/default/keyboard
    echo 'XKBLAYOUT="es"'    | sudo tee -a /etc/default/keyboard
    echo 'XKBVARIANT=""'     | sudo tee -a /etc/default/keyboard
    echo 'XKBOPTIONS=""'     | sudo tee -a /etc/default/keyboard
    echo ''                  | sudo tee -a /etc/default/keyboard
    echo 'BACKSPACE="guess"' | sudo tee -a /etc/default/keyboard
    echo ''                  | sudo tee -a /etc/default/keyboard

  # Indicar idioma español de España para todos los usuarios
    echo ""                                                      | sudo tee    /etc/profile
    echo '# Poner idioma español de España a todos los usuarios' | sudo tee -a /etc/profile
    echo '  export LANG=es_ES.UTF-8'                             | sudo tee -a /etc/profile
    echo '  export LANGUAGE=es_ES:es'                            | sudo tee -a /etc/profile
    
    echo '  export LANG=es_ES.UTF-8'                             | sudo tee -a /etc/skel/.bashrc
    echo '  export LANGUAGE=es_ES:es'                            | sudo tee -a /etc/skel/.bashrc

  # Notificar cambios
    echo ""
    echo -e "${cColorAzulClaro}    Cambios realizados.${cFinColor}"
    echo -e "${cColorAzulClaro}    Debes reiniciar el sistema para que los cambios tengan efecto.${cFinColor}"
    echo ""

fi

