#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para securizar el servidor SSH por defecto de Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SSH-Servidor-Securizar.sh | bash
# ----------

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    OS_NAME=$NAME
    OS_VERS=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    OS_NAME=$(lsb_release -si)
    OS_VERS=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    OS_NAME=$DISTRIB_ID
    OS_VERS=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    OS_NAME=Debian
    OS_VERS=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    OS_NAME=$(uname -s)
    OS_VERS=$(uname -r)
  fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de securización de SSH para Debian 7 (Wheezy)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de securización de SSH para Debian 8 (Jessie)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de securización de SSH para Debian 9 (Stretch)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de securización de SSH para Debian 10 (Buster)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de securización de SSH para Debian 11 (Bullseye)...${vFinColor}"
  echo ""

 #menu=(dialog --timeout 5 --checklist "Marca las opciones que quieras instalar:" 22 96 16)
  menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
    opciones=(
      1 "Ejecutar securización básica (casi mandatorio)" on
      2 "Opción 2" off
      3 "Opción 3" off
      4 "Opción 4" off
      5 "Opción 5" off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  #clear

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Ejecutando securización básica..."
            echo ""
            echo "    Los cambios serán los siguientes:"
            echo ""
            echo "    - Se cambiará el puerto del 2 al 22222"
            echo "    - Se deshabilitará el logueo con la cuenta del root"
            echo "    - Se limitará el tiempo para introducir la contraseña a 15 segundos"
            echo "    - Se limitará el ingreso de contraseña incorrecta a sólo 3 veces."
            echo "    - Se denegará permanentemente el acceso a los usuarios mortadelo y filemon"
            echo ""
            # Cambiar el puerto
              sed -i -e 's|#Port 22|Port 22222|g' /etc/ssh/sshd_config
            # Deshabilitar el logueo del root
              sed -i -e 's|PermitRootLogin yes|PermitRootLogin no|g' /etc/ssh/sshd_config
            # Configurar el tiempo máximo para introducir la contraseña en 15 segundos
              sed -i -e 's|#LoginGraceTime 2m|LoginGraceTime 15|g' /etc/ssh/sshd_config
            # Limitar ingresar la contraseña mal a sólo 3 veces
              sed -i -e 's|#MaxAuthTries 6|MaxAuthTries 3|g' /etc/ssh/sshd_config
            # Denegar ssh a los usuarios mortadelo y filemon
              echo "DenyUsers mortadelo filemon" >> /etc/ssh/sshd_config

          ;;

          2)

            echo ""
            echo "  Opción 2..."
            echo ""

          ;;

          3)

            echo ""
            echo "  Opción 3..."
            echo ""

          ;;

          4)

            echo ""
            echo "  Opción 4..."
            echo ""

          ;;

          5)

            echo ""
            echo "  Opción 5..."
            echo ""

          ;;

      esac

  done

fi
