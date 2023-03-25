#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para reinstalar Grub desde un LiveCD
# ----------

CantArgsCorrectos=2
ArgsInsuficientes=65

if [ $# -ne $CantArgsCorrectos ]
  then
    echo ""
    echo "------------------------------------------------------------------------------"
    echo "Mal uso del script."
    echo ""
    echo "El uso correcto sería: $0 [Disco] [Partición]"
    echo ""
    echo "Ejemplo:"
    echo ' $0 /dev/sda 1'
    echo "------------------------------------------------------------------------------"
    echo ""
    exit $ArgsInsuficientes
  else
    echo ""
    echo "  Reinstalando Grub en la partición $1"
    echo ""
    mount $1$2 /mnt
    mount --bind /dev /mnt/dev
    mount --bind /dev/pts /mnt/dev/pts
    mount --bind /proc /mnt/proc
    mount --bind /sys /mnt/sys
    echo "grub-install $1" > /mnt/reinstalargrub
    echo "grub-install --recheck $1" >> /mnt/reinstalargrub
    echo "update-grub" >> /mnt/reinstalargrub
    echo "exit" >> /mnt/reinstalargrub
    chmod +x /mnt/reinstalargrub
    chroot /mnt /bin/bash -c "su - -c /reinstalargrub"
    umount /mnt/sys
    umount /mnt/proc
    umount /mnt/dev/pts
    umount /mnt/dev
    umount /mnt
    echo ""
fi
