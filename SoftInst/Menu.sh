# Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
  if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
    echo ""
    echo "dialog no está instalado. Iniciando su instalación..."
    echo ""
    apt-get -y update && apt-get -y install dialog
    echo ""
  fi

menu=(dialog --timeout 5 --checklist "Marca los mineros que quieras instalar:" 22 96 16)
  opciones=
    (
      1 "Opción 1" on
      2 "Opción 2" off
      3 "Opción 3" off
      4 "Opción 4" off
      5 "Opción 5" off
    )
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
  clear

  for choice in $choices
    do
      case $choice in

        1)

          echo ""
          echo "  Opción 1..."
          echo ""

        ;;

        2)

          echo ""
          echo "  Opción 2..."
          echo ""

        ;;

        3)

          echo ""
          echo "  Opción 3..."
          echo ""

        ;;

        4)

          echo ""
          echo "  Opción 4..."
          echo ""

        ;;

        5)

          echo ""
          echo "  Opción 5..."
          echo ""

        ;;


    esac

done
