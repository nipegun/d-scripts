#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar el servidor Samba en Debian
#
# Ejecución remota:
#    curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-Archivos-Samba-InstalarYConfigurar.sh | bash -s NombreDeGrupo NombreDeEquipo nipegun
#
#  Para que los usuarios puedan utilizar samba es necesario crearles una contraseña para samba al usuario con:
#  smbpasswd -a NombreDeUsuario
#  La contraseña samba puede ser distinta a la de la propia cuenta de usuario
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then              # Para systemd y freedesktop.org
     . /etc/os-release
     cNomSO=$NAME
     cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then  # linuxbase.org
       cNomSO=$(lsb_release -si)
       cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then           # Para algunas versiones de Debian sin el comando lsb_release
       . /etc/lsb-release
       cNomSO=$DISTRIB_ID
       cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then        # Para versiones viejas de Debian.
       cNomSO=Debian
       cVerSO=$(cat /etc/debian_version)
  else                                         # Para el viejo uname (También funciona para BSD)
       cNomSO=$(uname -s)
       cVerSO=$(uname -r)
  fi

if [ $cVerSO == "13" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Samba para Debian 13 (x)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Samba para Debian 11 (Bookworm)..."  
  echo ""

  ArgumentosRequeridos=3

  if [ $# -ne $ArgumentosRequeridos ]
    then
      echo ""
      echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
      echo -e "$0 ${cColorVerde}[GrupoDeTrabajo] [NombreNetBios] [Usuario]${cFinColor}"
      echo ""
      echo "Ejemplo:"
      echo "$0 oficina ordenador pepe"
      echo ""
      exit
    else
      apt-get update && apt-get -y install dialog
      menu=(dialog --timeout 5 --checklist "Instalación de la compartición Samba:" 22 76 16)
      opciones=(
        1 "Instalar los paquetes necesarios" on
        2 "Configurar las opciones globales" on
        3 "Configurar la compartición Pública anónima" off
        4 "Configurar la compartición de la carpeta del usuario" off
        5 "Configurar la compartición Multimedia" off
        6 "Configurar la compartición de Webs" off
        7 "Reiniciar el demonio y mostrar el estado" on
      )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      clear

      for choice in $choices
        do
          case $choice in

            1)
              echo ""
              echo -e "${cColorVerde}  Instalando los paquetes necesarios...${cFinColor}"
              echo ""
              apt-get -y install libcups2
              apt-get -y install samba
              apt-get -y install samba-common
              apt-get -y install cups
              cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
            ;;

            2)
              echo ""
              echo -e "${cColorVerde}  Configurando las opciones globales...${cFinColor}"
              echo ""
              echo "[global]"                                                     > /etc/samba/smb.conf
              echo "  workgroup = $1"                                            >> /etc/samba/smb.conf
              echo "  server string = Servidor Samba %v"                         >> /etc/samba/smb.conf
              echo "  wins support = yes"                                        >> /etc/samba/smb.conf
              echo "  netbios name = $2"                                         >> /etc/samba/smb.conf
              echo "  security = user"                                           >> /etc/samba/smb.conf
              echo "  guest account = nobody"                                    >> /etc/samba/smb.conf
              echo "  map to guest = bad user"                                   >> /etc/samba/smb.conf
              echo "  dns proxy = no"                                            >> /etc/samba/smb.conf
              echo "  hosts allow = 192.168.0. 192.168.1. 192.168.2. 192.168.3." >> /etc/samba/smb.conf
              echo "  hosts deny = 192.168.1.254"                                >> /etc/samba/smb.conf
              echo "  #interfaces = lo eth1 wlan0 br0"                           >> /etc/samba/smb.conf
              echo "  #bind interfaces only = yes"                               >> /etc/samba/smb.conf
              echo ""                                                            >> /etc/samba/smb.conf
            ;;

            3)
              echo ""
              echo -e "${cColorVerde}  Creando la compartición para la carpeta pública...${cFinColor}"
              echo ""
              mkdir /publica/
              chown nobody:nogroup /publica/
              chmod -Rv 777 /publica/
              echo "[publica]"                                     >> /etc/samba/smb.conf
              echo "  path = /publica/"                            >> /etc/samba/smb.conf
              echo "  comment = Compartida para usuarios anónimos" >> /etc/samba/smb.conf
              echo "  browseable = yes"                            >> /etc/samba/smb.conf
              echo "  public = yes"                                >> /etc/samba/smb.conf
              echo "  writeable = no"                              >> /etc/samba/smb.conf
              echo "  guest ok = yes"                              >> /etc/samba/smb.conf
              echo ""                                              >> /etc/samba/smb.conf
            ;;

            4)
              echo ""
              echo -e "${cColorVerde}  Creando la compartición para la carpeta del usuario...${cFinColor}"
              echo ""
              echo "[Usuario $3]"                       >> /etc/samba/smb.conf
              echo "  path = /home/$3/"                 >> /etc/samba/smb.conf
              echo "  comment = Carpeta del usuario $3" >> /etc/samba/smb.conf
              echo "  browseable = yes"                  >> /etc/samba/smb.conf
              echo "  read only = no"                   >> /etc/samba/smb.conf
              echo "  valid users = $3"                 >> /etc/samba/smb.conf
            ;;

            5)
              echo ""
              echo -e "${cColorVerde}  Creando la compartición de una carpeta Multimedia...${cFinColor}"
              echo ""
              echo "[Multimedia]"                                   >> /etc/samba/smb.conf
              echo "  path = /Discos/HDD-Multimedia/"               >> /etc/samba/smb.conf
              echo "  comment = Pelis, series, música, libros, etc" >> /etc/samba/smb.conf
              echo "  browseable = yes"                             >> /etc/samba/smb.conf
              echo "  public = no"                                  >> /etc/samba/smb.conf
              echo "  guest ok = no"                                >> /etc/samba/smb.conf
              echo "  write list = $1"                              >> /etc/samba/smb.conf
              echo ""                                               >> /etc/samba/smb.conf
            ;;

            6)
              echo ""
              echo -e "${cColorVerde}  Creando la compartición de la carpeta de las Webs...${cFinColor}"
              echo ""
              echo "[Webs]"                  >> /etc/samba/smb.conf
              echo "  path = /var/www/"      >> /etc/samba/smb.conf
              echo "  comment = Webs"        >> /etc/samba/smb.conf
              echo "  browseable = yes"      >> /etc/samba/smb.conf
              echo "  public = no"           >> /etc/samba/smb.conf
              echo "  guest ok = no"         >> /etc/samba/smb.conf
              echo "  write list = www-data" >> /etc/samba/smb.conf
              echo ""                        >> /etc/samba/smb.conf
            ;;

            7)
              echo ""
              echo "  AHORA DEBERÁS INGRESAR 2 VECES LA NUEVA CONTRASEÑA SAMBA PARA EL USUARIO $3."
              echo "  PUEDE SER DISTINTA A LA DE LA PROPIA CUENTA DE USUARIO PERO SI PONES UNA"
              echo "  DISTINTA, CUANDO TE CONECTES A LA CARPETA COMPARTIDA, ACUÉRDATE DE UTILIZAR"
              echo "  LA CONTRASEÑA QUE PONGAS AHORA Y NO LA DE LA CUENTA DE USUARIO."
              echo ""
              smbpasswd -a $3
              service smbd restart
              sleep 5
              service smbd status
              echo ""
            ;;

          esac

        done
  fi

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Samba para Debian 11 (Bullseye)..."  
  echo ""

  ArgumentosRequeridos=3

  if [ $# -ne $ArgumentosRequeridos ]
    then
      echo ""
      echo "---------------------------------------------------------------"
      echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
      echo -e "$0 ${cColorVerde}[GrupoDeTrabajo] [NombreNetBios] [Usuario]${cFinColor}"
      echo ""
      echo "Ejemplo:"
      echo "$0 oficina ordenador pepe"
      echo "---------------------------------------------------------------"
      echo ""
      exit
    else
      apt-get update && apt-get -y install dialog
      menu=(dialog --timeout 5 --checklist "Instalación de la compartición Samba:" 22 76 16)
      opciones=(
        1 "Instalar los paquetes necesarios" on
        2 "Configurar las opciones globales" on
        3 "Configurar la compartición Pública anónima" off
        4 "Configurar la compartición de la carpeta del usuario" off
        5 "Configurar la compartición Multimedia" off
        6 "Configurar la compartición de Webs" off
        7 "Reiniciar el demonio y mostrar el estado" on
      )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      clear

      for choice in $choices
        do
          case $choice in

            1)
              echo ""
              echo -e "${cColorVerde}  Instalando los paquetes necesarios...${cFinColor}"
              echo ""
              apt-get -y install libcups2
              apt-get -y install samba
              apt-get -y install samba-common
              apt-get -y install cups
              cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
            ;;

            2)
              echo ""
              echo -e "${cColorVerde}  Configurando las opciones globales...${cFinColor}"
              echo ""
              echo "[global]"                                                     > /etc/samba/smb.conf
              echo "  workgroup = $1"                                            >> /etc/samba/smb.conf
              echo "  server string = Servidor Samba %v"                         >> /etc/samba/smb.conf
              echo "  wins support = yes"                                        >> /etc/samba/smb.conf
              echo "  netbios name = $2"                                         >> /etc/samba/smb.conf
              echo "  security = user"                                           >> /etc/samba/smb.conf
              echo "  guest account = nobody"                                    >> /etc/samba/smb.conf
              echo "  map to guest = bad user"                                   >> /etc/samba/smb.conf
              echo "  dns proxy = no"                                            >> /etc/samba/smb.conf
              echo "  hosts allow = 192.168.0. 192.168.1. 192.168.2. 192.168.3." >> /etc/samba/smb.conf
              echo "  hosts deny = 192.168.1.254"                                >> /etc/samba/smb.conf
              echo "  #interfaces = lo eth1 wlan0 br0"                           >> /etc/samba/smb.conf
              echo "  #bind interfaces only = yes"                               >> /etc/samba/smb.conf
              echo ""                                                            >> /etc/samba/smb.conf
            ;;

            3)
              echo ""
              echo -e "${cColorVerde}  Creando la compartición para la carpeta pública...${cFinColor}"
              echo ""
              mkdir /publica/
              chown nobody:nogroup /publica/
              chmod -Rv 777 /publica/
              echo "[publica]"                                     >> /etc/samba/smb.conf
              echo "  path = /publica/"                            >> /etc/samba/smb.conf
              echo "  comment = Compartida para usuarios anónimos" >> /etc/samba/smb.conf
              echo "  browseable = yes"                            >> /etc/samba/smb.conf
              echo "  public = yes"                                >> /etc/samba/smb.conf
              echo "  writeable = no"                              >> /etc/samba/smb.conf
              echo "  guest ok = yes"                              >> /etc/samba/smb.conf
              echo ""                                              >> /etc/samba/smb.conf
            ;;

            4)
              echo ""
              echo -e "${cColorVerde}  Creando la compartición para la carpeta del usuario...${cFinColor}"
              echo ""
              echo "[Usuario $3]"                       >> /etc/samba/smb.conf
              echo "  path = /home/$3/"                 >> /etc/samba/smb.conf
              echo "  comment = Carpeta del usuario $3" >> /etc/samba/smb.conf
              echo "  browseable = yes"                  >> /etc/samba/smb.conf
              echo "  read only = no"                   >> /etc/samba/smb.conf
              echo "  valid users = $3"                 >> /etc/samba/smb.conf
            ;;

            5)
              echo ""
              echo -e "${cColorVerde}  Creando la compartición de una carpeta Multimedia...${cFinColor}"
              echo ""
              echo "[Multimedia]"                                   >> /etc/samba/smb.conf
              echo "  path = /Discos/HDD-Multimedia/"               >> /etc/samba/smb.conf
              echo "  comment = Pelis, series, música, libros, etc" >> /etc/samba/smb.conf
              echo "  browseable = yes"                             >> /etc/samba/smb.conf
              echo "  public = no"                                  >> /etc/samba/smb.conf
              echo "  guest ok = no"                                >> /etc/samba/smb.conf
              echo "  write list = $1"                              >> /etc/samba/smb.conf
              echo ""                                               >> /etc/samba/smb.conf
            ;;

            6)
              echo ""
              echo -e "${cColorVerde}  Creando la compartición de la carpeta de las Webs...${cFinColor}"
              echo ""
              echo "[Webs]"                  >> /etc/samba/smb.conf
              echo "  path = /var/www/"      >> /etc/samba/smb.conf
              echo "  comment = Webs"        >> /etc/samba/smb.conf
              echo "  browseable = yes"      >> /etc/samba/smb.conf
              echo "  public = no"           >> /etc/samba/smb.conf
              echo "  guest ok = no"         >> /etc/samba/smb.conf
              echo "  write list = www-data" >> /etc/samba/smb.conf
              echo ""                        >> /etc/samba/smb.conf
            ;;

            7)
              echo ""
              echo "  AHORA DEBERÁS INGRESAR 2 VECES LA NUEVA CONTRASEÑA SAMBA PARA EL USUARIO $3."
              echo "  PUEDE SER DISTINTA A LA DE LA PROPIA CUENTA DE USUARIO PERO SI PONES UNA"
              echo "  DISTINTA, CUANDO TE CONECTES A LA CARPETA COMPARTIDA, ACUÉRDATE DE UTILIZAR"
              echo "  LA CONTRASEÑA QUE PONGAS AHORA Y NO LA DE LA CUENTA DE USUARIO."
              echo ""
              smbpasswd -a $3
              service smbd restart
              sleep 5
              service smbd status
              echo ""
            ;;

          esac

        done
  fi

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación de bind9 para Debian 10 (Buster)..."  
  echo ""

  ArgumentosRequeridos=3
  

  if [ $# -ne $ArgumentosRequeridos ]
    then
      echo ""
      echo "---------------------------------------------------------------"
      echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
      echo -e "$0 ${cColorVerde}[GrupoDeTrabajo] [NombreNetBios] [Usuario]${cFinColor}"
      echo ""
      echo "Ejemplo:"
      echo "$0 oficina ordenador pepe"
      echo "---------------------------------------------------------------"
      echo ""
      exit
    else
      apt-get update && apt-get -y install dialog
      menu=(dialog --timeout 5 --checklist "Instalación de la compartición Samba:" 22 76 16)
      opciones=(
        1 "Instalar los paquetes necesarios" on
        2 "Configurar las opciones globales" on
        3 "Configurar la compartición Pública anónima" off
        4 "Configurar la compartición de la carpeta del usuario" off
        5 "Configurar la compartición Multimedia" off
        6 "Configurar la compartición de Webs" off
        7 "Reiniciar el demonio y mostrar el estado" on
      )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      clear

      for choice in $choices
        do
          case $choice in

            1)
              echo ""
              echo -e "${cColorVerde}  Instalando los paquetes necesarios...${cFinColor}"
              echo ""
              apt-get -y install libcups2 samba samba-common cups
              cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
            ;;

            2)
              echo ""
              echo -e "${cColorVerde}  Configurando las opciones globales...${cFinColor}"
              echo ""
              echo "[global]"                                                     > /etc/samba/smb.conf
              echo "  workgroup = $1"                                            >> /etc/samba/smb.conf
              echo "  server string = Servidor Samba %v"                         >> /etc/samba/smb.conf
              echo "  wins support = yes"                                        >> /etc/samba/smb.conf
              echo "  netbios name = $2"                                         >> /etc/samba/smb.conf
              echo "  security = user"                                           >> /etc/samba/smb.conf
              echo "  guest account = nobody"                                    >> /etc/samba/smb.conf
              echo "  map to guest = bad user"                                   >> /etc/samba/smb.conf
              echo "  dns proxy = no"                                            >> /etc/samba/smb.conf
              echo "  hosts allow = 192.168.0. 192.168.1. 192.168.2. 192.168.3." >> /etc/samba/smb.conf
              echo "  hosts deny = 192.168.1.254"                                >> /etc/samba/smb.conf
              echo "  #interfaces = lo eth1 wlan0 br0"                           >> /etc/samba/smb.conf
              echo "  #bind interfaces only = yes"                               >> /etc/samba/smb.conf
              echo ""                                                            >> /etc/samba/smb.conf
            ;;

            3)
              echo ""
              echo -e "${cColorVerde}  Creando la compartición para la carpeta pública...${cFinColor}"
              echo ""
              mkdir /publica/
              chown nobody:nogroup /publica/
              chmod -Rv 777 /publica/
              echo "[publica]"                                     >> /etc/samba/smb.conf
              echo "  path = /publica/"                            >> /etc/samba/smb.conf
              echo "  comment = Compartida para usuarios anónimos" >> /etc/samba/smb.conf
              echo "  browseable = yes"                            >> /etc/samba/smb.conf
              echo "  public = yes"                                >> /etc/samba/smb.conf
              echo "  writeable = no"                              >> /etc/samba/smb.conf
              echo "  guest ok = yes"                              >> /etc/samba/smb.conf
              echo ""                                              >> /etc/samba/smb.conf
            ;;

            4)
              echo ""
              echo -e "${cColorVerde}  Creando la compartición para la carpeta del usuario...${cFinColor}"
              echo ""
              echo "[Usuario $3]"                       >> /etc/samba/smb.conf
              echo "  path = /home/$3/"                 >> /etc/samba/smb.conf
              echo "  comment = Carpeta del usuario $3" >> /etc/samba/smb.conf
              echo "  browseable = yes"                  >> /etc/samba/smb.conf
              echo "  read only = no"                   >> /etc/samba/smb.conf
              echo "  valid users = $3"                 >> /etc/samba/smb.conf
            ;;

            5)
              echo ""
              echo -e "${cColorVerde}  Creando la compartición de una carpeta Multimedia...${cFinColor}"
              echo ""
              echo "[Multimedia]"                                   >> /etc/samba/smb.conf
              echo "  path = /Discos/HDD-Multimedia/"               >> /etc/samba/smb.conf
              echo "  comment = Pelis, series, música, libros, etc" >> /etc/samba/smb.conf
              echo "  browseable = yes"                             >> /etc/samba/smb.conf
              echo "  public = no"                                  >> /etc/samba/smb.conf
              echo "  guest ok = no"                                >> /etc/samba/smb.conf
              echo "  write list = $1"                              >> /etc/samba/smb.conf
              echo ""                                               >> /etc/samba/smb.conf
            ;;

            6)
              echo ""
              echo -e "${cColorVerde}  Creando la compartición de la carpeta de las Webs...${cFinColor}"
              echo ""
              echo "[Webs]"                  >> /etc/samba/smb.conf
              echo "  path = /var/www/"      >> /etc/samba/smb.conf
              echo "  comment = Webs"        >> /etc/samba/smb.conf
              echo "  browseable = yes"      >> /etc/samba/smb.conf
              echo "  public = no"           >> /etc/samba/smb.conf
              echo "  guest ok = no"         >> /etc/samba/smb.conf
              echo "  write list = www-data" >> /etc/samba/smb.conf
              echo ""                        >> /etc/samba/smb.conf
            ;;

            7)
              echo ""
              echo "  AHORA DEBERÁS INGRESAR 2 VECES LA NUEVA CONTRASEÑA SAMBA PARA EL USUARIO $3."
              echo "  PUEDE SER DISTINTA A LA DE LA PROPIA CUENTA DE USUARIO PERO SI PONES UNA"
              echo "  DISTINTA, CUANDO TE CONECTES A LA CARPETA COMPARTIDA, ACUÉRDATE DE UTILIZAR"
              echo "  LA CONTRASEÑA QUE PONGAS AHORA Y NO LA DE LA CUENTA DE USUARIO."
              echo ""
              smbpasswd -a $3
              service smbd restart
              sleep 5
              service smbd status
              echo ""
            ;;

          esac

        done
  fi

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación de bind9 para Debian 9 (Stretch)..."  
  echo ""

  cCantArgumEsperados=3

  if [ $# -ne $EXPECTED_ARGS ]
    then
      echo ""
      echo "---------------------------------------------------------------"
      echo -e "${cColorRojo}Mal uso del script.${cFinColor} El uso correcto sería:"
      echo -e "$0 ${cColorVerde}[GrupoDeTrabajo] [NombreNetBios] [Usuario]${cFinColor}"
      echo ""
      echo "Ejemplo:"
      echo "$0 oficina ordenador pepe"
      echo "---------------------------------------------------------------"
      echo ""
      exit
    else
      apt-get update && apt-get -y install dialog
      menu=(dialog --timeout 5 --checklist "Instalación de la compartición Samba:" 22 76 16)
      opciones=(
        1 "Instalar los paquetes necesarios" on
        2 "Configurar las opciones globales" on
        3 "Configurar la compartición Pública anónima" off
        4 "Configurar la compartición de la carpeta del usuario" off
        5 "Configurar la compartición Multimedia" off
        6 "Configurar la compartición de Webs" off
        7 "Reiniciar el demonio y mostrar el estado" on
      )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      clear

      for choice in $choices
        do
          case $choice in

            1)
              echo ""
              echo -e "${cColorVerde}  Instalando los paquetes necesarios...${cFinColor}"
              echo ""
              apt-get -y install libcups2 samba samba-common cups
              cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
            ;;

            2)
              echo ""
              echo -e "${cColorVerde}  Configurando las opciones globales...${cFinColor}"
              echo ""
              echo "[global]" > /etc/samba/smb.conf
              echo "  workgroup = $1" >> /etc/samba/smb.conf
              echo "  server string = Servidor Samba %v" >> /etc/samba/smb.conf
              echo "  wins support = yes" >> /etc/samba/smb.conf
              echo "  netbios name = $2" >> /etc/samba/smb.conf
              echo "  security = user" >> /etc/samba/smb.conf
              echo "  guest account = nobody" >> /etc/samba/smb.conf
              echo "  map to guest = bad user" >> /etc/samba/smb.conf
              echo "  dns proxy = no" >> /etc/samba/smb.conf
              echo "  hosts allow = 192.168.0. 192.168.1. 192.168.2. 192.168.3." >> /etc/samba/smb.conf
              echo "  hosts deny = 192.168.1.255" >> /etc/samba/smb.conf
              echo "  #interfaces = lo eth1 wlan0 br0" >> /etc/samba/smb.conf
              echo "  #bind interfaces only = yes" >> /etc/samba/smb.conf
              echo "" >> /etc/samba/smb.conf
            ;;

            3)
              echo ""
              echo -e "${cColorVerde}  Creando la compartición para la carpeta pública...${cFinColor}"
              echo ""
              echo "[publica]" >> /etc/samba/smb.conf
              mkdir /publica/
              chown nobody:nogroup /publica/
              chmod -Rv 777 /publica/
              echo "  path = /publica/" >> /etc/samba/smb.conf
              echo "  comment = Compartida para usuarios anónimos" >> /etc/samba/smb.conf
              echo "  browseable = yes" >> /etc/samba/smb.conf
              echo "  public = yes" >> /etc/samba/smb.conf
              echo "  writeable = no" >> /etc/samba/smb.conf
              echo "  guest ok = yes" >> /etc/samba/smb.conf
              echo "" >> /etc/samba/smb.conf
            ;;

            4)
              echo ""
              echo -e "${cColorVerde}  Creando la compartición para la carpeta del usuario...${cFinColor}"
              echo ""
              echo "[Usuario $3]" >> /etc/samba/smb.conf
              echo "  path = /home/$3/" >> /etc/samba/smb.conf
              echo "  comment = Carpeta del usuario $3" >> /etc/samba/smb.conf
              echo "  browseable = yes" >> /etc/samba/smb.conf
              echo "  read only = no" >> /etc/samba/smb.conf
              echo "  valid users = $3" >> /etc/samba/smb.conf
            ;;

            5)
              echo ""
              echo -e "${cColorVerde}  Creando la compartición de una carpeta Multimedia...${cFinColor}"
              echo ""
              echo "[Multimedia]" >> /etc/samba/smb.conf
              echo "  path = /Multimedia/" >> /etc/samba/smb.conf
              echo "  comment = Pelis, Serie, Música, libros, etc" >> /etc/samba/smb.conf
              echo "  browseable = yes" >> /etc/samba/smb.conf
              echo "  public = yes" >> /etc/samba/smb.conf
              echo "  writeable = no" >> /etc/samba/smb.conf
              echo "  guest ok = yes" >> /etc/samba/smb.conf
              echo "" >> /etc/samba/smb.conf
            ;;

            6)
              echo ""
              echo -e "${cColorVerde}  Creando la compartición de la carpeta de las Webs...${cFinColor}"
              echo ""
              echo "[Webs]" >> /etc/samba/smb.conf
              echo "  path = /var/www/" >> /etc/samba/smb.conf
              echo "  comment = Webs" >> /etc/samba/smb.conf
              echo "  browseable = yes" >> /etc/samba/smb.conf
               echo "  public = no" >> /etc/samba/smb.conf
              echo "  guest ok = no" >> /etc/samba/smb.conf
              echo "  write list = www-data" >> /etc/samba/smb.conf
              echo "" >> /etc/samba/smb.conf
            ;;

            7)
              echo ""
              echo "  AHORA DEBERÁS INGRESAR 2 VECES LA NUEVA CONTRASEÑA SAMBA PARA EL USUARIO $3."
              echo "  PUEDE SER DISTINTA A LA DE LA PROPIA CUENTA DE USUARIO PERO SI PONES UNA"
              echo "  DISTINTA, CUANDO TE CONECTES A LA CARPETA COMPARTIDA, ACUÉRDATE DE UTILIZAR"
              echo "  LA CONTRASEÑA QUE PONGAS AHORA Y NO LA DE LA CUENTA DE USUARIO."
              echo ""
              smbpasswd -a $3
              service smbd restart
              sleep 5
              service smbd status
              echo ""
            ;;

          esac

        done
  fi

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Samba para Debian 8 (Jessie)..."  
  echo ""

  cCantArgumEsperados=3

  if [ $# -ne $EXPECTED_ARGS ]
    then
      echo ""
      echo "---------------------------------------------------------------"
      echo "Mal uso del script. El uso correcto sería:"
      echo "InstalarYConfigurarServidorSamba GrupoDeTrabajo NombreNetBios Usuario"
      echo ""
      echo "Ejemplo:"
      echo "InstalarYConfigurarServidorSamba oficina ordenador pepe"
      echo "---------------------------------------------------------------"
      echo ""
      exit
    else
      apt-get update && apt-get -y install dialog
      menu=(dialog --timeout 5 --checklist "Instalación de la compartición Samba:" 22 76 16)
      opciones=(
        1 "Instalar los paquetes necesarios" on
        2 "Configurar las opciones globales" on
        3 "Configurar la compartición Pública anónima" off
        4 "Configurar la compartición de la carpeta del usuario" off
        5 "Configurar la compartición Multimedia" off
        6 "Configurar la compartición de Webs" off
        7 "Reiniciar el demonio y mostrar el estado" on
      )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      clear

      for choice in $choices
        do
          case $choice in

            1)
              echo ""
              echo "---------------------------------------"
              echo "  INSTALANDO LOS PAQUETES NECESARIOS"
              echo "---------------------------------------"
              echo ""
              apt-get -y install libcups2 samba samba-common cups
              mv /etc/samba/smb.conf /etc/samba/smb.conf.bak
            ;;

            2)
              echo ""
              echo "--------------------------------------"
              echo "  CONFIGURANDO LAS OPCIONES GLOBALES"
              echo "--------------------------------------"
              echo ""
              echo "[global]"                                                     > /etc/samba/smb.conf
              echo "  workgroup = $1"                                            >> /etc/samba/smb.conf
              echo "  server string = Servidor Samba %v"                         >> /etc/samba/smb.conf
              echo "  wins support = yes"                                        >> /etc/samba/smb.conf
              echo "  netbios name = $2"                                         >> /etc/samba/smb.conf
              echo "  security = user"                                           >> /etc/samba/smb.conf
              echo "  guest account = nobody"                                    >> /etc/samba/smb.conf
              echo "  map to guest = bad user"                                   >> /etc/samba/smb.conf
              echo "  dns proxy = no"                                            >> /etc/samba/smb.conf
              echo "  hosts allow = 192.168.0. 192.168.1. 192.168.2. 192.168.3." >> /etc/samba/smb.conf
              echo "  hosts deny = 192.168.1.255"                                >> /etc/samba/smb.conf
              echo "  #interfaces = lo eth1 wlan0 br0"                           >> /etc/samba/smb.conf
              echo "  #bind interfaces only = yes"                               >> /etc/samba/smb.conf
              echo ""                                                            >> /etc/samba/smb.conf
            ;;

            3)
              echo ""
              echo "---------------------------------------------------"
              echo "  CREANDO LA COMPARTICIÓN PARA LA CARPETA PÚBLICA"
              echo "---------------------------------------------------"
              echo ""
              echo "[publica]" >> /etc/samba/smb.conf
              mkdir /publica/
              chown nobody:nogroup /publica/
              chmod -Rv 777 /publica/
              echo "  path = /publica/"                            >> /etc/samba/smb.conf
              echo "  comment = Compartida para usuarios anónimos" >> /etc/samba/smb.conf
              echo "  browseable = yes"                            >> /etc/samba/smb.conf
              echo "  public = yes"                                >> /etc/samba/smb.conf
              echo "  writeable = no"                              >> /etc/samba/smb.conf
              echo "  guest ok = yes"                              >> /etc/samba/smb.conf
              echo ""                                              >> /etc/samba/smb.conf
            ;;

            4)
              echo ""
              
              echo "  CREANDO LA COMPARTICIÓN PARA LA CARPETA DEL USUARIO"
              
              echo ""
              echo "[Usuario $3]"                       >> /etc/samba/smb.conf
              echo "  path = /home/$3/"                 >> /etc/samba/smb.conf
              echo "  comment = Carpeta del usuario $3" >> /etc/samba/smb.conf
              echo "  browseable = yes"                  >> /etc/samba/smb.conf
              echo "  read only = no"                   >> /etc/samba/smb.conf
              echo "  valid users = $3"                 >> /etc/samba/smb.conf

            ;;

            5)
              echo ""
              
              echo "  CREANDO LA COMPARTICIÓN DE UNA CARPETA CON MULTIMEDIA"
              
              echo ""
              echo "[Multimedia]"                                  >> /etc/samba/smb.conf
              echo "  path = /Multimedia/"                         >> /etc/samba/smb.conf
              echo "  comment = Pelis, Serie, Música, libros, etc" >> /etc/samba/smb.conf
              echo "  browseable = yes"                            >> /etc/samba/smb.conf
              echo "  public = yes"                                >> /etc/samba/smb.conf
              echo "  writeable = no"                              >> /etc/samba/smb.conf
              echo "  guest ok = yes"                              >> /etc/samba/smb.conf
              echo ""                                              >> /etc/samba/smb.conf
            ;;

            6)
              echo ""
              echo "-----------------------------------------------------"
              echo "  CREANDO LA COMPARTICIÓN DE LA CARPETA DE LAS WEBS"
              echo "-----------------------------------------------------"
              echo ""
              echo "[Webs]"                  >> /etc/samba/smb.conf
              echo "  path = /var/www/"      >> /etc/samba/smb.conf
              echo "  comment = Webs"        >> /etc/samba/smb.conf
              echo "  browseable = yes"      >> /etc/samba/smb.conf
              echo "  public = no"           >> /etc/samba/smb.conf
              echo "  guest ok = no"         >> /etc/samba/smb.conf
              echo "  write list = www-data" >> /etc/samba/smb.conf
              echo ""                        >> /etc/samba/smb.conf
            ;;

            7)
              echo ""
              echo "  AHORA DEBERÁS INGRESAR 2 VECES LA NUEVA CONTRASEÑA SAMBA PARA EL USUARIO $3."
              echo "  PUEDE SER DISTINTA A LA DE LA PROPIA CUENTA DE USUARIO PERO SI PONES UNA"
              echo "  DISTINTA, CUANDO TE CONECTES A LA CARPETA COMPARTIDA, ACUÉRDATE DE UTILIZAR"
              echo "  LA CONTRASEÑA QUE PONGAS AHORA Y NO LA DE LA CUENTA DE USUARIO."
              echo ""
              smbpasswd -a $3
              service smbd restart
              sleep 5
              service smbd status
              echo ""
            ;;

          esac

        done

    fi

elif [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación de Samba para Debian 7 (Wheezy)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi

