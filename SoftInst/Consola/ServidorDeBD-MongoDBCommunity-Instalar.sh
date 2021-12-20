#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar el servidor de bases MongoDB en Debian
#
# Ejecución remota
# curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/Consola/ServidorDeBD-MongoDBCommunity-Instalar.sh | bash
#
#--------------------------------------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

## Determinar la versión de Debian

   if [ -f /etc/os-release ]; then
       # Para systemd y freedesktop.org
       . /etc/os-release
       OS_NAME=$NAME
       OS_VERS=$VERSION_ID
   elif type lsb_release >/dev/null 2>&1; then
       # linuxbase.org
       OS_NAME=$(lsb_release -si)
       OS_VERS=$(lsb_release -sr)
   elif [ -f /etc/lsb-release ]; then
       # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       OS_NAME=$DISTRIB_ID
       OS_VERS=$DISTRIB_RELEASE
   elif [ -f /etc/debian_version ]; then
       # Para versiones viejas de Debian.
       OS_NAME=Debian
       OS_VERS=$(cat /etc/debian_version)
   else
       # Para el viejo uname (También funciona para BSD)
       OS_NAME=$(uname -s)
       OS_VERS=$(uname -r)
   fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor MongoDB para Debian 7 (Wheezy)..."
  echo "-------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo "-------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor MongoDB para Debian 8 (Jessie)..."
  echo "-------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor MongoDB para Debian 9 (Stretch)..."
  echo "--------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian."
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo "--------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor MongoDB para Debian 10 (Buster)..."
  echo "--------------------------------------------------------------------------------------"
  echo ""

  echo ""
  echo "  Instalando dependencias..."
  echo ""
  apt-get -y update
  apt-get -y install dirmngr
  apt-get -y install gnupg
  apt-get -y install apt-transport-https
  apt-get -y install software-properties-common
  apt-get -y install ca-certificates
  apt-get -y install curl

  echo ""
  echo "  Agregando la clave GPG..."
  echo ""
  curl -fsSL https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
  
  echo ""
  echo "  Agregando el repositorio..."
  echo ""
  add-apt-repository 'deb https://repo.mongodb.org/apt/debian buster/mongodb-org/4.2 main'
  
  echo ""
  echo "  Instalando paquetes..."
  echo ""
  apt-get -y update
  apt-get -y install mongodb-org

  echo ""
  echo "  Activando el servicio..."
  echo ""
  systemctl enable mongod --now







o verify whether the installation has completed successfully, connect to the MongoDB database server using the mongo tool and print the connection status:

mongo --eval 'db.runCommand({ connectionStatus: 1 })'

The output will look like this:

MongoDB shell version v4.2.1
connecting to: mongodb://127.0.0.1:27017/?compressors=disabled&gssapiServiceName=mongodb
Implicit session: session { "id" : UUID("09f11c53-605f-44ad-abec-ec5801bb6b06") }
MongoDB server version: 4.2.1
{
	"authInfo" : {
		"authenticatedUsers" : [ ],
		"authenticatedUserRoles" : [ ]
	},
	"ok" : 1
}

    A value of 1 for the ok field indicates success.

Configuring MongoDB

The MongoDB configuration file is named mongod.conf and is located in the /etc directory. The file is in YAML format.

The default configuration settings are sufficient for most users. However, for production environments, it is recommended to uncomment the security section and enable authorization, as shown below:
/etc/mongod.conf

security:
  authorization: enabled

The authorization option enables Role-Based Access Control (RBAC) that regulates users access to database resources and operations. If this option is disabled, each user can access all databases and perform any action.

After editing the configuration file, restart the mongod service for changes to take effect:

sudo systemctl restart mongod

To find more information about the configuration options available in MongoDB 4.2, visit the Configuration File Options documentation page.
Creating Administrative MongoDB User

If you enabled the MongoDB authentication, you’ll need to create an administrative user that can access and manage the MongoDB instance. To do so, access the mongo shell with:

mongo

From inside the MongoDB shell, type the following command to connect to the admin database:

use admin

switched to db admin

Issue the following command to create a new user named mongoAdmin with the userAdminAnyDatabase role:

db.createUser(
  {
    user: "mongoAdmin", 
    pwd: "changeMe", 
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
)

Successfully added user: {
	"user" : "mongoAdmin",
	"roles" : [
		{
			"role" : "userAdminAnyDatabase",
			"db" : "admin"
		}
	]
}

You can name the administrative MongoDB user as you want.

Exit the mongo shell with:

quit()

To test the changes, access the mongo shell using the administrative user you have previously created:

mongo -u mongoAdmin -p --authenticationDatabase admin

Enter the password when prompted. Once you are inside the MongoDB shell connect to the admin database:

use admin

switched to db admin

Now, print the users with:

show users

{
	"_id" : "admin.mongoAdmin",
	"userId" : UUID("cdc81e0f-db58-4ec3-a6b8-829ad0c31f5c"),
	"user" : "mongoAdmin",
	"db" : "admin",
	"roles" : [
		{
			"role" : "userAdminAnyDatabase",
			"db" : "admin"
		}
	],
	"mechanisms" : [
		"SCRAM-SHA-1",
		"SCRAM-SHA-256"
	]
}












elif [ $OS_VERS == "11" ]; then

  echo ""
  echo "----------------------------------------------------------------------------------------"
  echo "  Iniciando el script de instalación del servidor MongoDB para Debian 11 (Bullseye)..."
  echo "----------------------------------------------------------------------------------------"
  echo ""

  mkdir -p /root/SoftInst/MySQLServer/ 2> /dev/null
  cd /root/SoftInst/MySQLServer/
  NomArchivo=$(curl -s https://dev.mysql.com/downloads/repo/apt/ | grep href | grep deb | cut -d'?' -f2 | cut -d'=' -f2 | cut -d'&' -f1)
  ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  wget no está instalado. Iniciando su instalación..."
       echo ""
       apt-get -y update
       apt-get -y install wget
       echo ""
     fi
  wget https://dev.mysql.com/get/$NomArchivo
  ## Comprobar si el paquete gnupg está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s gnupg 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  gnupg no está instalado. Iniciando su instalación..."
       echo ""
       apt-get -y update
       apt-get -y install gnupg
       echo ""
     fi
  ## Comprobar si el paquete lsb-release está instalado. Si no lo está, instalarlo.
     if [[ $(dpkg-query -s lsb-release 2>/dev/null | grep installed) == "" ]]; then
       echo ""
       echo "  lsb-release no está instalado. Iniciando su instalación..."
       echo ""
       apt-get -y update
       apt-get -y install lsb-release
       echo ""
     fi
  dpkg -i /root/SoftInst/MySQLServer/$NomArchivo
  apt-get update
  apt-get -y install mysql-server
  #mysql-secure-installation
  echo ""
  echo "  Entrando como root a la línea de comandos de MySQL..."
  echo ""
  echo "  Para crear un nuevo usuario ejecuta:"
  echo "  CREATE USER 'username' IDENTIFIED BY 'password';"
  echo ""
  mysql -u root -p
fi

