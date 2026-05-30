#!/usr/bin/env python3

#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/LlamaCPP-Modelos-GGUF-Cargar.py | python3 - -- [ArchivoGGUF]

import argparse
import os
import re
import shlex
import shutil
import struct
import subprocess
import sys


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


def fBytesAGiB(vBytes):
  return vBytes / 1024 / 1024 / 1024


def fGiBABBytes(vGiB):
  return int(vGiB * 1024 * 1024 * 1024)


def fMiBABBytes(vMiB):
  return int(vMiB * 1024 * 1024)


def fBytesAMiB(vBytes):
  return vBytes / 1024 / 1024


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


def fSaltarValorMetadata(vArchivo, vTipo):
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
      fSaltarValorMetadata(vArchivo, vTipoArray)
  elif vTipo == 10:
    vArchivo.seek(8, os.SEEK_CUR)
  elif vTipo == 11:
    vArchivo.seek(8, os.SEEK_CUR)
  elif vTipo == 12:
    vArchivo.seek(8, os.SEEK_CUR)
  else:
    raise ValueError("Tipo GGUF no soportado en metadata: " + str(vTipo))


def fLeerValorMetadataEscalar(vArchivo, vTipo):
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
    raise ValueError("Tipo GGUF no soportado en metadata escalar: " + str(vTipo))


def fLeerValorMetadata(vArchivo, vTipo):
  if vTipo == 9:
    vTipoArray = fLeer(vArchivo, "I")
    vLongitudArray = fLeer(vArchivo, "Q")
    aValores = []

    if vLongitudArray > 4096:
      for _ in range(vLongitudArray):
        fSaltarValorMetadata(vArchivo, vTipoArray)

      return None

    for _ in range(vLongitudArray):
      aValores.append(fLeerValorMetadataEscalar(vArchivo, vTipoArray))

    return aValores

  return fLeerValorMetadataEscalar(vArchivo, vTipo)


def fAlinear(vValor, vAlineacion):
  vResto = vValor % vAlineacion

  if vResto == 0:
    return vValor

  return vValor + vAlineacion - vResto


def fObtenerIndiceCapa(vNombreTensor):
  vMatch = re.search(r"^blk\.([0-9]+)\.", vNombreTensor)

  if vMatch:
    return int(vMatch.group(1))

  vMatch = re.search(r"\.layers\.([0-9]+)\.", vNombreTensor)

  if vMatch:
    return int(vMatch.group(1))

  return None


def fTensorPareceMoE(vNombreTensor):
  aPatrones = [
    ".ffn_gate_exps",
    ".ffn_down_exps",
    ".ffn_up_exps",
    ".experts.",
    ".mlp.experts.",
    ".feed_forward.experts.",
    ".block_sparse_moe."
  ]

  vNombre = vNombreTensor.lower()

  for vPatron in aPatrones:
    if vPatron in vNombre:
      return True

  return False


def fCrearCapaVacia():
  return {
    "total": 0,
    "moe": 0,
    "normal": 0
  }


def fLeerGGUF(vRutaModelo):
  aMetadata = {}
  aTensores = []
  vTamanoArchivo = os.path.getsize(vRutaModelo)

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
      vPosicionValor = vArchivo.tell()

      try:
        vValor = fLeerValorMetadata(vArchivo, vTipo)

        if vValor is not None:
          aMetadata[vClave] = vValor

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

      aTensores.append({
        "nombre": vNombreTensor,
        "tipo": vTipoTensor,
        "offset": vOffsetTensor,
        "moe": fTensorPareceMoE(vNombreTensor)
      })

    vAlineacion = int(aMetadata.get("general.alignment", 32))
    vInicioDatos = fAlinear(vArchivo.tell(), vAlineacion)

  aTensoresOrdenados = sorted(aTensores, key=lambda x: x["offset"])
  aCapas = {}
  vBytesSinCapa = 0
  vBytesSinCapaMoE = 0
  vBytesTotal = 0
  vBytesMoE = 0

  for vIndice, aTensor in enumerate(aTensoresOrdenados):
    vOffsetAbsoluto = vInicioDatos + aTensor["offset"]

    if vIndice + 1 < len(aTensoresOrdenados):
      vSiguienteOffsetAbsoluto = vInicioDatos + aTensoresOrdenados[vIndice + 1]["offset"]
      vBytesTensor = vSiguienteOffsetAbsoluto - vOffsetAbsoluto
    else:
      vBytesTensor = vTamanoArchivo - vOffsetAbsoluto

    if vBytesTensor < 0:
      raise ValueError("Offset inválido detectado en el GGUF")

    vBytesTotal += vBytesTensor

    if aTensor["moe"]:
      vBytesMoE += vBytesTensor

    vIndiceCapa = fObtenerIndiceCapa(aTensor["nombre"])

    if vIndiceCapa is None:
      vBytesSinCapa += vBytesTensor

      if aTensor["moe"]:
        vBytesSinCapaMoE += vBytesTensor
    else:
      if vIndiceCapa not in aCapas:
        aCapas[vIndiceCapa] = fCrearCapaVacia()

      aCapas[vIndiceCapa]["total"] += vBytesTensor

      if aTensor["moe"]:
        aCapas[vIndiceCapa]["moe"] += vBytesTensor
      else:
        aCapas[vIndiceCapa]["normal"] += vBytesTensor

  return {
    "ruta": vRutaModelo,
    "version": vVersion,
    "metadata": aMetadata,
    "tensor_count": vTensorCount,
    "bytes_total": vBytesTotal,
    "bytes_sin_capa": vBytesSinCapa,
    "bytes_sin_capa_moe": vBytesSinCapaMoE,
    "bytes_moe": vBytesMoE,
    "capas": aCapas
  }


def fCargarGGUF(vRuta, vDescripcion):
  if not os.path.isfile(vRuta):
    print("Error: no se encuentra el archivo " + vDescripcion + ": " + str(vRuta), file=sys.stderr)
    return None

  try:
    return fLeerGGUF(vRuta)
  except (ValueError, EOFError, OSError, struct.error) as vError:
    print("Error: no se pudo leer el GGUF " + vDescripcion + " '" + str(vRuta) + "': " + str(vError), file=sys.stderr)
    return None


def fObtenerMetadata(aResultadoGGUF, vClave, vDefecto=None):
  return aResultadoGGUF["metadata"].get(vClave, vDefecto)


def fObtenerMetadataPorSufijo(aResultadoGGUF, aSufijos, vDefecto=None):
  vArquitectura = aResultadoGGUF["metadata"].get("general.architecture")

  for vSufijo in aSufijos:
    if vArquitectura is not None:
      vClaveArquitectura = str(vArquitectura) + vSufijo

      if vClaveArquitectura in aResultadoGGUF["metadata"]:
        return aResultadoGGUF["metadata"][vClaveArquitectura]

    for vClave, vValor in aResultadoGGUF["metadata"].items():
      if vClave.endswith(vSufijo):
        return vValor

  return vDefecto


def fObtenerArquitectura(aResultadoGGUF):
  return str(fObtenerMetadata(aResultadoGGUF, "general.architecture", "desconocida"))


def fConvertirEnteroMetadata(vValor, vDefecto=None):
  if vValor is None:
    return vDefecto

  if isinstance(vValor, list):
    for vElemento in vValor:
      vEntero = fConvertirEnteroMetadata(vElemento, None)

      if vEntero is not None:
        return vEntero

    return vDefecto

  if isinstance(vValor, bool):
    return int(vValor)

  try:
    return int(vValor)
  except (TypeError, ValueError):
    return vDefecto


def fObtenerBlockCount(aResultadoGGUF):
  vValor = fObtenerMetadataPorSufijo(aResultadoGGUF, [".block_count"])
  vEntero = fConvertirEnteroMetadata(vValor, None)

  if vEntero is not None:
    return vEntero

  return len(aResultadoGGUF["capas"])


def fObtenerContextoNativo(aResultadoGGUF):
  vValor = fObtenerMetadataPorSufijo(aResultadoGGUF, [".context_length", ".max_position_embeddings"])
  return fConvertirEnteroMetadata(vValor, None)


def fObtenerEnteroMetadata(aResultadoGGUF, aSufijos, vDefecto=None):
  vValor = fObtenerMetadataPorSufijo(aResultadoGGUF, aSufijos)
  return fConvertirEnteroMetadata(vValor, vDefecto)


