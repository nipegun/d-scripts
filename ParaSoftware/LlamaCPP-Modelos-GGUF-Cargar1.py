#!/usr/bin/env python3

# Ejecución remota
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/LlamaCPP-Modelos-GGUF-Cargar.py | python3 - [ArchivoGGUF]

import argparse
import errno
import math
import os
import re
import shlex
import shutil
import socket
import struct
import subprocess
import sys
import time


cTiposKVBytes = {
  "f32": 4.0,
  "f16": 2.0,
  "bf16": 2.0,
  "q8_0": 34.0 / 32.0,
  "q4_0": 18.0 / 32.0,
  "q4_1": 20.0 / 32.0,
  "iq4_nl": 18.0 / 32.0,
  "q5_0": 22.0 / 32.0,
  "q5_1": 24.0 / 32.0
}


# Período de capas SWA para arquitecturas que no lo declaran en los metadatos.
# El valor N significa que 1 de cada N capas es de atención global y el resto SWA.
cPatronSWAPorArquitectura = {
  "gemma2": 2,
  "gemma3": 6,
  "gemma3n": 6
}


# Mapeo de general.file_type (enum llama_ftype de llama.cpp) a nombre de cuantización
# y tipo de caché KV equivalente. La caché KV se iguala a la precisión de los pesos:
# mantenerla muy por encima desperdicia memoria y por debajo degrada la calidad.
# Las cuantizaciones por debajo de 4 bits se elevan a q4_0 porque no existen tipos de caché menores.
cCuantizacionPorFileType = {
  0: ("F32", "f16"),
  1: ("F16", "f16"),
  2: ("Q4_0", "q4_0"),
  3: ("Q4_1", "q4_1"),
  7: ("Q8_0", "q8_0"),
  8: ("Q5_0", "q5_0"),
  9: ("Q5_1", "q5_1"),
  10: ("Q2_K", "q4_0"),
  11: ("Q3_K_S", "q4_0"),
  12: ("Q3_K_M", "q4_0"),
  13: ("Q3_K_L", "q4_0"),
  14: ("Q4_K_S", "q4_1"),
  15: ("Q4_K_M", "q4_1"),
  16: ("Q5_K_S", "q5_1"),
  17: ("Q5_K_M", "q5_1"),
  18: ("Q6_K", "q8_0"),
  19: ("IQ2_XXS", "q4_0"),
  20: ("IQ2_XS", "q4_0"),
  21: ("Q2_K_S", "q4_0"),
  22: ("IQ3_XS", "q4_0"),
  23: ("IQ3_XXS", "q4_0"),
  24: ("IQ1_S", "q4_0"),
  25: ("IQ4_NL", "iq4_nl"),
  26: ("IQ3_S", "q4_0"),
  27: ("IQ3_M", "q4_0"),
  28: ("IQ2_S", "q4_0"),
  29: ("IQ2_M", "q4_0"),
  30: ("IQ4_XS", "iq4_nl"),
  31: ("IQ1_M", "q4_0"),
  32: ("BF16", "f16"),
  36: ("TQ1_0", "q4_0"),
  37: ("TQ2_0", "q4_0"),
  38: ("MXFP4_MOE", "q4_1")
}


def fBytesAGiB(pBytes):
  return pBytes / 1024 / 1024 / 1024


def fGiBABBytes(pGiB):
  return int(pGiB * 1024 * 1024 * 1024)


def fMiBABBytes(pMiB):
  return int(pMiB * 1024 * 1024)


def fBytesAMiB(pBytes):
  return pBytes / 1024 / 1024


def fLeerBytes(pArchivo, pCantidad):
  vDatos = pArchivo.read(pCantidad)

  if len(vDatos) != pCantidad:
    raise EOFError("El archivo terminó antes de lo esperado")

  return vDatos


def fLeer(pArchivo, pFormato):
  vFormatoCompleto = "<" + pFormato
  vCantidad = struct.calcsize(vFormatoCompleto)
  return struct.unpack(vFormatoCompleto, fLeerBytes(pArchivo, vCantidad))[0]


def fLeerCadena(pArchivo):
  vLongitud = fLeer(pArchivo, "Q")
  vDatos = fLeerBytes(pArchivo, vLongitud)
  return vDatos.decode("utf-8", "replace")


def fSaltarValorMetadata(pArchivo, pTipo):
  if pTipo == 0:
    pArchivo.seek(1, os.SEEK_CUR)
  elif pTipo == 1:
    pArchivo.seek(1, os.SEEK_CUR)
  elif pTipo == 2:
    pArchivo.seek(2, os.SEEK_CUR)
  elif pTipo == 3:
    pArchivo.seek(2, os.SEEK_CUR)
  elif pTipo == 4:
    pArchivo.seek(4, os.SEEK_CUR)
  elif pTipo == 5:
    pArchivo.seek(4, os.SEEK_CUR)
  elif pTipo == 6:
    pArchivo.seek(4, os.SEEK_CUR)
  elif pTipo == 7:
    pArchivo.seek(1, os.SEEK_CUR)
  elif pTipo == 8:
    vLongitud = fLeer(pArchivo, "Q")
    pArchivo.seek(vLongitud, os.SEEK_CUR)
  elif pTipo == 9:
    vTipoArray = fLeer(pArchivo, "I")
    vLongitudArray = fLeer(pArchivo, "Q")

    for _ in range(vLongitudArray):
      fSaltarValorMetadata(pArchivo, vTipoArray)
  elif pTipo == 10:
    pArchivo.seek(8, os.SEEK_CUR)
  elif pTipo == 11:
    pArchivo.seek(8, os.SEEK_CUR)
  elif pTipo == 12:
    pArchivo.seek(8, os.SEEK_CUR)
  else:
    raise ValueError("Tipo GGUF no admitido en los metadatos: " + str(pTipo))


def fLeerValorMetadataEscalar(pArchivo, pTipo):
  if pTipo == 0:
    return fLeer(pArchivo, "B")
  elif pTipo == 1:
    return fLeer(pArchivo, "b")
  elif pTipo == 2:
    return fLeer(pArchivo, "H")
  elif pTipo == 3:
    return fLeer(pArchivo, "h")
  elif pTipo == 4:
    return fLeer(pArchivo, "I")
  elif pTipo == 5:
    return fLeer(pArchivo, "i")
  elif pTipo == 6:
    return fLeer(pArchivo, "f")
  elif pTipo == 7:
    return bool(fLeer(pArchivo, "B"))
  elif pTipo == 8:
    return fLeerCadena(pArchivo)
  elif pTipo == 10:
    return fLeer(pArchivo, "Q")
  elif pTipo == 11:
    return fLeer(pArchivo, "q")
  elif pTipo == 12:
    return fLeer(pArchivo, "d")
  else:
    raise ValueError("Tipo GGUF no admitido en los metadatos escalares: " + str(pTipo))


def fLeerValorMetadata(pArchivo, pTipo):
  if pTipo == 9:
    vTipoArray = fLeer(pArchivo, "I")
    vLongitudArray = fLeer(pArchivo, "Q")
    aValores = []

    if vLongitudArray > 4096:
      for _ in range(vLongitudArray):
        fSaltarValorMetadata(pArchivo, vTipoArray)

      return None

    for _ in range(vLongitudArray):
      aValores.append(fLeerValorMetadataEscalar(pArchivo, vTipoArray))

    return aValores

  return fLeerValorMetadataEscalar(pArchivo, pTipo)


def fAlinear(pValor, pAlineacion):
  vResto = pValor % pAlineacion

  if vResto == 0:
    return pValor

  return pValor + pAlineacion - vResto


def fObtenerIndiceCapa(pNombreTensor):
  vMatch = re.search(r"^blk\.([0-9]+)\.", pNombreTensor)

  if vMatch:
    return int(vMatch.group(1))

  vMatch = re.search(r"\.layers\.([0-9]+)\.", pNombreTensor)

  if vMatch:
    return int(vMatch.group(1))

  return None


def fTensorPareceMoE(pNombreTensor):
  aPatrones = [
    ".ffn_gate_exps",
    ".ffn_down_exps",
    ".ffn_up_exps",
    ".experts.",
    ".mlp.experts.",
    ".feed_forward.experts.",
    ".block_sparse_moe."
  ]

  vNombre = pNombreTensor.lower()

  for vPatron in aPatrones:
    if vPatron in vNombre:
      return True

  return False


def fTensorPareceSalida(pNombreTensor):
  vNombre = pNombreTensor.lower()

  return (
    vNombre.startswith("output.")
    or vNombre.startswith("output_")
    or vNombre.startswith("lm_head.")
  )


def fCrearCapaVacia():
  return {
    "total": 0,
    "moe": 0,
    "normal": 0
  }


def fLeerGGUFIndividual(pRutaModelo):
  dMetadata = {}
  ldTensores = []
  vTamanoArchivo = os.path.getsize(pRutaModelo)

  with open(pRutaModelo, "rb") as vArchivo:
    vMagic = fLeerBytes(vArchivo, 4)

    if vMagic != b"GGUF":
      raise ValueError("El archivo no parece ser GGUF")

    vVersion = fLeer(vArchivo, "I")
    vTensorCount = fLeer(vArchivo, "Q")
    vMetadataCount = fLeer(vArchivo, "Q")

    for _ in range(vMetadataCount):
      vClave = fLeerCadena(vArchivo)
      vTipo = fLeer(vArchivo, "I")
      vPosicionValor = vArchivo.tell()

      try:
        vValor = fLeerValorMetadata(vArchivo, vTipo)

        if vValor is not None:
          dMetadata[vClave] = vValor

      except Exception:
        vArchivo.seek(vPosicionValor)
        fSaltarValorMetadata(vArchivo, vTipo)

    for _ in range(vTensorCount):
      vNombreTensor = fLeerCadena(vArchivo)
      vDimensiones = fLeer(vArchivo, "I")

      for _ in range(vDimensiones):
        fLeer(vArchivo, "Q")

      vTipoTensor = fLeer(vArchivo, "I")
      vOffsetTensor = fLeer(vArchivo, "Q")

      ldTensores.append({
        "nombre": vNombreTensor,
        "tipo": vTipoTensor,
        "offset": vOffsetTensor,
        "moe": fTensorPareceMoE(vNombreTensor),
        "salida": fTensorPareceSalida(vNombreTensor)
      })

    vAlineacion = int(dMetadata.get("general.alignment", 32))

    if vAlineacion <= 0:
      raise ValueError("La alineación GGUF debe ser mayor que cero")

    vInicioDatos = fAlinear(vArchivo.tell(), vAlineacion)

  ldTensoresOrdenados = sorted(ldTensores, key=lambda pElemento: pElemento["offset"])
  dCapas = {}
  vBytesSinCapa = 0
  vBytesSinCapaMoE = 0
  vBytesSinCapaSalida = 0
  vBytesSinCapaMoESalida = 0
  vBytesTotal = 0
  vBytesMoE = 0

  for vIndice, dTensor in enumerate(ldTensoresOrdenados):
    vOffsetAbsoluto = vInicioDatos + dTensor["offset"]

    if vIndice + 1 < len(ldTensoresOrdenados):
      vSiguienteOffsetAbsoluto = vInicioDatos + ldTensoresOrdenados[vIndice + 1]["offset"]
      vBytesTensor = vSiguienteOffsetAbsoluto - vOffsetAbsoluto
    else:
      vBytesTensor = vTamanoArchivo - vOffsetAbsoluto

    if vBytesTensor < 0:
      raise ValueError("Offset inválido detectado en el GGUF")

    vBytesTotal += vBytesTensor

    if dTensor["moe"]:
      vBytesMoE += vBytesTensor

    vIndiceCapa = fObtenerIndiceCapa(dTensor["nombre"])

    if vIndiceCapa is None:
      vBytesSinCapa += vBytesTensor

      if dTensor["moe"]:
        vBytesSinCapaMoE += vBytesTensor

      if dTensor["salida"]:
        vBytesSinCapaSalida += vBytesTensor

        if dTensor["moe"]:
          vBytesSinCapaMoESalida += vBytesTensor
    else:
      if vIndiceCapa not in dCapas:
        dCapas[vIndiceCapa] = fCrearCapaVacia()

      dCapas[vIndiceCapa]["total"] += vBytesTensor

      if dTensor["moe"]:
        dCapas[vIndiceCapa]["moe"] += vBytesTensor
      else:
        dCapas[vIndiceCapa]["normal"] += vBytesTensor

  return {
    "ruta": pRutaModelo,
    "version": vVersion,
    "metadata": dMetadata,
    "tensor_count": vTensorCount,
    "bytes_total": vBytesTotal,
    "bytes_sin_capa": vBytesSinCapa,
    "bytes_sin_capa_moe": vBytesSinCapaMoE,
    "bytes_sin_capa_salida": vBytesSinCapaSalida,
    "bytes_sin_capa_moe_salida": vBytesSinCapaMoESalida,
    "bytes_moe": vBytesMoE,
    "capas": dCapas,
    "rutas": [pRutaModelo],
    "split_count": 1
  }


def fObtenerRutasGGUFDividido(pRutaModelo, pSplitCount):
  vNombre = os.path.basename(pRutaModelo)
  vDirectorio = os.path.dirname(os.path.abspath(pRutaModelo))
  vCoincidencia = re.match(r"^(.*)-(\d+)-of-(\d+)(\.gguf)$", vNombre, re.IGNORECASE)

  if vCoincidencia is None:
    raise ValueError("El GGUF declara varios fragmentos, pero su nombre no sigue el formato N-of-M.gguf")

  vNumeroActual = int(vCoincidencia.group(2))
  vTotalNombre = int(vCoincidencia.group(3))
  vAnchoNumero = len(vCoincidencia.group(2))
  vAnchoTotal = len(vCoincidencia.group(3))

  if vNumeroActual != 1:
    raise ValueError("Debe indicarse el primer fragmento del GGUF dividido")

  if vTotalNombre != pSplitCount:
    raise ValueError("El número de fragmentos del nombre no coincide con split.count")

  aRutas = []

  for vIndice in range(1, pSplitCount + 1):
    vNombreFragmento = (
      vCoincidencia.group(1)
      + "-"
      + str(vIndice).zfill(vAnchoNumero)
      + "-of-"
      + str(pSplitCount).zfill(vAnchoTotal)
      + vCoincidencia.group(4)
    )
    vRutaFragmento = os.path.join(vDirectorio, vNombreFragmento)

    if not os.path.isfile(vRutaFragmento):
      raise ValueError("Falta el fragmento GGUF: " + vRutaFragmento)

    aRutas.append(vRutaFragmento)

  return aRutas


def fCombinarResultadosGGUF(pResultados):
  if len(pResultados) == 0:
    raise ValueError("No hay fragmentos GGUF para combinar")

  aRutasCombinadas = []

  for dFragmento in pResultados:
    aRutasCombinadas.extend(dFragmento.get("rutas", [dFragmento["ruta"]]))

  dResultado = pResultados[0]
  dResultado["rutas"] = aRutasCombinadas
  dResultado["split_count"] = len(pResultados)

  for vIndiceResultado, dFragmento in enumerate(pResultados):
    if vIndiceResultado == 0:
      continue

    if dFragmento["version"] != dResultado["version"]:
      raise ValueError("Los fragmentos GGUF no tienen la misma versión")

    dResultado["tensor_count"] += dFragmento["tensor_count"]
    dResultado["bytes_total"] += dFragmento["bytes_total"]
    dResultado["bytes_sin_capa"] += dFragmento["bytes_sin_capa"]
    dResultado["bytes_sin_capa_moe"] += dFragmento["bytes_sin_capa_moe"]
    dResultado["bytes_sin_capa_salida"] += dFragmento["bytes_sin_capa_salida"]
    dResultado["bytes_sin_capa_moe_salida"] += dFragmento["bytes_sin_capa_moe_salida"]
    dResultado["bytes_moe"] += dFragmento["bytes_moe"]

    for vIndiceCapa, dCapa in dFragmento["capas"].items():
      if vIndiceCapa not in dResultado["capas"]:
        dResultado["capas"][vIndiceCapa] = fCrearCapaVacia()

      dResultado["capas"][vIndiceCapa]["total"] += dCapa["total"]
      dResultado["capas"][vIndiceCapa]["moe"] += dCapa["moe"]
      dResultado["capas"][vIndiceCapa]["normal"] += dCapa["normal"]

  vTensorCountEsperado = fConvertirEnteroMetadata(dResultado["metadata"].get("split.tensors.count"), None)

  if vTensorCountEsperado is not None and dResultado["tensor_count"] != vTensorCountEsperado:
    raise ValueError("El total de tensores no coincide con split.tensors.count")

  return dResultado


def fLeerGGUF(pRutaModelo):
  dResultadoInicial = fLeerGGUFIndividual(pRutaModelo)
  vSplitCount = fConvertirEnteroMetadata(dResultadoInicial["metadata"].get("split.count"), 1)
  vSplitNo = fConvertirEnteroMetadata(dResultadoInicial["metadata"].get("split.no"), 0)

  if vSplitCount is None or vSplitCount <= 1:
    return dResultadoInicial

  if vSplitNo != 0:
    raise ValueError("Debe indicarse el primer fragmento del GGUF dividido")

  aRutas = fObtenerRutasGGUFDividido(pRutaModelo, vSplitCount)
  ldResultados = []

  for vIndice, vRutaFragmento in enumerate(aRutas):
    dFragmento = fLeerGGUFIndividual(vRutaFragmento)
    vNumeroFragmento = fConvertirEnteroMetadata(dFragmento["metadata"].get("split.no"), None)
    vTotalFragmentos = fConvertirEnteroMetadata(dFragmento["metadata"].get("split.count"), None)

    if vNumeroFragmento != vIndice:
      raise ValueError("El orden de split.no no coincide en " + vRutaFragmento)

    if vTotalFragmentos != vSplitCount:
      raise ValueError("split.count no coincide en " + vRutaFragmento)

    ldResultados.append(dFragmento)

  return fCombinarResultadosGGUF(ldResultados)


def fCargarGGUF(pRuta, pDescripcion):
  if not os.path.isfile(pRuta):
    print("Error: no se encuentra el archivo " + pDescripcion + ": " + str(pRuta), file=sys.stderr)
    return None

  try:
    return fLeerGGUF(pRuta)
  except (ValueError, EOFError, OSError, struct.error) as vError:
    print("Error: no se pudo leer el GGUF " + pDescripcion + " '" + str(pRuta) + "': " + str(vError), file=sys.stderr)
    return None


def fObtenerMetadata(pResultadoGGUF, pClave, pDefecto=None):
  return pResultadoGGUF["metadata"].get(pClave, pDefecto)


def fObtenerMetadataPorSufijo(pResultadoGGUF, pSufijos, pDefecto=None):
  vArquitectura = pResultadoGGUF["metadata"].get("general.architecture")

  for vSufijo in pSufijos:
    if vArquitectura is not None:
      vClaveArquitectura = str(vArquitectura) + vSufijo

      if vClaveArquitectura in pResultadoGGUF["metadata"]:
        return pResultadoGGUF["metadata"][vClaveArquitectura]

    for vClave, vValor in pResultadoGGUF["metadata"].items():
      if vClave.endswith(vSufijo):
        return vValor

  return pDefecto


def fObtenerArquitectura(pResultadoGGUF):
  return str(fObtenerMetadata(pResultadoGGUF, "general.architecture", "desconocida"))


def fConvertirEnteroMetadata(pValor, pDefecto=None):
  if pValor is None:
    return pDefecto

  if isinstance(pValor, list):
    for vElemento in pValor:
      vEntero = fConvertirEnteroMetadata(vElemento, None)

      if vEntero is not None:
        return vEntero

    return pDefecto

  if isinstance(pValor, bool):
    return int(pValor)

  try:
    return int(pValor)
  except (TypeError, ValueError):
    return pDefecto


def fObtenerBlockCount(pResultadoGGUF):
  vValor = fObtenerMetadataPorSufijo(pResultadoGGUF, [".block_count"])
  vEntero = fConvertirEnteroMetadata(vValor, None)

  if vEntero is not None:
    return vEntero

  aIndicesCapas = [
    vIndiceCapa
    for vIndiceCapa in pResultadoGGUF["capas"]
    if isinstance(vIndiceCapa, int) and vIndiceCapa >= 0
  ]

  if len(aIndicesCapas) == 0:
    return 0

  return max(aIndicesCapas) + 1


def fObtenerContextoNativo(pResultadoGGUF):
  vValor = fObtenerMetadataPorSufijo(pResultadoGGUF, [".context_length", ".max_position_embeddings"])
  return fConvertirEnteroMetadata(vValor, None)


def fObtenerEnteroMetadata(pResultadoGGUF, pSufijos, pDefecto=None):
  vValor = fObtenerMetadataPorSufijo(pResultadoGGUF, pSufijos)
  return fConvertirEnteroMetadata(vValor, pDefecto)


def fExpandirValorPorCapa(pValor, pBlockCount, pDefecto=None):
  aLista = []

  if isinstance(pValor, list) and len(pValor) > 0:
    for vIndiceCapa in range(pBlockCount):
      if vIndiceCapa < len(pValor):
        aLista.append(fConvertirEnteroMetadata(pValor[vIndiceCapa], pDefecto))
      else:
        aLista.append(fConvertirEnteroMetadata(pValor[-1], pDefecto))

    return aLista

  vEntero = fConvertirEnteroMetadata(pValor, pDefecto)

  for _ in range(pBlockCount):
    aLista.append(vEntero)

  return aLista


def fObtenerPatronSWA(pResultadoGGUF, pBlockCount):
  vVentana = fObtenerEnteroMetadata(pResultadoGGUF, [".attention.sliding_window"])

  if vVentana is None or vVentana <= 0:
    return None

  vPatron = fObtenerMetadataPorSufijo(pResultadoGGUF, [".attention.sliding_window_pattern"])
  aEsSWA = None

  if isinstance(vPatron, list) and len(vPatron) > 0:
    aEsSWA = []

    for vIndiceCapa in range(pBlockCount):
      if vIndiceCapa < len(vPatron):
        aEsSWA.append(bool(vPatron[vIndiceCapa]))
      else:
        aEsSWA.append(bool(vPatron[-1]))
  else:
    vPeriodo = fConvertirEnteroMetadata(vPatron, None)

    if vPeriodo is None:
      vPeriodo = cPatronSWAPorArquitectura.get(fObtenerArquitectura(pResultadoGGUF))

    if vPeriodo is not None and vPeriodo > 1:
      aEsSWA = [((vIndiceCapa + 1) % vPeriodo) != 0 for vIndiceCapa in range(pBlockCount)]

  if aEsSWA is None:
    return None

  return {
    "ventana": vVentana,
    "es_swa": aEsSWA
  }


def fObtenerDimensionesKV(pResultadoGGUF):
  vEmbedding = fObtenerEnteroMetadata(pResultadoGGUF, [".embedding_length", ".hidden_size"])
  vHeadCount = fObtenerEnteroMetadata(pResultadoGGUF, [".attention.head_count", ".num_attention_heads"])
  vHeadCountKV = fObtenerEnteroMetadata(pResultadoGGUF, [".attention.head_count_kv", ".num_key_value_heads"])
  vKeyLength = fObtenerEnteroMetadata(pResultadoGGUF, [".attention.key_length"])
  vValueLength = fObtenerEnteroMetadata(pResultadoGGUF, [".attention.value_length"])

  if vHeadCountKV is None:
    vHeadCountKV = vHeadCount

  if vKeyLength is None:
    if vEmbedding is not None and vHeadCount is not None and vHeadCount > 0:
      vKeyLength = int(vEmbedding / vHeadCount)

  if vValueLength is None:
    if vEmbedding is not None and vHeadCount is not None and vHeadCount > 0:
      vValueLength = int(vEmbedding / vHeadCount)

  if (
    vHeadCountKV is None
    or vHeadCountKV <= 0
    or vKeyLength is None
    or vKeyLength <= 0
    or vValueLength is None
    or vValueLength <= 0
  ):
    return None

  return {
    "head_count": vHeadCount,
    "head_count_kv": vHeadCountKV,
    "key_length": vKeyLength,
    "value_length": vValueLength,
    "k_gqa": vHeadCountKV * vKeyLength,
    "v_gqa": vHeadCountKV * vValueLength
  }


def fObtenerConfiguracionRecurrente(pResultadoGGUF, pBlockCount, pParallel):
  vArquitectura = fObtenerArquitectura(pResultadoGGUF)
  vTieneSSM = any(".ssm." in vClave for vClave in pResultadoGGUF["metadata"])

  if not vTieneSSM:
    return {
      "detectada": False,
      "estimada": True,
      "bytes": 0
    }

  if vArquitectura not in ["qwen3next", "qwen35", "qwen35moe"]:
    return {
      "detectada": True,
      "estimada": False,
      "motivo": "la arquitectura recurrente " + vArquitectura + " no tiene una fórmula de estado validada"
    }

  vIntervaloAtencion = fObtenerEnteroMetadata(pResultadoGGUF, [".full_attention_interval"], 4)
  vConvKernel = fObtenerEnteroMetadata(pResultadoGGUF, [".ssm.conv_kernel"])
  vStateSize = fObtenerEnteroMetadata(pResultadoGGUF, [".ssm.state_size"])
  vInnerSize = fObtenerEnteroMetadata(pResultadoGGUF, [".ssm.inner_size"])

  if (
    vIntervaloAtencion is None
    or vIntervaloAtencion <= 1
    or vConvKernel is None
    or vConvKernel <= 0
    or vStateSize is None
    or vStateSize <= 0
    or vInnerSize is None
    or vInnerSize <= 0
  ):
    return {
      "detectada": True,
      "estimada": False,
      "motivo": "faltan dimensiones válidas del estado recurrente SSM"
    }

  aEsAtencion = [
    ((vIndiceCapa + 1) % vIntervaloAtencion) == 0
    for vIndiceCapa in range(pBlockCount)
  ]
  vCapasRecurrentes = sum(1 for vEsAtencion in aEsAtencion if not vEsAtencion)
  vElementosEstadoPorCapa = vInnerSize * (vStateSize + (2 * (vConvKernel - 1)))
  vBytesPorCapa = vElementosEstadoPorCapa * 4 * int(pParallel)

  return {
    "detectada": True,
    "estimada": True,
    "arquitectura": vArquitectura,
    "es_atencion": aEsAtencion,
    "capas_recurrentes": vCapasRecurrentes,
    "bytes_por_capa": vBytesPorCapa,
    "bytes": vBytesPorCapa * vCapasRecurrentes
  }


def fBytesPorTipoKV(pTipoKV):
  vTipo = str(pTipoKV).lower()

  if vTipo not in cTiposKVBytes:
    raise ValueError("Tipo de caché KV no admitido para la estimación: " + str(pTipoKV))

  return cTiposKVBytes[vTipo]


def fCalcularBytesKVCache(pResultadoGGUF, pCtxSize, pParallel, pCacheTypeK, pCacheTypeV, pUBatchSize=512, pSWAFull=False):
  vBlockCount = fObtenerBlockCount(pResultadoGGUF)
  dDimensionesKV = fObtenerDimensionesKV(pResultadoGGUF)
  dRecurrente = fObtenerConfiguracionRecurrente(pResultadoGGUF, vBlockCount, pParallel)

  if vBlockCount <= 0:
    return {
      "bytes": 0,
      "bytes_fijos": 0,
      "bytes_por_capa": {},
      "bytes_fijos_por_capa": {},
      "estimado": False,
      "motivo": "block_count no es un entero positivo y no puede inferirse de las capas",
      "swa": None,
      "recurrente": dRecurrente
    }

  if not dRecurrente["estimada"]:
    return {
      "bytes": 0,
      "bytes_fijos": 0,
      "bytes_por_capa": {},
      "bytes_fijos_por_capa": {},
      "estimado": False,
      "motivo": dRecurrente["motivo"],
      "swa": None,
      "recurrente": dRecurrente
    }

  if dDimensionesKV is None:
    return {
      "bytes": 0,
      "bytes_fijos": 0,
      "bytes_por_capa": {},
      "bytes_fijos_por_capa": {},
      "estimado": False,
      "motivo": "no se encontraron dimensiones K/V suficientes en los metadatos",
      "swa": None,
      "recurrente": dRecurrente
    }

  vBytesK = fBytesPorTipoKV(pCacheTypeK)
  vBytesV = fBytesPorTipoKV(pCacheTypeV)
  vCtxTotal = int(pCtxSize)
  dPatronSWA = fObtenerPatronSWA(pResultadoGGUF, vBlockCount)
  vValorHeadCountKV = fObtenerMetadataPorSufijo(pResultadoGGUF, [".attention.head_count_kv", ".num_key_value_heads"])
  aHeadCountKVPorCapa = fExpandirValorPorCapa(vValorHeadCountKV, vBlockCount, dDimensionesKV["head_count_kv"])
  vKeyLengthSWA = fObtenerEnteroMetadata(pResultadoGGUF, [".attention.key_length_swa"], dDimensionesKV["key_length"])
  vValueLengthSWA = fObtenerEnteroMetadata(pResultadoGGUF, [".attention.value_length_swa"], dDimensionesKV["value_length"])
  vCapasCompartidas = fObtenerEnteroMetadata(pResultadoGGUF, [".attention.shared_kv_layers"], 0)

  if vCapasCompartidas is None:
    vCapasCompartidas = 0

  if any(vHeadCountKV is None or vHeadCountKV <= 0 for vHeadCountKV in aHeadCountKVPorCapa):
    return {
      "bytes": 0,
      "bytes_fijos": 0,
      "bytes_por_capa": {},
      "bytes_fijos_por_capa": {},
      "estimado": False,
      "motivo": "attention.head_count_kv contiene dimensiones no positivas",
      "swa": None,
      "recurrente": dRecurrente
    }

  if dPatronSWA is not None and (
    vKeyLengthSWA is None
    or vKeyLengthSWA <= 0
    or vValueLengthSWA is None
    or vValueLengthSWA <= 0
  ):
    return {
      "bytes": 0,
      "bytes_fijos": 0,
      "bytes_por_capa": {},
      "bytes_fijos_por_capa": {},
      "estimado": False,
      "motivo": "las dimensiones K/V de la atención SWA no son positivas",
      "swa": None,
      "recurrente": dRecurrente
    }

  if vCapasCompartidas < 0 or vCapasCompartidas > vBlockCount:
    return {
      "bytes": 0,
      "bytes_fijos": 0,
      "bytes_por_capa": {},
      "bytes_fijos_por_capa": {},
      "estimado": False,
      "motivo": "attention.shared_kv_layers está fuera del rango de capas",
      "swa": None,
      "recurrente": dRecurrente
    }

  vBytes = 0
  vBytesFijos = 0
  vCapasSWA = 0
  vCapasGlobales = 0
  dBytesPorCapa = {}
  dBytesFijosPorCapa = {}

  for vIndiceCapa in range(vBlockCount):
    dBytesPorCapa[vIndiceCapa] = 0
    dBytesFijosPorCapa[vIndiceCapa] = 0

    if dRecurrente["detectada"] and not dRecurrente["es_atencion"][vIndiceCapa]:
      vBytesCapa = dRecurrente["bytes_por_capa"]
      vBytes += vBytesCapa
      vBytesFijos += vBytesCapa
      dBytesPorCapa[vIndiceCapa] = vBytesCapa
      dBytesFijosPorCapa[vIndiceCapa] = vBytesCapa
      continue

    # Las últimas shared_kv_layers capas reutilizan la KV de capas anteriores y no reservan memoria propia
    if vCapasCompartidas > 0 and vIndiceCapa >= vBlockCount - vCapasCompartidas:
      continue

    vHeadCountKVCapa = aHeadCountKVPorCapa[vIndiceCapa]

    if vHeadCountKVCapa is None:
      vHeadCountKVCapa = dDimensionesKV["head_count_kv"]

    vEsCapaSWA = dPatronSWA is not None and dPatronSWA["es_swa"][vIndiceCapa]

    if vEsCapaSWA and not pSWAFull:
      # llama.cpp solo reserva la ventana SWA más el microbatch en estas capas, no el contexto completo
      vLimiteTokensSWA = (dPatronSWA["ventana"] * int(pParallel)) + int(pUBatchSize)
      vTokensCapa = min(vCtxTotal, vLimiteTokensSWA)
      vBytesCapa = int(vTokensCapa * ((vHeadCountKVCapa * vKeyLengthSWA * vBytesK) + (vHeadCountKVCapa * vValueLengthSWA * vBytesV)))
      vBytes += vBytesCapa
      dBytesPorCapa[vIndiceCapa] = vBytesCapa

      if vCtxTotal >= vLimiteTokensSWA:
        vBytesFijos += vBytesCapa
        dBytesFijosPorCapa[vIndiceCapa] = vBytesCapa

      vCapasSWA += 1
    else:
      vTokensCapa = vCtxTotal

      if vEsCapaSWA:
        vKeyLengthCapa = vKeyLengthSWA
        vValueLengthCapa = vValueLengthSWA
      else:
        vKeyLengthCapa = dDimensionesKV["key_length"]
        vValueLengthCapa = dDimensionesKV["value_length"]

      vBytesCapa = int(vTokensCapa * ((vHeadCountKVCapa * vKeyLengthCapa * vBytesK) + (vHeadCountKVCapa * vValueLengthCapa * vBytesV)))
      vBytes += vBytesCapa
      dBytesPorCapa[vIndiceCapa] = vBytesCapa

      if vEsCapaSWA:
        vCapasSWA += 1
      else:
        vCapasGlobales += 1

  dInfoSWA = None

  if dPatronSWA is not None:
    dInfoSWA = {
      "ventana": dPatronSWA["ventana"],
      "capas_swa": vCapasSWA,
      "capas_globales": vCapasGlobales,
      "swa_full": bool(pSWAFull)
    }

  return {
    "bytes": vBytes,
    "bytes_fijos": vBytesFijos,
    "bytes_por_capa": dBytesPorCapa,
    "bytes_fijos_por_capa": dBytesFijosPorCapa,
    "estimado": True,
    "motivo": "ok",
    "dimensiones": dDimensionesKV,
    "swa": dInfoSWA,
    "recurrente": dRecurrente
  }



