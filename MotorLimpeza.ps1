# =================================================================
# MOTOR DE OTIMIZACAO V51 (PROJECT PORTFOLIO EDITION)
# =================================================================
$ErrorActionPreference = 'SilentlyContinue'
$FixedW = 100 
$Version = "V51"
# COLOQUE O LINK "RAW" DO SEU GITHUB AQUI DEPOIS:
$UpdateURL = "https://raw.githubusercontent.com/SEU_USUARIO/SEU_REPO/main/MotorLimpeza.ps1"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- CÓDIGO C# (TIMER & MEMORY CLEANER) ---
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

# --- VISUAL E ALINHAMENTO ---
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
    param([string]$LeftText, [string]$RightText, [string]$ColorL="White", [string]$ColorR="Green")
    $TotalLen = $LeftText.Length + 5 + $RightText.Length
    $PadLeft = [math]::Floor(($FixedW - $TotalLen) / 2)
    if ($PadLeft -lt 0) { $PadLeft = 0 }
    Write-Host (" " * $PadLeft) -NoNewline
    Write-Host "$LeftText     " -NoNewline -ForegroundColor $ColorL
    Write-Host "$RightText" -ForegroundColor $ColorR
}

function Draw-Separator {
    Show-Center "--------------------------------------------------------------------------------" "DarkGray"
}

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
    Show-Center " COMMAND CENTER $Version " "DarkGray"
    Write-Host "`n"
}

function Draw-Menu-Item {
    param($Num, $Title, $Action, $Desc)
    $PadStart = " " * 8
    Write-Host "$PadStart" -NoNewline
    Write-Host "[$Num] " -NoNewline -ForegroundColor Cyan
    $T = "$Title".PadRight(26)
    Write-Host "$T" -NoNewline -ForegroundColor White
    $A = "[$Action]".PadRight(12)
    
    $AColor = "DarkGray"
    if ($Action -eq "LIMPEZA") { $AColor = "Green" }
    elseif ($Action -eq "GAMER") { $AColor = "Magenta" }
    elseif ($Action -eq "SISTEMA") { $AColor = "Yellow" }
    elseif ($Action -eq "INFO") { $AColor = "Cyan" }
    elseif ($Action -eq "ATIVADOR") { $AColor = "Red" }
    
    Write-Host "$A " -NoNewline -ForegroundColor $AColor
    Write-Host "- $Desc" -ForegroundColor Gray
}