def fObtenerDimensionesKV(aResultadoGGUF):
  vEmbedding = fObtenerEnteroMetadata(aResultadoGGUF, [".embedding_length", ".hidden_size"])
  vHeadCount = fObtenerEnteroMetadata(aResultadoGGUF, [".attention.head_count", ".num_attention_heads"])
  vHeadCountKV = fObtenerEnteroMetadata(aResultadoGGUF, [".attention.head_count_kv", ".num_key_value_heads"])
  vKeyLength = fObtenerEnteroMetadata(aResultadoGGUF, [".attention.key_length"])
  vValueLength = fObtenerEnteroMetadata(aResultadoGGUF, [".attention.value_length"])

  if vHeadCountKV is None:
    vHeadCountKV = vHeadCount

  if vKeyLength is None:
    if vEmbedding is not None and vHeadCount is not None and vHeadCount > 0:
      vKeyLength = int(vEmbedding / vHeadCount)

  if vValueLength is None:
    if vEmbedding is not None and vHeadCount is not None and vHeadCount > 0:
      vValueLength = int(vEmbedding / vHeadCount)

  if vHeadCountKV is None or vKeyLength is None or vValueLength is None:
    return None

  return {
    "head_count": vHeadCount,
    "head_count_kv": vHeadCountKV,
    "key_length": vKeyLength,
    "value_length": vValueLength,
    "k_gqa": vHeadCountKV * vKeyLength,
    "v_gqa": vHeadCountKV * vValueLength
  }


def fBytesPorTipoKV(vTipoKV):
  vTipo = str(vTipoKV).lower()

  if vTipo not in cTiposKVBytes:
    raise ValueError("Tipo de KV cache no soportado para estimación: " + str(vTipoKV))

  return cTiposKVBytes[vTipo]


def fCalcularBytesKVCache(aResultadoGGUF, vCtxSize, vParallel, vCacheTypeK, vCacheTypeV):
  vBlockCount = fObtenerBlockCount(aResultadoGGUF)
  aDimensionesKV = fObtenerDimensionesKV(aResultadoGGUF)

  if aDimensionesKV is None:
    return {
      "bytes": 0,
      "estimado": False,
      "motivo": "no se encontraron dimensiones K/V suficientes en metadata"
    }

  vBytesK = fBytesPorTipoKV(vCacheTypeK)
  vBytesV = fBytesPorTipoKV(vCacheTypeV)
  vCtxTotal = int(vCtxSize) * int(vParallel)
  vBytes = int(vBlockCount * vCtxTotal * ((aDimensionesKV["k_gqa"] * vBytesK) + (aDimensionesKV["v_gqa"] * vBytesV)))

  return {
    "bytes": vBytes,
    "estimado": True,
    "motivo": "ok",
    "dimensiones": aDimensionesKV
  }



def fConfigurarContextoPorDefecto(vArgumentos, aResultadoGGUF):
  vContextoNativo = fObtenerContextoNativo(aResultadoGGUF)

  if vArgumentos.ctx_size is not None:
    vArgumentos.ctx_size_origen = "indicado por usuario"
    return

  if vContextoNativo is not None and vContextoNativo > 0:
    vArgumentos.ctx_size = vContextoNativo
    vArgumentos.ctx_size_origen = "nativo del GGUF"
    return

  vArgumentos.ctx_size = 32768
  vArgumentos.ctx_size_origen = "fallback del script"


def fRedondearContextoRecomendado(vCtxSize):
  if vCtxSize is None:
    return None

  vCtxSize = int(vCtxSize)

  if vCtxSize < 1024:
    return None

  return max(1024, int(vCtxSize / 1024) * 1024)


def fCalcularContextoAconsejadoAcelerador(
  vCtxActual,
  vBytesKVActual,
  vBytesModeloGPU,
  vLibreTotal,
  vOverheadPercent,
  vOverheadFijoBytes,
  vReservaTotalBytes
):
  if vCtxActual is None or vCtxActual <= 0 or vBytesKVActual <= 0:
    return None

  if vLibreTotal is None or vLibreTotal <= 0:
    return None

  vDisponibleAntesKV = vLibreTotal - vReservaTotalBytes - vOverheadFijoBytes
  vKVMax = (vDisponibleAntesKV / (1 + vOverheadPercent)) - vBytesModeloGPU

  if vKVMax <= 0:
    return None

  vCtxMax = int(vCtxActual * (vKVMax / vBytesKVActual) * 0.90)
  return fRedondearContextoRecomendado(vCtxMax)


def fCalcularContextoAconsejadoRAM(
  vCtxActual,
  vBytesKVActual,
  vBytesModeloCPU,
  vMemAvailable,
  vCacheRAMBytes,
  vReservaMinimaBytes
):
  if vCtxActual is None or vCtxActual <= 0 or vBytesKVActual <= 0:
    return None

  vKVMax = ((vMemAvailable - vReservaMinimaBytes - vCacheRAMBytes) / 1.10) - vBytesModeloCPU

  if vKVMax <= 0:
    return None

  vCtxMax = int(vCtxActual * (vKVMax / vBytesKVActual) * 0.90)
  return fRedondearContextoRecomendado(vCtxMax)


def fAgregarAvisoContextoDemasiadoGrande(
  aAvisos,
  vArgumentos,
  vCabeAcelerador,
  vCabeRAM,
  aAceleradores,
  vKVOffloadActivo,
  vBytesKVGPU,
  vBytesKVRAM,
  vBytesModeloGPU,
  vBytesModeloCPU,
  vOverheadPercent,
  vOverheadFijoBytes,
  vReservaMinimaBytes,
  vMemAvailable,
  vCacheRAMBytes
):
  if vCabeAcelerador and vCabeRAM:
    return

  if getattr(vArgumentos, "ctx_size_origen", "") == "nativo del GGUF":
    aAvisos.append("Se está usando el contexto nativo máximo del GGUF; si no cabe, reduce --ctx-size.")
  else:
    aAvisos.append("El contexto solicitado no cabe con la memoria calculada; reduce --ctx-size.")

  aContextos = []

  if vKVOffloadActivo and not vCabeAcelerador:
    vLibreTotal = None

    if all(aAcelerador["libre"] is not None for aAcelerador in aAceleradores):
      vLibreTotal = sum(aAcelerador["libre"] for aAcelerador in aAceleradores)

    vContextoAcelerador = fCalcularContextoAconsejadoAcelerador(
      vArgumentos.ctx_size,
      vBytesKVGPU,
      vBytesModeloGPU,
      vLibreTotal,
      vOverheadPercent,
      vOverheadFijoBytes,
      vReservaMinimaBytes * len(aAceleradores)
    )

    if vContextoAcelerador is not None:
      aContextos.append(vContextoAcelerador)

  if not vKVOffloadActivo and not vCabeRAM:
    vContextoRAM = fCalcularContextoAconsejadoRAM(
      vArgumentos.ctx_size,
      vBytesKVRAM,
      vBytesModeloCPU,
      vMemAvailable,
      vCacheRAMBytes,
      vReservaMinimaBytes
    )

    if vContextoRAM is not None:
      aContextos.append(vContextoRAM)

  if len(aContextos) > 0:
    vContextoAconsejado = min(aContextos)
    aAvisos.append("Prueba con --ctx-size " + str(vContextoAconsejado) + " como punto de partida conservador.")
  else:
    aAvisos.append("Reducir contexto puede no ser suficiente; baja --ngl, activa --cpu-moe o usa KV cache más pequeña.")

def fNormalizarNGL(vNgl, vBlockCount):
  if str(vNgl).lower() == "auto":
    vCapasGPU = vBlockCount
  elif str(vNgl).lower() == "all":
    vCapasGPU = vBlockCount
  else:
    vCapasGPU = int(vNgl)

  if vCapasGPU < 0:
    vCapasGPU = 0

  if vCapasGPU > vBlockCount:
    vCapasGPU = vBlockCount

  return vCapasGPU


def fCalcularBytesGPU(aResultadoGGUF, vNgl, vCpuMoE, vNCpuMoE):
  vBlockCount = fObtenerBlockCount(aResultadoGGUF)
  vCapasGPU = fNormalizarNGL(vNgl, vBlockCount)
  vBytesGPU = 0

  if vCapasGPU >= vBlockCount:
    vBytesGPU += aResultadoGGUF["bytes_sin_capa"]

    if vCpuMoE:
      vBytesGPU -= aResultadoGGUF["bytes_sin_capa_moe"]

  for vIndiceCapa in range(vCapasGPU):
    aCapa = aResultadoGGUF["capas"].get(vIndiceCapa, fCrearCapaVacia())
    vBytesCapa = aCapa["total"]

    if vCpuMoE:
      vBytesCapa -= aCapa["moe"]
    elif vNCpuMoE is not None and vIndiceCapa < vNCpuMoE:
      vBytesCapa -= aCapa["moe"]

    vBytesGPU += vBytesCapa

  if vBytesGPU < 0:
    vBytesGPU = 0

  return vCapasGPU, vBytesGPU


