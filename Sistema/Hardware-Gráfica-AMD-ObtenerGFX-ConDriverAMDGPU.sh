#!/bin/bash

# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/Sistema/Hardware-Gr%C3%A1fica-AMD-ObtenerGFX-ConDriverAMDGPU.sh | bash

set -e

fEsGfxValido() {
  local vGfxName

  vGfxName="$1"

  case "${vGfxName}" in
    gfx000|gfx0|"")
      return 1
    ;;
    gfx[1-9]*)
      return 0
    ;;
    *)
      return 1
    ;;
  esac
}

fNormalizarGfx() {
  local vGfxName

  vGfxName="$1"
  vGfxName="$(echo "${vGfxName}" | grep -m 1 -oE 'gfx[0-9a-z]+' || true)"

  if fEsGfxValido "${vGfxName}"; then
    echo "${vGfxName}"
    return 0
  fi

  echo ""
}

fConvertirDecimalAHexUnDigito() {
  local vNumero

  vNumero="$1"

  case "${vNumero}" in
    0)
      echo "0"
    ;;
    1)
      echo "1"
    ;;
    2)
      echo "2"
    ;;
    3)
      echo "3"
    ;;
    4)
      echo "4"
    ;;
    5)
      echo "5"
    ;;
    6)
      echo "6"
    ;;
    7)
      echo "7"
    ;;
    8)
      echo "8"
    ;;
    9)
      echo "9"
    ;;
    10)
      echo "a"
    ;;
    11)
      echo "b"
    ;;
    12)
      echo "c"
    ;;
    13)
      echo "d"
    ;;
    14)
      echo "e"
    ;;
    15)
      echo "f"
    ;;
    *)
      echo ""
    ;;
  esac
}

fDetectarConSysfsIpDiscovery() {
  local vDispositivo
  local vRutaGc
  local vVendorId
  local vMajor
  local vMinor
  local vRevision
  local vRevisionHex
  local vGfxName

  for vDispositivo in /sys/class/drm/card*/device; do
    [ -e "${vDispositivo}" ] || continue
    [ -f "${vDispositivo}/vendor" ] || continue

    vVendorId="$(sed 's/^0x//' "${vDispositivo}/vendor")"

    [ "${vVendorId}" = "1002" ] || continue

    for vRutaGc in "${vDispositivo}"/ip_discovery/die/*/GC/*; do
      [ -d "${vRutaGc}" ] || continue
      [ -f "${vRutaGc}/major" ] || continue
      [ -f "${vRutaGc}/minor" ] || continue
      [ -f "${vRutaGc}/revision" ] || continue

      vMajor="$(cat "${vRutaGc}/major")"
      vMinor="$(cat "${vRutaGc}/minor")"
      vRevision="$(cat "${vRutaGc}/revision")"

      [ -n "${vMajor}" ] || continue
      [ -n "${vMinor}" ] || continue
      [ -n "${vRevision}" ] || continue

      vRevisionHex="$(fConvertirDecimalAHexUnDigito "${vRevision}")"

      [ -n "${vRevisionHex}" ] || continue

      vGfxName="gfx${vMajor}${vMinor}${vRevisionHex}"

      if fEsGfxValido "${vGfxName}"; then
        echo "${vGfxName}"
        return 0
      fi
    done
  done

  echo ""
}

fDetectarConRocmAgentEnumerator() {
  local vSalida
  local vLinea
  local vGfxName

  command -v rocm_agent_enumerator >/dev/null 2>&1 || {
    echo ""
    return 0
  }

  vSalida="$(rocm_agent_enumerator 2>/dev/null || true)"

  for vLinea in ${vSalida}; do
    vGfxName="$(fNormalizarGfx "${vLinea}")"

    if fEsGfxValido "${vGfxName}"; then
      echo "${vGfxName}"
      return 0
    fi
  done

  echo ""
}

fDetectarConRocmInfo() {
  local vSalida
  local vLinea
  local vGfxName

  command -v rocminfo >/dev/null 2>&1 || {
    echo ""
    return 0
  }

  vSalida="$(rocminfo 2>/dev/null | grep -oE 'gfx[0-9a-z]+' || true)"

  for vLinea in ${vSalida}; do
    vGfxName="$(fNormalizarGfx "${vLinea}")"

    if fEsGfxValido "${vGfxName}"; then
      echo "${vGfxName}"
      return 0
    fi
  done

  echo ""
}

fListarGpuAmdDetectadas() {
  local vDispositivo
  local vVendorId
  local vDeviceId
  local vClassId
  local vPciId
  local vNombre

  for vDispositivo in /sys/bus/pci/devices/*; do
    [ -f "${vDispositivo}/vendor" ] || continue
    [ -f "${vDispositivo}/device" ] || continue
    [ -f "${vDispositivo}/class" ] || continue

    vVendorId="$(sed 's/^0x//' "${vDispositivo}/vendor")"
    vDeviceId="$(sed 's/^0x//' "${vDispositivo}/device")"
    vClassId="$(cat "${vDispositivo}/class")"

    [ "${vVendorId}" = "1002" ] || continue

    case "${vClassId}" in
      0x03*)
        vPciId="${vVendorId}:${vDeviceId}"
        vNombre="$(basename "${vDispositivo}")"
        echo "${vNombre} ${vPciId}" >&2
      ;;
    esac
  done
}

fDetectarGfxName() {
  local vGfxName

  vGfxName="$(fDetectarConSysfsIpDiscovery)"

  if fEsGfxValido "${vGfxName}"; then
    echo "${vGfxName}"
    return 0
  fi

  vGfxName="$(fDetectarConRocmAgentEnumerator)"

  if fEsGfxValido "${vGfxName}"; then
    echo "${vGfxName}"
    return 0
  fi

  vGfxName="$(fDetectarConRocmInfo)"

  if fEsGfxValido "${vGfxName}"; then
    echo "${vGfxName}"
    return 0
  fi

  echo "No se pudo detectar automáticamente una arquitectura GFX válida." >&2
  echo "" >&2
  echo "GPUs AMD PCI detectadas:" >&2
  fListarGpuAmdDetectadas
  echo "" >&2
  echo "Causas probables:" >&2
  echo "- El driver amdgpu no expone ip_discovery para esta GPU o este kernel." >&2
  echo "- ROCm está demasiado viejo y devuelve gfx000 o no reconoce la GPU." >&2
  echo "- La GPU AMD es demasiado antigua para este método." >&2
  echo "- La GPU no está usando el driver amdgpu." >&2

  exit 1
}

fDetectarGfxName
