# =================================================================
# SYSTEM OPTIMIZER CORE V55 (TITAN LEGACY - FULL FEATURES)
# =================================================================
$ErrorActionPreference = 'SilentlyContinue'
$FixedW = 100 
$Version = "V55"

# --- FIX DE UPDATE E PATH (Blindagem contra Path Nulo) ---
if ($PSScriptRoot) {
    $ScriptPath = $PSScriptRoot
} else {
    $ScriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
}
# Define o arquivo atual para auto-update funcionar independente do nome
$CurrentFile = $MyInvocation.MyCommand.Definition

# LINK RAW (Certifique-se que o nome no GitHub sera OptimizerCore.ps1)
$UpdateURL = "https://raw.githubusercontent.com/jefheee/System-Optimizer-Tool/main/OptimizerCore.ps1"

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
    elseif ($Action -eq "ADVANCED") { $AColor = "Red" }
    
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

# --- FUNÇÕES NOVAS (V55) ---

function Start-DirectXShaderClear {
    Show-Center "Limpando Cache de Sombras (Shader Cache - AMD/NVIDIA)..." "Cyan"
    $Paths = @("$env:LOCALAPPDATA\AMD\DxCache", "$env:LOCALAPPDATA\NVIDIA\GLCache", "$env:LOCALAPPDATA\D3DSCache")
    foreach ($P in $Paths) { if (Test-Path $P) { Remove-Item "$P\*" -Recurse -Force -ErrorAction SilentlyContinue } }
    Show-Center "Executando limpeza nativa do DirectX..." "Yellow"
    Cleanmgr /sagerun:64 | Out-Null
    Show-Center "Shaders resetados! Isso corrige gagueira (stutter) em jogos." "Green"; Start-Sleep 2
}

function Start-OneDriveRemoval {
    Show-Center "ALERTA: Isso removera o OneDrive COMPLETAMENTE." "Red"
    Show-Center "Pressione ENTER para confirmar ou ESC para cancelar." "White"
    $K = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown"); if ($K.VirtualKeyCode -eq 27) { return }
    taskkill /f /im OneDrive.exe | Out-Null
    if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") { Start-Process "$env:systemroot\System32\OneDriveSetup.exe" -ArgumentList "/uninstall" -Wait }
    if (Test-Path "$env:systemroot\SysWOW64\OneDriveSetup.exe") { Start-Process "$env:systemroot\SysWOW64\OneDriveSetup.exe" -ArgumentList "/uninstall" -Wait }
    Remove-Item "$env:USERPROFILE\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
    Show-Center "OneDrive eliminado do sistema." "Green"; Start-Sleep 3
}

function Start-BluetoothCacheFix {
    Stop-Service bthserv -Force -ErrorAction SilentlyContinue
    Remove-Item "HKLM:\SYSTEM\CurrentControlSet\Services\BTHPORT\Parameters\Keys\*" -Recurse -Force -ErrorAction SilentlyContinue
    Start-Service bthserv -ErrorAction SilentlyContinue
    Show-Center "Cache Bluetooth limpo. Reconecte seus dispositivos." "Green"; Start-Sleep 2
}

function Start-FontCacheReset {
    Stop-Service FontCache -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\*.dat" -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:SystemRoot\ServiceProfiles\LocalService\AppData\Local\FontCache\*" -Recurse -Force -ErrorAction SilentlyContinue
    Start-Service FontCache -ErrorAction SilentlyContinue
    Show-Center "Fontes resetadas! Textos borrados devem sumir." "Green"; Start-Sleep 2
}

# --- FUNÇÕES ANTIGAS (PRESERVADAS DA V54) ---

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
    Show-Center "Configurando seguranca de conexao (TLS 1.2)..." "DarkGray"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Show-Center "Verificando atualizacoes no GitHub..." "Cyan"
    
    try {
        # Usa UseBasicParsing e baixa o arquivo raw
        $NewScript = Invoke-RestMethod -Uri $UpdateURL -UseBasicParsing
        
        # Verifica se o conteúdo baixado parece ser o script correto
        if ($NewScript -match "SYSTEM OPTIMIZER") {
            # ATENCAO: Usa $CurrentFile para atualizar o arquivo que esta rodando agora
            Set-Content -Path $global:CurrentFile -Value $NewScript -Force
            Show-Center "Atualizado com sucesso! Reinicie o script." "Green"
        } else {
            Show-Center "Conteudo invalido. Verifique o link RAW." "Red"
        }
    } catch {
        Show-Center "Erro ao conectar: $($_.Exception.Message)" "Red"
    }
    Wait-User
}

function Start-TakeOwnership {
    Show-Center "Adicionando 'Tomar Posse' ao menu de contexto..." "Cyan"
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
    
    Show-Center "Funcao adicionada! Clique com botao direito em qualquer arquivo." "Green"
    Start-Sleep 3
}

function Start-RAMBackground {
    Show-Center "Iniciando Job de Limpeza de RAM em 2o plano..." "Cyan"
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
            Start-Sleep -Seconds 600 # Roda a cada 10 min
        }
    }
    Start-Job -ScriptBlock $JobCode -Name "RamOptimizer"
    Show-Center "Ativado! Limpeza automatica a cada 10 minutos." "Green"
    Start-Sleep 2
}

function Start-DefenderExclusion {
    Show-Center "Cole o caminho da pasta do jogo (ex: C:\Jogos\CS2):" "White"
    $Path = Read-Host
    if (Test-Path $Path) {
        Add-MpPreference -ExclusionPath $Path
        Show-Center "Pasta adicionada as exclusoes do Defender!" "Green"
    } else {
        Show-Center "Pasta nao encontrada." "Red"
    }
    Start-Sleep 2
}

function Start-BottleneckTest {
    Clear-Host; Show-Center "--- MONITOR DE GARGALO (BOTTLENECK) ---" "Cyan"
    Show-Center "Analisando carga do processador por 10 segundos..." "Gray"; Write-Host ""
    $CpuLoad = 0
    for ($i=1; $i -le 10; $i++) {
        $Val = (Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average
        $CpuLoad += $Val
        Write-Host "`rColetando amostra $i/10: $Val% CPU" -NoNewline -ForegroundColor Green; Start-Sleep 1
    }
    $Avg = [math]::Round($CpuLoad / 10, 1)
    Write-Host "`n"; Show-Center "Uso Medio da CPU: $Avg%" "White"
    if ($Avg -gt 85) { Show-Center "GARGALO DE CPU! Seu processador esta limitando o desempenho." "Red" }
    elseif ($Avg -lt 25) { Show-Center "CPU Folgada! Placa de Video limitando (O Ideal)." "Green" }
    else { Show-Center "Sistema operando com carga equilibrada." "Yellow" }
    Wait-User
}

function Start-JitterTest {
    Clear-Host; Show-Center "--- TESTE DE ESTABILIDADE PING ---" "Cyan"
    Show-Center "Calculando variacao (Jitter) da sua internet..." "Gray"; Write-Host ""
    $Pings = @(); $Total = 0
    for ($i=1; $i -le 10; $i++) {
        $Ms = (Test-Connection 8.8.8.8 -Count 1).ResponseTime
        $Pings += $Ms; $Total += $Ms
        Write-Host "`rDisparo $i/10: ${Ms}ms" -NoNewline -ForegroundColor Green; Start-Sleep -Milliseconds 200
    }
    $Avg = $Total / 10; $JitterSum = 0
    for ($i=0; $i -lt 9; $i++) { $JitterSum += [math]::Abs($Pings[$i] - $Pings[$i+1]) }
    $Jitter = [math]::Round($JitterSum / 9, 2)
    Write-Host "`n"; Show-Center "Ping Medio: $Avg ms  |  Oscilacao (Jitter): $Jitter ms" "White"
    if ($Jitter -lt 5) { Show-Center "Internet PERFEITA para jogos." "Green" }
    elseif ($Jitter -lt 15) { Show-Center "Internet BOA (Pode dar leves engasgos)." "Yellow" }
    else { Show-Center "Internet INSTAVEL (Muitos picos de lag)." "Red" }
    Wait-User
}

function Start-AppxRestore {
    Show-Center "Reinstalando aplicativos nativos do Windows (Pode demorar)..." "Cyan"
    Get-AppxPackage -AllUsers | ForEach-Object {
        Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" -ErrorAction SilentlyContinue
    }
    Show-Center "Aplicativos padrao restaurados com sucesso!" "Green"
}

function Start-NetAdapterReset {
    Show-Center "Reiniciando adaptadores fisicos de rede..." "Cyan"
    $Adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
    foreach ($A in $Adapters) {
        Disable-NetAdapter -Name $A.Name -Confirm:$false -ErrorAction SilentlyContinue
        Start-Sleep 2
        Enable-NetAdapter -Name $A.Name -Confirm:$false -ErrorAction SilentlyContinue
    }
    Show-Center "Adaptadores reiniciados e IPs renovados!" "Green"
}

function Start-CopilotToggle {
    Show-Center "Desativando Copilot e funcoes de IA..." "Cyan"
    $RegPath = "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot"
    if (-not (Test-Path $RegPath)) { New-Item -Path $RegPath -Force | Out-Null }
    Set-ItemProperty -Path $RegPath -Name "TurnOffWindowsCopilot" -Value 1 -Force
    $RegExplorer = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    Set-ItemProperty -Path $RegExplorer -Name "ShowCopilotButton" -Value 0 -Force
    Show-Center "Copilot desativado. Reinicie o PC para aplicar." "Green"
}

# --- MÓDULOS PRINCIPAIS ---

function Modulo-Diagnostico {
    Show-Center "=== DIAGNOSTICO DO PC ===" "White"; Write-Host ""
    
    try {
        $OS = Get-CimInstance Win32_OperatingSystem
        $Boot = $OS.LastBootUpTime; $Up = (Get-Date) - $Boot
        Show-Center "SISTEMA OPERACIONAL" "Cyan"
        Show-Center "Windows: $($OS.Caption) (Build $($OS.BuildNumber))" "White"
        Show-Center "Ligado ha: $($Up.Days)d $($Up.Hours)h $($Up.Minutes)m" "White"
    } catch {}
    
    Write-Host ""
    
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
        $HwItems = @(
            "[GPU] $GPU",
            "[RAM] $RamSummary",
            "[CPU] $CPU",
            "[MOBO] $($Board.Manufacturer) $($Board.Product)"
        )
        Show-Pyramid $HwItems "White"
        
        if ($LowSpeedWarning) {
            Write-Host ""
            Show-Center "[ALERTA] RAM com velocidade baixa. Ative o XMP na BIOS." "Red"
        }
    } catch {}

    Write-Host "`n"; Show-Center "ARMAZENAMENTO" "Cyan"; Write-Host ""
    $Disks = Get-PhysicalDisk | Sort-Object MediaType, Size -Descending
    foreach ($D in $Disks) {
        $Size = [Math]::Round($D.Size / 1GB, 0)
        $Type = if ($D.MediaType -eq "Unspecified") { "SSD" } else { $D.MediaType }
        $Color = if ($D.HealthStatus -eq "Healthy") { "Green" } else { "Red" }
        # Textos puramente brancos, apenas Status colorido
        Show-Dual-Center "$Type - $Size GB - ($($D.Model))" "[$($D.HealthStatus)]" "White" $Color
    }
    
    Write-Host "`n"; Show-Center "CONEXAO" "Cyan"; Write-Host ""
    try {
        $P1 = (Test-Connection 8.8.8.8 -Count 1).ResponseTime
        $P2 = (Test-Connection 1.1.1.1 -Count 1).ResponseTime
        Show-Dual-Center "Google: ${P1}ms" "Cloudflare: ${P2}ms" "White" "White"
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
    try { Clear-RecycleBin -Force -ErrorAction SilentlyContinue | Out-Null } catch {}

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
        Draw-Menu-Item "8" "RAM AUTO-CLEAN (JOB)" "GAMER" "Limpa a RAM sozinho a cada 10 min"
        Draw-Separator
        Draw-Menu-Item "9" "DEFENDER EXCLUSION" "GAMER" "Impede o antivirus de travar seu jogo"
        Draw-Separator
        Draw-Menu-Item "10" "DIRECTX SHADER RESET" "GAMER" "Limpa cache da GPU (Fix Stuttering)"
        Draw-Separator
        Draw-Menu-Item "0" "VOLTAR" "---" "Retornar ao Menu Inicial"
        
        Write-Host "`n"; Show-Center "Escolha uma Opcao:" "Cyan"
        $K = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
        if ($K -eq '1' -and $Host.UI.RawUI.KeyAvailable) { $K += $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character } # Captura o 10
        
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
            '8' { Start-RAMBackground }
            '9' { Start-DefenderExclusion }
            '10' { Start-DirectXShaderClear }
            '0' { return }
        }
    } while ($true)
}

function Modulo-SystemTools {
    do {
        Clear-Host; Draw-Header; Show-Center "=== FERRAMENTAS DO SISTEMA (PAGINA 1) ===" "Yellow"; Write-Host ""
        
        Draw-Menu-Item "1" "WINUTIL (CHRIS TITUS)" "SISTEMA" "Ferramenta Externa Super Completa"
        Draw-Separator
        Draw-Menu-Item "2" "ARRUMAR WINDOWS UPDATE" "SISTEMA" "Destrava atualizacoes presas"
        Draw-Separator
        Draw-Menu-Item "3" "ESCOLHER MELHOR DNS" "SISTEMA" "Muda a rede para a mais rapida"
        Draw-Separator
        Draw-Menu-Item "4" "REPARAR ARQUIVOS WINDOWS" "SISTEMA" "Verifica e corrige tela azul e erros"
        Draw-Separator
        Draw-Menu-Item "5" "LIMPAR TAREFAS ORFAS" "SISTEMA" "Apaga gatilhos de apps excluidos"
        Draw-Separator
        Draw-Menu-Item "6" "APAGAR APPS INUTEIS" "SISTEMA" "Remove Cortana, Xbox GameBar, etc"
        Draw-Separator
        Draw-Menu-Item "7" "DESATIVAR TELEMETRIA" "SISTEMA" "Impede o Windows de te rastrear"
        Draw-Separator
        Draw-Menu-Item "9" "FERRAMENTAS AVANCADAS" "SISTEMA" "Ir para Pagina 2 (OneDrive, Fonts...)"
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
            '4' { Show-Center "Isso pode demorar. Aguarde..." "Cyan"; sfc /scannow; dism /online /cleanup-image /restorehealth; Wait-User }
            '5' { 
                $Tasks = Get-ScheduledTask | Where-Object { $_.Actions.Execute -ne $null }
                foreach ($T in $Tasks) {
                    $P = $T.Actions.Execute.Replace('"', ''); if ($P -match "^[a-zA-Z]:\\") { if (-not (Test-Path $P)) { Unregister-ScheduledTask -TaskName $T.TaskName -Confirm:$false -ErrorAction SilentlyContinue | Out-Null } }
                }
                Show-Center "Tarefas Orfas Limpas." "Green"; Start-Sleep 2
            }
            '6' { Get-AppxPackage "*Cortana*" | Remove-AppxPackage; Get-AppxPackage "*XboxGamingOverlay*" | Remove-AppxPackage; Show-Center "Apps removidos." "Green"; Start-Sleep 2 }
            '7' { Stop-Service DiagTrack -ErrorAction SilentlyContinue; Set-Service DiagTrack -StartupType Disabled; Show-Center "Rastreamento Desativado." "Green"; Start-Sleep 2 }
            '9' { Modulo-SystemTools-Pag2 }
            '0' { return }
        }
    } while ($true)
}

function Modulo-SystemTools-Pag2 {
    do {
        Clear-Host; Draw-Header; Show-Center "=== FERRAMENTAS AVANCADAS (PAGINA 2) ===" "Red"; Write-Host ""
        
        Draw-Menu-Item "1" "RESTAURAR APPS PADRAO" "SISTEMA" "Reinstala Calculadora, Loja e Nativos"
        Draw-Separator
        Draw-Menu-Item "2" "REINICIAR ADAPTADOR REDE" "SISTEMA" "Desliga e liga a internet fisicamente"
        Draw-Separator
        Draw-Menu-Item "3" "DESATIVAR IA E COPILOT" "SISTEMA" "Remove recursos de IA do Windows"
        Draw-Separator
        Draw-Menu-Item "4" "ADD TOMAR POSSE (MENU)" "SISTEMA" "Adiciona opcao de dono no botao direito"
        Draw-Separator
        Draw-Menu-Item "5" "REMOVER ONEDRIVE (FULL)" "ADVANCED" "Apaga app e residuos (Novo V55)"
        Draw-Separator
        Draw-Menu-Item "6" "RESETAR FONTE CACHE" "ADVANCED" "Corrige letras borradas (Novo V55)"
        Draw-Separator
        Draw-Menu-Item "7" "FIX BLUETOOTH CACHE" "ADVANCED" "Resolve falha de pareamento (Novo V55)"
        Draw-Separator
        Draw-Menu-Item "8" "ATUALIZAR SCRIPT" "SISTEMA" "Baixa a versao mais recente do GitHub"
        Draw-Separator
        Draw-Menu-Item "9" "TESTES GARGALO E JITTER" "ADVANCED" "Testar CPU e Internet"
        Draw-Separator
        Draw-Menu-Item "0" "VOLTAR" "---" "Retornar a Pagina 1"
        
        Write-Host "`n"; Show-Center "Escolha uma Opcao:" "Cyan"
        $K = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
        switch ($K) {
            '1' { Start-AppxRestore; Start-Sleep 2 }
            '2' { Start-NetAdapterReset }
            '3' { Start-CopilotToggle; Start-Sleep 2 }
            '4' { Start-TakeOwnership }
            '5' { Start-OneDriveRemoval }
            '6' { Start-FontCacheReset }
            '7' { Start-BluetoothCacheFix }
            '8' { Start-AutoUpdate }
            '9' { Start-BottleneckTest; Start-JitterTest }
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
    Draw-Menu-Item "1" "OTIMIZAR AGORA" "LIMPEZA" "Esvazia lixeira, limpa sistema e melhora RAM"
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