def fConfigurarTipoCachePorDefecto(pArgumentos, pResultadoGGUF):
  aAvisos = []

  if pArgumentos.cache_type_k != "auto" and pArgumentos.cache_type_v != "auto":
    pArgumentos.cache_type_origen = "indicado por usuario"

    if pArgumentos.cache_type_v not in ["f32", "f16", "bf16"]:
      aAvisos.append("La caché V cuantizada (" + str(pArgumentos.cache_type_v) + ") requiere atención flash; usa --flash-attn on o auto en llama-server.")

    return aAvisos

  vFileType = fConvertirEnteroMetadata(fObtenerMetadata(pResultadoGGUF, "general.file_type"), None)
  vNombreCuantizacion = "desconocida"
  vTipoDetectado = "f16"

  if vFileType is not None and vFileType in cCuantizacionPorFileType:
    vNombreCuantizacion = cCuantizacionPorFileType[vFileType][0]
    vTipoDetectado = cCuantizacionPorFileType[vFileType][1]
  else:
    aAvisos.append("No se pudo determinar la cuantización del modelo (general.file_type); la caché KV automática usa f16.")

  if pArgumentos.cache_type_k == "auto" and pArgumentos.cache_type_v == "auto":
    pArgumentos.cache_type_k = vTipoDetectado
    pArgumentos.cache_type_v = vTipoDetectado
    pArgumentos.cache_type_origen = "auto según cuantización del modelo (pesos " + vNombreCuantizacion + ")"
  else:
    aPartesOrigen = []

    if pArgumentos.cache_type_k == "auto":
      pArgumentos.cache_type_k = vTipoDetectado
      aPartesOrigen.append("K auto (pesos " + vNombreCuantizacion + ")")
    else:
      aPartesOrigen.append("K indicado por usuario")

    if pArgumentos.cache_type_v == "auto":
      pArgumentos.cache_type_v = vTipoDetectado
      aPartesOrigen.append("V auto (pesos " + vNombreCuantizacion + ")")
    else:
      aPartesOrigen.append("V indicado por usuario")

    pArgumentos.cache_type_origen = ", ".join(aPartesOrigen)

  if pArgumentos.cache_type_v not in ["f32", "f16", "bf16"]:
    aAvisos.append("La caché V cuantizada (" + str(pArgumentos.cache_type_v) + ") requiere atención flash; usa --flash-attn on o auto en llama-server.")

  return aAvisos


def fObtenerErrorCompatibilidadSplitTensor(pArgumentos):
  if pArgumentos.split_mode != "tensor":
    return None

  if pArgumentos.flash_attn == "off":
    return "--split-mode tensor no es compatible con --flash-attn off"

  aTiposSinCuantizar = ["f32", "f16", "bf16"]

  if pArgumentos.cache_type_k not in aTiposSinCuantizar or pArgumentos.cache_type_v not in aTiposSinCuantizar:
    return "--split-mode tensor no admite una caché KV principal cuantizada; usa f32, f16 o bf16"

  if pArgumentos.model_draft is not None and (
    pArgumentos.cache_type_k_draft not in aTiposSinCuantizar
    or pArgumentos.cache_type_v_draft not in aTiposSinCuantizar
  ):
    return "--split-mode tensor no admite una caché KV draft cuantizada; usa f32, f16 o bf16"

  return None


def fConfigurarContextoPorDefecto(pArgumentos, pResultadoGGUF):
  vContextoNativo = fObtenerContextoNativo(pResultadoGGUF)

  if pArgumentos.ctx_size is not None:
    pArgumentos.ctx_size_origen = "indicado por usuario"
    return

  if vContextoNativo is not None and vContextoNativo > 0:
    pArgumentos.ctx_size = vContextoNativo
    pArgumentos.ctx_size_origen = "nativo del GGUF"
    return

  pArgumentos.ctx_size = 32768
  pArgumentos.ctx_size_origen = "fallback del script"


def fRedondearContextoRecomendado(pCtxSize):
  if pCtxSize is None:
    return None

  pCtxSize = int(pCtxSize)

  if pCtxSize < 1024:
    return None

  return max(1024, int(pCtxSize / 1024) * 1024)


def fCalcularContextoAconsejadoAcelerador(
  pCtxActual,
  pBytesKVActual,
  pBytesKVFijo,
  pBytesModeloGPU,
  pLibreTotal,
  pOverheadPercent,
  pOverheadFijoBytes,
  pReservaTotalBytes
):
  if pCtxActual is None or pCtxActual <= 0 or pBytesKVActual <= 0:
    return None

  if pLibreTotal is None or pLibreTotal <= 0:
    return None

  vDisponibleAntesKV = pLibreTotal - pReservaTotalBytes - pOverheadFijoBytes
  vKVMax = (vDisponibleAntesKV / (1 + pOverheadPercent)) - pBytesModeloGPU

  if vKVMax <= 0:
    return None

  # La parte fija SWA/recurrente no baja al reducir contexto; solo escala la KV de atención variable
  vBytesKVVariable = pBytesKVActual - pBytesKVFijo
  vKVMaxVariable = vKVMax - pBytesKVFijo

  if vBytesKVVariable <= 0 or vKVMaxVariable <= 0:
    return None

  vCtxMax = int(pCtxActual * (vKVMaxVariable / vBytesKVVariable) * 0.90)
  return fRedondearContextoRecomendado(vCtxMax)


def fCalcularContextoAconsejadoRAM(
  pCtxActual,
  pBytesKVActual,
  pBytesKVFijo,
  pBytesModeloCPU,
  pMemAvailable,
  pCacheRAMBytes,
  pReservaMinimaBytes
):
  if pCtxActual is None or pCtxActual <= 0 or pBytesKVActual <= 0:
    return None

  vKVMax = ((pMemAvailable - pReservaMinimaBytes - pCacheRAMBytes) / 1.10) - pBytesModeloCPU

  if vKVMax <= 0:
    return None

  vBytesKVVariable = pBytesKVActual - pBytesKVFijo
  vKVMaxVariable = vKVMax - pBytesKVFijo

  if vBytesKVVariable <= 0 or vKVMaxVariable <= 0:
    return None

  vCtxMax = int(pCtxActual * (vKVMaxVariable / vBytesKVVariable) * 0.90)
  return fRedondearContextoRecomendado(vCtxMax)


def fAgregarAvisoContextoDemasiadoGrande(
  pAvisos,
  pArgumentos,
  pCabeAcelerador,
  pCabeRAM,
  pAceleradores,
  pKVOffloadActivo,
  pBytesKVGPU,
  pBytesKVRAM,
  pBytesKVFijoGPU,
  pBytesKVFijoRAM,
  pBytesModeloGPU,
  pBytesModeloCPU,
  pOverheadPercent,
  pOverheadFijoBytes,
  pReservaMinimaBytes,
  pMemAvailable,
  pCacheRAMBytes
):
  if pCabeAcelerador and pCabeRAM:
    return

  if getattr(pArgumentos, "ctx_size_origen", "") == "nativo del GGUF":
    pAvisos.append("Se está usando el contexto nativo máximo del GGUF; si no cabe, reduce --ctx-size.")
  else:
    pAvisos.append("El contexto solicitado no cabe con la memoria calculada; reduce --ctx-size.")

  aContextos = []

  if pBytesKVGPU > 0 and not pCabeAcelerador and len(pAceleradores) == 1:
    vLibreTotal = None

    if all(dAcelerador["libre"] is not None for dAcelerador in pAceleradores):
      vLibreTotal = sum(dAcelerador["libre"] for dAcelerador in pAceleradores)

    vContextoAcelerador = fCalcularContextoAconsejadoAcelerador(
      pArgumentos.ctx_size,
      pBytesKVGPU,
      pBytesKVFijoGPU,
      pBytesModeloGPU,
      vLibreTotal,
      pOverheadPercent,
      pOverheadFijoBytes,
      pReservaMinimaBytes * len(pAceleradores)
    )

    if vContextoAcelerador is not None:
      aContextos.append(vContextoAcelerador)

  if pBytesKVRAM > 0 and not pCabeRAM:
    vContextoRAM = fCalcularContextoAconsejadoRAM(
      pArgumentos.ctx_size,
      pBytesKVRAM,
      pBytesKVFijoRAM,
      pBytesModeloCPU,
      pMemAvailable,
      pCacheRAMBytes,
      pReservaMinimaBytes
    )

    if vContextoRAM is not None:
      aContextos.append(vContextoRAM)

  if len(aContextos) > 0:
    vContextoAconsejado = min(aContextos)
    pAvisos.append("Prueba con --ctx-size " + str(vContextoAconsejado) + " como punto de partida conservador.")
  else:
    pAvisos.append("Reducir el contexto puede no ser suficiente; baja --ngl, activa --cpu-moe o usa una caché KV más pequeña.")

def fNormalizarNGL(pNgl, pBlockCount):
  if str(pNgl).lower() == "auto":
    vNGLNormalizado = pBlockCount + 1
  elif str(pNgl).lower() == "all":
    vNGLNormalizado = pBlockCount + 1
  else:
    vNGLNormalizado = int(pNgl)

  if vNGLNormalizado < 0:
    vNGLNormalizado = 0

  if vNGLNormalizado > pBlockCount + 1:
    vNGLNormalizado = pBlockCount + 1

  return vNGLNormalizado


def fCalcularBytesGPU(pResultadoGGUF, pNgl, pCpuMoE, pNCpuMoE):
  vBlockCount = fObtenerBlockCount(pResultadoGGUF)
  vNGLNormalizado = fNormalizarNGL(pNgl, vBlockCount)
  vCapasGPU = max(0, min(vBlockCount, vNGLNormalizado - 1))
  vIndicePrimeraCapaGPU = vBlockCount - vCapasGPU
  vBytesGPU = 0

  if vNGLNormalizado > 0:
    vBytesSalida = pResultadoGGUF.get("bytes_sin_capa_salida", 0)

    if pCpuMoE:
      vBytesSalida -= pResultadoGGUF.get("bytes_sin_capa_moe_salida", 0)

    vBytesGPU += vBytesSalida

  for vIndiceCapa in range(vIndicePrimeraCapaGPU, vBlockCount):
    dCapa = pResultadoGGUF["capas"].get(vIndiceCapa, fCrearCapaVacia())
    vBytesCapa = dCapa["total"]

    if pCpuMoE:
      vBytesCapa -= dCapa["moe"]
    elif pNCpuMoE is not None and vIndiceCapa < pNCpuMoE:
      vBytesCapa -= dCapa["moe"]

    vBytesGPU += vBytesCapa

  if vBytesGPU < 0:
    vBytesGPU = 0

  return vCapasGPU, vBytesGPU, vNGLNormalizado


def fCalcularBytesRAMCPU(pResultadoGGUF, pBytesGPU):
  vBytesCPU = pResultadoGGUF["bytes_total"] - pBytesGPU

  if vBytesCPU < 0:
    vBytesCPU = 0

  return vBytesCPU


def fObtenerMemAvailableBytes():
  with open("/proc/meminfo", "r", encoding="utf-8") as vArchivo:
    for vLinea in vArchivo:
      if vLinea.startswith("MemAvailable:"):
        aPartes = vLinea.split()
        return int(aPartes[1]) * 1024

  raise RuntimeError("No se pudo leer MemAvailable desde /proc/meminfo")


def fObtenerMemTotalBytes():
  try:
    with open("/proc/meminfo", "r", encoding="utf-8") as vArchivo:
      for vLinea in vArchivo:
        if vLinea.startswith("MemTotal:"):
          aPartes = vLinea.split()
          return int(aPartes[1]) * 1024
  except OSError:
    return None

  return None


def fParsearListaEnteros(pTexto):
  aResultado = []

  if pTexto is None:
    return aResultado

  for vParte in str(pTexto).split(","):
    vParte = vParte.strip()

    if vParte == "":
      continue

    aResultado.append(int(vParte))

  return aResultado


def fParsearTensorSplit(pTexto, pCantidad):
  if pTexto is None or str(pTexto).strip() == "":
    return None

  aValores = []

  for vParte in str(pTexto).split(","):
    vParte = vParte.strip()

    if vParte == "":
      continue

    vValor = float(vParte)

    if not math.isfinite(vValor) or vValor < 0:
      raise ValueError("Las proporciones de --tensor-split deben ser números finitos no negativos")

    aValores.append(vValor)

  if len(aValores) == 0:
    return None

  if len(aValores) != pCantidad:
    raise ValueError("--tensor-split debe contener exactamente una proporción por GPU")

  vTotal = sum(aValores)

  if vTotal <= 0:
    return None

  return [vValor / vTotal for vValor in aValores]


def fEjecutar(pComando, pTimeout=10):
  try:
    return subprocess.run(
      pComando,
      stdout=subprocess.PIPE,
      stderr=subprocess.PIPE,
      text=True,
      timeout=pTimeout
    )
  except Exception:
    return None


def fParsearLineaMemoriaAMD(pTexto, pClave):
  vRegex = r"^\s*" + re.escape(pClave) + r":\s+([0-9]+)\s+MB\s*$"

  for vLinea in pTexto.splitlines():
    vMatch = re.search(vRegex, vLinea)

    if vMatch:
      return int(vMatch.group(1)) * 1024 * 1024

  return None


def fObtenerMemoriaAMD(pGpuIndex):
  if shutil.which("amd-smi") is None:
    return None

  aComando = [
    "amd-smi",
    "metric",
    "--gpu",
    str(pGpuIndex)
  ]

  vProceso = fEjecutar(aComando)

  if vProceso is None or vProceso.returncode != 0:
    return None

  vTexto = vProceso.stdout

  return {
    "backend": "AMD",
    "index": pGpuIndex,
    "total_vram": fParsearLineaMemoriaAMD(vTexto, "TOTAL_VRAM"),
    "used_vram": fParsearLineaMemoriaAMD(vTexto, "USED_VRAM"),
    "free_vram": fParsearLineaMemoriaAMD(vTexto, "FREE_VRAM"),
    "total_visible_vram": fParsearLineaMemoriaAMD(vTexto, "TOTAL_VISIBLE_VRAM"),
    "used_visible_vram": fParsearLineaMemoriaAMD(vTexto, "USED_VISIBLE_VRAM"),
    "free_visible_vram": fParsearLineaMemoriaAMD(vTexto, "FREE_VISIBLE_VRAM"),
    "total_gtt": fParsearLineaMemoriaAMD(vTexto, "TOTAL_GTT"),
    "used_gtt": fParsearLineaMemoriaAMD(vTexto, "USED_GTT"),
    "free_gtt": fParsearLineaMemoriaAMD(vTexto, "FREE_GTT")
  }


def fObtenerMemoriaNVIDIA(pGpuIndex):
  if shutil.which("nvidia-smi") is None:
    return None

  aComando = [
    "nvidia-smi",
    "--query-gpu=memory.total,memory.used,memory.free,name",
    "--format=csv,noheader,nounits",
    "-i",
    str(pGpuIndex)
  ]

  vProceso = fEjecutar(aComando)

  if vProceso is None or vProceso.returncode != 0:
    return None

  vLinea = vProceso.stdout.strip().splitlines()[0] if vProceso.stdout.strip() else ""
  aPartes = [vParte.strip() for vParte in vLinea.split(",")]

  if len(aPartes) < 3:
    return None

  vNombre = "NVIDIA"

  if len(aPartes) >= 4:
    vNombre = ",".join(aPartes[3:]).strip()

  return {
    "backend": "NVIDIA",
    "index": pGpuIndex,
    "name": vNombre,
    "total_vram": int(aPartes[0]) * 1024 * 1024,
    "used_vram": int(aPartes[1]) * 1024 * 1024,
    "free_vram": int(aPartes[2]) * 1024 * 1024
  }


def fDetectarGPUIntegradaVulkan(pGpuIndex=None):
  if shutil.which("vulkaninfo") is None:
    return None

  vProceso = fEjecutar(["vulkaninfo", "--summary"], 10)

  if vProceso is None or vProceso.returncode != 0:
    return None

  vTexto = vProceso.stdout or ""

  if pGpuIndex is not None:
    vPatronGPU = r"(?:^|\n)\s*GPU" + str(pGpuIndex) + r"\s*:(.*?)(?=\n\s*GPU[0-9]+\s*:|\Z)"
    vCoincidenciaGPU = re.search(vPatronGPU, vTexto, re.DOTALL)

    if vCoincidenciaGPU is not None:
      vSeccionGPU = vCoincidenciaGPU.group(1)

      if "PHYSICAL_DEVICE_TYPE_INTEGRATED_GPU" in vSeccionGPU:
        return True

      if "PHYSICAL_DEVICE_TYPE_DISCRETE_GPU" in vSeccionGPU:
        return False

  vTieneIntegrada = "PHYSICAL_DEVICE_TYPE_INTEGRATED_GPU" in vTexto
  vTieneDiscreta = "PHYSICAL_DEVICE_TYPE_DISCRETE_GPU" in vTexto

  if vTieneIntegrada and not vTieneDiscreta:
    return True

  if vTieneDiscreta and not vTieneIntegrada:
    return False

  return None


def fResolverUsoGTT(pModoGTT, pGpuIndex=None):
  if pModoGTT == "on":
    return True

  if pModoGTT == "off":
    return False

  vEsIntegrada = fDetectarGPUIntegradaVulkan(pGpuIndex)

  if vEsIntegrada is None:
    return False

  return vEsIntegrada


def fSeleccionarMemoriaAcelerador(pMemoria, pUsarGTT):
  if pMemoria is None:
    return None, "no disponible"

  if pMemoria.get("backend") == "AMD":
    vTotalGTT = pMemoria.get("total_gtt")
    vFreeGTT = pMemoria.get("free_gtt")
    vTotalVisibleVRAM = pMemoria.get("total_visible_vram")
    vFreeVisibleVRAM = pMemoria.get("free_visible_vram")

    # En una APU la VRAM de BIOS y la GTT son la misma RAM física; Vulkan puede reservar en ambas
    if pUsarGTT and vFreeVisibleVRAM is not None and vFreeGTT is not None:
      return vFreeVisibleVRAM + vFreeGTT, "FREE_VISIBLE_VRAM+FREE_GTT"

    if vTotalGTT is not None and vTotalVisibleVRAM is not None:
      if vTotalGTT > vTotalVisibleVRAM * 4:
        return vFreeGTT, "FREE_GTT"

    if vFreeVisibleVRAM is not None:
      return vFreeVisibleVRAM, "FREE_VISIBLE_VRAM"

    if vFreeGTT is not None:
      return vFreeGTT, "FREE_GTT"

    return None, "no disponible"

  if pMemoria.get("backend") == "NVIDIA":
    return pMemoria.get("free_vram"), "FREE_VRAM"

  return None, "no disponible"


def fNombreMemoriaLegible(pNombreMemoria):
  dNombres = {
    "FREE_GTT": "RAM de sistema mapeada para la GPU",
    "FREE_VISIBLE_VRAM": "VRAM visible",
    "FREE_VISIBLE_VRAM+FREE_GTT": "VRAM visible + GTT (APU)",
    "FREE_VRAM": "VRAM",
    "no disponible": "no disponible"
  }

  return dNombres.get(pNombreMemoria, pNombreMemoria)


def fObtenerAceleradores(pBackend, pGpuIndexes, pModoGTT):
  ldAceleradores = []

  for vGpuIndex in pGpuIndexes:
    dMemoria = None

    if pBackend in ["auto", "nvidia"]:
      dMemoria = fObtenerMemoriaNVIDIA(vGpuIndex)

    if dMemoria is None and pBackend in ["auto", "amd"]:
      dMemoria = fObtenerMemoriaAMD(vGpuIndex)

    vUsarGTT = fResolverUsoGTT(pModoGTT, vGpuIndex)
    vLibre, vNombreMemoria = fSeleccionarMemoriaAcelerador(dMemoria, vUsarGTT)

    ldAceleradores.append({
      "index": vGpuIndex,
      "memoria": dMemoria,
      "libre": vLibre,
      "nombre_memoria": vNombreMemoria,
      "nombre_memoria_legible": fNombreMemoriaLegible(vNombreMemoria),
      "usar_gtt": vUsarGTT,
      "requerido": 0
    })

  return ldAceleradores


def fObtenerHelpLlamaServer(pRutaLlamaServer):
  if not os.path.exists(pRutaLlamaServer):
    return None

  vProceso = fEjecutar([pRutaLlamaServer, "--help"], 10)

  if vProceso is None:
    return None

  return (vProceso.stdout or "") + "\n" + (vProceso.stderr or "")


def fObtenerFlagSoportado(pHelp, pFlags):
  if pHelp is None:
    return pFlags[0]

  for vFlag in pFlags:
    vPatron = r"(?<![A-Za-z0-9_-])" + re.escape(vFlag) + r"(?=$|[\s,=<\[\]{}])"

    if re.search(vPatron, pHelp):
      return vFlag

  return None


def fFlagSoportado(pHelp, pFlags):
  return fObtenerFlagSoportado(pHelp, pFlags) is not None



def fAgregarOpcion(pComando, pHelp, pFlags, pValores, pAvisos):
  vFlagSoportado = fObtenerFlagSoportado(pHelp, pFlags)

  if vFlagSoportado is not None:
    pComando.append(vFlagSoportado)

    for vValor in pValores:
      pComando.append(str(vValor))
  else:
    pAvisos.append("Flag no soportado por este llama-server: " + "/".join(pFlags))


def fAgregarBooleano(pComando, pHelp, pFlags, pAvisos):
  vFlagSoportado = fObtenerFlagSoportado(pHelp, pFlags)

  if vFlagSoportado is not None:
    pComando.append(vFlagSoportado)
  else:
    pAvisos.append("Flag no soportado por este llama-server: " + "/".join(pFlags))


def fTerminalSoportaColor():
  if not sys.stdout.isatty():
    return False

  if os.environ.get("NO_COLOR"):
    return False

  vTerm = os.environ.get("TERM", "")

  if vTerm == "dumb":
    return False

  return True


def fColor(pTexto, pColor, pUsarColor):
  if not pUsarColor:
    return pTexto

  dColores = {
    "rojo": "\033[31m",
    "verde": "\033[32m",
    "amarillo": "\033[33m",
    "azul": "\033[34m",
    "magenta": "\033[35m",
    "cyan": "\033[36m",
    "gris": "\033[90m",
    "negrita": "\033[1m",
    "reset": "\033[0m"
  }

  return dColores.get(pColor, "") + pTexto + dColores["reset"]


def fFondo(pTexto, pColor, pUsarColor):
  if not pUsarColor:
    return pTexto

  dColores = {
    "rojo": "\033[48;5;196m",
    "verde": "\033[42m",
    "blanco": "\033[48;5;231m",
    "gris": "\033[48;5;245m",
    "azulclaro": "\033[48;5;117m",
    "naranja": "\033[48;5;208m",
    "verdeclaro": "\033[48;5;114m",
    "reset": "\033[0m"
  }

  return dColores.get(pColor, "") + pTexto + dColores["reset"]


def fFormatoGiB(pBytes):
  if pBytes is None:
    return "N/A"

  return "{:.3f} GiB".format(fBytesAGiB(pBytes))


def fFormatoMiB(pBytes):
  if pBytes is None:
    return "N/A"

  return "{:.0f} MiB".format(fBytesAMiB(pBytes))


def fFormatoPorcentaje(pUsado, pTotal):
  if pUsado is None or pTotal is None or pTotal == 0:
    return "N/A"

  return "{:.1f}%".format((pUsado / pTotal) * 100)


def fFormatoTokens(pTokens):
  if pTokens is None:
    return "N/A"

  return str(pTokens) + " tokens"


def fAcortarTexto(pTexto, pAncho):
  if len(pTexto) <= pAncho:
    return pTexto

  if pAncho <= 3:
    return pTexto[:pAncho]

  return "..." + pTexto[-(pAncho - 3):]


def fLineaHorizontal(pAncho, pIzquierda, pCentro, pDerecha):
  return pIzquierda + (pCentro * (pAncho - 2)) + pDerecha


def fFila(pClave, pValor, pAncho, pUsarColor, pColorValor=None):
  vAnchoClave = 34
  vAnchoValor = pAncho - vAnchoClave - 7

  vClaveFormateada = fAcortarTexto(str(pClave), vAnchoClave).ljust(vAnchoClave)
  vValorLimpio = fAcortarTexto(str(pValor), vAnchoValor)
  vValorFormateado = vValorLimpio.ljust(vAnchoValor)

  if pColorValor is not None:
    vValorFormateado = fColor(vValorFormateado, pColorValor, pUsarColor)

  return "│ " + vClaveFormateada + " │ " + vValorFormateado + " │"


def fCrearBarra(pUsado, pTotal, pAnchoBarra, pUsarColor):
  if pUsado is None or pTotal is None or pTotal <= 0:
    return "N/A", 3, "N/A"

  vPorcentaje = pUsado / pTotal
  vPorcentajeLimitado = max(0.0, min(vPorcentaje, 1.0))
  vCaracteresRojos = int(round(pAnchoBarra * vPorcentajeLimitado))

  if pUsado > 0 and vCaracteresRojos == 0:
    vCaracteresRojos = 1

  if vCaracteresRojos > pAnchoBarra:
    vCaracteresRojos = pAnchoBarra

  vCaracteresVerdes = pAnchoBarra - vCaracteresRojos
  vTextoPorcentaje = "{:6.1f}%".format(vPorcentaje * 100)

  if pUsarColor:
    vBarra = (
      fFondo(" " * vCaracteresRojos, "rojo", pUsarColor)
      + fFondo(" " * vCaracteresVerdes, "verde", pUsarColor)
    )
  else:
    vBarra = ("█" * vCaracteresRojos) + ("░" * vCaracteresVerdes)

  return vBarra, pAnchoBarra, vTextoPorcentaje


def fFilaBarra(pClave, pUsado, pTotal, pAncho, pUsarColor):
  vAnchoClave = 34
  vAnchoValor = pAncho - vAnchoClave - 7
  vAnchoBarra = 30

  vClaveFormateada = fAcortarTexto(str(pClave), vAnchoClave).ljust(vAnchoClave)
  vBarra, vAnchoVisibleBarra, vTextoPorcentaje = fCrearBarra(pUsado, pTotal, vAnchoBarra, pUsarColor)

  vTextoDerecha = " " + vTextoPorcentaje
  vAnchoVisibleValor = vAnchoVisibleBarra + len(vTextoDerecha)

  if vAnchoVisibleValor > vAnchoValor:
    vAnchoBarra = max(5, vAnchoValor - len(vTextoDerecha))
    vBarra, vAnchoVisibleBarra, vTextoPorcentaje = fCrearBarra(pUsado, pTotal, vAnchoBarra, pUsarColor)
    vTextoDerecha = " " + vTextoPorcentaje
    vAnchoVisibleValor = vAnchoVisibleBarra + len(vTextoDerecha)

  vPadding = " " * max(0, vAnchoValor - vAnchoVisibleValor)
  vValorFormateado = vBarra + vTextoDerecha + vPadding

  return "│ " + vClaveFormateada + " │ " + vValorFormateado + " │"


def fRepartirAnchoBarra(pValores, pAnchoBarra):
  vTotal = sum(pValores)

  if vTotal <= 0:
    return [0 for _ in pValores]

  aExactos = [pAnchoBarra * vValor / vTotal for vValor in pValores]
  aChars = [int(vExacto) for vExacto in aExactos]
  vAsignado = sum(aChars)
  aOrdenResto = sorted(range(len(pValores)), key=lambda pIndice: aExactos[pIndice] - aChars[pIndice], reverse=True)
  vPos = 0

  while vAsignado < pAnchoBarra and len(aOrdenResto) > 0:
    aChars[aOrdenResto[vPos % len(aOrdenResto)]] += 1
    vAsignado += 1
    vPos += 1

  return aChars


cPaleta256 = {
  "rojo": 196,
  "blanco": 231,
  "gris": 245,
  "azulclaro": 117,
  "naranja": 208,
  "verdeclaro": 114
}


def fEscFondo256(pNombre):
  vCodigo = cPaleta256.get(pNombre)

  if vCodigo is None:
    return ""

  return "\033[48;5;" + str(vCodigo) + "m"


def fEscFrente256(pNombre):
  vCodigo = cPaleta256.get(pNombre)

  if vCodigo is None:
    return ""

  return "\033[38;5;" + str(vCodigo) + "m"


def fSubceldasColores(pValores, pColores, pSubceldas):
  vTotal = sum(pValores)

  if vTotal <= 0 or pSubceldas <= 0:
    return []

  aResultado = []
  vAcumulado = 0.0
  vFinAnterior = 0

  for vIndice, vValor in enumerate(pValores):
    vAcumulado += vValor
    vFin = int(round(pSubceldas * vAcumulado / vTotal))

    if vFin > pSubceldas:
      vFin = pSubceldas

    for _ in range(vFinAnterior, vFin):
      aResultado.append(pColores[vIndice])

    vFinAnterior = vFin

  while len(aResultado) < pSubceldas:
    aResultado.append(pColores[-1])

  return aResultado


def fRenderBarraColor(pSubColores, pAnchoBarra):
  aBloques = [" ", "▏", "▎", "▍", "▌", "▋", "▊", "▉"]
  vReset = "\033[0m"
  vBarra = ""

  for vCelda in range(pAnchoBarra):
    aOcho = pSubColores[vCelda * 8:(vCelda + 1) * 8]

    if len(aOcho) == 0:
      vBarra += " "
      continue

    while len(aOcho) < 8:
      aOcho.append(aOcho[-1])

    vColorIzquierda = aOcho[0]
    vOctavos = 1

    while vOctavos < 8 and aOcho[vOctavos] == vColorIzquierda:
      vOctavos += 1

    if vOctavos >= 8:
      vBarra += fEscFondo256(vColorIzquierda) + " " + vReset
    else:
      vColorDerecha = aOcho[vOctavos]
      vBarra += fEscFondo256(vColorDerecha) + fEscFrente256(vColorIzquierda) + aBloques[vOctavos] + vReset

  return vBarra


def fCrearBarraComposicion(pValores, pColoresFondo, pCaracteresMono, pAnchoBarra, pUsarColor):
  if any(vValor is None for vValor in pValores) or sum(pValores) <= 0:
    return "N/A", 3

  if pUsarColor:
    aSubColores = fSubceldasColores(pValores, pColoresFondo, pAnchoBarra * 8)
    return fRenderBarraColor(aSubColores, pAnchoBarra), pAnchoBarra

  aChars = fRepartirAnchoBarra(pValores, pAnchoBarra)
  vBarra = ""

  for vIndice in range(len(aChars)):
    vBarra += pCaracteresMono[vIndice] * aChars[vIndice]

  return vBarra, sum(aChars)


def fFilaLibre(pIzquierda, pAnchoIzquierdaVisible, pDerecha, pAnchoDerechaVisible, pAncho):
  vAnchoClave = 34
  vAnchoValor = pAncho - vAnchoClave - 7
  vPadIzquierda = " " * max(0, vAnchoClave - pAnchoIzquierdaVisible)
  vPadDerecha = " " * max(0, vAnchoValor - pAnchoDerechaVisible)

  return "│ " + pIzquierda + vPadIzquierda + " │ " + pDerecha + vPadDerecha + " │"


def fFilaLeyenda(pColorFondo, pCaracterMono, pEtiqueta, pTextoDerecha, pAncho, pUsarColor):
  if pUsarColor:
    vSwatch = fFondo("  ", pColorFondo, pUsarColor)
  else:
    vSwatch = pCaracterMono * 2

  vIzquierda = "  " + vSwatch + " " + str(pEtiqueta)
  vAnchoIzquierdaVisible = 2 + 2 + 1 + len(str(pEtiqueta))

  return fFilaLibre(vIzquierda, vAnchoIzquierdaVisible, str(pTextoDerecha), len(str(pTextoDerecha)), pAncho)


def fFilaBarraComposicion(pClave, pValores, pColoresFondo, pCaracteresMono, pTextoValor, pAncho, pUsarColor):
  vAnchoClave = 34
  vAnchoValor = pAncho - vAnchoClave - 7
  vAnchoBarra = 40

  vTextoDerecha = " " + str(pTextoValor)

  vBarra, vAnchoVisibleBarra = fCrearBarraComposicion(pValores, pColoresFondo, pCaracteresMono, vAnchoBarra, pUsarColor)
  vAnchoVisibleValor = vAnchoVisibleBarra + len(vTextoDerecha)

  if vAnchoVisibleValor > vAnchoValor:
    vAnchoBarra = max(5, vAnchoValor - len(vTextoDerecha))
    vBarra, vAnchoVisibleBarra = fCrearBarraComposicion(pValores, pColoresFondo, pCaracteresMono, vAnchoBarra, pUsarColor)
    vAnchoVisibleValor = vAnchoVisibleBarra + len(vTextoDerecha)

  vPadding = " " * max(0, vAnchoValor - vAnchoVisibleValor)
  vClaveFormateada = fAcortarTexto(str(pClave), vAnchoClave).ljust(vAnchoClave)

  return "│ " + vClaveFormateada + " │ " + vBarra + vTextoDerecha + vPadding + " │"


