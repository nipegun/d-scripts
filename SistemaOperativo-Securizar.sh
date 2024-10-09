#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para securizar el sistema operativo Debian
#
# Ejecución remota:
#   curl -sL x | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  #if [ $(id -u) -ne 0 ]; then     # Sólo comprueba si es root
  if [[ $EUID -ne 0 ]]; then       # Comprueba si es root o sudo
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse con privilegios de administrador (como root o con sudo).${cFinColor}"
    echo ""
    exit
  fi

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    apt-get -y update && apt-get -y install curl
    echo ""
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

# Ejecutar comandos dependiendo de la versión de Debian detectada

  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de securización de Sistema Operativo para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de securización de Sistema Operativo para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

  # Definir fecha de ejecución del script
    cFechaDeEjec=$(date +a%Ym%md%d@%T)

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update && apt-get -y install dialog
      echo ""
    fi

  # Crear el menú
    #menu=(dialog --timeout 5 --checklist "Marca las opciones que quieras instalar:" 22 96 16)
    menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
      opciones=(
        1 "Impedir a usuarios acceder a carpetas home de otros usuarios" on
        2 "Enjaular usuarios que que conecten mediante SSH" off
        3 "Comrobar permisos de archivos críticos del sistema" off
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
            echo "  Opción 1..."
            echo ""

          ;;

          2)

            echo ""
            echo "  Enjaulando usuarios que se conecten mediante SSH..."
            echo ""

            # Crear la carpeta que servirá para la jaula
              mkdir -p /home/jaula
              chown root:root /home/jaula
            # Crear el grupo para hacer match
              addgroup enjaulados
            # Agregar el usuaio al grupo enjaulados
            
              usermod -aG enjaulados nombredeusuario
            # Modificar sshhd_config
              # Primero hacer copia de seguridad
                cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak.$cFechaDeEjec
              # Agregar match de grupo
                echo "Match Group enjaulados"   > /etc/ssh/sshd_config.d/enjaulados.conf
                echo "  ChrootDirectory /home" >> /etc/ssh/sshd_config.d/enjaulados.conf
                echo "  AllowTCPForwarding no" >> /etc/ssh/sshd_config.d/enjaulados.conf
                echo "  X11Forwarding no"      >> /etc/ssh/sshd_config.d/enjaulados.conf
              # Reiniciar el servicio SSH
                service ssh restart

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

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de securización de Sistema Operativo para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de securización de Sistema Operativo para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de securización de Sistema Operativo para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de securización de Sistema Operativo para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de securización de Sistema Operativo para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
