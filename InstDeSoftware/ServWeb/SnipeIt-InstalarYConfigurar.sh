#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar snipe-it en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/SnipeIt-InstalarYConfigurar.sh | bash -s "snipeit.dominio.com"
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/SnipeIt-InstalarYConfigurar.sh | nano -
# ----------

vFQDN="${1:-snipeit.dominio.com}"

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de snipe-it para Debian 13 (x)...${cFinColor}"
    echo ""

    # Obtener el tag de la última release del repo de Github
      echo ""
      echo "    Obteniendo el tag de la última release del repo de Github..."
      echo ""
      # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install curl
          echo ""
        fi
      # Comprobar si el paquete jq está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s jq 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete jq no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install jq
          echo ""
        fi
      vTagUltRelGithub=$(curl -s https://api.github.com/repos/grokability/snipe-it/releases/latest | jq -r '.tag_name')
      echo "      El tag de la última release es $vTagUltRelGithub"
      echo ""

    # Descargar el archivo
      echo ""
      echo "    Descargando el archivo comprimido..."
      echo ""
      curl -L https://github.com/grokability/snipe-it/archive/refs/tags/"$vTagUltRelGithub".tar.gz -o /tmp/snipeit.tar.gz

    # Descargar el archivo
      echo ""
      echo "    Descomprimiendo el código..."
      echo ""
      tar -xvzf /tmp/snipeit.tar.gz -C /tmp/
      # Mover a nueva carpeta
        vNumVers=$(echo $vTagUltRelGithub | cut -d'v' -f2)
        mv -f "/tmp/snipe-it-$vNumVers/" "/tmp/SnipeItSource/"

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de snipe-it para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Definir fecha de ejecución del script
      cFechaDeEjec=$(date +a%Ym%md%d@%T)

    # Crear el menú
      # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install dialog
          echo ""
        fi
      menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 80 16)
        opciones=(
          1 "Instalar con configuración básica"    on
          2 "Traducir a español de España"         on
          3 "Modificar timezone a Europa/Madrid"   on
          4 "Redirigir a https"                    off
          5 "Instalar certificados de letsencrypt" off
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      #clear

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Instalando con configuración básica..."
              echo ""

              # Comprobar si el paquete sudo está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s sudo 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}      El paquete sudo  no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  apt-get -y update
                  apt-get -y install sudo
                  echo ""
                fi

              # Descargar el script oficial de instalación
                echo ""
                echo "    Descargando el script oficial de instalación..."
                echo ""
                cd /tmp/
                # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo -e "${cColorRojo}      El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
                    echo ""
                    sudo apt-get -y update
                    sudo apt-get -y install wget
                    echo ""
                  fi
                wget https://raw.githubusercontent.com/grokability/snipe-it/master/install.sh

              # Ejecutar script oficial de instalación
                chmod 744 install.sh
                # Comprobar si el paquete lsb-release está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s lsb-release 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo -e "${cColorRojo}      El paquete lsb-release no está instalado. Iniciando su instalación...${cFinColor}"
                    echo ""
                    sudo apt-get -y update
                    sudo apt-get -y install lsb-release
                    echo ""
                  fi
                # Lanzar el instalador respondiendo a la primera pregunta con el fqdn, a la segunda con "y" y a la tercera con "n"
                  printf "%s\ny\nn\n" "$vFQDN" | sudo ./install.sh

              # Notificar fin de ejecución del script
                echo ""
                echo "  Script de instalación de snipe-it, finalizado."
                echo ""
                echo "    SnipeIt se instaló con el FQDN $vFQDN. Para cambiarlo modifica los archivos:"
                echo ""
                echo "      /etc/apache2/sites-available/snipeit.conf"
                echo "      /etc/hosts"
                echo ""
                echo "    y luego reinicia el servicio con:"
                echo ""
                echo "      systemctl restart snipeit"
                echo ""
                echo "    Para configurar el servidor de correo:"
                echo ""

            ;;

            2)

              echo ""
              echo "  Traduciendo a español de España..."
              echo ""
              sudo sed -i "s|APP_LOCALE='en-US'|APP_LOCALE='es-ES'|g" /var/www/html/snipeit/.env

            ;;

            3)

              echo ""
              echo "  Modificando timezone a Europa/Madrid..."
              echo ""
              sudo sed -i 's|APP_TIMEZONE=Etc/UTC|APP_TIMEZONE=Europe/Madrid|g' /var/www/html/snipeit/.env

            ;;

            4)

              echo ""
              echo "  Redirigiendo a https..."
              echo ""

            ;;

            5)

              echo ""
              echo "  Instalando certificados de letsencrypt..."
              echo ""

            ;;

        esac

    done

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de snipe-it para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de snipe-it para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de snipe-it para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de snipe-it para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de snipe-it para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
