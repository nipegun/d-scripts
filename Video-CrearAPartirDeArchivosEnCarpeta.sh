#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear un video a partir de todos los archivos de imagen de una carpeta dada
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Video-CrearAPartirDeArchivosEnCarpeta.sh | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/Video-CrearAPartirDeArchivosEnCarpeta.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/Video-CrearAPartirDeArchivosEnCarpeta.sh | bash -s "/home/videovig/" "jpg"
#
# Para agregar este script a cron:
#   crontab -e
#   59 23 * * * /root/scripts/-d-scripts/Video-CrearAPartirDeArchivosEnCarpeta.sh "/home/videovig/" "jpg"
# ----------

#vCarpetaConArchivos="/home/videovig/"
#vExt="jpg"

vCarpetaConArchivos=$1
vExt=$2

cColorAzul="\033[0;34m"
cColorAzulClaro="\033[1;34m"
cColorVerde='\033[1;32m'
cColorRojo='\033[1;31m'
cFinColor='\033[0m'

cCantArgumEsperados=2

if [ $# -ne $cCantArgumEsperados ]
  then
    echo ""
    echo -e "${cColorRojo}  Mal uso del script. El uso correcto sería: ${cFinColor}"
    echo                 "    script [CarpetaConArchivos] [Extensión]"
    echo ""
    echo                 "  Ejemplo:"
    echo                 '    script "/home/pepe/fotos/" "jpg"'
    echo ""
    exit
  else
    echo ""
    echo -e "${cColorAzulClaro}  Creando video a partir de los archivos de imagen ubicados en $vCarpetaConArchivos ... ${cFinColor}"
    echo ""
    vFecha=$(date +A%YM%mD%d)
    vYear=$(date +%Y)
    vMonth=$(date +%m)
    vDay=$(date +%d)
    # Comprobar si el paquete ffmpeg está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s ffmpeg 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}  El paquete ffmpeg no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        apt-get -y update && apt-get -y install ffmpeg
        echo ""
      fi
    mkdir /VideoVig 2> /dev/null
    ffmpeg -framerate 25 -hide_banner -loglevel error -pattern_type glob -i "$vCarpetaConArchivos$vYear$vMonth$vDay/*.$vExt" -c:v libx264 -pix_fmt yuv420p /VideoVig/$vFecha.mp4
    echo ""
fi

