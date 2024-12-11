#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar CTFd en Debian
#
# Ejecución remota:
#   https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaCLI/CTFd-InstalarYConfigurar.sh | bash
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
          sudo apt-get -y update && sudo apt-get -y install dialog
          echo ""
        fi
      menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
        opciones=(
          1 "Clonar el repo de CTFd"                                          on
          2 "  Crear el entorno virtual de python e instalar dentro"          on
          3 "    Compilar y guardar en /home/$USER/bin/"                      off
          4 "  Instalar en /home/$USER/.local/bin/"                           off
          5 "    Agregar /home/$USER/.local/bin/ al path"                     off
          6 "Clonar repo, crear venv, compilar e instalar a nivel de sistema" off
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Clonar el repo de CTFd..."
              echo ""

              mkdir -p ~/repos/python/
              cd ~/repos/python/
              rm -rf ~/repos/python/CTFd/
              # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install git
                  echo ""
                fi
              git clone https://github.com/CTFd/CTFd.git

            ;;

            2)

              echo ""
              echo "  Creando el entorno virtual de python e instalando dentro..."
              echo ""
              cd ~/repos/python/CTFd/
              # Comprobar si el paquete python3-venv está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s python3-venv 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}  El paquete python3-venv no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install python3-venv
                  echo ""
                fi
              python3 -m venv venv
              # Crear el mensaje para mostrar cuando se entra al entorno virtual
                echo ''                                                         >> ~/repos/python/CTFd/venv/bin/activate
                echo 'echo -e "\n  Activando el entorno virtual de CTFd... \n"' >> ~/repos/python/CTFd/venv/bin/activate
                echo 'echo -e "    Forma de uso:\n"'                            >> ~/repos/python/CTFd/venv/bin/activate
                echo 'echo -e "      x\n"'                                      >> ~/repos/python/CTFd/venv/bin/activate
              # Entrar al entorno virtual
                source ~/repos/python/CTFd/venv/bin/activate
              # Instalar requerimientos
                pip install -r requirements.txt
              # Instalar el conector mysql
                python3 -m pip install wheel
                python3 -m pip install pymysql

                apt-get -y install python3
                apt-get -y install python3-venv
                apt-get -y install python3-pip
                apt-get -y install git
                apt-get -y install mariadb-server
                apt-get -y install mariadb-client
                apt-get -y install libmariadb-dev
                apt-get -y install build-essential



              # Salir del entorno virtual
                deactivate
              # Notificar fin de instalación en el entorno virtual
                echo ""
                echo -e "${cColorVerde}    Entorno virtual preparado. source ~/repos/python/CTFd/venv/bin/activate se puede ejecutar desde el venv de la siguiente forma:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      source ~/repos/python/volatility3/venv/bin/activate${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        vol      [Parámetros]${cFinColor}"
                echo -e "${cColorVerde}        volshell [Parámetros]${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      deactivate${cFinColor}"
                echo ""

            ;;

            3)

              echo ""
              echo "  Creando la base de datos..."
              echo ""

              # Crear la base de datos
                mysql -u root -e "CREATE DATABASE ctfd; CREATE USER 'ctfd'@'localhost' IDENTIFIED BY 'P@ssw0rd'; GRANT ALL PRIVILEGES ON ctfd.* TO 'ctfd'@'localhost'; FLUSH PRIVILEGES;"

              # Generar una llave única para la app flask
                vLlaveFlask=$(python3 -c "import secrets; print(secrets.token_hex(32))")

              # 
                echo "FLASK_ENV=production"                                       > ~/repos/python/CTFd/.ctfd.env
                echo "DATABASE_URL=mysql+pymysql://ctfd:P@ssw0rd@localhost/ctfd" >> ~/repos/python/CTFd/.ctfd.env
                echo "SECRET_KEY=$vLlaveFlask"                                   >> ~/repos/python/CTFd/.ctfd.env
                echo "MAIL_SERVER=localhost"                                     >> ~/repos/python/CTFd/.ctfd.env
                echo "MAIL_PORT=25"                                              >> ~/repos/python/CTFd/.ctfd.env
                echo "MAIL_USE_TLS=false"                                        >> ~/repos/python/CTFd/.ctfd.env
                echo "MAIL_USERNAME="                                            >> ~/repos/python/CTFd/.ctfd.env
                echo "MAIL_PASSWORD="                                            >> ~/repos/python/CTFd/.ctfd.env

              # Inicializar la base de datos
                flask db upgrade

              # Iniciar CTFd
                flask run --host=0.0.0.0

              # Instalar Green Unicorn
                pip install gunicorn
                gunicorn -w 4 -b 0.0.0.0:8000 "CTFd:create_app()"

              # Crear el usuario para ejecutar el servicio de systemd
                adduser --system --group --no-create-home ctfd
                chown -R ctfd:ctfd /ruta/al/directorio/CTFd

[Unit]
Description=CTFd Service
After=network.target

[Service]
User=ctfd
Group=ctfd
WorkingDirectory=/ruta/al/directorio/CTFd
Environment="FLASK_ENV=production"
ExecStart=/ruta/al/directorio/CTFd/env/bin/gunicorn -w 4 -b 0.0.0.0:8000 "CTFd:create_app()"
Restart=always

[Install]
WantedBy=multi-user.target


