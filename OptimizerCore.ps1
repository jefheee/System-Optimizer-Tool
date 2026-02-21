# =================================================================
# SYSTEM OPTIMIZER CORE V57 (GLOBAL TITAN)
# =================================================================
$ErrorActionPreference = 'SilentlyContinue'
$FixedW = 100 
$Version = "V57"

# --- CONFIGURACAO DE AMBIENTE ---
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
if ($PSScriptRoot) { $ScriptPath = $PSScriptRoot } else { $ScriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition }
$CurrentFile = $MyInvocation.MyCommand.Definition

# URLs GITHUB (Atualize com seu repositorio real)
$RepoRaw = "https://raw.githubusercontent.com/jefheee/System-Optimizer-Tool/main"
$UpdateURL = "$RepoRaw/OptimizerCore.ps1"
$BatURL = "$RepoRaw/SystemOptimizer.bat"
$ChangelogURL = "$RepoRaw/CHANGELOG.md"
$ReadmeURL = "$RepoRaw/README.md"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ================= DICIONARIO DE IDIOMAS (DATABASE) =================
$Dict = @{
    "PT" = @{
        "LangName" = "Portugues (Brasil)"
        "Welcome" = "Selecione seu idioma / Select Language:"
        "M_Opt" = "OTIMIZAR AGORA (SSD)"; "D_Opt" = "Esvazia lixeira, limpa sistema e melhora RAM"
        "M_Lite" = "OTIMIZACAO LITE (HDD)"; "D_Lite" = "Limpeza segura para discos antigos (Sem TRIM)"
        "M_Gamer" = "FERRAMENTAS GAMER"; "D_Gamer" = "Aumenta FPS, tira lag do mouse e otimiza rede"
        "M_Sys" = "FERRAMENTAS SISTEMA"; "D_Sys" = "Repara erros, arruma internet e apaga inuteis"
        "M_Act" = "ATIVADOR WINDOWS"; "D_Act" = "Ativa o Windows e o pacote Office para sempre"
        "M_Diag" = "DIAGNOSTICO PC"; "D_Diag" = "Mostra as pecas, gargalo e saude do sistema"
        "M_Set" = "AJUSTES / SETTINGS"; "D_Set" = "Mudar idioma, atualizacoes e reset"
        "M_Exit" = "SAIR"; "D_Exit" = "Fechar e Sair do Otimizador"
        "Choose" = "Escolha uma opcao digitando o numero:"
        "Wait" = "Pressione qualquer tecla para voltar..."
        "Back" = "VOLTAR" ; "D_Back" = "Retornar ao menu anterior"
        # Settings
        "S_Lang" = "MUDAR IDIOMA"; "DS_Lang" = "Trocar para EN, ES, FR, DE, RU, CN"
        "S_Upd" = "FORCAR ATUALIZACAO"; "DS_Upd" = "Baixar novamente todos os arquivos do GitHub"
        "S_Rst" = "RESETAR CONFIGS"; "DS_Rst" = "Apaga preferencias e reinicia o script"
        # Messages
        "Msg_Clean" = "Limpando"
        "Msg_Done" = "Concluido!"
        "Msg_Wait" = "Aguarde..."
        "Msg_UpdateOK" = "[OK] Atualizado com sucesso! Reinicie o programa."
        "Msg_UpdateFail" = "[ERRO] Falha ao baixar."
        # Gamer Menu
        "G_Timer" = "REDUZIR LATENCIA"; "DG_Timer" = "Abaixa resposta do Windows (0.5ms)"
        "G_Prio" = "FORCAR PRIORIDADE ALTA"; "DG_Prio" = "Foca CPU no jogo (Regedit)"
        "G_FSO" = "DESATIVAR TELA CHEIA"; "DG_FSO" = "Remove lag do Alt+Tab (FSO)"
        "G_Mouse" = "MOUSE PRECISAO 1:1"; "DG_Mouse" = "Remove aceleracao do mouse"
        "G_Keys" = "OTIMIZAR TECLADO"; "DG_Keys" = "Resposta rapida de teclas"
        "G_Net" = "REDUZIR PACOTES REDE"; "DG_Net" = "Otimiza TCP para jogos online"
        "G_Ram" = "RAM AUTO-CLEAN (JOB)"; "DG_Ram" = "Limpeza automatica a cada 10 min"
        "G_Def" = "DEFENDER EXCLUSION"; "DG_Def" = "Evita scan na pasta do jogo"
        "G_Dx" = "DIRECTX SHADER RESET"; "DG_Dx" = "Corrige stutters (Cache GPU)"
        # System Menu
        "Y_WinUtil" = "WINUTIL (CHRIS TITUS)"; "DY_WinUtil" = "Ferramenta Externa Super Completa"
        "Y_Upd" = "REPARAR WINDOWS UPDATE"; "DY_Upd" = "Destrava atualizacoes presas"
        "Y_Dns" = "MELHOR DNS (PING)"; "DY_Dns" = "Escolhe Google ou Cloudflare"
        "Y_Rep" = "REPARAR ARQUIVOS WIN"; "DY_Rep" = "SFC e DISM (Demorado)"
        "Y_Orphan" = "LIMPAR TAREFAS ORFAS"; "DY_Orphan" = "Apaga gatilhos invalidos"
        "Y_Apps" = "APAGAR APPS INUTEIS"; "DY_Apps" = "Remove Cortana, XboxBar"
        "Y_Tel" = "DESATIVAR TELEMETRIA"; "DY_Tel" = "Impede rastreamento"
        "Y_Adv" = "FERRAMENTAS AVANCADAS >>"; "DY_Adv" = "OneDrive, Bluetooth, Fontes..."
        # Advanced
        "A_One" = "REMOVER ONEDRIVE"; "DA_One" = "Apaga app e residuos"
        "A_Font" = "RESETAR FONTE CACHE"; "DA_Font" = "Corrige letras borradas"
        "A_Blue" = "FIX BLUETOOTH CACHE"; "DA_Blue" = "Resolve falha de pareamento"
        "A_Store" = "RESTAURAR LOJA/APPS"; "DA_Store" = "Reinstala padroes do Windows"
        "A_Own" = "ADD TOMAR POSSE"; "DA_Own" = "Botao direito para virar Dono"
    }
    "EN" = @{
        "LangName" = "English (Global)"
        "Welcome" = "Select your language:"
        "M_Opt" = "OPTIMIZE NOW (SSD)"; "D_Opt" = "Empty bin, clean system, and boost RAM"
        "M_Lite" = "LITE OPTIMIZATION (HDD)"; "D_Lite" = "Safe cleanup for older drives (No TRIM)"
        "M_Gamer" = "GAMING TOOLS"; "D_Gamer" = "Boost FPS, fix mouse lag, and optimize network"
        "M_Sys" = "SYSTEM TOOLS"; "D_Sys" = "Fix errors, network tweaks, and debloat"
        "M_Act" = "WINDOWS ACTIVATOR"; "D_Act" = "Permanent system and Office activation (MAS)"
        "M_Diag" = "PC DIAGNOSTICS"; "D_Diag" = "Hardware info, bottleneck, and health"
        "M_Set" = "SETTINGS"; "D_Set" = "Change language, updates, and reset"
        "M_Exit" = "EXIT"; "D_Exit" = "Close Command Center"
        "Choose" = "Choose an option by typing the number:"
        "Wait" = "Press any key to return..."
        "Back" = "BACK" ; "D_Back" = "Return to previous menu"
        "S_Lang" = "CHANGE LANGUAGE"; "DS_Lang" = "Switch to PT, ES, FR, DE, RU, CN"
        "S_Upd" = "FORCE UPDATE"; "DS_Upd" = "Re-download all files from GitHub"
        "S_Rst" = "RESET CONFIG"; "DS_Rst" = "Clear preferences and restart"
        "Msg_Clean" = "Cleaning"
        "Msg_Done" = "Done!"
        "Msg_Wait" = "Please wait..."
        "Msg_UpdateOK" = "[OK] Successfully updated! Please restart."
        "Msg_UpdateFail" = "[ERROR] Download failed."
        "G_Timer" = "REDUCE LATENCY"; "DG_Timer" = "Lower Windows timer (0.5ms)"
        "G_Prio" = "FORCE HIGH PRIORITY"; "DG_Prio" = "Focus CPU on game (Regedit)"
        "G_FSO" = "DISABLE FULLSCREEN OPT"; "DG_FSO" = "Fix Alt+Tab lag (FSO)"
        "G_Mouse" = "MOUSE ACCURACY 1:1"; "DG_Mouse" = "Disable mouse acceleration"
        "G_Keys" = "OPTIMIZE KEYBOARD"; "DG_Keys" = "Fast key response"
        "G_Net" = "REDUCE PACKET LOSS"; "DG_Net" = "Optimize TCP for online games"
        "G_Ram" = "RAM AUTO-CLEAN (JOB)"; "DG_Ram" = "Auto-clean every 10 mins"
        "G_Def" = "DEFENDER EXCLUSION"; "DG_Def" = "Skip scan on game folder"
        "G_Dx" = "DIRECTX SHADER RESET"; "DG_Dx" = "Fix stutters (GPU Cache)"
        "Y_WinUtil" = "WINUTIL (CHRIS TITUS)"; "DY_WinUtil" = "Complete External Tool"
        "Y_Upd" = "FIX WINDOWS UPDATE"; "DY_Upd" = "Unstuck updates"
        "Y_Dns" = "BEST DNS (PING)"; "DY_Dns" = "Choose Google or Cloudflare"
        "Y_Rep" = "REPAIR SYSTEM FILES"; "DY_Rep" = "SFC and DISM (Slow)"
        "Y_Orphan" = "CLEAN ORPHAN TASKS"; "DY_Orphan" = "Delete invalid triggers"
        "Y_Apps" = "REMOVE BLOATWARE"; "DY_Apps" = "Delete Cortana, XboxBar"
        "Y_Tel" = "DISABLE TELEMETRY"; "DY_Tel" = "Stop Windows tracking"
        "Y_Adv" = "ADVANCED TOOLS >>"; "DY_Adv" = "OneDrive, Bluetooth, Fonts..."
        "A_One" = "REMOVE ONEDRIVE"; "DA_One" = "Delete app and leftovers"
        "A_Font" = "RESET FONT CACHE"; "DA_Font" = "Fix blurry text"
        "A_Blue" = "FIX BLUETOOTH CACHE"; "DA_Blue" = "Fix pairing issues"
        "A_Store" = "RESTORE STORE/APPS"; "DA_Store" = "Reinstall Windows defaults"
        "A_Own" = "ADD TAKE OWNERSHIP"; "DA_Own" = "Right-click to own files"
    }
    "ES" = @{
        "LangName" = "Espanol"
        "Welcome" = "Seleccione su idioma:"
        "M_Opt" = "OPTIMIZAR AHORA (SSD)"; "D_Opt" = "Vacia papelera, limpia sistema y mejora RAM"
        "M_Lite" = "OPTIMIZACION LITE (HDD)"; "D_Lite" = "Limpieza segura para discos antiguos (Sin TRIM)"
        "M_Gamer" = "HERRAMIENTAS GAMER"; "D_Gamer" = "Aumenta FPS, quita lag de mouse y optimiza red"
        "M_Sys" = "HERRAMIENTAS SISTEMA"; "D_Sys" = "Repara errores, red y elimina basura"
        "M_Act" = "ACTIVADOR WINDOWS"; "D_Act" = "Activacion permanente de Windows y Office"
        "M_Diag" = "DIAGNOSTICO PC"; "D_Diag" = "Muestra hardware, cuello de botella y salud"
        "M_Set" = "AJUSTES"; "D_Set" = "Cambiar idioma, actualizar y reiniciar"
        "M_Exit" = "SALIR"; "D_Exit" = "Cerrar Command Center"
        "Choose" = "Elige una opcion escribiendo el numero:"
        "Wait" = "Presiona cualquier tecla para volver..."
        "Back" = "VOLVER" ; "D_Back" = "Regresar al menu anterior"
        "S_Lang" = "CAMBIAR IDIOMA"; "DS_Lang" = "Cambiar a PT, EN, FR, DE, RU, CN"
        "S_Upd" = "FORZAR ACTUALIZACION"; "DS_Upd" = "Descargar todo de nuevo desde GitHub"
        "S_Rst" = "REINICIAR CONFIG"; "DS_Rst" = "Borrar preferencias y reiniciar"
        "Msg_Clean" = "Limpiando"
        "Msg_Done" = "Hecho!"
        "Msg_Wait" = "Espere..."
        "Msg_UpdateOK" = "[OK] Actualizado con exito! Reinicie."
        "Msg_UpdateFail" = "[ERROR] Fallo en la descarga."
        "G_Timer" = "REDUCIR LATENCIA"; "DG_Timer" = "Bajar respuesta Windows (0.5ms)"
        "G_Prio" = "FORZAR PRIORIDAD ALTA"; "DG_Prio" = "Enfocar CPU en juego"
        "G_FSO" = "DESACTIVAR PANTALLA C."; "DG_FSO" = "Quitar lag Alt+Tab (FSO)"
        "G_Mouse" = "MOUSE PRECISION 1:1"; "DG_Mouse" = "Quitar aceleracion mouse"
        "G_Keys" = "OPTIMIZAR TECLADO"; "DG_Keys" = "Respuesta rapida teclas"
        "G_Net" = "REDUCIR PAQUETES RED"; "DG_Net" = "Optimizar TCP juegos online"
        "G_Ram" = "RAM AUTO-CLEAN (JOB)"; "DG_Ram" = "Auto-limpieza cada 10 min"
        "G_Def" = "EXCLUSION DEFENDER"; "DG_Def" = "Evitar scan en carpeta juego"
        "G_Dx" = "DIRECTX SHADER RESET"; "DG_Dx" = "Corregir stutters (Cache GPU)"
        "Y_WinUtil" = "WINUTIL (CHRIS TITUS)"; "DY_WinUtil" = "Herramienta Externa Completa"
        "Y_Upd" = "REPARAR WINDOWS UPDATE"; "DY_Upd" = "Desatascar actualizaciones"
        "Y_Dns" = "MEJOR DNS (PING)"; "DY_Dns" = "Elegir Google o Cloudflare"
        "Y_Rep" = "REPARAR ARCHIVOS WIN"; "DY_Rep" = "SFC y DISM (Lento)"
        "Y_Orphan" = "LIMPIAR TAREAS HUERF."; "DY_Orphan" = "Borrar triggers invalidos"
        "Y_Apps" = "BORRAR APPS BASURA"; "DY_Apps" = "Borrar Cortana, XboxBar"
        "Y_Tel" = "DESACTIVAR TELEMETRIA"; "DY_Tel" = "Detener rastreo Windows"
        "Y_Adv" = "HERRAMIENTAS AVANZ. >>"; "DY_Adv" = "OneDrive, Bluetooth, Fuentes..."
        "A_One" = "ELIMINAR ONEDRIVE"; "DA_One" = "Borrar app y residuos"
        "A_Font" = "RESET CACHE FUENTES"; "DA_Font" = "Corregir letras borrosas"
        "A_Blue" = "FIX BLUETOOTH CACHE"; "DA_Blue" = "Corregir emparejamiento"
        "A_Store" = "RESTAURAR TIENDA/APPS"; "DA_Store" = "Reinstalar defaults Windows"
        "A_Own" = "TOMAR POSESION"; "DA_Own" = "Click derecho para ser dueno"
    }
    "FR" = @{
        "LangName" = "Francais"
        "Welcome" = "Selectionnez votre langue:"
        "M_Opt" = "OPTIMISER (SSD)"; "D_Opt" = "Vider corbeille, nettoyer systeme et RAM"
        "M_Lite" = "OPTIMISATION LITE (HDD)"; "D_Lite" = "Nettoyage sur pour vieux disques (Sans TRIM)"
        "M_Gamer" = "OUTILS GAMING"; "D_Gamer" = "Boost FPS, reduire lag et optimiser reseau"
        "M_Sys" = "OUTILS SYSTEME"; "D_Sys" = "Reparer erreurs, reseau et bloatware"
        "M_Act" = "ACTIVATEUR WINDOWS"; "D_Act" = "Activation permanente Windows et Office"
        "M_Diag" = "DIAGNOSTIC PC"; "D_Diag" = "Infos materiel, goulot et sante"
        "M_Set" = "PARAMETRES"; "D_Set" = "Langue, mises a jour et reinitialisation"
        "M_Exit" = "QUITTER"; "D_Exit" = "Fermer Command Center"
        "Choose" = "Choisissez une option :"
        "Wait" = "Appuyez sur une touche..."
        "Back" = "RETOUR" ; "D_Back" = "Menu precedent"
        "S_Lang" = "CHANGER LANGUE"; "DS_Lang" = "Changer vers PT, EN, ES, DE, RU, CN"
        "S_Upd" = "FORCER MISE A JOUR"; "DS_Upd" = "Telecharger a nouveau depuis GitHub"
        "S_Rst" = "REINITIALISER"; "DS_Rst" = "Effacer preferences et redemarrer"
        "Msg_Clean" = "Nettoyage"
        "Msg_Done" = "Fait !"
        "Msg_Wait" = "Patientez..."
        "Msg_UpdateOK" = "[OK] Mis a jour ! Redemarrez."
        "Msg_UpdateFail" = "[ERREUR] Echec telechargement."
        "G_Timer" = "REDUIRE LATENCE"; "DG_Timer" = "Timer Windows bas (0.5ms)"
        "G_Prio" = "FORCER HAUTE PRIO"; "DG_Prio" = "Focus CPU sur jeu"
        "G_FSO" = "DESACTIVER FULLSCREEN"; "DG_FSO" = "Corriger lag Alt+Tab"
        "G_Mouse" = "PRECISION SOURIS 1:1"; "DG_Mouse" = "Desactiver acceleration"
        "G_Keys" = "OPTIMISER CLAVIER"; "DG_Keys" = "Reponse rapide touches"
        "G_Net" = "OPTIMISER PAQUETS"; "DG_Net" = "TCP pour jeux en ligne"
        "G_Ram" = "RAM AUTO-CLEAN (JOB)"; "DG_Ram" = "Nettoyage auto 10 min"
        "G_Def" = "EXCLUSION DEFENDER"; "DG_Def" = "Ignorer dossier jeu"
        "G_Dx" = "DIRECTX SHADER RESET"; "DG_Dx" = "Corriger stutters (GPU)"
        "Y_WinUtil" = "WINUTIL (CHRIS TITUS)"; "DY_WinUtil" = "Outil Externe Complet"
        "Y_Upd" = "REPARER WINDOWS UPDATE"; "DY_Upd" = "Debloquer mises a jour"
        "Y_Dns" = "MEILLEUR DNS (PING)"; "DY_Dns" = "Choisir Google ou Cloudflare"
        "Y_Rep" = "REPARER FICHIERS WIN"; "DY_Rep" = "SFC et DISM (Lent)"
        "Y_Orphan" = "NETTOYER TACHES ORPH."; "DY_Orphan" = "Supprimer declencheurs vides"
        "Y_Apps" = "SUPPRIMER BLOATWARE"; "DY_Apps" = "Supprimer Cortana, XboxBar"
        "Y_Tel" = "DESACTIVER TELEMETRIE"; "DY_Tel" = "Stopper tracage Windows"
        "Y_Adv" = "OUTILS AVANCES >>"; "DY_Adv" = "OneDrive, Bluetooth, Polices..."
        "A_One" = "SUPPRIMER ONEDRIVE"; "DA_One" = "Supprimer app et restes"
        "A_Font" = "RESET CACHE POLICES"; "DA_Font" = "Corriger texte flou"
        "A_Blue" = "FIX BLUETOOTH CACHE"; "DA_Blue" = "Corriger appairage"
        "A_Store" = "RESTAURER STORE/APPS"; "DA_Store" = "Reinstaller defaut Windows"
        "A_Own" = "PRENDRE POSSESSION"; "DA_Own" = "Clic droit proprietaire"
    }
    "DE" = @{
        "LangName" = "Deutsch"
        "Welcome" = "Wahlen Sie Ihre Sprache:"
        "M_Opt" = "JETZT OPTIMIEREN (SSD)"; "D_Opt" = "Papierkorb leeren, System und RAM"
        "M_Lite" = "LITE OPTIMIERUNG (HDD)"; "D_Lite" = "Sicher fur alte Festplatten (Kein TRIM)"
        "M_Gamer" = "GAMING TOOLS"; "D_Gamer" = "Mehr FPS, weniger Lag"
        "M_Sys" = "SYSTEM TOOLS"; "D_Sys" = "Fehler beheben, Netzwerk, Debloat"
        "M_Act" = "WINDOWS ACTIVATOR"; "D_Act" = "Aktivierung Windows/Office (MAS)"
        "M_Diag" = "PC DIAGNOSE"; "D_Diag" = "Hardware Info und Gesundheit"
        "M_Set" = "EINSTELLUNGEN"; "D_Set" = "Sprache, Updates und Reset"
        "M_Exit" = "BEENDEN"; "D_Exit" = "Schliessen"
        "Choose" = "Wahlen Sie eine Option:"
        "Wait" = "Druecken Sie eine Taste..."
        "Back" = "ZURUCK" ; "D_Back" = "Vorheriges Menu"
        "S_Lang" = "SPRACHE ANDERN"; "DS_Lang" = "Wechseln zu PT, EN, ES, FR, RU"
        "S_Upd" = "UPDATE ERZWINGEN"; "DS_Upd" = "Neu herunterladen von GitHub"
        "S_Rst" = "RESET CONFIG"; "DS_Rst" = "Einstellungen loschen"
        "Msg_Clean" = "Reinigung"
        "Msg_Done" = "Fertig!"
        "Msg_Wait" = "Warten..."
        "Msg_UpdateOK" = "[OK] Update erfolgreich!"
        "Msg_UpdateFail" = "[FEHLER] Download fehlgeschlagen."
        "G_Timer" = "LATENZ VERRINGERN"; "DG_Timer" = "Windows Timer (0.5ms)"
        "G_Prio" = "HOHE PRIORITAT"; "DG_Prio" = "CPU Fokus auf Spiel"
        "G_FSO" = "VOLLBILD OPTIMIERUNG"; "DG_FSO" = "Fix Alt+Tab Lag"
        "G_Mouse" = "MAUS PRAZISION 1:1"; "DG_Mouse" = "Beschleunigung aus"
        "G_Keys" = "TASTATUR OPTIMIEREN"; "DG_Keys" = "Schnelle Reaktion"
        "G_Net" = "NETZWERK PAKETE"; "DG_Net" = "TCP fur Online Spiele"
        "G_Ram" = "RAM AUTO-CLEAN"; "DG_Ram" = "Auto alle 10 Min"
        "G_Def" = "DEFENDER AUSNAHME"; "DG_Def" = "Spielordner ignorieren"
        "G_Dx" = "DIRECTX SHADER RESET"; "DG_Dx" = "Fix Ruckler (GPU Cache)"
        "Y_WinUtil" = "WINUTIL (CHRIS TITUS)"; "DY_WinUtil" = "Externes Tool"
        "Y_Upd" = "FIX WINDOWS UPDATE"; "DY_Upd" = "Updates reparieren"
        "Y_Dns" = "BESTE DNS (PING)"; "DY_Dns" = "Google oder Cloudflare"
        "Y_Rep" = "SYSTEMDATEIEN REP."; "DY_Rep" = "SFC und DISM"
        "Y_Orphan" = "AUFGABEN BEREINIGEN"; "DY_Orphan" = "Ungultige Trigger loschen"
        "Y_Apps" = "BLOATWARE LOSCHEN"; "DY_Apps" = "Cortana, XboxBar weg"
        "Y_Tel" = "TELEMETRIE AUS"; "DY_Tel" = "Tracking stoppen"
        "Y_Adv" = "ERWEITERT >>"; "DY_Adv" = "OneDrive, Bluetooth..."
        "A_One" = "ONEDRIVE LOSCHEN"; "DA_One" = "App und Reste entfernen"
        "A_Font" = "FONT CACHE RESET"; "DA_Font" = "Fix unscharfer Text"
        "A_Blue" = "FIX BLUETOOTH"; "DA_Blue" = "Kopplung fixen"
        "A_Store" = "STORE RESTORE"; "DA_Store" = "Windows Apps reset"
        "A_Own" = "BESITZ UBERNEHMEN"; "DA_Own" = "Kontextmenu Admin"
    }
    "RU" = @{
        "LangName" = "Russian"
        "Welcome" = "Viberite yazik:"
        "M_Opt" = "OPTIMIZE NOW (SSD)"; "D_Opt" = "Ochistka korziny, sistemy i RAM"
        "M_Lite" = "LITE OPTIMIZATION (HDD)"; "D_Lite" = "Bezopasno dlya staryh diskov"
        "M_Gamer" = "GAMING TOOLS"; "D_Gamer" = "FPS boost, fix laga myshi"
        "M_Sys" = "SYSTEM TOOLS"; "D_Sys" = "Ispravlenie oshibok, set"
        "M_Act" = "WINDOWS ACTIVATOR"; "D_Act" = "Aktivatsiya Windows/Office"
        "M_Diag" = "PC DIAGNOSTICS"; "D_Diag" = "Info o zheleze i zdorovye"
        "M_Set" = "SETTINGS"; "D_Set" = "Yazik, obnovlenie i sbros"
        "M_Exit" = "EXIT"; "D_Exit" = "Zakryt"
        "Choose" = "Viberite opciyu:"
        "Wait" = "Nazhmite lyubuyu klavishu..."
        "Back" = "NAZAD" ; "D_Back" = "Predydushchee menyu"
        "S_Lang" = "SMENIT YAZIK"; "DS_Lang" = "PT, EN, ES, FR, DE, CN"
        "S_Upd" = "OBNOVIT SKRIPT"; "DS_Upd" = "Skachat zanovo s GitHub"
        "S_Rst" = "SBROS NASTROEK"; "DS_Rst" = "Udalit config i perezapustit"
        "Msg_Clean" = "Ochistka"
        "Msg_Done" = "Gotovo!"
        "Msg_Wait" = "Podozhdite..."
        "Msg_UpdateOK" = "[OK] Obnovleno! Perezapustite."
        "Msg_UpdateFail" = "[ERROR] Oshibka."
        "G_Timer" = "UMENSHIT ZADERZHKU"; "DG_Timer" = "Timer Resolution (0.5ms)"
        "G_Prio" = "VJYSOKIY PRIORITET"; "DG_Prio" = "CPU fokus na igru"
        "G_FSO" = "OTKLYUCHIT FSO"; "DG_FSO" = "Fix Alt+Tab laga"
        "G_Mouse" = "TOCHNOST MYSHI 1:1"; "DG_Mouse" = "Bez uskoreniya"
        "G_Keys" = "OPTIMIZACIYA KLAVY"; "DG_Keys" = "Bystry otklik"
        "G_Net" = "OPTIMIZACIYA SETI"; "DG_Net" = "TCP dlya onlayn igr"
        "G_Ram" = "RAM AUTO-CLEAN"; "DG_Ram" = "Avto-ochistka 10 min"
        "G_Def" = "ISKLYUCHENIYA DEFENDER"; "DG_Def" = "Ne skanirovat igru"
        "G_Dx" = "DIRECTX SHADER RESET"; "DG_Dx" = "Fix stutters (GPU)"
        "Y_WinUtil" = "WINUTIL (CHRIS TITUS)"; "DY_WinUtil" = "Vneshniy instrument"
        "Y_Upd" = "FIX WINDOWS UPDATE"; "DY_Upd" = "Pochinit obnovleniya"
        "Y_Dns" = "LUCHSHIY DNS"; "DY_Dns" = "Google ili Cloudflare"
        "Y_Rep" = "POCHINIT SISTEMU"; "DY_Rep" = "SFC i DISM"
        "Y_Orphan" = "OCHISTKA ZADACH"; "DY_Orphan" = "Udalit pustye taski"
        "Y_Apps" = "UDALIT BLOATWARE"; "DY_Apps" = "Cortana, XboxBar"
        "Y_Tel" = "OTKLYUCHIT SLEZHKU"; "DY_Tel" = "Stop Telemetry"
        "Y_Adv" = "DOPOlNITELNO >>"; "DY_Adv" = "OneDrive, Bluetooth..."
        "A_One" = "UDALIT ONEDRIVE"; "DA_One" = "Polnoe udalenie"
        "A_Font" = "SBROS FONT CACHE"; "DA_Font" = "Fix razmytogo teksta"
        "A_Blue" = "FIX BLUETOOTH"; "DA_Blue" = "Pochinit soedinenie"
        "A_Store" = "RESTORE STORE"; "DA_Store" = "Pereustanovka Apps"
        "A_Own" = "TAKE OWNERSHIP"; "DA_Own" = "Prava vladelca"
    }
    "CN" = @{
        "LangName" = "Chinese (Simplified)"
        "Welcome" = "Qing xuan ze yu yan:"
        "M_Opt" = "YOU HUA (SSD)"; "D_Opt" = "Qing kong hui shou zhan, xi tong he RAM"
        "M_Lite" = "QING LIANG YOU HUA (HDD)"; "D_Lite" = "An quan qing li jiu ying pan"
        "M_Gamer" = "YOU XI GONG JU"; "D_Gamer" = "Ti gao FPS, xiu fu shu biao yi chi"
        "M_Sys" = "XI TONG GONG JU"; "D_Sys" = "Xiu fu cuo wu, wang luo he jing jian"
        "M_Act" = "WINDOWS JI HUO"; "D_Act" = "Yong jiu ji huo Windows/Office"
        "M_Diag" = "DIAN NAO ZHEN DUAN"; "D_Diag" = "Ying jian xin xi he jian kang"
        "M_Set" = "SHE ZHI"; "D_Set" = "Yu yan, geng xin he chong zhi"
        "M_Exit" = "TUI CHU"; "D_Exit" = "Guan bi"
        "Choose" = "Qing xuan ze:"
        "Wait" = "An ren yi jian fan hui..."
        "Back" = "FAN HUI" ; "D_Back" = "Shang yi ji cai dan"
        "S_Lang" = "GENG GAI YU YAN"; "DS_Lang" = "Qie huan dao PT, EN, ES..."
        "S_Upd" = "QIAN ZHI GENG XIN"; "DS_Upd" = "Cong GitHub chong xin xia zai"
        "S_Rst" = "CHONG ZHI PEI ZHI"; "DS_Rst" = "Qing chu she zhi bing chong qi"
        "Msg_Clean" = "Qing li zhong"
        "Msg_Done" = "Wan cheng!"
        "Msg_Wait" = "Qing shao hou..."
        "Msg_UpdateOK" = "[OK] Geng xin cheng gong! Qing chong qi."
        "Msg_UpdateFail" = "[ERROR] Xia zai shi bai."
        "G_Timer" = "JIANG DI YAN CHI"; "DG_Timer" = "Windows shi zhong (0.5ms)"
        "G_Prio" = "QIAN ZHI GAO YOU XIAN"; "DG_Prio" = "CPU ju jiao you xi"
        "G_FSO" = "JIN YONG QUAN PING YOU HUA"; "DG_FSO" = "Xiu fu Alt+Tab ka dun"
        "G_Mouse" = "SHU BIAO JING DU 1:1"; "DG_Mouse" = "Jin yong jia su"
        "G_Keys" = "JIAN PAN YOU HUA"; "DG_Keys" = "Kuai su xiang ying"
        "G_Net" = "YOU HUA WANG LUO"; "DG_Net" = "TCP you xi you hua"
        "G_Ram" = "RAM ZI DONG QING LI"; "DG_Ram" = "Mei 10 fen zhong qing li"
        "G_Def" = "DEFENDER PAI CHU"; "DG_Def" = "Hu lve you xi mu lu"
        "G_Dx" = "DIRECTX SHADER CHONG ZHI"; "DG_Dx" = "Xiu fu ka dun (GPU)"
        "Y_WinUtil" = "WINUTIL (CHRIS TITUS)"; "DY_WinUtil" = "Wai bu gong ju"
        "Y_Upd" = "XIU FU WINDOWS UPDATE"; "DY_Upd" = "Xiu fu geng xin"
        "Y_Dns" = "ZUI JIA DNS"; "DY_Dns" = "Xuan ze Google huo Cloudflare"
        "Y_Rep" = "XIU FU XI TONG"; "DY_Rep" = "SFC he DISM"
        "Y_Orphan" = "QING LI CAN LIU REN WU"; "DY_Orphan" = "Shan chu wu xiao chu fa qi"
        "Y_Apps" = "SHAN CHU YU ZHUANG"; "DY_Apps" = "Shan chu Cortana, XboxBar"
        "Y_Tel" = "JIN YONG YAO CE"; "DY_Tel" = "Ting zhi Windows gen zong"
        "Y_Adv" = "GAO JI GONG JU >>"; "DY_Adv" = "OneDrive, Bluetooth..."
        "A_One" = "SHAN CHU ONEDRIVE"; "DA_One" = "Shan chu ying yong he can liu"
        "A_Font" = "CHONG ZHI ZI TI HUA CUN"; "DA_Font" = "Xiu fu mo hu wen zi"
        "A_Blue" = "XIU FU BLUETOOTH"; "DA_Blue" = "Xiu fu pei dui"
        "A_Store" = "HUI FU SHANG DIAN"; "DA_Store" = "Chong zhuang Windows Apps"
        "A_Own" = "HUO QU SUO YOU QUAN"; "DA_Own" = "You jian guan li yuan"
    }
}

