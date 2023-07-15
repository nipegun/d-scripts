#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

-
#  Script de NiPeGun para crear el servicio para los scripts de simulación de lectura del sensor DHT22 para Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/SensorDHT22Simulado-CrearServicios.sh | bash
-

## Crear el servicio de lectura y guardado
   echo "[Unit]"                                                                                  > /etc/systemd/system/DHT22Simulado.service
   echo "Description=Servicio de SystemD para el sensor DHT22"                                   >> /etc/systemd/system/DHT22Simulado.service
   echo "[Service]"                                                                              >> /etc/systemd/system/DHT22Simulado.service
   echo "ExecStart=/usr/bin/python3 /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py" >> /etc/systemd/system/DHT22Simulado.service
   echo "[Install]"                                                                              >> /etc/systemd/system/DHT22Simulado.service
   echo "WantedBy=default.target"                                                                >> /etc/systemd/system/DHT22Simulado.service

## Crear el servicio de temporizador para disparar el servicio de lectura y guardado
   echo "[Unit]"                                         > /etc/systemd/system/DHT22Simulado.timer
   echo "Description=Temporizador para el sensor DHT22" >> /etc/systemd/system/DHT22Simulado.timer
   echo "[Timer]"                                       >> /etc/systemd/system/DHT22Simulado.timer
   echo "OnCalendar=*-*-* *:*:00"                       >> /etc/systemd/system/DHT22Simulado.timer
   echo "[Install]"                                     >> /etc/systemd/system/DHT22Simulado.timer
   echo "WantedBy=default.target"                       >> /etc/systemd/system/DHT22Simulado.timer

   systemctl enable DHT22Simulado.service
   systemctl enable DHT22Simulado.timer
   systemctl start  DHT22Simulado.service
   systemctl start  DHT22Simulado.timer