# Instalar Green Unicorn, que es un servidor WSGI (Web Server Gateway Interface) para aplicaciones Python. 

              # Instalar el proxy inverso
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

            4)

              echo ""
              echo "  Instalando en /home/$USER/.local/bin/..."
              echo ""

              # Comprobar si el paquete python3-setuptools está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s python3-setuptools 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}  El paquete python3-setuptools no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install python3-setuptools
                  echo ""
                fi
              cd ~/repos/python/volatility3/
              python3 setup.py install --user
              cd ~

              # Notificar fin de ejecución del script
                echo ""
                echo -e "${cColorVerde}    Para ejecutar volatility3 instalado en /home/$USER/.local/bin/:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      Si al instalar has marcado 'Agregar /home/$USER/.local/bin/ al path', simplemente ejecuta:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}        vol [Parámetros]${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      Si al instalar NO has marcado 'Agregar /home/$USER/.local/bin/ al path', ejecuta:${cFinColor}"
                echo ""
                echo -e "${cColorVerde}       ~/.local/bin/vol [Parámetros]${cFinColor}"
                echo ""

            ;;

            5)

              echo ""
              echo "  Agregando /home/$USER/.local/bin al path..."
              echo ""
              echo 'export PATH=/home/'"$USER"'/.local/bin:$PATH' >> ~/.bashrc

            ;;

            6)

              echo ""
              echo "  Clonando repo, creando venv, compilando e instalando a nivel de sistema..."
              echo ""

              # Preparar el entorno virtual de python
                echo ""
                echo "    Preparando el entorno virtual de python..."
                echo ""
                mkdir -p /tmp/PythonVirtualEnvironments/ 2> /dev/null
                rm -rf /tmp/PythonVirtualEnvironments/volatility3/
                cd /tmp/PythonVirtualEnvironments/
              # Comprobar si el paquete python3-venv está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s python3-venv 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}  El paquete python3-venv no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install python3-venv
                  echo ""
                fi
                python3 -m venv volatility3

              # Ingresar en el entorno virtual e instalar
                echo ""
                echo "    Ingresando en el entorno virtual e instalando..."
                echo ""
                source /tmp/PythonVirtualEnvironments/volatility3/bin/activate

              # Clonar el repo
                echo ""
                echo "  Clonando el repo..."
                echo ""
                cd /tmp/PythonVirtualEnvironments/volatility3/
                # Comprobar si el paquete git está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s git 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo -e "${cColorRojo}  El paquete git no está instalado. Iniciando su instalación...${cFinColor}"
                    echo ""
                    sudo apt-get -y update
                    sudo apt-get -y install git
                    echo ""
                  fi
                git clone https://github.com/volatilityfoundation/volatility3.git
                mv volatility3 code
                cd code

              # Compilar
                echo ""
                echo "    Compilando..."
                echo ""
                
                sudo apt-get -y install build-essential
                sudo apt-get -y install python3-dev

                python3 -m pip install wheel
                python3 -m pip install setuptools
                python3 -m pip install pyinstaller
                
                python3 -m pip install distorm3
                python3 -m pip install pycryptodome
                python3 -m pip install pillow
                python3 -m pip install openpyxl
                python3 -m pip install ujson
                python3 -m pip install pytz
                python3 -m pip install ipython
                python3 -m pip install capstone
                python3 -m pip install yara-python
                
                python3 -m pip install .

                pyinstaller --onefile --collect-all=vol.py vol.py
                pyinstaller --onefile --collect-all=volshell.py volshell.py

                #pyinstaller --onefile --hidden-import=importlib.metadata --collect-all=volatility3 volatility3.py

              # Instalar paquetes necesarios
                #echo ""
                #echo "    Instalando paquetes necesarios..."
                #echo ""
                #sudo apt-get -y update
                #sudo apt-get -y install python3
                #sudo apt-get -y install python3-pip
                #sudo apt-get -y install python3-setuptools
                #sudo apt-get -y install python3-dev
                #sudo apt-get -y install python3-venv
                #sudo apt-get -y install python3-wheel
                #sudo apt-get -y install python3-distorm3
                #sudo apt-get -y install python3-yara
                #sudo apt-get -y install python3-pillow
                #sudo apt-get -y install python3-openpyxl
                #sudo apt-get -y install python3-ujson
                #sudo apt-get -y install python3-ipython
                #sudo apt-get -y install python3-capstone
                #sudo apt-get -y install python3-pycryptodome          # Anterior pycrypto
                #sudo apt-get -y install python3-pytz-deprecation-shim # Anterior python3-pytz                sudo apt-get -y install build-essential

                
                #sudo apt-get -y install liblzma-dev

                #sudo apt-get -y install git
                #sudo apt-get -y install libraw1394-11
                #sudo apt-get -y install libcapstone-dev
                #sudo apt-get -y install capstone-tool
                #sudo apt-get -y install tzdata


                #sudo apt-get -y install libpython3-dev

              # Desactivar el entorno virtual
                echo ""
                echo "    Desactivando el entorno virtual..."
                echo ""
                deactivate

              # Copiar los binarios compilados a la carpeta de binarios del usuario
                echo ""
                echo "    Copiando los binarios a la carpeta /usr/bin/"
                echo ""
                sudo rm -f /usr/bin/volatility3
                sudo cp -vf /tmp/PythonVirtualEnvironments/volatility3/code/dist/vol      /usr/bin/volatility3
                sudo rm -f /usr/bin/volatility3shell
                sudo cp -vf /tmp/PythonVirtualEnvironments/volatility3/code/dist/volshell /usr/bin/volatility3shell
                cd ~

              # Notificar fin de ejecución del script
                echo ""
                echo -e "${cColorVerde}    La instalación ha finalizado. Se han copiado las herramientas a /usr/bin/ ${cFinColor}"
                echo -e "${cColorVerde}    Puedes ejecutarlas de la siguiente forma: ${cFinColor}"
                echo ""
                echo -e "${cColorVerde}      volatility3 [Parámetros]${cFinColor}"
                echo ""

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
