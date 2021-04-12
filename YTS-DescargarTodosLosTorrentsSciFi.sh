#!/bin/bash

DominioYTS=yts.mx
CalidadDeseada=720p
Genero="sci-fi"
CarpetaDeDescarga="/tmp/YTS/"
NroPagIni=135
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
    echo ""
    echo "Revisando la página de resultados nro $NroPag..."
    echo ""
    curl --insecure --silent https://$DominioYTS/browse-movies/0/all/$Genero/0/latest/0/all?page=$NroPag | grep href | grep title | grep movies | cut -d '"' -f 2 >> /tmp/YTS/URLPagPelis.txt

    ## Comprobar si la página de resultados ya no muestra pelis y, si eso, parar el buble for
    ResultadoDelCurl=$(curl --insecure --silent https://$DominioYTS/browse-movies/0/all/$Genero/0/latest/0/all?page=$NroPag | grep href | grep title | grep movies | cut -d '"' -f 2)
    if [ "$ResultadoDelCurl" = "" ]
      then
        echo ""
        echo "La página $NroPag ya no tiene resultados. Parando la búsqueda..."
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
for URLPeli in $(cat /tmp/YTS/URLPagPelis.txt)
  do
    echo ""
    echo "Buscando enlaces a torrents en: ${URLPeli}"
    echo ""
    sleep 1
  done