def fObtenerComposicionMemoria(pAceleradores, pMemTotalBytes):
  if pMemTotalBytes is None or pMemTotalBytes <= 0:
    return None

  for dAcelerador in pAceleradores:
    dMemoria = dAcelerador["memoria"]

    if dMemoria is None or dMemoria.get("backend") != "AMD":
      continue

    vBytesVRAM = dMemoria.get("total_vram")
    vBytesGTT = dMemoria.get("total_gtt")

    if vBytesVRAM is None or vBytesGTT is None:
      continue

    vBytesGTTAjustado = min(vBytesGTT, pMemTotalBytes)
    vBytesSO = max(0, pMemTotalBytes - vBytesGTTAjustado)
    vUsadoVRAM = min(vBytesVRAM, dMemoria.get("used_vram") or 0)
    vUsadoGTT = min(vBytesGTTAjustado, dMemoria.get("used_gtt") or 0)

    return {
      "index": dAcelerador["index"],
      "vram": vBytesVRAM,
      "gtt": vBytesGTTAjustado,
      "so": vBytesSO,
      "total": vBytesVRAM + pMemTotalBytes,
      "vram_usado": vUsadoVRAM,
      "vram_libre": max(0, vBytesVRAM - vUsadoVRAM),
      "gtt_usado": vUsadoGTT,
      "gtt_libre": max(0, vBytesGTTAjustado - vUsadoGTT)
    }

  return None


def fTitulo(pTexto, pAncho, pUsarColor):
  vTextoTitulo = " " + pTexto + " "
  vLongitudRestante = pAncho - len(vTextoTitulo) - 2

  if vLongitudRestante < 0:
    vTextoTitulo = fAcortarTexto(vTextoTitulo, pAncho - 2)
    vLongitudRestante = 0

  vIzquierda = vLongitudRestante // 2
  vDerecha = vLongitudRestante - vIzquierda

  return "┌" + ("─" * vIzquierda) + fColor(vTextoTitulo, "negrita", pUsarColor) + ("─" * vDerecha) + "┐"


def fSeparador(pAncho):
  return fLineaHorizontal(pAncho, "├", "─", "┤")


def fPie(pAncho):
  return fLineaHorizontal(pAncho, "└", "─", "┘")


def fEstado(pCondicion):
  if pCondicion:
    return "CABE"

  return "NO CABE"


def fCalcularPesosModelo(pResultadoGGUF, pNgl, pCpuMoE, pNCpuMoE):
  vCapasGPU, vBytesGPU, vNGLNormalizado = fCalcularBytesGPU(pResultadoGGUF, pNgl, pCpuMoE, pNCpuMoE)
  vBytesCPU = fCalcularBytesRAMCPU(pResultadoGGUF, vBytesGPU)

  return {
    "capas_gpu": vCapasGPU,
    "ngl_normalizado": vNGLNormalizado,
    "bytes_gpu": vBytesGPU,
    "bytes_cpu": vBytesCPU
  }


def fCalcularDistribucionKV(pResultadoGGUF, pResultadoKV, pPesosModelo, pKVOffload):
  vBytesTotal = pResultadoKV.get("bytes", 0)
  vBytesFijosTotal = pResultadoKV.get("bytes_fijos", 0)

  if not pKVOffload:
    return {
      "bytes_gpu": 0,
      "bytes_ram": vBytesTotal,
      "bytes_fijos_gpu": 0,
      "bytes_fijos_ram": vBytesFijosTotal
    }

  vBlockCount = fObtenerBlockCount(pResultadoGGUF)
  vCapasGPU = max(0, min(vBlockCount, pPesosModelo.get("capas_gpu", 0)))
  vIndicePrimeraCapaGPU = vBlockCount - vCapasGPU
  dBytesPorCapa = pResultadoKV.get("bytes_por_capa", {})
  dBytesFijosPorCapa = pResultadoKV.get("bytes_fijos_por_capa", {})
  vBytesGPU = sum(
    dBytesPorCapa.get(vIndiceCapa, 0)
    for vIndiceCapa in range(vIndicePrimeraCapaGPU, vBlockCount)
  )
  vBytesFijosGPU = sum(
    dBytesFijosPorCapa.get(vIndiceCapa, 0)
    for vIndiceCapa in range(vIndicePrimeraCapaGPU, vBlockCount)
  )

  return {
    "bytes_gpu": vBytesGPU,
    "bytes_ram": max(0, vBytesTotal - vBytesGPU),
    "bytes_fijos_gpu": vBytesFijosGPU,
    "bytes_fijos_ram": max(0, vBytesFijosTotal - vBytesFijosGPU)
  }


def fObtenerProporciones(pAceleradores, pTensorSplit):
  vCantidad = len(pAceleradores)
  aProporciones = fParsearTensorSplit(pTensorSplit, vCantidad)

  if aProporciones is not None:
    return aProporciones

  aLibres = []

  for dAcelerador in pAceleradores:
    if dAcelerador["libre"] is None:
      aLibres.append(0)
    else:
      aLibres.append(dAcelerador["libre"])

  vTotalLibre = sum(aLibres)

  if vTotalLibre > 0:
    return [vLibre / vTotalLibre for vLibre in aLibres]

  return [1.0 / vCantidad for _ in range(vCantidad)]


def fBuscarPosicionMainGPU(pAceleradores, pMainGpu):
  if pMainGpu >= 0 and pMainGpu < len(pAceleradores):
    return pMainGpu

  return 0


def fDistribuirRequerimientoAcelerador(pAceleradores, pBytesModeloGPU, pBytesKVGPU, pSplitMode, pTensorSplit, pMainGpu, pReiniciar=True):
  if len(pAceleradores) == 0:
    return

  if pReiniciar:
    for dAcelerador in pAceleradores:
      dAcelerador["requerido"] = 0

  if len(pAceleradores) == 1:
    pAceleradores[0]["requerido"] += pBytesModeloGPU + pBytesKVGPU
    return

  vModo = str(pSplitMode or "layer")
  vPosicionMain = fBuscarPosicionMainGPU(pAceleradores, pMainGpu)
  aProporciones = fObtenerProporciones(pAceleradores, pTensorSplit)

  if vModo == "none":
    pAceleradores[vPosicionMain]["requerido"] += pBytesModeloGPU + pBytesKVGPU
    return

  if vModo == "row":
    for vIndice, dAcelerador in enumerate(pAceleradores):
      dAcelerador["requerido"] += int(pBytesModeloGPU * aProporciones[vIndice])

    pAceleradores[vPosicionMain]["requerido"] += pBytesKVGPU
    return

  for vIndice, dAcelerador in enumerate(pAceleradores):
    dAcelerador["requerido"] += int((pBytesModeloGPU + pBytesKVGPU) * aProporciones[vIndice])


def fUnirIndicesGPU(pPrimeros, pSegundos):
  aResultado = []

  for vIndice in pPrimeros + pSegundos:
    if vIndice not in aResultado:
      aResultado.append(vIndice)

  return aResultado


def fSeleccionarAceleradores(pAceleradores, pGpuIndexes):
  dPorIndice = {dAcelerador["index"]: dAcelerador for dAcelerador in pAceleradores}
  return [dPorIndice[vIndice] for vIndice in pGpuIndexes if vIndice in dPorIndice]


def fCalcularUsoRAMCompartidaAcelerador(pAceleradores):
  vBytesRAMCompartida = 0

  for dAcelerador in pAceleradores:
    dMemoria = dAcelerador.get("memoria")

    if dMemoria is None or dMemoria.get("backend") != "AMD":
      continue

    if dAcelerador.get("nombre_memoria") == "FREE_VISIBLE_VRAM+FREE_GTT":
      vVRAMVisibleLibre = dMemoria.get("free_visible_vram") or 0
      vBytesRAMCompartida += max(0, dAcelerador["requerido"] - vVRAMVisibleLibre)
    elif dAcelerador.get("nombre_memoria") == "FREE_GTT":
      vBytesRAMCompartida += dAcelerador["requerido"]

  return vBytesRAMCompartida


def fMostrarResumenBonito(
  pArgumentos,
  pResultadoGGUF,
  pPesosModelo,
  pKVModelo,
  pResultadoDraft,
  pPesosDraft,
  pKVDraft,
  pMemAvailable,
  pMemTotal,
  pAceleradores,
  pOverheadBytes,
  pReservaMinimaBytes,
  pRequeridoAceleradorTotal,
  pRequeridoAceleradorConReservaTotal,
  pRequeridoRAM,
  pRequeridoRAMConReserva,
  pCabeAcelerador,
  pCabeRAM,
  pAvisos,
  pHelpDisponible
):
  vUsarColor = fTerminalSoportaColor()
  vAncho = 94
  vNombreModelo = os.path.basename(pArgumentos.modelo)
  vBlockCount = fObtenerBlockCount(pResultadoGGUF)
  vContextoNativo = fObtenerContextoNativo(pResultadoGGUF)

  print(fTitulo("PRECOMPROBACIÓN GGUF / LLAMA-SERVER MODERNO", vAncho, vUsarColor))
  print(fFila("Modelo", vNombreModelo, vAncho, vUsarColor, "cyan"))
  print(fFila("Ruta", pArgumentos.modelo, vAncho, vUsarColor))
  print(fFila("Arquitectura", fObtenerArquitectura(pResultadoGGUF), vAncho, vUsarColor))
  print(fFila("Metadatos GGUF", "v" + str(pResultadoGGUF["version"]), vAncho, vUsarColor))
  print(fFila("Fragmentos GGUF", str(pResultadoGGUF.get("split_count", 1)), vAncho, vUsarColor))
  print(fSeparador(vAncho))
  print(fFila("Capas detectadas", str(vBlockCount), vAncho, vUsarColor))
  print(fFila("Capas solicitadas para GPU", str(pPesosModelo["capas_gpu"]), vAncho, vUsarColor, "cyan"))
  print(fFila("Contexto solicitado", fFormatoTokens(pArgumentos.ctx_size), vAncho, vUsarColor))
  print(fFila("Contexto nativo en metadatos", fFormatoTokens(vContextoNativo), vAncho, vUsarColor))

  if hasattr(pArgumentos, "ctx_size_origen"):
    print(fFila("Origen contexto", pArgumentos.ctx_size_origen, vAncho, vUsarColor, "cyan"))
  print(fFila("Paralelismo", str(pArgumentos.parallel), vAncho, vUsarColor))
  print(fFila("Microbatch físico", str(pArgumentos.ubatch_size), vAncho, vUsarColor))
  print(fFila("SWA a contexto completo", str(pArgumentos.swa_full), vAncho, vUsarColor))
  print(fFila("Caché KV K/V", str(pArgumentos.cache_type_k) + " / " + str(pArgumentos.cache_type_v), vAncho, vUsarColor))

  if hasattr(pArgumentos, "cache_type_origen"):
    print(fFila("Origen tipo KV", pArgumentos.cache_type_origen, vAncho, vUsarColor, "cyan"))
  print(fFila("KV offload", str(pArgumentos.kv_offload), vAncho, vUsarColor))
  print(fFila("Split mode", str(pArgumentos.split_mode), vAncho, vUsarColor))
  print(fFila("Tensor split", str(pArgumentos.tensor_split), vAncho, vUsarColor))
  print(fFila("Fit llama.cpp", str(pArgumentos.fit), vAncho, vUsarColor))
  print(fFila("Help llama-server detectado", str(pHelpDisponible), vAncho, vUsarColor))
  print(fSeparador(vAncho))
  print(fFila("Pesos totales", fFormatoGiB(pResultadoGGUF["bytes_total"]), vAncho, vUsarColor))
  print(fFila("Pesos MoE detectados", fFormatoGiB(pResultadoGGUF["bytes_moe"]), vAncho, vUsarColor, "amarillo"))
  print(fFila("Pesos no asociados a capas", fFormatoGiB(pResultadoGGUF["bytes_sin_capa"]), vAncho, vUsarColor))
  print(fFila("Pesos estimados GPU", fFormatoGiB(pPesosModelo["bytes_gpu"]), vAncho, vUsarColor, "cyan"))
  print(fFila("Pesos estimados CPU/RAM", fFormatoGiB(pPesosModelo["bytes_cpu"]), vAncho, vUsarColor))
  print(fFila("KV/estado estimados", fFormatoGiB(pKVModelo["bytes"]), vAncho, vUsarColor, "cyan" if pKVModelo["estimado"] else "amarillo"))

  if pKVModelo.get("recurrente", {}).get("detectada") and pKVModelo["recurrente"].get("estimada"):
    dInfoRecurrente = pKVModelo["recurrente"]
    vTextoRecurrente = fFormatoGiB(dInfoRecurrente["bytes"]) + " en " + str(dInfoRecurrente["capas_recurrentes"]) + " capas"
    print(fFila("Estado recurrente estimado", vTextoRecurrente, vAncho, vUsarColor, "cyan"))

  if pKVModelo.get("swa") is not None:
    dInfoSWA = pKVModelo["swa"]
    vTextoSWA = str(dInfoSWA["capas_swa"]) + " capas SWA + " + str(dInfoSWA["capas_globales"]) + " globales"

    if dInfoSWA.get("swa_full"):
      vTextoSWA += " (SWA completa)"

    print(fFila("Atención SWA detectada", vTextoSWA, vAncho, vUsarColor, "cyan"))
    print(fFila("Ventana SWA", fFormatoTokens(dInfoSWA["ventana"]), vAncho, vUsarColor))

  if not pKVModelo["estimado"]:
    print(fFila("Motivo de KV/estado", pKVModelo["motivo"], vAncho, vUsarColor, "amarillo"))

  if pResultadoDraft is not None:
    print(fSeparador(vAncho))
    print(fFila("Modelo draft", os.path.basename(pResultadoDraft["ruta"]), vAncho, vUsarColor, "cyan"))
    print(fFila("Arquitectura draft", fObtenerArquitectura(pResultadoDraft), vAncho, vUsarColor))
    print(fFila("Capas GPU del draft", str(pPesosDraft["capas_gpu"]), vAncho, vUsarColor))
    print(fFila("Pesos GPU del draft", fFormatoGiB(pPesosDraft["bytes_gpu"]), vAncho, vUsarColor))
    print(fFila("Pesos CPU/RAM del draft", fFormatoGiB(pPesosDraft["bytes_cpu"]), vAncho, vUsarColor))
    print(fFila("Caché KV K/V del draft", str(pArgumentos.cache_type_k_draft) + " / " + str(pArgumentos.cache_type_v_draft), vAncho, vUsarColor))
    print(fFila("KV/estado draft estimados", fFormatoGiB(pKVDraft["bytes"]), vAncho, vUsarColor, "cyan" if pKVDraft["estimado"] else "amarillo"))

    if pKVDraft.get("recurrente", {}).get("detectada") and pKVDraft["recurrente"].get("estimada"):
      dInfoRecurrenteDraft = pKVDraft["recurrente"]
      vTextoRecurrenteDraft = fFormatoGiB(dInfoRecurrenteDraft["bytes"]) + " en " + str(dInfoRecurrenteDraft["capas_recurrentes"]) + " capas"
      print(fFila("Estado recurrente draft", vTextoRecurrenteDraft, vAncho, vUsarColor, "cyan"))

    if not pKVDraft["estimado"]:
      print(fFila("Motivo de KV/estado draft", pKVDraft["motivo"], vAncho, vUsarColor, "amarillo"))

  print(fSeparador(vAncho))
  print(fFila("Overhead estimado acelerador", fFormatoGiB(pOverheadBytes), vAncho, vUsarColor, "amarillo"))
  print(fFila("Reserva mínima por acelerador", fFormatoGiB(pReservaMinimaBytes), vAncho, vUsarColor, "amarillo"))
  print(fFila("Requerido acelerador", fFormatoGiB(pRequeridoAceleradorTotal), vAncho, vUsarColor))
  print(fFila("Requerido acelerador con reserva", fFormatoGiB(pRequeridoAceleradorConReservaTotal), vAncho, vUsarColor, "amarillo"))
  vRequeridoGTTCompartida = max(0, pRequeridoRAMConReserva - pRequeridoRAM - pReservaMinimaBytes)
  print(fFila("GTT compartida requerida", fFormatoGiB(vRequeridoGTTCompartida), vAncho, vUsarColor))
  print(fFila("Requerido RAM con reserva", fFormatoGiB(pRequeridoRAMConReserva), vAncho, vUsarColor))
  print(fSeparador(vAncho))

  dComposicion = fObtenerComposicionMemoria(pAceleradores, pMemTotal)

  if dComposicion is not None:
    vModeloVRAM = min(pRequeridoAceleradorTotal, dComposicion["vram_libre"])
    vRestoGPU = max(0, pRequeridoAceleradorTotal - vModeloVRAM)
    vModeloGTT = min(vRestoGPU, dComposicion["gtt"])
    vModeloSO = min(pRequeridoRAM, dComposicion["so"])
    vBlancoVRAM = max(0, dComposicion["vram_libre"] - vModeloVRAM)
    vBlancoGTT = max(0, dComposicion["gtt"] - vModeloGTT)
    vBlancoSO = max(0, dComposicion["so"] - vModeloSO)
    vRequeridoTotalModelo = pRequeridoAceleradorTotal + pRequeridoRAM

    aValoresBarra = [
      dComposicion["vram_usado"], vModeloVRAM, vBlancoVRAM,
      vModeloGTT, vBlancoGTT,
      vModeloSO, vBlancoSO
    ]
    aColoresComposicion = ["azulclaro", "azulclaro", "azulclaro", "naranja", "naranja", "verdeclaro", "verdeclaro"]
    aMonoComposicion = ["█", "█", "█", "▒", "▒", "░", "░"]
    aColoresModelo = ["gris", "rojo", "blanco", "rojo", "blanco", "rojo", "blanco"]
    aMonoModelo = ["▓", "█", "░", "█", "░", "█", "░"]
    vDesgloseModelo = "{:.2f} GPU + {:.2f} CPU GiB".format(fBytesAGiB(vModeloVRAM + vModeloGTT), fBytesAGiB(vModeloSO))

    print(fFilaBarraComposicion("Memoria del sistema (APU)", aValoresBarra, aColoresComposicion, aMonoComposicion, fFormatoGiB(dComposicion["total"]), vAncho, vUsarColor))
    print(fFilaLeyenda("azulclaro", "█", "VRAM asignada en BIOS", fFormatoGiB(dComposicion["vram"]), vAncho, vUsarColor))
    print(fFilaLeyenda("naranja", "▒", "GTT visible a Vulkan", fFormatoGiB(dComposicion["gtt"]), vAncho, vUsarColor))
    print(fFilaLeyenda("verdeclaro", "░", "RAM del sistema operativo", fFormatoGiB(dComposicion["so"]), vAncho, vUsarColor))
    print(fSeparador(vAncho))
    print(fFilaBarraComposicion("Ocupado por el modelo", aValoresBarra, aColoresModelo, aMonoModelo, fFormatoGiB(vRequeridoTotalModelo), vAncho, vUsarColor))
    print(fFilaLeyenda("gris", "▓", "VRAM en uso (escritorio)", fFormatoGiB(dComposicion["vram_usado"]), vAncho, vUsarColor))
    print(fFilaLeyenda("rojo", "█", "Lo que ocupa el modelo", vDesgloseModelo, vAncho, vUsarColor))

    for dAcelerador in pAceleradores:
      vNombre = "GPU " + str(dAcelerador["index"])
      dMemoria = dAcelerador["memoria"]

      if dMemoria is None:
        continue

      if dMemoria.get("backend") == "AMD":
        vNombre += " AMD"
        print(fFila(vNombre + " VRAM visible libre", fFormatoGiB(dMemoria.get("free_visible_vram")), vAncho, vUsarColor))
        print(fFila(vNombre + " GTT libre", fFormatoGiB(dMemoria.get("free_gtt")), vAncho, vUsarColor))
        print(fFila(vNombre + " memoria contada", dAcelerador["nombre_memoria_legible"] + " = " + fFormatoGiB(dAcelerador["libre"]), vAncho, vUsarColor, "verde"))
      elif dMemoria.get("backend") == "NVIDIA":
        vNombre += " NVIDIA"
        print(fFila(vNombre + " VRAM libre", fFormatoGiB(dMemoria.get("free_vram")), vAncho, vUsarColor, "verde"))
        print(fFila(vNombre + " total VRAM", fFormatoGiB(dMemoria.get("total_vram")), vAncho, vUsarColor))

    print(fFila("RAM disponible del sistema", fFormatoGiB(pMemAvailable), vAncho, vUsarColor, "verde"))
  else:
    for dAcelerador in pAceleradores:
      vNombre = "GPU " + str(dAcelerador["index"])
      dMemoria = dAcelerador["memoria"]

      if dMemoria is not None and dMemoria.get("backend") == "NVIDIA":
        vNombre += " NVIDIA"
      elif dMemoria is not None and dMemoria.get("backend") == "AMD":
        vNombre += " AMD"

      print(fFila(vNombre + " memoria usada", dAcelerador["nombre_memoria_legible"], vAncho, vUsarColor, "cyan"))
      print(fFilaBarra(vNombre + " requerido", dAcelerador["requerido"] + pReservaMinimaBytes, dAcelerador["libre"], vAncho, vUsarColor))
      print(fFila(vNombre + " libre", fFormatoGiB(dAcelerador["libre"]), vAncho, vUsarColor, "verde"))

      if dMemoria is not None:
        if dMemoria.get("backend") == "NVIDIA":
          print(fFila(vNombre + " total VRAM", fFormatoGiB(dMemoria.get("total_vram")), vAncho, vUsarColor))
        elif dMemoria.get("backend") == "AMD":
          print(fFila(vNombre + " VRAM visible libre", fFormatoGiB(dMemoria.get("free_visible_vram")), vAncho, vUsarColor))
          print(fFila(vNombre + " RAM sistema mapeada GPU", fFormatoGiB(dMemoria.get("free_gtt")), vAncho, vUsarColor))

    print(fFilaBarra("Uso modelo en RAM", pRequeridoRAMConReserva, pMemAvailable, vAncho, vUsarColor))
    print(fFila("RAM disponible del sistema", fFormatoGiB(pMemAvailable), vAncho, vUsarColor, "verde"))

  print(fSeparador(vAncho))

  vColorEstadoAcelerador = "verde" if pCabeAcelerador else "rojo"
  vColorEstadoRAM = "verde" if pCabeRAM else "rojo"

  print(fFila("Estado acelerador", fEstado(pCabeAcelerador), vAncho, vUsarColor, vColorEstadoAcelerador))
  print(fFila("Estado RAM sistema", fEstado(pCabeRAM), vAncho, vUsarColor, vColorEstadoRAM))

  vMargenRAM = pMemAvailable - pRequeridoRAMConReserva
  vColorMargenRAM = "verde" if vMargenRAM >= 0 else "rojo"
  print(fFila("Margen RAM", fFormatoGiB(vMargenRAM), vAncho, vUsarColor, vColorMargenRAM))

  for dAcelerador in pAceleradores:
    if dAcelerador["libre"] is not None:
      vMargen = dAcelerador["libre"] - dAcelerador["requerido"] - pReservaMinimaBytes
      vColorMargen = "verde" if vMargen >= 0 else "rojo"
      print(fFila("Margen GPU " + str(dAcelerador["index"]), fFormatoGiB(vMargen), vAncho, vUsarColor, vColorMargen))

  if len(pAvisos) > 0:
    print(fSeparador(vAncho))

    for vAviso in pAvisos:
      print(fFila("Aviso", vAviso, vAncho, vUsarColor, "amarillo"))

  print(fPie(vAncho))


