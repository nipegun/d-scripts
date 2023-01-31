#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para securizar el servidor SSH por defecto de Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SSH-Servidor-Securizar.sh | bash
# ----------

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${vColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${vFinColor}" >&2
    exit 1
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
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de securización de SSH para Debian 7 (Wheezy)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "8" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de securización de SSH para Debian 8 (Jessie)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "9" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de securización de SSH para Debian 9 (Stretch)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "10" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de instalación de securización de SSH para Debian 10 (Buster)...${vFinColor}"
  echo ""

  echo ""
  echo -e "${vColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${vFinColor}"
  echo ""

elif [ $OS_VERS == "11" ]; then

  echo ""
  echo -e "${vColorAzulClaro}  Iniciando el script de securización de SSH para Debian 11 (Bullseye)...${vFinColor}"
  echo ""

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${vColorRojo}    dialog no está instalado. Iniciando su instalación...${vFinColor}"
      echo ""
      apt-get -y update && apt-get -y install dialog
      echo ""
    fi

  menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
    opciones=(
      1 "Ejecutar securización básica (mandatorio)." on
      2 "Activar la autenticación mediante clave público/privada." on
      3 "Limitar la autenticación a sólo mediante clave público/privada." off
      4 "Implementar autenticación de doble factor." off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Ejecutando securización básica..."
            echo ""
            echo "    Los cambios serán los siguientes:"
            echo ""
            echo "    - Se cambiará el puerto del 2 al 22222"
            echo "    - Se deshabilitará el logueo con la cuenta del root"
            echo "    - Se limitará el tiempo para introducir la contraseña a 15 segundos"
            echo "    - Se limitará el ingreso de contraseña incorrecta a sólo 3 veces."
            echo "    - Se denegará permanentemente el acceso a los usuarios mortadelo y filemon"
            echo ""
            # Cambiar el puerto
              sed -i -e 's|#Port 22|Port 22222|g' /etc/ssh/sshd_config
            # Deshabilitar el logueo del root
              sed -i -e 's|PermitRootLogin yes|PermitRootLogin no|g' /etc/ssh/sshd_config
            # Configurar el tiempo máximo para introducir la contraseña en 15 segundos
              sed -i -e 's|#LoginGraceTime 2m|LoginGraceTime 15|g' /etc/ssh/sshd_config
            # Limitar ingresar la contraseña mal a sólo 3 veces
              sed -i -e 's|#MaxAuthTries 6|MaxAuthTries 3|g' /etc/ssh/sshd_config
            # Denegar ssh a los usuarios mortadelo y filemon
              echo -e "DenyUsers\tmortadelo\tfilemon" >> /etc/ssh/sshd_config
            # Reiniciar el servidor SSH
              systemctl restart ssh.service

          ;;

          2)

            echo ""
            echo "  Activando la autenticación mediante clave público/privada..."
            echo ""
            # Activar la autenticación mediante llave pública
              sed -i -e 's|#PubkeyAuthentication yes|PubkeyAuthentication yes|g' /etc/ssh/sshd_config
            # Crear el usuario tecnico
              useradd -d /home/tecnico/ -s /bin/bash -p $(openssl passwd -1 Contra123) tecnico
              mkdir /home/tecnico/ 2> /dev/null
              chown tecnico:tecnico /home/$1/ -R
              find /home/tecnico -type d -exec chmod 750 {} \;
              find /home/tecnico -type f -exec chmod 664 {} \;
            # Reiniciar el servidor SSH
              systemctl restart ssh.service
            echo ""
            echo "    Recuerda crear las llaves SSH en el cliente ejecutando:"
            echo "      ssh-keygen -t rsa -b 4096"
            echo ""
            echo "      El comando creará dos archivos en el cliente:"
            echo "      - /home/usuario/.ssh/id_rsa     (clave privada)"
            echo "      - /home/usuario/.ssh/id_rsa.pub (clave pública)"
            echo ""
            echo "        Deberás meter el contenido del archivo id_rsa.pub del cliente"
            echo "        dentro del archivo ~/.ssh/authorized_keys de la cuenta de usuario del servidor."
            echo '        Por ejemplo, para copiar la primer id dentro del usuario "tecnico" del servidor, ejecuta en el cliente:'
            echo "          ssh-copy-id ssh://tecnico@IPdelServidorSSH:22222"
            echo "          o"
            echo "          scp -P 22222 ~/.ssh/id_rsa.pub tecnico@IPdelServidorSSH:~/.ssh/authorized_keys"
            echo "          ↑↑↑↑↑↑↑↑↑    - No crea la carpeta ~/.ssh/ (si no existe, fallará)    ↑↑↑↑↑↑↑↑↑"
            echo ""
            echo '          Para copiar la segunda ID y siguientes, ejecuta:'
            echo "            cat ~/.ssh/id_rsa.pub | ssh -p 22222 tecnico@IPdelServidorSSH 'cat >> ~/.ssh/authorized_keys'"
            echo ""
            echo "    NOTA: Aunque éste método te evite tener que poner la contraseña SSH del servidor,"
            echo "    la conexión seguirá pidiendo la contraseña de la clave privada del cliente."
            echo ""

          ;;

          3)

            echo ""
            echo "  Limitando la autenticación a sólo mediante clave público/privada..."
            echo ""
            sed -i -e 's|#PasswordAuthentication yes|PasswordAuthentication no|g' /etc/ssh/sshd_config
            sed -i -e 's|#PubkeyAuthentication yes|PubkeyAuthentication yes|g'    /etc/ssh/sshd_config

          ;;

          4)

            echo ""
            echo "  Implementando autenticación de doble factor..."
            echo ""
            # Establecer la zona horaria
              echo ""
              echo "    Estableciendo Europe/Madrid como zona horaria..."
              echo ""
              timedatectl set-timezone Europe/Madrid
            # Instalar chrony
              echo ""
              echo "    Instalando chrony..."
              echo ""
              apt-get -y update && apt-get -y install chrony
              # A ejecutar en el cliente:
                # timedatectl -H tecnico@IPDelServidorSSH:22222
                # apt-get -y install  iputils-clockdiff
                # clockdiff -o IPDelServidorSSH
            # Instalar dependencias
              apt-get -y update
              apt-get -y install libpam0g-dev
              apt-get -y install make
              apt-get -y install gcc
              apt-get -y install wget
              apt-get -y install ssh
              apt-get -y install libpam-google-authenticator
            # Ejecutar Google Authenticator con la cuenta de técnico
              echo ""
              echo "    Preparando autenticación OTP..."
              echo ""
              echo "      - Toma nota de la clave privada (Your new secret key is:) y guárdala en un lugar seguro."
              echo "      - Escanea el código QR con la app Google Authenticator y, una vez escaneado,"
              echo "        baja hasta la cuenta que acabas de agregar, toma nota del código e introdúcelo abajo, donde pone:"
              echo '        "Enter code from app:"'
              echo ""
              echo "      - Si el código es correcto, se te presentarán todos los códigos de emergencia."
              echo "        Toma nota de todos ellos y guárdalos también en un lugar seguro."
              echo "      - Luego responde que si a todas las preguntas que te salgan."
              echo ""
              su tecnico -c "google-authenticator"
            # Crear una contraseña para el usuario root
              vRootPass=$(cat /etc/shadow | grep root | cut -d ':' -f2)
              if [ $vRootPass == "" ] || [ $vRootPass == "!" ]; then
                passwd root
              fi
            # Realizar modificaciones (Falta comprobar si funcionan en Debian, en Ubuntu si funciona)
              # echo "auth required pam_google_authenticator.so"                  >> /etc/pam.d/sshd
              # sed -i -e 's/@include common-auth/#@include common-auth/g'           /etc/pam.d/sshd
              # sed -i -e 's|PasswordAuthentication yes|PasswordAuthentication no|g'             /etc/ssh/sshd_config
              # sed -i -e 's|KbdInteractiveAuthentication no|KbdInteractiveAuthentication yes|g' /etc/ssh/sshd_config
              # echo "AuthenticationMethods publickey,keyboard-interactive"                   >> /etc/ssh/sshd_config

          ;;

      esac

  done

fi
