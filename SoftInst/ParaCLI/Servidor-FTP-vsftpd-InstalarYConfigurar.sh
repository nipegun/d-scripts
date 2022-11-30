#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para instalar y configurar vsftpd en Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-FTP-vsftpd-InstalarYConfigurar.sh | bash
#
#  Ejecución remota sin caché:
#  curl -s -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-FTP-vsftpd-InstalarYConfigurar.sh | bash
#
#  Ejecución remota con parámetros:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-FTP-vsftpd-InstalarYConfigurar.sh | bash -s Parámetro1 Parámetro2
# ----------

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
  fi

# Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${vColorRojo}curl no está instalado. Iniciando su instalación...${vFinColor}"
    echo ""
    apt-get -y update && apt-get -y install curl
    echo ""
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    OS_NAME=$NAME
    OS_VERS=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    OS_NAME=$(lsb_release -si)
    OS_VERS=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    OS_NAME=$DISTRIB_ID
    OS_VERS=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    OS_NAME=Debian
    OS_VERS=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    OS_NAME=$(uname -s)
    OS_VERS=$(uname -r)
  fi

if [ $OS_VERS == "7" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de vsftpd para Debian 7 (Wheezy)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de vsftpd para Debian 8 (Jessie)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de vsftpd para Debian 9 (Stretch)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de vsftpd para Debian 10 (Buster)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}Iniciando el script de instalación de vsftpd para Debian 11 (Bullseye)...${vFinColor}"
  echo ""

  echo ""
  echo "  Actualizando la lista de los paquetes disponibles en los repositorios..."
  echo ""
  apt-get -y update

  echo ""
  echo "  Instalando el paquete vsftpd..."
  echo ""
  apt-get -y update

  echo ""
  echo "  Efectuando cambios en la configuración..."
  echo ""
  # 
  sed -i -e 's-#write_enable=YES-write_enable=YES-g'                                                 /etc/vsftpd.conf
  sed -i -e 's-#chroot_local_user=YES-chroot_local_user=YES-g'                                       /etc/vsftpd.conf
  sed -i -e 's-#chroot_list_enable=YES-chroot_list_enable=YES-g'                                     /etc/vsftpd.conf
  echo "allow_writeable_chroot=YES" >>                                                               /etc/vsftpd.conf
  sed -i -e 's-#chroot_list_file=/etc/vsftpd.chroot_list-chroot_list_file=/etc/vsftpd.chroot_list-g' /etc/vsftpd.conf
  sed -i -e 's-#ls_recurse_enable=YES-ls_recurse_enable=YES-g'                                       /etc/vsftpd.conf

  # Especificar cual es la carpeta pública. Si no se especifica, el directorio home del usuario sería la carpeta FTP home
    echo "local_root=public_html" >>                                                               /etc/vsftpd.conf


  # Activar escritura
    write_enable=YES
  
  # Activar el logueo de los usuarios del sistema
    local_enable=YES
    allow_writeable_chroot=YES

  # Agregar usuarios a los que vamos a permitir moverse por su carpeta home
    touch /etc/vsftpd.chroot_list
    echo "ubuntu" > /etc/vsftpd.chroot_list 

  # Modificar mensaje de bienvenida
    sed -i -e 's-#ftpd_banner=Welcome to blah FTP service-ftpd_banner=Bienvenido al servidor FTP-g'   /etc/vsftpd.conf
    systemctl restart vsftpd

  # Activar navegación anónima
    sed -i -e 's-anonymous_enable=NO-anonymous_enable=YES-g' /etc/vsftpd.conf
    systemctl restart vsftpd

  # Activar enjaulado de usuarios
    sed -i -e 's|#chroot_local_user=YES|chroot_local_user=YES|g' /etc/vsftpd.conf
    
  # Activar conexión mediante SSL
    openssl req -x509 -nodes -newkey rsa:2048 -days 365 -keyout /etc/ssl/private/vsftpd.key -out /etc/ssl/certs/vsftpd.pem
    chmod 600 vsftpd.pem 
    sed -i -e 's|rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem|rsa_cert_file=/etc/ssl/certs/vsftpd.pem|g'                   /etc/vsftpd.conf
    sed -i -e 's|rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key|rsa_private_key_file=/etc/ssl/private/vsftpd.key|g' /etc/vsftpd.conf
    sed -i -e 's|ssl_enable=NO|ssl_enable=YES|g'                                                                                 /etc/vsftpd.conf
    echo "ssl_ciphers=HIGH"           >> /etc/vsftpd.conf
    echo "force_local_data_ssl=YES"   >> /etc/vsftpd.conf
    echo "force_local_logins_ssl=YES" >> /etc/vsftpd.conf
    systemctl restart vsftpd 

  # Activar modo Dios
    # Si la directiva chroot_local_user está configurada como YES, la lista se convierte en una lista de excepción
    sed -i -e 's|#chroot_local_user=YES|chroot_local_user=YES|g'                                       /etc/vsftpd.conf
    sed -i -e 's|#chroot_list_enable=YES|chroot_list_enable=YES|g'                                     /etc/vsftpd.conf
    sed -i -e 's|#chroot_list_file=/etc/vsftpd.chroot_list|chroot_list_file=/etc/vsftpd.chroot_list|g' /etc/vsftpd.conf
    touch /etc/vsftpd.chroot_list
    

fi