def fCrearComandoLlamaServer(pArgumentos, pPesosModelo, pPesosDraft, pHelp):
  aComando = [
    pArgumentos.llama_server,
    "--host",
    pArgumentos.host,
    "--port",
    str(pArgumentos.port)
  ]

  aAvisos = []

  if pArgumentos.device:
    fAgregarOpcion(aComando, pHelp, ["--device", "-dev"], [pArgumentos.device], aAvisos)

  if str(pArgumentos.ngl).lower() != "auto":
    if str(pArgumentos.ngl).lower() == "all":
      vNGLComando = "all"
    else:
      vNGLComando = pPesosModelo["ngl_normalizado"]

    fAgregarOpcion(aComando, pHelp, ["--n-gpu-layers", "--gpu-layers", "-ngl"], [vNGLComando], aAvisos)

  if pArgumentos.ctx_size is not None:
    fAgregarOpcion(aComando, pHelp, ["--ctx-size", "-c"], [pArgumentos.ctx_size], aAvisos)

  if pArgumentos.parallel is not None:
    fAgregarOpcion(aComando, pHelp, ["--parallel", "-np"], [pArgumentos.parallel], aAvisos)

  if pArgumentos.ubatch_size is not None:
    fAgregarOpcion(aComando, pHelp, ["--ubatch-size", "-ub"], [pArgumentos.ubatch_size], aAvisos)

  if pArgumentos.swa_full:
    fAgregarBooleano(aComando, pHelp, ["--swa-full"], aAvisos)

  if pArgumentos.cache_ram is not None:
    fAgregarOpcion(aComando, pHelp, ["--cache-ram", "-cram"], [pArgumentos.cache_ram], aAvisos)

  if pArgumentos.cache_type_k is not None:
    fAgregarOpcion(aComando, pHelp, ["--cache-type-k", "-ctk"], [pArgumentos.cache_type_k], aAvisos)

  if pArgumentos.cache_type_v is not None:
    fAgregarOpcion(aComando, pHelp, ["--cache-type-v", "-ctv"], [pArgumentos.cache_type_v], aAvisos)

  if pArgumentos.flash_attn is not None:
    fAgregarOpcion(aComando, pHelp, ["--flash-attn", "-fa"], [pArgumentos.flash_attn], aAvisos)

  if pArgumentos.kv_offload == "on":
    fAgregarBooleano(aComando, pHelp, ["--kv-offload", "-kvo"], aAvisos)
  elif pArgumentos.kv_offload == "off":
    fAgregarBooleano(aComando, pHelp, ["--no-kv-offload", "-nkvo"], aAvisos)

  if pArgumentos.split_mode is not None:
    fAgregarOpcion(aComando, pHelp, ["--split-mode", "-sm"], [pArgumentos.split_mode], aAvisos)

  if pArgumentos.tensor_split is not None:
    fAgregarOpcion(aComando, pHelp, ["--tensor-split", "-ts"], [pArgumentos.tensor_split], aAvisos)

  if pArgumentos.main_gpu is not None:
    fAgregarOpcion(aComando, pHelp, ["--main-gpu", "-mg"], [pArgumentos.main_gpu], aAvisos)

  if pArgumentos.fit is not None:
    fAgregarOpcion(aComando, pHelp, ["--fit", "-fit"], [pArgumentos.fit], aAvisos)

  if pArgumentos.fit_target is not None:
    fAgregarOpcion(aComando, pHelp, ["--fit-target", "-fitt"], [pArgumentos.fit_target], aAvisos)

  if pArgumentos.fit_ctx is not None:
    fAgregarOpcion(aComando, pHelp, ["--fit-ctx", "-fitc"], [pArgumentos.fit_ctx], aAvisos)

  if pArgumentos.cpu_moe:
    fAgregarBooleano(aComando, pHelp, ["--cpu-moe", "-cmoe"], aAvisos)

  if pArgumentos.n_cpu_moe is not None:
    fAgregarOpcion(aComando, pHelp, ["--n-cpu-moe", "-ncmoe"], [pArgumentos.n_cpu_moe], aAvisos)

  if pArgumentos.no_warmup:
    fAgregarBooleano(aComando, pHelp, ["--no-warmup"], aAvisos)

  if pArgumentos.model_draft is not None:
    fAgregarOpcion(aComando, pHelp, ["--model-draft", "--spec-draft-model", "-md"], [pArgumentos.model_draft], aAvisos)

    if pArgumentos.device_draft:
      fAgregarOpcion(aComando, pHelp, ["--device-draft", "--spec-draft-device", "-devd"], [pArgumentos.device_draft], aAvisos)

    if str(pArgumentos.ngl_draft).lower() != "auto" and pPesosDraft is not None:
      if str(pArgumentos.ngl_draft).lower() == "all":
        vNGLDraftComando = "all"
      else:
        vNGLDraftComando = pPesosDraft["ngl_normalizado"]

      fAgregarOpcion(aComando, pHelp, ["--n-gpu-layers-draft", "--gpu-layers-draft", "--spec-draft-ngl", "-ngld"], [vNGLDraftComando], aAvisos)

    fAgregarOpcion(
      aComando,
      pHelp,
      ["--spec-draft-type-k", "--cache-type-k-draft", "-ctkd"],
      [pArgumentos.cache_type_k_draft],
      aAvisos
    )
    fAgregarOpcion(
      aComando,
      pHelp,
      ["--spec-draft-type-v", "--cache-type-v-draft", "-ctvd"],
      [pArgumentos.cache_type_v_draft],
      aAvisos
    )

    if pArgumentos.cpu_moe_draft:
      fAgregarBooleano(aComando, pHelp, ["--cpu-moe-draft", "--spec-draft-cpu-moe", "-cmoed"], aAvisos)

    if pArgumentos.n_cpu_moe_draft is not None:
      fAgregarOpcion(aComando, pHelp, ["--n-cpu-moe-draft", "--spec-draft-n-cpu-moe", "-ncmoed"], [pArgumentos.n_cpu_moe_draft], aAvisos)

    if pArgumentos.spec_type is not None:
      fAgregarOpcion(aComando, pHelp, ["--spec-type"], [pArgumentos.spec_type], aAvisos)

    if pArgumentos.spec_draft_n_max is not None:
      fAgregarOpcion(aComando, pHelp, ["--spec-draft-n-max"], [pArgumentos.spec_draft_n_max], aAvisos)

  aComando.extend([
    "-m",
    pArgumentos.modelo
  ])

  aComando.extend(pArgumentos.argumentos_extra)

  return aComando, aAvisos