$LangFile = "$ScriptPath\lang.ini"

# ================= SELETOR DE IDIOMA GRAFICO =================
function Select-Language-GUI {
    Clear-Host; Write-Host "`n"
    Show-Center "  _______  __   __  _______  _______  _______  __   __  " "Cyan"
    Show-Center " |       ||  | |  ||       ||       ||       ||  |_|  | " "Cyan"
    Show-Center " |  _____||  |_|  ||  _____||_     _||    ___||       | " "Cyan"
    Show-Center " | |_____ |       || |_____   |   |  |   |___ |       | " "Cyan"
    Show-Center " |_____  ||_     _||_____  |  |   |  |    ___||       | " "Cyan"
    Show-Center "  _____| |  |   |   _____| |  |   |  |   |___ | ||_|| | " "Cyan"
    Show-Center " |_______|  |___|  |_______|  |___|  |_______||_|   |_| " "Cyan"
    Show-Center "  _______  _______  _______  ___  __   __  ___  _______  _______  ______   " "Cyan"
    Show-Center " |       ||       ||       ||   ||  |_|  ||   ||       ||       ||    _ |  " "Cyan"
    Show-Center " |   _   ||    _  ||_     _||   ||       ||   ||____   ||    ___||   | ||  " "Cyan"
    Show-Center " |  | |  ||   |_| |  |   |  |   ||       ||   ||____|  ||   |___ |   |_||_ " "Cyan"
    Show-Center " |  |_|  ||    ___|  |   |  |   ||       ||   || ______||    ___||    __  |" "Cyan"
    Show-Center " |       ||   |      |   |  |   || ||_|| ||   || |_____ |   |___ |   |  | |" "Cyan"
    Show-Center " |_______||___|      |___|  |___||_|   |_||___||_______||_______||___|  |_|" "Cyan"
    Write-Host ""
    Show-Center " GLOBAL LANGUAGE SELECTOR " "DarkGray"
    Write-Host "`n"
    
    Show-Center "[1] Portugues (Brasil)" "White"
    Show-Center "[2] English (Global)" "White"
    Show-Center "[3] Espanol" "White"
    Show-Center "[4] Francais" "White"
    Show-Center "[5] Deutsch" "White"
    Show-Center "[6] Russian" "White"
    Show-Center "[7] Chinese (Pinyin)" "White"
    
    Write-Host "`n"; Show-Center "Input Number:" "Cyan"
    $choice = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
    switch ($choice) {
        '2' { Set-Content $LangFile "EN" }
        '3' { Set-Content $LangFile "ES" }
        '4' { Set-Content $LangFile "FR" }
        '5' { Set-Content $LangFile "DE" }
        '6' { Set-Content $LangFile "RU" }
        '7' { Set-Content $LangFile "CN" }
        Default { Set-Content $LangFile "PT" }
    }
}

