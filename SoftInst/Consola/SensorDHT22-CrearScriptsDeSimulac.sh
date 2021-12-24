#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#--------------------------------------------------------------------------------------------------
#  Script de NiPeGun para crear los scripts de simulación de lectura del sensor DHT22 para Debian
#--------------------------------------------------------------------------------------------------

## Creación del script de simulación de lectura del sensor
   echo '#!/usr/bin/python3'                                                                          > /root/scripts/SensorDHT22-LeerSimulac.py
   echo ''                                                                                           >> /root/scripts/SensorDHT22-LeerSimulac.py
   echo 'from time import time, sleep'                                                               >> /root/scripts/SensorDHT22-LeerSimulac.py
   echo 'import json'                                                                                >> /root/scripts/SensorDHT22-LeerSimulac.py
   echo 'from random import uniform'                                                                 >> /root/scripts/SensorDHT22-LeerSimulac.py
   echo ''                                                                                           >> /root/scripts/SensorDHT22-LeerSimulac.py
   echo 'while True:'                                                                                >> /root/scripts/SensorDHT22-LeerSimulac.py
   echo '  sleep(1 - time() % 1)'                                                                    >> /root/scripts/SensorDHT22-LeerSimulac.py
   echo "  print(json.dumps({'Temperatura': uniform(10, 45), 'Humedad': uniform(11,99)}, indent=2))" >> /root/scripts/SensorDHT22-LeerSimulac.py
   chmod +x /root/scripts/SensorDHT22-LeerSimulac.py

## Creación del script que simula la lectura del sensor y guarda esos datos simulados en la base de datos
   echo '#!/usr/bin/python3'                                                                                       > /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo ''                                                                                                        >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo 'from time import time, sleep'                                                                            >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo 'import datetime'                                                                                         >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo 'from random import uniform'                                                                              >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo 'import json'                                                                                             >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo 'from influxdb import client as influxdb'                                                                 >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo ''                                                                                                        >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo '#Base de datos'                                                                                          >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo "influxHost = 'localhost'"                                                                                >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo "influxPort = '8086'"                                                                                     >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo "influxDB = 'bdpruebas'"                                                                                  >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo "influxUser = 'usuariopruebas'"                                                                           >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo "influxPasswd = 'clave'"                                                                                  >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo ''                                                                                                        >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo 'while True:'                                                                                             >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo '  sleep(10 - time() % 10)'                                                                               >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo '  # Adaptar el formato de la hora para que influxDB lo entienda (2017-02-26T13:33:49.00279827Z)'         >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo "  current_time = datetime.datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')"                              >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo '  var_humedad, var_temperatura = uniform(10, 45), uniform(11,99)'                                        >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo '  influx_metric = [{'                                                                                    >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo '  "measurement": "temp_hume",'                                                                           >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo '                 "time": current_time,'                                                                  >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo '                 "fields":'                                                                              >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo '                   {'                                                                                    >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo '                     "Temperatura": var_temperatura,'                                                    >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo '                     "Humedad": var_humedad'                                                             >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo '                   }'                                                                                    >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo '  }]'                                                                                                    >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo '  # Guardar en la base de datos'                                                                         >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo '  try:'                                                                                                  >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo '    db = influxdb.InfluxDBClient(influxHost, influxPort, influxUser, influxPasswd, influxDB)'            >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo '    db.write_points(influx_metric)'                                                                      >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo '  finally:'                                                                                              >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo '    db.close()'                                                                                          >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   echo '  print("Se han guardado los siguientes valores: Humedad:",var_humedad, "Temperatura:",var_temperatura)' >> /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py
   chmod +x /root/scripts/SensorDHT22-LeerSimulacYGuardarEnInfluxDB.py