def fCrearParser():
  vParser = argparse.ArgumentParser(
    description="Comprueba si un modelo GGUF cabe antes de lanzar llama-server. Incluye KV/estado recurrente, MoE, modelo draft, NVIDIA, AMD y multi-GPU."
  )

  vParser.add_argument(
    "modelo",
    nargs="?",
    help="Ruta al archivo .gguf"
  )

  vParser.add_argument(
    "--llama-server",
    default="/home/nipegun/IA/LlamaCPP/llama-server",
    help="Ruta al binario llama-server"
  )

  vParser.add_argument(
    "--host",
    default="127.0.0.1"
  )

  vParser.add_argument(
    "--port",
    type=int,
    default=8080
  )

  vParser.add_argument(
    "--device",
    default="Vulkan0",
    help="Dispositivos llama.cpp separados por comas. auto no filtra dispositivos y none fuerza CPU."
  )

  vParser.add_argument(
    "--device-draft",
    default=None,
    help="Dispositivo para el draft model."
  )

  vParser.add_argument(
    "--backend",
    choices=["auto", "nvidia", "amd"],
    default="auto"
  )

  vParser.add_argument(
    "--gpu-index",
    type=int,
    default=None,
    help="Compatibilidad con versión anterior. Equivale a --gpu-indexes N."
  )

  vParser.add_argument(
    "--gpu-indexes",
    default="0",
    help="Lista de GPUs físicas para estimar memoria: 0 o 0,1,2."
  )

  vParser.add_argument(
    "--gpu-indexes-draft",
    default=None,
    help="GPUs físicas usadas por el draft model; por defecto usa --gpu-indexes."
  )

  vParser.add_argument(
    "--gtt",
    choices=["on", "off", "auto"],
    default="auto",
    help="Suma la GTT a la memoria del acelerador en AMD. auto la activa solo si Vulkan reporta GPU integrada (APU)."
  )

  vParser.add_argument(
    "--ngl",
    default="all",
    help="Capas GPU: número, all o auto."
  )

  vParser.add_argument(
    "--ctx-size",
    type=int,
    default=None,
    help="Contexto en tokens. Si no se indica, usa el contexto nativo declarado en el GGUF."
  )

  vParser.add_argument(
    "--parallel",
    type=int,
    default=1
  )

  vParser.add_argument(
    "--ubatch-size",
    type=int,
    default=512,
    help="Microbatch físico de llama.cpp; afecta al búfer de atención SWA."
  )

  vParser.add_argument(
    "--swa-full",
    action="store_true",
    help="Reserva el contexto completo también para las capas SWA."
  )

  vParser.add_argument(
    "--cache-ram",
    type=int,
    default=0,
    help="Caché de prompts de llama-server en MiB. 0 para desactivar."
  )

  vParser.add_argument(
    "--cache-type-k",
    choices=sorted(cTiposKVBytes.keys()) + ["auto"],
    default="auto",
    help="Tipo de la caché K. auto la iguala a la cuantización de los pesos del modelo."
  )

  vParser.add_argument(
    "--cache-type-v",
    choices=sorted(cTiposKVBytes.keys()) + ["auto"],
    default="auto",
    help="Tipo de la caché V. auto la iguala a la cuantización de los pesos del modelo."
  )

  vParser.add_argument(
    "--flash-attn",
    choices=["on", "off", "auto"],
    default="auto",
    help="Uso de atención flash en llama-server."
  )

  vParser.add_argument(
    "--kv-offload",
    choices=["on", "off", "auto"],
    default="on",
    help="Hace que la KV/el estado siga a cada capa en GPU o permanezca en RAM. auto no pasa flag y estima como on."
  )

  vParser.add_argument(
    "--split-mode",
    choices=["none", "layer", "row", "tensor"],
    default="layer",
    help="Reparto multi-GPU. tensor es experimental y exige KV sin cuantizar."
  )

  vParser.add_argument(
    "--tensor-split",
    default=None,
    help="Exactamente una proporción por GPU, por ejemplo 3,1 o 1,1."
  )

  vParser.add_argument(
    "--main-gpu",
    type=int,
    default=0
  )

  vParser.add_argument(
    "--fit",
    choices=["on", "off"],
    default=None
  )

  vParser.add_argument(
    "--fit-target",
    default=None,
    help="Un margen MiB compartido o exactamente uno por GPU para --fit. Ejemplo: 1024 o 1024,2048."
  )

  vParser.add_argument(
    "--fit-ctx",
    type=int,
    default=None
  )

  vParser.add_argument(
    "--cpu-moe",
    action="store_true",
    help="Mantiene todos los pesos MoE detectados en CPU para estimación y comando."
  )

  vParser.add_argument(
    "--n-cpu-moe",
    type=int,
    default=None,
    help="Mantiene los pesos MoE de las primeras N capas en CPU."
  )

  vParser.add_argument(
    "--model-draft",
    default=None,
    help="Modelo draft GGUF para speculative decoding."
  )

  vParser.add_argument(
    "--ngl-draft",
    default="all",
    help="Capas GPU del draft model: número, all o auto."
  )

  vParser.add_argument(
    "--cache-type-k-draft",
    choices=sorted(cTiposKVBytes.keys()),
    default="f16",
    help="Tipo de la caché K del draft model."
  )

  vParser.add_argument(
    "--cache-type-v-draft",
    choices=sorted(cTiposKVBytes.keys()),
    default="f16",
    help="Tipo de la caché V del draft model."
  )

  vParser.add_argument(
    "--cpu-moe-draft",
    action="store_true"
  )

  vParser.add_argument(
    "--n-cpu-moe-draft",
    type=int,
    default=None
  )

  vParser.add_argument(
    "--spec-type",
    default=None
  )

  vParser.add_argument(
    "--spec-draft-n-max",
    type=int,
    default=None
  )

  vParser.add_argument(
    "--overhead-percent",
    type=float,
    default=19.0,
    help="Margen porcentual para búferes, driver, Vulkan/CUDA y temporales."
  )

  vParser.add_argument(
    "--overhead-gib",
    type=float,
    default=0.0,
    help="Margen fijo adicional en GiB."
  )

  vParser.add_argument(
    "--min-free-gib",
    type=float,
    default=0.5,
    help="Memoria mínima que debe quedar libre por GPU y en RAM."
  )

  vParser.add_argument(
    "--no-warmup",
    action="store_true"
  )

  vParser.add_argument(
    "--list-devices",
    action="store_true",
    help="Ejecuta llama-server --list-devices y sale."
  )

  vParser.add_argument(
    "--dry-run",
    action="store_true"
  )

  vParser.add_argument(
    "--force",
    action="store_true"
  )

  vParser.add_argument(
    "--no-validar-flags",
    action="store_true",
    help="No consulta llama-server --help para filtrar flags no soportados."
  )

  return vParser


def fParsearListaDispositivos(pTexto):
  if pTexto is None or str(pTexto).strip() == "":
    return []

  return [vParte.strip() for vParte in str(pTexto).split(",") if vParte.strip() != ""]


def fValidarNGL(pValor, pNombre, pParser):
  if str(pValor).lower() in ["all", "auto"]:
    return

  try:
    vEntero = int(pValor)
  except (TypeError, ValueError):
    pParser.error(pNombre + " debe ser un número no negativo, all o auto")

  if vEntero < 0:
    pParser.error(pNombre + " no puede ser negativo")


def fValidarPassthrough(pArgumentosExtra, pParser):
  if len(pArgumentosExtra) == 0:
    return

  if "--" not in sys.argv[1:]:
    pParser.error("los argumentos desconocidos deben colocarse después de --")

  vOpcionesProhibidas = {
    "--host", "--port", "--reuse-port", "--no-reuse-port",
    "-m", "--model", "-mu", "--model-url", "-hf", "-hfr", "--hf-repo",
    "-hff", "--hf-file", "--models-dir", "--models-preset", "--models-max",
    "--models-autoload", "--no-models-autoload", "-c", "--ctx-size", "-np", "--parallel",
    "-b", "--batch-size", "-ub", "--ubatch-size", "--swa-full",
    "-ctk", "--cache-type-k", "-ctv", "--cache-type-v",
    "-fa", "--flash-attn", "-kvo", "--kv-offload", "-nkvo", "--no-kv-offload",
    "-kvu", "--kv-unified", "--no-kv-unified", "--ctx-checkpoints", "--ctx-checkpoints-interval",
    "-dev", "--device", "-ngl", "--gpu-layers", "--n-gpu-layers",
    "-sm", "--split-mode", "-ts", "--tensor-split", "-mg", "--main-gpu",
    "-fit", "--fit", "-fitt", "--fit-target", "-fitc", "--fit-ctx",
    "-cmoe", "--cpu-moe", "-ncmoe", "--n-cpu-moe",
    "-md", "--model-draft", "--spec-draft-model", "--model-draft-url",
    "--hf-repo-draft", "--hf-file-draft", "-devd", "--device-draft",
    "--spec-draft-device", "-ngld", "--n-gpu-layers-draft", "--gpu-layers-draft",
    "--spec-draft-ngl", "-ctkd", "--cache-type-k-draft", "--spec-draft-type-k",
    "-ctvd", "--cache-type-v-draft", "--spec-draft-type-v",
    "-cram", "--cache-ram", "--mmproj", "--mmproj-url", "--no-mmproj",
    "--model-vocoder", "--model-vocoder-url", "--hf-repo-v", "--hf-file-v",
    "--lora", "--lora-scaled", "--control-vector", "--control-vector-scaled",
    "--override-kv", "--override-tensor", "--rpc", "--mlock", "--mmap",
    "--no-mmap", "--no-host", "--op-offload", "--no-op-offload"
  }

  for vArgumento in pArgumentosExtra:
    vOpcion = str(vArgumento).split("=", 1)[0]

    if vOpcion in vOpcionesProhibidas:
      pParser.error("la opción controlada " + vOpcion + " debe configurarse mediante una opción admitida por esta precomprobación")


def fValidarArgumentos(pArgumentos, pParser, pArgumentosExtra):
  fValidarNGL(pArgumentos.ngl, "--ngl", pParser)
  fValidarNGL(pArgumentos.ngl_draft, "--ngl-draft", pParser)

  if pArgumentos.port < 1 or pArgumentos.port > 65535:
    pParser.error("--port debe estar entre 1 y 65535")

  if str(pArgumentos.host).strip() == "":
    pParser.error("--host no puede estar vacío")

  if pArgumentos.ctx_size is not None and pArgumentos.ctx_size <= 0:
    pParser.error("--ctx-size debe ser mayor que cero")

  if pArgumentos.parallel <= 0:
    pParser.error("--parallel debe ser mayor que cero")

  if pArgumentos.ubatch_size <= 0:
    pParser.error("--ubatch-size debe ser mayor que cero")

  if pArgumentos.cache_ram < 0:
    pParser.error("--cache-ram no puede ser negativo")

  if not math.isfinite(pArgumentos.overhead_percent) or pArgumentos.overhead_percent < 0:
    pParser.error("--overhead-percent debe ser un número finito no negativo")

  if not math.isfinite(pArgumentos.overhead_gib) or pArgumentos.overhead_gib < 0:
    pParser.error("--overhead-gib debe ser un número finito no negativo")

  if not math.isfinite(pArgumentos.min_free_gib) or pArgumentos.min_free_gib < 0:
    pParser.error("--min-free-gib debe ser un número finito no negativo")

  for vNombre, vValor in [
    ("--n-cpu-moe", pArgumentos.n_cpu_moe),
    ("--n-cpu-moe-draft", pArgumentos.n_cpu_moe_draft)
  ]:
    if vValor is not None and vValor < 0:
      pParser.error(vNombre + " no puede ser negativo")

  if pArgumentos.fit_ctx is not None and pArgumentos.fit_ctx <= 0:
    pParser.error("--fit-ctx debe ser mayor que cero")

  if pArgumentos.spec_draft_n_max is not None and pArgumentos.spec_draft_n_max <= 0:
    pParser.error("--spec-draft-n-max debe ser mayor que cero")

  try:
    aGpuIndexes = fParsearListaEnteros(pArgumentos.gpu_indexes)
  except ValueError:
    pParser.error("--gpu-indexes debe contener enteros separados por comas")

  if len(aGpuIndexes) == 0:
    pParser.error("--gpu-indexes no puede estar vacío")

  if any(vIndice < 0 for vIndice in aGpuIndexes):
    pParser.error("--gpu-indexes no puede contener índices negativos")

  if len(set(aGpuIndexes)) != len(aGpuIndexes):
    pParser.error("--gpu-indexes no puede repetir una GPU")

  if pArgumentos.gpu_indexes_draft is None:
    pArgumentos.gpu_indexes_draft = pArgumentos.gpu_indexes

  try:
    aGpuIndexesDraft = fParsearListaEnteros(pArgumentos.gpu_indexes_draft)
  except ValueError:
    pParser.error("--gpu-indexes-draft debe contener enteros separados por comas")

  if len(aGpuIndexesDraft) == 0:
    pParser.error("--gpu-indexes-draft no puede estar vacío")

  if any(vIndice < 0 for vIndice in aGpuIndexesDraft):
    pParser.error("--gpu-indexes-draft no puede contener índices negativos")

  if len(set(aGpuIndexesDraft)) != len(aGpuIndexesDraft):
    pParser.error("--gpu-indexes-draft no puede repetir una GPU")

  if pArgumentos.device is not None and str(pArgumentos.device).lower() not in ["none"]:
    aDispositivos = fParsearListaDispositivos(pArgumentos.device)

    if len(aDispositivos) != len(aGpuIndexes):
      pParser.error("la cantidad de --device debe coincidir con --gpu-indexes")
  elif pArgumentos.device is None and len(aGpuIndexes) > 1:
    pParser.error("--device auto requiere una sola GPU; indica la lista explícita para usar varias")

  if pArgumentos.device_draft is not None and str(pArgumentos.device_draft).lower() not in ["none"]:
    aDispositivosDraft = fParsearListaDispositivos(pArgumentos.device_draft)

    if len(aDispositivosDraft) != len(aGpuIndexesDraft):
      pParser.error("la cantidad de --device-draft debe coincidir con --gpu-indexes-draft")
  elif pArgumentos.device_draft is None and aGpuIndexesDraft != aGpuIndexes:
    pParser.error("--gpu-indexes-draft distinto requiere indicar también --device-draft")

  if pArgumentos.main_gpu < 0 or pArgumentos.main_gpu >= len(aGpuIndexes):
    pParser.error("--main-gpu debe ser una posición válida dentro de --gpu-indexes")

  if pArgumentos.tensor_split is not None:
    try:
      aTensorSplit = fParsearTensorSplit(pArgumentos.tensor_split, len(aGpuIndexes))
    except ValueError as vError:
      pParser.error(str(vError))

    if aTensorSplit is None:
      pParser.error("--tensor-split debe contener al menos una proporción positiva")

  if pArgumentos.fit_target is not None:
    try:
      aFitTarget = [float(vParte.strip()) for vParte in str(pArgumentos.fit_target).split(",") if vParte.strip() != ""]
    except ValueError:
      pParser.error("--fit-target debe contener números separados por comas")

    if len(aFitTarget) == 0 or any(not math.isfinite(vValor) or vValor < 0 for vValor in aFitTarget):
      pParser.error("--fit-target debe contener números finitos no negativos")

    if len(aFitTarget) not in [1, len(aGpuIndexes)]:
      pParser.error("--fit-target debe contener un valor o exactamente uno por GPU")

  if pArgumentos.model_draft is None and (
    pArgumentos.device_draft is not None
    or str(pArgumentos.ngl_draft).lower() != "all"
    or pArgumentos.cache_type_k_draft != "f16"
    or pArgumentos.cache_type_v_draft != "f16"
    or pArgumentos.cpu_moe_draft
    or pArgumentos.n_cpu_moe_draft is not None
    or pArgumentos.spec_type is not None
    or pArgumentos.spec_draft_n_max is not None
  ):
    pParser.error("las opciones draft requieren --model-draft")

  fValidarPassthrough(pArgumentosExtra, pParser)


def fParsearArgumentos():
  vParser = fCrearParser()
  aArgumentosEntrada = sys.argv[1:]
  aArgumentosCargador = aArgumentosEntrada
  aArgumentosExtra = []

  if "--" in aArgumentosEntrada:
    vPosicionSeparador = aArgumentosEntrada.index("--")
    aArgumentosCargador = aArgumentosEntrada[:vPosicionSeparador]
    aArgumentosExtra = aArgumentosEntrada[vPosicionSeparador + 1:]

  vArgumentos, aArgumentosDesconocidos = vParser.parse_known_args(aArgumentosCargador)

  if len(aArgumentosDesconocidos) > 0:
    vParser.error("los argumentos desconocidos deben colocarse después de --")

  if vArgumentos.device == "auto":
    vArgumentos.device = None

  if vArgumentos.gpu_index is not None:
    vArgumentos.gpu_indexes = str(vArgumentos.gpu_index)

  fValidarArgumentos(vArgumentos, vParser, aArgumentosExtra)

  vArgumentos.argumentos_extra = aArgumentosExtra

  return vArgumentos


def fEjecutarListDevices(pRutaLlamaServer):
  vProceso = fEjecutar([pRutaLlamaServer, "--list-devices"], 10)

  if vProceso is None:
    print("Error: no se pudo ejecutar llama-server --list-devices", file=sys.stderr)
    return 1

  if vProceso.stdout:
    print(vProceso.stdout.rstrip())

  if vProceso.stderr:
    print(vProceso.stderr.rstrip(), file=sys.stderr)

  return vProceso.returncode


def fComprobarPuerto(pHost, pPort):
  aSockets = []
  vDireccionesVistas = set()

  try:
    aDirecciones = socket.getaddrinfo(
      pHost,
      pPort,
      type=socket.SOCK_STREAM,
      flags=socket.AI_PASSIVE
    )

    for vFamilia, vTipo, vProtocolo, _, vDireccion in aDirecciones:
      vClaveDireccion = (vFamilia, vTipo, vProtocolo, vDireccion)

      if vClaveDireccion in vDireccionesVistas:
        continue

      vDireccionesVistas.add(vClaveDireccion)
      vSocket = socket.socket(vFamilia, vTipo, vProtocolo)
      aSockets.append(vSocket)
      vSocket.bind(vDireccion)

    return {
      "disponible": True,
      "ocupado": False,
      "motivo": "ok"
    }
  except OSError as vError:
    return {
      "disponible": False,
      "ocupado": vError.errno == errno.EADDRINUSE,
      "motivo": str(vError)
    }
  finally:
    for vSocket in aSockets:
      try:
        vSocket.close()
      except OSError:
        pass


def fPuertoDisponible(pHost, pPort):
  return fComprobarPuerto(pHost, pPort)["disponible"]


