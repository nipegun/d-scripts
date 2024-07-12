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

vPuerto=22

# -------------------------
# NO TOCAR A PARTIR DE AQUÍ
#--------------------------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

  # Comprobar si el script se está ejecutando con privilegios de administración (root o sudo)
    if [ "$EUID" -ne 0 ]; then
      echo -e "${cColorRojo}  El script debe ejecutarse con privilegios de administración (como root o con sudo).${cFinColor}"
      exit 1
    fi

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
      2 "Inverso - Solicitar asistencia remota hacia mi Debian (RDP)" off
      3 "Inverso - Solicitar asistencia remota hacia mi Debian (SSH)" off
      4 "Inverso - Permitir el acceso a un servicio en un puerto de este ordenador" off
      5 "Inverso - Permitir el acceso a un servicio en un puerto de otro ordenador de mi subred" off
      6 "Inverso - Publicar un servicio propio en una IP diferente a la nuestra" off
      7 "Opción 5" off
      8 "Opción 5" off
      9 "Opción 5" off
     10 "Opción 5" off
     11 "Opción 5" off
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
              vPuertoServicioLocal=3389
              vPuertoEnOrdenadorRemoto=63389
              vUsuarioRemoto="nipegun"
              vIPoDNSRemoto="0.0.0.0"

            # Comprobar que el puerto del servidor SSH sea el 22
              if [ "$vPuerto" -eq 22 ]; then
                ssh -R localhost:$vPuertoEnOrdenadorRemoto:localhost:$vPuertoServicioLocal "$vUsuarioRemoto"@"$vIPoDNSRemoto"
              else
                ssh -R localhost:$vPuertoEnOrdenadorRemoto:localhost:$vPuertoServicioLocal "$vUsuarioRemoto"@"$vIPoDNSRemoto" -p "$vPuerto"
              fi
  
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

          6)

            echo ""
            echo "  Opción 6..."
            echo ""

          ;;

          7)

            echo ""
            echo "  Opción 7..."
            echo ""

          ;;

          8)

            echo ""
            echo "  Opción 8..."
            echo ""

          ;;

          9)

            echo ""
            echo "  Opción 9..."
            echo ""

          ;;

      esac

  done
