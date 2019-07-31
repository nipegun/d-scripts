#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y preparar la compartición remota del escritorio en Debian 9
#------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

menu=(dialog --timeout 5 --checklist "Elección dl Sistema Operativo:" 22 76 16)
  opciones=(1 "Instalar Para Debian 9" on
            2 "Instalar para Ubuntu 18.04" off)
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  clear

  for choice in $choices

    do

      case $choice in

        1)
          echo ""
          echo "-----------------------------------------------------------------------------"
          echo -e "${ColorVerde}  Instalando y preparando el servidor de escritorio remoto para Debian 9...${FinColor}"
          echo "-----------------------------------------------------------------------------"
          echo ""
          echo "  Instalando el servidor xrdp..."
          echo ""
          apt-get -y update
          apt-get -y install xrdp
          cp /etc/xrdp/xrdp_keyboard.ini /etc/xrdp/xrdp_keyboard.ini.bak
          sed -i -e 's|rdp_layout_de=0x00000407|rdp_layout_de=0x00000407\nrdp_layout_es=0x0000040A|g' /etc/xrdp/xrdp_keyboard.ini
          sed -i -e 's|rdp_layout_de=de|rdp_layout_de=de\nrdp_layout_es=es|g' /etc/xrdp/xrdp_keyboard.ini
          sed -i -e 's|allowed_users=console|allowed_users=anybody|g' /etc/X11/Xwrapper.config        
          echo ""
          echo "  Activando XRDP como servicio..."
          echo ""
          systemctl enable xrdp
        ;;

        2)
          echo ""
          echo "------------------------------------------------------------------"
          echo "  Instalando y preparando el escritorio remoto para Ubuntu 18.04"
          echo "------------------------------------------------------------------"
          echo ""
          # Instalar Gnome Tweak Tool
          sudo apt-get -y install gnome-tweak-tool
          # Permitir el acceso a la consola
          sudo sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/X11/Xwrapper.config
          # Crear políticas de excepción
          echo "[Allow Colord all Users]" > /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla
          echo "Identity=unix-user:*" >> /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla
          echo "Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile" >> /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla
          echo "ResultAny=no" >> /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla
          echo "ResultInactive=no" >> /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla
          echo "ResultActive=yes" >> /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla
          # Activar las extensiones de Gnome Shell
          gnome-shell-extension-tool -e ubuntu-dock@ubuntu.com
          gnome-shell-extension-tool -e ubuntu-appindicators@ubuntu.com
          # Vaciar la carpeta de crashes
          sudo rm /var/crash/*
        ;;

      esac

done

echo ""
echo "  Ejecución del script, finalizada."
echo ""
echo "  Después de reiniciar el sistema deberías poder"
echo "  conectarte a su escritorio remoto desde otro ordenador."
echo ""

