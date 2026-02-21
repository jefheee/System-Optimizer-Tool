# =================================================================
# SYSTEM OPTIMIZER CORE V58 (EXTERNAL JSON & CUSTOMIZATION)
# =================================================================
$ErrorActionPreference = 'SilentlyContinue'
$FixedW = 100 
$Version = "V58"

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
if ($PSScriptRoot) { $ScriptPath = $PSScriptRoot } else { $ScriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition }
$CurrentFile = $MyInvocation.MyCommand.Definition

# URLs GITHUB (Com o novo lang.json)
$RepoRaw = "https://raw.githubusercontent.com/jefheee/System-Optimizer-Tool/main"
$UpdateURL = "$RepoRaw/OptimizerCore.ps1"
$BatURL = "$RepoRaw/SystemOptimizer.bat"
$ChangelogURL = "$RepoRaw/CHANGELOG.md"
$ReadmeURL = "$RepoRaw/README.md"
$LangJSONURL = "$RepoRaw/lang.json"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- FIX TELA PRETA: CONFIGURA O CONSOLE ANTES DE TUDO ---
try {
    $RawUI = $Host.UI.RawUI
    $Buf = $RawUI.BufferSize
    $Buf.Width = 120; $Buf.Height = 3000
    $RawUI.BufferSize = $Buf
} catch {}

# ================= ARQUIVOS DE CONFIGURACAO E JSON =================
$PrefFile = "$ScriptPath\lang.ini"
$ThemeFile = "$ScriptPath\theme.ini"
$LangJsonPath = "$ScriptPath\lang.json"

$global:AppTheme = if (Test-Path $ThemeFile) { Get-Content $ThemeFile } else { "Cyan" }

# Le o Dicionario JSON
if (Test-Path $LangJsonPath) {
    try {
        $global:Dict = Get-Content $LangJsonPath -Raw | ConvertFrom-Json
    } catch {
        Write-Host "ERRO: O arquivo lang.json esta corrompido ou mal formatado." -ForegroundColor Red; Start-Sleep 3; exit
    }
} else {
    Write-Host "ERRO CRITICO: O arquivo 'lang.json' nao foi encontrado na pasta do programa!" -ForegroundColor Red
    Write-Host "Baixe-o no GitHub ou certifique-se de que ele esta junto do .ps1" -ForegroundColor Yellow
    Start-Sleep 5; exit
}

# ================= FUNCOES DE SUPORTE (TEXTO E VISUAL) =================

function Show-Center {
    param([string]$Text, [string]$Color = "White")
    $Trimmed = $Text.Trim()
    $PadLeft = [math]::Floor(($FixedW - $Trimmed.Length) / 2)
    if ($PadLeft -lt 0) { $PadLeft = 0 }
    Write-Host (" " * $PadLeft) -NoNewline
    Write-Host "$Trimmed" -ForegroundColor $Color
}

