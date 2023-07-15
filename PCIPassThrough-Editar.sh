#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para editar la configuración de PCI PassThrough
# ----------

echo ""
echo "  Editando la configuración del módulo VFIO..."
echo ""
nano /etc/modprobe.d/vfio.conf

echo ""
echo "  Editando la configuración por default del GRUB..."
echo ""
nano /etc/default/grub
update-grub

echo ""
echo "  Editando la BlackList de los módulos..."
echo ""
nano /etc/modprobe.d/pcipassthrough.conf
update-initramfs -u

