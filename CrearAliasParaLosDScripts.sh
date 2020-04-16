#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#-----------------------------------------------------------
#  Script de NiPeGun para crear los alias de los d-scripts 
#-----------------------------------------------------------

ColorVerde="\033[1;32m"
FinColor="\033[0m"

echo ""
echo -e "${ColorVerde}Creando alias para los d-scripts...${FinColor}"
echo ""

ln -s /root/scripts/d-scripts/externos/VelocidadDeInternet                 /root/scripts/d-scripts/Alias/vdi

ln -s /root/scripts/d-scripts/APagarSistemaOperativo.sh                    /root/scripts/d-scripts/Alias/apso
ln -s /root/scripts/d-scripts/AbrirMidnightCommander.sh                    /root/scripts/d-scripts/Alias/amc
ln -s /root/scripts/d-scripts/ActualizarSistemaOperativo.sh                /root/scripts/d-scripts/Alias/aso
ln -s /root/scripts/d-scripts/ActualizarSistemaOperativoYApagar.sh         /root/scripts/d-scripts/Alias/asoya
ln -s /root/scripts/d-scripts/ActualizarSistemaOperativoYReiniciar.sh      /root/scripts/d-scripts/Alias/asoyr
ln -s /root/scripts/d-scripts/ADministrarUsuariosDElSERvidorCALibre.sh     /root/scripts/d-scripts/Alias/adudelsercal
ln -s /root/scripts/d-scripts/AgregarAlMailElUsuario.sh                    /root/scripts/d-scripts/Alias/aameu
ln -s /root/scripts/d-scripts/BloquearTráficoDeTORConIPTables.sh           /root/scripts/d-scripts/Alias/btdtorcipt
ln -s /root/scripts/d-scripts/BorrarArchivosDSStore.sh                     /root/scripts/d-scripts/Alias/badss
ln -s /root/scripts/d-scripts/BorrarArchivosPuntoGuiónBajo.sh              /root/scripts/d-scripts/Alias/bapgb
ln -s /root/scripts/d-scripts/BorrarArchivosZoneIdentifier.sh              /root/scripts/d-scripts/Alias/bazi
ln -s /root/scripts/d-scripts/BorrarKernelsViejos.sh                       /root/scripts/d-scripts/Alias/bkv
ln -s /root/scripts/d-scripts/BorrarTAGsMP3.sh                             /root/scripts/d-scripts/Alias/btagmp3
ln -s /root/scripts/d-scripts/BorrarUsuarioYHome.sh                        /root/scripts/d-scripts/Alias/buyh
ln -s /root/scripts/d-scripts/BuscarArchivoEnElSistema.sh                  /root/scripts/d-scripts/Alias/baees
ln -s /root/scripts/d-scripts/BuscarCarpetaEnElSistema.sh                  /root/scripts/d-scripts/Alias/bcees
ln -s /root/scripts/d-scripts/BuscarMódulosCargables.sh                    /root/scripts/d-scripts/Alias/bmc
ln -s /root/scripts/d-scripts/BuscarTextoEnArchivos.sh                     /root/scripts/d-scripts/Alias/btea
ln -s /root/scripts/d-scripts/BuscarTextoEnArchivosDeSistema.sh            /root/scripts/d-scripts/Alias/bteads
ln -s /root/scripts/d-scripts/BuscarTextoEnNombreDeArchivos.sh             /root/scripts/d-scripts/Alias/btenda
ln -s /root/scripts/d-scripts/BuscarYReemplazarTextoEnArchivosDeSistema.sh /root/scripts/d-scripts/Alias/byrteads
ln -s /root/scripts/d-scripts/CambiarNombreDeUsuario.sh                    /root/scripts/d-scripts/Alias/cndu
ln -s /root/scripts/d-scripts/CompilarEInstalarElÚltimoKernelEstable.sh    /root/scripts/d-scripts/Alias/ceieuke
ln -s /root/scripts/d-scripts/ComprobarSSD.sh                              /root/scripts/d-scripts/Alias/cssd
ln -s /root/scripts/d-scripts/CrearBaseDeDatosYUsuario.sh                  /root/scripts/d-scripts/Alias/cbddyu
ln -s /root/scripts/d-scripts/DejarSóloElKernelMásReciente.sh              /root/scripts/d-scripts/Alias/dsekmr
ln -s /root/scripts/d-scripts/EditarGRUB.sh                                /root/scripts/d-scripts/Alias/egrub
ln -s /root/scripts/d-scripts/EditarHAPROXY.sh                             /root/scripts/d-scripts/Alias/ehaproxy
ln -s /root/scripts/d-scripts/EditarPCIPASSTHROUGH.sh                      /root/scripts/d-scripts/Alias/epcipassthrough
ln -s /root/scripts/d-scripts/EditarSAMBA.sh                               /root/scripts/d-scripts/Alias/esamba
ln -s /root/scripts/d-scripts/EditarTRANSMISSION.sh                        /root/scripts/d-scripts/Alias/etransmission
ln -s /root/scripts/d-scripts/EjecutarComo.sh                              /root/scripts/d-scripts/Alias/ec
ln -s /root/scripts/d-scripts/EnviarMailA.sh                               /root/scripts/d-scripts/Alias/ema
ln -s /root/scripts/d-scripts/ExportarBaseDeDatos.sh                       /root/scripts/d-scripts/Alias/ebdd
ln -s /root/scripts/d-scripts/ExtraerSubtítuloDeMKV.sh                     /root/scripts/d-scripts/Alias/esdmkv
ln -s /root/scripts/d-scripts/Grupos.sh                                    /root/scripts/d-scripts/Alias/g
ln -s /root/scripts/d-scripts/HardwareInfo.sh                              /root/scripts/d-scripts/Alias/hi
ln -s /root/scripts/d-scripts/HardwareInfoGráfica.sh                       /root/scripts/d-scripts/Alias/higraf
ln -s /root/scripts/d-scripts/HardwareInfoProcesador.sh                    /root/scripts/d-scripts/Alias/hiproc
ln -s /root/scripts/d-scripts/HardwareInfoRAM.sh                           /root/scripts/d-scripts/Alias/hiram
ln -s /root/scripts/d-scripts/HardwareInfoRed.sh                           /root/scripts/d-scripts/Alias/hired
ln -s /root/scripts/d-scripts/ImportarBaseDeDatos.sh                       /root/scripts/d-scripts/Alias/ibdd
ln -s /root/scripts/d-scripts/IMPrimir.sh                                  /root/scripts/d-scripts/Alias/imp
ln -s /root/scripts/d-scripts/IMPrimirArchivo.sh                           /root/scripts/d-scripts/Alias/impa
ln -s /root/scripts/d-scripts/InfoNodoLitecoin.sh                          /root/scripts/d-scripts/Alias/inl
ln -s /root/scripts/d-scripts/InfoShell.sh                                 /root/scripts/d-scripts/Alias/is
ln -s /root/scripts/d-scripts/LanzarEscritorio.sh                          /root/scripts/d-scripts/Alias/le
ln -s /root/scripts/d-scripts/ListarNodosTORQueEntran.sh                   /root/scripts/d-scripts/Alias/lntorqe
ln -s /root/scripts/d-scripts/MonitorizarLog.sh                            /root/scripts/d-scripts/Alias/ml
ln -s /root/scripts/d-scripts/MostrarAparatosConectadosAlRouterDebian.sh   /root/scripts/d-scripts/Alias/macard
ln -s /root/scripts/d-scripts/MostrarAparatosConectadosEnLaInterfaz.sh     /root/scripts/d-scripts/Alias/maceli
ln -s /root/scripts/d-scripts/MostrarContenidoDelPaquete.sh                /root/scripts/d-scripts/Alias/mcdp
ln -s /root/scripts/d-scripts/MostrarIPLAN.sh                              /root/scripts/d-scripts/Alias/miplan
ln -s /root/scripts/d-scripts/MostrarIPWAN.sh                              /root/scripts/d-scripts/Alias/mipwan
ln -s /root/scripts/d-scripts/MostrarKernelsInstalados.sh                  /root/scripts/d-scripts/Alias/mki
ln -s /root/scripts/d-scripts/MostrarMódulosCargados.sh                    /root/scripts/d-scripts/Alias/mmc
ln -s /root/scripts/d-scripts/MostrarReglasIPTablesActivas.sh              /root/scripts/d-scripts/Alias/mripta
ln -s /root/scripts/d-scripts/MostrarSetsIPSet.sh                          /root/scripts/d-scripts/Alias/msips
ln -s /root/scripts/d-scripts/MostrarUsuariosDelGrupo.sh                   /root/scripts/d-scripts/Alias/mudg
ln -s /root/scripts/d-scripts/MostrarVelocidadDeCargaDeLaWeb.sh            /root/scripts/d-scripts/Alias/mvdcdlw
ln -s /root/scripts/d-scripts/MostrarVersiónDeDebian.sh                    /root/scripts/d-scripts/Alias/mvdd
ln -s /root/scripts/d-scripts/NotificarFalloDeDisco.sh                     /root/scripts/d-scripts/Alias/nfdd
ln -s /root/scripts/d-scripts/NuevaWebVarWWW.sh                            /root/scripts/d-scripts/Alias/nwvwww
ln -s /root/scripts/d-scripts/ProcesosCorriendo.sh                         /root/scripts/d-scripts/Alias/pc
ln -s /root/scripts/d-scripts/ProcesosCorriendoEnÁrbol.sh                  /root/scripts/d-scripts/Alias/pcea
ln -s /root/scripts/d-scripts/PuertosAbiertos.sh                           /root/scripts/d-scripts/Alias/pa
ln -s /root/scripts/d-scripts/QuéInstalóElPaquete.sh                       /root/scripts/d-scripts/Alias/qiep
ln -s /root/scripts/d-scripts/ReiniciarSistemaOperativo.sh                 /root/scripts/d-scripts/Alias/rso
ln -s /root/scripts/d-scripts/RepararPermisosVarWWW.sh                     /root/scripts/d-scripts/Alias/rpvwww
ln -s /root/scripts/d-scripts/RetenerKernels.sh                            /root/scripts/d-scripts/Alias/rk
ln -s /root/scripts/d-scripts/RPMDeDisco.sh                                /root/scripts/d-scripts/Alias/rpmdd
ln -s /root/scripts/d-scripts/ServiciosEnEJecución.sh                      /root/scripts/d-scripts/Alias/seej
ln -s /root/scripts/d-scripts/SINcronizarDScripts.sh                       /root/scripts/d-scripts/Alias/sinds
ln -s /root/scripts/d-scripts/TelegramIT.sh                                /root/scripts/d-scripts/Alias/tit
ln -s /root/scripts/d-scripts/TelegramITFile.sh                            /root/scripts/d-scripts/Alias/titf
ln -s /root/scripts/d-scripts/TRIM.sh                                      /root/scripts/d-scripts/Alias/trim
ln -s /root/scripts/d-scripts/UsuarioNuevoConShell.sh                      /root/scripts/d-scripts/Alias/uncs
ln -s /root/scripts/d-scripts/UsuarioNuevoSinShell.sh                      /root/scripts/d-scripts/Alias/unss
ln -s /root/scripts/d-scripts/Usuarios.sh                                  /root/scripts/d-scripts/Alias/u
ln -s /root/scripts/d-scripts/VelocidadDeDiscoDeSistema.sh                 /root/scripts/d-scripts/Alias/vddds
ln -s /root/scripts/d-scripts/VerEstadoDeServicio.sh                       /root/scripts/d-scripts/Alias/veds
ln -s /root/scripts/d-scripts/VersiónDeDebian.sh                           /root/scripts/d-scripts/Alias/vdd
ln -s /root/scripts/d-scripts/VerLogEnTiempoReal.sh                        /root/scripts/d-scripts/Alias/vletr
ln -s /root/scripts/d-scripts/WinDir.sh                                    /root/scripts/d-scripts/Alias/wd

ln -s /root/scripts/d-scripts/router/EditarDHCP.sh                /root/scripts/d-scripts/Alias/edhcp
ln -s /root/scripts/d-scripts/router/EditarHOSTAPD.sh             /root/scripts/d-scripts/Alias/ehostapd
ln -s /root/scripts/d-scripts/router/MostrarAparatosConectados.sh /root/scripts/d-scripts/Alias/mac
ln -s /root/scripts/d-scripts/router/EditarOpenVPN.sh             /root/scripts/d-scripts/Alias/eovpn

echo ""
echo -e "${ColorVerde}Alias creados. Deberías poder ejecutar los d-scripts escribiendo el nombre de su alias.${FinColor}"
echo ""

