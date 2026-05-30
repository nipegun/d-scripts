#!/usr/bin/env python3

# Ejecución remota
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/LlamaCPP-Modelos-GGUF-Mostrar-Capas.py | python3 - -- [ArchivoGGUF]

import argparse
import os
import struct
import sys


def fLeerBytes(vArchivo, vCantidad):
  vDatos = vArchivo.read(vCantidad)

  if len(vDatos) != vCantidad:
    raise EOFError("El archivo terminó antes de lo esperado")

  return vDatos


def fLeer(vArchivo, vFormato):
  vFormatoCompleto = "<" + vFormato
  vCantidad = struct.calcsize(vFormatoCompleto)
  return struct.unpack(vFormatoCompleto, fLeerBytes(vArchivo, vCantidad))[0]


def fLeerCadena(vArchivo):
  vLongitud = fLeer(vArchivo, "Q")
  vDatos = fLeerBytes(vArchivo, vLongitud)
  return vDatos.decode("utf-8", "replace")


def fSaltarValor(vArchivo, vTipo):
  if vTipo == 0:
    vArchivo.seek(1, os.SEEK_CUR)
  elif vTipo == 1:
    vArchivo.seek(1, os.SEEK_CUR)
  elif vTipo == 2:
    vArchivo.seek(2, os.SEEK_CUR)
  elif vTipo == 3:
    vArchivo.seek(2, os.SEEK_CUR)
  elif vTipo == 4:
    vArchivo.seek(4, os.SEEK_CUR)
  elif vTipo == 5:
    vArchivo.seek(4, os.SEEK_CUR)
  elif vTipo == 6:
    vArchivo.seek(4, os.SEEK_CUR)
  elif vTipo == 7:
    vArchivo.seek(1, os.SEEK_CUR)
  elif vTipo == 8:
    vLongitud = fLeer(vArchivo, "Q")
    vArchivo.seek(vLongitud, os.SEEK_CUR)
  elif vTipo == 9:
    vTipoArray = fLeer(vArchivo, "I")
    vLongitudArray = fLeer(vArchivo, "Q")

    for _ in range(vLongitudArray):
      fSaltarValor(vArchivo, vTipoArray)
  elif vTipo == 10:
    vArchivo.seek(8, os.SEEK_CUR)
  elif vTipo == 11:
    vArchivo.seek(8, os.SEEK_CUR)
  elif vTipo == 12:
    vArchivo.seek(8, os.SEEK_CUR)
  else:
    raise ValueError("Tipo GGUF no soportado: " + str(vTipo))


def fLeerValor(vArchivo, vTipo):
  if vTipo == 0:
    return fLeer(vArchivo, "B")
  elif vTipo == 1:
    return fLeer(vArchivo, "b")
  elif vTipo == 2:
    return fLeer(vArchivo, "H")
  elif vTipo == 3:
    return fLeer(vArchivo, "h")
  elif vTipo == 4:
    return fLeer(vArchivo, "I")
  elif vTipo == 5:
    return fLeer(vArchivo, "i")
  elif vTipo == 6:
    return fLeer(vArchivo, "f")
  elif vTipo == 7:
    return bool(fLeer(vArchivo, "B"))
  elif vTipo == 8:
    return fLeerCadena(vArchivo)
  elif vTipo == 10:
    return fLeer(vArchivo, "Q")
  elif vTipo == 11:
    return fLeer(vArchivo, "q")
  elif vTipo == 12:
    return fLeer(vArchivo, "d")
  else:
    raise ValueError("Tipo GGUF no soportado para lectura directa: " + str(vTipo))


def fListarCapas(vRutaModelo):
  aResultados = []

  with open(vRutaModelo, "rb") as vArchivo:
    vMagic = fLeerBytes(vArchivo, 4)

    if vMagic != b"GGUF":
      raise ValueError("El archivo no parece ser GGUF")

    vVersion = fLeer(vArchivo, "I")
    vTensorCount = fLeer(vArchivo, "Q")
    vMetadataCount = fLeer(vArchivo, "Q")

    for _ in range(vMetadataCount):
      vClave = fLeerCadena(vArchivo)
      vTipo = fLeer(vArchivo, "I")

      if vClave.endswith(".block_count"):
        vValor = fLeerValor(vArchivo, vTipo)
        aResultados.append((vClave, vValor))
      else:
        fSaltarValor(vArchivo, vTipo)

  return vVersion, vTensorCount, vMetadataCount, aResultados


def fMostrarResultado(vRutaModelo, aResultados, vMostrarRuta):
  if vMostrarRuta:
    print(vRutaModelo)

  if not aResultados:
    print("  No se encontró ninguna clave *.block_count en la metadata GGUF")
    return 1

  for vClave, vValor in aResultados:
    print("  " + str(vClave) + " = " + str(vValor))
    print("  layers = " + str(vValor))

  return 0


def fMain():
  vParser = argparse.ArgumentParser(
    description="Lista la cantidad de capas de uno o más modelos GGUF leyendo su metadata."
  )

  vParser.add_argument(
    "modelos",
    nargs="+",
    help="Ruta a uno o más archivos .gguf"
  )

  vArgumentos = vParser.parse_args()
  vCodigoSalida = 0
  vMostrarRuta = len(vArgumentos.modelos) > 1

  for vRutaModelo in vArgumentos.modelos:
    try:
      vVersion, vTensorCount, vMetadataCount, aResultados = fListarCapas(vRutaModelo)
      vResultado = fMostrarResultado(vRutaModelo, aResultados, vMostrarRuta)

      if vResultado != 0:
        vCodigoSalida = vResultado

    except Exception as vError:
      print(vRutaModelo + ": Error: " + str(vError), file=sys.stderr)
      vCodigoSalida = 1

  return vCodigoSalida


if __name__ == "__main__":
  sys.exit(fMain())

