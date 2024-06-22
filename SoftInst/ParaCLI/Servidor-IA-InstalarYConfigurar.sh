#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar un servidor de inteligencia artificial en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-IA-InstalarYConfigurar.sh | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-IA-InstalarYConfigurar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-IA-InstalarYConfigurar.sh | bash -s Parámetro1 Parámetro2
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
  if [ $(id -u) -ne 0 ]; then
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
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

if [ $cVerSO == "13" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor de inteligencia artificial para Debian 13 (x)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor de inteligencia artificial para Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  vFechaDeEjec=$(date +a%Ym%md%d@%T)

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install dialog
      echo ""
    fi

  menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
    opciones=(
      1 "Instalar Ollama" on
      2 "Instalar llama3" off
      3 "Instalar Open WebUI" off
      4 "Opción 4" off
      5 "Opción 5" off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Instalando Ollama..."
            echo ""

            echo ""
            echo "    Bajando y ejecutando el script de instalación desde la web oficial..."
            echo ""
            # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update
                apt-get -y install curl
                echo ""
              fi
            # Comprobar si el paquete pciutils está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s pciutils 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}      El paquete pciutils no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update
                apt-get -y install pciutils
                echo ""
              fi
            # Correr el script de instalación
              curl -fsSL https://ollama.com/install.sh | sh

            # Activar e iniciar el servicio
            systemctl enable ollama --now

          ;;

          2)

            echo ""
            echo "  Instalando el modelo llama3..."
            echo ""
            # Modelo de 8.000.000.000 de parámetros
              ollama pull llama3:8b
            # Modelo de 70.000.000.000 de parámetros
              #ollama pull llama3:70b

          ;;

          3)

            echo ""
            echo "  Instalando Open WebUI..."
            echo ""
            apt-get -y install python3-venv
            python3 -m venv --system-site-packages /opt/open-webui
            /opt/open-webui/bin/pip3 install open-webui 

            # Crear el servicio
              echo ""
              echo "  Creando el servicio..."
              echo ""
              echo "[Unit]"                                          > /usr/lib/systemd/system/open-webui.service
              echo "Description=Open WebUI Service"                 >> /usr/lib/systemd/system/open-webui.service
              echo "After=network.target"                           >> /usr/lib/systemd/system/open-webui.service
              echo ""                                               >> /usr/lib/systemd/system/open-webui.service
              echo "[Service]"                                      >> /usr/lib/systemd/system/open-webui.service
              echo "Type=simple"                                    >> /usr/lib/systemd/system/open-webui.service
              echo "ExecStart=/opt/open-webui/bin/open-webui serve" >> /usr/lib/systemd/system/open-webui.service
              echo "ExecStop=/bin/kill -HUP $MAINPID"               >> /usr/lib/systemd/system/open-webui.service
              echo "User=root"                                      >> /usr/lib/systemd/system/open-webui.service
              echo "Group=root"                                     >> /usr/lib/systemd/system/open-webui.service
              echo ""                                               >> /usr/lib/systemd/system/open-webui.service
              echo "[Install]"                                      >> /usr/lib/systemd/system/open-webui.service
              echo "WantedBy=multi-user.target"                     >> /usr/lib/systemd/system/open-webui.service

            # Activar e iniciar el servicio
              echo ""
              echo "  Activando e iniciando el servicio..."
              echo ""
              systemctl daemon-reload
              systemctl enable --now open-webui.service 

            # Notificar fin de la instalación de Open WebUI
              echo ""
              echo "  Instalación de Open WebUI, finalizada."
              echo ""
              echo "    La web está disponible en: http://localhost:8080"
              echo ""
              echo "    El primer usuario en registrarse se convertirá automáticamente en el AAdministrador."
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
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor de inteligencia artificial para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor de inteligencia artificial para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor de inteligencia artificial para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor de inteligencia artificial para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor de inteligencia artificial para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

fi

