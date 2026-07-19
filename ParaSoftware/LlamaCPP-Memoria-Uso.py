#!/usr/bin/env python3

# Ejecución remota
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/LlamaCPP-Memoria-Uso.py | python3 - [ArchivoGGUF]

import argparse
import csv
import datetime
import io
import json
import os
import re
import shutil
import subprocess
import sys
import time
from pathlib import Path


cKiB = 1024
cMiB = 1024 ** 2
cGiB = 1024 ** 3
cVersion = "1.2"


def fLeerTexto(pRuta):
  try:
    return Path(pRuta).read_text(encoding="utf-8", errors="replace")
  except (FileNotFoundError, PermissionError, ProcessLookupError, OSError):
    return ""


def fEjecutar(pComando):
  try:
    vResultado = subprocess.run(
      pComando,
      stdout=subprocess.PIPE,
      stderr=subprocess.PIPE,
      text=True,
      check=False,
      timeout=10,
    )
  except (FileNotFoundError, subprocess.TimeoutExpired, OSError):
    return 127, ""

  return vResultado.returncode, vResultado.stdout


def fConvertirCantidad(pTexto):
  vCoincidencia = re.search(
    r"(-?[0-9]+(?:[.,][0-9]+)?)\s*(B|KB|KiB|MB|MiB|GB|GiB)?",
    str(pTexto),
    re.IGNORECASE,
  )
  if not vCoincidencia:
    return 0

  vCantidad = float(vCoincidencia.group(1).replace(",", "."))
  vUnidad = (vCoincidencia.group(2) or "B").lower()
  dMultiplicadores = {
    "b": 1,
    "kb": 1000,
    "kib": cKiB,
    "mb": 1000 ** 2,
    "mib": cMiB,
    "gb": 1000 ** 3,
    "gib": cGiB,
  }
  return max(0, int(vCantidad * dMultiplicadores[vUnidad]))


def fFormatearBytes(pBytes):
  vBytes = max(0, int(pBytes))
  if vBytes >= cGiB:
    return f"{vBytes / cGiB:.3f} GiB"
  if vBytes >= cMiB:
    return f"{vBytes / cMiB:.2f} MiB"
  if vBytes >= cKiB:
    return f"{vBytes / cKiB:.2f} KiB"
  return f"{vBytes} B"


def fObtenerCmdline(pPid):
  vDatos = b""
  try:
    vDatos = Path(f"/proc/{pPid}/cmdline").read_bytes()
  except (FileNotFoundError, PermissionError, ProcessLookupError, OSError):
    return []

  return [vParte.decode("utf-8", errors="replace") for vParte in vDatos.split(b"\0") if vParte]


def fObtenerNombreProceso(pPid):
  aCmdline = fObtenerCmdline(pPid)
  if aCmdline:
    return " ".join(aCmdline)

  return fLeerTexto(f"/proc/{pPid}/comm").strip()


def fObtenerEjecutable(pPid):
  try:
    return os.readlink(f"/proc/{pPid}/exe")
  except (FileNotFoundError, PermissionError, ProcessLookupError, OSError):
    return ""


def fEsEjecutableLlamaCpp(pRuta):
  if not pRuta:
    return False

  vNombre = Path(pRuta).name.lower()
  return vNombre == "llama" or vNombre.startswith("llama-")


def fEsProcesoLlamaCpp(pPid, pCmdline, pComm):
  aCandidatos = [
    fObtenerEjecutable(pPid),
    pCmdline[0] if pCmdline else "",
    pComm,
  ]

  return any(fEsEjecutableLlamaCpp(vCandidato) for vCandidato in aCandidatos)


def fBuscarProcesos(pPatron):
  aProcesos = []
  vPatron = pPatron.lower() if pPatron else ""
  vPidPropio = os.getpid()

  for vEntrada in Path("/proc").iterdir():
    if not vEntrada.name.isdigit():
      continue

    vPid = int(vEntrada.name)
    if vPid == vPidPropio:
      continue

    aCmdline = fObtenerCmdline(vPid)
    vComm = fLeerTexto(f"/proc/{vPid}/comm").strip()

    if pPatron:
      vTexto = " ".join([vComm] + aCmdline).lower()
      if vPatron not in vTexto:
        continue
    elif not fEsProcesoLlamaCpp(vPid, aCmdline, vComm):
      continue

    aProcesos.append({
      "pid": vPid,
      "nombre": " ".join(aCmdline) if aCmdline else vComm,
    })

  return sorted(aProcesos, key=lambda pProceso: pProceso["pid"])


