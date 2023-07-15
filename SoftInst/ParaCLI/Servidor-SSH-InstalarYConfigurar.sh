#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar el servidor OpenSSH en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-SSH-InstalarYConfigurar.sh | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
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

if [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 7 (Wheezy)..."  
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 8 (Jessie)..."  
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 9 (Stretch)..."  
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 10 (Buster)..."  
  echo ""

  echo ""
  echo -e "${cColorRojo}  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de xxxxxxxxx para Debian 11 (Bullseye)..."  
  echo ""

  # Comprobar si el paquete openssh-server está instalado.
    if [[ $(dpkg-query -s openssh-server 2>/dev/null | grep installed) != "" ]]; then
      echo ""
      echo "  El paquete openssh-server ya está instalado."
      echo "  Es posible que este equipo ya tenga un servidor SSH en funcionamiento."
      echo ""
      echo "  Escribe ok y presiona Enter para destruir la instalación anterior y generar una nueva:"
      echo ""
      read -p "" vProceder
      echo ""
    else
      vProceder="ok"
    fi

  if [ $vProceder == "ok" ]; then

    # Comprobar si el paquete tasksel está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s tasksel 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}  tasksel no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        apt-get -y update && apt-get -y install tasksel
        echo ""
      fi
    tasksel install ssh-server
    #apt-get -y install sshpass

    # Implementar Autenticación de dos factores
      apt-get -y update
      apt-get -y install libpam0g-dev
      apt-get -y install make
      apt-get -y install gcc
      apt-get -y install wget
      apt-get -y install ssh
      apt-get -y install libpam-google-authenticator
      # Modificar /etc/pam.d/sshd
        echo "auth required pam_google_authenticator.so"        >> /etc/pam.d/sshd
        sed -i -e 's|@include common-auth|#@include common-auth|g' /etc/pam.d/sshd
      # Modificar /etc/ssh/sshd_config
        sed -i -e 's|PasswordAuthentication yes|PasswordAuthentication no|'g             /etc/ssh/sshd_config
        sed -i -e 's|KbdInteractiveAuthentication no|KbdInteractiveAuthentication yes|'g /etc/ssh/sshd_config
        #echo "ChallengeResponseAuthentication yes" >>                                    /etc/ssh/sshd_config # Obsoleto en Ubuntu 22.04
        echo "AuthenticationMethods publickey,keyboard-interactive" >>                   /etc/ssh/sshd_config
        #AuthenticationMethods any
    
      echo ""
      echo "  A continuación se te mostrará un código QR que deberás escanear con la app Google Authenticator de tu dispositivo."
      echo "  Inmediatamente después se te solicitará ingresar un código proporcionado por la app."
      echo "    Es el código que te aparecerá en la sección $(cat /etc/hostname) "
      echo "  Si ingresas el código correcto se te proporcionará la llave privada y los códigos de recuperación."
      echo "    Deberás tomar nota de ambos y guardarlos en un lugar seguro."
      echo ""
      read -p "  Presiona ENTER para proceder..."
      echo ""
      su %1 -c "google-authenticator"

    # Enjaular usuarios
      echo "Match Group enjaulados"              >> /etc/ssh/sshd_config
      echo "  ChrootDirectory /home"             >> /etc/ssh/sshd_config
      echo "  AllowTCPForwarding no"             >> /etc/ssh/sshd_config
      echo "  X11Forwarding no"                  >> /etc/ssh/sshd_config
      echo "  ForceCommand internal-sftp -u 002" >> /etc/ssh/sshd_config
      echo ""


    fi
 
fi

