#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------------------------
#  SCRIPT DE NIPEGUN PARA INSTALAR Y CONFIGURAR EL SERVIDOR NFS EN PROXMOXVE
#-----------------------------------------------------------------------------

# Instalar el paquete necesario
echo ""
echo "----------------------------------------------------------"
echo "  INSTALANDO EL PAQUETE NECESARIO PARA COMPARTIR POR NFS"
echo "----------------------------------------------------------"
echo ""
apt-get -y install nfs-kernel-server

# Crear el directorio a compartir
echo ""
echo "----------------------------------"
echo "  CREANDO LA CARPETA A COMPARTIR"
echo "----------------------------------"
echo ""
mkdir /nfs

# Agregar un archivo a ese directorio para ver si la comparticón es correcta
echo ""
echo "----------------------------------------------------------------------------"
echo "  AGREGANDO UN ARCHIVO A LA CARPETA COMPARTIDA PARA PROBAR LA COMPARTICIÓN"
echo "----------------------------------------------------------------------------"
echo ""
echo "Prueba" > /nfs/Prueba.txt

# Agregar la compartición a /etc/exports
echo ""
echo "--------------------------------------------------"
echo "  AGREGANDO LA CARPETA COMPARTIDA A /etc/exports"
echo "--------------------------------------------------"
echo ""
echo "/nfs *(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports

# Aplicar cambios
echo ""
echo "--------------------------------------------------------"
echo "  APLICANDO LOS CAMBIOS Y ACTIVANDO LAS COMPARTICIONES"
echo "--------------------------------------------------------"
echo ""
exportfs -a

# Activar el servicio para que la compartición esté disponible al inicio  del sistema
echo ""
echo "------------------------------------------------------------------------"
echo "  ACTIVANDO EL SERVICIO PARA QUE ESTé DISPONIBLE AL INICIAR EL SISTEMA"
echo "------------------------------------------------------------------------"
echo ""
systemctl enable nfs-kernel-server