def fSeleccionarPid(pPid, pPatron):
  if pPid is not None:
    if not Path(f"/proc/{pPid}").exists():
      raise RuntimeError(f"No existe el PID {pPid}.")
    return pPid

  aProcesos = fBuscarProcesos(pPatron)
  if not aProcesos:
    if pPatron:
      raise RuntimeError(
        f"No se encontró ningún proceso que contenga '{pPatron}'. Usa --pid para indicarlo."
      )
    raise RuntimeError(
      "No se encontró ningún ejecutable de llama.cpp. Usa --pid o --process para indicarlo."
    )

  if len(aProcesos) > 1:
    aLineas = ["Se encontraron varios procesos. Indica uno con --pid:"]
    for dProceso in aProcesos:
      aLineas.append(f"  PID {dProceso['pid']}: {dProceso['nombre']}")
    raise RuntimeError("\n".join(aLineas))

  return aProcesos[0]["pid"]


def fLeerValoresKb(pRuta):
  dValores = {}
  vTexto = fLeerTexto(pRuta)
  for vLinea in vTexto.splitlines():
    if ":" not in vLinea:
      continue

    vClave, vValor = vLinea.split(":", 1)
    vCoincidencia = re.search(r"([0-9]+)", vValor)
    if vCoincidencia:
      dValores[vClave.strip()] = int(vCoincidencia.group(1)) * cKiB

  return dValores


def fEsRutaModelo(pRuta, pModelosExplicitos):
  if not pRuta or pRuta.startswith("["):
    return False

  vRuta = pRuta.removesuffix(" (deleted)")
  try:
    vRutaNormalizada = str(Path(vRuta).resolve(strict=False))
  except OSError:
    vRutaNormalizada = vRuta

  if vRutaNormalizada.lower().endswith(".gguf"):
    return True

  for vModelo in pModelosExplicitos:
    try:
      vModeloNormalizado = str(Path(vModelo).resolve(strict=False))
    except OSError:
      vModeloNormalizado = vModelo
    if vRutaNormalizada == vModeloNormalizado:
      return True

  return False


def fAnalizarSmaps(pPid, pModelosExplicitos):
  vRuta = f"/proc/{pPid}/smaps"
  vTexto = fLeerTexto(vRuta)
  if not vTexto:
    return {
      "disponible": False,
      "modelos": {},
      "modelo_total": {},
      "rollup": {},
      "categorias": {},
    }

  dModelos = {}
  dRollup = {}
  dCategorias = {
    "anon": 0,
    "fichero": 0,
    "shmem": 0,
  }
  vRutaActual = ""
  dMapeoActual = {}

  def fClasificarMapeo(pRuta):
    if not pRuta:
      return "anon"

    vRutaMinuscula = pRuta.lower()
    if (
      pRuta.startswith("[heap]")
      or pRuta.startswith("[stack")
      or pRuta.startswith("[anon")
      or pRuta.startswith("[vdso]")
      or pRuta.startswith("[vvar")
      or pRuta.startswith("[vsyscall]")
    ):
      return "anon"

    if (
      vRutaMinuscula.startswith("/dev/shm/")
      or vRutaMinuscula.startswith("/memfd:")
      or "sysv" in vRutaMinuscula
      or pRuta.startswith("[shmem")
    ):
      return "shmem"

    return "fichero"

  def fGuardarMapeo():
    if not dMapeoActual:
      return

    for vClave, vValor in dMapeoActual.items():
      dRollup[vClave] = dRollup.get(vClave, 0) + vValor

    vCategoria = fClasificarMapeo(vRutaActual)
    dCategorias[vCategoria] += dMapeoActual.get("Pss", 0)

    if not fEsRutaModelo(vRutaActual, pModelosExplicitos):
      return

    dModelo = dModelos.setdefault(vRutaActual, {})
    for vClave, vValor in dMapeoActual.items():
      dModelo[vClave] = dModelo.get(vClave, 0) + vValor

  for vLinea in vTexto.splitlines():
    if re.match(r"^[0-9a-fA-F]+-[0-9a-fA-F]+\s", vLinea):
      fGuardarMapeo()
      aPartes = vLinea.split(None, 5)
      vRutaActual = aPartes[5] if len(aPartes) >= 6 else ""
      dMapeoActual = {}
      continue

    if ":" not in vLinea:
      continue

    vClave, vValor = vLinea.split(":", 1)
    vCoincidencia = re.search(r"([0-9]+)", vValor)
    if vCoincidencia:
      dMapeoActual[vClave.strip()] = int(vCoincidencia.group(1)) * cKiB

  fGuardarMapeo()

  dTotal = {}
  for dModelo in dModelos.values():
    for vClave, vValor in dModelo.items():
      dTotal[vClave] = dTotal.get(vClave, 0) + vValor

  return {
    "disponible": True,
    "modelos": dModelos,
    "modelo_total": dTotal,
    "rollup": dRollup,
    "categorias": dCategorias,
  }

