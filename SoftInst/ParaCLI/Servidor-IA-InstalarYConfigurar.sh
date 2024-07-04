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
      2 "Instalar Open WebUI" on
      3 "Instalar modelos LLM para Ollama" on
      4 "Instalar TextGeneration WebUI" off
      5 "Instalar modelos LLM para TextGeneration WebUI" off
      6 "Instalar LMStudio" off
      7 "Instalar modelos LLM para LMStudio" off
      8 "Instalar AnythingLLM" off
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
              echo "    El primer usuario en registrarse se convertirá automáticamente en el Administrador."
              echo ""

          ;;

          3)

            echo ""
            echo "  Instalando modelos LLM para Ollama..."
            echo ""
            # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}    El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update
                apt-get -y install curl
                echo ""
              fi
            curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Ollama-ModelosLLM-Instalar.sh | bash

          ;;

          4)

            echo ""
            echo "  Instalando TextGeneration WebUI..."
            echo ""

            # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}    El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update && apt-get -y install wget
                echo ""
              fi

            # Comprobar si hay conexión a Internet antes de sincronizar los d-scripts
              wget -q --tries=10 --timeout=20 --spider https://github.com
              if [[ $? -eq 0 ]]; then
                # Borrar carpeta vieja
                  rm /root/SoftInst/text-generation-webui -R 2> /dev/null
                  mkdir /root/SoftInst/ 2> /dev/null
                  cd /root/SoftInst/
                # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo -e "${cColorRojo}    El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
                    echo ""
                    apt-get -y update && apt-get -y install git
                    echo ""
                  fi
                git clone --depth=1 https://github.com/oobabooga/text-generation-webui
                rm /root/SoftInst/text-generation-webui/.git -R 2> /dev/null
                find /root/SoftInst/text-generation-webui/ -type f -iname "*.sh" -exec chmod +x {} \;
                mv /root/SoftInst/text-generation-webui/ /opt
              fi

            # Instalar ROCm SDK 5.6 (Para tarjetas AMD a partir de Radeon RX 6800 XT)

            # Instalar el paquete
              chmod +x /opt/text-generation-webui/start_linux.sh
              /opt/text-generation-webui/start_linux.sh

            # Crear el servicio
              echo ""
              echo "  Creando el servicio..."
              echo ""
              echo "[Unit]"                                                        > /usr/lib/systemd/system/text-generation-webui.service
              echo "Description=TextGeneration WebUI Service"                     >> /usr/lib/systemd/system/text-generation-webui.service
              echo "After=network.target"                                         >> /usr/lib/systemd/system/text-generation-webui.service
              echo ""                                                             >> /usr/lib/systemd/system/text-generation-webui.service
              echo "[Service]"                                                    >> /usr/lib/systemd/system/text-generation-webui.service
              echo "Type=simple"                                                  >> /usr/lib/systemd/system/text-generation-webui.service
              echo "ExecStart=/opt/text-generation-webui/start_linux.sh --listen" >> /usr/lib/systemd/system/text-generation-webui.service
              echo "ExecStop=/bin/kill -HUP $MAINPID"                             >> /usr/lib/systemd/system/text-generation-webui.service
              echo "User=root"                                                    >> /usr/lib/systemd/system/text-generation-webui.service
              echo "Group=root"                                                   >> /usr/lib/systemd/system/text-generation-webui.service
              echo ""                                                             >> /usr/lib/systemd/system/text-generation-webui.service
              echo "[Install]"                                                    >> /usr/lib/systemd/system/text-generation-webui.service
              echo "WantedBy=multi-user.target"                                   >> /usr/lib/systemd/system/text-generation-webui.service

            # Activar e iniciar el servicio
              echo ""
              echo "  Activando e iniciando el servicio..."
              echo ""
              systemctl daemon-reload

            # Notificar fin de la instalación
              echo ""
              echo "  Instalación de TextGeneration WebUI, finalizada."
              echo ""
              echo "    Auto-ejecutando..."
              echo "      Para salir, presiona Ctrl+c"
              echo ""
              echo "    Para volver a iniciar, ejecuta:"
              echo "      /opt/text-generation-webui/start_linux.sh"
              echo ""
              echo "    Si quieres que se escuche en todas las IPs (no sólo en localhost), ejecuta:"
              echo "      /opt/text-generation-webui/start_linux.sh --listen"
              echo ""
              echo "    Para actualizar TextGeneration WebUI, ejecuta:"
              echo "      /root/SoftInst/text-generation-webui/update_wizard_linux.sh"
              echo ""
              echo "    Se ha creado el servicio. Para activarlo, ejecuta:"
              echo "      systemctl enable --now text-generation-webui.service"
              echo ""

          ;;

          5)

            echo ""
            echo "  Instalando modelos LLM para TextGeneration WebUI..."
            echo ""
            #Use the download-model.py script to automatically download a model from Hugging Face.

          ;;

          6)

            echo ""
            echo "  Instalando LM Studio.."
            echo ""
            # Obtener el enlace de descarga
              #vEnlace=$(curl -sL )
              vEnlace="https://releases.lmstudio.ai/linux/x86/0.2.27/beta/LM_Studio-0.2.27.AppImage"
            echo ""
            echo "    Descargando paquete AppImage..."
            echo ""
            curl -L -o /tmp/LMStudio.AppImage $vEnlace
            chmod +x /tmp/LMStudio.AppImage
            mkdir -p /home/$vUsuarioNoRoot/IA/LMStudio
            mv /tmp/LMStudio.AppImage /home/$vUsuarioNoRoot/IA/LMStudio
            chown $vUsuarioNoRoot:$vUsuarioNoRoot /home/$vUsuarioNoRoot/IA/ -R

          ;;

          7)

            echo ""
            echo "  Instalando modelos LLM para LMStudio.."
            echo ""
            curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/LMStudio-ModelosLLM-Instalar.sh | bash

          ;;

          8)

            echo ""
            echo "  Instalando AnythingLLM.."
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

