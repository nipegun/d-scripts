#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Frigate en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Frigate-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Frigate-Instalar.sh | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Frigate-Instalar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Frigate-Instalar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Frigate-Instalar.shv | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Frigate para Debian 13 (x)...${cFinColor}"
    echo ""

    sudo apt-get -y update
    sudo apt-get -y install python3
    sudo apt-get -y install python3-venv
    sudo apt-get -y install python3-pip
    sudo apt-get -y install ffmpeg
    sudo apt-get -y install libgl1
    sudo apt-get -y install libglib2.0-0
    sudo apt-get -y install mosquitto
    sudo apt-get -y install mosquitto-clients

    # Activar e iniciar mosquito
      sudo systemctl enable mosquitto --now

    # Usuario y estructura
      sudo useradd -r -s /usr/sbin/nologin frigate
      sudo mkdir -p /opt/frigate
      sudo chown frigate:frigate /opt/frigate

    # Clonar repo
      cd /opt/frigate
      git clone https://github.com/blakeblackshear/frigate.git src
      sudo chown frigate:frigate /opt/frigate

    # Crear la configuración para la primera camara
      sudo mkdir /etc/frigate
      echo 'mqtt:'                                                 | sudo tee    /etc/frigate/config.yml
      echo '  host: 127.0.0.1'                                     | sudo tee -a /etc/frigate/config.yml
      echo ''                                                      | sudo tee -a /etc/frigate/config.yml
      echo 'ffmpeg:'                                               | sudo tee -a /etc/frigate/config.yml
      echo '  path: /usr/bin/ffmpeg'                               | sudo tee -a /etc/frigate/config.yml
      echo ''                                                      | sudo tee -a /etc/frigate/config.yml
      echo 'cameras:'                                              | sudo tee -a /etc/frigate/config.yml
      echo '  g3flex:'                                             | sudo tee -a /etc/frigate/config.yml
      echo '    ffmpeg:'                                           | sudo tee -a /etc/frigate/config.yml
      echo '      inputs:'                                         | sudo tee -a /etc/frigate/config.yml
      echo '        - path: rtsp://ubnt:ubnt@192.168.1.105:554/s0' | sudo tee -a /etc/frigate/config.yml
      echo '          roles:'                                      | sudo tee -a /etc/frigate/config.yml
      echo '            - detect'                                  | sudo tee -a /etc/frigate/config.yml
      echo '            - record'                                  | sudo tee -a /etc/frigate/config.yml
      echo '    detect:'                                           | sudo tee -a /etc/frigate/config.yml
      echo '      width: 1920'                                     | sudo tee -a /etc/frigate/config.yml
      echo '      height: 1080'                                    | sudo tee -a /etc/frigate/config.yml
      echo '      fps: 5'                                          | sudo tee -a /etc/frigate/config.yml

mkdir -p /config
cp -v /etc/frigate/config.yml /config/config.yml
cp -v /opt/frigate/src/labelmap.txt /labelmap.txt
sudo chown frigate:frigate /config -Rv

        # Crear módulo onvif falso
          echo 'class ONVIFError(Exception):'             | sudo tee    /opt/frigate/src/onvif.py
          echo '  pass'                                   | sudo tee -a /opt/frigate/src/onvif.py
          echo ''                                         | sudo tee -a /opt/frigate/src/onvif.py
          echo 'class ONVIFService:'                      | sudo tee -a /opt/frigate/src/onvif.py
          echo '  def __init__(self, *args, **kwargs):'   | sudo tee -a /opt/frigate/src/onvif.py
          echo '    raise RuntimeError("ONVIF disabled")' | sudo tee -a /opt/frigate/src/onvif.py
          echo ''                                         | sudo tee -a /opt/frigate/src/onvif.py
          echo 'class ONVIFCamera:'                       | sudo tee -a /opt/frigate/src/onvif.py
          echo '  def __init__(self, *args, **kwargs):'   | sudo tee -a /opt/frigate/src/onvif.py
          echo '    raise RuntimeError("ONVIF disabled")' | sudo tee -a /opt/frigate/src/onvif.py

        sudo echo 'VERSION = "manual"' > /opt/frigate/src/frigate/version.py

sudo chown frigate:frigate /opt/frigate -Rv

    # Crear el entorno virtual e instalar dentro
      su -s /bin/bash frigate
      cd /opt/frigate
      python3 -m venv venv
      source venv/bin/activate
        pip install psutil
        pip install uvicorn
        pip install peewee_migrate
        pip install fastapi
        pip install joserfc
        pip install slowapi
        pip install requests
        pip install opencv-python-headless
        pip install py3nvml

        pip install unidecode
        pip install starlette_context
        pip install aiofiles
        pip install zmq
        pip install prometheus_client
        pip install pytz
        pip install tzlocal
        pip install httpx
        pip install tensorflow
        pip install onnxruntime
        pip install openvino
        pip install zeep
        pip install pathvalidate
        pip install regex
        pip install sherpa_onnx
        pip install librosa
        pip install setproctitle
        pip install pyclipper
        pip install rapidfuzz
        pip install shapely
        pip install titlecase
        pip install transformers
        pip install python-multipart
        pip install norfair
        pip install py_vapid
        pip install pywebpush
        pip install pandas
        pip install paho-mqtt
        pip install ws4py
        pip install ruamel.yaml


cd /opt/frigate/src
python3 -m frigate.app





















PYTHONPATH=/opt/frigate/src FRIGATE_CONFIG_FILE=/etc/frigate/config.yml /opt/frigate/venv/bin/python3 -m frigate.app



  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Frigate para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Frigate para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Frigate para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Frigate para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Frigate para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Frigate para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
