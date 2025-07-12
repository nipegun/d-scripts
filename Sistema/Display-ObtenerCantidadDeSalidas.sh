#!/bin/bash

echo ""
echo "  Mostrando todas las salidas gráficas..."
echo ""
xrandr | grep -e isconnected -e onnected | cut -d' ' -f1


echo ""
echo "  Mostrando salidas que tienen cables conectados a monitores..."
echo ""
xrandr | grep onnected | grep -v isconnected | cut -d' ' -f1

echo ""
echo "  Configurando todos los monitores para que muestren 1920x1080..."
echo ""
xrandr --output HDMI-A-1 --mode 1920x1080 --scale 1x1 --output DisplayPort-1-4 --mode 1920x1080 --scale 1x1

echo ""
echo "  Configurando todos los monitores para que muestren 2560x1440..."
echo ""
xrandr --output HDMI-A-1 --mode 2560x1440 --scale 1x1 --output DisplayPort-1-4 --mode 2560x1440 --scale 1x1

