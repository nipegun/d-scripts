#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

--
# Script de NiPeGun para instalar y configurar los mineros para las diferentes criptomonedas
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Cryptos-Mineros-InstalarYConfigurar.sh | bash
--

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

UsuarioNoRoot=NiPeGun

echo ""
echo -e "${cColorVerde}  Iniciando el script de instalación de los diferentes mineros de criptomonedas...${cFinColor}"
echo ""

# Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo -e "${cColorRojo}  dialog no está instalado. Iniciando su instalación...${cFinColor}"
    echo ""
    apt-get -y update
    apt-get -y install dialog
    echo ""
  fi

menu=(dialog --timeout 5 --checklist "Marca los mineros que quieras instalar:" 22 96 16)
  opciones=(
    1 "Instalar el minero de XMR para el usuario root" off
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
   12 "Agregar los mineros del usuario $UsuarioNoRoot a los ComandosPostArranque" off
  )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo -e "${cColorVerde}  Instalando el minero de XMR (Monero) para el usuario root...${cFinColor}"
          echo ""

          # Crear la carpeta
             mkdir -p /root/Cryptos/XMR/minero/ 2> /dev/null

        ;;

        2)

          echo ""
          echo -e "${cColorVerde}  Moviendo el minero de XMR a la carpeta del usuario $UsuarioNoRoot...${cFinColor}"
          echo ""

          # Mover carpeta de mineros
             mkdir -p /home/$UsuarioNoRoot/Cryptos/XMR/ 2> /dev/null
             mv /root/Cryptos/XMR/minero/ /home/$UsuarioNoRoot/Cryptos/XMR/minero/
          # Reparación de permisos
             chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R

        ;;

        3)

          echo ""
          echo -e "${cColorVerde}  Instalando el minero de RVN (Raven) con AMD para el usuario root...${cFinColor}"
          echo ""

          # Crear la carpeta
             mkdir -p /root/Cryptos/RVN/minero/amd/ 2> /dev/null

        ;;

        4)

          echo ""
          echo -e "${cColorVerde}  Moviendo el minero de RVN con AMD a la carpeta del usuario $UsuarioNoRoot...${cFinColor}"
          echo ""

          # Mover carpeta de mineros
             mkdir -p /home/$UsuarioNoRoot/Cryptos/RVN/minero/ 2> /dev/null
             mv /root/Cryptos/RVN/minero/amd/ /home/$UsuarioNoRoot/Cryptos/RVN/minero/amd/
          # Reparación de permisos
             chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R

        ;;

        5)

          echo ""
          echo -e "${cColorVerde}  Instalando el minero de RVN (Raven) con nVidia para el usuario root...${cFinColor}"
          echo ""

          # Crear la carpeta
             mkdir -p /root/Cryptos/RVN/minero/nvidia/ 2> /dev/null

        ;;

        6)

          echo ""
          echo -e "${cColorVerde}  Moviendo el minero de RVN con nVidia a la carpeta del usuario $UsuarioNoRoot...${cFinColor}"
          echo ""

          # Mover carpeta de mineros
             mv /root/Cryptos/RVN/minero/nvidia/ /home/$UsuarioNoRoot/Cryptos/RVN/minero/
          # Reparación de permisos
             chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R

        ;;


        9)

          echo ""
          echo -e "${cColorVerde}  Instalando el minero de LTC (Litecoin) para el usuario root...${cFinColor}"
          echo ""

          # Crear la carpeta
             mkdir -p /root/MinerosCrypto/LTC/ 2> /dev/null

        ;;

        10)

          echo ""
          echo -e "${cColorVerde}  Moviendo el minero de LTC a la carpeta del usuario $UsuarioNoRoot...${cFinColor}"
          echo ""

          # Mover carpeta de mineros
             mv /root/MinerosCrypto/ /home/$UsuarioNoRoot//MinerosCrypto/
          # Reparación de permisos
             chown $UsuarioNoRoot:$UsuarioNoRoot /home/$UsuarioNoRoot/ -R

        ;;

        11)

          echo ""
          echo -e "${cColorVerde}  Agregando los mineros del root a los ComandosPostArranque...${cFinColor}"
          echo ""
          # CRP
             echo "#/root/MinerosCrypto/CRP/Minar.sh &" >> /root/scripts/ComandosPostArranque.sh
             echo "#disown -a"                          >> /root/scripts/ComandosPostArranque.sh
        ;;

        12)

          echo ""
          echo -e "${cColorVerde}  Agregando los mineros del usuario $UsuarioNoRoot a los ComandosPostArranque...${cFinColor}"
          echo ""
          # CRP
             echo "#su $UsuarioNoRoot -c /home/$UsuarioNoRoot/MinerosCrypto/CRP/Minar.sh &" >> /root/scripts/ComandosPostArranque.sh
             echo "#disown -a"                                                             >> /root/scripts/ComandosPostArranque.sh
        ;;

      esac

done


