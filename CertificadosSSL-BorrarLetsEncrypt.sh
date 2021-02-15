#!/bin/bash

Dominio="nipegun.com"

rm -rf /etc/letsencrypt/live/$Dominio
rm /etc/letsencrypt/renewal/$Dominio.conf

rm -rf /etc/letsencrypt/live/www.$Dominio
rm /etc/letsencrypt/renewal/www.$Dominio.conf
