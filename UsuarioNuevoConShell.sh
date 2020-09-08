#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#---------------------------------------------------------------------
#  Script de NiPeGun para agregar usuarios nuevos con shell a Debian
#---------------------------------------------------------------------

ArgumentosEsperados=1
ArgumentosInsuficientes=65
ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'


if [ $# -ne $ArgumentosEsperados ]
  then
    echo ""
    echo "------------------------------------------------------------------"
    echo -e "${ColorRojo}Mal uso del script.${FinColor} El uso correcto sería:"
    echo ""
    echo -e "$0 ${ColorVerde}[NombreDeUsuario]${FinColor}"
    echo ""
    echo "Ejemplo:"
    echo " $0 pepe"
    echo "------------------------------------------------------------------"
    echo ""
    exit $ArgumentosInsuficientes
  else
    cmd=(dialog --checklist "Opciones del script:" 22 76 16)
    options=(1 "Crear el usuario" on
             2 "Crear la carpeta del usuario con permisos estándar usuario" on
             3 "Denegar el acceso a la carpeta de usuario a otros usuarios" off
             4 "Compartir la carpeta de usuario mediante Samba" off
             5 "Otras opciones" off)
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    clear
    for choice in $choices
    do
      case $choice in
        1)
          echo ""
          echo -e "${ColorVerde}Creando el usuario $1...${FinColor}"
          echo ""
          useradd -d /home/$1/ -s /bin/bash $1
        ;;

        2)
          echo ""
          echo -e "${ColorVerde}Creando la carpeta del usuario con permisos estándar...${FinColor}"
          echo ""
          mkdir /home/$1/
          chown $1:$1 /home/$1/ -R
          find /home/$1 -type d -exec chmod 775 {} \;
          find /home/$1 -type f -exec chmod 664 {} \;
        ;;

        3)
          echo ""
          echo -e "${ColorVerde}Denegando el acceso a la carpeta /home/$1 a los otros usuarios...${FinColor}"
          echo ""
          find /home/$1 -type d -exec chmod 750 {} \;
          find /home/$1 -type f -exec chmod 664 {} \;
        ;;
    
        4)
          echo ""
          echo -e "${ColorVerde}Creando la compartición Samba para la carpeta de usuario...${FinColor}"
          echo ""
          echo "[$1]" >> /etc/samba/smb.conf
          echo "  path = /home/$1/" >> /etc/samba/smb.conf
          echo "  comment = Carpeta del usuario $1" >> /etc/samba/smb.conf
          echo "  browsable = yes" >> /etc/samba/smb.conf
          echo "  read only = no" >> /etc/samba/smb.conf
          echo "  valid users = $1" >> /etc/samba/smb.conf
          echo ""
          echo -e "${ColorRojo}Ahora deberás ingresar 2 veces la nueva contraseña samba para el usuario $1.${FinColor}"
          echo -e "${ColorRojo}Puede ser distinta a la de la propia cuenta de usuario. Pero si pones una${FinColor}"
          echo -e "${ColorRojo}distinta, cuando te conectes a la carpeta compartida, acuérdate de utilizar${FinColor}"
          echo -e "${ColorRojo}la contraseña que pongas ahora y no la de la cuenta de usuario.${FinColor}"
          echo ""
          smbpasswd -a $1
        ;;

        5)
       
        ;;

      esac

    done

fi

