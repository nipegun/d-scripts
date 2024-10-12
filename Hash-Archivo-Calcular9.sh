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
    menu=(dialog --checklist "Marca los hashes que deseas calcular:" 24 50 16)
      opciones=(
        1 "SHA-3 512"  on
        2 "SHA-512"    on
        3 "SHA-3 384"  on
        4 "SHA-384"    on
        5 "SHA-3 256"  on
        6 "SHA-256"    on
        7 "BLAKE2"     on
        8 "SHA-3 224"  on
        9 "SHA-224"    on
       10 "Whirlpool"  off
       11 "RIPEMD-160" on
       12 "SHA-1"      on
       13 "Tiger"      off
       14 "MD5"        on
       15 "CRC32"      on
       16 "Adler-32"   off
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
            echo -e "    El hash SHA-3 512 es: ${cColorAzulClaro}$vHashSHA3_512${cFinColor}"

          ;;

          2)

            echo ""
            echo "  Calculando el hash SHA-512 del archivo $1..."
            echo ""
            vHashSHA_512=$(sha512sum "$1" | cut -d' ' -f1)
            echo -e "    El hash SHA-512 es: ${cColorAzulClaro}$vHashSHA_512${cFinColor}"

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
            echo -e "    El hash SHA-3 384 es: ${cColorAzulClaro}$vHashSHA3_384${cFinColor}"

          ;;

          4)

            echo ""
            echo "  Calculando el hash SHA-384 del archivo $1..."
            echo ""
            vHashSHA_384=$(sha384sum "$1" | cut -d' ' -f1)
            echo -e "    El hash SHA-384 es: ${cColorAzulClaro}$vHashSHA_384${cFinColor}"

          ;;

          5)

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
            echo -e "    El hash SHA-3 256 es: ${cColorAzulClaro}$vHashSHA3_256${cFinColor}"

          ;;

          6)

            echo ""
            echo "  Calculando el hash SHA-256 del archivo $1..."
            echo ""
            vHashSHA_256=$(sha256sum "$1" | cut -d' ' -f1)
            echo -e "    El hash SHA-256 es: ${cColorAzulClaro}$vHashSHA_256${cFinColor}"

          ;;

          7)

            echo ""
            echo "  Calculando el hash BLAKE2 del archivo $1..."
            echo ""
            vHashBLAKE2=$(b2sum "$1" | cut -d' ' -f1)
            echo -e "    El hash BLAKE2 es: ${cColorAzulClaro}$vHashBLAKE2${cFinColor}"

          ;;

          8)

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
            echo -e "    El hash SHA-3 224 es: ${cColorAzulClaro}$vHashSHA3_224${cFinColor}"

          ;;

          9)

            echo ""
            echo "  Calculando el hash SHA-224 del archivo $1..."
            echo ""
            vHashSHA_224=$(sha224sum "$1" | cut -d' ' -f1)
            echo -e "    El hash SHA-224 es: ${cColorAzulClaro}$vHashSHA_224${cFinColor}"

          ;;

         10)

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

         11)

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
            vHashRIPEMD_160=$(openssl dgst -rmd160 "$1" | cut -d'=' -f2 | sed 's- --g')
            echo -e "    El hash RIPEMD-160 es: ${cColorAzulClaro}$vHashRIPEMD_160${cFinColor}"
            openssl dgst -rmd160 "$1"

          ;;

          12)

            echo ""
            echo "  Calculando el hash SHA-1 del archivo $1..."
            echo ""
            vHashSHA1=$(sha1sum "$1" | cut -d' ' -f1)
            echo -e "    El hash SHA-1 es: ${cColorAzulClaro}$vHashSHA1${cFinColor}"

          ;;

          13)

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

          14)

            echo ""
            echo "  Calculando el hash MD5 del archivo $1..."
            echo ""
            vHashMD5=$(md5sum "$1" | cut -d' ' -f1)
            echo -e "    El hash MD5 es: ${cColorAzulClaro}$vHashMD5${cFinColor}"

          ;;

          15)

            echo ""
            echo "  Calculando el hash CRC32 del archivo $1..."
            echo ""
            vHashCRC32=$(cksum "$1")
            echo "    El hash CRC32 es: $vHashCRC32"
            cksum "$1"

          ;;

          16)

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

