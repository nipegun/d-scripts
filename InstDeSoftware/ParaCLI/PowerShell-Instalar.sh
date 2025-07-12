#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar PowerShell en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/PowerShell-Instalar.sh | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/PowerShell-Instalar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/PowerShell-Instalar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/PowerShell-Instalar.sh | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de PowerShell para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de PowerShell para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

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
          1 "Instalar agregando el repositorio" on
          2 "Instalar desde Github" off
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Intentando instalar PowerShell agregando el repositorio..."
              echo ""

              # Instalar el repositorio
                echo ""
                echo "  Instalando el repositorio de PowerShell..."
                echo ""
                cd /tmp/
                # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo -e "${cColorRojo}    El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                    echo ""
                    apt-get -y update
                    apt-get -y install curl
                    echo ""
                  fi
                curl -L https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -o /tmp/PowerShellRepo.deb
                apt -y install /tmp/PowerShellRepo.deb

              # Actualizar la lista de paquetes disponibles en los repositorios
                echo ""
                echo "  Actualizando la lista de paquetes disponibles en los repositorios..."
                echo ""
                apt-get -y update

              # Instalar el paquete
                echo ""
                echo "  Instalar el paquete powershell..."
                echo ""
                apt-get -y install powershell-lts

              # Notificar fin de ejecución del script
                echo ""
                echo "  Script de instalación de PowerShell, finalizado."
                echo ""
                echo "    Para ejecutar PowerShell, ejecuta:"
                echo "      pwsh"
                echo ""
                echo "    Para borrarlo:"
                echo "      apt-get -y autoremove powershell-lts"
                echo "      apt remove packages-microsoft-prod"
                echo "      apt-get update"
                echo ""

            ;;

            2)

              echo ""
              echo "  Intentando instalar PowerShell desde Github..."
              echo ""

              # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}  El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  apt-get -y update
                  apt-get -y install wget
                  echo ""
                fi

              # Determinar la última versión disponible en Github
                echo ""
                echo "  Determinando la última versión disponible en Github..."
                echo ""
                vUltVers=$(curl -sL https://github.com/PowerShell/PowerShell/releases/latest | sed 's->->\n-g' | grep deb_amd64 | grep lts | cut -d'_' -f2 | cut -d'-' -f1)

              # Obtener el nombre del archivo de instalación de la última versión
                echo ""
                echo "  Obteniendo el nombre del archivo de instalación de la última versión..."
                echo ""
                vNomArch=$(curl -sL https://github.com/PowerShell/PowerShell/releases/latest | sed 's->->\n-g' | grep deb_amd64 | grep lts)

              # Descargar el paquete de instalación
                echo ""
                echo "  Descargando el paquete de instalación..."
                echo ""
                cd /tmp/
                wget https://github.com/PowerShell/PowerShell/releases/download/v$vUltVers/$vNomArch -O /tmp/powershell.deb

              # Instalar el paquete
                echo ""
                echo "  Instalando el paquete..."
                echo ""
                apt -y install /tmp/powershell.deb

              # Notificar fin de ejecución del script
                echo ""
                echo "  Script de instalación de PowerShell, finalizado."
                echo ""
                echo "    Para ejecutar PowerShell, ejecuta:"
                echo "      pwsh"
                echo ""
                echo "    Para borrarlo:"
                echo "      apt-get -y autoremove powershell-lts"
                echo ""

            ;;

        esac

    done

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de PowerShell para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de PowerShell para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de PowerShell para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de PowerShell para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de PowerShell para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
