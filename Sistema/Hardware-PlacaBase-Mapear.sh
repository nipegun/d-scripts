#!/bin/bash

####
####  Script no terminado
####

vArchivoDOT="/tmp/Prueba.dot"
vImagenMapaFinal="/tmp/MapaHardware.png"
vUsuarioLogueado="nipegun"

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  #if [ $(id -u) -ne 0 ]; then
  if [[ $EUID -ne 0 ]]; then
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    echo ""
    exit
  fi

# Comprobar si las herramientas necesarias están instaladas
  # lshw
    if [[ $(dpkg-query -s lshw 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete lshw no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update && apt-get -y install lshw
      echo ""
    fi
  # pciutils
    if [[ $(dpkg-query -s pciutils 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete pciutils no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update && apt-get -y install pciutils
      echo ""
    fi
  # usbutils
    if [[ $(dpkg-query -s usbutils 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete usbutils no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update && apt-get -y install usbutils
      echo ""
    fi
  # dmidecode
    if [[ $(dpkg-query -s dmidecode 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete dmidecode no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update && apt-get -y install dmidecode
      echo ""
    fi

# Iniciar el archivo DOT
  echo "digraph G {"          > $vArchivoDOT
  echo "  layout=neato;"     >> $vArchivoDOT
  echo "  overlap=false;"    >> $vArchivoDOT
  echo "  node [shape=box];" >> $vArchivoDOT

# Obtener información de la placa base
  echo ""
  echo -e "  Obteniendo información de la placa base..."
  echo ""
  vInfoPlacaBse=$(dmidecode -t baseboard | grep -E 'Manufacturer|Product Name')
  #echo "\"PlacaBase\" [label=\"Placa Base\n$vInfoPlacaBase\"];" >> $vArchivoDOT




# Obtener información del procesador
  echo ""
  echo "  Obteniendo información del procesador"
  echo ""
  vInfoProcesador=$(dmidecode -t processor | grep -E "Socket Designation|Version")
  echo "\"Procesador\" [label=\"Procesador\n$vInfoProcesador\"];" >> $vArchivoDOT


# Obtener información del chipset y bridges
  #echo ""
  #echo -e "  Obteniendo información del chipset y los puentes norte y sur..."
  #echo ""
  #vPuentes=$(lshw -class bridge)
  #vPuenteNorte=$(echo "$bridges" | grep -i "northbridge")
  #vPuenteSur=$(echo "$bridges" | grep -i "southbridge")
  #echo "\"NorthBridge\" [label=\"North Bridge\n$vPuenteNorte\"];" >> $vArchivoDOT
  #echo "\"SouthBridge\" [label=\"South Bridge\n$vPuenteSur\"];"   >> $vArchivoDOT
  #echo "\"PlacaBase\" -> \"NorthBridge\";"                        >> $vArchivoDOT
  #echo "\"PlacaBase\" -> \"SouthBridge\";"                        >> $vArchivoDOT

# Obtener información de los puertos PCIe de la placa base
  # Definir el array asociativo
    declare -A vPuertosPCIe
    vPuertosPCIe=$(dmidecode -t 9 | grep -E "Designation|Type|ID" | sed 's/\t//g' | cut -d' ' -f2)

# Obtener información de los puertos PCIe y los dispositivos conectados
  echo ""
  echo -e "  Obteniendo información de los puertos PCIe..."
  echo ""
  vPuertosPCIe=$(lspci)
  echo "$vPuertosPCIe" | while read -r line; do
    vSlot=$(echo $line | cut -d ' ' -f 1)
    vDispositivo=$(echo $line | cut -d ' ' -f 2-)
    echo "\"PCIe_$vSlot\" [label=\"$vDispositivo\"];" >> $vArchivoDOT
    echo "\"NorthBridge\" -> \"PCIe_$vSlot\";"        >> $vArchivoDOT

# Obtener información de los dispositivos USB
  #echo ""
  #echo -e "  Obteniendo información de los buses USB y de los dispositivos conectados a ellos..."
  #vDispositivosUSB=$(lsusb)
  #echo "$vDispositivosUSB" | while read -r line; do
  #  vBusUSB=$(echo $line | cut -d ' ' -f 2)
  #  vDispositivoUSB=$(echo $line | cut -d ' ' -f 6-)
  #  echo "\"USB_$vBusUSB\" [label=\"$vDispositivoUSB\"];" >> $vArchivoDOT
  #  echo "\"SouthBridge\" -> \"USB_$vBusUSB\";"           >> $vArchivoDOT
  #done

# Finalizar el archivo DOT
  echo "}" >> $vArchivoDOT
  # Notificar generación del archivo
    echo ""
    echo "  Archivo DOT generado: $vArchivoDOT"
    echo ""

# Generar la imagen usando Graphviz
  dot -Tpng $vArchivoDOT -o $vImagenMapaFinal
  # Notificar generación de la imagen con el mapa
    echo ""
    echo "  Gráfico generado: $vImagenMapaFinal"
    echo ""

# Mostrar la imagen
  echo ""
  echo "  Mostrando la imagen..."
  echo ""
  # if desktop gnome
  #   eog $vImagenMapaFinal
  # if desktop mate
  #   eom $vImagenMapaFinal
  # Comprobar que el paquete sxiv esté instalado
    if [[ $(dpkg-query -s sxiv 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete sxiv no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update && apt-get -y install sxiv
      echo ""
    fi
  su - $vUsuarioLoqueado -c "eom $vImagenMapaFinal"