def fObtenerMemoriaRam(pPid, pModelosExplicitos):
  dSmaps = fAnalizarSmaps(pPid, pModelosExplicitos)
  dRollup = fLeerValoresKb(f"/proc/{pPid}/smaps_rollup")
  if not dRollup:
    dRollup = dSmaps["rollup"]

  if not dRollup:
    raise RuntimeError(
      f"No se pudo leer /proc/{pPid}/smaps. Ejecuta el script como el mismo usuario o con sudo."
    )

  dModelo = dSmaps["modelo_total"]
  dCategorias = dSmaps["categorias"]

  vPss = dRollup.get("Pss", 0)
  vRss = dRollup.get("Rss", 0)
  vPssAnon = dRollup.get("Pss_Anon", dCategorias.get("anon", 0))
  vPssFichero = dRollup.get("Pss_File", dCategorias.get("fichero", 0))
  vPssShmem = dRollup.get("Pss_Shmem", dCategorias.get("shmem", 0))
  vModeloPss = dModelo.get("Pss", 0)
  vOtrosFicheros = max(0, vPssFichero - vModeloPss)

  vPrivada = (
    dRollup.get("Private_Clean", 0)
    + dRollup.get("Private_Dirty", 0)
    + dRollup.get("Private_Hugetlb", 0)
  )
  vCompartida = (
    dRollup.get("Shared_Clean", 0)
    + dRollup.get("Shared_Dirty", 0)
    + dRollup.get("Shared_Hugetlb", 0)
  )

  dModelos = {}
  for vRutaModelo, dDatosModelo in dSmaps["modelos"].items():
    dDatos = dict(dDatosModelo)
    vRutaReal = vRutaModelo.removesuffix(" (deleted)")
    try:
      dDatos["tamano_archivo"] = Path(vRutaReal).stat().st_size
    except (FileNotFoundError, PermissionError, OSError):
      dDatos["tamano_archivo"] = 0
    dModelos[vRutaModelo] = dDatos

  return {
    "pss": vPss,
    "rss": vRss,
    "pss_anon": vPssAnon,
    "pss_fichero": vPssFichero,
    "pss_shmem": vPssShmem,
    "privada": vPrivada,
    "compartida": vCompartida,
    "swap_pss": dRollup.get("SwapPss", 0),
    "swap": dRollup.get("Swap", 0),
    "modelo_pss": vModeloPss,
    "modelo_rss": dModelo.get("Rss", 0),
    "modelo_virtual": dModelo.get("Size", 0),
    "otros_ficheros_pss": vOtrosFicheros,
    "resto_no_modelo_pss": max(0, vPss - vModeloPss),
    "modelos": dModelos,
    "smaps_disponible": dSmaps["disponible"],
  }

def fLeerDrmFdinfo(pPid):
  vDirectorio = Path(f"/proc/{pPid}/fdinfo")
  dClientes = {}

  try:
    aEntradas = list(vDirectorio.iterdir())
  except (FileNotFoundError, PermissionError, ProcessLookupError, OSError):
    return {
      "disponible": False,
      "vram": 0,
      "sistema_gpu": 0,
      "dispositivos": [],
      "drivers": [],
    }

  for vEntrada in aEntradas:
    vTexto = fLeerTexto(vEntrada)
    if "drm-driver:" not in vTexto:
      continue

    dCampos = {}
    for vLinea in vTexto.splitlines():
      if ":" not in vLinea:
        continue
      vClave, vValor = vLinea.split(":", 1)
      dCampos[vClave.strip()] = vValor.strip()

    vDriver = dCampos.get("drm-driver", "drm")
    vPdev = dCampos.get("drm-pdev", "sin-pci")
    vCliente = dCampos.get("drm-client-id", vEntrada.name)
    vIdCliente = f"{vDriver}|{vPdev}|{vCliente}"
    dCliente = dClientes.setdefault(vIdCliente, {
      "driver": vDriver,
      "pdev": vPdev,
      "regiones": {},
    })

    dResidentes = {}
    dMemoriaAntigua = {}
    for vClave, vValor in dCampos.items():
      if vClave.startswith("drm-resident-"):
        vRegion = vClave.removeprefix("drm-resident-")
        dResidentes[vRegion] = fConvertirCantidad(vValor)
      elif vClave.startswith("drm-memory-"):
        vRegion = vClave.removeprefix("drm-memory-")
        dMemoriaAntigua[vRegion] = fConvertirCantidad(vValor)

    dRegiones = dict(dMemoriaAntigua)
    dRegiones.update(dResidentes)
    for vRegion, vBytes in dRegiones.items():
      dCliente["regiones"][vRegion] = max(
        dCliente["regiones"].get(vRegion, 0),
        vBytes,
      )

  dPorDispositivo = {}
  aDrivers = []
  for dCliente in dClientes.values():
    vClaveGpu = f"{dCliente['driver']} {dCliente['pdev']}"
    dGpu = dPorDispositivo.setdefault(vClaveGpu, {
      "gpu": vClaveGpu,
      "vram": 0,
      "sistema_gpu": 0,
    })
    if dCliente["driver"] not in aDrivers:
      aDrivers.append(dCliente["driver"])

    for vRegion, vBytes in dCliente["regiones"].items():
      vRegionMinuscula = vRegion.lower()
      if "vram" in vRegionMinuscula:
        dGpu["vram"] += vBytes
      else:
        dGpu["sistema_gpu"] += vBytes

  aDispositivos = list(dPorDispositivo.values())
  return {
    "disponible": bool(dClientes),
    "vram": sum(dGpu["vram"] for dGpu in aDispositivos),
    "sistema_gpu": sum(dGpu["sistema_gpu"] for dGpu in aDispositivos),
    "dispositivos": aDispositivos,
    "drivers": aDrivers,
  }


def fMapaNvidia():
  dMapa = {}
  vCodigo, vSalida = fEjecutar([
    "nvidia-smi",
    "--query-gpu=index,uuid,name",
    "--format=csv,noheader,nounits",
  ])
  if vCodigo != 0:
    return dMapa

  for aFila in csv.reader(io.StringIO(vSalida)):
    if len(aFila) < 3:
      continue
    vIndice = aFila[0].strip()
    vUuid = aFila[1].strip()
    vNombre = aFila[2].strip()
    dMapa[vUuid] = f"GPU {vIndice}: {vNombre}"

  return dMapa


def fNvidiaCompute(pPid):
  if shutil.which("nvidia-smi") is None:
    return None

  vCodigo, vSalida = fEjecutar([
    "nvidia-smi",
    "--query-compute-apps=pid,gpu_uuid,used_memory",
    "--format=csv,noheader,nounits",
  ])
  if vCodigo != 0:
    return None

  dMapa = fMapaNvidia()
  dPorGpu = {}
  for aFila in csv.reader(io.StringIO(vSalida)):
    if len(aFila) < 3:
      continue
    try:
      vPid = int(aFila[0].strip())
    except ValueError:
      continue
    if vPid != pPid:
      continue

    vUuid = aFila[1].strip()
    try:
      vMemoria = int(float(aFila[2].strip())) * cMiB
    except ValueError:
      continue

    vGpu = dMapa.get(vUuid, vUuid)
    dPorGpu[vGpu] = dPorGpu.get(vGpu, 0) + vMemoria

  if not dPorGpu:
    return None

  return {
    "disponible": True,
    "fuente": "nvidia-smi --query-compute-apps",
    "vram": sum(dPorGpu.values()),
    "sistema_gpu": 0,
    "dispositivos": [
      {"gpu": vGpu, "vram": vBytes, "sistema_gpu": 0}
      for vGpu, vBytes in dPorGpu.items()
    ],
    "drivers": ["nvidia"],
  }


def fNvidiaPmon(pPid):
  if shutil.which("nvidia-smi") is None:
    return None

  vCodigo, vSalida = fEjecutar(["nvidia-smi", "pmon", "-s", "m", "-c", "1"])
  if vCodigo != 0:
    return None

  dPorGpu = {}
  for vLinea in vSalida.splitlines():
    vLinea = vLinea.strip()
    if not vLinea or vLinea.startswith("#"):
      continue

    aPartes = vLinea.split()
    if len(aPartes) < 5:
      continue

    try:
      vGpu = int(aPartes[0])
      vPid = int(aPartes[1])
    except ValueError:
      continue

    if vPid != pPid or aPartes[3] == "-":
      continue

    try:
      vMemoria = int(float(aPartes[3])) * cMiB
    except ValueError:
      continue

    dPorGpu[vGpu] = max(dPorGpu.get(vGpu, 0), vMemoria)

  if not dPorGpu:
    return None

  return {
    "disponible": True,
    "fuente": "nvidia-smi pmon",
    "vram": sum(dPorGpu.values()),
    "sistema_gpu": 0,
    "dispositivos": [
      {"gpu": f"GPU {vGpu}", "vram": vBytes, "sistema_gpu": 0}
      for vGpu, vBytes in sorted(dPorGpu.items())
    ],
  }


def fNvidiaTabla(pPid):
  if shutil.which("nvidia-smi") is None:
    return None

  vCodigo, vSalida = fEjecutar(["nvidia-smi"])
  if vCodigo != 0:
    return None

  dPorGpu = {}
  for vLinea in vSalida.splitlines():
    if not vLinea.lstrip().startswith("|"):
      continue

    aPartes = vLinea.replace("|", " ").split()
    if str(pPid) not in aPartes:
      continue

    vCoincidenciaMemoria = re.search(r"([0-9]+)\s*MiB\s*\|?\s*$", vLinea)
    if not vCoincidenciaMemoria:
      continue

    try:
      vGpu = int(aPartes[0])
    except (ValueError, IndexError):
      vGpu = len(dPorGpu)

    vMemoria = int(vCoincidenciaMemoria.group(1)) * cMiB
    dPorGpu[vGpu] = max(dPorGpu.get(vGpu, 0), vMemoria)

  if not dPorGpu:
    return None

  return {
    "disponible": True,
    "fuente": "tabla de procesos de nvidia-smi",
    "vram": sum(dPorGpu.values()),
    "sistema_gpu": 0,
    "dispositivos": [
      {"gpu": f"GPU {vGpu}", "vram": vBytes, "sistema_gpu": 0}
      for vGpu, vBytes in sorted(dPorGpu.items())
    ],
  }


def fExtraerJson(pTexto):
  aPosiciones = [vPos for vPos in (pTexto.find("["), pTexto.find("{")) if vPos >= 0]
  if not aPosiciones:
    return None

  vInicio = min(aPosiciones)
  try:
    vObjeto, _ = json.JSONDecoder().raw_decode(pTexto[vInicio:])
  except json.JSONDecodeError:
    return None
  return vObjeto


def fExtraerMemoriaAmd(pObjeto, pPid, pResultados):
  if isinstance(pObjeto, dict):
    vPid = pObjeto.get("pid")
    try:
      vCoincide = int(vPid) == pPid
    except (TypeError, ValueError):
      vCoincide = False

    if vCoincide:
      dMemoria = pObjeto.get("mem_usage")
      if isinstance(dMemoria, dict):
        vValor = dMemoria.get("value", 0)
        vUnidad = dMemoria.get("unit", "B")
        pResultados.append(fConvertirCantidad(f"{vValor} {vUnidad}"))
      elif dMemoria is not None:
        pResultados.append(fConvertirCantidad(dMemoria))

    for vValor in pObjeto.values():
      fExtraerMemoriaAmd(vValor, pPid, pResultados)

  elif isinstance(pObjeto, list):
    for vElemento in pObjeto:
      fExtraerMemoriaAmd(vElemento, pPid, pResultados)


def fAmdSmi(pPid):
  if shutil.which("amd-smi") is None:
    return None

  vCodigo, vSalida = fEjecutar([
    "amd-smi",
    "process",
    "--pid",
    str(pPid),
    "--general",
    "--json",
  ])
  if vCodigo != 0:
    return None

  vObjeto = fExtraerJson(vSalida)
  if vObjeto is None:
    return None

  aMemorias = []
  fExtraerMemoriaAmd(vObjeto, pPid, aMemorias)
  if not aMemorias:
    return None

  return {
    "disponible": True,
    "fuente": "amd-smi process",
    "vram": sum(aMemorias),
    "sistema_gpu": 0,
    "dispositivos": [
      {"gpu": f"GPU AMD {vIndice}", "vram": vBytes, "sistema_gpu": 0}
      for vIndice, vBytes in enumerate(aMemorias)
    ],
  }


def fResultadoDrm(pDrm):
  if not pDrm["disponible"] or (pDrm["vram"] == 0 and pDrm["sistema_gpu"] == 0):
    return None

  return {
    "disponible": True,
    "fuente": "/proc/PID/fdinfo (DRM)",
    "vram": pDrm["vram"],
    "sistema_gpu": pDrm["sistema_gpu"],
    "dispositivos": pDrm["dispositivos"],
    "drivers": pDrm.get("drivers", []),
  }


def fObtenerMemoriaGpu(pPid, pBackend):
  dDrm = fLeerDrmFdinfo(pPid)
  dDrmResultado = fResultadoDrm(dDrm)

  if pBackend == "cuda":
    dResultado = fNvidiaCompute(pPid)
    if dResultado is None:
      dResultado = fNvidiaPmon(pPid)
    if dResultado is None:
      dResultado = fNvidiaTabla(pPid)
    if dResultado is None:
      dResultado = dDrmResultado

  elif pBackend == "vulkan":
    if any("amdgpu" in vDriver for vDriver in dDrm["drivers"]):
      dResultado = dDrmResultado or fAmdSmi(pPid)
    else:
      dResultado = fNvidiaPmon(pPid)
      if dResultado is None:
        dResultado = fNvidiaTabla(pPid)
      if dResultado is None:
        dResultado = dDrmResultado
      if dResultado is None:
        dResultado = fAmdSmi(pPid)

  else:
    dResultado = dDrmResultado or fAmdSmi(pPid)

  if dResultado is None:
    return {
      "disponible": False,
      "fuente": "no disponible",
      "vram": 0,
      "sistema_gpu": 0,
      "dispositivos": [],
    }

  return dResultado


def fDetectarNoMmap(pCmdline):
  return "--no-mmap" in pCmdline


def fCrearEstimaciones(pRam, pGpu, pGpuUma):
  vRamGpu = pGpu.get("sistema_gpu", 0)
  if pGpuUma:
    vRamGpu += pGpu.get("vram", 0)
  vRamMinima = max(pRam["pss"], vRamGpu)
  vRamMaxima = pRam["pss"] + vRamGpu

  return {
    "ram_cpu_pss": pRam["pss"],
    "ram_gpu_sistema": vRamGpu,
    "gpu_uma": pGpuUma,
    "ram_fisica_minima": vRamMinima,
    "ram_fisica_maxima": vRamMaxima,
    "memoria_gpu_total": pGpu.get("vram", 0) + pGpu.get("sistema_gpu", 0),
  }


def fCrearInforme(pPid, pBackend, pModelosExplicitos, pGpuUma):
  aCmdline = fObtenerCmdline(pPid)
  dRam = fObtenerMemoriaRam(pPid, pModelosExplicitos)
  dGpu = fObtenerMemoriaGpu(pPid, pBackend)
  dEstimaciones = fCrearEstimaciones(dRam, dGpu, pGpuUma)

  return {
    "timestamp": datetime.datetime.now().isoformat(timespec="seconds"),
    "pid": pPid,
    "backend": pBackend,
    "comando": " ".join(aCmdline),
    "no_mmap": fDetectarNoMmap(aCmdline),
    "ram": dRam,
    "gpu": dGpu,
    "estimaciones": dEstimaciones,
  }


def fImprimirInforme(pInforme):
  dRam = pInforme["ram"]
  dGpu = pInforme["gpu"]
  dEstimaciones = pInforme["estimaciones"]

  print(f"Versión: {cVersion}")
  print(f"Fecha:   {pInforme['timestamp']}")
  print(f"PID:     {pInforme['pid']}")
  print(f"Backend: {pInforme['backend'].upper()}")
  print(f"Comando: {pInforme['comando']}")
  print("")
  print("RAM VISIBLE DESDE LA CPU")
  print(f"  PSS atribuible al proceso:          {fFormatearBytes(dRam['pss'])}")
  print(f"  RSS residente total:                {fFormatearBytes(dRam['rss'])}")
  print(f"  RSS privada:                        {fFormatearBytes(dRam['privada'])}")
  print(f"  RSS compartida:                     {fFormatearBytes(dRam['compartida'])}")
  print(f"  Swap proporcional:                  {fFormatearBytes(dRam['swap_pss'])}")
  print("")
  print("DESGLOSE DE LA RAM VISIBLE MEDIANTE PSS")
  print(f"  Parte del GGUF residente vía mmap:  {fFormatearBytes(dRam['modelo_pss'])}")
  print(f"  Memoria anónima:                    {fFormatearBytes(dRam['pss_anon'])}")
  print(f"  Ejecutable/bibliotecas/otros ficheros: {fFormatearBytes(dRam['otros_ficheros_pss'])}")
  print(f"  Memoria compartida shmem:           {fFormatearBytes(dRam['pss_shmem'])}")
  print(f"  Total no atribuible al GGUF:        {fFormatearBytes(dRam['resto_no_modelo_pss'])}")

  if dRam["modelos"]:
    print("")
    print("MODELOS MAPEADOS")
    for vRuta, dModelo in sorted(dRam["modelos"].items()):
      print(f"  {vRuta}")
      if dModelo.get("tamano_archivo", 0):
        print(f"    Tamaño del archivo:            {fFormatearBytes(dModelo['tamano_archivo'])}")
      print(f"    Porción mapeada por la CPU:    {fFormatearBytes(dModelo.get('Size', 0))}")
      print(f"    Porción residente en RAM CPU: {fFormatearBytes(dModelo.get('Rss', 0))}")
      print(f"    PSS atribuible en RAM CPU:    {fFormatearBytes(dModelo.get('Pss', 0))}")

  print("")
  print("MEMORIA DE GPU")
  if dGpu["disponible"]:
    print(f"  Fuente:                            {dGpu['fuente']}")
    print(f"  VRAM atribuida al proceso:         {fFormatearBytes(dGpu['vram'])}")
    print(f"  GTT/system usada por la GPU:       {fFormatearBytes(dGpu['sistema_gpu'])}")
    for dDispositivo in dGpu["dispositivos"]:
      print(
        f"  {dDispositivo['gpu']}: "
        f"VRAM {fFormatearBytes(dDispositivo['vram'])}, "
        f"system/GTT {fFormatearBytes(dDispositivo['sistema_gpu'])}"
      )
  else:
    print("  No se pudo obtener la VRAM por proceso con las interfaces disponibles.")

  print("")
  print("RESUMEN DE MEMORIA")
  print(f"  RAM visible desde CPU mediante PSS: {fFormatearBytes(dEstimaciones['ram_cpu_pss'])}")
  if dEstimaciones["ram_gpu_sistema"]:
    if dEstimaciones["gpu_uma"]:
      print(
        "  RAM usada por la GPU, VRAM+GTT:    "
        f"{fFormatearBytes(dEstimaciones['ram_gpu_sistema'])}"
      )
    else:
      print(
        "  RAM del sistema usada vía GTT:      "
        f"{fFormatearBytes(dEstimaciones['ram_gpu_sistema'])}"
      )
    print(
      "  RAM física total estimada:         "
      f"{fFormatearBytes(dEstimaciones['ram_fisica_minima'])} - "
      f"{fFormatearBytes(dEstimaciones['ram_fisica_maxima'])}"
    )
  else:
    print(f"  RAM física total estimada:         {fFormatearBytes(dEstimaciones['ram_fisica_maxima'])}")
  print(f"  Memoria administrada por la GPU:   {fFormatearBytes(dEstimaciones['memoria_gpu_total'])}")
  print("")
  print("INTERPRETACIÓN")
  print("  PSS solo contabiliza la memoria visible en el espacio de direcciones de la CPU.")
  print("  GTT es RAM del sistema administrada por el controlador gráfico para uso de la GPU.")
  if dEstimaciones["gpu_uma"]:
    print("  Se activó --gpu-uma: la región VRAM también se contabiliza como RAM física.")
  elif dGpu.get("vram", 0) and any("amdgpu" in dDriver for dDriver in dGpu.get("drivers", [])):
    print("  Si la GPU es una APU/UMA, repite con --gpu-uma para incluir la VRAM en la RAM física.")
  print("  El intervalo evita contar dos veces páginas GTT que también pudieran estar mapeadas por la CPU.")
  print("  La parte GGUF mostrada por smaps es únicamente la porción que continúa mapeada por la CPU.")
  print("  La memoria anónima incluye heap, KV cache, buffers de cálculo y estructuras internas.")
  print("  DRM no permite separar por sí solo modelo, KV cache y buffers dentro de VRAM/GTT.")
  if pInforme["no_mmap"]:
    print("  Se detectó --no-mmap: el modelo no puede separarse de la memoria anónima con precisión.")


