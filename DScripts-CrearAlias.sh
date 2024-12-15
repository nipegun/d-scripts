#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear los alias de los d-scripts 
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

echo ""
echo -e "${cColorAzulClaro}  Creando alias para los d-scripts...${cFinColor}"
echo ""

ln -s ~/scripts/d-scripts/Externos/VelocidadDeInternet.sh                      ~/scripts/d-scripts/Alias/vdi

ln -s ~/scripts/d-scripts/RepararPartición.sh                                  ~/scripts/d-scripts/Alias/rp
ln -s ~/scripts/d-scripts/Archivo-Borrar.sh                                    ~/scripts/d-scripts/Alias/del
ln -s ~/scripts/d-scripts/EditarInterfacesDeRed.sh                             ~/scripts/d-scripts/Alias/eidr
ln -s ~/scripts/d-scripts/ZeroTier.sh                                          ~/scripts/d-scripts/Alias/zt
ln -s ~/scripts/d-scripts/MumbleServer-Editar.sh                               ~/scripts/d-scripts/Alias/emumble
ln -s ~/scripts/d-scripts/EditarUHUB.sh                                        ~/scripts/d-scripts/Alias/euhub
ln -s ~/scripts/d-scripts/MidnightCommander-Abrir.sh                           ~/scripts/d-scripts/Alias/amc
ln -s ~/scripts/d-scripts/ADministrarUsuariosDElSERvidorCALibre.sh             ~/scripts/d-scripts/Alias/adudelsercal
ln -s ~/scripts/d-scripts/AgregarAlMailElUsuario.sh                            ~/scripts/d-scripts/Alias/aameu
ln -s ~/scripts/d-scripts/BloquearTráficoDeTORConIPTables.sh                   ~/scripts/d-scripts/Alias/btdtorcipt
ln -s ~/scripts/d-scripts/BorrarArchivosDSStore.sh                             ~/scripts/d-scripts/Alias/badss
ln -s ~/scripts/d-scripts/BorrarArchivosPuntoGuiónBajo.sh                      ~/scripts/d-scripts/Alias/bapgb
ln -s ~/scripts/d-scripts/BorrarArchivosZoneIdentifier.sh                      ~/scripts/d-scripts/Alias/bazi
ln -s ~/scripts/d-scripts/BorrarKernelsViejos.sh                               ~/scripts/d-scripts/Alias/bkv
ln -s ~/scripts/d-scripts/BorrarTAGsMP3.sh                                     ~/scripts/d-scripts/Alias/btagmp3
ln -s ~/scripts/d-scripts/BorrarUsuarioYHome.sh                                ~/scripts/d-scripts/Alias/buyh
ln -s ~/scripts/d-scripts/BuscarArchivoEnElSistema.sh                          ~/scripts/d-scripts/Alias/baees
ln -s ~/scripts/d-scripts/BuscarCarpetaEnElSistema.sh                          ~/scripts/d-scripts/Alias/bcees
ln -s ~/scripts/d-scripts/BuscarTextoEnArchivos.sh                             ~/scripts/d-scripts/Alias/btea
ln -s ~/scripts/d-scripts/BuscarTextoEnArchivosDeSistema.sh                    ~/scripts/d-scripts/Alias/bteads
ln -s ~/scripts/d-scripts/BuscarTextoEnNombreDeArchivos.sh                     ~/scripts/d-scripts/Alias/btenda
ln -s ~/scripts/d-scripts/BuscarTextoEnScripts.sh                              ~/scripts/d-scripts/Alias/btes
ln -s ~/scripts/d-scripts/BuscarYReemplazarTextoEnArchivosDeSistema.sh         ~/scripts/d-scripts/Alias/byrteads
ln -s ~/scripts/d-scripts/CambiarNombreDeUsuario.sh                            ~/scripts/d-scripts/Alias/cndu
ln -s ~/scripts/d-scripts/CompilarEInstalarElÚltimoKernelEstable.sh            ~/scripts/d-scripts/Alias/ceieuke
ln -s ~/scripts/d-scripts/ComprobarSSD.sh                                      ~/scripts/d-scripts/Alias/cssd
ln -s ~/scripts/d-scripts/DejarSóloElKernelMásReciente.sh                      ~/scripts/d-scripts/Alias/dsekmr
ln -s ~/scripts/d-scripts/DScripts-Sincronizar.sh                              ~/scripts/d-scripts/Alias/sinds
ln -s ~/scripts/d-scripts/EjecutarComo.sh                                      ~/scripts/d-scripts/Alias/ec
ln -s ~/scripts/d-scripts/ExtraerSubtítuloDeMKV.sh                             ~/scripts/d-scripts/Alias/esdmkv
ln -s ~/scripts/d-scripts/MostrarFrecuenciaCPU.sh                              ~/scripts/d-scripts/Alias/mfcpu
ln -s ~/scripts/d-scripts/Grub-Editar.sh                                       ~/scripts/d-scripts/Alias/egrub
ln -s ~/scripts/d-scripts/Grupos-Mostrar.sh                                    ~/scripts/d-scripts/Alias/grupos
ln -s ~/scripts/d-scripts/HAProxy-Editar.sh                                    ~/scripts/d-scripts/Alias/ehaproxy
ln -s ~/scripts/d-scripts/Hardware-Info.sh                                     ~/scripts/d-scripts/Alias/hi
ln -s ~/scripts/d-scripts/Hardware-InfoDisco.sh                                ~/scripts/d-scripts/Alias/hidis
ln -s ~/scripts/d-scripts/Hardware-InfoGráfica.sh                              ~/scripts/d-scripts/Alias/higra
ln -s ~/scripts/d-scripts/Hardware-InfoProcesador.sh                           ~/scripts/d-scripts/Alias/hipro
ln -s ~/scripts/d-scripts/Hardware-InfoRAM.sh                                  ~/scripts/d-scripts/Alias/hiram
ln -s ~/scripts/d-scripts/Hardware-InfoRed.sh                                  ~/scripts/d-scripts/Alias/hired
ln -s ~/scripts/d-scripts/IMPrimir.sh                                          ~/scripts/d-scripts/Alias/imp
ln -s ~/scripts/d-scripts/IMPrimirArchivo.sh                                   ~/scripts/d-scripts/Alias/impa
ln -s ~/scripts/d-scripts/InfoNodoLitecoin.sh                                  ~/scripts/d-scripts/Alias/inl
ln -s ~/scripts/d-scripts/InfoShell.sh                                         ~/scripts/d-scripts/Alias/is
ln -s ~/scripts/d-scripts/LanzarEscritorio.sh                                  ~/scripts/d-scripts/Alias/le
ln -s ~/scripts/d-scripts/ListarNodosTORQueEntran.sh                           ~/scripts/d-scripts/Alias/lntorqe
ln -s ~/scripts/d-scripts/LogsDelSistema-Mostrar.sh                            ~/scripts/d-scripts/Alias/slog
ln -s ~/scripts/d-scripts/Mail-Enviar-Texto-UsandoMail.sh                      ~/scripts/d-scripts/Alias/metum
ln -s ~/scripts/d-scripts/MonitorizarLog.sh                                    ~/scripts/d-scripts/Alias/ml
ln -s ~/scripts/d-scripts/MostrarAparatosConectadosAlRouterDebian.sh           ~/scripts/d-scripts/Alias/macard
ln -s ~/scripts/d-scripts/MostrarAparatosConectadosEnLaInterfaz.sh             ~/scripts/d-scripts/Alias/maceli
ln -s ~/scripts/d-scripts/MostrarContenidoDelPaquete.sh                        ~/scripts/d-scripts/Alias/mcdp
ln -s ~/scripts/d-scripts/MostrarIPLAN.sh                                      ~/scripts/d-scripts/Alias/miplan
ln -s ~/scripts/d-scripts/MostrarIPWAN.sh                                      ~/scripts/d-scripts/Alias/mipwan
ln -s ~/scripts/d-scripts/MostrarKernelsInstalados.sh                          ~/scripts/d-scripts/Alias/mki
ln -s ~/scripts/d-scripts/MostrarMódulosCargados.sh                            ~/scripts/d-scripts/Alias/mmc
ln -s ~/scripts/d-scripts/MostrarReglasIPTablesActivas.sh                      ~/scripts/d-scripts/Alias/mripta
ln -s ~/scripts/d-scripts/MostrarSetsIPSet.sh                                  ~/scripts/d-scripts/Alias/msips
ln -s ~/scripts/d-scripts/MostrarUsuariosDelGrupo.sh                           ~/scripts/d-scripts/Alias/mudg
ln -s ~/scripts/d-scripts/MostrarVelocidadDeCargaDeLaWeb.sh                    ~/scripts/d-scripts/Alias/mvdcdlw
ln -s ~/scripts/d-scripts/MostrarVersiónDeDebian.sh                            ~/scripts/d-scripts/Alias/mvdd
ln -s ~/scripts/d-scripts/MySQL-BaseDeDatos-Crear.sh                           ~/scripts/d-scripts/Alias/cbddyu
ln -s ~/scripts/d-scripts/MySQL-BaseDeDatos-Exportar.sh                        ~/scripts/d-scripts/Alias/ebdd
ln -s ~/scripts/d-scripts/MySQL-BaseDeDatos-Importar.sh                        ~/scripts/d-scripts/Alias/ibdd
ln -s ~/scripts/d-scripts/NotificarFalloDeDisco.sh                             ~/scripts/d-scripts/Alias/nfdd
ln -s ~/scripts/d-scripts/NuevaWebVarWWW.sh                                    ~/scripts/d-scripts/Alias/nwvwww
ln -s ~/scripts/d-scripts/PCIPassThrough-Editar.sh                             ~/scripts/d-scripts/Alias/epcip
ln -s ~/scripts/d-scripts/Proceso-Matar.sh                                     ~/scripts/d-scripts/Alias/mp
ln -s ~/scripts/d-scripts/Plex-Editar.sh                                       ~/scripts/d-scripts/Alias/eplex
ln -s ~/scripts/d-scripts/ProcesosCorriendo.sh                                 ~/scripts/d-scripts/Alias/pc
ln -s ~/scripts/d-scripts/ProcesosCorriendoEnÁrbol.sh                          ~/scripts/d-scripts/Alias/pcea
ln -s ~/scripts/d-scripts/PuertosAbiertos.sh                                   ~/scripts/d-scripts/Alias/pa
ln -s ~/scripts/d-scripts/QuéInstalóElPaquete.sh                               ~/scripts/d-scripts/Alias/qiep
ln -s ~/scripts/d-scripts/RepararPermisosVarWWW.sh                             ~/scripts/d-scripts/Alias/rpvwww
ln -s ~/scripts/d-scripts/RetenerKernels.sh                                    ~/scripts/d-scripts/Alias/rk
ln -s ~/scripts/d-scripts/RPMDeDisco.sh                                        ~/scripts/d-scripts/Alias/rpmdd
ln -s ~/scripts/d-scripts/Samba-Editar.sh                                      ~/scripts/d-scripts/Alias/esamba
ln -s ~/scripts/d-scripts/ServiciosEnEJecución.sh                              ~/scripts/d-scripts/Alias/seej
ln -s ~/scripts/d-scripts/SistemaOperativo-Actualizar.sh                       ~/scripts/d-scripts/Alias/aso
ln -s ~/scripts/d-scripts/SistemaOperativo-ActualizarYApagar.sh                ~/scripts/d-scripts/Alias/asoya
ln -s ~/scripts/d-scripts/SistemaOperativo-ActualizarYReiniciar.sh             ~/scripts/d-scripts/Alias/asoyr
ln -s ~/scripts/d-scripts/SistemaOperativo-Apagar.sh                           ~/scripts/d-scripts/Alias/apso
ln -s ~/scripts/d-scripts/SistemaOperativo-Reiniciar.sh                        ~/scripts/d-scripts/Alias/rso
ln -s ~/scripts/d-scripts/TelegramIT.sh                                        ~/scripts/d-scripts/Alias/tit
ln -s ~/scripts/d-scripts/TelegramITFile.sh                                    ~/scripts/d-scripts/Alias/titf
ln -s ~/scripts/d-scripts/Terminal-Limpiar.sh                                  ~/scripts/d-scripts/Alias/cls
ln -s ~/scripts/d-scripts/Texto-BuscarYReemplazarEnArchivosDeTodoElSistema.sh  ~/scripts/d-scripts/Alias/tbyreadtes
ln -s ~/scripts/d-scripts/Texto-BuscarEnContenidosDeArchivosDeLaCarpeta.sh     ~/scripts/d-scripts/Alias/tbecdadlc
ln -s ~/scripts/d-scripts/Texto-BuscarEnContenidosDeArchivosDeTodoElSistema.sh ~/scripts/d-scripts/Alias/tbecdadtes
ln -s ~/scripts/d-scripts/Texto-BuscarEnNombresDeArchivosDeLaCarpeta.sh        ~/scripts/d-scripts/Alias/tbendadlc
ln -s ~/scripts/d-scripts/Texto-BuscarEnNombresDeArchivosDeTodoElSistema.sh    ~/scripts/d-scripts/Alias/tbendadtes
ln -s ~/scripts/d-scripts/TransmissionDaemon-Editar.sh                         ~/scripts/d-scripts/Alias/etransmission
ln -s ~/scripts/d-scripts/TRIM.sh                                              ~/scripts/d-scripts/Alias/trim
ln -s ~/scripts/d-scripts/UsuarioNuevoConShell.sh                              ~/scripts/d-scripts/Alias/uncs
ln -s ~/scripts/d-scripts/UsuarioNuevoSinShell.sh                              ~/scripts/d-scripts/Alias/unss
ln -s ~/scripts/d-scripts/Usuarios.sh                                          ~/scripts/d-scripts/Alias/u
ln -s ~/scripts/d-scripts/VelocidadDeDiscoDeSistema.sh                         ~/scripts/d-scripts/Alias/vddds
ln -s ~/scripts/d-scripts/VerEstadoDeServicio.sh                               ~/scripts/d-scripts/Alias/veds
ln -s ~/scripts/d-scripts/VersiónDeDebian.sh                                   ~/scripts/d-scripts/Alias/vdd
ln -s ~/scripts/d-scripts/VerLogEnTiempoReal.sh                                ~/scripts/d-scripts/Alias/vletr
ln -s ~/scripts/d-scripts/WinDir.sh                                            ~/scripts/d-scripts/Alias/wd
ln -s ~/scripts/d-scripts/WireGuard-Editar.sh                                  ~/scripts/d-scripts/Alias/ewireguard

ln -s ~/scripts/d-scripts/router/EditarDHCP.sh                                 ~/scripts/d-scripts/Alias/edhcp
ln -s ~/scripts/d-scripts/router/EditarHOSTAPD.sh                              ~/scripts/d-scripts/Alias/ehostapd
ln -s ~/scripts/d-scripts/router/MostrarAparatosConectados.sh                  ~/scripts/d-scripts/Alias/mac
ln -s ~/scripts/d-scripts/router/EditarOpenVPN.sh                              ~/scripts/d-scripts/Alias/eovpn

echo ""
echo -e "${cColorVerde}    Alias creados. Deberías poder ejecutar los d-scripts escribiendo el nombre de su alias.${cFinColor}"
echo ""

