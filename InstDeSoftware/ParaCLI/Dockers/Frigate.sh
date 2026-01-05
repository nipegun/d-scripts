#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar Frigate en el DockerCE de Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Dockers/Frigate.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Dockers/Frigate.sh | sed 's-sudo--g' | bash
#
# Comando: docker run -d --restart=always --name Frigate -p 9392:9392 -p 5432:5432 -e "USERNAME=admin" -e "PASSWORD=admin"  greenbone/openvas-scanner:latest
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OpenVAS en el DockerCE de Debian...${cFinColor}"
  echo ""

# Crear el menú
  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo "   "
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install dialog
      echo ""
    fi
  menu=(dialog --radiolist "¿Donde quieres instalar Frigate?:" 22 76 16)
    opciones=(
      1 "En un ordenador o máquina virtual" off
      2 "En un contenedor LXC de Proxmox"   off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

      1)

        echo ""
        echo -e "${cColorVerde}  Instalando Frigate en un ordenador o máquina virtual...${cFinColor}"
        echo ""

        # Crear carpetas
          sudo mkdir -p /Contenedores/Frigate/config   2> /dev/null
          sudo mkdir -p /Contenedores/Frigate/storage  2> /dev/null
          sudo mkdir -p /root/scripts/ParaEsteDebian/  2> /dev/null

        # Crear config mínima (si no existe)
          if [[ ! -f /Contenedores/Frigate/config/config.yml ]]; then
            echo ""
            echo "    Creando config.yml mínima..."
            echo ""
            echo "mqtt:"                                                 | sudo tee    /Contenedores/Frigate/config/config.yml
            echo "  enabled: False"                                      | sudo tee -a /Contenedores/Frigate/config/config.yml
            echo "cameras:"                                              | sudo tee -a /Contenedores/Frigate/config/config.yml
            echo "  dummy_camera:"                                       | sudo tee -a /Contenedores/Frigate/config/config.yml
            echo "    enabled: False"                                    | sudo tee -a /Contenedores/Frigate/config/config.yml
            echo "    ffmpeg:"                                           | sudo tee -a /Contenedores/Frigate/config/config.yml
            echo "      inputs:"                                         | sudo tee -a /Contenedores/Frigate/config/config.yml
            echo "        - path: rtsp://127.0.0.1:554/rtsp"             | sudo tee -a /Contenedores/Frigate/config/config.yml
            echo "          roles:"                                      | sudo tee -a /Contenedores/Frigate/config/config.yml
            echo "            - detect"                                  | sudo tee -a /Contenedores/Frigate/config/config.yml
            echo "  cam_192_168_1_105:"                                  | sudo tee -a /Contenedores/Frigate/config/config.yml
            echo "    ffmpeg:"                                           | sudo tee -a /Contenedores/Frigate/config/config.yml
            echo "      inputs:"                                         | sudo tee -a /Contenedores/Frigate/config/config.yml
            echo "        - path: rtsp://ubnt:ubnt@192.168.1.105:554/s0" | sudo tee -a /Contenedores/Frigate/config/config.yml
            echo "          roles:"                                      | sudo tee -a /Contenedores/Frigate/config/config.yml
            echo "            - detect"                                  | sudo tee -a /Contenedores/Frigate/config/config.yml
            echo "            - record"                                  | sudo tee -a /Contenedores/Frigate/config/config.yml
            echo "    record:"                                           | sudo tee -a /Contenedores/Frigate/config/config.yml
            echo "      enabled: True"                                   | sudo tee -a /Contenedores/Frigate/config/config.yml
            echo "      retain:"                                         | sudo tee -a /Contenedores/Frigate/config/config.yml
            echo "        days: 3"                                       | sudo tee -a /Contenedores/Frigate/config/config.yml
            echo "        mode: motion"                                  | sudo tee -a /Contenedores/Frigate/config/config.yml
          else
            echo ""
            echo "    Ya existe /Contenedores/Frigate/config/config.yml (no lo modifico)."
            echo ""
          fi

            echo "mqtt:"
            echo "  enabled: False"
            echo ""
            echo "cameras:"



        # Crear el script iniciador
          echo ""
          echo "    Creando el script iniciador..."
          echo ""
          echo '#!/bin/bash'                                                                      | sudo tee    /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh
          echo ""                                                                                 | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh
          echo "docker rm -f frigate 2>/dev/null"                                                 | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh
          echo "docker run -d                                                                 \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh
          echo "  --name frigate                                                              \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh
          echo "  --restart=unless-stopped                                                    \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh
          echo "  --stop-timeout 30                                                           \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh
          echo "  --mount type=tmpfs,target=/tmp/cache,tmpfs-size=1000000000                  \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh
          echo "  --device /dev/bus/usb:/dev/bus/usb                                          \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh
          echo "  --device /dev/dri/renderD128                                                \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh
          echo "  --shm-size=64m                                                              \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh
          echo "  -v /Contenedores/Frigate/storage:/media/frigate                             \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh
          echo "  -v /Contenedores/Frigate/config:/config                                     \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh
          echo "  -v /etc/localtime:/etc/localtime:ro                                         \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh
          echo "  -e FRIGATE_RTSP_PASSWORD='password'                                         \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh
          echo "  -p 8971:8971                                                                \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh
          echo "  -p 8554:8554                                                                \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh
          echo "  -p 8555:8555/tcp                                                            \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh
          echo "  -p 8555:8555/udp                                                            \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh
          echo "  ghcr.io/blakeblackshear/frigate:stable"                                         | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh
          sudo chmod +x /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh


        # Insertar el script iniciador en los comandos post arranque
          echo ""
          echo "    Insertando el script iniciador en los ComandosPostArranque..."
          echo ""
          echo "/root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh" | sudo tee -a /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

        # Iniciar el docker por primera vez
          echo ""
          echo "    Iniciando el container por primera vez..."
          echo ""
          sudo /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh

        # Notificar fin de ejecución del script
          echo ""
          echo "  Script de instalación del Docker de Frigate, finalizado."
          echo ""

      ;;

      2)

        echo ""
        echo -e "${cColorVerde}  Instalando Frigate en un contenedor LXC...${cFinColor}"
        echo ""

        # Crear carpetas
          sudo mkdir -p /Host/Frigate/config   2> /dev/null
          sudo mkdir -p /Host/Frigate/storage  2> /dev/null
          sudo mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null

        # Crear config mínima (si no existe)
          if [[ ! -f /Contenedores/Frigate/config/config.yml ]]; then
            echo ""
            echo "    Creando config.yml mínima..."
            echo ""
            echo "mqtt:"                                                 | sudo tee    /Host/Frigate/config/config.yml
            echo "  enabled: False"                                      | sudo tee -a /Host/Frigate/config/config.yml
            echo "cameras:"                                              | sudo tee -a /Host/Frigate/config/config.yml
            echo "  dummy_camera:"                                       | sudo tee -a /Host/Frigate/config/config.yml
            echo "    enabled: False"                                    | sudo tee -a /Host/Frigate/config/config.yml
            echo "    ffmpeg:"                                           | sudo tee -a /Host/Frigate/config/config.yml
            echo "      inputs:"                                         | sudo tee -a /Host/Frigate/config/config.yml
            echo "        - path: rtsp://127.0.0.1:554/rtsp"             | sudo tee -a /Host/Frigate/config/config.yml
            echo "          roles:"                                      | sudo tee -a /Host/Frigate/config/config.yml
            echo "            - detect"                                  | sudo tee -a /Host/Frigate/config/config.yml
            echo "  cam_192_168_1_105:"                                  | sudo tee -a /Host/Frigate/config/config.yml
            echo "    ffmpeg:"                                           | sudo tee -a /Host/Frigate/config/config.yml
            echo "      inputs:"                                         | sudo tee -a /Host/Frigate/config/config.yml
            echo "        - path: rtsp://ubnt:ubnt@192.168.1.105:554/s0" | sudo tee -a /Host/Frigate/config/config.yml
            echo "          roles:"                                      | sudo tee -a /Host/Frigate/config/config.yml
            echo "            - detect"                                  | sudo tee -a /Host/Frigate/config/config.yml
            echo "            - record"                                  | sudo tee -a /Host/Frigate/config/config.yml
            echo "    record:"                                           | sudo tee -a /Host/Frigate/config/config.yml
            echo "      enabled: True"                                   | sudo tee -a /Host/Frigate/config/config.yml
            echo "      retain:"                                         | sudo tee -a /Host/Frigate/config/config.yml
            echo "        days: 3"                                       | sudo tee -a /Host/Frigate/config/config.yml
            echo "        mode: motion"                                  | sudo tee -a /Host/Frigate/config/config.yml
          else
            echo ""
            echo "    Ya existe /Contenedores/Frigate/config/config.yml (no lo modifico)."
            echo ""
          fi
        
          if [[ ! -f /Host/Frigate/config/config.yml ]]; then
            echo ""
            echo "    Creando config.yml mínima..."
            echo ""
            echo "mqtt:"                                     | sudo tee    /Host/Frigate/config/config.yml >/dev/null
            echo "  enabled: False"                          | sudo tee -a /Host/Frigate/config/config.yml >/dev/null
            echo ""                                          | sudo tee -a /Host/Frigate/config/config.yml >/dev/null
            echo "cameras:"                                  | sudo tee -a /Host/Frigate/config/config.yml >/dev/null
            echo "  dummy_camera:"                           | sudo tee -a /Host/Frigate/config/config.yml >/dev/null
            echo "    enabled: False"                        | sudo tee -a /Host/Frigate/config/config.yml >/dev/null
            echo "    ffmpeg:"                               | sudo tee -a /Host/Frigate/config/config.yml >/dev/null
            echo "      inputs:"                             | sudo tee -a /Host/Frigate/config/config.yml >/dev/null
            echo "        - path: rtsp://127.0.0.1:554/rtsp" | sudo tee -a /Host/Frigate/config/config.yml >/dev/null
            echo "          roles:"                          | sudo tee -a /Host/Frigate/config/config.yml >/dev/null
            echo "            - detect"                      | sudo tee -a /Host/Frigate/config/config.yml >/dev/null
          fi

        # Crear el script iniciador
          echo ""
          echo "    Creando el script iniciador..."
          echo ""
          echo '#!/bin/bash'                                                     | sudo tee    /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh >/dev/null
          echo ""                                                                | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh >/dev/null
          echo "docker rm -f frigate 2>/dev/null"                                | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh >/dev/null
          echo "docker run -d                                                \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh >/dev/null
          echo "  --name frigate                                             \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh >/dev/null
          echo "  --restart=unless-stopped                                   \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh >/dev/null
          echo "  --stop-timeout 30                                          \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh >/dev/null
          echo "  --mount type=tmpfs,target=/tmp/cache,tmpfs-size=1000000000 \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh >/dev/null
          echo "  --device /dev/bus/usb:/dev/bus/usb                         \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh >/dev/null
          echo "  --device /dev/dri/renderD128                               \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh >/dev/null
          echo "  --shm-size=64m                                             \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh >/dev/null
          echo "  -v /Host/Frigate/storage:/media/frigate                    \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh >/dev/null
          echo "  -v /Host/Frigate/config:/config                            \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh >/dev/null
          echo "  -v /etc/localtime:/etc/localtime:ro                        \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh >/dev/null
          echo "  -e FRIGATE_RTSP_PASSWORD='password'                        \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh >/dev/null
          echo "  -p 8971:8971                                               \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh >/dev/null
          echo "  -p 8554:8554                                               \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh >/dev/null
          echo "  -p 8555:8555/tcp                                           \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh >/dev/null
          echo "  -p 8555:8555/udp                                           \\" | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh >/dev/null
          echo "  ghcr.io/blakeblackshear/frigate:stable"                        | sudo tee -a /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh >/dev/null
          sudo chmod +x /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh


        # Insertar el script iniciador en los comandos post arranque
          echo ""
          echo "    Insertando el script iniciador en los ComandosPostArranque..."
          echo ""
          echo "/root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh" | sudo tee -a /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

        # Iniciar el docker por primera vez
          echo ""
          echo "    Iniciando el container por primera vez..."
          echo ""
          sudo /root/scripts/ParaEsteDebian/DockerCE-Cont-Frigate-Iniciar.sh

        # Notificar fin de ejecución del script
          echo ""
          echo "  Script de instalación del Docker de Frigate, finalizado."
          echo ""

      ;;

    esac

  done
