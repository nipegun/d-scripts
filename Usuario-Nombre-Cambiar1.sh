#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para cambiar el nombre de un usuario y mover todas las carpetas y archivos
#
# Ejecución remota con sudo:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Usuario-Nombre-Cambiar.sh | bash -s NombreUsuarioViejo NombreUsuarioNuevo
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Usuario-Nombre-Cambiar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  #if [ $(id -u) -ne 0 ]; then     # Sólo comprueba si es root
  if [[ $EUID -ne 0 ]]; then       # Comprueba si es root o sudo
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse con privilegios de administrador (como root o con sudo).${cFinColor}"
    echo ""
    exit
  fi

cCantArgumEsperados=2

if [ $# -ne $cCantArgumEsperados ]
  then
    echo ""
    
    echo "Mal uso del script."
    echo ""
    echo "  El uso correcto sería: $0 [NombreDeUsuarioViejo] [NombreDeUsuarioNuevo]"
    echo ""
    echo "  Ejemplo:"
    echo "    $0 pepe jose"
    echo ""
    exit
  else
    if [ $(who | grep ^"$1") == "$1" ]; then
      echo ""
      echo -e "${cColorRojo}    El usuario $1 tiene una sesión iniciada.${cFinColor}"
      echo ""
      echo "      Para conseguir migrar el nombre correctamente reinica Debian y, al acabar de reiniciar,"
      echo "      loguéate con el root en modo consola (Ctrl + Alt + F2) y vuelve a ejecutar el script."
      echo ""
    else
      echo ""
      echo "    Renombrando el usuario..."
      echo ""
      usermod -l $2 $1
      echo ""
      echo "    Cambiando la carpeta home y moviendo los datos a la nueva carpeta..."
      echo ""
      usermod -d /home/$2 -m $2
      echo ""
      echo "    Moviendo al usuario de grupo..."
      echo ""
      groupmod -n $2 $1
      echo ""
    fi
fi

