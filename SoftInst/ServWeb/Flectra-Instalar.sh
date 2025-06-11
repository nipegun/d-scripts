#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Flectra en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ServWeb/Flectra-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ServWeb/Flectra-Instalar.sh | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ServWeb/Flectra-Instalar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ServWeb/Flectra-Instalar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ServWeb/Flectra-Instalar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
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

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install curl
    echo ""
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Flectra para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Flectra para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Crear el menú
      # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install dialog
          echo ""
        fi
      menu=(dialog --checklist "Cómo quieres instalar Flectra:" 22 80 16)
        opciones=(
          1 "Agregando el repositorio de la última versión"                 off
          2 "Descargando directamente el archivo .deb de la última versión" off
          3 "Descargando el código fuente"                                  off
          4 "Clonando el repo oficial de GitLab"                            on
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      #clear

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Instalando Flectra desde el repositorio oficial para Debian..."
              echo ""

              # Descargar paquetes necesarios para la correcta ejecución del script
                echo ""
                echo "    Descargando paquetes necesarios para la correcta ejecución del script..."
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install curl
                sudo apt-get -y install gpg
                sudo apt-get -y install wget
                sudo apt-get -y install gsfonts
                sudo apt-get -y install fonts-freefont-ttf
                sudo apt-get -y install fonts-dejavu

              # Determinar la última versión disponible de Flectra
                echo ""
                echo "    Determinando la última versión disponible..."
                echo ""
                vUltVersFlectra=$(curl -ksL download.flectrahq.com | sed 's->->\n-g' | grep href | grep latest | grep deb | head -n1 | cut -d '"' -f2 | cut -d '/' -f1)
                echo "      La última versión disponible es la $vUltVersFlectra"
                echo ""

              # Agregar el repositorio
                echo ""
                echo "    Agregando el repositorio..."
                echo ""
                cd /tmp
                sudo rm -f /etc/apt/trusted.gpg.d/flectra.gpg 2> /dev/null
                wget --no-check-certificate https://download.flectrahq.com/flectra.key -O - | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/flectra.gpg
                echo "deb [trusted=yes] http://download.flectrahq.com/"$vUltVersFlectra"/pub/deb ./" | sudo tee /etc/apt/sources.list.d/flectra.list
                sudo apt-get -y update

              # Instalar
                echo ""
                echo "    Instalando..."
                echo ""
                apt-get install flectra

            ;;

            2)

              echo ""
              echo "  Instalando Flectra desde el .deb de la última versión..."
              echo ""

              # Descargar paquetes necesarios para la correcta ejecución del script
                echo ""
                echo "    Descargando paquetes necesarios para la correcta ejecución del script..."
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install curl
                sudo apt-get -y install gpg
                sudo apt-get -y install wget
                sudo apt-get -y install gsfonts
                sudo apt-get -y install fonts-freefont-ttf
                sudo apt-get -y install fonts-dejavu

              # Determinar la última versión disponible de Flectra
                echo ""
                echo "    Determinando la última versión disponible..."
                echo ""
                vUltVersFlectra=$(curl -ksL download.flectrahq.com | sed 's->->\n-g' | grep href | grep latest | grep deb | head -n1 | cut -d '"' -f2 | cut -d '/' -f1)
                echo "      La última versión disponible es la $vUltVersFlectra"
                echo ""

              # Descargar el .deb
                echo ""
                echo "    Descargando el archivo .deb..."
                echo ""
                vURLIntermediaArchivo=$(curl -ksL download.flectrahq.com | sed 's->->\n-g' | grep href | grep latest | grep deb | head -n1 | cut -d '"' -f2)
                curl -kL https://download.flectrahq.com/"$vURLIntermediaArchivo" -o /tmp/flectra.deb

              # Instalar el archivo .deb
                echo ""
                echo "    Instalando el archivo .deb..."
                echo ""
                sudo apt -y install /tmp/flectra.deb

              # Notificar fin de ejecución del script
                echo ""
                echo "    La ejecución del script ha finalizado."
                echo "    Flectra está instalada y configurada."



            ;;

            3)

              echo ""
              echo "  Instalando Flectra descargando el código fuente..."
              echo ""

              # Descargar paquetes necesarios para la correcta ejecución del script
                echo ""
                echo "    Descargando paquetes necesarios para la correcta ejecución del script..."
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install curl
                sudo apt-get -y install gpg
                sudo apt-get -y install wget
                sudo apt-get -y install gsfonts
                sudo apt-get -y install fonts-freefont-ttf
                sudo apt-get -y install fonts-dejavu
                sudo apt-get -y install postgresql
                sudo apt-get -y install postgresql-server-dev-all
                sudo apt-get -y install build-essential
                sudo apt-get -y install python3-dev
                sudo apt-get -y install python3-pip
                sudo apt-get -y install python3-venv
                sudo apt-get -y install npm
                sudo apt-get -y install nodejs
                sudo apt-get -y install git
                sudo apt-get -y install libldap2-dev
                sudo apt-get -y install libxml2-dev
                sudo apt-get -y install libxslt1-dev
                sudo apt-get -y install libjpeg-dev
                sudo apt-get -y install unzip
                sudo apt-get -y install libsasl2-dev
                sudo apt-get -y install libldap2-dev
                sudo apt-get -y install libssl-dev

              # Crear el usuario
                echo ""
                echo "    Creando el usuario del sistema..."
                echo ""
                sudo adduser --system --group --home /opt/flectra flectra
                sudo su - postgres -c "createuser -s flectra"

              # Determinar la última versión disponible de Flectra
                echo ""
                echo "    Determinando la última versión disponible..."
                echo ""
                vUltVersFlectra=$(curl -ksL download.flectrahq.com | sed 's->->\n-g' | grep href | grep latest | grep zip | head -n1 | cut -d '"' -f2 | cut -d '/' -f1)
                echo "      La última versión disponible es la $vUltVersFlectra"
                echo ""

              # Descargar el .zip
                echo ""
                echo "    Descargando el archivo .zip..."
                echo ""
                vURLIntermediaArchivo=$(curl -ksL download.flectrahq.com | sed 's->->\n-g' | grep href | grep latest | grep zip | head -n1 | cut -d '"' -f2)
                curl -kL https://download.flectrahq.com/"$vURLIntermediaArchivo" -o /tmp/flectra.zip

              # Descomprimir el .zip
                echo ""
                echo "    Descomprimiendo el archivo .zip..."
                echo ""
                cd /tmp
                unzip /tmp/flectra.zip
                sudo cp -r /tmp/flectra-"$vUltVersFlectra"/* /opt/flectra
                sudo chown flectra:flectra /opt/flectra -R

              # Crear el entorno virtual
                echo ""
                echo "    Creando el entorno virtual..."
                echo ""
                sudo -u flectra bash -c '\
                  mkdir /opt/flectra/VirtualEnvironment/              && \
                  python3 -m venv /opt/flectra/VirtualEnvironment/    && \
                  source /opt/flectra/VirtualEnvironment/bin/activate && \
                  pip install wheel                                   && \
                  pip install -r /opt/flectra/requirements.txt        && \
                  deactivate \
                '

            ;;

            4)

              echo ""
              echo "  Instalando Flectra clonando el repo oficial de gitlab..."
              echo ""

              # Descargar paquetes necesarios para la correcta ejecución del script
                echo ""
                echo "    Descargando paquetes necesarios para la correcta ejecución del script..."
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install curl
                sudo apt-get -y install gpg
                sudo apt-get -y install wget
                sudo apt-get -y install gsfonts
                sudo apt-get -y install fonts-freefont-ttf
                sudo apt-get -y install fonts-dejavu
                sudo apt-get -y install postgresql
                sudo apt-get -y install postgresql-server-dev-all
                sudo apt-get -y install build-essential
                sudo apt-get -y install python3-dev
                sudo apt-get -y install python3-pip
                sudo apt-get -y install python3-venv
                sudo apt-get -y install npm
                sudo apt-get -y install nodejs
                sudo apt-get -y install git
                sudo apt-get -y install libldap2-dev
                sudo apt-get -y install libxml2-dev
                sudo apt-get -y install libxslt1-dev
                sudo apt-get -y install libjpeg-dev
                sudo apt-get -y install unzip
                sudo apt-get -y install libsasl2-dev
                sudo apt-get -y install libldap2-dev
                sudo apt-get -y install libssl-dev

              # Crear el usuario
                echo ""
                echo "    Creando el usuario del sistema..."
                echo ""
                sudo adduser --system --group --home /opt/flectra flectra
                sudo su - postgres -c "createuser -s flectra"

              # Determinar la última versión disponible de Flectra
                echo ""
                echo "    Determinando la última versión disponible..."
                echo ""
                vUltVersFlectra=$(curl -ksL download.flectrahq.com | sed 's->->\n-g' | grep href | grep latest | grep zip | head -n1 | cut -d '"' -f2 | cut -d '/' -f1)
                echo "      La última versión disponible es la $vUltVersFlectra"
                echo ""

              # Clonar el repo
                echo ""
                echo "    Clonando el repo..."
                echo ""
                sudo -u flectra bash -c "\
                  cd /opt/flectra/                                                                        && \
                  git clone --depth=1 --branch=$vUltVersFlectra https://gitlab.com/flectra-hq/flectra.git && \
                  mv /opt/flectra/flectra /opt/flectra/Code
                "

              # Crear el entorno virtual
                echo ""
                echo "    Creando el entorno virtual..."
                echo ""
                sudo -u flectra bash -c '\
                  mkdir /opt/flectra/VirtualEnvironment/              && \
                  python3 -m venv /opt/flectra/VirtualEnvironment/    && \
                  source /opt/flectra/VirtualEnvironment/bin/activate && \
                  pip install wheel                                   && \
                  pip install -r /opt/flectra/Code/requirements.txt   && \
                  deactivate \
                '

              # Crear el archivo de configuración
                echo ""
                echo "    Creando el archivo de configuración..."
                echo ""
                echo '[options]'                              | sudo tee    /opt/flectra/flectra.conf
                echo 'admin_passwd = admin'                   | sudo tee -a /opt/flectra/flectra.conf
                echo 'db_host = False'                        | sudo tee -a /opt/flectra/flectra.conf
                echo 'db_port = False'                        | sudo tee -a /opt/flectra/flectra.conf
                echo 'db_user = flectra'                      | sudo tee -a /opt/flectra/flectra.conf
                echo 'db_password = False'                    | sudo tee -a /opt/flectra/flectra.conf
                echo 'addons_path = /opt/flectra/code/addons' | sudo tee -a /opt/flectra/flectra.conf
                echo 'default_productivity_apps = True'       | sudo tee -a /opt/flectra/flectra.conf
                echo 'logfile = /var/log/flectra/flectra.log' | sudo tee -a /opt/flectra/flectra.conf
                sudo chown flectra:flectra /opt/flectra/flectra.conf

              # Crear el lanzador
                echo ""
                echo "    Creando el lanzador..."
                echo ""
                echo '#!/usr/bin/env python3'                                       | sudo tee    /opt/flectra/flectra.py
                echo ''                                                             | sudo tee -a /opt/flectra/flectra.py
                echo 'import sys'                                                   | sudo tee -a /opt/flectra/flectra.py
                echo 'import os'                                                    | sudo tee -a /opt/flectra/flectra.py
                echo ''                                                             | sudo tee -a /opt/flectra/flectra.py
                echo '# Agrega el paquete flectra al path'                          | sudo tee -a /opt/flectra/flectra.py
                echo 'sys.path.insert(0, "/opt/flectra/code")'                      | sudo tee -a /opt/flectra/flectra.py
                echo ''                                                             | sudo tee -a /opt/flectra/flectra.py
                echo 'import flectra'                                               | sudo tee -a /opt/flectra/flectra.py
                echo ''                                                             | sudo tee -a /opt/flectra/flectra.py
                echo 'if __name__ == "__main__":'                                   | sudo tee -a /opt/flectra/flectra.py
                echo '  flectra.cli.main(args=["-c", "/opt/flectra/flectra.conf"])' | sudo tee -a /opt/flectra/flectra.py
                sudo chmod +x /opt/flectra/flectra.py
                sudo chown flectra:flectra /opt/flectra/flectra.py

              # Ejecutar Flectra por primera vez
                #echo ""
                #echo "    Ejecutando Flectra por primera vez..."
                #echo ""
                #sudo -u flectra bash -c '\
                #  source /opt/flectra/VirtualEnvironment/bin/activate                                                         && \
                #  /opt/flectra/VirtualEnvironment/bin/python3 /opt/flectra/code/flectra-bin --config /opt/flectra/flectra.conf \
                #'

              # Crear el servicio de systemd
                echo ""
                echo "    Creando el servicio de systemd..."
                echo ""


            ;;

        esac

    done

 

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Flectra para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Flectra para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Flectra para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Flectra para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Flectra para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
