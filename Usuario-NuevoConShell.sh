#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para agregar usuarios nuevos con shell a Debian
# ----------

cCantArgEsperados=1

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'


if [ $# -ne $cCantArgEsperados ]
  then
    echo ""
    echo "------------------------------------------------------------------"
    echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
    echo ""
    echo -e "$0 ${cColorVerde}[NombreDeUsuario]${cFinColor}"
    echo ""
    echo "Ejemplo:"
    echo " $0 pepe"
    echo "------------------------------------------------------------------"
    echo ""
    exit
  else
    # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo "  dialog no está instalado. Iniciando su instalación..."
        echo ""
        apt-get -y update && apt-get -y install dialog > /dev/null
        echo ""
      fi
    cmd=(dialog --checklist "Opciones del script:" 22 76 16)
    options=(
      1 "Crear el usuario" on
      2 "Crear la carpeta del usuario con permisos estándar usuario" on
      3 "Denegar el acceso a la carpeta de usuario a otros usuarios" off
      4 "Compartir la carpeta de usuario mediante Samba" off
      5 "Otras opciones" off
    )
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    clear
    for choice in $choices
    do
      case $choice in
        1)
          echo ""
          echo -e "${cColorVerde}Creando el usuario $1...${cFinColor}"
          echo ""
          useradd -d /home/$1/ -s /bin/bash $1
        ;;

        2)
          echo ""
          echo -e "${cColorVerde}Creando la carpeta del usuario con permisos estándar...${cFinColor}"
          echo ""
          mkdir /home/$1/
          chown $1:$1 /home/$1/ -R
          find /home/$1 -type d -exec chmod 775 {} \;
          find /home/$1 -type f -exec chmod 664 {} \;
        ;;

        3)
          echo ""
          echo -e "${cColorVerde}Denegando el acceso a la carpeta /home/$1 a los otros usuarios...${cFinColor}"
          echo ""
          find /home/$1 -type d -exec chmod 750 {} \;
          find /home/$1 -type f -exec chmod 660 {} \;
        ;;
    
        4)
          echo ""
          echo -e "${cColorVerde}Creando la compartición Samba para la carpeta de usuario...${cFinColor}"
          echo ""
          echo "[$1]"                               >> /etc/samba/smb.conf
          echo "  path = /home/$1/"                 >> /etc/samba/smb.conf
          echo "  comment = Carpeta del usuario $1" >> /etc/samba/smb.conf
          echo "  browsable = yes"                  >> /etc/samba/smb.conf
          echo "  read only = no"                   >> /etc/samba/smb.conf
          echo "  valid users = $1"                 >> /etc/samba/smb.conf
          echo ""
          echo -e "${cColorRojo}Ahora deberás ingresar 2 veces la nueva contraseña samba para el usuario $1.${cFinColor}"
          echo -e "${cColorRojo}Puede ser distinta a la de la propia cuenta de usuario. Pero si pones una${cFinColor}"
          echo -e "${cColorRojo}distinta, cuando te conectes a la carpeta compartida, acuérdate de utilizar${cFinColor}"
          echo -e "${cColorRojo}la contraseña que pongas ahora y no la de la cuenta de usuario.${cFinColor}"
          echo ""
          smbpasswd -a $1
        ;;

        5)
       
        ;;

      esac

    done

fi

