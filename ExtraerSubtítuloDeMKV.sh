#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para EXTRAER SUBTÍTULOS DE ARCHIVOS MKV
# ----------

# If no directory is given, work in local dir
if [ "$1" = "" ]; then
  DIR="."
else
  DIR="$1"
fi

# Get all the MKV files in this dir and its subdirs
find "$DIR" -type f -name '*.mkv' | while read filename
do
  # Find out which tracks contain the subtitles
  mkvmerge -i "$filename" | grep 'subtitles' | while read subline
  do
    # Grep the number of the subtitle track
    tracknumber=`echo $subline | egrep -o "[0-9]{1,2}" | head -1`

    # Get base name for subtitle
    subtitlename=${filename%.*}

    # Extract the track to a .tmp file
    `mkvextract tracks "$filename" $tracknumber:"$subtitlename.srt.tmp" > /dev/null 2>&1`
    `chmod g+rw "$subtitlename.srt.tmp"`

    # Do a super-primitive language guess: ENGLISH
    langtest=`egrep -ic ' you | to | the ' "$subtitlename".srt.tmp`
    trimregex=""

    # Check if subtitle passes our language filter (10 or more matches)
    if [ $langtest -ge 10 ]; then
      # Regex to remove credits at the end of subtitles (read my reason why!)
      `sed 's/\r//g' < "$subtitlename.srt.tmp" \
        | sed 's/%/%%/g' \
        | awk '{if (a){printf("\t")};printf $0; a=1; } /^$/{print ""; a=0;}' \
        | grep -iv "$trimregex" \
        | sed 's/\t/\r\n/g' > "$subtitlename.srt"`
      `rm "$subtitlename.srt.tmp"`
      `chmod g+rw "$subtitlename.srt"`
    else
      # Not our desired language: add a number to the filename and keep anyway, just in case
      `mv "$subtitlename.srt.tmp" "$subtitlename.$tracknumber.srt" > /dev/null 2>&1`
    fi
  done
done

