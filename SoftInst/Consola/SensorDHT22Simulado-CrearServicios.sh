## Crear los servicios
   echo "[Unit]"                                                                                   > /etc/systemd/system/dht22.service
   echo "Description=Servicio de SystemD para el sensor DHT22"                                    >> /etc/systemd/system/dht22.service
   echo "[Service]"                                                                               >> /etc/systemd/system/dht22.service
   echo "ExecStart=/usr/bin/python3 /home/pi/Servicio-SimularLecturaDeDHT22YGuardarEnInfluxDB.py" >> /etc/systemd/system/dht22.service
   echo "[Install]"                                                                               >> /etc/systemd/system/dht22.service
   echo "WantedBy=default.target"                                                                 >> /etc/systemd/system/dht22.service

   echo "[Unit]"                                         > /etc/systemd/system/dht22.timer
   echo "Description=Temporizador para el sensor DHT22" >> /etc/systemd/system/dht22.timer
   echo "[Timer]"                                       >> /etc/systemd/system/dht22.timer
   echo "OnCalendar=*-*-* *:*:00"                       >> /etc/systemd/system/dht22.timer
   echo "[Install]"                                     >> /etc/systemd/system/dht22.timer
   echo "WantedBy=default.target"                       >> /etc/systemd/system/dht22.timer
   systemctl enable dht22.service
   systemctl enable dht22.timer
   systemctl start dht22.service
   systemctl start dht22.timer
