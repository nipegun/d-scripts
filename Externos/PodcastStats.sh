#!/bin/bash
set -e
IFS=$'\n\t'
TMPFILE="/tmp/$(basename $0).$$"

# Version 1.0; April 2016
# Copyright (c) 2016 Patrick Vessey <patrick@linuxluddites.com>
# This software is released under the MIT License; for further information,
# please refer to <https://opensource.org/licenses/MIT>

# Example harness for the the prpm-filter.sh script to filter Apache-style
# web logs and generate download statistics in accordance with the criteria
# defined by the Public Radio Podcast Measurement Guidelines version 1.1; for
# further information, refer to <https://github.com/PatrickVessey/prpm-filter>

# Alter the following two variables to suit your environment
LOGGLOB="$1*"
REGEX="$2"

for f in $LOGGLOB; do
    if [ "${f:(-3)}" = ".gz" ]; then gunzip -c $f; else cat $f; fi;
done | /root/scrips/d-scripts/externos/PodcastStatsFiltro.sh "$REGEX" > $TMPFILE

printf "\n--- Descargas únicas del episodio\n\n"
cat $TMPFILE | cut -f1 | sort | uniq -c

printf "\n--- Los 10 episodios más descargados\n\n"
cat $TMPFILE | cut -f1 | sort | uniq -c | sort -nrk1,1 | head -n10

printf "\n--- Descargas únicas anuales\n\n"
cat $TMPFILE | cut -f2 | cut -c-4 | sort -r | uniq -c

printf "\n--- Descargas únicas mensuales (últimos 12 meses)\n\n"
cat $TMPFILE | cut -f2 | cut -c-7 | sort -r | uniq -c | head -n12

printf "\n--- Descargas únicas diarias (fortnight)\n\n"
cat $TMPFILE | cut -f2 | sort -r | uniq -c | head -n14

printf "\n--- All-time unique downloader count\n\n"
cat $TMPFILE | cut -f3- | sort -u | wc -l

# For geoiplookup: apt-get install geoip-bin
if (command -v geoiplookup >/dev/null 2>&1); then
    printf "\n--- Los 20 países desde los que más descargan\n\n"
    cat $TMPFILE | cut -f3 | xargs -n1 geoiplookup | cut -c24- | sort | uniq -c | awk '{sum[$0]+=$1; tot+=$1} END{for(i in sum) printf("%6.1f%% %s\n", sum[i]/tot*100, i)}' | sort -nrk2,2 | head -n20
fi

rm $TMPFILE
#eof
