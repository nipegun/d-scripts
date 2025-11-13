#!/bin/bash

# ----------
# Script de NiPeGun para configurar desbloqueo automático de la partición Luks mediante TPM2 al iniciar el sistema
#
# Ejecución remota:
#   cusl -sL x | bash -s [Partición]
#
# Para ver particiones luks, con el sistema desbloqueado:
#   sudo lsblk -o NAME,TYPE,FSTYPE,MOUNTPOINT | grep crypt

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

echo "Instalando dependencias..."
apt-get update -qq
apt-get -y install clevis clevis-tpm2 clevis-luks clevis-initramfs initramfs-tools tpm2-tools tpm2-tss

echo -n "Introduce la contraseña LUKS de $vDisco: "
read -s vClaveLUKS
echo ""

echo "Vinculando LUKS con TPM2..."
echo "$vClaveLUKS" | clevis luks bind -d "$vDisco" tpm2 '{"pcr_bank":"sha256"}'

echo "Actualizando initramfs para incluir Clevis..."
update-initramfs -u -k all

echo "Verificando slots vinculados a TPM2:"
clevis luks list -d "$vDisco"

echo ""
echo "Configuración completada."
echo "A partir de ahora, Debian 13 intentará desbloquear automáticamente $vDisco durante el arranque mediante TPM2."
