#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para importar el pack CyberSecLab para VirtualBox en Debian
#
# Pre-ejecución remota:
#   sudo apt-get -y update && sudo apt-get -y install dialog wget
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaGUI/VirtualBox/Packs/CyberSecLab-Importar.sh | bash (No se debe hacer sudo bash)
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaGUI/VirtualBox/Packs/CyberSecLab-Importar.sh | nano -
# ----------

# Definir la carpeta donde están las máquinas virtuales (normalmente "/home/usuarios/VirtualBox VMs/" )
  vCarpetaDeMVs='~/VirtualBox VMs'

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el paquete virtualbox está instalado.
  if ! command -v virtualbox &> /dev/null; then
    echo ""
    echo -e "${cColorRojo}  VirtualBox no está instalado.${cFinColor}"
    echo ""
    echo -e "${cColorRojo}    Para instalarlo ejecuta como root:${cFinColor}"
    echo ""
    echo -e "${cColorRojo}      curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaGUI/VirtualBox-Instalar.sh | bash${cFinColor}"
    echo ""
    echo -e "${cColorRojo}    ...o como usuario con permisos sudo:${cFinColor}"
    echo ""
    echo -e "${cColorRojo}      curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ParaGUI/VirtualBox-Instalar.sh | sudo bash${cFinColor}"
    echo ""
    exit
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

