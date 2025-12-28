#!/usr/bin/env python3

import importlib.util
import subprocess
import sys

# Paquete apt necesario para instalar paquetes python
cNombreDelPaqueteApt = "python3-pip"

def fPaqueteAptEstaInstalado(pNombreDelPaqueteApt):
  """Verifica si un paquete apt está instalado."""
  vResultado = subprocess.run(
    ["dpkg", "-s", pNombreDelPaqueteApt],
    stdout=subprocess.DEVNULL,
    stderr=subprocess.DEVNULL
  )
  return vResultado.returncode == 0

def fInstalarPaqueteApt(pNombreDelPaqueteApt):
  """Instala un paquete mediante apt."""
  print(f"[*] Instalando paquete apt: {pNombreDelPaqueteApt}")
  try:
    subprocess.run(
      ["sudo", "apt-get", "-y", "update"],
      check=True
    )
    subprocess.run(
      ["sudo", "apt-get", "-y", "install", pNombreDelPaqueteApt],
      check=True
    )
    print(f"[✓] {pNombreDelPaqueteApt} instalado correctamente")
  except subprocess.CalledProcessError as e:
    print(f"[✗] Error instalando {pNombreDelPaqueteApt}: {e}")
    sys.exit(1)

def fModuloPythonEstaInstalado(pNombreDelModulo):
  """Verifica si un módulo Python está disponible."""
  return importlib.util.find_spec(pNombreDelModulo) is not None

def fInstalarPaquetePython(pNombreDelPaquete):
  """Instala un paquete Python mediante pip."""
  print(f"[*] Instalando paquete Python: {pNombreDelPaquete}")
  try:
    subprocess.run(
      [
        sys.executable,
        "-m", "pip", "install",
        pNombreDelPaquete,
        "--break-system-packages"
      ],
      check=True
    )
    print(f"[✓] {pNombreDelPaquete} instalado correctamente")
  except subprocess.CalledProcessError as e:
    print(f"[✗] Error instalando {pNombreDelPaquete}: {e}")
    return False
  return True

def fComprobarEInstalarPaquetes(pdPaquetesPython):
  """Comprueba e instala los paquetes Python necesarios."""
  aErrores = []
  for vNombrePip, vNombreModulo in pdPaquetesPython.items():
    if fModuloPythonEstaInstalado(vNombreModulo):
      print(f"[✓] {vNombrePip} ya está instalado")
    else:
      if not fInstalarPaquetePython(vNombrePip):
        aErrores.append(vNombrePip)
  return aErrores

def fInstalarDependencias(pdPaquetesPython):
  """
  Función principal para instalar dependencias.
  
  Args:
    pdPaquetesPython: Diccionario {nombre_pip: nombre_modulo}
  
  Returns:
    True si todo OK, False si hubo errores
  """
  print("=== Comprobando dependencias ===\n")
  
  # Verificar pip
  if not fPaqueteAptEstaInstalado(cNombreDelPaqueteApt):
    fInstalarPaqueteApt(cNombreDelPaqueteApt)
  else:
    print(f"[✓] {cNombreDelPaqueteApt} ya está instalado")
  
  print()
  
  # Instalar paquetes Python
  aErrores = fComprobarEInstalarPaquetes(pdPaquetesPython)
  
  print("\n=== Resumen ===")
  if aErrores:
    print(f"[!] Paquetes con errores: {', '.join(aErrores)}")
    return False
  else:
    print("[✓] Todas las dependencias instaladas correctamente")
    return True

# Solo para pruebas directas del módulo
if __name__ == "__main__":
  dPaquetesEjemplo = {
    "flask": "flask",
    "requests": "requests",
  }
  if not fInstalarDependencias(dPaquetesEjemplo):
    sys.exit(1)
