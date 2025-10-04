#!/bin/bash

su -
apt-get -y purge sudo
apt-get -y autoremove --purge
apt-get -y clean

