#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Unifi Protect en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaGUI/UnifiProtect-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaGUI/UnifiProtect-Instalar.sh | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaGUI/UnifiProtect-Instalar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaGUI/UnifiProtect-Instalar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaGUI/UnifiProtect-Instalar.sh | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Unifi Protect para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Unifi Protect corre mejor en Debian 11.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Unifi Protect para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Unifi Protect corre mejor en Debian 11.${cFinColor}"
    echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Unifi Protect para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    # Actualizar la lista de paquetes disponibles en los repositorios
      sudo apt-get -y update

    # Instalar paquetes necesarios
      sudo apt-get -y install ca-certificates
      sudo apt-get -y install curl
      sudo apt-get -y install gnupg
      sudo apt-get -y install lsb-release
      sudo apt-get -y install ffmpeg

    # Instalar MongoDB 4.4
      # Descargar binario de mongodb
        cd /opt
        curl -LO https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-debian10-4.4.29.tgz
      # Desempaquetar
        sudo tar -xzf /opt/mongodb-linux-x86_64-debian10-4.4.29.tgz -C /opt
      # Crear rutas y enlazar binarios de MongoDB
        sudo ln -s /opt/mongodb-linux-x86_64-debian10-4.4.29/bin/* /usr/local/bin/
      # Crear usuario, directorios y permisos para MongoDB
        sudo useradd -r -s /usr/sbin/nologin mongodb
        sudo mkdir -p /var/lib/mongodb /var/log/mongodb
        sudo chown -R mongodb:mongodb /var/lib/mongodb /var/log/mongodb
      # Crear el servidio de systemd
        echo '[Unit]'                                                                                                              | sudo tee    /etc/systemd/system/mongod.service
        echo 'Description=MongoDB Database Server'                                                                                 | sudo tee -a /etc/systemd/system/mongod.service
        echo 'After=network.target'                                                                                                | sudo tee -a /etc/systemd/system/mongod.service
        echo ''                                                                                                                    | sudo tee -a /etc/systemd/system/mongod.service
        echo '[Service]'                                                                                                           | sudo tee -a /etc/systemd/system/mongod.service
        echo 'User=mongodb'                                                                                                        | sudo tee -a /etc/systemd/system/mongod.service
        echo 'Group=mongodb'                                                                                                       | sudo tee -a /etc/systemd/system/mongod.service
        echo 'ExecStart=/usr/local/bin/mongod --dbpath /var/lib/mongodb --logpath /var/log/mongodb/mongod.log --bind_ip 127.0.0.1' | sudo tee -a /etc/systemd/system/mongod.service
        echo 'Restart=always'                                                                                                      | sudo tee -a /etc/systemd/system/mongod.service
        echo 'LimitNOFILE=64000'                                                                                                   | sudo tee -a /etc/systemd/system/mongod.service
        echo ''                                                                                                                    | sudo tee -a /etc/systemd/system/mongod.service
        echo '[Install]'                                                                                                           | sudo tee -a /etc/systemd/system/mongod.service
        echo 'WantedBy=multi-user.target'                                                                                          | sudo tee -a /etc/systemd/system/mongod.service
      # Arrancar MongoDB y verificar versión
        sudo systemctl daemon-reexec
        sudo systemctl daemon-reload
        sudo systemctl enable --now mongod
        sudo mongod --version

    # Instalar NodeJS 16
      curl -fsSL https://deb.nodesource.com/setup_16.x | sudo bash -
      sudo apt-get -y install nodejs

    # Descargar protect
      sudo mkdir -p /opt/unifi-protec

rm -f /opt/unifi-protect/unifi-protect.deb
curl -L -A "Mozilla/5.0" https://fw-download.ubnt.com/data/unifi-protect/unifi-protect_2.11.13_amd64.deb -o /opt/unifi-protect/unifi-protect.deb

curl -fsSL https://dl.ui.com/unifi/unifi-repo.gpg | gpg --dearmor -o /usr/share/keyrings/unifi.gpg
echo "deb [signed-by=/usr/share/keyrings/unifi.gpg] https://www.ui.com/downloads/unifi/debian stable ubiquiti" > /etc/apt/sources.list.d/unifi.list







sudo docker run --privileged --rm tonistiigi/binfmt --install all

sudo docker run -d --name unifi-protect  \
    --privileged                         \
    --tmpfs /run                         \
    --tmpfs /run/lock                    \
    --tmpfs /tmp                         \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro  \
    -v /storage/srv:/srv                 \
    -v /storage/data:/data               \
    -v /storage/persistent:/persistent   \
    --network host                       \
    -e STORAGE_DISK=/dev/sda1            \
    markdegroot/unifi-protect-arm64:latest




sudo docker run -d --name unifi-protect \
  --privileged                              \
  --network host                            \
  --tmpfs /run                              \
  --tmpfs /run/lock                         \
  --tmpfs /tmp                              \
  -v unifi-protect:/srv                     \
  -v unifi-protect-data:/data               \
  markdegroot/unifi-protect-arm64:latest

echo "  entrar a http://localhost:3000"



sudo docker stop unifi-protect
sudo docker rm unifi-protect
sudo docker volume rm unifi-protect unifi-protect-data

sudo mkdir -p /mnt/DiscoGrabaciones/{srv,data,persistent}
sudo chown -R root:root /mnt/DiscoGrabaciones
sudo chmod -R 755 /mnt/DiscoGrabaciones


sudo docker run -d --name unifi-protect \
  --privileged \
  --tmpfs /run \
  --tmpfs /run/lock \
  --tmpfs /tmp \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  -v /mnt/DiscoGrabaciones/srv:/srv \
  -v /mnt/DiscoGrabaciones/data:/data \
  -v /mnt/DiscoGrabaciones/persistent:/persistent \
  --network host \
  markdegroot/unifi-protect-arm64:latest











# x86

sudo docker run -d --name unifi-protect-x86         \
    --tmpfs /srv/unifi-protect/temp                 \
    -p 7080:7080                                    \
    -p 7443:7443                                    \
    -p 7444:7444                                    \
    -p 7447:7447                                    \
    -p 7550:7550                                    \
    -p 7442:7442                                    \
    -m 2048m                                        \
    -v unifi-protect-db:/var/lib/postgresql/10/main \
    -v unifi-protect:/srv/unifi-protect             \
    markdegroot/unifi-protect-x86:latest








sudo docker run -d --name unifi-protect-x86 \
  -p 7080:7080 \
  -p 7443:7443 \
  -p 7444:7444 \
  -p 7447:7447 \
  -p 7550:7550 \
  -p 7442:7442 \
  -m 2048m \
  -v unifi-protect-db:/var/lib/postgresql/10/main \
  -v unifi-protect:/srv/unifi-protect \
  markdegroot/unifi-protect-x86:latest


sudo docker rm unifi-protect-x86

sudo docker run -d --name unifi-protect-x86 \
  --user 0 \
  -p 7080:7080 \
  -p 7443:7443 \
  -p 7444:7444 \
  -p 7447:7447 \
  -p 7550:7550 \
  -p 7442:7442 \
  -m 2048m \
  -v unifi-protect-db:/var/lib/postgresql/10/main \
  -v unifi-protect:/srv/unifi-protect \
  markdegroot/unifi-protect-x86:latest





sudo docker rm unifi-protect-x86

sudo docker run --rm -v unifi-protect:/srv/unifi-protect busybox sh -c '
mkdir -p /srv/unifi-protect/temp /srv/unifi-protect/logs /srv/unifi-protect/data &&
chmod -R 777 /srv/unifi-protect
'

sudo docker run -d --name unifi-protect-x86 \
  --privileged \
  --tmpfs /run \
  --tmpfs /run/lock \
  --tmpfs /tmp \
  -p 7080:7080 \
  -p 7443:7443 \
  -p 7444:7444 \
  -p 7447:7447 \
  -p 7550:7550 \
  -p 7442:7442 \
  -m 2048m \
  -v unifi-protect-db:/var/lib/postgresql/10/main \
  -v unifi-protect:/srv/unifi-protect \
  markdegroot/unifi-protect-x86:latest





sudo docker run -d --name unifi-protect \
  --privileged \
  --network host \
  --tmpfs /run \
  --tmpfs /run/lock \
  --tmpfs /tmp \
  -v unifi-protect:/srv \
  -v unifi-protect-data:/data \
  markdegroot/unifi-protect-arm64














Después del setup UniFi Protect cerrará 3000 moverá todo a HTTPS Y entonces entrarás por:3000

UniFi Protect needs a lot of storage to record video. Protect will fail to start if there is not at least 100GB disk space available, so make sure to store your Docker volumes on a disk with some space (/storage in the above run command).
Optional: Update the env variable STORAGE_DISK to your disk to see disk usage inside UniFi Protect.

Issues with remote access
There is a known issue that remote access to your UNVR (via the Ubnt cloud) will not work with the console unless the primary network interface is named enp0s2. To achieve this, on your host machine create the file /etc/systemd/network/98-enp0s2.link with the content below, replacing xx:xx:xx:xx:xx:xx with your actual MAC address.

[Match]
MACAddress=xx:xx:xx:xx:xx:xx

[Link]
Name=enp0s2
Make sure to update your network settings to reflect the new interface name. To apply the settings, run sudo update-initramfs -u and reboot your host machine.




    # Instalar
      sudo apt -y install /opt/unifi-protect/unifi-protect.deb

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Unifi Protect para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Unifi Protect para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Unifi Protect para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Unifi Protect para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
