----------------------------------------------------------------------------------------------------------------
  ORIGINAL PARA LA RASPBERRY PI
----------------------------------------------------------------------------------------------------------------

## Creación del script que lee el sensor
   echo '#!/usr/bin/python3'                                                                  > /home/pi/LeerDHT22.py
   echo ''                                                                                   >> /home/pi/LeerDHT22.py
   echo 'import Adafruit_DHT'                                                                >> /home/pi/LeerDHT22.py
   echo 'import json'                                                                        >> /home/pi/LeerDHT22.py
   echo ''                                                                                   >> /home/pi/LeerDHT22.py
   echo 'DHT_SENSOR = Adafruit_DHT.DHT22'                                                    >> /home/pi/LeerDHT22.py
   echo 'DHT_PIN = 4'                                                                        >> /home/pi/LeerDHT22.py
   echo ''                                                                                   >> /home/pi/LeerDHT22.py
   echo 'while True:'                                                                        >> /home/pi/LeerDHT22.py
   echo '  humidity, temperature = Adafruit_DHT.read_retry(DHT_SENSOR, DHT_PIN)'             >> /home/pi/LeerDHT22.py
   echo '  if humidity is not None and temperature is not None:'                             >> /home/pi/LeerDHT22.py
   echo "    print(json.dumps({'Temperatura': temperature, 'Humedad': humidity}, indent=2))" >> /home/pi/LeerDHT22.py
   echo '  else:'                                                                            >> /home/pi/LeerDHT22.py
   echo '    print("Failed to retrieve data from humidity sensor")'                          >> /home/pi/LeerDHT22.py
   chmod +x /home/pi/LeerDHT22.py

## Creación del script que lee el sensor y guarda los datos en la base de datos
   echo '#!/usr/bin/python3'                                                                         > /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo ''                                                                                           >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo 'import Adafruit_DHT'                                                                        >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo 'import datetime'                                                                            >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo 'from influxdb import client as influxdb'                                                    >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo ''                                                                                           >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo '# Base de datos'                                                                            >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo 'influxHost = xxx'                                                                           >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo 'influxPort = xxx'                                                                           >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo 'influxDB = xxx'                                                                             >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo 'influxUser = xxx'                                                                           >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo 'influxPasswd = xxx'                                                                         >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo ''                                                                                           >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo '# Sensor'                                                                                   >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo 'DHT_SENSOR = Adafruit_DHT.DHT22'                                                            >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo 'DHT_PIN = 4'                                                                                >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo ''                                                                                           >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo '# Crear el objeto del sensor usando el bus I2C de la Raspberry'                             >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo 'humidity, temperature = Adafruit_DHT.read_retry(DHT_SENSOR, DHT_PIN)'                       >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo ''                                                                                           >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo '# Mostrar la fecha en un formato agimable con influxDB 2017-02-26T13:33:49.00279827Z'       >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo "current_time = datetime.datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')"                   >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo ''                                                                                           >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo 'influx_metric = [{'                                                                         >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo '"measurement": "temp_hum",'                                                                 >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo '               "time": current_time,'                                                       >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo '               "fields":'                                                                   >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo '                 {'                                                                         >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo '                   "Temperatura": temperature,'                                             >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo '                   "Humedad": humidity'                                                     >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo '                 }'                                                                         >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo '}]'                                                                                         >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo ''                                                                                           >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo '# Salvar los datos a la base de datos de InfluxDB'                                          >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo 'try:'                                                                                       >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo '  db = influxdb.InfluxDBClient(influxHost, influxPort, influxUser, InflusPasswd, InfluxDB)' >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo '  db.write_points(influx_metric)'                                                           >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo 'finally:'                                                                                   >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   echo '  db.close()'                                                                               >> /home/pi/LeerDHT22YGuardarEnInfluxDB.py
   chmod +x /home/pi/LeerDHT22YGuardarEnInfluxDB.py

