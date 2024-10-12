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
    menu=(dialog --checklist "Marca los hashes que deseas calcular:" 22 50 16)
      opciones=(
        1 "SHA-3 512"  on
        2 "SHA-512"    on
        3 "SHA-3 384"  on
        4 "SHA-3 256"  on
        5 "SHA-256"    on
        6 "BLAKE2"     on
        7 "SHA-3 224"  on
        8 "Whirlpool"  off
        9 "RIPEMD-160" on
       10 "SHA-1"      on
       11 "Tiger"      off
       12 "MD5"        on
       13 "CRC32"      on
       14 "Adler-32"   off
      )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Calculando el hash SHA-3 512 del archivo $1..."
            echo ""
            # Comprobar si el paquete openssl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s openssl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}  El paquete openssl no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update && apt-get -y install openssl
                echo ""
              fi
            vHashSHA3_512=$(openssl dgst -sha3-512 "$1" | cut -d'=' -f2 | sed 's- --g')
            echo "    El hash SHA-3 512 es: $vHashSHA3_512"

          ;;

          2)

            echo ""
            echo "  Calculando el hash SHA-512 del archivo $1..."
            echo ""
            sha512sum "$1"

          ;;

          3)

            echo ""
            echo "  Calculando el hash SHA-3 384 del archivo $1..."
            echo ""
            # Comprobar si el paquete openssl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s openssl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}  El paquete openssl no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update && apt-get -y install openssl
                echo ""
              fi
            vHashSHA3_384=$(openssl dgst -sha3-384 "$1" | cut -d'=' -f2 | sed 's- --g')
            echo "    El hash SHA-3 384 es: $vHashSHA3_384"

          ;;

          4)

            echo ""
            echo "  Calculando el hash SHA-3 256 del archivo $1..."
            echo ""
            # Comprobar si el paquete openssl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s openssl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}  El paquete openssl no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update && apt-get -y install openssl
                echo ""
              fi
            vHashSHA3_256=$(openssl dgst -sha3-256 "$1" | cut -d'=' -f2 | sed 's- --g')
            echo "    El hash SHA-3 256 es: $vHashSHA3_256"

          ;;

          5)

            echo ""
            echo "  Calculando el hash SHA-256 del archivo $1..."
            echo ""
            sha256sum "$1"

          ;;

          6)

            echo ""
            echo "  Calculando el hash BLAKE2 del archivo $1..."
            echo ""
            b2sum "$1"

          ;;

          7)

            echo ""
            echo "  Calculando el hash SHA-3 224 del archivo $1..."
            echo ""
            # Comprobar si el paquete openssl está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s openssl 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}  El paquete openssl no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update && apt-get -y install openssl
                echo ""
              fi
            vHashSHA3_224=$(openssl dgst -sha3-224 "$1" | cut -d'=' -f2 | sed 's- --g')
            echo "    El hash SHA-3 224 es: $vHashSHA3_224"

          ;;

          8)

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

          9)

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

          10)

            echo ""
            echo "  Calculando el hash SHA-1 del archivo $1..."
            echo ""
            sha1sum "$1"

          ;;

          11)

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

          12)

            echo ""
            echo "  Calculando el hash MD5 del archivo $1..."
            echo ""
            md5sum "$1"

          ;;

          13)

            echo ""
            echo "  Calculando el hash CRC32 del archivo $1..."
            echo ""
            cksum "$1"

          ;;

          14)

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