def fSerializarJson(pObjeto):
  if isinstance(pObjeto, dict):
    return {vClave: fSerializarJson(vValor) for vClave, vValor in pObjeto.items()}
  if isinstance(pObjeto, list):
    return [fSerializarJson(vValor) for vValor in pObjeto]
  return pObjeto


def fCrearParser():
  vParser = argparse.ArgumentParser(
    description="Mide la RAM y VRAM utilizadas por un proceso de llama.cpp en Debian.",
  )
  vGrupo = vParser.add_mutually_exclusive_group(required=True)
  vGrupo.add_argument("--gpu-cuda", dest="backend", action="store_const", const="cuda")
  vGrupo.add_argument("--gpu-vulkan", dest="backend", action="store_const", const="vulkan")
  vGrupo.add_argument("--gpu-rocm", dest="backend", action="store_const", const="rocm")
  vParser.add_argument("--pid", type=int, help="PID exacto del proceso de llama.cpp.")
  vParser.add_argument(
    "--process",
    default=None,
    help=(
      "Texto que debe aparecer en el nombre o comando del proceso. "
      "Si se omite, detecta ejecutables llama-* y excluye ollama."
    ),
  )
  vParser.add_argument(
    "--model",
    action="append",
    default=[],
    help="Ruta adicional de modelo a contabilizar. Puede repetirse.",
  )
  vParser.add_argument(
    "--gpu-uma",
    action="store_true",
    help="Contabiliza como RAM física tanto GTT como la región VRAM de una APU/UMA.",
  )
  vParser.add_argument(
    "--watch",
    type=float,
    default=0,
    metavar="SEGUNDOS",
    help="Repite la medición cada N segundos.",
  )
  vParser.add_argument("--json", action="store_true", help="Genera la salida en JSON.")
  vParser.add_argument("--version", action="version", version=f"%(prog)s {cVersion}")
  return vParser


def fMain():
  vParser = fCrearParser()
  vArgs = vParser.parse_args()

  if vArgs.watch < 0:
    vParser.error("--watch no puede ser negativo.")

  try:
    vPid = fSeleccionarPid(vArgs.pid, vArgs.process)
    while True:
      dInforme = fCrearInforme(vPid, vArgs.backend, vArgs.model, vArgs.gpu_uma)

      if vArgs.watch > 0 and not vArgs.json and sys.stdout.isatty():
        print("\033[2J\033[H", end="")

      if vArgs.json:
        print(json.dumps(fSerializarJson(dInforme), indent=2, ensure_ascii=False))
      else:
        fImprimirInforme(dInforme)

      if vArgs.watch <= 0:
        break

      time.sleep(vArgs.watch)

  except KeyboardInterrupt:
    return 130
  except RuntimeError as vError:
    print(f"Error: {vError}", file=sys.stderr)
    return 1
  except ProcessLookupError:
    print(f"Error: el proceso PID {vPid} ha terminado.", file=sys.stderr)
    return 1

  return 0


if __name__ == "__main__":
  sys.exit(fMain())