def fLiberarPuerto(pHost, pPort):
  dEstadoPuerto = fComprobarPuerto(pHost, pPort)

  if dEstadoPuerto["disponible"]:
    return True

  if not dEstadoPuerto["ocupado"]:
    print("Error: no se puede comprobar el puerto en el host indicado: " + dEstadoPuerto["motivo"], file=sys.stderr)
    return False

  vRutaFuser = shutil.which("fuser")

  if vRutaFuser is None:
    print("Error: el puerto " + str(pPort) + " está ocupado y no se encuentra fuser para liberarlo", file=sys.stderr)
    return False

  try:
    vProceso = subprocess.run(
      [vRutaFuser, "-k", "-TERM", "-n", "tcp", str(pPort)],
      stdout=subprocess.DEVNULL,
      stderr=subprocess.DEVNULL,
      timeout=5,
      check=False
    )

    if vProceso.returncode not in [0, 1]:
      print("Error: no se pudo solicitar el cierre del proceso que usa el puerto " + str(pPort), file=sys.stderr)
      return False

    for _ in range(20):
      dEstadoPuerto = fComprobarPuerto(pHost, pPort)

      if dEstadoPuerto["disponible"]:
        print("Puerto " + str(pPort) + " liberado antes de iniciar llama-server")
        return True

      if not dEstadoPuerto["ocupado"]:
        print("Error al volver a comprobar el puerto: " + dEstadoPuerto["motivo"], file=sys.stderr)
        return False

      time.sleep(0.1)

    vProcesoKill = subprocess.run(
      [vRutaFuser, "-k", "-KILL", "-n", "tcp", str(pPort)],
      stdout=subprocess.DEVNULL,
      stderr=subprocess.DEVNULL,
      timeout=5,
      check=False
    )

    if vProcesoKill.returncode not in [0, 1]:
      print("Error: no se pudo forzar el cierre del proceso que usa el puerto " + str(pPort), file=sys.stderr)
      return False

    for _ in range(10):
      dEstadoPuerto = fComprobarPuerto(pHost, pPort)

      if dEstadoPuerto["disponible"]:
        print("Puerto " + str(pPort) + " liberado antes de iniciar llama-server")
        return True

      if not dEstadoPuerto["ocupado"]:
        print("Error al volver a comprobar el puerto: " + dEstadoPuerto["motivo"], file=sys.stderr)
        return False

      time.sleep(0.1)

    print("Error: el puerto " + str(pPort) + " continúa ocupado", file=sys.stderr)
    return False
  except (OSError, subprocess.SubprocessError) as vError:
    print("Error al liberar el puerto " + str(pPort) + ": " + str(vError), file=sys.stderr)
    return False
  finally:
    pass


def fMain():
  vArgumentos = fParsearArgumentos()
  vRutaLlamaServer = shutil.which(vArgumentos.llama_server)

  if vRutaLlamaServer is not None:
    vArgumentos.llama_server = vRutaLlamaServer

  if vArgumentos.list_devices:
    return fEjecutarListDevices(vArgumentos.llama_server)

  if vArgumentos.modelo is None:
    print("Error: falta la ruta del modelo GGUF", file=sys.stderr)
    return 1

  vHelp = None

  if not vArgumentos.no_validar_flags:
    vHelp = fObtenerHelpLlamaServer(vArgumentos.llama_server)

  dResultadoGGUF = fCargarGGUF(vArgumentos.modelo, "del modelo")

  if dResultadoGGUF is None:
    return 1

  fConfigurarContextoPorDefecto(vArgumentos, dResultadoGGUF)
  aAvisosCache = fConfigurarTipoCachePorDefecto(vArgumentos, dResultadoGGUF)
  vErrorSplitTensor = fObtenerErrorCompatibilidadSplitTensor(vArgumentos)

  if vErrorSplitTensor is not None:
    print("Error: " + vErrorSplitTensor, file=sys.stderr)
    return 1

  if vArgumentos.cache_type_v not in ["f32", "f16", "bf16"] and vArgumentos.flash_attn == "off":
    print("Error: una caché V cuantizada no puede usarse con --flash-attn off", file=sys.stderr)
    return 1

  vModeloSoloCPU = str(vArgumentos.device).lower() == "none"
  vNGLModeloEstimacion = 0 if vModeloSoloCPU else vArgumentos.ngl
  dPesosModelo = fCalcularPesosModelo(dResultadoGGUF, vNGLModeloEstimacion, vArgumentos.cpu_moe, vArgumentos.n_cpu_moe)
  dKVModelo = fCalcularBytesKVCache(
    dResultadoGGUF,
    vArgumentos.ctx_size,
    vArgumentos.parallel,
    vArgumentos.cache_type_k,
    vArgumentos.cache_type_v,
    vArgumentos.ubatch_size,
    vArgumentos.swa_full
  )

  dResultadoDraft = None
  dPesosDraft = None
  vDraftSoloCPU = True
  dKVDraft = {
    "bytes": 0,
    "bytes_fijos": 0,
    "estimado": True,
    "motivo": "sin draft model",
    "swa": None
  }

  if vArgumentos.model_draft is not None:
    if vArgumentos.cache_type_v_draft not in ["f32", "f16", "bf16"] and vArgumentos.flash_attn == "off":
      print("Error: una caché V cuantizada del draft no puede usarse con --flash-attn off", file=sys.stderr)
      return 1

    if vArgumentos.cache_type_v_draft not in ["f32", "f16", "bf16"]:
      aAvisosCache.append("La caché V cuantizada del draft (" + str(vArgumentos.cache_type_v_draft) + ") requiere atención flash.")

    dResultadoDraft = fCargarGGUF(vArgumentos.model_draft, "del draft model")

    if dResultadoDraft is None:
      return 1

    vDispositivoDraftEfectivo = vArgumentos.device_draft if vArgumentos.device_draft is not None else vArgumentos.device
    vDraftSoloCPU = str(vDispositivoDraftEfectivo).lower() == "none"
    vNGLDraftEstimacion = 0 if vDraftSoloCPU else vArgumentos.ngl_draft
    dPesosDraft = fCalcularPesosModelo(dResultadoDraft, vNGLDraftEstimacion, vArgumentos.cpu_moe_draft, vArgumentos.n_cpu_moe_draft)
    dKVDraft = fCalcularBytesKVCache(
      dResultadoDraft,
      vArgumentos.ctx_size,
      vArgumentos.parallel,
      vArgumentos.cache_type_k_draft,
      vArgumentos.cache_type_v_draft,
      vArgumentos.ubatch_size,
      vArgumentos.swa_full
    )

  vEstimacionKVCompleta = dKVModelo["estimado"] and (
    dResultadoDraft is None or dKVDraft["estimado"]
  )

  vMemAvailable = fObtenerMemAvailableBytes()
  vMemTotal = fObtenerMemTotalBytes()
  aGpuIndexesModelo = [] if vModeloSoloCPU else fParsearListaEnteros(vArgumentos.gpu_indexes)
  aGpuIndexesDraft = []

  if dPesosDraft is not None and not vDraftSoloCPU:
    aGpuIndexesDraft = fParsearListaEnteros(vArgumentos.gpu_indexes_draft)

  aGpuIndexes = fUnirIndicesGPU(aGpuIndexesModelo, aGpuIndexesDraft)
  ldAceleradores = fObtenerAceleradores(vArgumentos.backend, aGpuIndexes, vArgumentos.gtt)
  ldAceleradoresModelo = fSeleccionarAceleradores(ldAceleradores, aGpuIndexesModelo)
  ldAceleradoresDraft = fSeleccionarAceleradores(ldAceleradores, aGpuIndexesDraft)

  vKVOffloadModelo = vArgumentos.kv_offload in ["on", "auto"] and not vModeloSoloCPU
  vKVOffloadDraft = vArgumentos.kv_offload in ["on", "auto"] and not vDraftSoloCPU
  vKVOffloadActivo = vKVOffloadModelo or vKVOffloadDraft
  vBytesModeloGPUModelo = dPesosModelo["bytes_gpu"]
  vBytesModeloGPUDraft = dPesosDraft["bytes_gpu"] if dPesosDraft is not None else 0
  vBytesModeloGPU = vBytesModeloGPUModelo + vBytesModeloGPUDraft
  vBytesModeloCPU = dPesosModelo["bytes_cpu"]
  dDistribucionKVModelo = fCalcularDistribucionKV(
    dResultadoGGUF,
    dKVModelo,
    dPesosModelo,
    vKVOffloadModelo
  )
  dDistribucionKVDraft = {
    "bytes_gpu": 0,
    "bytes_ram": 0,
    "bytes_fijos_gpu": 0,
    "bytes_fijos_ram": 0
  }

  if dPesosDraft is not None:
    vBytesModeloCPU += dPesosDraft["bytes_cpu"]
    dDistribucionKVDraft = fCalcularDistribucionKV(
      dResultadoDraft,
      dKVDraft,
      dPesosDraft,
      vKVOffloadDraft
    )

  vBytesKVGPUModelo = dDistribucionKVModelo["bytes_gpu"]
  vBytesKVGPUDraft = dDistribucionKVDraft["bytes_gpu"]
  vBytesKVGPU = vBytesKVGPUModelo + vBytesKVGPUDraft
  vBytesKVRAM = dDistribucionKVModelo["bytes_ram"] + dDistribucionKVDraft["bytes_ram"]
  vBytesKVFijoGPU = dDistribucionKVModelo["bytes_fijos_gpu"] + dDistribucionKVDraft["bytes_fijos_gpu"]
  vBytesKVFijoRAM = dDistribucionKVModelo["bytes_fijos_ram"] + dDistribucionKVDraft["bytes_fijos_ram"]

  vOverheadPercent = vArgumentos.overhead_percent / 100
  vOverheadBytes = int((vBytesModeloGPU + vBytesKVGPU) * vOverheadPercent) + fGiBABBytes(vArgumentos.overhead_gib)
  vReservaMinimaBytes = fGiBABBytes(vArgumentos.min_free_gib)
  vBaseAceleradorModelo = vBytesModeloGPUModelo + vBytesKVGPUModelo
  vBaseAceleradorDraft = vBytesModeloGPUDraft + vBytesKVGPUDraft
  vBaseAceleradorTotal = vBaseAceleradorModelo + vBaseAceleradorDraft
  vOverheadModelo = 0
  vOverheadDraft = 0

  if vBaseAceleradorTotal > 0:
    vOverheadModelo = int(vOverheadBytes * (vBaseAceleradorModelo / vBaseAceleradorTotal))
    vOverheadDraft = vOverheadBytes - vOverheadModelo

  vRequeridoAceleradorTotal = vBytesModeloGPU + vBytesKVGPU + vOverheadBytes
  vRequeridoAceleradorConReservaTotal = vRequeridoAceleradorTotal + (vReservaMinimaBytes * len(ldAceleradores))

  for dAcelerador in ldAceleradores:
    dAcelerador["requerido"] = 0

  fDistribuirRequerimientoAcelerador(
    ldAceleradoresModelo,
    vBytesModeloGPUModelo + vOverheadModelo,
    vBytesKVGPUModelo,
    vArgumentos.split_mode,
    vArgumentos.tensor_split,
    vArgumentos.main_gpu,
    False
  )

  if dPesosDraft is not None:
    if aGpuIndexesDraft == aGpuIndexesModelo:
      vTensorSplitDraft = vArgumentos.tensor_split
    else:
      vTensorSplitDraft = None

    vMainGPUDraft = min(vArgumentos.main_gpu, max(0, len(ldAceleradoresDraft) - 1))
    fDistribuirRequerimientoAcelerador(
      ldAceleradoresDraft,
      vBytesModeloGPUDraft + vOverheadDraft,
      vBytesKVGPUDraft,
      vArgumentos.split_mode,
      vTensorSplitDraft,
      vMainGPUDraft,
      False
    )

  vCacheRAMBytes = fMiBABBytes(vArgumentos.cache_ram)
  vRequeridoRAM = int((vBytesModeloCPU + vBytesKVRAM) * 1.10) + vCacheRAMBytes
  vUsoRAMCompartidaAcelerador = fCalcularUsoRAMCompartidaAcelerador(ldAceleradores)
  vRequeridoRAMConReserva = vRequeridoRAM + vUsoRAMCompartidaAcelerador + vReservaMinimaBytes

  vCabeAcelerador = True
  vCabeRAM = True
  aAvisos = []
  aAvisos.extend(aAvisosCache)

  if not dKVModelo["estimado"]:
    vCabeAcelerador = False
    vCabeRAM = False
    aAvisos.append("La KV/el estado principal no puede estimarse; la precomprobación falla de forma segura.")

  if dResultadoDraft is not None and not dKVDraft["estimado"]:
    vCabeAcelerador = False
    vCabeRAM = False
    aAvisos.append("La KV/el estado draft no puede estimarse; la precomprobación falla de forma segura.")

  if vBytesModeloGPU + vBytesKVGPU > 0:
    if len(ldAceleradores) == 0:
      vCabeAcelerador = False
      aAvisos.append("No hay aceleradores asociados a los pesos o al estado que deben descargarse")

    for dAcelerador in ldAceleradores:
      if dAcelerador["libre"] is None:
        vCabeAcelerador = False
        aAvisos.append("No se pudo obtener memoria libre de GPU " + str(dAcelerador["index"]))
      elif dAcelerador["requerido"] + vReservaMinimaBytes > dAcelerador["libre"]:
        vCabeAcelerador = False

  if vRequeridoRAMConReserva > vMemAvailable:
    vCabeRAM = False

  if vUsoRAMCompartidaAcelerador > 0:
    aAvisos.append("La comprobación de RAM incluye " + fFormatoGiB(vUsoRAMCompartidaAcelerador) + " de GTT compartida con el acelerador.")

  fAgregarAvisoContextoDemasiadoGrande(
    aAvisos,
    vArgumentos,
    vCabeAcelerador,
    vCabeRAM,
    ldAceleradores,
    vKVOffloadActivo,
    vBytesKVGPU,
    vBytesKVRAM,
    vBytesKVFijoGPU,
    vBytesKVFijoRAM,
    vBytesModeloGPU,
    vBytesModeloCPU,
    vOverheadPercent,
    fGiBABBytes(vArgumentos.overhead_gib),
    vReservaMinimaBytes,
    max(0, vMemAvailable - vUsoRAMCompartidaAcelerador),
    vCacheRAMBytes
  )

  aComando, aAvisosComando = fCrearComandoLlamaServer(vArgumentos, dPesosModelo, dPesosDraft, vHelp)
  aAvisos.extend(aAvisosComando)

  if vArgumentos.ngl == "auto":
    aAvisos.append("--ngl auto no se pasa al comando porque llama.cpp ya usa auto por defecto; la estimación asume todas las capas posibles en GPU.")

  fMostrarResumenBonito(
    vArgumentos,
    dResultadoGGUF,
    dPesosModelo,
    dKVModelo,
    dResultadoDraft,
    dPesosDraft,
    dKVDraft,
    vMemAvailable,
    vMemTotal,
    ldAceleradores,
    vOverheadBytes,
    vReservaMinimaBytes,
    vRequeridoAceleradorTotal,
    vRequeridoAceleradorConReservaTotal,
    vRequeridoRAM,
    vRequeridoRAMConReserva,
    vCabeAcelerador,
    vCabeRAM,
    aAvisos,
    vHelp is not None
  )

  if not vCabeAcelerador:
    print("Resultado: NO CABE en acelerador")

    for dAcelerador in ldAceleradores:
      if dAcelerador["libre"] is not None:
        vFaltan = dAcelerador["requerido"] + vReservaMinimaBytes - dAcelerador["libre"]

        if vFaltan > 0:
          print("Faltan en GPU " + str(dAcelerador["index"]) + ": " + fFormatoGiB(vFaltan))

  if not vCabeRAM:
    vFaltan = vRequeridoRAMConReserva - vMemAvailable
    print("Resultado: NO CABE en RAM del sistema")
    print("Faltan en RAM: " + fFormatoGiB(vFaltan))

  if vCabeAcelerador and vCabeRAM:
    print("Resultado: CABE según la estimación")
  elif vArgumentos.force and vEstimacionKVCompleta:
    print("Resultado: SE LANZA FORZADO aunque la estimación dice que no cabe")

  print("Comando final:")
  print(" ".join(shlex.quote(vArg) for vArg in aComando))

  if not vEstimacionKVCompleta:
    print("No se lanza llama-server porque la KV/el estado no se pudo estimar; --force no omite esta comprobación.")
    return 1

  if not vCabeAcelerador or not vCabeRAM:
    if not vArgumentos.force:
      print("No se lanza llama-server. Usa --force si quieres lanzarlo igualmente.")
      return 1

  if vArgumentos.dry_run:
    return 0

  if not os.path.isfile(aComando[0]):
    print("Error: no se encuentra el binario llama-server: " + str(aComando[0]), file=sys.stderr)
    print("Indica la ruta con --llama-server o usa --dry-run para solo ver el comando.", file=sys.stderr)
    return 1

  if not fLiberarPuerto(vArgumentos.host, vArgumentos.port):
    return 1

  try:
    os.execv(aComando[0], aComando)
  except OSError as vError:
    print("Error al ejecutar llama-server: " + str(vError), file=sys.stderr)
    return 1

  return 0


def fEjecutarMainSeguro():
  try:
    return fMain()
  except (OSError, RuntimeError, TypeError, ValueError, OverflowError, ZeroDivisionError, struct.error) as vError:
    print("Error no recuperable: " + str(vError), file=sys.stderr)
    return 1
  finally:
    pass


if __name__ == "__main__":
  sys.exit(fEjecutarMainSeguro())

