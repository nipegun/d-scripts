#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar el servidor de bases MongoDB en Debian
#
# Ejecución remota
# curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-MongoDB-Instalar.sh | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

## Determinar la versión de Debian

   if [ -f /etc/os-release ]; then
       # Para systemd y freedesktop.org
       . /etc/os-release
       cNomSO=$NAME
       cVerSO=$VERSION_ID
   elif type lsb_release >/dev/null 2>&1; then
       # linuxbase.org
       cNomSO=$(lsb_release -si)
       cVerSO=$(lsb_release -sr)
   elif [ -f /etc/lsb-release ]; then
       # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       cNomSO=$DISTRIB_ID
       cVerSO=$DISTRIB_RELEASE
   elif [ -f /etc/debian_version ]; then
       # Para versiones viejas de Debian.
       cNomSO=Debian
       cVerSO=$(cat /etc/debian_version)
   else
       # Para el viejo uname (También funciona para BSD)
       cNomSO=$(uname -s)
       cVerSO=$(uname -r)
   fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor MongoDB para Debian 7 (Wheezy)..."
  echo "-------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor MongoDB para Debian 8 (Jessie)..."
  echo "-------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""

  echo "  Iniciando el script de instalación del servidor MongoDB para Debian 9 (Stretch)..."

  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""

  echo "  Iniciando el script de instalación del servidor MongoDB para Debian 10 (Buster)..."

  echo ""

  echo ""
  echo "  Determinando el número de la última versión de MongoDB..."
  echo ""
  UltVersMongoDB=$(curl -s https://repo.mongodb.org/apt/debian/dists/buster/mongodb-org/ | grep href | grep -v velopmen | grep -v esti | grep -v arent | tail -n1 | cut -d "'" -f2)
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
  ## Comprobar si el paquete gnupg está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s gnupg 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  gnupg no está instalado. Iniciando su instalación..."
       echo ""
       apt-get -y update
       apt-get -y install gnupg
       echo ""
     fi
  curl -fsSL https://www.mongodb.org/static/pgp/server-$UltVersMongoDB.asc | apt-key add -
  
  echo ""
  echo "  Agregando el repositorio..."
  echo ""
  ## Comprobar si el paquete lsb-release está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s lsb-release 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  lsb-release no está instalado. Iniciando su instalación..."
       echo ""
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

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor MongoDB para Debian 11 (Bullseye)..."
  echo "----------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Determinando el número de la última versión de MongoDB..."
  echo ""
  UltVersMongoDB=$(curl -s https://repo.mongodb.org/apt/debian/dists/buster/mongodb-org/ | grep href | grep -v velopmen | grep -v esti | grep -v arent | tail -n1 | cut -d "'" -f2)
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
  ## Comprobar si el paquete gnupg está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s gnupg 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  gnupg no está instalado. Iniciando su instalación..."
       echo ""
       apt-get -y update
       apt-get -y install gnupg
       echo ""
     fi
  curl -fsSL https://www.mongodb.org/static/pgp/server-$UltVersMongoDB.asc | apt-key add -
  
  echo ""
  echo "  Agregando el repositorio..."
  echo ""
  ## Comprobar si el paquete lsb-release está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s lsb-release 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  lsb-release no está instalado. Iniciando su instalación..."
       echo ""
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

fi