# Carrega idioma ou chama o seletor
if (-not (Test-Path $LangFile)) { Select-Language-GUI }
$UserLang = Get-Content $LangFile
# Fallback se o arquivo estiver corrompido
if (-not $Dict.ContainsKey($UserLang)) { $UserLang = "PT" }

function Get-Text($key) { 
    if ($Dict[$UserLang][$key]) { return $Dict[$UserLang][$key] }
    return "[$key]" # Retorna a chave se faltar traducao
}

# ================= CÓDIGO C# E VISUAL =================

$Kernel32 = @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("ntdll.dll")]
    public static extern int NtSetTimerResolution(uint DesiredResolution, bool SetResolution, ref uint CurrentResolution);
    [DllImport("psapi.dll")]
    public static extern int EmptyWorkingSet(IntPtr hwProc);
}
"@
try { Add-Type -TypeDefinition $Kernel32 -PassThru | Out-Null } catch {}

try {
    $RawUI = $Host.UI.RawUI
    $Buf = $RawUI.BufferSize
    $Buf.Width = 120; $Buf.Height = 3000
    $RawUI.BufferSize = $Buf
} catch {}

function Show-Center {
    param([string]$Text, [string]$Color = "White")
    $Trimmed = $Text.Trim()
    $PadLeft = [math]::Floor(($FixedW - $Trimmed.Length) / 2)
    if ($PadLeft -lt 0) { $PadLeft = 0 }
    Write-Host (" " * $PadLeft) -NoNewline
    Write-Host "$Trimmed" -ForegroundColor $Color
}

