#!/bin/bash

# Terminar el script si el mensaje no es un mensaje recibido
  if [ "$1" != "RECEIVED" ]; then
    exit;
  fi;

# Guardar en variables los datos del SMS recibido
  vRemitente=`formail -zx From: < $2`
  vTexto=`formail -I "" <$2 | sed -e "1d"`

# Guardar los datos en un archivo de texto
  mkdir -p /root/sms/ 2> /dev/null
  touch /root/sms/recibidos.txt
  echo "De $vRemitente : $vTexto" >> /root/sms/recibidos.txt
