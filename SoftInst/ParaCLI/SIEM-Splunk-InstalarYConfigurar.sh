#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar splunk en Debian
#
# Ejecución remota (puede requierir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/SIEM-Splunk-InstalarYConfigurar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/SIEM-Splunk-InstalarYConfigurar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/SIEM-Splunk-InstalarYConfigurar.sh | nano -
# ----------

vSplunk="9.4.1"
vComp="e3bdab203ac8"

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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de splunk para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de splunk para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Definir fecha de ejecución del script
      cFechaDeEjec=$(date +a%Ym%md%d@%T)

    # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        apt-get -y update
        apt-get -y install dialog
        echo ""
      fi

    # Crear el menú
      menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
        opciones=(
          1 "Instalar Splunk Enterprise v"$vSplunk" Trial" on
          2 "Splunk Universal Forwarder v"$vSplunk" amd64" off
          3 "Splunk Universal Forwarder v"$vSplunk" arm" off
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Instalando Splunk enterprise v$vSplunk Free Trial..."
              echo ""
              mkdir -p /root/SoftInst/Splunk
              # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  apt-get -y update
                  apt-get -y install curl
                  echo ""
                fi
              wget "https://download.splunk.com/products/splunk/releases/"$vSplunk"/linux/splunk-"$vSplunk"-"$vComp"-linux-amd64.deb" -O /root/SoftInst/Splunk/splunk.deb
              apt -y install /root/SoftInst/Splunk/splunk.deb
              # Iniciar y aceptar licencia
                /opt/splunk/bin/splunk start --accept-license
              # Hacer que se auto-inicie
                /opt/splunk/bin/splunk enable boot-start
              # Permitir que la web se acceda desde cualquier IP
                #echo ""                             >> /opt/splunk/etc/system/local/web.conf
                #echo "[settings]"                   >> /opt/splunk/etc/system/local/web.conf
                #echo "server.socket_host = 0.0.0.0" >> /opt/splunk/etc/system/local/web.conf
                #echo ""                             >> /opt/splunk/etc/system/local/web.conf
              # Reiniciar
                #/opt/splunk/bin/splunk restart

              # Notificar fin de la instalación
                echo ""
                echo "  La instalación ha finalizado."
                echo "    La web de Splunk está accesible en el puerto 8000."
                echo ""
                echo "    Para configurar la escucha:"
                echo "      Acceder a la interfaz web y loguearse con la cuenta creada."
                echo '      Luego ir a "Settings" >> "Add Data" >> "Forwarding and receiving".'
                echo '      En "Configure receiving" hacer click en "Add new".'
                echo '      Indicad, por ejemplo, el puerto 9997 y Salvar.'
                echo ''

            ;;

            2)

              echo ""
              echo "  Splunk Universal Forwarder v$vSplunk (amd64)..."
              echo ""
              wget -O splunkforwarder-"$vSplunk"-"$vComp"-linux-amd64.deb "https://download.splunk.com/products/universalforwarder/releases/"$vSplunk"/linux/splunkforwarder-"$vSplunk"-"$vComp"-linux-amd64.deb"

           ;;

            3)

              echo ""
              echo "  Splunk Universal Forwarder v$vSplunk (ARM)..."
              echo ""
              wget -O splunkforwarder-"$vSplunk"-"$vComp"-Linux-armv8.deb "https://download.splunk.com/products/universalforwarder/releases/"$vSplunk"/linux/splunkforwarder-"$vSplunk"-"$vComp"-Linux-armv8.deb"

           ;;

        esac

    done

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de splunk para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de splunk para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de splunk para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de splunk para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de splunk para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi

echo ""
echo "  Instalación finalizada."
echo ""
echo "    Más info y documentación aquí: https://docs.splunk.com/Documentation/Splunk"
echo ""