function Wait-User {
    Write-Host "`n"; Show-Center "Pressione qualquer tecla para voltar..." "DarkGray"
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

# --- FUNÇÕES ESPECIAIS ---

function Start-TimerResolution {
    Clear-Host; Show-Center "--- MODO BAIXA LATENCIA (0.5ms) ---" "Magenta"
    Show-Center "Mantenha esta janela ABERTA enquanto joga." "Yellow"
    Write-Host ""; $C = 0; [Win32]::NtSetTimerResolution(5000, $true, [ref]$C)
    Show-Center "ATIVO: 0.5ms (Tempo de resposta no minimo)" "Green"
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    [Win32]::NtSetTimerResolution(156000, $true, [ref]$C)
}

function Start-FilterKeys {
    $Path = "HKCU:\Control Panel\Accessibility\Keyboard Response"
    Set-ItemProperty $Path -Name "AutoRepeatDelay" -Value "150" -Force
    Set-ItemProperty $Path -Name "AutoRepeatRate" -Value "15" -Force
    Set-ItemProperty $Path -Name "Flags" -Value "126" -Force
    Show-Center "Teclado otimizado para resposta ultra-rapida!" "Green"
}

function Start-NetworkPacketReducer {
    # Aplica TcpAckFrequency em todas as interfaces
    $Interfaces = Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\*"
    foreach ($Interface in $Interfaces) {
        New-ItemProperty -Path $Interface.PSPath -Name "TcpAckFrequency" -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
        New-ItemProperty -Path $Interface.PSPath -Name "TCPNoDelay" -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
    }
    Show-Center "Otimizacao de Pacotes de Rede Aplicada!" "Green"
}

function Start-RAMCleaner {
    $Procs = Get-Process
    foreach ($P in $Procs) { try { [void][Win32]::EmptyWorkingSet($P.Handle) } catch {} }
    [System.GC]::Collect() | Out-Null
}

function Start-AutoUpdate {
    Show-Center "Verificando atualizacoes no GitHub..." "Cyan"
    try {
        $NewScript = Invoke-RestMethod -Uri $UpdateURL
        if ($NewScript -match "SYSTEM OPTIMIZER") {
            Set-Content -Path $MyInvocation.MyCommand.Path -Value $NewScript
            Show-Center "Atualizado com sucesso! Reinicie o script." "Green"
        } else {
            Show-Center "Nenhuma atualizacao encontrada ou erro no link." "Yellow"
        }
    } catch {
        Show-Center "Erro ao conectar. Configure o link do GitHub no script." "Red"
    }
    Wait-User
}

# --- MÓDULOS PRINCIPAIS ---

function Modulo-Diagnostico {
    Show-Center "=== DIAGNOSTICO DO PC ===" "White"; Write-Host ""
    
    # SISTEMA
    try {
        $OS = Get-CimInstance Win32_OperatingSystem
        $Boot = $OS.LastBootUpTime; $Up = (Get-Date) - $Boot
        Show-Center "SISTEMA OPERACIONAL" "Cyan"
        Show-Center "Windows: $($OS.Caption) (Build $($OS.BuildNumber))" "White"
        Show-Center "Ligado ha: $($Up.Days)d $($Up.Hours)h $($Up.Minutes)m" "Gray"
    } catch {}
    
    Write-Host ""
    
    # HARDWARE
    try {
        $CPU = (Get-CimInstance Win32_Processor).Name
        $GPU = (Get-CimInstance Win32_VideoController | Select-Object -First 1).Name
        $Board = Get-CimInstance Win32_BaseBoard
        
        $MemInfos = Get-CimInstance Win32_PhysicalMemory
        $RamTotalGB = 0; $RamDetails = @(); $LowSpeedWarning = $false
        foreach ($M in $MemInfos) {
            $SizeGB = [math]::Round($M.Capacity / 1GB, 0)
            $RamTotalGB += $SizeGB
            $Speed = $M.Speed
            $Manuf = $M.Manufacturer
            $RamDetails += "${SizeGB}GB $Manuf ${Speed}MHz"
            if ($Speed -lt 2666) { $LowSpeedWarning = $true }
        }
        $RamSummary = "$RamTotalGB GB ($($RamDetails -join ' + '))"

        Show-Center "HARDWARE PRINCIPAL" "Cyan"
        Show-Dual-Center "GPU:" "$GPU" "White" "White"
        Show-Dual-Center "RAM:" "$RamSummary" "White" "White"
        Show-Dual-Center "CPU:" "$CPU" "White" "White"
        Show-Dual-Center "MOBO:" "$($Board.Manufacturer) $($Board.Product)" "White" "Gray"
        
        if ($LowSpeedWarning) {
            Write-Host ""
            Show-Center "[ALERTA] RAM com velocidade baixa. Ative o XMP na BIOS." "Red"
        }
    } catch {}

    # DRIVER SCAN
    Write-Host ""
    $BadDrivers = Get-PnpDevice | Where-Object { $_.Status -eq "Error" -or $_.Status -eq "Degraded" }
    if ($BadDrivers) {
        Show-Center "ALERTA: Drivers com erro encontrados!" "Red"
        foreach ($D in $BadDrivers) { Show-Center "$($D.FriendlyName)" "Red" }
    } else {
        Show-Center "Todos os drivers estao funcionando corretamente." "Green"
    }

    Write-Host "`n"; Show-Center "ARMAZENAMENTO" "Cyan"; Write-Host ""
    $Disks = Get-PhysicalDisk | Sort-Object MediaType, Size -Descending
    foreach ($D in $Disks) {
        $Size = [Math]::Round($D.Size / 1GB, 0)
        $Type = if ($D.MediaType -eq "Unspecified") { "SSD" } else { $D.MediaType }
        $Color = if ($D.HealthStatus -eq "Healthy") { "Green" } else { "Red" }
        # Alinhamento Perfeito: Texto Branco, Status Colorido
        Show-Dual-Center "$Type - $Size GB - ($($D.Model))" "[$($D.HealthStatus)]" "White" $Color
    }
    
    Write-Host "`n"; Show-Center "CONEXAO" "Cyan"; Write-Host ""
    try {
        $P1 = (Test-Connection 8.8.8.8 -Count 1).ResponseTime
        $P2 = (Test-Connection 1.1.1.1 -Count 1).ResponseTime
        Show-Dual-Center "Google: ${P1}ms" "Cloudflare: ${P2}ms" "White" "Green"
    } catch { Show-Center "Sem Internet" "Red" }
    
    Wait-User
}

function Modulo-Otimizacao {
    Show-Center "=== FAXINA COMPLETA E OTIMIZACAO ===" "White"; Write-Host ""
    $TotalFreedMB = 0
    
    Show-Center "Parando Servicos do Windows..." "Yellow"
    Stop-Service wuauserv -Force -ErrorAction SilentlyContinue; Stop-Service bits -Force -ErrorAction SilentlyContinue

    $Steps = @(
        @{Name="Lixo do Usuario"; Path="$env:TEMP\*"},
        @{Name="Lixo do Windows"; Path="$env:WINDIR\Temp\*"},
        @{Name="Arquivos de Boot"; Path="$env:WINDIR\Prefetch\*"},
        @{Name="Restos de Atualizacoes"; Path="$env:WINDIR\SoftwareDistribution\Download\*"},
        @{Name="Logs do Sistema"; Path="$env:WINDIR\Logs\*"},
        @{Name="Relatorios de Erros"; Path="$env:LOCALAPPDATA\Microsoft\Windows\WER\*"}
    )

    foreach ($Step in $Steps) {
        $Size = Get-SizeMB $Step.Path; $TotalFreedMB += $Size
        Show-Center "Limpando $($Step.Name) ($Size MB)..." "Cyan"
        try { Get-ChildItem $Step.Path -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue } catch {}
        Start-Sleep -Milliseconds 50
    }

    Show-Center "Esvaziando Lixeira..." "Cyan"
    try { Clear-RecycleBin -Force -ErrorAction SilentlyContinue } catch {}

    Show-Center "Resetando Cache de Icones..." "Cyan"
    try { Remove-Item "$env:LOCALAPPDATA\IconCache.db" -Force -ErrorAction SilentlyContinue } catch {}

    $BrowserSize = 0
    $Browsers = @("$env:LOCALAPPDATA\Vivaldi\User Data\Default\Cache", "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache", "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache")
    foreach ($P in $Browsers) { 
        if (Test-Path $P) { 
            $BrowserSize += Get-SizeMB "$P\*"; Remove-Item "$P\*" -Recurse -Force -ErrorAction SilentlyContinue 
        } 
    }
    $TotalFreedMB += $BrowserSize
    Show-Center "Limpando Lixo dos Navegadores ($BrowserSize MB)..." "Cyan"
    
    Show-Center "Limpando Logs de Eventos..." "Cyan"
    wevtutil el | ForEach-Object { [void](wevtutil cl "$_" 2>$null) }
    
    Show-Center "Otimizando HD, RAM e DNS..." "DarkGray"
    netsh int tcp set global rss=enabled | Out-Null
    fsutil behavior set memoryusage 2 | Out-Null
    Start-RAMCleaner; ipconfig /flushdns | Out-Null
    
    Start-Service wuauserv -ErrorAction SilentlyContinue; Start-Service bits -ErrorAction SilentlyContinue
    try { Optimize-Volume -DriveLetter C -ReTrim -ErrorAction SilentlyContinue | Out-Null } catch {}

    Write-Host "`n"; Show-Center "--- RESUMO DA LIMPEZA ---" "White"
    Show-Center "ESPACO TOTAL LIBERADO: $TotalFreedMB MB" "Green"
    Show-Center "Sistema Limpo, RAM Desafogada e SSD Otimizado." "Green"
    
    [System.Media.SystemSounds]::Exclamation.Play(); Wait-User
}

function Modulo-Gamer {
    do {
        Clear-Host; Draw-Header; Show-Center "=== FERRAMENTAS GAMER ===" "Magenta"; Write-Host ""
        Draw-Menu-Item "1" "REDUZIR LATENCIA (TIMER)" "GAMER" "Abaixa o tempo de resposta do Windows"
        Draw-Separator
        Draw-Menu-Item "2" "FORCAR PRIORIDADE ALTA" "GAMER" "Foca o processador no seu jogo"
        Draw-Separator
        Draw-Menu-Item "3" "DESATIVAR TELA CHEIA" "GAMER" "Tira o lag do Alt+Tab nos jogos (FSO)"
        Draw-Separator
        Draw-Menu-Item "4" "DESBLOQUEAR NUCLEOS CPU" "GAMER" "Forca 100% do processador no jogo"
        Draw-Separator
        Draw-Menu-Item "5" "MOUSE PRECISAO 1:1" "GAMER" "Remove aceleracao do Windows"
        Draw-Separator
        Draw-Menu-Item "6" "OTIMIZAR TECLADO" "GAMER" "Garante resposta rapida ao segurar teclas"
        Draw-Separator
        Draw-Menu-Item "7" "REDUZIR PACOTES REDE" "GAMER" "Otimiza o registro TCP para jogos online"
        Draw-Separator
        Draw-Menu-Item "8" "SALVAR PROGRESSO (SAVES)" "GAMER" "Faz copia dos seus jogos pro Desktop"
        Draw-Separator
        Draw-Menu-Item "0" "VOLTAR" "---" "Retornar ao Menu Inicial"
        
        Write-Host "`n"; Show-Center "Escolha uma Opcao:" "Cyan"
        $K = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
        switch ($K) {
            '1' { Start-TimerResolution }
            '2' { Show-Center "Nome do jogo (ex: cs2.exe):" "White"; $G = Read-Host; if ($G) { Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$G\PerfOptions" -Name "CpuPriorityClass" -Value 3 -Force; Show-Center "Jogo abrira em Alta Prioridade!" "Green"; Start-Sleep 2 } }
            '3' { Set-ItemProperty "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehaviorMode" -Value 2 -Force -ErrorAction SilentlyContinue; Show-Center "Otimizacoes desativadas. Input Lag reduzido!" "Green"; Start-Sleep 2 }
            '4' { powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100; powercfg -setactive scheme_current; Show-Center "Nucleos desbloqueados! CPU operando livremente." "Green"; Start-Sleep 2 }
            '5' { 
                Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value "0"
                Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value "0"
                Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value "0"
                Show-Center "Aceleracao desativada. Precisao 1:1 aplicada perfeitamente." "Green"; Start-Sleep 2 
            }
            '6' { Start-FilterKeys; Start-Sleep 2 }
            '7' { Start-NetworkPacketReducer; Start-Sleep 2 }
            '8' { 
                $Dest = "$env:USERPROFILE\Desktop\Backup_Saves_$(Get-Date -Format 'dd-MM')"
                New-Item -ItemType Directory -Force -Path $Dest | Out-Null
                $Targets = @("Documents\My Games", "Saved Games", "Documents\Call of Duty", "Documents\Rockstar Games", "Documents\WB Games", "AppData\Local\TslGame")
                foreach ($T in $Targets) {
                    $F = "$env:USERPROFILE\$T".Replace("AppData", "AppData")
                    if (Test-Path $F) { Copy-Item $F -Destination "$Dest\$(Split-Path $F -Leaf)" -Recurse -Force; Show-Center "Copiado: $T" "DarkGray" }
                }
                Show-Center "Saves guardados na Area de Trabalho!" "Green"; Start-Sleep 2
            }
            '0' { return }
        }
    } while ($true)
}

function Modulo-SystemTools {
    do {
        Clear-Host; Draw-Header; Show-Center "=== FERRAMENTAS DO SISTEMA ===" "Yellow"; Write-Host ""
        
        Draw-Menu-Item "1" "WINUTIL (CHRIS TITUS)" "SISTEMA" "Ferramenta Externa Super Completa"
        Draw-Separator
        Draw-Menu-Item "2" "ARRUMAR WINDOWS UPDATE" "SISTEMA" "Destrava atualizacoes presas"
        Draw-Separator
        Draw-Menu-Item "3" "ESCOLHER MELHOR DNS" "SISTEMA" "Muda a rede para a mais rapida"
        Draw-Separator
        Draw-Menu-Item "4" "DESTRAVAR IMPRESSORA" "SISTEMA" "Reseta caso nao queira imprimir"
        Draw-Separator
        Draw-Menu-Item "5" "APAGAR APPS INUTEIS" "SISTEMA" "Remove Cortana, Xbox GameBar, etc"
        Draw-Separator
        Draw-Menu-Item "6" "REPARAR ARQUIVOS WINDOWS" "SISTEMA" "Verifica e corrige tela azul e erros"
        Draw-Separator
        Draw-Menu-Item "7" "DESATIVAR TELEMETRIA" "SISTEMA" "Impede o Windows de te rastrear"
        Draw-Separator
        Draw-Menu-Item "8" "GOD MODE (ATALHO)" "SISTEMA" "Cria icone de Admin na Area de Trabalho"
        Draw-Separator
        Draw-Menu-Item "9" "ATUALIZAR SCRIPT" "SISTEMA" "Baixa a versao mais recente do GitHub"
        Draw-Separator
        Draw-Menu-Item "0" "VOLTAR" "---" "Retornar ao Menu Inicial"
        
        Write-Host "`n"; Show-Center "Escolha uma Opcao:" "Cyan"
        $K = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
        switch ($K) {
            '1' { try { irm "https://christitus.com/win" | iex } catch { Show-Center "Sem internet." "Red"; Start-Sleep 2 } }
            '2' { Stop-Service wuauserv; Stop-Service bits; Remove-Item "$env:windir\SoftwareDistribution" -Recurse -Force -ErrorAction SilentlyContinue; Start-Service wuauserv; Start-Service bits; Show-Center "Update Resetado." "Green"; Start-Sleep 2 }
            '3' {
                Show-Center "Testando Velocidade..." "Cyan"
                $G = (Test-Connection 8.8.8.8 -Count 1).ResponseTime; $C = (Test-Connection 1.1.1.1 -Count 1).ResponseTime
                if ($C -lt $G) { Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -ServerAddresses ("1.1.1.1","1.0.0.1"); Show-Center "Cloudflare Ativado." "Green" }
                else { Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -ServerAddresses ("8.8.8.8","8.8.4.4"); Show-Center "Google Ativado." "Green" }
                Start-Sleep 2
            }
            '4' { Stop-Service Spooler; Start-Service Spooler; Show-Center "Impressora Reiniciada!" "Green"; Start-Sleep 2 }
            '5' { Get-AppxPackage "*Cortana*" | Remove-AppxPackage; Get-AppxPackage "*XboxGamingOverlay*" | Remove-AppxPackage; Show-Center "Apps removidos." "Green"; Start-Sleep 2 }
            '6' { Show-Center "Isso pode demorar. Aguarde..." "Cyan"; sfc /scannow; dism /online /cleanup-image /restorehealth; Wait-User }
            '7' { Stop-Service DiagTrack -ErrorAction SilentlyContinue; Set-Service DiagTrack -StartupType Disabled; Show-Center "Rastreamento Desativado." "Green"; Start-Sleep 2 }
            '8' { New-Item -Path "$env:USERPROFILE\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}" -ItemType Directory -Force | Out-Null; Show-Center "Criado no Desktop." "Green"; Start-Sleep 2 }
            '9' { Start-AutoUpdate }
            '0' { return }
        }
    } while ($true)
}

function Modulo-Mas {
    Clear-Host; Draw-Header; Show-Center "=== ATIVADOR DO WINDOWS E OFFICE ===" "Red"; Write-Host ""
    Show-Center "Como Ativar:" "Yellow"
    Show-Center "1. Uma janela PRETA de comando vai abrir em alguns segundos." "White"
    Show-Center "2. No seu teclado, aperte o numero [1] para ativar seu Windows para sempre." "White"
    Show-Center "3. Ou aperte o numero [2] para ativar seu Pacote Office." "White"
    Write-Host ""; Show-Center "Pressione qualquer tecla para chamar o Ativador..." "Cyan"
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    try { irm https://get.activated.win | iex } catch { Show-Center "Sem conexao com a internet." "Red"; Start-Sleep 2 }
}

# --- MENU PRINCIPAL ---
do {
    Draw-Header
    Draw-Menu-Item "1" "OTIMIZAR AGORA" "LIMPEZA" "Limpar Lixo, Cache e Otimizar PC"
    Draw-Separator
    Draw-Menu-Item "2" "WINDOWS ACTIVATOR" "ATIVADOR" "Ativa o Windows e o pacote Office para sempre"
    Draw-Separator
    Draw-Menu-Item "3" "FERRAMENTAS GAMER" "GAMER" "Aumenta FPS, tira lag do mouse e do sistema"
    Draw-Separator
    Draw-Menu-Item "4" "FERRAMENTAS SISTEMA" "SISTEMA" "Repara erros, arruma internet e apaga inuteis"
    Draw-Separator
    Draw-Menu-Item "5" "DIAGNOSTICO PC" "INFO" "Mostra as pecas, gargalo e saude do sistema"
    Draw-Separator
    Draw-Menu-Item "6" "SAIR" "---" "Fechar e Sair do Otimizador"
    
    Write-Host "`n"; Show-Center "Escolha uma opcao digitando o numero correspondente:" "Cyan"
    $Key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
    switch ($Key) {
        '1' { Modulo-Otimizacao }
        '2' { Modulo-Mas }
        '3' { Modulo-Gamer }
        '4' { Modulo-SystemTools }
        '5' { Modulo-Diagnostico }
        '6' { exit }
    }
} while ($true)