function Show-Pyramid {
    param([array]$List, [string]$Color = "White")
    $Sorted = $List | Sort-Object Length -Descending
    foreach ($Item in $Sorted) { Show-Center $Item $Color }
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

function Draw-Separator { Show-Center "--------------------------------------------------------------------------------" "DarkGray" }

function Draw-Header {
    Clear-Host; Write-Host "`n"
    Show-Center "  _______  __   __  _______  _______  _______  __   __  " $global:AppTheme
    Show-Center " |       ||  | |  ||       ||       ||       ||  |_|  | " $global:AppTheme
    Show-Center " |  _____||  |_|  ||  _____||_     _||    ___||       | " $global:AppTheme
    Show-Center " | |_____ |       || |_____   |   |  |   |___ |       | " $global:AppTheme
    Show-Center " |_____  ||_     _||_____  |  |   |  |    ___||       | " $global:AppTheme
    Show-Center "  _____| |  |   |   _____| |  |   |  |   |___ | ||_|| | " $global:AppTheme
    Show-Center " |_______|  |___|  |_______|  |___|  |_______||_|   |_| " $global:AppTheme
    Show-Center "  _______  _______  _______  ___  __   __  ___  _______  _______  ______   " $global:AppTheme
    Show-Center " |       ||       ||       ||   ||  |_|  ||   ||       ||       ||    _ |  " $global:AppTheme
    Show-Center " |   _   ||    _  ||_     _||   ||       ||   ||____   ||    ___||   | ||  " $global:AppTheme
    Show-Center " |  | |  ||   |_| |  |   |  |   ||       ||   ||____|  ||   |___ |   |_||_ " $global:AppTheme
    Show-Center " |  |_|  ||    ___|  |   |  |   ||       ||   || ______||    ___||    __  |" $global:AppTheme
    Show-Center " |       ||   |      |   |  |   || ||_|| ||   || |_____ |   |___ |   |  | |" $global:AppTheme
    Show-Center " |_______||___|      |___|  |___||_|   |_||___||_______||_______||___|  |_|" $global:AppTheme
    Write-Host ""
}

function Select-Language-GUI {
    Draw-Header
    Show-Center " GLOBAL LANGUAGE SELECTOR " "DarkGray"; Write-Host "`n"
    
    # EFEITO PIRAMIDE NAS LINGUAGENS (Do maior para o menor em caracteres)
    $LangList = @(
        "[1] Portugues (PT-BR)",
        "[7] Chinese (Pinyin)",
        "[2] English (Global)",
        "[4] Francais (FR)",
        "[6] Russian (RU)",
        "[5] Deutsch (DE)",
        "[3] Espanol (ES)"
    )
    Show-Pyramid $LangList "White"
    
    Write-Host "`n"; Show-Center "Input Number:" $global:AppTheme
    $choice = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
    switch ($choice) {
        '2' { $global:UserLang = "EN"; Set-Content $PrefFile "EN" }
        '3' { $global:UserLang = "ES"; Set-Content $PrefFile "ES" }
        '4' { $global:UserLang = "FR"; Set-Content $PrefFile "FR" }
        '5' { $global:UserLang = "DE"; Set-Content $PrefFile "DE" }
        '6' { $global:UserLang = "RU"; Set-Content $PrefFile "RU" }
        '7' { $global:UserLang = "CN"; Set-Content $PrefFile "CN" }
        Default { $global:UserLang = "PT"; Set-Content $PrefFile "PT" }
    }
}

if (-not (Test-Path $PrefFile)) { Select-Language-GUI } else { $global:UserLang = Get-Content $PrefFile }
# Fallback caso o JSON não tenha o idioma mapeado ainda
try { $test = $global:Dict.($global:UserLang) } catch { $global:UserLang = "EN" }

function Get-Text($key) { 
    try {
        $val = $global:Dict.($global:UserLang).$key
        if ($val) { return $val } else { return "[$key]" }
    } catch { return "[$key]" }
}

function Draw-Menu-Item {
    param($Num, $Title, $CategoryText, $ColorHex, $Desc)
    $PadStart = " " * 8
    Write-Host "$PadStart" -NoNewline
    Write-Host "[$Num] " -NoNewline -ForegroundColor $global:AppTheme
    $T = "$Title".PadRight(28)
    Write-Host "$T" -NoNewline -ForegroundColor White
    $A = "[$CategoryText]".PadRight(12)
    Write-Host "$A " -NoNewline -ForegroundColor $ColorHex
    Write-Host "- $Desc" -ForegroundColor Gray
}

function Wait-User { Write-Host "`n"; Show-Center (Get-Text "Wait") "DarkGray"; $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") }

function Get-SizeMB ($Path) {
    $Items = Get-ChildItem $Path -Recurse -File -ErrorAction SilentlyContinue
    if ($Items) {
        $Sum = ($Items | Measure-Object -Property Length -Sum).Sum
        if ($Sum) { return [math]::Round($Sum / 1MB, 2) }
    }
    return 0
}

# --- CÓDIGO C# ---
$Kernel32 = @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("ntdll.dll")] public static extern int NtSetTimerResolution(uint DesiredResolution, bool SetResolution, ref uint CurrentResolution);
    [DllImport("psapi.dll")] public static extern int EmptyWorkingSet(IntPtr hwProc);
}
"@
try { Add-Type -TypeDefinition $Kernel32 -PassThru | Out-Null } catch {}

