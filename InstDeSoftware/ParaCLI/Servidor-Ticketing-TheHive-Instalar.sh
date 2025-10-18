#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar TheHive en Debian
#
# Ejecución remota con sudo:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Servidor-Ticketing-TheHive-Instalar.sh | sudo bash
#
# Ejecución remota como root:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Servidor-Ticketing-TheHive-Instalar.sh | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Servidor-Ticketing-TheHive-Instalar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Servidor-Ticketing-TheHive-Instalar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/Servidor-Ticketing-TheHive-Instalar.sh | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de TheHive para Debian 13 (x)...${cFinColor}"
    echo ""

apt update
apt install -y curl gnupg apt-transport-https openjdk-17-jre-headless
echo "deb [trusted=yes] https://deb.strangebee.com stable main" | tee /etc/apt/sources.list.d/strangebee.list
apt update
apt install -y thehive
apt install -y postgresql
sudo -u postgres psql <<'EOF'
CREATE DATABASE thehive;
CREATE USER thehive WITH PASSWORD 'thehivee';
GRANT ALL PRIVILEGES ON DATABASE thehive TO thehive;
EOF
Edita /etc/thehive/application.conf y configura:
db {
  provider = "org.postgresql.Driver"
  url = "jdbc:postgresql://127.0.0.1:5432/thehive"
  user = "thehive"
  password = "thehive"
}
echo "  Ve a: https://community.strangebee.com/licenses/"
echo "  Crea una cuenta gratuita y solicita la licencia TheHive Community."
echo "Recibirás un archivo .lic o un bloque de texto"
echo "Guárdalo en /etc/thehive/license.lic"

systemctl enable thehive
systemctl start thehive
# Verificar el log
  journalctl -fu thehive

# Notificar fin de ejecución del script
  echo "Puedes ir a http://TU_IP:9000"
  echo ""
  echo "  Usuario por defecto: admin@thehive.local"
  echo "  Contraseña por defecto: secret (te pedirá cambiarla la primera vez que te conectes)"
  echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de TheHive para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Actualizar el sistema
      apt-get -y update && apt-get -y upgrade

    # Instalar java
      apt-get -y install openjdk-17-jdk

    # Instalar e iniciar Elasticsearch:
      curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/ElasticSearch-Instalar.sh | bash

    # Parar Elasticsearch
      systemctl stop elasticsearch

    # Configurar Elasticsearch
      sed -i -e 's/#cluster.name: my-application/cluster.name: hive/g'   /etc/elasticsearch/elasticsearch.yml
      sed -i -e 's/#network.host: 192.168.0.1/network.host: 127.0.0.1/g' /etc/elasticsearch/elasticsearch.yml
      sed -i -e 's/#http.port: 9200/http.port: 9200/g'                   /etc/elasticsearch/elasticsearch.yml

network.host: 127.0.0.1
script.inline: on
cluster.name: hive
threadpool.index.queue_size: 100000
threadpool.search.queue_size: 100000
threadpool.bulk.queue_size: 1000



    # Volver a iniciar Elasticsearch
      systemctl start elasticsearch







https://docs.strangebee.com/thehive/installation/step-by-step-installation-guide/#thehive-installation-and-configuration





# dependencias
apt install wget gnupg apt-transport-https git ca-certificates ca-certificates-java curl software-properties-common python3-pip lsb-release

# java vm
wget -qO- https://apt.corretto.aws/corretto.key | sudo gpg --dearmor -o /usr/share/keyrings/corretto.gpg
echo "deb [signed-by=/usr/share/keyrings/corretto.gpg] https://apt.corretto.aws stable main" | sudo tee -a /etc/apt/sources.list.d/corretto.sources.list
sudo apt update
sudo apt install java-common java-11-amazon-corretto-jdk
echo JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto" | sudo tee -a /etc/environment
export JAVA_HOME="/usr/lib/jvm/java-11-amazon-corretto"


# apache cassandra
wget -qO -  https://downloads.apache.org/cassandra/KEYS | sudo gpg --dearmor  -o /usr/share/keyrings/cassandra-archive.gpg
echo "deb [signed-by=/usr/share/keyrings/cassandra-archive.gpg] https://debian.cassandra.apache.org 40x main" |  sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list 
apt install cassandra
# By default, data is stored in /var/lib/cassandra. Ensure appropriate permissions are set for this directory to avoid any issues with data storage and access.


# The hive
  wget -O- https://raw.githubusercontent.com/StrangeBeeCorp/Security/main/PGP%20keys/packages.key | gpg --dearmor -o /usr/share/keyrings/strangebee-archive-keyring.gpg
  echo 'deb [arch=all signed-by=/usr/share/keyrings/strangebee-archive-keyring.gpg] https://deb.strangebee.com thehive-5.4 main' | tee -a /etc/apt/sources.list.d/strangebee.list
  apt-get -y update && sudo apt-get -y install


  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de TheHive para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de TheHive para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de TheHive para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de TheHive para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de TheHive para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
