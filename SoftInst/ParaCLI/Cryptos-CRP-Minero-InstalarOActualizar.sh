#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar los mineros para las diferentes criptomonedas
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Cryptos-CRP-Minero-InstalarOActualizar.sh | bash
#
# Ejecución remota con cambio de llave pública:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Cryptos-CRP-Minero-InstalarOActualizar.sh | sed 's/^PublicKey.*/PublicKey=TuClave/g' | bash
# ----------

vPublicKey=C24C4B77698578B46CDB1C109996B0299984FEE46AAC5CD6025786F5C5C61415

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

echo ""
echo -e "${cColorVerde}  Iniciando el script de instalación o actualización del minero de Utopia...${cFinColor}"
echo ""

# Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "  dialog no está instalado. Iniciando su instalación..."    echo ""
    apt-get -y update && apt-get -y install dialog
    echo ""
  fi

# Crear menú
  menu=(dialog --timeout 5 --checklist "Marca los mineros que quieras instalar:" 22 96 16)
    opciones=(
      1 "Instalar o actualizar el minero de CRP para el usuario root" on
      2 "  Mover el minero de CRP a la carpeta del usuario no root" off
      3 "Agregar los mineros del root a los ComandosPostArranque" off
      4 "Agregar los mineros del usuario $vUsuarioCRPNoRoot a los ComandosPostArranque" off
      5 "Activar auto-logueo de root en modo texto" on
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

# Programar elecciones
  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo -e "${cColorVerde}  Instalando el minero de CRP (Crypton) para el usuario root...${cFinColor}"
          echo ""

          # Detener todos los posibles procesos activos del minero
            # Comprobar si el paquete psmisc está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s psmisc 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo "  El paquete psmisc no está instalado. Iniciando su instalación..."
                echo ""
                apt-get -y update
                apt-get -y install psmisc
                echo ""
              fi
            killall -9 uam

          # Crear la carpeta
            rm -rf /root/Cryptos/CRP/minero/ 2> /dev/null
            mkdir -p /root/Cryptos/CRP/ 2> /dev/null

          # Descargar la última versión del minero
            cd /root/Cryptos/CRP/
            # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
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
            rm -rf /root/Cryptos/CRP/opt/ 2> /dev/null
            rm -f /root/Cryptos/CRP/control.tar.gz 2> /dev/null
            rm -f /root/Cryptos/CRP/data.tar.xz 2> /dev/null
            rm -f /root/Cryptos/CRP/debian-binary 2> /dev/null
            rm -f /root/Cryptos/CRP/uam-latest_amd64.deb 2> /dev/null
            rm -f /root/Cryptos/CRP/*.deb 2> /dev/null
            wget https://update.u.is/downloads/uam/linux/uam-latest_amd64.deb 2> /dev/null

          # Extraer los archivos de dentro del .deb
            # Comprobar si el paquete binutils está instalado. Si no lo está, instalarlo.
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
            # Comprobar si el paquete tar está instalado. Si no lo está, instalarlo.
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
            # Borrar archivos sobrantes
              echo ""
              echo "  Borrando archivos sobrantes..."
              echo ""
              rm -rf /root/Cryptos/CRP/opt/
              rm -rf /root/Cryptos/CRP/control.tar.gz
              rm -rf /root/Cryptos/CRP/data.tar.xz
              rm -rf /root/Cryptos/CRP/debian-binary
              rm -rf /root/Cryptos/CRP/uam-latest_amd64.deb

          # Crear el archivo para minar
            echo '#!/bin/bash'                                                                                   > /root/Cryptos/CRP/minero/Minar.sh
            echo ""                                                                                             >> /root/Cryptos/CRP/minero/Minar.sh
            echo "cPublicKey=$vPublicKey"                                                                       >> /root/Cryptos/CRP/minero/Minar.sh
            echo 'vIPLocalDelMinero=$(hostname -I)'                                                             >> /root/Cryptos/CRP/minero/Minar.sh
            echo ""                                                                                             >> /root/Cryptos/CRP/minero/Minar.sh
            echo 'echo ""'                                                                                      >> /root/Cryptos/CRP/minero/Minar.sh
            echo 'echo "  Ejecutando el minero de Utopia..."'                                                   >> /root/Cryptos/CRP/minero/Minar.sh
            echo 'echo ""'                                                                                      >> /root/Cryptos/CRP/minero/Minar.sh
            echo ''                                                                                             >> /root/Cryptos/CRP/minero/Minar.sh
            echo '# Crear el bucle'                                                                             >> /root/Cryptos/CRP/minero/Minar.sh
            echo '  while true'                                                                                 >> /root/Cryptos/CRP/minero/Minar.sh
            echo '    do'                                                                                       >> /root/Cryptos/CRP/minero/Minar.sh
            echo '      # Ejecutar el comando'                                                                  >> /root/Cryptos/CRP/minero/Minar.sh
            echo '        ~/Cryptos/CRP/minero/uam --pk $cPublicKey --http ["$vIPLocalDelMinero"]:8090 --no-ui' >> /root/Cryptos/CRP/minero/Minar.sh
            echo '      # Verificr el código de salida del comando'                                             >> /root/Cryptos/CRP/minero/Minar.sh
            echo '        if [ $? -eq 0 ]; then'                                                                >> /root/Cryptos/CRP/minero/Minar.sh
            echo '          echo ""'                                                                            >> /root/Cryptos/CRP/minero/Minar.sh
            echo '          echo "    El proceso de ejecución del minero ha sido correcto."'                    >> /root/Cryptos/CRP/minero/Minar.sh
            echo '          echo ""'                                                                            >> /root/Cryptos/CRP/minero/Minar.sh
            echo '        else'                                                                                 >> /root/Cryptos/CRP/minero/Minar.sh
            echo '          echo ""'                                                                            >> /root/Cryptos/CRP/minero/Minar.sh
            echo '          echo "    El minero ha finalizado debido a un error."'                              >> /root/Cryptos/CRP/minero/Minar.sh
            echo '          echo ""'                                                                            >> /root/Cryptos/CRP/minero/Minar.sh
            echo '        fi'                                                                                   >> /root/Cryptos/CRP/minero/Minar.sh
            echo '      # Esperar 5 segundos antes de re-ejecutar el comando'                                   >> /root/Cryptos/CRP/minero/Minar.sh
            echo '        echo ""'                                                                              >> /root/Cryptos/CRP/minero/Minar.sh
            echo '        echo "  Volviendo a ejecutar el minero..."'                                           >> /root/Cryptos/CRP/minero/Minar.sh
            echo '        echo ""'                                                                              >> /root/Cryptos/CRP/minero/Minar.sh
            echo '        sleep 5'                                                                              >> /root/Cryptos/CRP/minero/Minar.sh
            echo '    done'                                                                                     >> /root/Cryptos/CRP/minero/Minar.sh
            chmod +x                                                                                               /root/Cryptos/CRP/minero/Minar.sh

          # Crear la configuración de conexión por defecto
            vIPLocal=$(hostname -I)
            vPuertoCentena=$(echo $vIPLocal | cut -d'.' -f4)
            mkdir -p /root/.uam/ > /dev/null
            echo "[net]"                                   > /root/.uam/uam.ini
            echo "listens=[$vIPLocal]:609$vPuertoCentena" >> /root/.uam/uam.ini
            sed -i -e 's| ]|]|g' /root/.uam/uam.ini

          # Auto-arrancar el minero cada vez que se inicia sesión como root
            echo "~/Cryptos/CRP/minero/Minar.sh" > /root/.bash_profile

        ;;

        2)

          echo ""
          echo -e "${cColorVerde}  Moviendo el minero de CRP a la carpeta del usuario no-root...${cFinColor}"
          echo ""
          # Pedir el nombre del usuario no-root
             vUsuarioCRPNoRoot=$(dialog --keep-tite --title "Ingresa el nombre para el usuario no-root" --inputbox "Nombre de usuario:" 8 60 3>&1 1>&2 2>&3 3>&- )
          if id "$vUsuarioCRPNoRoot" &>/dev/null; then
            # Crear la carpeta
              mkdir -p  /home/$vUsuarioCRPNoRoot/Cryptos/CRP/minero/ 2> /dev/null
            # Borrar el minero ya instalado
              rm -rf /home/$vUsuarioCRPNoRoot/Cryptos/CRP/minero/
            # Mover carpeta de mineros
              mv /root/Cryptos/CRP/minero/ /home/$vUsuarioCRPNoRoot/Cryptos/CRP/
            # Pasar el archivo de conexión por defecto
              mkdir -p /home/$vUsuarioCRPNoRoot/.uam/ > /dev/null
              cp /root/.uam/uam.ini /home/$vUsuarioCRPNoRoot/.uam/uam.ini
            # Reparación de permisos
              chown $vUsuarioCRPNoRoot:$vUsuarioCRPNoRoot /home/$vUsuarioCRPNoRoot/ -R 2> /dev/null
            # Borrar el minero de la carpeta del root
              rm -rf /root/Cryptos/CRP/
          else
            echo ""
            echo "  El usuario $vUsuarioCRPNoRoot no existe. Abortando script..."
            echo ""
            echo "  El minero ha quedado instalado sólo para el usuario root."
            echo ""
            exit
          fi

        ;;

        3)

          echo ""
          echo -e "${cColorVerde}  Agregando los mineros del root a los ComandosPostArranque...${cFinColor}"
          echo ""
          # CRP
            echo "#/root/Cryptos/CRP/minero/Minar.sh &" >> /root/scripts/ComandosPostArranque.sh
            echo "#disown -a"                           >> /root/scripts/ComandosPostArranque.sh
        ;;

        4)

          echo ""
          echo -e "${cColorVerde}  Agregando el minero del usuario $vUsuarioCRPNoRoot a los ComandosPostArranque...${cFinColor}"
          echo ""
          # CRP
            echo "#su $vUsuarioCRPNoRoot -c /home/$vUsuarioCRPNoRoot/Cryptos/CRP/minero/Minar.sh &" >> /root/scripts/ComandosPostArranque.sh
            echo "#disown -a"                                                                       >> /root/scripts/ComandosPostArranque.sh
        ;;

        5)

          curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Usuario-Root-AutologuearEnModoTexto-Activar.sh | bash

        ;;


    esac

done