# ================= SISTEMA DE UPDATE APRIMORADO =================

function Start-AutoUpdate {
    Show-Center (Get-Text "Msg_Wait") "DarkGray"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $BaseDir = $ScriptPath
    
    try {
        Show-Center "Core (.ps1)..." "Cyan"
        $NewScript = Invoke-RestMethod -Uri $UpdateURL -UseBasicParsing
        if ($NewScript -match "SYSTEM OPTIMIZER") { Set-Content -Path $global:CurrentFile -Value $NewScript -Force }
        
        Show-Center "Launcher (.bat)..." "Cyan"
        $NewBat = Invoke-RestMethod -Uri $BatURL -UseBasicParsing
        if ($NewBat -match "SYSTEM OPTIMIZER") { Set-Content -Path "$BaseDir\SystemOptimizer.bat" -Value $NewBat -Force }

        Show-Center "Language Base (lang.json)..." "Cyan"
        $NewLang = Invoke-RestMethod -Uri $LangJSONURL -UseBasicParsing
        if ($NewLang -match "LangName") { Set-Content -Path "$BaseDir\lang.json" -Value $NewLang -Force }

        Show-Center "Changelog..." "Cyan"
        $NewChangelog = Invoke-RestMethod -Uri $ChangelogURL -UseBasicParsing
        if ($NewChangelog -match "Changelog") { Set-Content -Path "$BaseDir\CHANGELOG.md" -Value $NewChangelog -Force }

        Show-Center "README..." "Cyan"
        $NewReadme = Invoke-RestMethod -Uri $ReadmeURL -UseBasicParsing
        if ($NewReadme -match "System Optimizer") { Set-Content -Path "$BaseDir\README.md" -Value $NewReadme -Force }

        Show-Center (Get-Text "Msg_UpdateOK") "Green"
    } catch {
        Show-Center "$(Get-Text 'Msg_UpdateFail') $($_.Exception.Message)" "Red"
    }
    Wait-User
}

# ================= MODULOS PRINCIPAIS =================

function Modulo-Settings {
    do {
        Draw-Header; Show-Center " COMMAND CENTER $Version | LANG: $($global:UserLang) " "DarkGray"; Write-Host ""
        Show-Center "=== $(Get-Text 'M_Set') ===" "Blue"; Write-Host ""
        
        Draw-Menu-Item "1" (Get-Text "S_Lang") (Get-Text "Cat_Set") "Blue" (Get-Text "DS_Lang")
        Draw-Separator
        Draw-Menu-Item "2" (Get-Text "S_Theme") (Get-Text "Cat_Set") "Magenta" (Get-Text "DS_Theme")
        Draw-Separator
        Draw-Menu-Item "3" (Get-Text "S_Short") (Get-Text "Cat_Set") "Cyan" (Get-Text "DS_Short")
        Draw-Separator
        Draw-Menu-Item "4" (Get-Text "S_Upd") (Get-Text "Cat_Set") "Blue" (Get-Text "DS_Upd")
        Draw-Separator
        Draw-Menu-Item "5" (Get-Text "S_Rst") (Get-Text "Cat_Set") "Red" (Get-Text "DS_Rst")
        Draw-Separator
        Draw-Menu-Item "0" (Get-Text "Back") "---" "DarkGray" (Get-Text "D_Back")
        
        Write-Host "`n"; Show-Center (Get-Text "Choose") $global:AppTheme
        $K = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
        switch ($K) {
            '1' { 
                # Atualizacao Instantanea de Idioma
                Remove-Item $PrefFile -Force -ErrorAction SilentlyContinue
                Select-Language-GUI
                # Ao dar break no switch e continuar o do-while, o menu recarrega na hora!
            }
            '2' { 
                if ($global:AppTheme -eq "Cyan") { $global:AppTheme = "Green"; Set-Content $ThemeFile "Green" }
                elseif ($global:AppTheme -eq "Green") { $global:AppTheme = "Magenta"; Set-Content $ThemeFile "Magenta" }
                else { $global:AppTheme = "Cyan"; Set-Content $ThemeFile "Cyan" }
                Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 1 
            }
            '3' {
                $WshShell = New-Object -comObject WScript.Shell
                $Shortcut = $WshShell.CreateShortcut("$HOME\Desktop\System Optimizer.lnk")
                $Shortcut.TargetPath = "$ScriptPath\SystemOptimizer.bat"
                $Shortcut.IconLocation = "shell32.dll, 24" 
                $Shortcut.Save()
                Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2
            }
            '4' { Start-AutoUpdate }
            '5' { Remove-Item $PrefFile -Force; Remove-Item $ThemeFile -Force; Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 1; exit }
            '0' { return }
        }
    } while ($true)
}

function Modulo-Otimizacao {
    Show-Center "=== $(Get-Text 'M_Opt') ===" "White"; Write-Host ""
    $TotalFreedMB = 0; Show-Center (Get-Text "Msg_Wait") "Yellow"
    Stop-Service wuauserv -Force -ErrorAction SilentlyContinue; Stop-Service bits -Force -ErrorAction SilentlyContinue

    $Steps = @(@{N="Temp User"; P="$env:TEMP\*"}, @{N="Temp Win"; P="$env:WINDIR\Temp\*"}, @{N="Prefetch"; P="$env:WINDIR\Prefetch\*"}, @{N="Update Cache"; P="$env:WINDIR\SoftwareDistribution\Download\*"}, @{N="Logs"; P="$env:WINDIR\Logs\*"})
    foreach ($Step in $Steps) {
        $Size = Get-SizeMB $Step.P; $TotalFreedMB += $Size
        Show-Center "$(Get-Text 'Msg_Clean') $($Step.N) ($Size MB)..." "Cyan"
        try { Get-ChildItem $Step.P -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue } catch {}
    }
    try { Clear-RecycleBin -Force -ErrorAction SilentlyContinue | Out-Null } catch {}
    
    $BrowserSize = 0; $Browsers = @("$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache", "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache")
    foreach ($P in $Browsers) { if (Test-Path $P) { $BrowserSize += Get-SizeMB "$P\*"; Remove-Item "$P\*" -Recurse -Force -ErrorAction SilentlyContinue } }
    $TotalFreedMB += $BrowserSize; Show-Center "$(Get-Text 'Msg_Clean') Browsers ($BrowserSize MB)..." "Cyan"
    
    wevtutil el | ForEach-Object { [void](wevtutil cl "$_" 2>$null) }
    netsh int tcp set global rss=enabled | Out-Null; fsutil behavior set memoryusage 2 | Out-Null
    foreach ($P in Get-Process) { try { [void][Win32]::EmptyWorkingSet($P.Handle) } catch {} }
    ipconfig /flushdns | Out-Null
    Start-Service wuauserv -ErrorAction SilentlyContinue; Start-Service bits -ErrorAction SilentlyContinue
    try { Optimize-Volume -DriveLetter C -ReTrim -ErrorAction SilentlyContinue | Out-Null } catch {}

    Write-Host "`n"; Show-Center "TOTAL: $TotalFreedMB MB" "Green"; Show-Center (Get-Text "Msg_Done") "Green"; Wait-User
}

function Modulo-Lite {
    Show-Center "=== $(Get-Text 'M_Lite') ===" "White"; Write-Host ""
    $TotalFreedMB = 0
    $Steps = @(@{N="Temp User"; P="$env:TEMP\*"}, @{N="Temp Win"; P="$env:WINDIR\Temp\*"}, @{N="Logs"; P="$env:WINDIR\Logs\*"})
    foreach ($Step in $Steps) { 
        $Size = Get-SizeMB $Step.P; $TotalFreedMB += $Size
        Show-Center "$(Get-Text 'Msg_Clean') $($Step.N)..." "Cyan"
        try { Get-ChildItem $Step.P -Recurse -Force | Remove-Item -Force -Recurse } catch {} 
    }
    try { Clear-RecycleBin -Force -ErrorAction SilentlyContinue | Out-Null } catch {}
    Write-Host "`n"; Show-Center "TOTAL: $TotalFreedMB MB" "Green"; Show-Center (Get-Text "Msg_Done") "Green"; Wait-User
}

