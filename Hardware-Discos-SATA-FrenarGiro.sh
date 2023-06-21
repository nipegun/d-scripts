#!/bin/bash

menu=(dialog --timeout 5 --checklist "Apagar discos de plato:" 22 76 16)
opciones=(
  1 "/dev/sda" on
  2 "/dev/sdb" on
  3 "/dev/sdc" on
  4 "/dev/sdd" on
  5 "/dev/sde" on
  6 "/dev/sdf" on
)
choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
clear

for choice in $choices
  do
    case $choice in

      1)
        echo ""
        echo "-----------------------------------"
        echo "  BAJANDO LA VELOCIDAD A /dev/sda"
        echo "-----------------------------------"
        echo ""
        hdparm -S 1 /dev/sda
      ;;

      2)
        echo ""
        echo "-----------------------------------"
        echo "  BAJANDO LA VELOCIDAD A /dev/sdb"
        echo "-----------------------------------"
        echo ""
        hdparm -S 1 /dev/sdb
      ;;

      3)
        echo ""
        echo "-----------------------------------"
        echo "  BAJANDO LA VELOCIDAD A /dev/sdc"
        echo "-----------------------------------"
        echo ""
        hdparm -S 1 /dev/sdc
      ;;

      4)
        echo ""
        echo "-----------------------------------"
        echo "  BAJANDO LA VELOCIDAD A /dev/sdd"
        echo "-----------------------------------"
        echo ""
        hdparm -S 1 /dev/sdd
      ;;

      5)
        echo ""
        echo "-----------------------------------"
        echo "  BAJANDO LA VELOCIDAD A /dev/sde"
        echo "-----------------------------------"
        echo ""
        hdparm -S 1 /dev/sde
      ;;

      6)
        echo ""
        echo "-----------------------------------"
        echo "  BAJANDO LA VELOCIDAD A /dev/sdf"
        echo "-----------------------------------"
        echo ""
        hdparm -S 1 /dev/sdf
      ;;

  esac

done

