#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#----------------------------------------------------------------------------
#  Script de NiPeGun descargar todos los torrents sci-fi disponibles en YTS
#----------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

DominioYTS=yts.mx
CalidadDeseada=720p
Genero="sci-fi"
CarpetaDeDescarga="/tmp/YTS"
NroPagIni=135
NroPagFin=500

## Construir el archivo con todas las URLs de las páginas de cada peli
echo ""
echo -e "${ColorVerde}Construyendo el archivo con todas las URLs de cada peli...${FinColor}"
echo ""
mkdir -p $CarpetaDeDescarga 2>/dev/null
touch         $CarpetaDeDescarga/URLsPagPelis.txt
truncate -s 0 $CarpetaDeDescarga/URLsPagPelis.txt
for NroPag in $(seq $NroPagIni $NroPagFin);
  do
    echo ""
    echo -e "${ColorVerde}Revisando la página de resultados nro $NroPag...${FinColor}"
    echo ""
    curl --insecure --silent https://$DominioYTS/browse-movies/0/all/$Genero/0/latest/0/all?page=$NroPag | grep href | grep title | grep movies | cut -d '"' -f 2 >> $CarpetaDeDescarga/URLsPagPelis.txt

    ## Comprobar si la página de resultados ya no muestra pelis y, si eso, parar el buble for
    ResultadoDelCurl=$(curl --insecure --silent https://$DominioYTS/browse-movies/0/all/$Genero/0/latest/0/all?page=$NroPag | grep href | grep title | grep movies | cut -d '"' -f 2)
    if [ "$ResultadoDelCurl" = "" ]
      then
        echo ""
        echo -e "${ColorRojo}La página $NroPag ya no tiene resultados. Parando la búsqueda...${FinColor}"
        echo ""

        ## Terminar el bucle for
        break
    fi

    ## Esperar 1 segundo hasta hacer otra vez la consulta curl
    sleep 1
  done

## Revisar una a una cada URL de cada peli para extraer los enlaces de descarga de los torrents
echo ""
echo "Revisando una a una las URLs de las pelis para buscar enlaces a torrents..."
echo ""
touch         $CarpetaDeDescarga/EnlacesEnURLsPagPelis.txt
truncate -s 0 $CarpetaDeDescarga/EnlacesEnURLsPagPelis.txt
for URLPeli in $(cat $CarpetaDeDescarga/URLsPagPelis.txt)
  do
    echo ""
    echo "Buscando enlaces a torrents en: ${URLPeli}"
    echo ""
    curl --insecure --silent ${URLPeli} | grep href | grep "torrent/download" | grep -v class | grep $CalidadDeseada >> $CarpetaDeDescarga/EnlacesEnURLsPagPelis.txt
    sleep 1
  done
touch         $CarpetaDeDescarga/EnlacesATorrents.txt
truncate -s 0 $CarpetaDeDescarga/EnlacesATorrents.txt
cat $CarpetaDeDescarga/EnlacesEnURLsPagPelis.txt | cut -d '"' -f 2 > $CarpetaDeDescarga/EnlacesATorrents.txt

## Guardar los archivos torrent en una carpeta
echo ""
echo "Guardando archivos torrent..."
echo ""
mkdir -p $CarpetaDeDescarga/Torrents/$Genero/ 2> /dev/null
cd $CarpetaDeDescarga/Torrents/$Genero/
for EnlaceAlTorrent in $(cat $CarpetaDeDescarga/EnlacesATorrents.txt)
  do
    echo ""
    echo "Buscando archivo torrent en: ${EnlaceAlTorrent}"
    echo ""
    wget ${EnlaceAlTorrent}
    sleep 1
  done

