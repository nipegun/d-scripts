#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para calcular la palabra checksum de una semilla BIP39
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Cryptos-BIP39-CalcularPalabraChecksum.sh | bash -s URL Servicio
#
#  Ejemplo:
#    curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Cryptos-BIP39-CalcularPalabraChecksum.sh | bash -s "/tmp/semillas.txt"
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    exit
  fi

cCantArgumEsperados=1

if [ $# -ne $cCantArgumEsperados ]
  then
    echo ""
    echo -e "${cColorRojo}  Mal uso del script. El uso correcto sería: ${cFinColor}"
    echo "    $0 [RutaHaciaElArchivoConLasSemillas]"
    echo ""
    echo "  Ejemplo:"
    echo "    $0 '/tmp/semillas.txt'"
    echo ""
    exit
  else
    cArchivoConSemillas="$1"
    if [ -f "$cArchivoConSemillas"  ];then
      vCantPalabrasEnArchivo=$(cat "$cArchivoConSemillas" | wc -w)
      echo ""
      echo "  La cantidad de palabras que contiene el archivo es $vCantPalabrasEnArchivo."
      echo ""
      # Realizar una acción dependiendo de la cantidad de palabras encontradas
        if [[  $vCantPalabrasEnArchivo == "11" ]];then
          # Determinar los bits a agregar
            vBitsAAgregar='7'
          # Descargar el archivo con la lista de palabras en inglés
            # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}  El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update
                apt-get -y install wget
                echo ""
              fi
            # Descargar el archivo a /tmp/
              rm -f /tmp/BIP39english.txt
              wget -q https://raw.githubusercontent.com/bitcoin/bips/master/bip-0039/english.txt -O /tmp/BIP39english.txt
          # Obtener los números binarios correspondientes a cada palabra
            echo ""
            echo "  A cada palabra le corresponden los siguientes números binarios:"
            echo ""
             while read vLinea; do
               for vPalabra in $vLinea; do
                 # Calcular el número binario
                   vNumeroDecimal=$(echo $(grep -n "^$vPalabra" /tmp/BIP39english.txt | cut -d':' -f1) - 1 | bc)
                   vNumeroBinario=$(echo "obase=2;$vNumeroDecimal" | bc)
                 # Obtener la longitud del número binario
                   vLongitudNumeroBinario=$((${#vNumeroBinario}))
                 # Calcular cuántos ceros a la izquierda se necesitan
                   vCantCerosIzq=$((11 - vLongitudNumeroBinario))
                 # Agregar los ceros a la izquierda
                   for ((i = 0; i < $vCantCerosIzq; i++)); do
                     vNumeroBinario="0$vNumeroBinario"
                   done
                 # Mostrar el número
                   echo $vNumeroBinario
               done
             echo ""
             done < "$cArchivoConSemillas"




             #while read vLinea; do
             #  for vPalabra in $vLinea; do
             #    grep -n "^$vPalabra" /tmp/BIP39english.txt
             #  done
             #done < "/tmp/BIP39english.txt"


          # Recorrer el archivo de semillas y asignar cada palabra a un array asociativo
            declare -A aBIP39english
            aBIP39english[0]="xxx"
            while read vLinea; do
              for vPalabra in $vLinea; do
                aBIP39english[$vLinea]="$vPalabra"
              done
            done < "/tmp/BIP39english.txt"
          # Consultar array
            #echo "  La cantidad de campos es: ${#aBIP39english[@]}."
            #echo ""
            #echo "    Los campos son los siguientes:"
            #echo ""
            # Iterar sobre el array
              #for vLinea in {1..2048}
              #  do
              #    echo ${!aBIP39english[[$vLinea]]}:${aBIP39english[[$vLinea]]}
              #  done
              #for vLinea in "${aBIP39english[@]}"
              #  do
              #    echo "$vLinea -> ${aBIP39english[$vLinea]}"
              #  done

        elif [[ $vCantPalabrasEnArchivo == "23" ]];then
          # Determinar los bits a agregar
            vBitsAAgregar='3'
        else
          echo ""
          echo -e "${cColorRojo} El archivo de semillas debe tener la siguiente cantidad de palabras: ${cFinColor}"
          echo -e "${cColorRojo}   11${cFinColor}"
          echo -e "${cColorRojo}   23${cFinColor}"
          echo -e "${cColorRojo}   pero tiene $vCantPalabrasEnArchivo ${cFinColor}"
          echo ""
          exit
        fi
    else
      echo ""
      echo -e "${cColorRojo}  El archivo $vArchivo no existe. Abortando script ${cFinColor}"
      echo ""
      exit
    fi
fi