def fCalcularBytesRAMCPU(aResultadoGGUF, vBytesGPU):
  vBytesCPU = aResultadoGGUF["bytes_total"] - vBytesGPU

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


def fParsearListaEnteros(vTexto):
  aResultado = []

  if vTexto is None:
    return aResultado

  for vParte in str(vTexto).split(","):
    vParte = vParte.strip()

    if vParte == "":
      continue

    aResultado.append(int(vParte))

  return aResultado


def fParsearTensorSplit(vTexto, vCantidad):
  if vTexto is None or str(vTexto).strip() == "":
    return None

  aValores = []

  for vParte in str(vTexto).split(","):
    vParte = vParte.strip()

    if vParte == "":
      continue

    aValores.append(float(vParte))

  if len(aValores) == 0:
    return None

  if len(aValores) < vCantidad:
    vUltimo = aValores[-1]

    while len(aValores) < vCantidad:
      aValores.append(vUltimo)

  if len(aValores) > vCantidad:
    aValores = aValores[:vCantidad]

  vTotal = sum(aValores)

  if vTotal <= 0:
    return None

  return [vValor / vTotal for vValor in aValores]


def fEjecutar(aComando, vTimeout=10):
  try:
    return subprocess.run(
      aComando,
      stdout=subprocess.PIPE,
      stderr=subprocess.PIPE,
      text=True,
      timeout=vTimeout
    )
  except Exception:
    return None


def fParsearLineaMemoriaAMD(vTexto, vClave):
  vRegex = r"^\s*" + re.escape(vClave) + r":\s+([0-9]+)\s+MB\s*$"

  for vLinea in vTexto.splitlines():
    vMatch = re.search(vRegex, vLinea)

    if vMatch:
      return int(vMatch.group(1)) * 1024 * 1024

  return None


