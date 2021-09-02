#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar los mineros para las diferentes criptomonedas
#----------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

UsuarioNoRoot=NiPeGun

echo ""
echo -e "${ColorVerde}------------------------------------------------------------------------------------${FinColor}"
echo -e "${ColorVerde}  Iniciando el script de instalación de los diferentes mineros de criptomonedas...${FinColor}"
echo -e "${ColorVerde}------------------------------------------------------------------------------------${FinColor}"
echo ""

## Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
   if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
     echo ""
     echo "  dialog no está instalado. Iniciando su instalación..."
     echo ""
     apt-get -y update
     apt-get -y install dialog
     echo ""
   fi

menu=(dialog --timeout 5 --checklist "Marca los mineros que quieras instalar:" 22 96 16)
  opciones=(1 "Instalar el minero de XMR para el usuario root" off
            2 "  - Mover el minero de XMR a la carpeta de usuario no root" off
            3 "Instalar el minero de RVN con AMD para el usuario root" off
            4 "  - Mover el minero de RVN con AMD a la carpeta de usuario no root" off
            5 "Instalar el minero de RVN con nVidia para el usuario root" off
            6 "  - Mover el minero de RVN con nVidia a la carpeta de usuario no root" off
            7 "Instalar el minero de CRP para el usuario root" on
            8 "  - Mover el minero de CRP a la carpeta de usuario no root" off
            9 "Instalar el minero de LTC para el usuario root" off
           10 "  - Mover el minero de LTC a la carpeta de usuario $UsuarioNoRoot" off
           11 "Agregar los mineros del root a los ComandosPostArranque" on
           12 "Agregar los mineros del usuario $UsuarioNoRoot a los ComandosPostArranque" off)
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  clear

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo -e "${ColorVerde}  Instalando el minero de XMR (Monero) para el usuario root...${FinColor}"
          echo ""

          ## Crear la carpeta
             mkdir -p /root/Cryptos/XMR/minero/ 2> /dev/null

        ;;

        2)

          echo ""
          echo -e "${ColorVerde}  Moviendo el minero de XMR a la carpeta del usuario $UsuarioNoRoot...${FinColor}"
          echo ""

          ## Mover carpeta de mineros
             mkdir -p /home/$UsuarioNoRoot/Cryptos/XMR/ 2> /dev/null
             mv /root/Cryptos/XMR/minero/ /home/$UsuarioNoRoot/Cryptos/XMR/minero/
          ## Reparación de permisos
             chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R

        ;;

        3)

          echo ""
          echo -e "${ColorVerde}  Instalando el minero de RVN (Raven) con AMD para el usuario root...${FinColor}"
          echo ""

          ## Crear la carpeta
             mkdir -p /root/Cryptos/RVN/minero/amd/ 2> /dev/null

        ;;

        4)

          echo ""
          echo -e "${ColorVerde}  Moviendo el minero de RVN con AMD a la carpeta del usuario $UsuarioNoRoot...${FinColor}"
          echo ""

          ## Mover carpeta de mineros
             mkdir -p /home/$UsuarioNoRoot/Cryptos/RVN/minero/ 2> /dev/null
             mv /root/Cryptos/RVN/minero/amd/ /home/$UsuarioNoRoot/Cryptos/RVN/minero/amd/
          ## Reparación de permisos
             chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R

        ;;

        5)

          echo ""
          echo -e "${ColorVerde}  Instalando el minero de RVN (Raven) con nVidia para el usuario root...${FinColor}"
          echo ""

          ## Crear la carpeta
             mkdir -p /root/Cryptos/RVN/minero/nvidia/ 2> /dev/null

        ;;

        6)

          echo ""
          echo -e "${ColorVerde}  Moviendo el minero de RVN con nVidia a la carpeta del usuario $UsuarioNoRoot...${FinColor}"
          echo ""

          ## Mover carpeta de mineros
             mv /root/Cryptos/RVN/minero/nvidia/ /home/$UsuarioNoRoot/Cryptos/RVN/minero/
          ## Reparación de permisos
             chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R

        ;;

        7)

          echo ""
          echo -e "${ColorVerde}  Instalando el minero de CRP (Crypton) para el usuario root...${FinColor}"
          echo ""

          ## Crear la carpeta
             rm -rf /root/MinerosCrypto/CRP/ 2> /dev/null
             mkdir -p /root/MinerosCrypto/CRP/ 2> /dev/null

          ## Descargar la última versión del minero
             cd /root/MinerosCrypto/CRP/
             ## Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo "  wget no está instalado. Iniciando su instalación..."
                  echo ""
                  apt-get -y update
                  apt-get -y install wget
                  echo ""
                fi
             echo ""
             echo "  Descargando el archivo .deb..."
             echo ""
             wget https://update.u.is/downloads/uam/linux/uam-latest_amd64.deb

          ## Extraer los archivos de dentro del .deb
             ## Comprobar si el paquete binutils está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s binutils 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo "  binutils no está instalado. Iniciando su instalación..."
                  echo ""
                  apt-get -y update
                  apt-get -y install binutils
                  echo ""
                fi
             echo ""
             echo "  Descomprimiendo el archivo .deb..."
             echo ""
             ar x /root/MinerosCrypto/CRP/uam-latest_amd64.deb
             ## Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s tar 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo "  tar no está instalado. Iniciando su instalación..."
                  echo ""
                  apt-get -y update
                  apt-get -y install tar
                  echo ""
                fi
                echo ""
                echo "  Descomprimiendo el archivo data.tar.xz..."
                echo ""
                tar xfv /root/MinerosCrypto/CRP/data.tar.xz
                echo ""
                mv /root/MinerosCrypto/CRP/opt/uam/* /root/MinerosCrypto/CRP/
             ## Borrar archivos sobrantes
                echo ""
                echo "  Borrando archivos sobrantes..."
                echo ""
                rm -rf /root/MinerosCrypto/CRP/opt/
                rm -rf /root/MinerosCrypto/CRP/control.tar.gz
                rm -rf /root/MinerosCrypto/CRP/data.tar.xz
                rm -rf /root/MinerosCrypto/CRP/debian-binary
                rm -rf /root/MinerosCrypto/CRP/uam-latest_amd64.deb

          ## Crear el archivo para minar
             echo '#!/bin/bash'  > /root/MinerosCrypto/CRP/Minar.sh
             echo ""            >> /root/MinerosCrypto/CRP/Minar.sh
             echo "/root/MinerosCrypto/CRP/uam --pk C24C4B77698578B46CDB1C109996B0299984FEE46AAC5CD6025786F5C5C61415 --http [127.0.0.1]:8090 --no-ui" >> /root/MinerosCrypto/CRP/Minar.sh
             chmod +x /root/MinerosCrypto/CRP/Minar.sh
        ;;

        8)

          echo ""
          echo -e "${ColorVerde}  Moviendo el minero de CRP a la carpeta del usuario $UsuarioNoRoot...${FinColor}"
          echo ""

          ## Mover carpeta de mineros
             mv /root/MinerosCrypto/ /home/$UsuarioNoRoot//MinerosCrypto/
          ## Reparación de permisos
             chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R

        ;;

        9)

          echo ""
          echo -e "${ColorVerde}  Instalando el minero de LTC (Litecoin) para el usuario root...${FinColor}"
          echo ""

          ## Crear la carpeta
             mkdir -p /root/MinerosCrypto/LTC/ 2> /dev/null

        ;;

        10)

          echo ""
          echo -e "${ColorVerde}  Moviendo el minero de LTC a la carpeta del usuario $UsuarioNoRoot...${FinColor}"
          echo ""

          ## Mover carpeta de mineros
             mv /root/MinerosCrypto/ /home/$UsuarioNoRoot//MinerosCrypto/
          ## Reparación de permisos
             chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R

        ;;

        11)

          echo ""
          echo -e "${ColorVerde}  Agregando los mineros del root a los ComandosPostArranque...${FinColor}"
          echo ""
          ## CRP
             echo "#/root/MinerosCrypto/CRP/Minar.sh &" >> /root/scripts/ComandosPostArranque.sh
             echo "#disown -a"                          >> /root/scripts/ComandosPostArranque.sh
        ;;

        12)

          echo ""
          echo -e "${ColorVerde}  Agregando los mineros del usuario $UsuarioNoRoot a los ComandosPostArranque...${FinColor}"
          echo ""
          ## CRP
             echo "#su $UsuarioNoRoot -c /home/$UsuarioNoRoot/MinerosCrypto/CRP/Minar.sh &" >> /root/scripts/ComandosPostArranque.sh
             echo "#disown -a"                                                             >> /root/scripts/ComandosPostArranque.sh
        ;;

      esac

done


