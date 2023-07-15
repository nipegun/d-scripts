#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# --------------
#  Script de NiPeGun para quitar un volúmen lógico de un grupo de volúmenes
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/LVM-GrupVol-QuitarVol.sh | bash
# 
#  Ejemplo:
#    pvs
#
#    PV         VG        Fmt  Attr PSize PFree
#    /dev/sda2  vg_rhel01 lvm2 a--  7.51g    0 
#    /dev/sdb1  vg_rhel01 lvm2 a--  4.99g    0 
#    /dev/sdc   vg_rhel01 lvm2 a--  2.00g 2.00g
#
#    vgreduce vg_rhel01 /dev/sdc
#
#    Removed "/dev/sdc" from volume group "vg_rhel01"
#
# --------------

vgreduce $1 $2

