#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar JupyterLab en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ServWeb/JupyterLab-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ServWeb/JupyterLab-Instalar.sh | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ServWeb/JupyterLab-Instalar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ServWeb/JupyterLab-Instalar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ServWeb/JupyterLab-Instalar.sh | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de JupyterLab para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de JupyterLab para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Crear el usuario para ejecutar jupyterlab
      echo ""
      echo "    Creando el usuario para ejecutar JupyterLab..."
      echo ""
      sudo adduser jupyterlab --system --home /opt/JupyterLab

    # Crear el entorno virtual
      echo ""
      echo "  Creando el entorno virtual de python..."
      echo ""
      cd /opt/JupyterLab/
      # Comprobar si el paquete python3-venv está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s python3-venv 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete python3-venv no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install python3-venv
          echo ""
        fi
      sudo python3 -m venv PythonVirtualEnvironment
      # Crear el mensaje para mostrar cuando se entra al entorno virtual
        echo 'echo -e "\n  Activando el entorno virtual de JupyterLab... \n"' | sudo tee -a /opt/JupyterLab/PythonVirtualEnvironment/bin/activate

    # Entrar al entorno virtual e instalar dentro
      echo ""
      echo "  Entrando al entorno virtual e instalando dentro..."
      echo ""
      # Corregir permisos
        sudo chown jupyterlab /opt/JupyterLab/ -R
      # Asignar shell a jupyterlab
        sudo chsh -s /bin/bash jupyterlab
      # Entrar al entorno virtual
        sudo su jupyterlab -c '\
        source /opt/JupyterLab/PythonVirtualEnvironment/bin/activate && \
        python3 -m pip install jupyterlab                            && \
        python3 -m pip install jupyterlab-language-pack-es-ES        && \
        python3 -m pip install notebook                              && \
        echo ""                                                      && \
        echo "    Crea una contraseña para Jupyter notebook:"        && \
        echo ""                                                      && \
        jupyter notebook password                                    && \
        python3 -m pip install voila                                 && \
        deactivate                                                      \
        '
      # Poner en español
        sudo mkdir -p /opt/JupyterLab/'.jupyter/lab/user-settings/@jupyterlab/translation-extension/'
        echo '{'                   | sudo tee -a /opt/JupyterLab/'.jupyter/lab/user-settings/@jupyterlab/translation-extension/plugin.jupyterlab-settings'
        echo '  "locale": "es_ES"' | sudo tee -a /opt/JupyterLab/'.jupyter/lab/user-settings/@jupyterlab/translation-extension/plugin.jupyterlab-settings'
        echo '}'                   | sudo tee -a /opt/JupyterLab'/.jupyter/lab/user-settings/@jupyterlab/translation-extension/plugin.jupyterlab-settings'
        sudo chown jupyterlab /opt/JupyterLab/ -R

      # Crear el archivo para ejecutar
        echo ""
        echo "    Creando el archivo para ejecutar..."
        echo ""
        echo '#!/bin/bash'                                                  | sudo tee    /opt/JupyterLab/JupyterLab.sh
        echo ''                                                             | sudo tee -a /opt/JupyterLab/JupyterLab.sh
        echo 'source /opt/JupyterLab/PythonVirtualEnvironment/bin/activate' | sudo tee -a /opt/JupyterLab/JupyterLab.sh
        echo '  jupyter lab --ip=0.0.0.0 --no-browser'                      | sudo tee -a /opt/JupyterLab/JupyterLab.sh
        echo 'deactivate'                                                   | sudo tee -a /opt/JupyterLab/JupyterLab.sh
        sudo chmod +x /opt/JupyterLab/JupyterLab.sh
        sudo chown jupyterlab /opt/JupyterLab/JupyterLab.sh

      # Notificar creación del entorno virtual
        echo ""
        echo -e "${cColorVerde}    Entorno virtual preparado. JubypterLab se puede iniciar de la siguiente forma:${cFinColor}"
        echo ""
        echo -e "${cColorVerde}      source /opt/JupyterLab/PythonVirtualEnvironments/bin/activate${cFinColor}"
        echo ""
        echo -e "${cColorVerde}        jupyter lab --ip=0.0.0.0 --no-browser${cFinColor}" # Esto hará que JupyterLab escuche en todas las IPs (LAN, WiFi, etc.) y no intente abrir un navegador local.
        echo ""
        echo -e "${cColorVerde}      deactivate${cFinColor}"
        echo ""

⚠️ Si no quieres que el usuario mantenga ese shell, puedes volver a desactivarlo con:

sudo chsh -s /usr/sbin/nologin jupyterlab

    # Crear el entorno virtual
      echo ""
      echo "  Creando el entorno virtual de python..."
      echo ""
      mkdir -p "$HOME"/PythonVirtualEnvironments/
      cd "$HOME"/PythonVirtualEnvironments/
      # Comprobar si el paquete python3-venv está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s python3-venv 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete python3-venv no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install python3-venv
          echo ""
        fi
      python3 -m venv JupyterLab
      # Crear el mensaje para mostrar cuando se entra al entorno virtual
        echo 'echo -e "\n  Activando el entorno virtual de JupyterLab... \n"' >> "$HOME"/PythonVirtualEnvironments/JupyterLab/bin/activate

    # Entrar al entorno virtual e instalar dentro
      echo ""
      echo "  Entrando al entorno virtual e instalando dentro..."
      echo ""
      # Entrar al entorno virtual
        source "$HOME"/PythonVirtualEnvironments/JupyterLab/bin/activate
      # Instalar jupyterlab
        python3 -m pip install jupyterlab
        #jupyter lab --generate-config
        #nano ~/.jupyter/jupyter_lab_config.py
      # Poner en español
        pip install jupyterlab-language-pack-es-ES
        mkdir -p "$HOME"/'.jupyter/lab/user-settings/@jupyterlab/translation-extension/'
        echo '{'                   | sudo tee -a "$HOME"/'.jupyter/lab/user-settings/@jupyterlab/translation-extension/plugin.jupyterlab-settings'
        echo '  "locale": "es_ES"' | sudo tee -a "$HOME"/'.jupyter/lab/user-settings/@jupyterlab/translation-extension/plugin.jupyterlab-settings'
        echo '}'                   | sudo tee -a "$HOME"'/.jupyter/lab/user-settings/@jupyterlab/translation-extension/plugin.jupyterlab-settings'
        sudo chown $USER:$USER "$HOME"'/.jupyter/' -R
      # Instalar notebook
        python3 -m pip install notebook
        echo ""
        echo "    Crea una contraseña para Jupyter notebook:"
        echo ""
        jupyter notebook password
      # Instalar voilá
        python3 -m pip install voila
      # Salir del entorno virtual
        deactivate

      # Notificar creación del entorno virtual
        echo ""
        echo -e "${cColorVerde}    Entorno virtual preparado. JubypterLab se puede iniciar de la siguiente forma:${cFinColor}"
        echo ""
        echo -e "${cColorVerde}      source "$HOME"/PythonVirtualEnvironments/JupyterLab/bin/activate${cFinColor}"
        echo ""
        echo -e "${cColorVerde}        jupyter lab --ip=0.0.0.0 --no-browser${cFinColor}" # Esto hará que JupyterLab escuche en todas las IPs (LAN, WiFi, etc.) y no intente abrir un navegador local.
        echo ""
        echo -e "${cColorVerde}      deactivate${cFinColor}"
        echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de JupyterLab para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de JupyterLab para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de JupyterLab para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de JupyterLab para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de JupyterLab para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi

