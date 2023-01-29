#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
#  Script de NiPeGun para crear un video a partir de todos los archivos de imagen de una carpeta dada
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Video-CrearAPartirDeArchivosEnCarpeta.sh | bash
#
#  Ejecución remota sin caché:
#  curl -s -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/Video-CrearAPartirDeArchivosEnCarpeta.sh | bash
#
#  Ejecución remota con parámetros:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/Video-CrearAPartirDeArchivosEnCarpeta.sh | bash -s Parámetro1 Parámetro2
# ----------

#vCarpetaConArchivos="/home/videovig/"
#vExt="jpg"

vCarpetaConArchivos="/home/videovig/"
vExt="jpg"

vColorAzul="\033[0;34m"
vColorAzulClaro="\033[1;34m"
vColorVerde='\033[1;32m'
vColorRojo='\033[1;31m'
vFinColor='\033[0m'

vCantArgsCorrectos=2
vArgsInsuficientes=65

if [ $# -ne $vCantArgsCorrectos ]
  then
    echo ""
    echo -e "${vColorRojo}  Mal uso del script. El uso correcto sería: ${vFinColor}"
    echo                 "    script [CarpetaConArchivos] [Extensión]"
    echo ""
    echo                 "  Ejemplo:"
    echo                 '    script "/home/pepe/fotos/" "jpg"'
    echo ""
    exit $vArgsInsuficientes
  else
    echo ""
    echo "  Creando video a partir de los archivos de imagen ubicados en:"
    echo ""
    echo ""
    vFecha=$(date +A%YM%mD%d)
    vYear=$(date +%Y)
    vMonth=$(date +%m)
    vDay=$(date +%d)
    # Comprobar si el paquete ffmpeg está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s ffmpeg 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${vColorRojo}  El paquete ffmpeg no está instalado. Iniciando su instalación...${vFinColor}"
        echo ""
        apt-get -y update && apt-get -y install ffmpeg
        echo ""
      fi
    ffmpeg -framerate 25 -pattern_type glob -i "$vCarpetaConArchivos$vYear$vMonth$vDay/*.$vExt" -c:v libx264 -pix_fmt yuv420p /VideoVig/$vFecha.mp4
fi

