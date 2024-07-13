#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Mattermost en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Mattermost-InstalarYConfigurar.sh | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Mattermost-InstalarYConfigurar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Mattermost-InstalarYConfigurar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Mattermost-InstalarYConfigurar.sh | nano -
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
  #if [ $(id -u) -ne 0 ]; then
  if [[ $EUID -ne 0 ]]; then
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

# Ejecutar comandos dependiendo de la versión de Debian detectada

  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Mattermost para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Mattermost para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Instalar PostgreSQL
      echo ""
      echo "    Instalando PostgreSQL..."
      echo ""
      apt-get update
      apt-get -y install postgresql
      apt-get -y install postgresql-contrib
      systemctl enable postgresql --now
      # Crear la base de datos y el usuario para Mattermost
        echo ""
        echo "      Creando el usuario y la base de datos para mattermost..."
        echo ""
        # Cambiar momentáneamente la autenticación del usuario postres
          # Obtener la versión de PostgreSQL instalada
            vVersPostgreInst=$(ls /etc/postgresql/ | tail -n1)
          cp /etc/postgresql/$vVersPostgreInst/main/pg_hba.conf /etc/postgresql/$vVersPostgreInst/main/pg_hba.conf.bak
          sed -i -e 's|local   all             postgres                                peer|local all postgres trust|g' /etc/postgresql/$vVersPostgreInst/main/pg_hba.conf
          systemctl restart postgresql
        vUsuarioMMPostgreSQL="mmuser"
        vPasswordMMPostgreSQL="P@ssw0rd!"
        vNombreBDPostgreSQL="mattermost"
        psql -U postgres -c "CREATE USER $vUsuarioMMPostgreSQL WITH PASSWORD '$vPasswordMMPostgreSQL';"
        psql -U postgres -c "CREATE DATABASE $vNombreBDPostgreSQL OWNER $vUsuarioMMPostgreSQL;"
        psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE $vNombreBDPostgreSQL TO $vUsuarioMMPostgreSQL;"
        # Restaurar la autenticación del usuario postres
          cp /etc/postgresql/$vVersPostgreInst/main/pg_hba.conf /etc/postgresql/$vVersPostgreInst/main/pg_hba.conf.bak
          sed -i -e 's|local all postgres trust|local all postgres peer|g' /etc/postgresql/$vVersPostgreInst/main/pg_hba.conf
          systemctl restart postgresql

    # Consultar el número de la última versión de Mattermost disponible
      echo ""
      echo "    Consultando el número de la última versión disponible de Mattermost..."
      echo ""
      # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          apt-get -y update && apt-get -y install curl
          echo ""
        fi
      vNumUltVers=$(curl -sL https://github.com/mattermost/mattermost/releases/latest/ | sed 's->->\n-g' | grep tag | grep tree | sed 's-/tree/-/tree/\n-g' | grep ^v | cut -d'"' -f1 | head -n1 | cut -d'v' -f2)
      echo ""
      echo "      La última versión disponible parece ser la $vNumUltVers"
      echo ""

    # Descargar el archivo comprimido de la última versión
      echo ""
      echo "    Descargando el archivo comprimido de la última versión..."
      echo ""
      rm -rf   /root/SoftInst/Mattermost/* 2> /dev/null
      mkdir -p /root/SoftInst/Mattermost/  2> /dev/null
      cd       /root/SoftInst/Mattermost/
      curl -L https://releases.mattermost.com/$vNumUltVers/mattermost-$vNumUltVers-linux-amd64.tar.gz -o Mattermost.tar.gz
      echo ""

    # Descomprimir el archivo
      echo ""
      echo "    Descomprimiendo el archivo..."
      echo ""
      tar -xvzf Mattermost.tar.gz
      echo ""

    # Agregar el usuario mattermost
      echo ""
      echo "    Agregando el usuario mattermost..."
      echo ""
      useradd --system --user-group mattermost

    # Preparar la carpeta final
      echo ""
      echo "    Preparando la carpeta final..."
      echo ""
      mv mattermost /opt
      mkdir /opt/mattermost/data
      chown -R mattermost:mattermost /opt/mattermost
      chmod -R g+w /opt/mattermost

#    # Preparar el servicio de systemd
#      echo ""
#      echo "    Preparando el servicio de systemd..."
#      echo ""
#      echo "[Unit]"                                    > /lib/systemd/system/Mattermost.service
#      echo "Description=Mattermost"                   >> /lib/systemd/system/Mattermost.service
#      echo "After=network.target"                     >> /lib/systemd/system/Mattermost.service
#      echo "After=postgresql.service"                 >> /lib/systemd/system/Mattermost.service # Aconsejable al instalar mattermost en la misma máquina que PosgreSQL
#      echo "BindsTo=postgresql.service"               >> /lib/systemd/system/Mattermost.service # Aconsejable al instalar mattermost en la misma máquina que PosgreSQL
#      echo ""                                         >> /lib/systemd/system/Mattermost.service
#      echo "[Service]"                                >> /lib/systemd/system/Mattermost.service
#      echo "Type=notify"                              >> /lib/systemd/system/Mattermost.service
#      echo "ExecStart=/opt/mattermost/bin/mattermost" >> /lib/systemd/system/Mattermost.service
#      echo "TimeoutStartSec=3600"                     >> /lib/systemd/system/Mattermost.service
#      echo "KillMode=mixed"                           >> /lib/systemd/system/Mattermost.service
#      echo "Restart=always"                           >> /lib/systemd/system/Mattermost.service
#      echo "RestartSec=10"                            >> /lib/systemd/system/Mattermost.service
#      echo "WorkingDirectory=/opt/mattermost"         >> /lib/systemd/system/Mattermost.service
#      echo "User=mattermost"                          >> /lib/systemd/system/Mattermost.service
#      echo "Group=mattermost"                         >> /lib/systemd/system/Mattermost.service
#      echo "LimitNOFILE=49152"                        >> /lib/systemd/system/Mattermost.service
#      echo ""                                         >> /lib/systemd/system/Mattermost.service
#      echo "[Install]"                                >> /lib/systemd/system/Mattermost.service
#      echo "WantedBy=multi-user.target"               >> /lib/systemd/system/Mattermost.service

    # Preparar el servicio de systemd
      echo ""
      echo "    Preparando el servicio de systemd..."
      echo ""
      echo "[Unit]"                                    > /etc/systemd/system/Mattermost.service
      echo "Description=Mattermost"                   >> /etc/systemd/system/Mattermost.service
      echo "After=network.target"                     >> /etc/systemd/system/Mattermost.service
      echo "After=postgresql.service"                 >> /etc/systemd/system/Mattermost.service # Aconsejable al instalar mattermost en la misma máquina que PosgreSQL
      echo "BindsTo=postgresql.service"               >> /etc/systemd/system/Mattermost.service # Aconsejable al instalar mattermost en la misma máquina que PosgreSQL
      echo ""                                         >> /etc/systemd/system/Mattermost.service
      echo "[Service]"                                >> /etc/systemd/system/Mattermost.service
      echo "Type=notify"                              >> /etc/systemd/system/Mattermost.service
      echo "ExecStart=/opt/mattermost/bin/mattermost" >> /etc/systemd/system/Mattermost.service
      echo "TimeoutStartSec=3600"                     >> /etc/systemd/system/Mattermost.service
      echo "KillMode=mixed"                           >> /etc/systemd/system/Mattermost.service
      echo "Restart=always"                           >> /etc/systemd/system/Mattermost.service
      echo "RestartSec=10"                            >> /etc/systemd/system/Mattermost.service
      echo "WorkingDirectory=/opt/mattermost"         >> /etc/systemd/system/Mattermost.service
      echo "User=mattermost"                          >> /etc/systemd/system/Mattermost.service
      echo "Group=mattermost"                         >> /etc/systemd/system/Mattermost.service
      echo "LimitNOFILE=49152"                        >> /etc/systemd/system/Mattermost.service
      echo ""                                         >> /etc/systemd/system/Mattermost.service
      echo "[Install]"                                >> /etc/systemd/system/Mattermost.service
      echo "WantedBy=multi-user.target"               >> /etc/systemd/system/Mattermost.service

    # Configurar Mattermost
      echo ""
      echo "    Configurando la aplicación..."
      echo ""
      # Hacer copia de seguridad del archivo de configuración
        cp /opt/mattermost/config/config.json /opt/mattermost/config/config.json.bak.ori
      # Modificar el DataSource
        # Comprobar si el paquete jq está instalado. Si no lo está, instalarlo.
          if [[ $(dpkg-query -s jq 2>/dev/null | grep installed) == "" ]]; then
            echo ""
            echo -e "${cColorRojo}      El paquete jq no está instalado. Iniciando su instalación...${cFinColor}"
            echo ""
            apt-get -y update && apt-get -y install jq
            echo ""
          fi
        jq '.SqlSettings.DataSource = "postgres://'"$vUsuarioMMPostgreSQL:$vPasswordMMPostgreSQL@localhost:5432/$vNombreBDPostgreSQL?sslmode=disable&connect_timeout=10"'"' /opt/mattermost/config/config.json > /tmp/mmconfig.json && mv /tmp/mmconfig.json /opt/mattermost/config/config.json
        #jq '.ServiceSettings.SiteURL = "http://mattermost.dominio.com"' /opt/mattermost/config/config.json

    # Activar e iniciar el servicio
      echo ""
      echo "    Activando e iniciando el servicio..."
      echo ""
      systemctl daemon-reload
      systemctl enable Mattermost.service --now

    # Notificar fin de ejecución del script
      echo ""
      echo "    Ejecución del script, finalizada."
      echo "      Puedes acceder al servicio en:"
      echo "        http://localhost:8065"
      echo ""

#Depending on your configuration, there are several important folders in /opt/mattermost to backup.
#These are config, logs, plugins, client/plugins, and data. We strongly recommend you back up these locations before running the rm command.

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Mattermost para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Mattermost para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Mattermost para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Mattermost para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Mattermost para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