function Show-Dual-Center {
    param([string]$LeftText, [string]$RightText, [string]$ColorL="White", [string]$ColorR="White")
    $TotalLen = $LeftText.Length + 5 + $RightText.Length
    $PadLeft = [math]::Floor(($FixedW - $TotalLen) / 2)
    if ($PadLeft -lt 0) { $PadLeft = 0 }
    Write-Host (" " * $PadLeft) -NoNewline
    Write-Host "$LeftText     " -NoNewline -ForegroundColor $ColorL
    Write-Host "$RightText" -ForegroundColor $ColorR
}

function Show-Pyramid {
    param([array]$List, [string]$Color = "White")
    $Sorted = $List | Sort-Object Length -Descending
    foreach ($Item in $Sorted) { Show-Center $Item $Color }
}

function Draw-Separator { Show-Center "--------------------------------------------------------------------------------" "DarkGray" }

function Draw-Header {
    Clear-Host; Write-Host "`n"
    Show-Center "  _______  __   __  _______  _______  _______  __   __  " "Cyan"
    Show-Center " |       ||  | |  ||       ||       ||       ||  |_|  | " "Cyan"
    Show-Center " |  _____||  |_|  ||  _____||_     _||    ___||       | " "Cyan"
    Show-Center " | |_____ |       || |_____   |   |  |   |___ |       | " "Cyan"
    Show-Center " |_____  ||_     _||_____  |  |   |  |    ___||       | " "Cyan"
    Show-Center "  _____| |  |   |   _____| |  |   |  |   |___ | ||_|| | " "Cyan"
    Show-Center " |_______|  |___|  |_______|  |___|  |_______||_|   |_| " "Cyan"
    Show-Center "  _______  _______  _______  ___  __   __  ___  _______  _______  ______   " "Cyan"
    Show-Center " |       ||       ||       ||   ||  |_|  ||   ||       ||       ||    _ |  " "Cyan"
    Show-Center " |   _   ||    _  ||_     _||   ||       ||   ||____   ||    ___||   | ||  " "Cyan"
    Show-Center " |  | |  ||   |_| |  |   |  |   ||       ||   ||____|  ||   |___ |   |_||_ " "Cyan"
    Show-Center " |  |_|  ||    ___|  |   |  |   ||       ||   || ______||    ___||    __  |" "Cyan"
    Show-Center " |       ||   |      |   |  |   || ||_|| ||   || |_____ |   |___ |   |  | |" "Cyan"
    Show-Center " |_______||___|      |___|  |___||_|   |_||___||_______||_______||___|  |_|" "Cyan"
    Write-Host ""
    Show-Center " COMMAND CENTER $Version | LANG: $UserLang " "DarkGray"
    Write-Host "`n"
}

