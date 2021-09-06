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

UsuarioNoRoot=usuariox

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
  opciones=(1 "Instalar el minero de CRP para el usuario root" on
            2 "  Mover el minero de CRP a la carpeta del usuario no root" on
            3 "Agregar los mineros del root a los ComandosPostArranque" off
            4 "Agregar los mineros del usuario $UsuarioNoRoot a los ComandosPostArranque" off)
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  clear

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo -e "${ColorVerde}  Instalando el minero de CRP (Crypton) para el usuario root...${FinColor}"
          echo ""

          ## Crear la carpeta
             rm -rf /root/Cryptos/CRP/minero/ 2> /dev/null
             mkdir -p /root/Cryptos/CRP/ 2> /dev/null

          ## Descargar la última versión del minero
             cd /root/Cryptos/CRP/
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
             ar x /root/Cryptos/CRP/uam-latest_amd64.deb
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
                tar xfv /root/Cryptos/CRP/data.tar.xz
                echo ""
                mv /root/Cryptos/CRP/opt/uam/ /root/Cryptos/CRP/minero/
             ## Borrar archivos sobrantes
                echo ""
                echo "  Borrando archivos sobrantes..."
                echo ""
                rm -rf /root/Cryptos/CRP/opt/
                rm -rf /root/Cryptos/CRP/control.tar.gz
                rm -rf /root/Cryptos/CRP/data.tar.xz
                rm -rf /root/Cryptos/CRP/debian-binary
                rm -rf /root/Cryptos/CRP/uam-latest_amd64.deb

          ## Crear el archivo para minar
             echo '#!/bin/bash'                                                                           > /root/Cryptos/CRP/minero/Minar.sh
             echo ""                                                                                     >> /root/Cryptos/CRP/minero/Minar.sh
             echo "PublicKey=C24C4B77698578B46CDB1C109996B0299984FEE46AAC5CD6025786F5C5C61415"           >> /root/Cryptos/CRP/minero/Minar.sh
             echo 'IPLocalDelMinero=$(hostname -I)'                                                      >> /root/Cryptos/CRP/minero/Minar.sh
             echo ""                                                                                     >> /root/Cryptos/CRP/minero/Minar.sh
             echo 'echo ""'                                                                              >> /root/Cryptos/CRP/minero/Minar.sh
             echo 'echo "  Ejecutando el minero de Utopia..."'                                           >> /root/Cryptos/CRP/minero/Minar.sh
             echo 'echo ""'                                                                              >> /root/Cryptos/CRP/minero/Minar.sh
             echo '/root/Cryptos/CRP/minero/uam --pk $PublicKey --http [$IPLocalDelMinero]:8090 --no-ui' >> /root/Cryptos/CRP/minero/Minar.sh
             chmod +x                                                                                       /root/Cryptos/CRP/minero/Minar.sh
        ;;

        2)

          echo ""
          echo -e "${ColorVerde}  Moviendo el minero de CRP a la carpeta del usuario $UsuarioNoRoot...${FinColor}"
          echo ""
          ## Crear la carpeta
             mkdir -p  /home/$UsuarioNoRoot/Cryptos/CRP/minero/ 2> /dev/null
          ## Borrar el minero ya instalado
             rm -rf /home/$UsuarioNoRoot/Cryptos/CRP/minero/
          ## Mover carpeta de mineros
             mv /root/Cryptos/CRP/minero/ /home/$UsuarioNoRoot/Cryptos/CRP/
          ## Modificar la ubicación del ejecutable en el script
             sed -i -e "s|/root/Cryptos/CRP/minero/uam|/home/$UsuarioNoRoot/Cryptos/CRP/minero/uam|g" /home/$UsuarioNoRoot/Cryptos/CRP/minero/Minar.sh
          ## Reparación de permisos
             chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R 2> /dev/null

        ;;

        3)

          echo ""
          echo -e "${ColorVerde}  Agregando los mineros del root a los ComandosPostArranque...${FinColor}"
          echo ""
          ## CRP
             echo "#/root/Cryptos/CRP/minero/Minar.sh &" >> /root/scripts/ComandosPostArranque.sh
             echo "#disown -a"                           >> /root/scripts/ComandosPostArranque.sh
        ;;

        4)

          echo ""
          echo -e "${ColorVerde}  Agregando los mineros del usuario $UsuarioNoRoot a los ComandosPostArranque...${FinColor}"
          echo ""
          ## CRP
             echo "#su $UsuarioNoRoot -c /home/$UsuarioNoRoot/Cryptos/CRP/minero/Minar.sh &" >> /root/scripts/ComandosPostArranque.sh
             echo "#disown -a"                                                              >> /root/scripts/ComandosPostArranque.sh
        ;;

      esac

done

