#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

#------------------------------------------------------------------------------------------------
#  Script de NiPeGun para instalar y configurar un pool de minería de criptomonedas en Debian10
#------------------------------------------------------------------------------------------------

ColorRojo='\033[1;31m'
ColorVerde='\033[1;32m'
FinColor='\033[0m'

PuertoRPCrvn="20401"
UsuarioRPCrvn="rvnrpc"
PassRPCrvn="rvnrpcpass"

             echo '{'                                                             > /root/miningcore/build/config-rvn.json
             echo '    "logging": {'                                             >> /root/miningcore/build/config-rvn.json
             echo '        "level": "info",'                                     >> /root/miningcore/build/config-rvn.json
             echo '        "enableConsoleLog": true,'                            >> /root/miningcore/build/config-rvn.json
             echo '        "enableConsoleColors": true,'                         >> /root/miningcore/build/config-rvn.json
             echo '        "logFile": "",'                                       >> /root/miningcore/build/config-rvn.json
             echo '        "logBaseDirectory": "",'                              >> /root/miningcore/build/config-rvn.json
             echo '        "perPoolLogFile": false'                              >> /root/miningcore/build/config-rvn.json
             echo '    },'                                                       >> /root/miningcore/build/config-rvn.json
             echo '    "banning": {'                                             >> /root/miningcore/build/config-rvn.json
             echo '        "manager": "integrated",'                             >> /root/miningcore/build/config-rvn.json
             echo '        "banOnJunkReceive": false,'                           >> /root/miningcore/build/config-rvn.json
             echo '        "banOnInvalidShares": false'                          >> /root/miningcore/build/config-rvn.json
             echo '    },'                                                       >> /root/miningcore/build/config-rvn.json
             echo '    "notifications": {'                                       >> /root/miningcore/build/config-rvn.json
             echo '        "enabled": false,'                                    >> /root/miningcore/build/config-rvn.json
             echo '            "email": {'                                       >> /root/miningcore/build/config-rvn.json
             echo '            "host": "smtp.example.com",'                      >> /root/miningcore/build/config-rvn.json
             echo '            "port": 587,'                                     >> /root/miningcore/build/config-rvn.json
             echo '            "user": "user",'                                  >> /root/miningcore/build/config-rvn.json
             echo '            "password": "password",'                          >> /root/miningcore/build/config-rvn.json
             echo '            "fromAddress": "info@yourpool.org",'              >> /root/miningcore/build/config-rvn.json
             echo '            "fromName": "support"'                            >> /root/miningcore/build/config-rvn.json
             echo '        },'                                                   >> /root/miningcore/build/config-rvn.json
             echo '        "admin": {'                                           >> /root/miningcore/build/config-rvn.json
             echo '            "enabled": false,'                                >> /root/miningcore/build/config-rvn.json
             echo '            "emailAddress": "user@example.com",'              >> /root/miningcore/build/config-rvn.json
             echo '            "notifyBlockFound": true'                         >> /root/miningcore/build/config-rvn.json
             echo '        }'                                                    >> /root/miningcore/build/config-rvn.json
             echo '    },'                                                       >> /root/miningcore/build/config-rvn.json
             echo '    "persistence": {'                                         >> /root/miningcore/build/config-rvn.json
             echo '        "postgres": {'                                        >> /root/miningcore/build/config-rvn.json
             echo '            "host": "127.0.0.1",'                             >> /root/miningcore/build/config-rvn.json
             echo '            "port": 5432,'                                    >> /root/miningcore/build/config-rvn.json
             echo '            "user": "miningcore",'                            >> /root/miningcore/build/config-rvn.json
             echo '            "password": "'"$MiningCoreDBPass"'",'                 >> /root/miningcore/build/config-rvn.json
             echo '            "database": "miningcore"'                         >> /root/miningcore/build/config-rvn.json
             echo '        }'                                                    >> /root/miningcore/build/config-rvn.json
             echo '    },'                                                       >> /root/miningcore/build/config-rvn.json
             echo '    "paymentProcessing": {'                                   >> /root/miningcore/build/config-rvn.json
             echo '        "enabled": false,'                                    >> /root/miningcore/build/config-rvn.json
             echo '        "interval": 600,'                                     >> /root/miningcore/build/config-rvn.json
             echo '        "shareRecoveryFile": "recovered-shares.txt"'          >> /root/miningcore/build/config-rvn.json
             echo '    },'                                                       >> /root/miningcore/build/config-rvn.json
             echo '    "pools": [{'                                              >> /root/miningcore/build/config-rvn.json
             echo '        "id": "RVN",'                                         >> /root/miningcore/build/config-rvn.json
             echo '        "enabled": true,'                                     >> /root/miningcore/build/config-rvn.json
             echo '        "coin": "ravencoin",'                                 >> /root/miningcore/build/config-rvn.json
             echo '        "address": "RKxPhh36Cz6JoqMuq1nwMuPYnkj8DmUswy",'     >> /root/miningcore/build/config-rvn.json
             echo '        "rewardRecipients": [{'                               >> /root/miningcore/build/config-rvn.json
             echo '            "address": "RKxPhh36Cz6JoqMuq1nwMuPYnkj8DmUswy",' >> /root/miningcore/build/config-rvn.json
             echo '            "percentage": 0'                                  >> /root/miningcore/build/config-rvn.json
             echo '        }],'                                                  >> /root/miningcore/build/config-rvn.json
             echo '    "blockRefreshInterval": 1000,'                            >> /root/miningcore/build/config-rvn.json
             echo '    "jobRebroadcastTimeout": 10,'                             >> /root/miningcore/build/config-rvn.json
             echo '    "clientConnectionTimeout": 600,'                          >> /root/miningcore/build/config-rvn.json
             echo '        "jobRebroadcastTimeout": 10,'                         >> /root/miningcore/build/config-rvn.json
             echo '        "clientConnectionTimeout": 600,'                      >> /root/miningcore/build/config-rvn.json
             echo '    "banning": {'                                             >> /root/miningcore/build/config-rvn.json
             echo '            "enabled": false,'                                >> /root/miningcore/build/config-rvn.json
             echo '            "time": 600,'                                     >> /root/miningcore/build/config-rvn.json
             echo '            "invalidPercent": 50,'                            >> /root/miningcore/build/config-rvn.json
             echo '            "checkThreshold": 50'                             >> /root/miningcore/build/config-rvn.json
             echo '        },'                                                   >> /root/miningcore/build/config-rvn.json
             echo '        "ports": {'                                           >> /root/miningcore/build/config-rvn.json
             echo '            "42061": {'                                       >> /root/miningcore/build/config-rvn.json
             echo '                "listenAddress": "127.0.0.1",'                >> /root/miningcore/build/config-rvn.json
             echo '                "difficulty": 16,'                            >> /root/miningcore/build/config-rvn.json
             echo '                "name": "Solo Mining",'                       >> /root/miningcore/build/config-rvn.json
             echo '                "varDiff": {'                                 >> /root/miningcore/build/config-rvn.json
             echo '                    "minDiff": 1,'                            >> /root/miningcore/build/config-rvn.json
             echo '                    "targetTime": 15,'                        >> /root/miningcore/build/config-rvn.json
             echo '                    "retargetTime": 90,'                      >> /root/miningcore/build/config-rvn.json
             echo '                    "variancePercent": 30'                    >> /root/miningcore/build/config-rvn.json
             echo '                }'                                            >> /root/miningcore/build/config-rvn.json
             echo '            }'                                                >> /root/miningcore/build/config-rvn.json
             echo '        },'                                                   >> /root/miningcore/build/config-rvn.json
             echo '        "daemons": [{'                                        >> /root/miningcore/build/config-rvn.json
             echo '            "host": "127.0.0.1",'                             >> /root/miningcore/build/config-rvn.json
             echo '            "port": "'"$PuertoRPCrvn"'",'                           >> /root/miningcore/build/config-rvn.json
             echo '            "user": "'"$UsuarioRPCrvn"'",'                        >> /root/miningcore/build/config-rvn.json
             echo '            "password": "'"$PassRPCrvn"'",'                       >> /root/miningcore/build/config-rvn.json
             echo '        "zmqBlockNotifySocket": "tcp://127.0.0.1:8767",'      >> /root/miningcore/build/config-rvn.json
             echo '        }],'                                                  >> /root/miningcore/build/config-rvn.json
             echo '        "paymentProcessing": {'                               >> /root/miningcore/build/config-rvn.json
             echo '            "enabled": true,'                                 >> /root/miningcore/build/config-rvn.json
             echo '            "minimumPayment": 0.5,'                           >> /root/miningcore/build/config-rvn.json
             echo '            "payoutScheme": "PPLNS",'                         >> /root/miningcore/build/config-rvn.json
             echo '            "payoutSchemeConfig": {'                          >> /root/miningcore/build/config-rvn.json
             echo '            "factor": 2.0'                                    >> /root/miningcore/build/config-rvn.json
             echo '            }'                                                >> /root/miningcore/build/config-rvn.json
             echo '        }'                                                    >> /root/miningcore/build/config-rvn.json
             echo '   }]'                                                        >> /root/miningcore/build/config-rvn.json
             echo '}'                                                            >> /root/miningcore/build/config-rvn.json
