#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar CTFd en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ServWeb/CTFd-InstalarYConfigurar.sh | bash
#
# Ejecución remota como root (para permisos sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ServWeb/CTFd-InstalarYConfigurar.sh | sed 's-sudo--g' | bash
#
# Enlace: https://github.com/CTFd/CTFd
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde="\033[1;32m"
  cColorRojo="\033[1;31m"
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor="\033[0m"

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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de CTFd para Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de CTFd para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Crear el menú
      # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install dialog
          echo ""
        fi
      menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
        opciones=(
          1 "Instalar requerimientos de sistema"                               on
          2 "  Crear la base de datos"                                         on
          3 "  Clonar el repo de Github"                                       on
          4 "    Crear el entorno virtual de python e instalar requerimientos" on
          5 "      Crear el usuario para ejecutar el servicio en systemd"      on
          6 "        Crear el servicio en systemd"                             on
          7 "Instalar el proxy inverso"                                        on
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Instalando requerimientos de sistema..."
              echo ""
              sudo apt-get -y update
              sudo apt-get -y install python3
              sudo apt-get -y install python3-venv
              sudo apt-get -y install python3-pip
              sudo apt-get -y install git
              sudo apt-get -y install mariadb-server
              sudo apt-get -y install mariadb-client
              sudo apt-get -y install libmariadb-dev
              sudo apt-get -y install build-essential

            ;;

            2)

              echo ""
              echo "  Creando la base de datos..."
              echo ""
              echo -e "" | sudo mysql -uroot -p -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'P@ssw0rd'; FLUSH PRIVILEGES;"
              sudo mysql -uroot -pP@ssw0rd -e "CREATE DATABASE ctfd; CREATE USER 'ctfd'@'localhost' IDENTIFIED BY 'P@ssw0rd'; GRANT ALL PRIVILEGES ON ctfd.* TO 'ctfd'@'localhost'; FLUSH PRIVILEGES;"

            ;;

            3)

              echo ""
              echo "  Clonando el repo de Github..."
              echo ""

              cd /opt/
              sudo rm -rf /opt/CTFd/
              sudo git clone https://github.com/CTFd/CTFd.git

            ;;

            4)

              echo ""
              echo "  Creando el entorno virtual de python e instalando requerimientos..."
              echo ""
              cd /opt/CTFd/
              sudo python3 -m venv venv
              # Crear el mensaje para mostrar cuando se entra al entorno virtual
                echo ''                                                                                | sudo tee -a /opt/CTFd/venv/bin/activate
                echo 'echo -e "\n  Activando el entorno virtual de CTFd... \n"'                        | sudo tee -a /opt/CTFd/venv/bin/activate
                echo 'echo -e "    Forma de uso:\n"'                                                   | sudo tee -a /opt/CTFd/venv/bin/activate
                echo 'echo -e "      cd /opt/CTFd\nflask run --host=0.0.0.0"'                          | sudo tee -a /opt/CTFd/venv/bin/activate
                echo 'echo -e "      o"'                                                               | sudo tee -a /opt/CTFd/venv/bin/activate
                echo 'echo -e ""'                                                                      | sudo tee -a /opt/CTFd/venv/bin/activate
                echo 'echo -e "      cd /opt/CTFd\ngunicorn -w 4 -b 0.0.0.0:4000 'CTFd:create_app()'"' | sudo tee -a /opt/CTFd/venv/bin/activate
              # Entrar al entorno virtual
                sudo source /opt/CTFd/venv/bin/activate
              # Instalar requerimientos
                pip3 install -r requirements.txt
              # Instalar el conector mysql
                pip3 install wheel
                pip3 install pymysql
              # Generar una llave única para la app flask
                vLlaveFlask=$(python3 -c "import secrets; print(secrets.token_hex(32))")
              # Crear el archivo de configuración
                echo "FLASK_ENV=production"                                      | sudo tee    /opt/CTFd/.ctfd.env
                echo "DATABASE_URL=mysql+pymysql://ctfd:P@ssw0rd@localhost/ctfd" | sudo tee -a /opt/CTFd/.ctfd.env
                echo "SECRET_KEY=$vLlaveFlask"                                   | sudo tee -a /opt/CTFd/.ctfd.env
                echo "MAIL_SERVER=localhost"                                     | sudo tee -a /opt/CTFd/.ctfd.env
                echo "MAIL_PORT=25"                                              | sudo tee -a /opt/CTFd/.ctfd.env
                echo "MAIL_USE_TLS=false"                                        | sudo tee -a /opt/CTFd/.ctfd.env
                echo "MAIL_USERNAME="                                            | sudo tee -a /opt/CTFd/.ctfd.env
                echo "MAIL_PASSWORD="                                            | sudo tee -a /opt/CTFd/.ctfd.env
              # Inicializar la base de datos
                flask db upgrade
              # Instalar Green Unicorn (para la web más rápida en producción)
                pip3 install gunicorn
              # Salir del entorno virtual
                deactivate
              # Notificar fin de instalación en el entorno virtual
                echo ""
                echo -e "${cColorVerde}    Entorno virtual preparado. CTFd se puede ejecutar desde el venv de la siguientes formas:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      source /opt/CTFd/venv/bin/activate${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        cd /opt/CTFd/'${cFinColor}"
                echo -e "${cColorVerde}        flask run --host=0.0.0.0${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      deactivate${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        o${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      source /opt/CTFd/venv/bin/activate${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        cd /opt/CTFd/'${cFinColor}"
                echo -e "${cColorVerde}        gunicorn -w 4 -b 0.0.0.0:4000 'CTFd:create_app()'${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      deactivate${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      Para un entorno de producción, con mucho tráfico, se aconseja la segunda forma.${cFinColor}"
                echo ""

            ;;

            5)

              echo ""
              echo "  Creando el usuario para ejecutar el servicio en systemd..."
              echo ""

              # Crear el usuario
                #useradd --system --no-create-home --shell /bin/false ctfd
                sudo useradd --system --no-create-home ctfd
                sudo mkdir -p /opt/CTFd 2> /dev/null
                sudo chown -R ctfd:ctfd /opt/CTFd -R

            ;;


            6)

              echo ""
              echo "  Creando y activando el servicio de systemd..."
              echo ""
              echo "[Unit]"                                                                                        > /etc/systemd/system/ctfd.service
              echo "Description=CTFd Service"                                                                     >> /etc/systemd/system/ctfd.service
              echo "After=network.target"                                                                         >> /etc/systemd/system/ctfd.service
              echo ""                                                                                             >> /etc/systemd/system/ctfd.service
              echo "[Service]"                                                                                    >> /etc/systemd/system/ctfd.service
              echo "User=ctfd"                                                                                    >> /etc/systemd/system/ctfd.service
              echo "Group=ctfs"                                                                                   >> /etc/systemd/system/ctfd.service
              echo "WorkingDirectory=/opt/CTFd/"                                                                  >> /etc/systemd/system/ctfd.service
              echo 'Environment="FLASK_ENV=production"'                                                           >> /etc/systemd/system/ctfd.service
              echo 'ExecStart=/opt/CTFd/venv/bin/gunicorn -w 4 -b 0.0.0.0:8000 "CTFd:create_app()"' >> /etc/systemd/system/ctfd.service
              echo "Restart=always"                                                                               >> /etc/systemd/system/ctfd.service
              echo ""                                                                                             >> /etc/systemd/system/ctfd.service
              echo "[Install]"                                                                                    >> /etc/systemd/system/ctfd.service
              echo "WantedBy=multi-user.target"                                                                   >> /etc/systemd/system/ctfd.service

            ;;

            7)

              echo ""
              echo "  Instalando el proxy inverso..."
              echo ""
              apt-get -y update
              apt-get -y install nginx
              # Deshabilitar el sitio por defecto
                rm /etc/nginx/sites-enabled/default
              # Crear el archivo del sistio
                echo "server {"                                      > /etc/nginx/sites-available/ctfd
                echo "    listen 80;"                               >> /etc/nginx/sites-available/ctfd
                echo "server_name cftd.dominio.com;"                >> /etc/nginx/sites-available/ctfd
                echo ""                                             >> /etc/nginx/sites-available/ctfd
                echo "  location / {"                               >> /etc/nginx/sites-available/ctfd
                echo "    proxy_pass http://127.0.0.1:8000;"        >> /etc/nginx/sites-available/ctfd
                echo '    proxy_set_header Host $host;'             >> /etc/nginx/sites-available/ctfd
                echo '    proxy_set_header X-Real-IP $remote_addr;' >> /etc/nginx/sites-available/ctfd
                echo "  }"                                          >> /etc/nginx/sites-available/ctfd
                echo "}"                                            >> /etc/nginx/sites-available/ctfd
              # Habilitar la configuración
                ln -s /etc/nginx/sites-available/ctfd /etc/nginx/sites-enabled/
                systemctl restart nginx

            ;;

        esac

    done

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Volatilty para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Volatilty para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Volatilty para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Volatilty para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Volatilty para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
