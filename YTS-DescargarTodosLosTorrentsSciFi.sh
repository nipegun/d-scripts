#!/bin/bash

DominioYTS=yts.mx
CalidadDeseada=720p
Genero="sci-fi"
CarpetaDeDescarga="/tmp/YTS/"
NroPagIni=2
NroPagFin=500

## Construir el archivo con todas las URLs de las páginas de cada peli
echo ""
echo "Construyendo el archivo con todas las URLs de cada peli..."
echo ""
mkdir -p $CarpetaDeDescarga 2>/dev/null
touch         /tmp/YTS/URLPagPelis.txt
truncate -s 0 /tmp/YTS/URLPagPelis.txt
for NroPag in $(seq $NroPagIni $NroPagFin);
  do
    curl --insecure --silent https://yts.mx/browse-movies/0/all/sci-fi/0/latest/0/all?page=$NroPag | grep href | grep title | grep movies | cut -d '"' -f 2 >> /tmp/YTS/URLPagPelis.txt

    ## Comprobar si el resultado del curl es un 404 y si lo es, terminar el bucle
    #if [ $NickName = $1 ]; then
      #
      #Puesto=$(curl -s https://eps.encounter.eus/ee$2/map/lookup/B$FilaZonaB"_"$ColumnaZonaB | jq -r '.seat')
      #echo ""
      #echo "$NickName está en el puesto $Puesto"
      #echo ""
      #
      ##Terminar el script
      #exit 1
    #fi

    # Esperar 1 segundo hasta hacer otra vez la consulta curl
    sleep 1
done