function Draw-Menu-Item {
    param($Num, $Title, $Action, $Desc)
    $PadStart = " " * 8
    Write-Host "$PadStart" -NoNewline
    Write-Host "[$Num] " -NoNewline -ForegroundColor Cyan
    $T = "$Title".PadRight(28)
    Write-Host "$T" -NoNewline -ForegroundColor White
    $A = "[$Action]".PadRight(12)
    
    $AColor = "DarkGray"
    if ($Action -eq "LIMPEZA") { $AColor = "Green" }
    elseif ($Action -eq "LITE") { $AColor = "Green" }
    elseif ($Action -eq "GAMER") { $AColor = "Magenta" }
    elseif ($Action -eq "SISTEMA") { $AColor = "Yellow" }
    elseif ($Action -eq "INFO") { $AColor = "Cyan" }
    elseif ($Action -eq "ATIVADOR") { $AColor = "Red" }
    elseif ($Action -eq "ADVANCED") { $AColor = "Red" }
    elseif ($Action -eq "SETTINGS") { $AColor = "Blue" }
    
    Write-Host "$A " -NoNewline -ForegroundColor $AColor
    Write-Host "- $Desc" -ForegroundColor Gray
}

function Wait-User {
    Write-Host "`n"; Show-Center (Get-Text "Wait") "DarkGray"
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Get-SizeMB ($Path) {
    $Items = Get-ChildItem $Path -Recurse -File -ErrorAction SilentlyContinue
    if ($Items) {
        $Sum = ($Items | Measure-Object -Property Length -Sum).Sum
        if ($Sum) { return [math]::Round($Sum / 1MB, 2) }
    }
    return 0
}

# ================= SISTEMA DE UPDATE APRIMORADO =================

function Start-AutoUpdate {
    Show-Center (Get-Text "Msg_Wait") "DarkGray"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    
    try {
        Show-Center "Motor (PowerShell)..." "Cyan"
        $NewScript = Invoke-RestMethod -Uri $UpdateURL -UseBasicParsing
        if ($NewScript -match "SYSTEM OPTIMIZER CORE") { Set-Content -Path $global:CurrentFile -Value $NewScript -Force }
        
        # AGORA BAIXA O .BAT TAMBEM
        Show-Center "Launcher (Batch)..." "Cyan"
        $NewBat = Invoke-RestMethod -Uri $BatURL -UseBasicParsing
        if ($NewBat -match "SYSTEM OPTIMIZER") { Set-Content -Path "$ScriptPath\SystemOptimizer.bat" -Value $NewBat -Force }

        Show-Center "Changelog..." "Cyan"
        $NewChangelog = Invoke-RestMethod -Uri $ChangelogURL -UseBasicParsing
        if ($NewChangelog -match "Changelog") { Set-Content -Path "$ScriptPath\CHANGELOG.md" -Value $NewChangelog -Force }

        Show-Center "README..." "Cyan"
        $NewReadme = Invoke-RestMethod -Uri $ReadmeURL -UseBasicParsing
        if ($NewReadme -match "System Optimizer") { Set-Content -Path "$ScriptPath\README.md" -Value $NewReadme -Force }

        Show-Center (Get-Text "Msg_UpdateOK") "Green"
    } catch {
        Show-Center "Error: $($_.Exception.Message)" "Red"
    }
    Wait-User
}

# ================= MODULOS DE SETTINGS =================
function Modulo-Settings {
    do {
        Clear-Host; Draw-Header; Show-Center "=== SETTINGS / AJUSTES ===" "Blue"; Write-Host ""
        
        Draw-Menu-Item "1" (Get-Text "S_Lang") "SETTINGS" (Get-Text "DS_Lang")
        Draw-Separator
        Draw-Menu-Item "2" (Get-Text "S_Upd") "SETTINGS" (Get-Text "DS_Upd")
        Draw-Separator
        Draw-Menu-Item "3" (Get-Text "S_Rst") "SETTINGS" (Get-Text "DS_Rst")
        Draw-Separator
        Draw-Menu-Item "0" (Get-Text "Back") "---" (Get-Text "D_Back")
        
        Write-Host "`n"; Show-Center (Get-Text "Choose") "Cyan"
        $K = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
        switch ($K) {
            '1' { 
                Remove-Item $LangFile -Force -ErrorAction SilentlyContinue
                Select-Language-GUI
                return # Forca recarregar o menu principal com novo idioma
            }
            '2' { Start-AutoUpdate }
            '3' { 
                Remove-Item $LangFile -Force -ErrorAction SilentlyContinue
                Show-Center (Get-Text "Msg_Done") "Green"
                Start-Sleep 1
                exit # Fecha para reiniciar limpo
            }
            '0' { return }
        }
    } while ($true)
}

# ================= FUNCOES ESPECIAIS =================

function Start-DirectXShaderClear {
    Show-Center (Get-Text "Msg_Clean") "Cyan"
    $Paths = @("$env:LOCALAPPDATA\AMD\DxCache", "$env:LOCALAPPDATA\NVIDIA\GLCache", "$env:LOCALAPPDATA\D3DSCache")
    foreach ($P in $Paths) { if (Test-Path $P) { Remove-Item "$P\*" -Recurse -Force -ErrorAction SilentlyContinue } }
    Cleanmgr /sagerun:64 | Out-Null
    Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2
}

function Start-OneDriveRemoval {
    Show-Center (Get-Text "Msg_Wait") "Red"
    $K = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown"); if ($K.VirtualKeyCode -eq 27) { return }
    taskkill /f /im OneDrive.exe | Out-Null
    if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") { Start-Process "$env:systemroot\System32\OneDriveSetup.exe" -ArgumentList "/uninstall" -Wait }
    Remove-Item "$env:USERPROFILE\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
    Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2
}

function Start-BluetoothCacheFix {
    Stop-Service bthserv -Force -ErrorAction SilentlyContinue
    Remove-Item "HKLM:\SYSTEM\CurrentControlSet\Services\BTHPORT\Parameters\Keys\*" -Recurse -Force -ErrorAction SilentlyContinue
    Start-Service bthserv -ErrorAction SilentlyContinue
    Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2
}

function Start-FontCacheReset {
    Stop-Service FontCache -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\*.dat" -Force -ErrorAction SilentlyContinue
    Start-Service FontCache -ErrorAction SilentlyContinue
    Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2
}

function Start-TimerResolution {
    Clear-Host; Show-Center (Get-Text "G_Timer") "Magenta"
    Show-Center (Get-Text "Msg_Wait") "Yellow"
    Write-Host ""; $C = 0; [Win32]::NtSetTimerResolution(5000, $true, [ref]$C)
    Show-Center "ATIVO: 0.5ms" "Green"
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    [Win32]::NtSetTimerResolution(156000, $true, [ref]$C)
}

function Start-FilterKeys {
    $Path = "HKCU:\Control Panel\Accessibility\Keyboard Response"
    Set-ItemProperty $Path -Name "AutoRepeatDelay" -Value "150" -Force
    Set-ItemProperty $Path -Name "AutoRepeatRate" -Value "15" -Force
    Set-ItemProperty $Path -Name "Flags" -Value "126" -Force
    Show-Center (Get-Text "Msg_Done") "Green"
}

function Start-NetworkPacketReducer {
    $Interfaces = Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\*"
    foreach ($Interface in $Interfaces) {
        New-ItemProperty -Path $Interface.PSPath -Name "TcpAckFrequency" -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
        New-ItemProperty -Path $Interface.PSPath -Name "TCPNoDelay" -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
    }
    Show-Center (Get-Text "Msg_Done") "Green"
}

function Start-RAMCleaner {
    $Procs = Get-Process
    foreach ($P in $Procs) { try { [void][Win32]::EmptyWorkingSet($P.Handle) } catch {} }
    [System.GC]::Collect() | Out-Null
}

function Start-TakeOwnership {
    Show-Center (Get-Text "Msg_Wait") "Cyan"
    $RegFile = "HKCR\*\shell\runas"; $RegDir = "HKCR\Directory\shell\runas"
    New-Item -Path $RegFile -Force | Out-Null
    Set-ItemProperty -Path $RegFile -Name "(default)" -Value "Tomar Posse"
    Set-ItemProperty -Path $RegFile -Name "Icon" -Value "imageres.dll,-78"
    New-Item -Path "$RegFile\command" -Force | Out-Null
    Set-ItemProperty -Path "$RegFile\command" -Name "(default)" -Value "cmd.exe /c takeown /f `"%1`" && icacls `"%1`" /grant administrators:F"
    New-Item -Path $RegDir -Force | Out-Null
    Set-ItemProperty -Path $RegDir -Name "(default)" -Value "Tomar Posse"
    Set-ItemProperty -Path $RegDir -Name "Icon" -Value "imageres.dll,-78"
    New-Item -Path "$RegDir\command" -Force | Out-Null
    Set-ItemProperty -Path "$RegDir\command" -Name "(default)" -Value "cmd.exe /c takeown /f `"%1`" /r /d y && icacls `"%1`" /grant administrators:F /t"
    Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2
}

function Start-RAMBackground {
    Show-Center (Get-Text "Msg_Wait") "Cyan"
    $JobCode = {
        $Kernel32 = @"
        using System;
        using System.Runtime.InteropServices;
        public class Win32 { [DllImport("psapi.dll")] public static extern int EmptyWorkingSet(IntPtr hwProc); }
"@
        Add-Type -TypeDefinition $Kernel32 -PassThru | Out-Null
        while($true) {
            foreach ($P in Get-Process) { try { [void][Win32]::EmptyWorkingSet($P.Handle) } catch {} }
            [System.GC]::Collect()
            Start-Sleep -Seconds 600
        }
    }
    Start-Job -ScriptBlock $JobCode -Name "RamOptimizer"
    Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2
}

function Start-DefenderExclusion {
    Show-Center "Path:" "White"
    $Path = Read-Host
    if (Test-Path $Path) {
        Add-MpPreference -ExclusionPath $Path
        Show-Center (Get-Text "Msg_Done") "Green"
    }
    Start-Sleep 2
}

function Start-BottleneckTest {
    Clear-Host; Show-Center (Get-Text "M_Diag") "Cyan"
    Show-Center (Get-Text "Msg_Wait") "Gray"; Write-Host ""
    $CpuLoad = 0
    for ($i=1; $i -le 10; $i++) {
        $Val = (Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average
        $CpuLoad += $Val
        Write-Host "`r Sample $i/10: $Val% CPU" -NoNewline -ForegroundColor Green; Start-Sleep 1
    }
    $Avg = [math]::Round($CpuLoad / 10, 1)
    Write-Host "`n"; Show-Center "CPU AVG: $Avg%" "White"
    Wait-User
}

function Start-JitterTest {
    Clear-Host; Show-Center (Get-Text "Msg_Wait") "Cyan"
    $Pings = @(); $Total = 0
    for ($i=1; $i -le 10; $i++) {
        $Ms = (Test-Connection 8.8.8.8 -Count 1).ResponseTime
        $Pings += $Ms; $Total += $Ms
        Write-Host "`r Ping $i/10: ${Ms}ms" -NoNewline -ForegroundColor Green; Start-Sleep -Milliseconds 200
    }
    $Avg = $Total / 10; $JitterSum = 0
    for ($i=0; $i -lt 9; $i++) { $JitterSum += [math]::Abs($Pings[$i] - $Pings[$i+1]) }
    $Jitter = [math]::Round($JitterSum / 9, 2)
    Write-Host "`n"; Show-Center "Ping: $Avg ms | Jitter: $Jitter ms" "White"
    Wait-User
}

function Start-AppxRestore {
    Show-Center (Get-Text "Msg_Wait") "Cyan"
    Get-AppxPackage -AllUsers | ForEach-Object {
        Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" -ErrorAction SilentlyContinue
    }
    Show-Center (Get-Text "Msg_Done") "Green"
}

function Start-NetAdapterReset {
    Show-Center (Get-Text "Msg_Wait") "Cyan"
    $Adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
    foreach ($A in $Adapters) {
        Disable-NetAdapter -Name $A.Name -Confirm:$false -ErrorAction SilentlyContinue
        Start-Sleep 2
        Enable-NetAdapter -Name $A.Name -Confirm:$false -ErrorAction SilentlyContinue
    }
    Show-Center (Get-Text "Msg_Done") "Green"
}

function Start-CopilotToggle {
    Show-Center (Get-Text "Msg_Wait") "Cyan"
    $RegPath = "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot"
    if (-not (Test-Path $RegPath)) { New-Item -Path $RegPath -Force | Out-Null }
    Set-ItemProperty -Path $RegPath -Name "TurnOffWindowsCopilot" -Value 1 -Force
    $RegExplorer = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    Set-ItemProperty -Path $RegExplorer -Name "ShowCopilotButton" -Value 0 -Force
    Show-Center (Get-Text "Msg_Done") "Green"
}

# ================= MODULOS DE OTIMIZACAO =================

function Modulo-Otimizacao {
    Show-Center (Get-Text "M_Opt") "White"; Write-Host ""
    $TotalFreedMB = 0
    
    Show-Center (Get-Text "Msg_Wait") "Yellow"
    Stop-Service wuauserv -Force -ErrorAction SilentlyContinue; Stop-Service bits -Force -ErrorAction SilentlyContinue

    $Steps = @(
        @{Name="Temp User"; Path="$env:TEMP\*"},
        @{Name="Temp Win"; Path="$env:WINDIR\Temp\*"},
        @{Name="Prefetch"; Path="$env:WINDIR\Prefetch\*"},
        @{Name="Update Cache"; Path="$env:WINDIR\SoftwareDistribution\Download\*"},
        @{Name="Logs"; Path="$env:WINDIR\Logs\*"},
        @{Name="Crash Dumps"; Path="$env:LOCALAPPDATA\Microsoft\Windows\WER\*"}
    )

    foreach ($Step in $Steps) {
        $Size = Get-SizeMB $Step.Path; $TotalFreedMB += $Size
        Show-Center "$(Get-Text 'Msg_Clean') $($Step.Name) ($Size MB)..." "Cyan"
        try { Get-ChildItem $Step.Path -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue } catch {}
        Start-Sleep -Milliseconds 50
    }

    try { Clear-RecycleBin -Force -ErrorAction SilentlyContinue | Out-Null } catch {}
    try { Remove-Item "$env:LOCALAPPDATA\IconCache.db" -Force -ErrorAction SilentlyContinue } catch {}

    $BrowserSize = 0
    $Browsers = @("$env:LOCALAPPDATA\Vivaldi\User Data\Default\Cache", "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache", "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache")
    foreach ($P in $Browsers) { 
        if (Test-Path $P) { 
            $BrowserSize += Get-SizeMB "$P\*"; Remove-Item "$P\*" -Recurse -Force -ErrorAction SilentlyContinue 
        } 
    }
    $TotalFreedMB += $BrowserSize
    Show-Center "$(Get-Text 'Msg_Clean') Browser Cache ($BrowserSize MB)..." "Cyan"
    wevtutil el | ForEach-Object { [void](wevtutil cl "$_" 2>$null) }
    
    netsh int tcp set global rss=enabled | Out-Null
    fsutil behavior set memoryusage 2 | Out-Null
    Start-RAMCleaner; ipconfig /flushdns | Out-Null
    
    Start-Service wuauserv -ErrorAction SilentlyContinue; Start-Service bits -ErrorAction SilentlyContinue
    try { Optimize-Volume -DriveLetter C -ReTrim -ErrorAction SilentlyContinue | Out-Null } catch {}

    Write-Host "`n"; Show-Center "TOTAL: $TotalFreedMB MB" "Green"
    Show-Center (Get-Text "Msg_Done") "Green"
    
    [System.Media.SystemSounds]::Exclamation.Play(); Wait-User
}

function Modulo-Lite {
    Show-Center (Get-Text "M_Lite") "White"; Write-Host ""
    $TotalFreedMB = 0
    
    $Steps = @(@{Name="Temp User"; Path="$env:TEMP\*"}, @{Name="Temp Win"; Path="$env:WINDIR\Temp\*"}, @{Name="Logs"; Path="$env:WINDIR\Logs\*"})
    foreach ($Step in $Steps) { 
        $Size = Get-SizeMB $Step.Path; $TotalFreedMB += $Size
        Show-Center "$(Get-Text 'Msg_Clean') $($Step.Name)..." "Cyan"
        try { Get-ChildItem $Step.Path -Recurse -Force | Remove-Item -Force -Recurse } catch {} 
    }
    
    $Browsers = @("$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache", "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache")
    foreach ($P in $Browsers) { if (Test-Path $P) { Remove-Item "$P\*" -Recurse -Force -ErrorAction SilentlyContinue } }
    try { Clear-RecycleBin -Force -ErrorAction SilentlyContinue | Out-Null } catch {}
    
    Write-Host "`n"; Show-Center "TOTAL: $TotalFreedMB MB" "Green"
    Show-Center (Get-Text "Msg_Done") "Green"; Wait-User
}

# ================= MENUS SECUNDARIOS =================

function Modulo-Diagnostico {
    Show-Center (Get-Text "M_Diag") "White"; Write-Host ""
    try {
        $OS = Get-CimInstance Win32_OperatingSystem
        $Boot = $OS.LastBootUpTime; $Up = (Get-Date) - $Boot
        Show-Center "Windows: $($OS.Caption) (Build $($OS.BuildNumber))" "White"
        Show-Center "Up: $($Up.Days)d $($Up.Hours)h $($Up.Minutes)m" "White"
    } catch {}
    Write-Host ""
    try {
        $CPU = (Get-CimInstance Win32_Processor).Name
        $GPU = (Get-CimInstance Win32_VideoController | Select-Object -First 1).Name
        $MemInfos = Get-CimInstance Win32_PhysicalMemory
        $RamTotalGB = 0; $RamDetails = @()
        foreach ($M in $MemInfos) {
            $SizeGB = [math]::Round($M.Capacity / 1GB, 0)
            $RamTotalGB += $SizeGB
            $RamDetails += "${SizeGB}GB $($M.Speed)MHz"
        }
        $RamSummary = "$RamTotalGB GB ($($RamDetails -join ' + '))"
        Show-Pyramid @("[GPU] $GPU", "[RAM] $RamSummary", "[CPU] $CPU") "White"
    } catch {}
    Write-Host "`n"; Show-Center "STORAGE" "Cyan"; Write-Host ""
    $Disks = Get-PhysicalDisk | Sort-Object MediaType, Size -Descending
    foreach ($D in $Disks) {
        $Size = [Math]::Round($D.Size / 1GB, 0)
        $Type = if ($D.MediaType -eq "Unspecified") { "SSD" } else { $D.MediaType }
        $Color = if ($D.HealthStatus -eq "Healthy") { "Green" } else { "Red" }
        Show-Dual-Center "$Type - $Size GB - ($($D.Model))" "[$($D.HealthStatus)]" "White" $Color
    }
    Wait-User
}

function Modulo-Gamer {
    do {
        Clear-Host; Draw-Header; Show-Center "=== $(Get-Text 'M_Gamer') ===" "Magenta"; Write-Host ""
        Draw-Menu-Item "1" (Get-Text "G_Timer") "GAMER" (Get-Text "DG_Timer")
        Draw-Separator
        Draw-Menu-Item "2" (Get-Text "G_Prio") "GAMER" (Get-Text "DG_Prio")
        Draw-Separator
        Draw-Menu-Item "3" (Get-Text "G_FSO") "GAMER" (Get-Text "DG_FSO")
        Draw-Separator
        Draw-Menu-Item "4" (Get-Text "G_Mouse") "GAMER" (Get-Text "DG_Mouse")
        Draw-Separator
        Draw-Menu-Item "5" (Get-Text "G_Keys") "GAMER" (Get-Text "DG_Keys")
        Draw-Separator
        Draw-Menu-Item "6" (Get-Text "G_Net") "GAMER" (Get-Text "DG_Net")
        Draw-Separator
        Draw-Menu-Item "7" (Get-Text "G_Ram") "GAMER" (Get-Text "DG_Ram")
        Draw-Separator
        Draw-Menu-Item "8" (Get-Text "G_Def") "GAMER" (Get-Text "DG_Def")
        Draw-Separator
        Draw-Menu-Item "9" (Get-Text "G_Dx") "GAMER" (Get-Text "DG_Dx")
        Draw-Separator
        Draw-Menu-Item "0" (Get-Text "Back") "---" (Get-Text "D_Back")
        
        Write-Host "`n"; Show-Center (Get-Text "Choose") "Cyan"
        $K = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
        switch ($K) {
            '1' { Start-TimerResolution }
            '2' { Show-Center "Ex: cs2.exe"; $G = Read-Host; if ($G) { Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$G\PerfOptions" -Name "CpuPriorityClass" -Value 3 -Force; Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2 } }
            '3' { Set-ItemProperty "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehaviorMode" -Value 2 -Force; Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2 }
            '4' { Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value "0"; Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2 }
            '5' { Start-FilterKeys; Start-Sleep 2 }
            '6' { Start-NetworkPacketReducer; Start-Sleep 2 }
            '7' { Start-RAMBackground }
            '8' { Start-DefenderExclusion }
            '9' { Start-DirectXShaderClear }
            '0' { return }
        }
    } while ($true)
}

function Modulo-SystemTools {
    do {
        Clear-Host; Draw-Header; Show-Center "=== $(Get-Text 'M_Sys') ===" "Yellow"; Write-Host ""
        Draw-Menu-Item "1" (Get-Text "Y_WinUtil") "SISTEMA" (Get-Text "DY_WinUtil")
        Draw-Separator
        Draw-Menu-Item "2" (Get-Text "Y_Upd") "SISTEMA" (Get-Text "DY_Upd")
        Draw-Separator
        Draw-Menu-Item "3" (Get-Text "Y_Dns") "SISTEMA" (Get-Text "DY_Dns")
        Draw-Separator
        Draw-Menu-Item "4" (Get-Text "Y_Rep") "SISTEMA" (Get-Text "DY_Rep")
        Draw-Separator
        Draw-Menu-Item "5" (Get-Text "Y_Orphan") "SISTEMA" (Get-Text "DY_Orphan")
        Draw-Separator
        Draw-Menu-Item "6" (Get-Text "Y_Apps") "SISTEMA" (Get-Text "DY_Apps")
        Draw-Separator
        Draw-Menu-Item "7" (Get-Text "Y_Tel") "SISTEMA" (Get-Text "DY_Tel")
        Draw-Separator
        Draw-Menu-Item "9" (Get-Text "Y_Adv") "SISTEMA" (Get-Text "DY_Adv")
        Draw-Separator
        Draw-Menu-Item "0" (Get-Text "Back") "---" (Get-Text "D_Back")
        
        Write-Host "`n"; Show-Center (Get-Text "Choose") "Cyan"
        $K = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
        switch ($K) {
            '1' { try { irm "https://christitus.com/win" | iex } catch { Show-Center "No Internet" "Red"; Start-Sleep 2 } }
            '2' { Stop-Service wuauserv; Stop-Service bits; Remove-Item "$env:windir\SoftwareDistribution" -Recurse -Force; Start-Service wuauserv; Start-Service bits; Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2 }
            '3' {
                Show-Center (Get-Text "Msg_Wait") "Cyan"
                $G = (Test-Connection 8.8.8.8 -Count 1).ResponseTime; $C = (Test-Connection 1.1.1.1 -Count 1).ResponseTime
                if ($C -lt $G) { Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -ServerAddresses ("1.1.1.1","1.0.0.1"); Show-Center "Cloudflare" "Green" }
                else { Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -ServerAddresses ("8.8.8.8","8.8.4.4"); Show-Center "Google" "Green" }
                Start-Sleep 2
            }
            '4' { Show-Center (Get-Text "Msg_Wait") "Cyan"; sfc /scannow; dism /online /cleanup-image /restorehealth; Wait-User }
            '5' { 
                $Tasks = Get-ScheduledTask | Where-Object { $_.Actions.Execute -ne $null }
                foreach ($T in $Tasks) { $P = $T.Actions.Execute.Replace('"', ''); if ($P -match "^[a-zA-Z]:\\") { if (-not (Test-Path $P)) { Unregister-ScheduledTask -TaskName $T.TaskName -Confirm:$false } } }
                Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2
            }
            '6' { Get-AppxPackage "*Cortana*" | Remove-AppxPackage; Get-AppxPackage "*XboxGamingOverlay*" | Remove-AppxPackage; Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2 }
            '7' { Stop-Service DiagTrack; Set-Service DiagTrack -StartupType Disabled; Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2 }
            '9' { Modulo-SystemTools-Pag2 }
            '0' { return }
        }
    } while ($true)
}

function Modulo-SystemTools-Pag2 {
    do {
        Clear-Host; Draw-Header; Show-Center "=== $(Get-Text 'M_Sys') 2 ===" "Red"; Write-Host ""
        Draw-Menu-Item "1" (Get-Text "A_Store") "SISTEMA" (Get-Text "DA_Store")
        Draw-Separator
        Draw-Menu-Item "2" (Get-Text "A_One") "ADVANCED" (Get-Text "DA_One")
        Draw-Separator
        Draw-Menu-Item "3" (Get-Text "A_Font") "ADVANCED" (Get-Text "DA_Font")
        Draw-Separator
        Draw-Menu-Item "4" (Get-Text "A_Blue") "ADVANCED" (Get-Text "DA_Blue")
        Draw-Separator
        Draw-Menu-Item "5" (Get-Text "A_Own") "SISTEMA" (Get-Text "DA_Own")
        Draw-Separator
        Draw-Menu-Item "0" (Get-Text "Back") "---" (Get-Text "D_Back")
        
        Write-Host "`n"; Show-Center (Get-Text "Choose") "Cyan"
        $K = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
        switch ($K) {
            '1' { Start-AppxRestore; Start-Sleep 2 }
            '2' { Start-OneDriveRemoval }
            '3' { Start-FontCacheReset }
            '4' { Start-BluetoothCacheFix }
            '5' { Start-TakeOwnership }
            '0' { return }
        }
    } while ($true)
}

function Modulo-Mas {
    Clear-Host; Draw-Header; Show-Center (Get-Text "M_Act") "Red"; Write-Host ""
    Show-Center "[1] Windows HWID  |  [2] Office" "White"
    Write-Host ""; Show-Center (Get-Text "Msg_Wait") "Cyan"
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    try { irm https://get.activated.win | iex } catch { Show-Center "No Internet" "Red"; Start-Sleep 2 }
}

# --- MENU PRINCIPAL (100% TRADUZIDO) ---
do {
    Draw-Header
    Draw-Menu-Item "1" (Get-Text "M_Opt") "LIMPEZA" (Get-Text "D_Opt")
    Draw-Separator
    Draw-Menu-Item "2" (Get-Text "M_Lite") "LITE" (Get-Text "D_Lite")
    Draw-Separator
    Draw-Menu-Item "3" (Get-Text "M_Gamer") "GAMER" (Get-Text "D_Gamer")
    Draw-Separator
    Draw-Menu-Item "4" (Get-Text "M_Sys") "SISTEMA" (Get-Text "D_Sys")
    Draw-Separator
    Draw-Menu-Item "5" (Get-Text "M_Act") "ATIVADOR" (Get-Text "D_Act")
    Draw-Separator
    Draw-Menu-Item "6" (Get-Text "M_Diag") "INFO" (Get-Text "D_Diag")
    Draw-Separator
    Draw-Menu-Item "7" (Get-Text "M_Set") "SETTINGS" (Get-Text "D_Set")
    Draw-Separator
    Draw-Menu-Item "0" (Get-Text "M_Exit") "---" (Get-Text "D_Exit")
    
    Write-Host "`n"; Show-Center (Get-Text "Choose") "Cyan"
    $Key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
    switch ($Key) {
        '1' { Modulo-Otimizacao }
        '2' { Modulo-Lite }
        '3' { Modulo-Gamer }
        '4' { Modulo-SystemTools }
        '5' { Modulo-Mas }
        '6' { Modulo-Diagnostico }
        '7' { Modulo-Settings }
        '0' { exit }
    }
} while ($true)