def fObtenerMemoriaAMD(vGpuIndex):
  if shutil.which("amd-smi") is None:
    return None

  aComando = [
    "amd-smi",
    "metric",
    "--gpu",
    str(vGpuIndex)
  ]

  aProceso = fEjecutar(aComando)

  if aProceso is None or aProceso.returncode != 0:
    return None

  vTexto = aProceso.stdout

  return {
    "backend": "AMD",
    "index": vGpuIndex,
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


def fObtenerMemoriaNVIDIA(vGpuIndex):
  if shutil.which("nvidia-smi") is None:
    return None

  aComando = [
    "nvidia-smi",
    "--query-gpu=memory.total,memory.used,memory.free,name",
    "--format=csv,noheader,nounits",
    "-i",
    str(vGpuIndex)
  ]

  aProceso = fEjecutar(aComando)

  if aProceso is None or aProceso.returncode != 0:
    return None

  vLinea = aProceso.stdout.strip().splitlines()[0] if aProceso.stdout.strip() else ""
  aPartes = [vParte.strip() for vParte in vLinea.split(",")]

  if len(aPartes) < 3:
    return None

  vNombre = "NVIDIA"

  if len(aPartes) >= 4:
    vNombre = ",".join(aPartes[3:]).strip()

  return {
    "backend": "NVIDIA",
    "index": vGpuIndex,
    "name": vNombre,
    "total_vram": int(aPartes[0]) * 1024 * 1024,
    "used_vram": int(aPartes[1]) * 1024 * 1024,
    "free_vram": int(aPartes[2]) * 1024 * 1024
  }


def fSeleccionarMemoriaAcelerador(aMemoria):
  if aMemoria is None:
    return None, "no disponible"

  if aMemoria.get("backend") == "AMD":
    vTotalGTT = aMemoria.get("total_gtt")
    vFreeGTT = aMemoria.get("free_gtt")
    vTotalVisibleVRAM = aMemoria.get("total_visible_vram")
    vFreeVisibleVRAM = aMemoria.get("free_visible_vram")

    if vTotalGTT is not None and vTotalVisibleVRAM is not None:
      if vTotalGTT > vTotalVisibleVRAM * 4:
        return vFreeGTT, "FREE_GTT"

    if vFreeVisibleVRAM is not None:
      return vFreeVisibleVRAM, "FREE_VISIBLE_VRAM"

    if vFreeGTT is not None:
      return vFreeGTT, "FREE_GTT"

    return None, "no disponible"

  if aMemoria.get("backend") == "NVIDIA":
    return aMemoria.get("free_vram"), "FREE_VRAM"

  return None, "no disponible"


def fNombreMemoriaLegible(vNombreMemoria):
  aNombres = {
    "FREE_GTT": "RAM de sistema mapeada para la GPU",
    "FREE_VISIBLE_VRAM": "VRAM visible",
    "FREE_VRAM": "VRAM",
    "no disponible": "no disponible"
  }

  return aNombres.get(vNombreMemoria, vNombreMemoria)


def fObtenerAceleradores(vBackend, aGpuIndexes):
  aAceleradores = []

  for vGpuIndex in aGpuIndexes:
    aMemoria = None

    if vBackend in ["auto", "nvidia"]:
      aMemoria = fObtenerMemoriaNVIDIA(vGpuIndex)

    if aMemoria is None and vBackend in ["auto", "amd"]:
      aMemoria = fObtenerMemoriaAMD(vGpuIndex)

    vLibre, vNombreMemoria = fSeleccionarMemoriaAcelerador(aMemoria)

    aAceleradores.append({
      "index": vGpuIndex,
      "memoria": aMemoria,
      "libre": vLibre,
      "nombre_memoria": vNombreMemoria,
      "nombre_memoria_legible": fNombreMemoriaLegible(vNombreMemoria),
      "requerido": 0
    })

  return aAceleradores


def fObtenerHelpLlamaServer(vRutaLlamaServer):
  if not os.path.exists(vRutaLlamaServer):
    return None

  aProceso = fEjecutar([vRutaLlamaServer, "--help"], 10)

  if aProceso is None:
    return None

  return (aProceso.stdout or "") + "\n" + (aProceso.stderr or "")


def fFlagSoportado(vHelp, aFlags):
  if vHelp is None:
    return True

  for vFlag in aFlags:
    if vFlag in vHelp:
      return True

  return False


def fAgregarOpcion(aComando, vHelp, aFlags, aValores, aAvisos):
  if fFlagSoportado(vHelp, aFlags):
    aComando.append(aFlags[0])

    for vValor in aValores:
      aComando.append(str(vValor))
  else:
    aAvisos.append("Flag no soportado por este llama-server: " + "/".join(aFlags))


def fAgregarBooleano(aComando, vHelp, aFlags, aAvisos):
  if fFlagSoportado(vHelp, aFlags):
    aComando.append(aFlags[0])
  else:
    aAvisos.append("Flag no soportado por este llama-server: " + "/".join(aFlags))


def fTerminalSoportaColor():
  if not sys.stdout.isatty():
    return False

  if os.environ.get("NO_COLOR"):
    return False

  vTerm = os.environ.get("TERM", "")

  if vTerm == "dumb":
    return False

  return True


def fColor(vTexto, vColor, vUsarColor):
  if not vUsarColor:
    return vTexto

  aColores = {
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

  return aColores.get(vColor, "") + vTexto + aColores["reset"]


def fFondo(vTexto, vColor, vUsarColor):
  if not vUsarColor:
    return vTexto

  aColores = {
    "rojo": "\033[48;5;196m",
    "verde": "\033[42m",
    "blanco": "\033[48;5;231m",
    "gris": "\033[48;5;245m",
    "azulclaro": "\033[48;5;117m",
    "naranja": "\033[48;5;208m",
    "verdeclaro": "\033[48;5;114m",
    "reset": "\033[0m"
  }

  return aColores.get(vColor, "") + vTexto + aColores["reset"]


def fFormatoGiB(vBytes):
  if vBytes is None:
    return "N/A"

  return "{:.3f} GiB".format(fBytesAGiB(vBytes))


def fFormatoMiB(vBytes):
  if vBytes is None:
    return "N/A"

  return "{:.0f} MiB".format(fBytesAMiB(vBytes))


def fFormatoPorcentaje(vUsado, vTotal):
  if vUsado is None or vTotal is None or vTotal == 0:
    return "N/A"

  return "{:.1f}%".format((vUsado / vTotal) * 100)


def fFormatoTokens(vTokens):
  if vTokens is None:
    return "N/A"

  return str(vTokens) + " tokens"


def fAcortarTexto(vTexto, vAncho):
  if len(vTexto) <= vAncho:
    return vTexto

  if vAncho <= 3:
    return vTexto[:vAncho]

  return "..." + vTexto[-(vAncho - 3):]


def fLineaHorizontal(vAncho, vIzquierda, vCentro, vDerecha):
  return vIzquierda + (vCentro * (vAncho - 2)) + vDerecha


def fFila(vClave, vValor, vAncho, vUsarColor, vColorValor=None):
  vAnchoClave = 34
  vAnchoValor = vAncho - vAnchoClave - 7

  vClaveFormateada = fAcortarTexto(str(vClave), vAnchoClave).ljust(vAnchoClave)
  vValorLimpio = fAcortarTexto(str(vValor), vAnchoValor)
  vValorFormateado = vValorLimpio.ljust(vAnchoValor)

  if vColorValor is not None:
    vValorFormateado = fColor(vValorFormateado, vColorValor, vUsarColor)

  return "│ " + vClaveFormateada + " │ " + vValorFormateado + " │"


def fCrearBarra(vUsado, vTotal, vAnchoBarra, vUsarColor):
  if vUsado is None or vTotal is None or vTotal <= 0:
    return "N/A", 3, "N/A"

  vPorcentaje = vUsado / vTotal
  vPorcentajeLimitado = max(0.0, min(vPorcentaje, 1.0))
  vCaracteresRojos = int(round(vAnchoBarra * vPorcentajeLimitado))

  if vUsado > 0 and vCaracteresRojos == 0:
    vCaracteresRojos = 1

  if vCaracteresRojos > vAnchoBarra:
    vCaracteresRojos = vAnchoBarra

  vCaracteresVerdes = vAnchoBarra - vCaracteresRojos
  vTextoPorcentaje = "{:6.1f}%".format(vPorcentaje * 100)

  if vUsarColor:
    vBarra = (
      fFondo(" " * vCaracteresRojos, "rojo", vUsarColor)
      + fFondo(" " * vCaracteresVerdes, "verde", vUsarColor)
    )
  else:
    vBarra = ("█" * vCaracteresRojos) + ("░" * vCaracteresVerdes)

  return vBarra, vAnchoBarra, vTextoPorcentaje


def fFilaBarra(vClave, vUsado, vTotal, vAncho, vUsarColor):
  vAnchoClave = 34
  vAnchoValor = vAncho - vAnchoClave - 7
  vAnchoBarra = 30

  vClaveFormateada = fAcortarTexto(str(vClave), vAnchoClave).ljust(vAnchoClave)
  vBarra, vAnchoVisibleBarra, vTextoPorcentaje = fCrearBarra(vUsado, vTotal, vAnchoBarra, vUsarColor)

  vTextoDerecha = " " + vTextoPorcentaje
  vAnchoVisibleValor = vAnchoVisibleBarra + len(vTextoDerecha)

  if vAnchoVisibleValor > vAnchoValor:
    vAnchoBarra = max(5, vAnchoValor - len(vTextoDerecha))
    vBarra, vAnchoVisibleBarra, vTextoPorcentaje = fCrearBarra(vUsado, vTotal, vAnchoBarra, vUsarColor)
    vTextoDerecha = " " + vTextoPorcentaje
    vAnchoVisibleValor = vAnchoVisibleBarra + len(vTextoDerecha)

  vPadding = " " * max(0, vAnchoValor - vAnchoVisibleValor)
  vValorFormateado = vBarra + vTextoDerecha + vPadding

  return "│ " + vClaveFormateada + " │ " + vValorFormateado + " │"


def fRepartirAnchoBarra(aValores, vAnchoBarra):
  vTotal = sum(aValores)

  if vTotal <= 0:
    return [0 for _ in aValores]

  aExactos = [vAnchoBarra * vValor / vTotal for vValor in aValores]
  aChars = [int(vExacto) for vExacto in aExactos]
  vAsignado = sum(aChars)
  aOrdenResto = sorted(range(len(aValores)), key=lambda vIndice: aExactos[vIndice] - aChars[vIndice], reverse=True)
  vPos = 0

  while vAsignado < vAnchoBarra and len(aOrdenResto) > 0:
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


def fEscFondo256(vNombre):
  vCodigo = cPaleta256.get(vNombre)

  if vCodigo is None:
    return ""

  return "\033[48;5;" + str(vCodigo) + "m"


def fEscFrente256(vNombre):
  vCodigo = cPaleta256.get(vNombre)

  if vCodigo is None:
    return ""

  return "\033[38;5;" + str(vCodigo) + "m"


def fSubceldasColores(aValores, aColores, vSubceldas):
  vTotal = sum(aValores)

  if vTotal <= 0 or vSubceldas <= 0:
    return []

  aResultado = []
  vAcumulado = 0.0
  vFinAnterior = 0

  for vIndice, vValor in enumerate(aValores):
    vAcumulado += vValor
    vFin = int(round(vSubceldas * vAcumulado / vTotal))

    if vFin > vSubceldas:
      vFin = vSubceldas

    for _ in range(vFinAnterior, vFin):
      aResultado.append(aColores[vIndice])

    vFinAnterior = vFin

  while len(aResultado) < vSubceldas:
    aResultado.append(aColores[-1])

  return aResultado


def fRenderBarraColor(aSubColores, vAnchoBarra):
  aBloques = [" ", "▏", "▎", "▍", "▌", "▋", "▊", "▉"]
  vReset = "\033[0m"
  vBarra = ""

  for vCelda in range(vAnchoBarra):
    aOcho = aSubColores[vCelda * 8:(vCelda + 1) * 8]

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


def fCrearBarraComposicion(aValores, aColoresFondo, aCaracteresMono, vAnchoBarra, vUsarColor):
  if any(vValor is None for vValor in aValores) or sum(aValores) <= 0:
    return "N/A", 3

  if vUsarColor:
    aSubColores = fSubceldasColores(aValores, aColoresFondo, vAnchoBarra * 8)
    return fRenderBarraColor(aSubColores, vAnchoBarra), vAnchoBarra

  aChars = fRepartirAnchoBarra(aValores, vAnchoBarra)
  vBarra = ""

  for vIndice in range(len(aChars)):
    vBarra += aCaracteresMono[vIndice] * aChars[vIndice]

  return vBarra, sum(aChars)


def fFilaLibre(vIzquierda, vAnchoIzquierdaVisible, vDerecha, vAnchoDerechaVisible, vAncho):
  vAnchoClave = 34
  vAnchoValor = vAncho - vAnchoClave - 7
  vPadIzquierda = " " * max(0, vAnchoClave - vAnchoIzquierdaVisible)
  vPadDerecha = " " * max(0, vAnchoValor - vAnchoDerechaVisible)

  return "│ " + vIzquierda + vPadIzquierda + " │ " + vDerecha + vPadDerecha + " │"


def fFilaLeyenda(vColorFondo, vCaracterMono, vEtiqueta, vTextoDerecha, vAncho, vUsarColor):
  if vUsarColor:
    vSwatch = fFondo("  ", vColorFondo, vUsarColor)
  else:
    vSwatch = vCaracterMono * 2

  vIzquierda = "  " + vSwatch + " " + str(vEtiqueta)
  vAnchoIzquierdaVisible = 2 + 2 + 1 + len(str(vEtiqueta))

  return fFilaLibre(vIzquierda, vAnchoIzquierdaVisible, str(vTextoDerecha), len(str(vTextoDerecha)), vAncho)


def fFilaBarraComposicion(vClave, aValores, aColoresFondo, aCaracteresMono, vTextoValor, vAncho, vUsarColor):
  vAnchoClave = 34
  vAnchoValor = vAncho - vAnchoClave - 7
  vAnchoBarra = 40

  vTextoDerecha = " " + str(vTextoValor)

  vBarra, vAnchoVisibleBarra = fCrearBarraComposicion(aValores, aColoresFondo, aCaracteresMono, vAnchoBarra, vUsarColor)
  vAnchoVisibleValor = vAnchoVisibleBarra + len(vTextoDerecha)

  if vAnchoVisibleValor > vAnchoValor:
    vAnchoBarra = max(5, vAnchoValor - len(vTextoDerecha))
    vBarra, vAnchoVisibleBarra = fCrearBarraComposicion(aValores, aColoresFondo, aCaracteresMono, vAnchoBarra, vUsarColor)
    vAnchoVisibleValor = vAnchoVisibleBarra + len(vTextoDerecha)

  vPadding = " " * max(0, vAnchoValor - vAnchoVisibleValor)
  vClaveFormateada = fAcortarTexto(str(vClave), vAnchoClave).ljust(vAnchoClave)

  return "│ " + vClaveFormateada + " │ " + vBarra + vTextoDerecha + vPadding + " │"


def fObtenerComposicionMemoria(aAceleradores, vMemTotalBytes):
  if vMemTotalBytes is None or vMemTotalBytes <= 0:
    return None

  for aAcelerador in aAceleradores:
    aMemoria = aAcelerador["memoria"]

    if aMemoria is None or aMemoria.get("backend") != "AMD":
      continue

    vBytesVRAM = aMemoria.get("total_vram")
    vBytesGTT = aMemoria.get("total_gtt")

    if vBytesVRAM is None or vBytesGTT is None:
      continue

    vBytesGTTAjustado = min(vBytesGTT, vMemTotalBytes)
    vBytesSO = max(0, vMemTotalBytes - vBytesGTTAjustado)
    vUsadoVRAM = min(vBytesVRAM, aMemoria.get("used_vram") or 0)
    vUsadoGTT = min(vBytesGTTAjustado, aMemoria.get("used_gtt") or 0)

    return {
      "index": aAcelerador["index"],
      "vram": vBytesVRAM,
      "gtt": vBytesGTTAjustado,
      "so": vBytesSO,
      "total": vBytesVRAM + vMemTotalBytes,
      "vram_usado": vUsadoVRAM,
      "vram_libre": max(0, vBytesVRAM - vUsadoVRAM),
      "gtt_usado": vUsadoGTT,
      "gtt_libre": max(0, vBytesGTTAjustado - vUsadoGTT)
    }

  return None


def fTitulo(vTexto, vAncho, vUsarColor):
  vTextoTitulo = " " + vTexto + " "
  vLongitudRestante = vAncho - len(vTextoTitulo) - 2

  if vLongitudRestante < 0:
    vTextoTitulo = fAcortarTexto(vTextoTitulo, vAncho - 2)
    vLongitudRestante = 0

  vIzquierda = vLongitudRestante // 2
  vDerecha = vLongitudRestante - vIzquierda

  return "┌" + ("─" * vIzquierda) + fColor(vTextoTitulo, "negrita", vUsarColor) + ("─" * vDerecha) + "┐"


def fSeparador(vAncho):
  return fLineaHorizontal(vAncho, "├", "─", "┤")


def fPie(vAncho):
  return fLineaHorizontal(vAncho, "└", "─", "┘")


def fEstado(vCondicion):
  if vCondicion:
    return "CABE"

  return "NO CABE"


def fCalcularPesosModelo(aResultadoGGUF, vNgl, vCpuMoE, vNCpuMoE):
  vCapasGPU, vBytesGPU = fCalcularBytesGPU(aResultadoGGUF, vNgl, vCpuMoE, vNCpuMoE)
  vBytesCPU = fCalcularBytesRAMCPU(aResultadoGGUF, vBytesGPU)

  return {
    "capas_gpu": vCapasGPU,
    "bytes_gpu": vBytesGPU,
    "bytes_cpu": vBytesCPU
  }


def fObtenerProporciones(aAceleradores, vTensorSplit):
  vCantidad = len(aAceleradores)
  aProporciones = fParsearTensorSplit(vTensorSplit, vCantidad)

  if aProporciones is not None:
    return aProporciones

  aLibres = []

  for aAcelerador in aAceleradores:
    if aAcelerador["libre"] is None:
      aLibres.append(0)
    else:
      aLibres.append(aAcelerador["libre"])

  vTotalLibre = sum(aLibres)

  if vTotalLibre > 0:
    return [vLibre / vTotalLibre for vLibre in aLibres]

  return [1.0 / vCantidad for _ in range(vCantidad)]


def fBuscarPosicionMainGPU(aAceleradores, vMainGpu):
  for vIndice, aAcelerador in enumerate(aAceleradores):
    if aAcelerador["index"] == vMainGpu:
      return vIndice

  return 0


def fDistribuirRequerimientoAcelerador(aAceleradores, vBytesModeloGPU, vBytesKVGPU, vSplitMode, vTensorSplit, vMainGpu):
  if len(aAceleradores) == 0:
    return

  for aAcelerador in aAceleradores:
    aAcelerador["requerido"] = 0

  if len(aAceleradores) == 1:
    aAceleradores[0]["requerido"] = vBytesModeloGPU + vBytesKVGPU
    return

  vModo = str(vSplitMode or "layer")
  vPosicionMain = fBuscarPosicionMainGPU(aAceleradores, vMainGpu)
  aProporciones = fObtenerProporciones(aAceleradores, vTensorSplit)

  if vModo == "none":
    aAceleradores[vPosicionMain]["requerido"] = vBytesModeloGPU + vBytesKVGPU
    return

  if vModo == "row":
    for vIndice, aAcelerador in enumerate(aAceleradores):
      aAcelerador["requerido"] += int(vBytesModeloGPU * aProporciones[vIndice])

    aAceleradores[vPosicionMain]["requerido"] += vBytesKVGPU
    return

  for vIndice, aAcelerador in enumerate(aAceleradores):
    aAcelerador["requerido"] += int((vBytesModeloGPU + vBytesKVGPU) * aProporciones[vIndice])


def fMostrarResumenBonito(
  vArgumentos,
  aResultadoGGUF,
  aPesosModelo,
  aKVModelo,
  aResultadoDraft,
  aPesosDraft,
  aKVDraft,
  vMemAvailable,
  vMemTotal,
  aAceleradores,
  vOverheadBytes,
  vReservaMinimaBytes,
  vRequeridoAceleradorTotal,
  vRequeridoAceleradorConReservaTotal,
  vRequeridoRAM,
  vRequeridoRAMConReserva,
  vCabeAcelerador,
  vCabeRAM,
  aAvisos,
  vHelpDisponible
):
  vUsarColor = fTerminalSoportaColor()
  vAncho = 94
  vNombreModelo = os.path.basename(vArgumentos.modelo)
  vBlockCount = fObtenerBlockCount(aResultadoGGUF)
  vContextoNativo = fObtenerContextoNativo(aResultadoGGUF)

  print(fTitulo("PRECHECK GGUF / LLAMA-SERVER MODERNO", vAncho, vUsarColor))
  print(fFila("Modelo", vNombreModelo, vAncho, vUsarColor, "cyan"))
  print(fFila("Ruta", vArgumentos.modelo, vAncho, vUsarColor))
  print(fFila("Arquitectura", fObtenerArquitectura(aResultadoGGUF), vAncho, vUsarColor))
  print(fFila("Metadata GGUF", "v" + str(aResultadoGGUF["version"]), vAncho, vUsarColor))
  print(fSeparador(vAncho))
  print(fFila("Capas detectadas", str(vBlockCount), vAncho, vUsarColor))
  print(fFila("Capas solicitadas para GPU", str(aPesosModelo["capas_gpu"]), vAncho, vUsarColor, "cyan"))
  print(fFila("Contexto solicitado", fFormatoTokens(vArgumentos.ctx_size), vAncho, vUsarColor))
  print(fFila("Contexto nativo metadata", fFormatoTokens(vContextoNativo), vAncho, vUsarColor))

  if hasattr(vArgumentos, "ctx_size_origen"):
    print(fFila("Origen contexto", vArgumentos.ctx_size_origen, vAncho, vUsarColor, "cyan"))
  print(fFila("Paralelismo", str(vArgumentos.parallel), vAncho, vUsarColor))
  print(fFila("KV cache K/V", str(vArgumentos.cache_type_k) + " / " + str(vArgumentos.cache_type_v), vAncho, vUsarColor))
  print(fFila("KV offload", str(vArgumentos.kv_offload), vAncho, vUsarColor))
  print(fFila("Split mode", str(vArgumentos.split_mode), vAncho, vUsarColor))
  print(fFila("Tensor split", str(vArgumentos.tensor_split), vAncho, vUsarColor))
  print(fFila("Fit llama.cpp", str(vArgumentos.fit), vAncho, vUsarColor))
  print(fFila("Help llama-server detectado", str(vHelpDisponible), vAncho, vUsarColor))
  print(fSeparador(vAncho))
  print(fFila("Pesos totales", fFormatoGiB(aResultadoGGUF["bytes_total"]), vAncho, vUsarColor))
  print(fFila("Pesos MoE detectados", fFormatoGiB(aResultadoGGUF["bytes_moe"]), vAncho, vUsarColor, "amarillo"))
  print(fFila("Pesos no asociados a capas", fFormatoGiB(aResultadoGGUF["bytes_sin_capa"]), vAncho, vUsarColor))
  print(fFila("Pesos estimados GPU", fFormatoGiB(aPesosModelo["bytes_gpu"]), vAncho, vUsarColor, "cyan"))
  print(fFila("Pesos estimados CPU/RAM", fFormatoGiB(aPesosModelo["bytes_cpu"]), vAncho, vUsarColor))
  print(fFila("KV cache estimada", fFormatoGiB(aKVModelo["bytes"]), vAncho, vUsarColor, "cyan" if aKVModelo["estimado"] else "amarillo"))

  if not aKVModelo["estimado"]:
    print(fFila("Motivo KV cache", aKVModelo["motivo"], vAncho, vUsarColor, "amarillo"))

  if aResultadoDraft is not None:
    print(fSeparador(vAncho))
    print(fFila("Draft model", os.path.basename(aResultadoDraft["ruta"]), vAncho, vUsarColor, "cyan"))
    print(fFila("Draft arquitectura", fObtenerArquitectura(aResultadoDraft), vAncho, vUsarColor))
    print(fFila("Draft capas GPU", str(aPesosDraft["capas_gpu"]), vAncho, vUsarColor))
    print(fFila("Draft pesos GPU", fFormatoGiB(aPesosDraft["bytes_gpu"]), vAncho, vUsarColor))
    print(fFila("Draft pesos CPU/RAM", fFormatoGiB(aPesosDraft["bytes_cpu"]), vAncho, vUsarColor))
    print(fFila("Draft KV cache estimada", fFormatoGiB(aKVDraft["bytes"]), vAncho, vUsarColor, "cyan" if aKVDraft["estimado"] else "amarillo"))

  print(fSeparador(vAncho))
  print(fFila("Overhead estimado acelerador", fFormatoGiB(vOverheadBytes), vAncho, vUsarColor, "amarillo"))
  print(fFila("Reserva mínima por acelerador", fFormatoGiB(vReservaMinimaBytes), vAncho, vUsarColor, "amarillo"))
  print(fFila("Requerido acelerador", fFormatoGiB(vRequeridoAceleradorTotal), vAncho, vUsarColor))
  print(fFila("Requerido acelerador con reserva", fFormatoGiB(vRequeridoAceleradorConReservaTotal), vAncho, vUsarColor, "amarillo"))
  print(fFila("Requerido RAM con reserva", fFormatoGiB(vRequeridoRAMConReserva), vAncho, vUsarColor))
  print(fSeparador(vAncho))

  aComposicion = fObtenerComposicionMemoria(aAceleradores, vMemTotal)

  if aComposicion is not None:
    vModeloVRAM = min(vRequeridoAceleradorTotal, aComposicion["vram_libre"])
    vRestoGPU = max(0, vRequeridoAceleradorTotal - vModeloVRAM)
    vModeloGTT = min(vRestoGPU, aComposicion["gtt"])
    vModeloSO = min(vRequeridoRAM, aComposicion["so"])
    vBlancoVRAM = max(0, aComposicion["vram_libre"] - vModeloVRAM)
    vBlancoGTT = max(0, aComposicion["gtt"] - vModeloGTT)
    vBlancoSO = max(0, aComposicion["so"] - vModeloSO)
    vRequeridoTotalModelo = vRequeridoAceleradorTotal + vRequeridoRAM

    aValoresBarra = [
      aComposicion["vram_usado"], vModeloVRAM, vBlancoVRAM,
      vModeloGTT, vBlancoGTT,
      vModeloSO, vBlancoSO
    ]
    aColoresComposicion = ["azulclaro", "azulclaro", "azulclaro", "naranja", "naranja", "verdeclaro", "verdeclaro"]
    aMonoComposicion = ["█", "█", "█", "▒", "▒", "░", "░"]
    aColoresModelo = ["gris", "rojo", "blanco", "rojo", "blanco", "rojo", "blanco"]
    aMonoModelo = ["▓", "█", "░", "█", "░", "█", "░"]
    vDesgloseModelo = "{:.2f} GPU + {:.2f} CPU GiB".format(fBytesAGiB(vModeloVRAM + vModeloGTT), fBytesAGiB(vModeloSO))

    print(fFilaBarraComposicion("Memoria del sistema (APU)", aValoresBarra, aColoresComposicion, aMonoComposicion, fFormatoGiB(aComposicion["total"]), vAncho, vUsarColor))
    print(fFilaLeyenda("azulclaro", "█", "VRAM asignada en BIOS", fFormatoGiB(aComposicion["vram"]), vAncho, vUsarColor))
    print(fFilaLeyenda("naranja", "▒", "GTT visible a Vulkan", fFormatoGiB(aComposicion["gtt"]), vAncho, vUsarColor))
    print(fFilaLeyenda("verdeclaro", "░", "RAM del sistema operativo", fFormatoGiB(aComposicion["so"]), vAncho, vUsarColor))
    print(fSeparador(vAncho))
    print(fFilaBarraComposicion("Ocupado por el modelo", aValoresBarra, aColoresModelo, aMonoModelo, fFormatoGiB(vRequeridoTotalModelo), vAncho, vUsarColor))
    print(fFilaLeyenda("gris", "▓", "VRAM en uso (escritorio)", fFormatoGiB(aComposicion["vram_usado"]), vAncho, vUsarColor))
    print(fFilaLeyenda("rojo", "█", "Lo que ocupa el modelo", vDesgloseModelo, vAncho, vUsarColor))

    for aAcelerador in aAceleradores:
      vNombre = "GPU " + str(aAcelerador["index"])
      aMemoria = aAcelerador["memoria"]

      if aMemoria is None:
        continue

      if aMemoria.get("backend") == "AMD":
        vNombre += " AMD"
        print(fFila(vNombre + " VRAM visible libre", fFormatoGiB(aMemoria.get("free_visible_vram")), vAncho, vUsarColor))
        print(fFila(vNombre + " GTT libre", fFormatoGiB(aMemoria.get("free_gtt")), vAncho, vUsarColor, "verde"))
      elif aMemoria.get("backend") == "NVIDIA":
        vNombre += " NVIDIA"
        print(fFila(vNombre + " VRAM libre", fFormatoGiB(aMemoria.get("free_vram")), vAncho, vUsarColor, "verde"))
        print(fFila(vNombre + " total VRAM", fFormatoGiB(aMemoria.get("total_vram")), vAncho, vUsarColor))

    print(fFila("RAM disponible del sistema", fFormatoGiB(vMemAvailable), vAncho, vUsarColor, "verde"))
  else:
    for aAcelerador in aAceleradores:
      vNombre = "GPU " + str(aAcelerador["index"])
      aMemoria = aAcelerador["memoria"]

      if aMemoria is not None and aMemoria.get("backend") == "NVIDIA":
        vNombre += " NVIDIA"
      elif aMemoria is not None and aMemoria.get("backend") == "AMD":
        vNombre += " AMD"

      print(fFila(vNombre + " memoria usada", aAcelerador["nombre_memoria_legible"], vAncho, vUsarColor, "cyan"))
      print(fFilaBarra(vNombre + " requerido", aAcelerador["requerido"] + vReservaMinimaBytes, aAcelerador["libre"], vAncho, vUsarColor))
      print(fFila(vNombre + " libre", fFormatoGiB(aAcelerador["libre"]), vAncho, vUsarColor, "verde"))

      if aMemoria is not None:
        if aMemoria.get("backend") == "NVIDIA":
          print(fFila(vNombre + " total VRAM", fFormatoGiB(aMemoria.get("total_vram")), vAncho, vUsarColor))
        elif aMemoria.get("backend") == "AMD":
          print(fFila(vNombre + " VRAM visible libre", fFormatoGiB(aMemoria.get("free_visible_vram")), vAncho, vUsarColor))
          print(fFila(vNombre + " RAM sistema mapeada GPU", fFormatoGiB(aMemoria.get("free_gtt")), vAncho, vUsarColor))

    print(fFilaBarra("Uso modelo en RAM", vRequeridoRAMConReserva, vMemAvailable, vAncho, vUsarColor))
    print(fFila("RAM disponible del sistema", fFormatoGiB(vMemAvailable), vAncho, vUsarColor, "verde"))

  print(fSeparador(vAncho))

  vColorEstadoAcelerador = "verde" if vCabeAcelerador else "rojo"
  vColorEstadoRAM = "verde" if vCabeRAM else "rojo"

  print(fFila("Estado acelerador", fEstado(vCabeAcelerador), vAncho, vUsarColor, vColorEstadoAcelerador))
  print(fFila("Estado RAM sistema", fEstado(vCabeRAM), vAncho, vUsarColor, vColorEstadoRAM))

  vMargenRAM = vMemAvailable - vRequeridoRAMConReserva
  vColorMargenRAM = "verde" if vMargenRAM >= 0 else "rojo"
  print(fFila("Margen RAM", fFormatoGiB(vMargenRAM), vAncho, vUsarColor, vColorMargenRAM))

  for aAcelerador in aAceleradores:
    if aAcelerador["libre"] is not None:
      vMargen = aAcelerador["libre"] - aAcelerador["requerido"] - vReservaMinimaBytes
      vColorMargen = "verde" if vMargen >= 0 else "rojo"
      print(fFila("Margen GPU " + str(aAcelerador["index"]), fFormatoGiB(vMargen), vAncho, vUsarColor, vColorMargen))

  if len(aAvisos) > 0:
    print(fSeparador(vAncho))

    for vAviso in aAvisos:
      print(fFila("Aviso", vAviso, vAncho, vUsarColor, "amarillo"))

  print(fPie(vAncho))


def fCrearComandoLlamaServer(vArgumentos, aPesosModelo, aPesosDraft, vHelp):
  aComando = [
    vArgumentos.llama_server,
    "--host",
    vArgumentos.host,
    "--port",
    str(vArgumentos.port)
  ]

  aAvisos = []

  if vArgumentos.device:
    fAgregarOpcion(aComando, vHelp, ["--device", "-dev"], [vArgumentos.device], aAvisos)

  if str(vArgumentos.ngl).lower() != "auto":
    fAgregarOpcion(aComando, vHelp, ["--n-gpu-layers", "--gpu-layers", "-ngl"], [aPesosModelo["capas_gpu"]], aAvisos)

  if vArgumentos.ctx_size is not None:
    fAgregarOpcion(aComando, vHelp, ["--ctx-size", "-c"], [vArgumentos.ctx_size], aAvisos)

  if vArgumentos.parallel is not None:
    fAgregarOpcion(aComando, vHelp, ["--parallel", "-np"], [vArgumentos.parallel], aAvisos)

  if vArgumentos.cache_ram is not None:
    fAgregarOpcion(aComando, vHelp, ["--cache-ram", "-cram"], [vArgumentos.cache_ram], aAvisos)

  if vArgumentos.cache_type_k is not None:
    fAgregarOpcion(aComando, vHelp, ["--cache-type-k", "-ctk"], [vArgumentos.cache_type_k], aAvisos)

  if vArgumentos.cache_type_v is not None:
    fAgregarOpcion(aComando, vHelp, ["--cache-type-v", "-ctv"], [vArgumentos.cache_type_v], aAvisos)

  if vArgumentos.kv_offload == "on":
    fAgregarBooleano(aComando, vHelp, ["--kv-offload", "-kvo"], aAvisos)
  elif vArgumentos.kv_offload == "off":
    fAgregarBooleano(aComando, vHelp, ["--no-kv-offload", "-nkvo"], aAvisos)

  if vArgumentos.split_mode is not None:
    fAgregarOpcion(aComando, vHelp, ["--split-mode", "-sm"], [vArgumentos.split_mode], aAvisos)

  if vArgumentos.tensor_split is not None:
    fAgregarOpcion(aComando, vHelp, ["--tensor-split", "-ts"], [vArgumentos.tensor_split], aAvisos)

  if vArgumentos.main_gpu is not None:
    fAgregarOpcion(aComando, vHelp, ["--main-gpu", "-mg"], [vArgumentos.main_gpu], aAvisos)

  if vArgumentos.fit is not None:
    fAgregarOpcion(aComando, vHelp, ["--fit", "-fit"], [vArgumentos.fit], aAvisos)

  if vArgumentos.fit_target is not None:
    fAgregarOpcion(aComando, vHelp, ["--fit-target", "-fitt"], [vArgumentos.fit_target], aAvisos)

  if vArgumentos.fit_ctx is not None:
    fAgregarOpcion(aComando, vHelp, ["--fit-ctx", "-fitc"], [vArgumentos.fit_ctx], aAvisos)

  if vArgumentos.cpu_moe:
    fAgregarBooleano(aComando, vHelp, ["--cpu-moe", "-cmoe"], aAvisos)

  if vArgumentos.n_cpu_moe is not None:
    fAgregarOpcion(aComando, vHelp, ["--n-cpu-moe", "-ncmoe"], [vArgumentos.n_cpu_moe], aAvisos)

  if vArgumentos.no_warmup:
    fAgregarBooleano(aComando, vHelp, ["--no-warmup"], aAvisos)

  if vArgumentos.model_draft is not None:
    fAgregarOpcion(aComando, vHelp, ["--model-draft", "--spec-draft-model", "-md"], [vArgumentos.model_draft], aAvisos)

    if vArgumentos.device_draft:
      fAgregarOpcion(aComando, vHelp, ["--device-draft", "--spec-draft-device", "-devd"], [vArgumentos.device_draft], aAvisos)

    if str(vArgumentos.ngl_draft).lower() != "auto" and aPesosDraft is not None:
      fAgregarOpcion(aComando, vHelp, ["--n-gpu-layers-draft", "--gpu-layers-draft", "--spec-draft-ngl", "-ngld"], [aPesosDraft["capas_gpu"]], aAvisos)

    if vArgumentos.cpu_moe_draft:
      fAgregarBooleano(aComando, vHelp, ["--cpu-moe-draft", "--spec-draft-cpu-moe", "-cmoed"], aAvisos)

    if vArgumentos.n_cpu_moe_draft is not None:
      fAgregarOpcion(aComando, vHelp, ["--n-cpu-moe-draft", "--spec-draft-n-cpu-moe", "-ncmoed"], [vArgumentos.n_cpu_moe_draft], aAvisos)

    if vArgumentos.spec_type is not None:
      fAgregarOpcion(aComando, vHelp, ["--spec-type"], [vArgumentos.spec_type], aAvisos)

    if vArgumentos.spec_draft_n_max is not None:
      fAgregarOpcion(aComando, vHelp, ["--spec-draft-n-max"], [vArgumentos.spec_draft_n_max], aAvisos)

  aComando.extend([
    "-m",
    vArgumentos.modelo
  ])

  aComando.extend(vArgumentos.argumentos_extra)

  return aComando, aAvisos


def fCrearParser():
  vParser = argparse.ArgumentParser(
    description="Comprueba si un modelo GGUF cabe antes de lanzar llama-server. Incluye KV cache, MoE, draft model, NVIDIA, AMD y multi-GPU."
  )

  vParser.add_argument(
    "modelo",
    nargs="?",
    help="Ruta al archivo .gguf"
  )

  vParser.add_argument(
    "--llama-server",
    default="/home/nipegun/IA/LlamaCPP/bin/llama-server",
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
    help="Dispositivo llama.cpp. Usa --device none para no pasar --device."
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
    "--cache-ram",
    type=int,
    default=0,
    help="Prompt cache de llama-server en MiB. 0 para desactivar."
  )

  vParser.add_argument(
    "--cache-type-k",
    choices=sorted(cTiposKVBytes.keys()),
    default="f16"
  )

  vParser.add_argument(
    "--cache-type-v",
    choices=sorted(cTiposKVBytes.keys()),
    default="f16"
  )

  vParser.add_argument(
    "--kv-offload",
    choices=["on", "off", "auto"],
    default="on",
    help="on/off/auto. auto no pasa flag y estima como on."
  )

  vParser.add_argument(
    "--split-mode",
    choices=["none", "layer", "row", "tensor"],
    default="layer"
  )

  vParser.add_argument(
    "--tensor-split",
    default=None,
    help="Proporciones tipo 3,1 o 1,1."
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
    help="Margen MiB por dispositivo para --fit. Ejemplo: 1024 o 1024,2048."
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
    help="Margen porcentual para buffers, driver, Vulkan/CUDA y temporales."
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


def fParsearArgumentos():
  vParser = fCrearParser()
  vArgumentos, aArgumentosExtra = vParser.parse_known_args()

  if len(aArgumentosExtra) > 0 and aArgumentosExtra[0] == "--":
    aArgumentosExtra = aArgumentosExtra[1:]

  if vArgumentos.device == "none":
    vArgumentos.device = None

  if vArgumentos.gpu_index is not None:
    vArgumentos.gpu_indexes = str(vArgumentos.gpu_index)

  vArgumentos.argumentos_extra = aArgumentosExtra

  return vArgumentos


def fEjecutarListDevices(vRutaLlamaServer):
  aProceso = fEjecutar([vRutaLlamaServer, "--list-devices"], 10)

  if aProceso is None:
    print("Error: no se pudo ejecutar llama-server --list-devices", file=sys.stderr)
    return 1

  if aProceso.stdout:
    print(aProceso.stdout.rstrip())

  if aProceso.stderr:
    print(aProceso.stderr.rstrip(), file=sys.stderr)

  return aProceso.returncode


def fMain():
  vArgumentos = fParsearArgumentos()

  if vArgumentos.list_devices:
    return fEjecutarListDevices(vArgumentos.llama_server)

  if vArgumentos.modelo is None:
    print("Error: falta la ruta del modelo GGUF", file=sys.stderr)
    return 1

  vHelp = None

  if not vArgumentos.no_validar_flags:
    vHelp = fObtenerHelpLlamaServer(vArgumentos.llama_server)

  aResultadoGGUF = fCargarGGUF(vArgumentos.modelo, "del modelo")

  if aResultadoGGUF is None:
    return 1

  fConfigurarContextoPorDefecto(vArgumentos, aResultadoGGUF)

  aPesosModelo = fCalcularPesosModelo(aResultadoGGUF, vArgumentos.ngl, vArgumentos.cpu_moe, vArgumentos.n_cpu_moe)
  aKVModelo = fCalcularBytesKVCache(aResultadoGGUF, vArgumentos.ctx_size, vArgumentos.parallel, vArgumentos.cache_type_k, vArgumentos.cache_type_v)

  aResultadoDraft = None
  aPesosDraft = None
  aKVDraft = {
    "bytes": 0,
    "estimado": True,
    "motivo": "sin draft model"
  }

  if vArgumentos.model_draft is not None:
    aResultadoDraft = fCargarGGUF(vArgumentos.model_draft, "del draft model")

    if aResultadoDraft is None:
      return 1

    aPesosDraft = fCalcularPesosModelo(aResultadoDraft, vArgumentos.ngl_draft, vArgumentos.cpu_moe_draft, vArgumentos.n_cpu_moe_draft)
    aKVDraft = fCalcularBytesKVCache(aResultadoDraft, vArgumentos.ctx_size, vArgumentos.parallel, vArgumentos.cache_type_k, vArgumentos.cache_type_v)

  vMemAvailable = fObtenerMemAvailableBytes()
  vMemTotal = fObtenerMemTotalBytes()
  aGpuIndexes = fParsearListaEnteros(vArgumentos.gpu_indexes)

  if len(aGpuIndexes) == 0:
    aGpuIndexes = [0]

  aAceleradores = fObtenerAceleradores(vArgumentos.backend, aGpuIndexes)

  vKVOffloadActivo = vArgumentos.kv_offload in ["on", "auto"]
  vBytesModeloGPU = aPesosModelo["bytes_gpu"]
  vBytesModeloCPU = aPesosModelo["bytes_cpu"]
  vBytesKVGPU = 0
  vBytesKVRAM = 0

  if vKVOffloadActivo:
    vBytesKVGPU += aKVModelo["bytes"]
  else:
    vBytesKVRAM += aKVModelo["bytes"]

  if aPesosDraft is not None:
    vBytesModeloGPU += aPesosDraft["bytes_gpu"]
    vBytesModeloCPU += aPesosDraft["bytes_cpu"]

    if vKVOffloadActivo:
      vBytesKVGPU += aKVDraft["bytes"]
    else:
      vBytesKVRAM += aKVDraft["bytes"]

  vOverheadPercent = vArgumentos.overhead_percent / 100
  vOverheadBytes = int((vBytesModeloGPU + vBytesKVGPU) * vOverheadPercent) + fGiBABBytes(vArgumentos.overhead_gib)
  vReservaMinimaBytes = fGiBABBytes(vArgumentos.min_free_gib)

  vRequeridoAceleradorTotal = vBytesModeloGPU + vBytesKVGPU + vOverheadBytes
  vRequeridoAceleradorConReservaTotal = vRequeridoAceleradorTotal + (vReservaMinimaBytes * len(aAceleradores))

  fDistribuirRequerimientoAcelerador(
    aAceleradores,
    vBytesModeloGPU + vOverheadBytes,
    vBytesKVGPU,
    vArgumentos.split_mode,
    vArgumentos.tensor_split,
    vArgumentos.main_gpu
  )

  vCacheRAMBytes = fMiBABBytes(vArgumentos.cache_ram)
  vRequeridoRAM = int((vBytesModeloCPU + vBytesKVRAM) * 1.10) + vCacheRAMBytes
  vRequeridoRAMConReserva = vRequeridoRAM + vReservaMinimaBytes

  vCabeAcelerador = True
  vCabeRAM = True
  aAvisos = []

  if vBytesModeloGPU + vBytesKVGPU > 0:
    for aAcelerador in aAceleradores:
      if aAcelerador["libre"] is None:
        vCabeAcelerador = False
        aAvisos.append("No se pudo obtener memoria libre de GPU " + str(aAcelerador["index"]))
      elif aAcelerador["requerido"] + vReservaMinimaBytes > aAcelerador["libre"]:
        vCabeAcelerador = False

  if vRequeridoRAMConReserva > vMemAvailable:
    vCabeRAM = False

  fAgregarAvisoContextoDemasiadoGrande(
    aAvisos,
    vArgumentos,
    vCabeAcelerador,
    vCabeRAM,
    aAceleradores,
    vKVOffloadActivo,
    vBytesKVGPU,
    vBytesKVRAM,
    vBytesModeloGPU,
    vBytesModeloCPU,
    vOverheadPercent,
    fGiBABBytes(vArgumentos.overhead_gib),
    vReservaMinimaBytes,
    vMemAvailable,
    vCacheRAMBytes
  )

  aComando, aAvisosComando = fCrearComandoLlamaServer(vArgumentos, aPesosModelo, aPesosDraft, vHelp)
  aAvisos.extend(aAvisosComando)

  if vArgumentos.ngl == "auto":
    aAvisos.append("--ngl auto no se pasa al comando porque llama.cpp ya usa auto por defecto; la estimación asume todas las capas posibles en GPU.")

  if not aKVModelo["estimado"]:
    aAvisos.append("KV cache principal no pudo estimarse con metadata suficiente; puede faltar memoria real.")

  if aResultadoDraft is not None and not aKVDraft["estimado"]:
    aAvisos.append("KV cache draft no pudo estimarse con metadata suficiente; puede faltar memoria real.")

  fMostrarResumenBonito(
    vArgumentos,
    aResultadoGGUF,
    aPesosModelo,
    aKVModelo,
    aResultadoDraft,
    aPesosDraft,
    aKVDraft,
    vMemAvailable,
    vMemTotal,
    aAceleradores,
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

    for aAcelerador in aAceleradores:
      if aAcelerador["libre"] is not None:
        vFaltan = aAcelerador["requerido"] + vReservaMinimaBytes - aAcelerador["libre"]

        if vFaltan > 0:
          print("Faltan en GPU " + str(aAcelerador["index"]) + ": " + fFormatoGiB(vFaltan))

  if not vCabeRAM:
    vFaltan = vRequeridoRAMConReserva - vMemAvailable
    print("Resultado: NO CABE en RAM del sistema")
    print("Faltan en RAM: " + fFormatoGiB(vFaltan))

  if vCabeAcelerador and vCabeRAM:
    print("Resultado: CABE según la estimación")
  elif vArgumentos.force:
    print("Resultado: SE LANZA FORZADO aunque la estimación dice que no cabe")

  print("Comando final:")
  print(" ".join(shlex.quote(vArg) for vArg in aComando))

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

  try:
    os.execv(aComando[0], aComando)
  except OSError as vError:
    print("Error al ejecutar llama-server: " + str(vError), file=sys.stderr)
    return 1

  return 0


if __name__ == "__main__":
  sys.exit(fMain())
