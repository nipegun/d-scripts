#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ------------
#  Script de NiPeGun para crear los scripts de simulación de lectura del sensor DHT22 para Debian
#
#  Ejecución remota:
#  curl -s https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/SensorDHT22Simulado-CrearScripts.sh | bash
# ------------

## Creación del script de simulación de lectura del sensor
   echo '#!/usr/bin/python3'                                                                          > /root/scripts/SensorDHT22Simulado-Leer.py
   echo ''                                                                                           >> /root/scripts/SensorDHT22Simulado-Leer.py
   echo 'from time import time, sleep'                                                               >> /root/scripts/SensorDHT22Simulado-Leer.py
   echo 'import json'                                                                                >> /root/scripts/SensorDHT22Simulado-Leer.py
   echo 'from random import uniform'                                                                 >> /root/scripts/SensorDHT22Simulado-Leer.py
   echo ''                                                                                           >> /root/scripts/SensorDHT22Simulado-Leer.py
   echo 'while True:'                                                                                >> /root/scripts/SensorDHT22Simulado-Leer.py
   echo '  sleep(1 - time() % 1)'                                                                    >> /root/scripts/SensorDHT22Simulado-Leer.py
   echo "  print(json.dumps({'Temperatura': uniform(10, 45), 'Humedad': uniform(11,99)}, indent=2))" >> /root/scripts/SensorDHT22Simulado-Leer.py
   chmod +x /root/scripts/SensorDHT22Simulado-Leer.py

## Creación del script para el servicio
   echo '#!/usr/bin/python3'                                                                                                 > /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo ''                                                                                                                  >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo 'import json'                                                                                                       >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo 'from random import uniform'                                                                                        >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo 'import datetime'                                                                                                   >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo 'from influxdb import client as influxdb'                                                                           >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo ''                                                                                                                  >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo '# Variables'                                                                                                       >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo "influxHost = 'xxx'"                                                                                                >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo "influxPort = 'xxx'"                                                                                                >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo "influxDB = 'xxx'"                                                                                                  >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo "influxUser = 'xxx'"                                                                                                >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo "influxPasswd = 'xxx'"                                                                                              >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo ''                                                                                                                  >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo '# Simular el objeto del sensor'                                                                                    >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo 'humidity, temperature = uniform(10, 45), uniform(10, 45)'                                                          >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo ''                                                                                                                  >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo '# Adaptar el formato de la hora para que influxDB lo entienda (2017-02-26T13:33:49.00279827Z)'                     >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo "current_time = datetime.datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')"                                          >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo ''                                                                                                                  >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo 'influx_metric = [{'                                                                                                >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo '"measurement": "temp_hume",'                                                                                       >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo '               "time": current_time,'                                                                              >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo '               "fields":'                                                                                          >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo '                 {'                                                                                                >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo '                   "Temperatura": temperature,'                                                                    >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo '                   "Humedad": humidity'                                                                            >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo '                 }'                                                                                                >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo '}]'                                                                                                                >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo ''                                                                                                                  >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo '# Salvar mediciones a la base de datos'                                                                            >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo 'try:'                                                                                                              >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo '  db = influxdb.InfluxDBClient(influxHost, influxPort, influxUser, influxPasswd, influxDB)'                        >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo '  db.write_points(influx_metric)'                                                                                  >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo 'finally:'                                                                                                          >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   echo '  db.close()'                                                                                                      >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   #echo '# Imprimir también a un archivo de log'                                                                            >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   #echo 'with open('/var/log/dht22.log', 'a') as archivolog:'                                                               >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   #echo '  print("Se han guardado los siguientes valores: Humedad:",humidity, "Temperatura:",temperature, file=archivolog)' >> /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   #chmod +x /root/scripts/SensorDHT22Simulado-LeerYGuardarEnInfluxDB.py
   #touch /var/log/dht22.log
   #chmod 777 /var/log/dht22.log


