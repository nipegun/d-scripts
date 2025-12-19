#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar el servidor de bases MongoDB en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Servidor-BBDD-MongoDB-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Servidor-BBDD-MongoDB-Instalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ParaCLI/Servidor-BBDD-MongoDB-Instalar.sh | nano -
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
  echo "  Iniciando el script de instalación del servidor MongoDB para Debian 13 (x)..." 
  echo ""

  echo ""
  echo "  Comandos para Debian 13 todavía no preparados. Por ahora, MongoDB es estable en Debian 12."
  echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor MongoDB para Debian 12 (Bookworm)..." 
  echo ""

  echo ""
  echo "    Determinando el número de la última versión estable de MongoDB Community..." 
  echo ""
  # Comprobar si el paquete jq está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s jq 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo -e "${cColorRojo}      El paquete jq no está instalado. Iniciando su instalación...${cFinColor}"
     echo ""
     sudo apt-get -y update
     sudo apt-get -y install jq
     echo ""
   fi
  curl -sL http://downloads.mongodb.org.s3.amazonaws.com/current.json | jq -r '.versions[].downloads[] | select(.arch == "x86_64" and .edition == "targeted" and .target == "debian12") | .packages' > /tmp/PaquetesDebianMondoDBCommunity.json
  vUltSubVersMongoDBCommunity=$(cat /tmp/PaquetesDebianMondoDBCommunity.json | grep server | grep -vE 'velopment|esting' | cut -d'"' -f2 | cut -d'_' -f2 | head -n1)
  echo ""
  echo "      La última versión estable de MongoDB Community es la $vUltSubVersMongoDBCommunity"
  echo ""
  # Calcular la versión sin subversión
    vUltVersMainMongoDBCommunity=$(echo $vUltSubVersMongoDBCommunity | cut -d '.' -f1-2)

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install dialog
      echo ""
    fi

  # Crear el menú
    menu=(dialog --checklist "Instalación de MongoDB - Indica la versión:" 22 96 16)
      opciones=(
        1 "Instalar la versión $vUltSubVersMongoDBCommunity desde el repositorio de MongoDB" on
        2 "Instalar la versión $vUltSubVersMongoDBCommunity desde el archivo .deb"           off
        3 "Instalar la última versión disponible en los repositorios de Debian"              off
        4 "  Verificar el estado de la conexión con la base de datos"                        off
        5 "  Activar el acceso desde todas las IPs"                                          off
        6 "  Securizar la instalación"                                                       off
      )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "    Instalando la versión $vUltSubVersMongoDBCommunity desde el repositorio de MongoDB..."
            echo ""

            vUltVersMainMongoDBCommunity='8.0'

            # Instalar el repositorio
              # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}    El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install curl
                  echo ""
                fi
              # Comprobar si el paquete gnupg está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s gnupg 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}    El paquete gnupg no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install gnupg
                  echo ""
                fi
              curl -fsSL https://www.mongodb.org/static/pgp/server-"$vUltVersMainMongoDBCommunity".asc | sudo gpg -o /usr/share/keyrings/mongodb-server-"$vUltVersMainMongoDBCommunity".gpg --dearmor

            # Instalar la llave para firmar el repositorio
              echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-$vUltVersMainMongoDBCommunity.gpg ] http://repo.mongodb.org/apt/debian bookworm/mongodb-org/$vUltVersMainMongoDBCommunity main" | sudo tee /etc/apt/sources.list.d/mongodb-org-$vUltVersMainMongoDBCommunity.list

            # Actualizar la lista de paquetes disponibles en todos los repositorios instalados en el sistema
              sudo apt-get -y update

            # Instalar el servidor MondoDB
              sudo apt-get -y install mongodb-org

            # Activar y ejecutar el servicio
              echo ""
              echo "  Activando el servicio..." 
              echo ""
              sudo systemctl enable mongod.service --now

            # Notificar el fin de la instalación
              echo ""
              echo "    Instalación finalizada."
              echo "      Los archivos se guardan en: /var/lib/mongodb"
              echo "      Los logs se guardan en: /var/log/mongodb"
              echo ""

            # Mostrar estado del servicio
              echo ""
              echo "  Mostrando estado del servicio..."
              echo ""
              systemctl status mongod.service --no-pager

          ;;

          2)

            echo ""
            echo "  Instalar la versión $vUltSubVersMongoDBCommunity desde el archivo .deb..."
            echo ""

            # Obtener el enlace de descarga del paquete .deb
              echo "" 
              echo "    Obteniendo el enlace de descarga del paquete.deb..."
              echo ""
              vEnlaceDescargaPaqueteDeb=$(cat /tmp/PaquetesDebianMondoDBCommunity.json | grep server | grep -vE 'velopment|esting' | cut -d'"' -f2 | head -n1)
              echo ""
              echo "      En enlace de descarga del paquete .deb es: $vEnlaceDescargaPaqueteDeb"
              echo ""

            # Guardar versión main
              vUltVersMainMongoDBCommunity=$(echo $vEnlaceDescargaPaqueteDeb | cut -d'/' -f9)

            # Descargar el paquete:
              echo ""
              echo "    Descargando el paquete..."
              echo ""
              sudo mkdir -p /root/SoftInst/MongoDBCommunity/ 2> /dev/null
              sudo cd /root/SoftInst/MongoDBCommunity/
              # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo -e "${cColorRojo}    El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
                  echo ""
                  sudo apt-get -y update
                  sudo apt-get -y install curl
                  echo ""
                fi
              sudo curl -L $vEnlaceDescargaPaqueteDeb -o /root/SoftInst/MongoDBCommunity/MondoDBCommunityServer.deb

            # Instalar el paquete
              echo ""
              echo "    Instalando el paquete .deb..."
              echo ""
              sudo apt -y install /root/SoftInst/MongoDBCommunity/MongoDBCommunityServer.deb

            # Instalar Mongo Community Shell
              echo ""
              echo "    Descargando e instalando Mongo Community Shell"
              echo ""
              sudo curl -L https://repo.mongodb.org/apt/debian/dists/bookworm/mongodb-org/$vUltVersMainMongoDBCommunity/main/binary-amd64/mongodb-org-shell_"$vUltSubVersMongoDBCommunity"_amd64.deb -o /root/SoftInst/MongoDBCommunity/MongoDBCommunityShell.deb 
              echo ""
              sudo apt -y install /root/SoftInst/MongoDBCommunity/MongoDBCommunityShell.deb

          # Activar y ejecutar el servicio
            echo ""
            echo "  Activando el servicio..." 
            echo ""
            systemctl enable mongod.service --now

          ;;

          3)

            echo ""
            echo "  Instalando la última versión disponible en los repositorios de Debian..."
            echo ""

          ;;

          4)

            echo ""
            echo "  Verificando el estado de la conexión con la base de datos..." 
            echo ""
            echo "  0 = Incorrecta."
            echo "  1 = Correcta"
            echo ""
            mongo --quiet --eval 'db.runCommand({ connectionStatus: 1 })' | jq .ok

          ;;

          5)

            echo ""
            echo "  Activando el acceso desde todas las IPs..."
            echo ""
            echo "    Si luego no quieres esto, edita el archivo /etc/mongod.conf"
            echo '    y cambia la línea IP en la parte que dice "bindIp: 0.0.0.0".'
            echo ""
            sed -i -e 's|bindIp: 127.0.0.1|bindIp: 0.0.0.0|g' /etc/mongod.conf

            # Reiniciar el servicio
              echo ""
              echo "  Reiniciando el servicio..." 
              echo ""
              systemctl daemon-reload
              systemctl restart mongod

          ;;

          6)

            echo ""
            echo "  Securizando instalación..."
            echo ""

            # Activar la autenticación de usuarios
              echo ""
              echo "    Activando la autenticación de usuarios..." 
              echo ""
              sed -i -e 's|#security:|security:\n  authorization: enabled|g' /etc/mongod.conf

            # Crear el usuario con privilegios de administración
              echo ""
              echo "  Creando el usuario con privilegios de administración..." 
              echo ""
              echo 'use admin'                            > /tmp/CrearUsuariosMongoDB.js
              echo ''                                    >> /tmp/CrearUsuariosMongoDB.js
              echo 'db.createUser({'                     >> /tmp/CrearUsuariosMongoDB.js
              echo '  user: "root",'                     >> /tmp/CrearUsuariosMongoDB.js
              echo '  pwd: "rootMongoDB",'               >> /tmp/CrearUsuariosMongoDB.js
              echo '  roles: ['                          >> /tmp/CrearUsuariosMongoDB.js
              echo '    {'                               >> /tmp/CrearUsuariosMongoDB.js
              echo '      role: "userAdminAnyDatabase",' >> /tmp/CrearUsuariosMongoDB.js
              echo '      db: "admin"'                   >> /tmp/CrearUsuariosMongoDB.js
              echo '    }'                               >> /tmp/CrearUsuariosMongoDB.js
              echo '    ,"readWriteAnyDatabase"'         >> /tmp/CrearUsuariosMongoDB.js
              echo '  ]'                                 >> /tmp/CrearUsuariosMongoDB.js
              echo '})'                                  >> /tmp/CrearUsuariosMongoDB.js
              mongosh --quiet < /tmp/CrearUsuariosMongoDB.js
              echo ""
              echo "  Se ha creado el usuario root con contraseña rootMySQL."
              echo ""
              echo "  Para cambiarle la contraseña lanza mongosh como root ejecuta:"
              echo ""
              echo "  use admin"
              echo '  db.changeUserPassword("root", passwordPrompt())'
              echo ""

            # Reiniciar el servicio
              echo ""
              echo "  Reiniciando el servicio..." 
              echo ""
              systemctl daemon-reload
              systemctl restart mongod

          ;;

      esac

  done

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor MongoDB para Debian 11 (Bullseye)..." 
  echo ""

  echo ""
  echo "  Determinando el número de la última versión de MongoDB..." 
  echo ""
  UltVersMongoDB=$(curl -sL https://repo.mongodb.org/apt/debian/dists/buster/mongodb-org/ | grep href | grep -v velopmen | grep -v esti | grep -v arent | tail -n1 | cut -d "'" -f2)
  echo "  La última versión de MongoDB es la $UltVersMongoDB"

  echo ""
  echo "  Instalando dependencias..." 
  echo ""
  apt-get -y update
  apt-get -y install ca-certificates
  apt-get -y install curl
  apt-get -y install jq

  echo ""
  echo "  Agregando la clave GPG..." 
  echo ""
  # Comprobar si el paquete gnupg está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s gnupg 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  gnupg no está instalado. Iniciando su instalación..."       echo ""
       apt-get -y update
       apt-get -y install gnupg
       echo ""
     fi
  curl -fsSL https://www.mongodb.org/static/pgp/server-$UltVersMongoDB.asc | apt-key add -
  
  echo ""
  echo "  Agregando el repositorio..." 
  echo ""
  # Comprobar si el paquete lsb-release está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s lsb-release 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  lsb-release no está instalado. Iniciando su instalación..."       echo ""
       apt-get -y update
       apt-get -y install lsb-release
       echo ""
     fi
  VersDebian=$(lsb_release -cs)
  echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/$UltVersMongoDB main" > /etc/apt/sources.list.d/mongodb-$UltVersMongoDB.list
  #echo "deb http://repo.mongodb.org/apt/debian $VersDebian/mongodb-org/$UltVersMongoDB main" > /etc/apt/sources.list.d/mongodb-$UltVersMongoDB.list

  echo ""
  echo "  Instalando paquetes..." 
  echo ""
  apt-get -y update
  apt-get -y install mongodb-org

  echo ""
  echo "  Activando el servicio..." 
  echo ""
  systemctl enable mongod --now

  echo ""
  echo "  Verificando el estado de la conexión con la base de datos..." 
  echo ""
  echo "  0 = Incorrecta."
  echo "  1 = Correcta"
  echo ""
  mongo --quiet --eval 'db.runCommand({ connectionStatus: 1 })' | jq .ok

  echo ""
  echo "  Activando la autenticación de usuarios..." 
  echo ""
  sed -i -e 's|#security:|security:\n  authorization: enabled|g' /etc/mongod.conf

  echo ""
  echo "  Activando el acceso desde todas las IPs..." 
  echo ""
  echo "  Si no quieres esto, edita el archivo /etc/mongod.conf"
  echo '  y cambia la línea IP en la parte que dice "bindIp: 0.0.0.0".'
  echo ""
  sed -i -e 's|bindIp: 127.0.0.1|bindIp: 0.0.0.0|g' /etc/mongod.conf

  echo ""
  echo "  Reiniciando el servicio..." 
  echo ""
  systemctl restart mongod

  echo ""
  echo "  Creando el usuario con privilegios de administración..." 
  echo ""
  echo 'use admin'                            > /tmp/CrearUsuariosMongoDB.js
  echo ''                                    >> /tmp/CrearUsuariosMongoDB.js
  echo 'db.createUser({'                     >> /tmp/CrearUsuariosMongoDB.js
  echo '  user: "root",'                     >> /tmp/CrearUsuariosMongoDB.js
  echo '  pwd: "rootMongoDB",'               >> /tmp/CrearUsuariosMongoDB.js
  echo '  roles: ['                          >> /tmp/CrearUsuariosMongoDB.js
  echo '    {'                               >> /tmp/CrearUsuariosMongoDB.js
  echo '      role: "userAdminAnyDatabase",' >> /tmp/CrearUsuariosMongoDB.js
  echo '      db: "admin"'                   >> /tmp/CrearUsuariosMongoDB.js
  echo '    }'                               >> /tmp/CrearUsuariosMongoDB.js
  echo '    ,"readWriteAnyDatabase"'         >> /tmp/CrearUsuariosMongoDB.js
  echo '  ]'                                 >> /tmp/CrearUsuariosMongoDB.js
  echo '})'                                  >> /tmp/CrearUsuariosMongoDB.js
  mongosh --quiet < /tmp/CrearUsuariosMongoDB.js
  echo ""
  echo "  Se ha creado el usuario root con contraseña rootMySQL."
  echo ""
  echo "  Para cambiarle la contraseña lanza mongosh como root ejecuta:"
  echo ""
  echo "  use admin"
  echo '  db.changeUserPassword("root", passwordPrompt())'
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor MongoDB para Debian 10 (Buster)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor MongoDB para Debian 9 (Stretch)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor MongoDB para Debian 8 (Jessie)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación del servidor MongoDB para Debian 7 (Wheezy)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

fi