function Modulo-Diagnostico {
    Show-Center "=== $(Get-Text 'M_Diag') ===" "White"; Write-Host ""
    try {
        $OS = Get-CimInstance Win32_OperatingSystem; $Boot = $OS.LastBootUpTime; $Up = (Get-Date) - $Boot
        Show-Center "$(Get-Text 'Diag_OS'): $($OS.Caption) (Build $($OS.BuildNumber))" "White"
        Show-Center "$(Get-Text 'Diag_Up'): $($Up.Days)d $($Up.Hours)h $($Up.Minutes)m" "White"
    } catch {}
    Write-Host "`n"; Show-Center (Get-Text 'Diag_HW') "Cyan"
    try {
        $CPU = (Get-CimInstance Win32_Processor).Name; $GPU = (Get-CimInstance Win32_VideoController | Select-Object -First 1).Name
        $MemInfos = Get-CimInstance Win32_PhysicalMemory; $RamTotalGB = 0; $RamDetails = @()
        foreach ($M in $MemInfos) { $SizeGB = [math]::Round($M.Capacity / 1GB, 0); $RamTotalGB += $SizeGB; $RamDetails += "${SizeGB}GB $($M.Speed)MHz" }
        $RamSummary = "$RamTotalGB GB ($($RamDetails -join ' + '))"
        Show-Pyramid @("[GPU] $GPU", "[RAM] $RamSummary", "[CPU] $CPU") "White"
    } catch {}
    Write-Host "`n"; Show-Center (Get-Text 'Diag_Store') "Cyan"; Write-Host ""
    $Disks = Get-PhysicalDisk | Sort-Object MediaType, Size -Descending
    foreach ($D in $Disks) {
        $Size = [Math]::Round($D.Size / 1GB, 0); $Type = if ($D.MediaType -eq "Unspecified") { "SSD" } else { $D.MediaType }
        $Color = if ($D.HealthStatus -eq "Healthy") { "Green" } else { "Red" }
        Show-Dual-Center "$Type - $Size GB - ($($D.Model))" "[$($D.HealthStatus)]" "White" $Color
    }
    Wait-User
}

