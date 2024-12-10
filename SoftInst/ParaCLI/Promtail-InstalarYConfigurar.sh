#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar Promtail en Debian
#
# Ejecución remota
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Promtail-InstalarYConfigurar.sh | bash
# ----------

vIPServLoki=xxx.xxx.xxx.xxx

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

if [ $cVerSO == "13" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Promtail para Debian 13 (x)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 13 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Promtail para Debian 12 (Bullseye)..."  
  echo ""

  # Actualizar la lista de paquetes disponibles en los repositorios
    apt-get -y update

  # Determinar la última versión de promtail
    echo ""
    echo "    Determinando la última versión de Promtail disponible en github"
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
    vUltVersPromtailGitHub=$(curl -sL https://github.com/grafana/loki/releases/latest/ | grep -oP 'href="/grafana/loki/releases/tag/\K[^"]+' | head -n1 | cut -d'v' -f2)
    echo "  La última versión es la $vUltVersPromtailGitHub"
    echo ""

  # Descargar el paquete con la última versión
    echo ""
    echo "    Descargando el paquete con la última versión..."
    echo ""
    mkdir -p /root/SoftInst/Promtail/
    curl -L https://github.com/grafana/loki/releases/download/v$vUltVersPromtailGitHub/promtail-linux-amd64.zip -o /root/SoftInst/Promtail/promtail.zip

  # Descomprimir el paquete
    echo ""
    echo "    Descomprimiendo el paquete..."
    echo ""
    cd /root/SoftInst/Promtail/
    # Comprobar si el paquete unzip está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s unzip 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}      El paquete unzip no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        apt-get -y update
        apt-get -y install unzip
        echo ""
      fi
    unzip promtail.zip

  # Copiar el binario a /bin/
    echo ""
    echo "  Copiando el binario a /usr/bin"
    echo ""
    cp -fv /root/SoftInst/Promtail/promtail-linux-amd64 /usr/bin/

  # Crear el usuario sin privilegios para utilizar loki
    #useradd --no-create-home --shell /bin/false promtail
    useradd --system promtail
    mkdir -p /etc/promtail
    chown -R promtail:promtail /etc/promtail
    mkdir -p /var/lib/promtail
    chown -R promtail:promtail /var/lib/promtail

  # Crear el archivo de configuración
    echo ""
    echo "    Creando el archivo de configuración..."
    echo ""
    echo "server:"                                                                                            > /etc/promtail/promtail-config.yaml
    echo "  http_listen_port: 9080  # Puerto local para métricas y estado de Promtail"                       >> /etc/promtail/promtail-config.yaml
    echo "  log_level: info"                                                                                 >> /etc/promtail/promtail-config.yaml
    echo ""                                                                                                  >> /etc/promtail/promtail-config.yaml
    echo "positions:"                                                                                        >> /etc/promtail/promtail-config.yaml
    echo "  filename: /var/lib/promtail/positions.yaml  # Archivo con las posiciones de lectura de los logs" >> /etc/promtail/promtail-config.yaml
    echo ""                                                                                                  >> /etc/promtail/promtail-config.yaml
    echo "clients:"                                                                                          >> /etc/promtail/promtail-config.yaml
    echo "  - url: http://$vIPServLoki:3100/loki/api/v1/push  # Dirección del servidor Loki"                 >> /etc/promtail/promtail-config.yaml
    echo ""                                                                                                  >> /etc/promtail/promtail-config.yaml
    echo "scrape_configs:"                                                                                   >> /etc/promtail/promtail-config.yaml
    echo "  - job_name: system_logs  # Nombre del trabajo"                                                   >> /etc/promtail/promtail-config.yaml
    echo "    static_configs:"                                                                               >> /etc/promtail/promtail-config.yaml
    echo "      - targets:"                                                                                  >> /etc/promtail/promtail-config.yaml
    echo "          - localhost  # Promtail no necesita targets reales; esto es simbólico"                   >> /etc/promtail/promtail-config.yaml
    echo "        labels:"                                                                                   >> /etc/promtail/promtail-config.yaml
    echo "          job: varlogs  # Etiqueta para identificar estos logs en Loki"                            >> /etc/promtail/promtail-config.yaml
    echo '          host: ${HOSTNAME}  # Etiqueta con el nombre del servidor donde se ejecuta Promtail'      >> /etc/promtail/promtail-config.yaml
    echo "          __path__: /var/log/*.log  # Ruta a los archivos de log que se quieren procesar"          >> /etc/promtail/promtail-config.yaml

  # Crear el servicio de systemd
    echo "[Unit]"                                                                                    > /etc/systemd/system/promtail.service
    echo "Description=Promtail Service"                                                             >> /etc/systemd/system/promtail.service
    echo "After=network.target"                                                                     >> /etc/systemd/system/promtail.service
    echo ""                                                                                         >> /etc/systemd/system/promtail.service
    echo "[Service]"                                                                                >> /etc/systemd/system/promtail.service
    echo "Type=simple"                                                                              >> /etc/systemd/system/promtail.service
    echo "ExecStart=/usr/bin/promtail-linux-amd64 --config.file=/etc/promtail/promtail-config.yaml" >> /etc/systemd/system/promtail.service
    echo "Restart=always"                                                                           >> /etc/systemd/system/promtail.service
    echo "RestartSec=5"                                                                             >> /etc/systemd/system/promtail.service
    echo "User=promtail"                                                                            >> /etc/systemd/system/promtail.service
    echo "Group=promtail"                                                                           >> /etc/systemd/system/promtail.service
    echo ""                                                                                         >> /etc/systemd/system/promtail.service
    echo "[Install]"                                                                                >> /etc/systemd/system/promtail.service
    echo "WantedBy=multi-user.target"                                                               >> /etc/systemd/system/promtail.service

  # Recargar los daemons
    systemctl daemon-reload

  # Habilitar e iniciar loki
    systemctl enable promtail --now

  # Comprobar estado
    systemctl status promtail.service --no-pager

  # Notificar fin de ejecución del script
    echo ""
    echo "    La instalación de promtail ha finalizado."
    echo ""
    echo "    Para ver los logs del servicio, ejecuta:"
    echo "      tail -f /var/log/promtail.log"
    echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Promtail para Debian 11 (Bullseye)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de Promtail para Debian 10 (Buster)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  
  echo "  Iniciando el script de instalación de Promtail para Debian 9 (Stretch)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Promtail para Debian 8 (Jessie)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Promtail para Debian 7 (Wheezy)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

fi
