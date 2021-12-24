----------------------------------------------------------------------------------------------------------------
  SCRIPTS QUE SIMULAN EL SENSOR DHT22
----------------------------------------------------------------------------------------------------------------
## Creación del script de simulación de lectura del sensor
   echo '#!/usr/bin/python3'                                                                          > /home/pi/SimularLecturaDeDHT22.py
   echo ''                                                                                           >> /home/pi/SimularLecturaDeDHT22.py
   echo 'from time import time, sleep'                                                               >> /home/pi/SimularLecturaDeDHT22.py
   echo 'import json'                                                                                >> /home/pi/SimularLecturaDeDHT22.py
   echo 'from random import uniform'                                                                 >> /home/pi/SimularLecturaDeDHT22.py
   echo ''                                                                                           >> /home/pi/SimularLecturaDeDHT22.py
   echo 'while True:'                                                                                >> /home/pi/SimularLecturaDeDHT22.py
   echo '  sleep(1 - time() % 1)'                                                                    >> /home/pi/SimularLecturaDeDHT22.py
   echo "  print(json.dumps({'Temperatura': uniform(10, 45), 'Humedad': uniform(11,99)}, indent=2))" >> /home/pi/SimularLecturaDeDHT22.py
   chmod +x /home/pi/SimularLecturaDeDHT22.py

## Creación del script que simula la lectura del sensor y guarda esos datos simulados en la base de datos
   echo '#!/usr/bin/python3'                                                                                       > /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo ''                                                                                                        >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo 'from time import time, sleep'                                                                            >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo 'import datetime'                                                                                         >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo 'from random import uniform'                                                                              >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo 'import json'                                                                                             >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo 'from influxdb import client as influxdb'                                                                 >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo ''                                                                                                        >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '#Base de datos'                                                                                          >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo "influxHost = 'localhost'"                                                                                >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo "influxPort = '8086'"                                                                                     >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo "influxDB = 'bdpruebas'"                                                                                  >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo "influxUser = 'usuariopruebas'"                                                                           >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo "influxPasswd = 'clave'"                                                                                  >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo ''                                                                                                        >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo 'while True:'                                                                                             >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '  sleep(10 - time() % 10)'                                                                               >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '  # Adaptar el formato de la hora para que influxDB lo entienda (2017-02-26T13:33:49.00279827Z)'         >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo "  current_time = datetime.datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')"                              >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '  var_humedad, var_temperatura = uniform(10, 45), uniform(11,99)'                                        >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '  influx_metric = [{'                                                                                    >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '  "measurement": "temp_hume",'                                                                           >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '                 "time": current_time,'                                                                  >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '                 "fields":'                                                                              >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '                   {'                                                                                    >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '                     "Temperatura": var_temperatura,'                                                    >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '                     "Humedad": var_humedad'                                                             >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '                   }'                                                                                    >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '  }]'                                                                                                    >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '  # Guardar en la base de datos'                                                                         >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '  try:'                                                                                                  >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '    db = influxdb.InfluxDBClient(influxHost, influxPort, influxUser, influxPasswd, influxDB)'            >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '    db.write_points(influx_metric)'                                                                      >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '  finally:'                                                                                              >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '    db.close()'                                                                                          >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '  print("Se han guardado los siguientes valores: Humedad:",var_humedad, "Temperatura:",var_temperatura)' >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   chmod +x /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py----------------------------------------------------------------------------------------------------------------
  SCRIPTS QUE SIMULAN EL SENSOR DHT22
----------------------------------------------------------------------------------------------------------------
## Creación del script de simulación de lectura del sensor
   echo '#!/usr/bin/python3'                                                                          > /home/pi/SimularLecturaDeDHT22.py
   echo ''                                                                                           >> /home/pi/SimularLecturaDeDHT22.py
   echo 'from time import time, sleep'                                                               >> /home/pi/SimularLecturaDeDHT22.py
   echo 'import json'                                                                                >> /home/pi/SimularLecturaDeDHT22.py
   echo 'from random import uniform'                                                                 >> /home/pi/SimularLecturaDeDHT22.py
   echo ''                                                                                           >> /home/pi/SimularLecturaDeDHT22.py
   echo 'while True:'                                                                                >> /home/pi/SimularLecturaDeDHT22.py
   echo '  sleep(1 - time() % 1)'                                                                    >> /home/pi/SimularLecturaDeDHT22.py
   echo "  print(json.dumps({'Temperatura': uniform(10, 45), 'Humedad': uniform(11,99)}, indent=2))" >> /home/pi/SimularLecturaDeDHT22.py
   chmod +x /home/pi/SimularLecturaDeDHT22.py

## Creación del script que simula la lectura del sensor y guarda esos datos simulados en la base de datos
   echo '#!/usr/bin/python3'                                                                                       > /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo ''                                                                                                        >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo 'from time import time, sleep'                                                                            >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo 'import datetime'                                                                                         >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo 'from random import uniform'                                                                              >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo 'import json'                                                                                             >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo 'from influxdb import client as influxdb'                                                                 >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo ''                                                                                                        >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '#Base de datos'                                                                                          >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo "influxHost = 'localhost'"                                                                                >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo "influxPort = '8086'"                                                                                     >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo "influxDB = 'bdpruebas'"                                                                                  >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo "influxUser = 'usuariopruebas'"                                                                           >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo "influxPasswd = 'clave'"                                                                                  >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo ''                                                                                                        >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo 'while True:'                                                                                             >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '  sleep(10 - time() % 10)'                                                                               >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '  # Adaptar el formato de la hora para que influxDB lo entienda (2017-02-26T13:33:49.00279827Z)'         >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo "  current_time = datetime.datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')"                              >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '  var_humedad, var_temperatura = uniform(10, 45), uniform(11,99)'                                        >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '  influx_metric = [{'                                                                                    >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '  "measurement": "temp_hume",'                                                                           >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '                 "time": current_time,'                                                                  >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '                 "fields":'                                                                              >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '                   {'                                                                                    >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '                     "Temperatura": var_temperatura,'                                                    >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '                     "Humedad": var_humedad'                                                             >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '                   }'                                                                                    >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '  }]'                                                                                                    >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '  # Guardar en la base de datos'                                                                         >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '  try:'                                                                                                  >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '    db = influxdb.InfluxDBClient(influxHost, influxPort, influxUser, influxPasswd, influxDB)'            >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '    db.write_points(influx_metric)'                                                                      >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '  finally:'                                                                                              >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '    db.close()'                                                                                          >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   echo '  print("Se han guardado los siguientes valores: Humedad:",var_humedad, "Temperatura:",var_temperatura)' >> /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py
   chmod +x /home/pi/SimularLecturaDeDHT22YGuardarEnInfluxDB.py