function Modulo-Gamer {
    do {
        Draw-Header; Show-Center " COMMAND CENTER $Version | LANG: $($global:UserLang) " "DarkGray"; Write-Host ""
        Show-Center "=== $(Get-Text 'M_Gamer') ===" "Magenta"; Write-Host ""
        Draw-Menu-Item "1" (Get-Text "G_Timer") (Get-Text "Cat_Gamer") "Magenta" (Get-Text "DG_Timer")
        Draw-Separator
        Draw-Menu-Item "2" (Get-Text "G_Prio") (Get-Text "Cat_Gamer") "Magenta" (Get-Text "DG_Prio")
        Draw-Separator
        Draw-Menu-Item "3" (Get-Text "G_FSO") (Get-Text "Cat_Gamer") "Magenta" (Get-Text "DG_FSO")
        Draw-Separator
        Draw-Menu-Item "4" (Get-Text "G_Mouse") (Get-Text "Cat_Gamer") "Magenta" (Get-Text "DG_Mouse")
        Draw-Separator
        Draw-Menu-Item "5" (Get-Text "G_Keys") (Get-Text "Cat_Gamer") "Magenta" (Get-Text "DG_Keys")
        Draw-Separator
        Draw-Menu-Item "6" (Get-Text "G_Net") (Get-Text "Cat_Gamer") "Magenta" (Get-Text "DG_Net")
        Draw-Separator
        Draw-Menu-Item "7" (Get-Text "G_Ram") (Get-Text "Cat_Gamer") "Magenta" (Get-Text "DG_Ram")
        Draw-Separator
        Draw-Menu-Item "8" (Get-Text "G_Def") (Get-Text "Cat_Gamer") "Magenta" (Get-Text "DG_Def")
        Draw-Separator
        Draw-Menu-Item "9" (Get-Text "G_Dx") (Get-Text "Cat_Gamer") "Magenta" (Get-Text "DG_Dx")
        Draw-Separator
        Draw-Menu-Item "0" (Get-Text "Back") "---" "DarkGray" (Get-Text "D_Back")
        
        Write-Host "`n"; Show-Center (Get-Text "Choose") $global:AppTheme
        $K = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
        switch ($K) {
            '1' { Clear-Host; Show-Center "0.5ms"; $C=0; [Win32]::NtSetTimerResolution(5000, $true, [ref]$C); $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown"); [Win32]::NtSetTimerResolution(156000, $true, [ref]$C) }
            '2' { Show-Center (Get-Text "Msg_Input") "White"; $G = Read-Host; if ($G) { Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$G\PerfOptions" -Name "CpuPriorityClass" -Value 3 -Force; Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2 } }
            '3' { Set-ItemProperty "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehaviorMode" -Value 2 -Force; Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2 }
            '4' { Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value "0"; Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2 }
            '5' { Set-ItemProperty "HKCU:\Control Panel\Accessibility\Keyboard Response" -Name "AutoRepeatDelay" -Value "150" -Force; Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 1 }
            '6' { 
                $Interfaces = Get-Item "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\*"; foreach ($Interface in $Interfaces) { New-ItemProperty -Path $Interface.PSPath -Name "TcpAckFrequency" -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null }
                Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 1 
            }
            '7' { Start-Job -ScriptBlock { Add-Type -TypeDefinition @"
                using System; using System.Runtime.InteropServices; public class Win32 { [DllImport("psapi.dll")] public static extern int EmptyWorkingSet(IntPtr hwProc); }
"@; while($true) { foreach ($P in Get-Process) { try { [void][Win32]::EmptyWorkingSet($P.Handle) } catch {} }; Start-Sleep -Seconds 600 } } -Name "RamOpt"; Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2 }
            '8' { Show-Center (Get-Text "Msg_Input") "White"; $Path = Read-Host; if (Test-Path $Path) { Add-MpPreference -ExclusionPath $Path; Show-Center (Get-Text "Msg_Done") "Green" }; Start-Sleep 2 }
            '9' { Cleanmgr /sagerun:64 | Out-Null; Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2 }
            '0' { return }
        }
    } while ($true)
}

function Modulo-SystemTools {
    do {
        Draw-Header; Show-Center " COMMAND CENTER $Version | LANG: $($global:UserLang) " "DarkGray"; Write-Host ""
        Show-Center "=== $(Get-Text 'M_Sys') ===" "Yellow"; Write-Host ""
        Draw-Menu-Item "1" (Get-Text "Y_WinUtil") (Get-Text "Cat_Sys") "Yellow" (Get-Text "DY_WinUtil")
        Draw-Separator
        Draw-Menu-Item "2" (Get-Text "Y_Upd") (Get-Text "Cat_Sys") "Yellow" (Get-Text "DY_Upd")
        Draw-Separator
        Draw-Menu-Item "3" (Get-Text "Y_Dns") (Get-Text "Cat_Sys") "Yellow" (Get-Text "DY_Dns")
        Draw-Separator
        Draw-Menu-Item "4" (Get-Text "Y_Rep") (Get-Text "Cat_Sys") "Yellow" (Get-Text "DY_Rep")
        Draw-Separator
        Draw-Menu-Item "5" (Get-Text "Y_Orphan") (Get-Text "Cat_Sys") "Yellow" (Get-Text "DY_Orphan")
        Draw-Separator
        Draw-Menu-Item "6" (Get-Text "Y_Apps") (Get-Text "Cat_Sys") "Yellow" (Get-Text "DY_Apps")
        Draw-Separator
        Draw-Menu-Item "7" (Get-Text "Y_Tel") (Get-Text "Cat_Sys") "Yellow" (Get-Text "DY_Tel")
        Draw-Separator
        Draw-Menu-Item "9" (Get-Text "Y_Adv") (Get-Text "Cat_Sys") "Yellow" (Get-Text "DY_Adv")
        Draw-Separator
        Draw-Menu-Item "0" (Get-Text "Back") "---" "DarkGray" (Get-Text "D_Back")
        
        Write-Host "`n"; Show-Center (Get-Text "Choose") $global:AppTheme
        $K = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
        switch ($K) {
            '1' { try { irm "https://christitus.com/win" | iex } catch { Show-Center "Erro" "Red"; Start-Sleep 2 } }
            '2' { Stop-Service wuauserv; Stop-Service bits; Remove-Item "$env:windir\SoftwareDistribution" -Recurse -Force; Start-Service wuauserv; Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2 }
            '3' { Show-Center (Get-Text "Msg_Wait") "Cyan"; $G = (Test-Connection 8.8.8.8 -Count 1).ResponseTime; $C = (Test-Connection 1.1.1.1 -Count 1).ResponseTime; if ($C -lt $G) { Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -ServerAddresses ("1.1.1.1","1.0.0.1") } else { Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -ServerAddresses ("8.8.8.8","8.8.4.4") }; Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2 }
            '4' { Show-Center (Get-Text "Msg_Wait") "Cyan"; sfc /scannow; Wait-User }
            '5' { $Tasks = Get-ScheduledTask | Where-Object { $_.Actions.Execute -ne $null }; foreach ($T in $Tasks) { $P = $T.Actions.Execute.Replace('"', ''); if ($P -match "^[a-zA-Z]:\\") { if (-not (Test-Path $P)) { Unregister-ScheduledTask -TaskName $T.TaskName -Confirm:$false } } }; Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2 }
            '6' { Get-AppxPackage "*Cortana*" | Remove-AppxPackage; Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2 }
            '7' { Stop-Service DiagTrack; Set-Service DiagTrack -StartupType Disabled; Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2 }
            '9' { Modulo-SystemTools-Pag2 }
            '0' { return }
        }
    } while ($true)
}

function Modulo-SystemTools-Pag2 {
    do {
        Draw-Header; Show-Center " COMMAND CENTER $Version | LANG: $($global:UserLang) " "DarkGray"; Write-Host ""
        Show-Center "=== $(Get-Text 'M_Sys') 2 ===" "Red"; Write-Host ""
        Draw-Menu-Item "1" (Get-Text "A_Store") (Get-Text "Cat_Sys") "Yellow" (Get-Text "DA_Store")
        Draw-Separator
        Draw-Menu-Item "2" (Get-Text "A_One") (Get-Text "Cat_Adv") "Red" (Get-Text "DA_One")
        Draw-Separator
        Draw-Menu-Item "3" (Get-Text "A_Font") (Get-Text "Cat_Adv") "Red" (Get-Text "DA_Font")
        Draw-Separator
        Draw-Menu-Item "4" (Get-Text "A_Blue") (Get-Text "Cat_Adv") "Red" (Get-Text "DA_Blue")
        Draw-Separator
        Draw-Menu-Item "5" (Get-Text "A_Own") (Get-Text "Cat_Sys") "Yellow" (Get-Text "DA_Own")
        Draw-Separator
        Draw-Menu-Item "6" (Get-Text "A_Drv") (Get-Text "Cat_Adv") "Red" (Get-Text "DA_Drv")
        Draw-Separator
        Draw-Menu-Item "0" (Get-Text "Back") "---" "DarkGray" (Get-Text "D_Back")
        
        Write-Host "`n"; Show-Center (Get-Text "Choose") $global:AppTheme
        $K = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
        switch ($K) {
            '1' { Show-Center (Get-Text "Msg_Wait") "Cyan"; Get-AppxPackage -AllUsers | ForEach-Object { Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" }; Start-Sleep 2 }
            '2' { taskkill /f /im OneDrive.exe | Out-Null; Remove-Item "$env:USERPROFILE\OneDrive" -Recurse -Force; Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2 }
            '3' { Stop-Service FontCache; Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\*.dat" -Force; Start-Service FontCache; Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2 }
            '4' { Stop-Service bthserv; Remove-Item "HKLM:\SYSTEM\CurrentControlSet\Services\BTHPORT\Parameters\Keys\*" -Recurse -Force; Start-Service bthserv; Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2 }
            '5' { 
                $RegFile = "HKCR\*\shell\runas"; $RegDir = "HKCR\Directory\shell\runas"; New-Item -Path $RegFile -Force | Out-Null; Set-ItemProperty -Path $RegFile -Name "(default)" -Value "Tomar Posse"; New-Item -Path "$RegFile\command" -Force | Out-Null; Set-ItemProperty -Path "$RegFile\command" -Name "(default)" -Value "cmd.exe /c takeown /f `"%1`" && icacls `"%1`" /grant administrators:F"; New-Item -Path $RegDir -Force | Out-Null; Set-ItemProperty -Path $RegDir -Name "(default)" -Value "Tomar Posse"; New-Item -Path "$RegDir\command" -Force | Out-Null; Set-ItemProperty -Path "$RegDir\command" -Name "(default)" -Value "cmd.exe /c takeown /f `"%1`" /r /d y && icacls `"%1`" /grant administrators:F /t"; Show-Center (Get-Text "Msg_Done") "Green"; Start-Sleep 2 
            }
            '6' { 
                Show-Center (Get-Text "Msg_Wait") "Cyan"; $Dest = "C:\Backup_Drivers"; if (-not (Test-Path $Dest)) { New-Item -ItemType Directory -Force -Path $Dest | Out-Null }
                try { Export-WindowsDriver -Online -Destination $Dest -ErrorAction Stop | Out-Null; Show-Center "$(Get-Text 'Msg_Done') $Dest" "Green" } catch { Show-Center "Erro" "Red" }; Start-Sleep 3
            }
            '0' { return }
        }
    } while ($true)
}

function Modulo-Mas {
    Clear-Host; Draw-Header; Show-Center (Get-Text "M_Act") "Red"; Write-Host ""
    Show-Center "[1] Windows HWID  |  [2] Office" "White"
    Write-Host ""; Show-Center (Get-Text "Msg_Wait") "Cyan"
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    try { irm https://get.activated.win | iex } catch { Show-Center "Erro" "Red"; Start-Sleep 2 }
}

# --- MENU PRINCIPAL ---
do {
    Draw-Header
    Show-Center " COMMAND CENTER $Version | LANG: $($global:UserLang) " "DarkGray"; Write-Host ""
    
    Draw-Menu-Item "1" (Get-Text "M_Opt") (Get-Text "Cat_Clean") "Green" (Get-Text "D_Opt")
    Draw-Separator
    Draw-Menu-Item "2" (Get-Text "M_Lite") (Get-Text "Cat_Lite") "Green" (Get-Text "D_Lite")
    Draw-Separator
    Draw-Menu-Item "3" (Get-Text "M_Gamer") (Get-Text "Cat_Gamer") "Magenta" (Get-Text "D_Gamer")
    Draw-Separator
    Draw-Menu-Item "4" (Get-Text "M_Sys") (Get-Text "Cat_Sys") "Yellow" (Get-Text "D_Sys")
    Draw-Separator
    Draw-Menu-Item "5" (Get-Text "M_Act") (Get-Text "Cat_Act") "Red" (Get-Text "D_Act")
    Draw-Separator
    Draw-Menu-Item "6" (Get-Text "M_Diag") (Get-Text "Cat_Info") "Cyan" (Get-Text "D_Diag")
    Draw-Separator
    Draw-Menu-Item "7" (Get-Text "M_Set") (Get-Text "Cat_Set") "Blue" (Get-Text "D_Set")
    Draw-Separator
    Draw-Menu-Item "0" (Get-Text "M_Exit") "---" "DarkGray" (Get-Text "D_Exit")
    
    Write-Host "`n"; Show-Center (Get-Text "Choose") $global:AppTheme
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
