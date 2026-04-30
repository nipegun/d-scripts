#!/usr/bin/env -S PYTHONDONTWRITEBYTECODE=1 python3

import sqlite3
import json
import os
import sys
from datetime import datetime, timezone

cDbPath = os.path.expanduser("~/.local/share/opencode/opencode.db")

cCyan    = "\033[36m"
cVerde   = "\033[32m"
cAmarillo = "\033[33m"
cGris    = "\033[90m"
cReset   = "\033[0m"

def fObtenerPrompts():
  if not os.path.exists(cDbPath):
    print(f"Base de datos no encontrada: {cDbPath}", file=sys.stderr)
    sys.exit(1)

  vConn = sqlite3.connect(cDbPath)
  vConn.row_factory = sqlite3.Row
  try:
    vCursor = vConn.execute("""
      SELECT
        m.id AS message_id,
        m.session_id,
        m.data AS message_data,
        s.title AS session_title,
        s.directory AS session_directory,
        s.time_created AS session_time
      FROM message m
      JOIN session s ON m.session_id = s.id
      WHERE json_extract(m.data, '$.role') = 'user'
      ORDER BY m.time_created DESC
    """)

    vMensajes = vCursor.fetchall()
    if not vMensajes:
      print("No se encontraron prompts de usuario.")
      return

    for vIdx, vRow in enumerate(vMensajes, 1):
      vMsgData = json.loads(vRow["message_data"])
      vTimeCreated = vMsgData.get("time", {}).get("created", 0)
      if vTimeCreated:
        vFecha = datetime.fromtimestamp(vTimeCreated / 1000, tz=timezone.utc).strftime("%Y-%m-%d %H:%M:%S UTC")
      else:
        vFecha = "fecha desconocida"

      vPartes = vConn.execute(
        "SELECT data FROM part WHERE message_id = ? AND json_extract(data, '$.type') = 'text' ORDER BY time_created",
        (vRow["message_id"],)
      ).fetchall()

      vTextos = []
      for vParte in vPartes:
        vParteData = json.loads(vParte["data"])
        vTexto = vParteData.get("text", "")
        if vTexto:
          vTextos.append(vTexto)

      vPrompt = "\n".join(vTextos) if vTextos else "(sin texto)"

      vCabecera = f"┌─ Prompt #{vIdx} ── {vFecha} ─"
      vPadding = 80 - len(vCabecera) - 1
      print(f"{cCyan}{vCabecera}{'─' * vPadding}┐{cReset}")
      print(f"{cCyan}│{cReset} {cGris}Proyecto  :{cReset} {vRow['session_directory']}")
      print(f"{cCyan}│{cReset} {cGris}Sesión    :{cReset} {vRow['session_title']}")
      print(f"{cCyan}│{cReset} {cGris}Session ID:{cReset} {vRow['session_id']}")
      print(f"{cCyan}│{cReset} {cGris}Message ID:{cReset} {vRow['message_id']}")
      print(f"{cCyan}├{'─' * 78}┤{cReset}")
      for vLinea in vPrompt.split("\n"):
        print(f"{cCyan}│{cReset} {cAmarillo}{vLinea}{cReset}")
      print(f"{cCyan}└{'─' * 78}┘{cReset}")

  finally:
    vConn.close()

if __name__ == "__main__":
  fObtenerPrompts()
