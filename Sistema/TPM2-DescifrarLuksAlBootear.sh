#!/bin/bash

# ----------
# Script de NiPeGun para configurar desbloqueo automático de la partición Luks mediante TPM2 al iniciar el sistema
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/TPM2-DescifrarLuksAlBootear.sh | bash -s [Partición]
#
# Para ver particiones luks, con el sistema desbloqueado:
#   sudo lsblk -o NAME,TYPE,FSTYPE,MOUNTPOINT | grep crypt
# ----------

vDisco="$1"

if [ -z "$vDisco" ]; then
  echo "Uso: $0 /dev/sdXN"
  echo "Ejemplo: $0 /dev/nvme0n1p3"
  exit 1
fi

if [ ! -e "$vDisco" ]; then
  echo "El dispositivo $vDisco no existe. Abortando."
  exit 1
fi

# Instalar paquetes
  echo ""
  echo "  Instalando dependencias..."
  echo ""
  sudo apt-get -y update
  sudo apt-get -y install clevis
  sudo apt-get -y install clevis-tpm2
  sudo apt-get -y install clevis-luks
  sudo apt-get -y install clevis-initramfs
  sudo apt-get -y install initramfs-tools
  sudo apt-get -y install tpm2-tools

# Versión de LUKS
  vVersLUKS=$(sudo cryptsetup luksDump "$vDisco" | grep -i "Version" | cut -d':' -f2 | xargs)

# Comprobar si LUKS es la versión 1
  if [[ $vVersLUKS == '1' ]]; then
    echo ""
    echo "  El sistema está utilizando LUKS 1. Se procederá a hacer una copia de seguridad del header luks."
    echo ""
    sudo mkdir -p /root/LUKS/
    vDiscoSinRuta=$(echo "$vDisco" | cut -d '/' -f3)
    sudo cryptsetup luksHeaderBackup "$vDisco" --header-backup-file /root/LUKS/backup_header_luks_"$vDiscoSinRuta".bin && sudo cryptsetup convert "$vDisco" --type luks2
  fi

# Pedir la contraseña de cifrado de la partición
  echo ""
  echo -n "Introduce la contraseña LUKS de $vDisco: "
  echo ""
  read -s vClaveLUKS
  echo ""

# Notificar intento de vinculación
  echo ""
  echo "Vinculando LUKS con TPM2..."
  echo ""
  echo "$vClaveLUKS" | sudo clevis luks bind -d "$vDisco" tpm2 '{"pcr_bank":"sha256"}'

# Actualizar el initramfs
  echo ""
  echo "Actualizando initramfs para incluir Clevis..."
  echo ""
  sudo update-initramfs -u -k all

# Verificar
  echo ""
  echo "Verificando slots vinculados a TPM2:"
  echo ""
  clevis luks list -d "$vDisco"

# Notificar fin de ejecución del script
  echo ""
  echo "Configuración completada."
  echo "A partir de ahora, Debian 13 intentará desbloquear automáticamente $vDisco durante el arranque mediante TPM2."
  echo ""
