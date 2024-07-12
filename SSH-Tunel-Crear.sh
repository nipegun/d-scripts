#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear túneles SSH en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SSH-Tunel-Crear.sh | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SSH-Tunel-Crear.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SSH-Tunel-Crear.sh | bash -s Parámetro1 Parámetro2
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
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    echo ""
    exit
  fi

vFechaDeEjec=$(date +a%Ym%md%d@%T)

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update && apt-get -y install dialog
      echo ""
    fi

  #menu=(dialog --timeout 5 --checklist "Marca las opciones que quieras instalar:" 22 96 16)
  menu=(dialog --checklist "¿Qué tipo de tunel quieres crear:" 22 96 16)
    opciones=(
      1 "Tunel hacia un servicio alojado en un ordenador de casa o de la oficina" on
      2 "Solicitar asistencia remota hacia mi Debian (RDP)" off
      3 "Solicitar asistencia remota hacia mi debian (SSH)" off
      4 "Opción 4" off
      5 "Opción 5" off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  #clear

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Creando un tunel hacia un servicio alojado en casa o en la oficina..."
            echo ""
            "Ingresa la IP o nombre DNS del servidor SSH remoto"
              vDirServidorSSHRemoto=""
            "Ingresa el usuario con el que te vas a conectar al servidor remoto:"
              vUsuarioSSHRemoto=""
            "Ingresa la IP LAN del ordenador remoto al que te quieres conectar:"
              vIPLANOrdenadorRemoto=""
            "Ingresa el puerto donde está el servicio del ordenador remoto:"
              vPuertoServicioOrdenadorRemoto=""
            "Ingresa el puerto de este ordenador en el que quieres mapear la conexión:"
              vPuertoLocal=""

            echo ""
            echo "    Intentando crear tunel con los siguientes datos:"
            echo ""
            echo "      IP remota del servidor SSH: $vDirServidorSSHRemoto"
            echo "      Usuario del servidor SSH: $vUsuarioSSHRemoto"
            echo "      IP LAN del ordenador de casa u oficina: $vIPLANOrdenadorRemoto"
            echo "      Puerto en el que está el servicio del ordenador: $vPuertoServicioOrdenadorRemoto"
            echo "      Puerto de este ordenador al que conectarse para acceder: $vPuertoLocal"
            echo ""
            echo "      Comando ejecutado:"
            echo "        ssh -L $vPuertoLocal:$vIPLANOrdenadorRemoto:$vPuertoServicioOrdenadorRemoto $vUsuarioSSHRemoto@$vDirServidorSSHRemoto"
            echo ""
            ssh -L $vPuertoLocal:$vIPLANOrdenadorRemoto:$vPuertoServicioOrdenadorRemoto $vUsuarioSSHRemoto@$vDirServidorSSHRemoto

          ;;

          2)

            echo ""
            echo "  Creando un tunel para solicitar asistencia remota hacia mi Debian (RDP)..."
            echo ""

            # Comprobar si el paquete ssh está instalado. Si no lo está, instalarlo.
              if [[ $(dpkg-query -s ssh 2>/dev/null | grep installed) == "" ]]; then
                echo ""
                echo -e "${cColorRojo}  El paquete ssh no está instalado. Iniciando su instalación...${cFinColor}"
                echo ""
                apt-get -y update && apt-get -y install ssh
                echo ""
              fi

            # Definir el usuario y la IP del servidor SSH remoto
              vUsuarioRemoto="nipegun"
              vIPRemota=""
            ssh -R localhost:3389:localhost:63389 root@dominio.com -p 11122
            ssh -R localhost:3389:localhost:63389 root@dominio.com
          ;;

          3)

            echo ""
            echo "  Creando un tunel para solicitar asistencia remota hacia mi Debian (SSH)..."
            echo ""

          ;;

          4)

            echo ""
            echo "  Opción 4..."
            echo ""

          ;;

          5)

            echo ""
            echo "  Opción 5..."
            echo ""

          ;;

      esac

  done
