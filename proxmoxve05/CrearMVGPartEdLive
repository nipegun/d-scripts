#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que te salga de los huevos con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------------------------------------
#  Script de NiPeGun para crear una máquina virtual para clonaciones de discos virtuales en ProxmoxVE
#------------------------------------------------------------------------------------------------------

cd /var/lib/vz/template/iso
wget --no-check-certificate http://hacks4geeks.com/_/premium/descargas/GPartEdLive/gparted-live.iso
qm create $1 --balloon 0 --boot d --cores 2 --keyboard es --memory 2048 --name GPartEdLive --numa 0 --ostype l26 --sata0 local:iso/gparted-live.iso,media=cdrom --scsihw virtio-scsi-pci --sockets 1