# Ejecutar comandos dependiendo de la versión de Debian detectada

  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de importación del pack CyberSecLab para el VirtualBox de Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de importación del pack CyberSecLab para el VirtualBox de Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Crear el menú
      #menu=(dialog --timeout 5 --checklist "Marca las opciones que quieras instalar:" 22 96 16)
      menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
        opciones=(
          1 "Crear la máquina virtual de OpenWrt"             on
          2 "  Importar .vmdk de OpenWrt"                     on
          3 "Crear la máquina virtual de Kali"                on
          4 "  Importar .vmdk de Kali"                        on
          5 "Crear la máquina virtual de SIFT..."             off
          6 "  Importar .vmdk de Sift..."                     off
          7 "Crear la máquina virtual de Windows Server 22"   off
          8 "  Importar .vmdk de Windows Server 22"           off
          9 "Crear la máquina virtual de Windows 11 Pro"      off
         10 "  Importar .vmdk de Windows 11 Pro"              off
         11 "Crear la máquina virtual de pruebas para el lab" on
         12 "Agrupar las máquinas virtuales"                  off
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      #clear

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Creando la máquina virtual de OpenWrt..."
              echo ""
              VBoxManage createvm --name "openwrtlab" --ostype "Linux_64" --register
              VBoxManage modifyvm "openwrtlab" --firmware efi
              # Procesador
                VBoxManage modifyvm "openwrtlab" --cpus 2
              # RAM
                VBoxManage modifyvm "openwrtlab" --memory 2048
              # Gráfica
                VBoxManage modifyvm "openwrtlab" --graphicscontroller vmsvga --vram 16 
              # Audio
                VBoxManage modifyvm "openwrtlab" --audio none
              # Red
                VBoxManage modifyvm "openwrtlab" --nictype1 virtio
                  VBoxManage modifyvm "openwrtlab" --nic1 "NAT"
                VBoxManage modifyvm "openwrtlab" --nictype2 virtio
                  VBoxManage modifyvm "openwrtlab" --nic2 intnet --intnet2 "redintlan"
                VBoxManage modifyvm "openwrtlab" --nictype3 virtio
                  VBoxManage modifyvm "openwrtlab" --nic3 intnet --intnet3 "redintlab"
              # Almacenamiento
                # CD
                  VBoxManage storagectl "openwrtlab" --name "SATA Controller" --add sata --controller IntelAhci --portcount 1
                  VBoxManage storageattach "openwrtlab" --storagectl "SATA Controller" --port 0 --device 0 --type dvddrive --medium emptydrive
                # Controladora de disco duro
                  VBoxManage storagectl "openwrtlab" --name "VirtIO" --add "VirtIO" --bootable on --portcount 1

            ;;

            2)

              echo ""
              echo "    Importando .vmdk de OpenWrt..."
              echo ""
              cd "$vCarpetaDeMVs"/openwrtlab/
              wget http://hacks4geeks.com/_/descargas/MVs/Discos/Packs/CyberSecLab/openwrtlab.vmdk
              VBoxManage storageattach "openwrtlab" --storagectl "VirtIO" --port 0 --device 0 --type hdd --medium "$vCarpetaDeMVs"/openwrtlab/openwrtlab.vmdk

            ;;

            3)

              echo ""
              echo "  Creando la máquina virtual de Kali..."
              echo ""
              VBoxManage createvm --name "kali" --ostype "Debian_64" --register
              VBoxManage modifyvm "kali" --firmware efi
              # Procesador
                VBoxManage modifyvm "kali" --cpus 4
              # RAM
                VBoxManage modifyvm "kali" --memory 4096
              # Gráfica
                VBoxManage modifyvm "kali" --graphicscontroller vmsvga --vram 128 --accelerate3d on
              # Red
                VBoxManage modifyvm "kali" --nictype1 virtio
                VBoxManage modifyvm "kali" --nic1 intnet --intnet1 "redintlan"
              # Almacenamiento
                # CD
                  VBoxManage storagectl "kali" --name "SATA Controller" --add sata --controller IntelAhci --portcount 1
                  VBoxManage storageattach "kali" --storagectl "SATA Controller" --port 0 --device 0 --type dvddrive --medium emptydrive
                # Controladora de disco duro
                  VBoxManage storagectl "kali" --name "VirtIO" --add "VirtIO" --bootable on --portcount 1

            ;;

            4)

              echo ""
              echo "    Importando .vmdk de Kali..."
              echo ""
              cd "$vCarpetaDeMVs"/kali/
              wget http://hacks4geeks.com/_/descargas/MVs/Discos/Packs/CyberSecLab/kali.vmdk
              VBoxManage storageattach "kali" --storagectl "VirtIO" --port 0 --device 0 --type hdd --medium "$vCarpetaDeMVs"/kali/kali.vmdk

            ;;

            5)

              echo ""
              echo "  Creando la máquina virtual de SIFT..."
              echo ""
              VBoxManage createvm --name "sift" --ostype "Ubuntu_64" --register
              VBoxManage modifyvm "sift" --firmware efi
              # Procesador
                VBoxManage modifyvm "sift" --cpus 4
              # RAM
                VBoxManage modifyvm "sift" --memory 4096
              # Gráfica
                VBoxManage modifyvm "sift" --graphicscontroller vmsvga --vram 128 --accelerate3d on
              # Red
                VBoxManage modifyvm "sift" --nictype1 virtio
                VBoxManage modifyvm "sift" --nic1 intnet --intnet1 "redintlan"
              # Almacenamiento
                # CD
                  VBoxManage storagectl "sift" --name "SATA Controller" --add sata --controller IntelAhci --portcount 1
                  VBoxManage storageattach "sift" --storagectl "SATA Controller" --port 0 --device 0 --type dvddrive --medium emptydrive
                # Controladora de disco duro
                  VBoxManage storagectl "sift" --name "VirtIO" --add "VirtIO" --bootable on --portcount 1


            ;;

            6)

              echo ""
              echo "    Importando .vmdk de Sift..."
              echo ""
              cd "$vCarpetaDeMVs"/sift/
              wget http://hacks4geeks.com/_/descargas/MVs/Discos/Packs/CyberSecLab/sift.vmdk
              VBoxManage storageattach "sift" --storagectl "VirtIO" --port 0 --device 0 --type hdd --medium "$vCarpetaDeMVs"/sift/sift.vmdk

            ;;

            7)

              echo ""
              echo "  Creando la máquina virtual de Windows Server 22..."
              echo ""

            ;;

            8)

              echo ""
              echo "    Importando .vmdk de Windows Server 22..."
              echo ""
              cd "$vCarpetaDeMVs"/winserver22/
              wget http://hacks4geeks.com/_/descargas/MVs/Discos/Packs/CyberSecLab/winserver22.vmdk
              VBoxManage storageattach "winserver22" --storagectl "VirtIO" --port 0 --device 0 --type hdd --medium ~/"VirtualBox VMs/winserver22/winserver22.vmdk"

            ;;

            9)

              echo ""
              echo "  Creando la máquina virtual de Windows 11 Pro..."
              echo ""

            ;;

           10)

              echo ""
              echo "    Importando .vmdk de Windows 11 Pro..."
              echo ""
              cd "$vCarpetaDeMVs"/win11pro/
              wget http://hacks4geeks.com/_/descargas/MVs/Discos/Packs/CyberSecLab/win11pro.vmdk
              VBoxManage storageattach "win11pro" --storagectl "VirtIO" --port 0 --device 0 --type hdd --medium "$vCarpetaDeMVs"/win11pro/win11pro.vmdk

            ;;

           11)

              echo ""
              echo "  Creando la máquina virtual de pruebas para el lab..."
              echo ""
              VBoxManage createvm --name "pruebas" --ostype "Other_64" --register
              VBoxManage modifyvm "pruebas" --firmware efi
              # Procesador
                VBoxManage modifyvm "pruebas" --cpus 4
              # RAM
                VBoxManage modifyvm "pruebas" --memory 4096
              # Gráfica
                VBoxManage modifyvm "pruebas" --graphicscontroller vmsvga --vram 128 --accelerate3d on
              # Red
                VBoxManage modifyvm "pruebas" --nictype1 virtio
                VBoxManage modifyvm "pruebas" --nic1 intnet --intnet1 "redintlab"
              # Almacenamiento
                # CD
                  VBoxManage storagectl "pruebas" --name "SATA Controller" --add sata --controller IntelAhci --portcount 1
                  VBoxManage storageattach "pruebas" --storagectl "SATA Controller" --port 0 --device 0 --type dvddrive --medium emptydrive
                # Controladora de disco duro
                  VBoxManage storagectl "pruebas" --name "VirtIO" --add "VirtIO" --bootable on --portcount 1

            ;;

           12)

              echo ""
              echo "  Agrupando las máquinas virtuales..."
              echo ""
              VBoxManage modifyvm "openwrtlab"  --groups "/CyberSecLab"
              VBoxManage modifyvm "kali"        --groups "/CyberSecLab"
              VBoxManage modifyvm "sift"        --groups "/CyberSecLab"
              VBoxManage modifyvm "winserver22" --groups "/CyberSecLab"
              VBoxManage modifyvm "win11pro"    --groups "/CyberSecLab"
              VBoxManage modifyvm "pruebas"     --groups "/CyberSecLab"

            ;;

        esac

    done

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de importación del pack CyberSecLab para el VirtualBox de Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de importación del pack CyberSecLab para el VirtualBox de Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de importación del pack CyberSecLab para el VirtualBox de Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de importación del pack CyberSecLab para el VirtualBox de Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de importación del pack CyberSecLab para el VirtualBox de Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
