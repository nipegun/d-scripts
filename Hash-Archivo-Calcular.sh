#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para obtener el hash de un archivo con diferentes algoritmos:
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Hash-Archivo-Calcular.sh | bash -s RutaAlArchivo
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Hash-Archivo-Calcular.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Definir la cantidad de argumentos esperados
  cCantArgumEsperados=1

if [ $# -ne $cCantArgumEsperados ]
  then
    echo ""
    echo -e "${cColorRojo}  Mal uso del script. El uso correcto sería: ${cFinColor}"
    echo "    $0 [RutaAlArchivo]"
    echo ""
    echo "  Ejemplo:"
    echo "    $0 '/home/nico/Descargas/El informe.txt'"
    echo ""
    exit
  else

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update && apt-get -y install dialog
      echo ""
    fi

  # Crear el menú
    menu=(dialog --checklist "Marca los hashes que deseas calcular:" 22 96 16)
      opciones=(
        1 "SHA-512"    off
        2 "SHA-3"      off
        3 "BLAKE2"     off
        4 "SHA-256"    off
        5 "Whirlpool"  off
        6 "RIPEMD-160" off
        7 "SHA-1"      off
        8 "Tiger"      off
        9 "MD5"        off
       10 "CRC32"      off
       11 "Adler-32"   off
      )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Calculando el hash SHA-512 del archivo $1..."
            echo ""
            sha512sum "$1"

          ;;

          2)

            echo ""
            echo "  Calculando el hash SHA-3 del archivo $1..."
            echo ""
            sha3sum "$1"

          ;;

          3)

            echo ""
            echo "  Calculando el hash BLAKE2 del archivo $1..."
            echo ""
            b2sum "$1"

          ;;

          4)

            echo ""
            echo "  Calculando el hash SHA-256 del archivo $1..."
            echo ""
            sha256sum "$1"

          ;;

          5)

            echo ""
            echo "  Calculando el hash Wirpool del archivo $1..."
            echo ""
            # Comprobar si el paquete openssl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s openssl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}  El paquete openssl no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update && apt-get -y install openssl
                echo ""
              fi
            openssl dgst -whirlpool "$1"

          ;;


          6)

            echo ""
            echo "  Calculando el hash RIPEMD-160 del archivo $1..."
            echo ""
            # Comprobar si el paquete openssl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s openssl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}  El paquete openssl no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update && apt-get -y install openssl
                echo ""
              fi
            openssl dgst -rmd160 "$1"

          ;;

          7)

            echo ""
            echo "  Calculando el hash SHA-1 del archivo $1..."
            echo ""
            sha1sum "$1"

          ;;

          8)

            echo ""
            echo "  Calculando el hash Tiger del archivo $1..."
            echo ""
            # Comprobar si el paquete openssl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s openssl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}  El paquete openssl no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update && apt-get -y install openssl
                echo ""
              fi
            openssl dgst -tiger "$1"

          ;;

          9)

            echo ""
            echo "  Calculando el hash MD5 del archivo $1..."
            echo ""
            md5sum "$1"

          ;;

          10)

            echo ""
            echo "  Calculando el hash CRC32 del archivo $1..."
            echo ""
            cksum "$1"

          ;;

          11)

            echo ""
            echo "  Calculando el hash Adler-32 del archivo $1..."
            echo ""
            # Comprobar si el paquete openssl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s openssl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}  El paquete openssl no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                #apt-get -y update && apt-get -y install openssl
                echo ""
              fi
            openssl dgst -adler32 "$1"

          ;;

      esac

  done

fi

