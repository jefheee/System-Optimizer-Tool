# =================================================================
# SYSTEM OPTIMIZER - MAIN BOOTSTRAPPER (MODULAR BACKEND ENGINE)
# =================================================================

# Configurações globais e preferências de codificação
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$FixedW = 100
$Version = "V59 (Modular)"

# Determina o diretório base do script de forma segura e consistente
if ($PSScriptRoot) { 
    $ScriptPath = $PSScriptRoot 
} else { 
    $ScriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition 
}
$global:ScriptPath = $ScriptPath
$global:CurrentFile = $MyInvocation.MyCommand.Definition

# Dot-Sourcing estruturado de todas as bibliotecas, utilitários e módulos funcionais
$FilesToLoad = @(
    "src\utils\Win32-Helper.ps1",
    "src\core\Lang-Manager.ps1",
    "src\core\UI-Renderer.ps1",
    "src\utils\Update-Helper.ps1",
    "src\utils\ThirdParty-Fetcher.ps1",
    "src\modules\Opt-Clean.ps1",
    "src\modules\Opt-Gamer.ps1",
    "src\modules\Opt-System.ps1",
    "src\modules\Opt-Diagnostics.ps1"
)

foreach ($File in $FilesToLoad) {
    $FullPath = Join-Path $ScriptPath $File
    if (Test-Path $FullPath) {
        . $FullPath
    } else {
        Write-Error "Dependencia modular critica ausente: $File"
        Start-Sleep -Seconds 5
        exit 1
    }
}

# Inicializa buffers do terminal console
Set-ConsoleBuffer

# Loop do Menu CLI Principal (Apresentação de Consumo da API)
do {
    Show-Header
    Show-Center " COMMAND CENTER $Version | LANG: $($global:UserLang) " "DarkGray"
    Write-Host ""
    
    Show-MenuItem "1" (Get-AppText "M_Opt") (Get-AppText "Cat_Clean") "Green" (Get-AppText "D_Opt")
    Show-Separator
    Show-MenuItem "2" (Get-AppText "M_Lite") (Get-AppText "Cat_Lite") "Green" (Get-AppText "D_Lite")
    Show-Separator
    Show-MenuItem "3" (Get-AppText "M_Gamer") (Get-AppText "Cat_Gamer") "Magenta" (Get-AppText "D_Gamer")
    Show-Separator
    Show-MenuItem "4" (Get-AppText "M_Sys") (Get-AppText "Cat_Sys") "Yellow" (Get-AppText "D_Sys")
    Show-Separator
    Show-MenuItem "5" (Get-AppText "M_Act") (Get-AppText "Cat_Act") "Red" (Get-AppText "D_Act")
    Show-Separator
    Show-MenuItem "6" (Get-AppText "M_Diag") (Get-AppText "Cat_Info") "Cyan" (Get-AppText "D_Diag")
    Show-Separator
    Show-MenuItem "7" (Get-AppText "M_Set") (Get-AppText "Cat_Set") "Blue" (Get-AppText "D_Set")
    Show-Separator
    Show-MenuItem "0" (Get-AppText "M_Exit") "---" "DarkGray" (Get-AppText "D_Exit")
    
    Write-Host "`n"
    Show-Center (Get-AppText "Choose") $global:AppTheme
    $Key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
    
    switch ($Key) {
        '1' { 
            Show-Header
            Show-Center "=== $(Get-AppText 'M_Opt') ===" "White"
            Write-Host "`n"
            Show-Center (Get-AppText "Msg_Wait") "Yellow"
            
            # Executa a limpeza do backend e consome o retorno estruturado PSCustomObject
            $CleanResults = Invoke-Optimization
            
            foreach ($Res in $CleanResults) {
                if ($Res.Step -ne "Summary") {
                    Show-Center "$(Get-AppText 'Msg_Clean') $($Res.Target) ($($Res.BytesFreed) MB)..." "Cyan"
                } else {
                    Write-Host "`n"
                    Show-Center "TOTAL: $($Res.BytesFreed) MB" "Green"
                    Show-Center (Get-AppText "Msg_Done") "Green"
                }
            }
            Wait-User
        }
        
        '2' { 
            Show-Header
            Show-Center "=== $(Get-AppText 'M_Lite') ===" "White"
            Write-Host "`n"
            Show-Center (Get-AppText "Msg_Wait") "Yellow"
            
            # Executa a limpeza lite e consome o retorno estruturado
            $CleanResults = Invoke-LiteOptimization
            
            foreach ($Res in $CleanResults) {
                if ($Res.Step -ne "Summary") {
                    Show-Center "$(Get-AppText 'Msg_Clean') $($Res.Target) ($($Res.BytesFreed) MB)..." "Cyan"
                } else {
                    Write-Host "`n"
                    Show-Center "TOTAL: $($Res.BytesFreed) MB" "Green"
                    Show-Center (Get-AppText "Msg_Done") "Green"
                }
            }
            Wait-User
        }
        
        '3' { 
            # Submenu Gamer
            do {
                Show-Header
                Show-Center " COMMAND CENTER $Version | LANG: $($global:UserLang) " "DarkGray"
                Write-Host ""
                Show-Center "=== $(Get-AppText 'M_Gamer') ===" "Magenta"
                Write-Host ""
                
                Show-MenuItem "1" (Get-AppText "G_Timer") (Get-AppText "Cat_Gamer") "Magenta" (Get-AppText "DG_Timer")
                Show-Separator
                Show-MenuItem "2" (Get-AppText "G_Prio") (Get-AppText "Cat_Gamer") "Magenta" (Get-AppText "DG_Prio")
                Show-Separator
                Show-MenuItem "3" (Get-AppText "G_FSO") (Get-AppText "Cat_Gamer") "Magenta" (Get-AppText "DG_FSO")
                Show-Separator
                Show-MenuItem "4" (Get-AppText "G_Mouse") (Get-AppText "Cat_Gamer") "Magenta" (Get-AppText "DG_Mouse")
                Show-Separator
                Show-MenuItem "5" (Get-AppText "G_Keys") (Get-AppText "Cat_Gamer") "Magenta" (Get-AppText "DG_Keys")
                Show-Separator
                Show-MenuItem "6" (Get-AppText "G_Net") (Get-AppText "Cat_Gamer") "Magenta" (Get-AppText "DG_Net")
                Show-Separator
                Show-MenuItem "7" (Get-AppText "G_Ram") (Get-AppText "Cat_Gamer") "Magenta" (Get-AppText "DG_Ram")
                Show-Separator
                Show-MenuItem "8" (Get-AppText "G_Def") (Get-AppText "Cat_Gamer") "Magenta" (Get-AppText "DG_Def")
                Show-Separator
                Show-MenuItem "9" (Get-AppText "G_Dx") (Get-AppText "Cat_Gamer") "Magenta" (Get-AppText "DG_Dx")
                Show-Separator
                Show-MenuItem "0" (Get-AppText "Back") "---" "DarkGray" (Get-AppText "D_Back")
                
                Write-Host "`n"
                Show-Center (Get-AppText "Choose") $global:AppTheme
                $SubKey = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
                
                $GamerOutput = $null
                switch ($SubKey) {
                    '1' { 
                        Clear-Host
                        Show-Center "Timer: 0.5ms (Pressione qualquer tecla para retornar e restaurar)" "Cyan"
                        $GamerOutput = Set-LatencyResolution -Enable $true
                        [void]($Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown"))
                        $null = Set-LatencyResolution -Enable $false # Restaura timer ao sair
                    }
                    '2' {
                        Show-Center (Get-AppText "Msg_Input") "White"
                        $Proc = Read-Host
                        if ($Proc) {
                            $GamerOutput = Set-ProcessPriority -ProcessName $Proc
                        }
                    }
                    '3' { $GamerOutput = Set-GameDVR }
                    '4' { $GamerOutput = Set-MouseOptimization }
                    '5' { $GamerOutput = Set-KeyboardOptimization }
                    '6' { $GamerOutput = Set-NetworkOptimization }
                    '7' { $GamerOutput = Start-RamAutoCleanJob }
                    '8' {
                        Show-Center (Get-AppText "Msg_Input") "White"
                        $PPath = Read-Host
                        if ($PPath) {
                            $GamerOutput = Add-DefenderExclusion -Path $PPath
                        }
                    }
                    '9' { $GamerOutput = Reset-DirectXShader }
                    '0' { break }
                }
                
                if ($GamerOutput) {
                    if ($GamerOutput.Status -eq "Success") {
                        Show-Center ($GamerOutput.Message) "Green"
                    } else {
                        Show-Center "Erro: $($GamerOutput.Message)" "Red"
                    }
                    Start-Sleep -Seconds 2
                }
            } while ($true)
        }
        
        '4' { 
            # Submenu Sistema
            do {
                Show-Header
                Show-Center " COMMAND CENTER $Version | LANG: $($global:UserLang) " "DarkGray"
                Write-Host ""
                Show-Center "=== $(Get-AppText 'M_Sys') ===" "Yellow"
                Write-Host ""
                
                Show-MenuItem "1" (Get-AppText "Y_WinUtil") (Get-AppText "Cat_Sys") "Yellow" (Get-AppText "DY_WinUtil")
                Show-Separator
                Show-MenuItem "2" (Get-AppText "Y_Upd") (Get-AppText "Cat_Sys") "Yellow" (Get-AppText "DY_Upd")
                Show-Separator
                Show-MenuItem "3" (Get-AppText "Y_Dns") (Get-AppText "Cat_Sys") "Yellow" (Get-AppText "DY_Dns")
                Show-Separator
                Show-MenuItem "4" (Get-AppText "Y_Rep") (Get-AppText "Cat_Sys") "Yellow" (Get-AppText "DY_Rep")
                Show-Separator
                Show-MenuItem "5" (Get-AppText "Y_Orphan") (Get-AppText "Cat_Sys") "Yellow" (Get-AppText "DY_Orphan")
                Show-Separator
                Show-MenuItem "6" (Get-AppText "Y_Apps") (Get-AppText "Cat_Sys") "Yellow" (Get-AppText "DY_Apps")
                Show-Separator
                Show-MenuItem "7" (Get-AppText "Y_Tel") (Get-AppText "Cat_Sys") "Yellow" (Get-AppText "DY_Tel")
                Show-Separator
                Show-MenuItem "8" (Get-AppText "Y_Adv") (Get-AppText "Cat_Sys") "Yellow" (Get-AppText "DY_Adv")
                Show-Separator
                Show-MenuItem "0" (Get-AppText "Back") "---" "DarkGray" (Get-AppText "D_Back")
                
                Write-Host "`n"
                Show-Center (Get-AppText "Choose") $global:AppTheme
                $SubKey = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
                
                $SysOutput = $null
                switch ($SubKey) {
                    '1' { 
                        Show-Center (Get-AppText "Msg_Wait") "Cyan"
                        # Executa busca segura da ferramenta remota e a invoca
                        $FetchResult = Invoke-ThirdPartyTool -ToolName "WinUtil"
                        if ($FetchResult.Status -eq "Success") {
                            try {
                                & $FetchResult.ScriptBlock
                                $SysOutput = [PSCustomObject]@{ Status = "Success"; Message = "WinUtil carregado com sucesso." }
                            } catch {
                                $SysOutput = [PSCustomObject]@{ Status = "Error"; Message = "Falha ao executar WinUtil: $($_.Exception.Message)" }
                            }
                        } else {
                            $SysOutput = [PSCustomObject]@{ Status = "Error"; Message = $FetchResult.Message }
                        }
                    }
                    '2' { $SysOutput = Repair-WindowsUpdate }
                    '3' { 
                        Show-Center (Get-AppText "Msg_Wait") "Cyan"
                        $SysOutput = Set-DnsOptimization 
                    }
                    '4' { 
                        Show-Center (Get-AppText "Msg_Wait") "Cyan"
                        $SysOutput = Invoke-SystemSfcDism 
                        Wait-User
                    }
                    '5' { $SysOutput = Remove-OrphanedTasks }
                    '6' { $SysOutput = Remove-Bloatware }
                    '7' { $SysOutput = Disable-Telemetry }
                    '8' { 
                        # Submenu Avançado 2
                        do {
                            Show-Header
                            Show-Center " COMMAND CENTER $Version | LANG: $($global:UserLang) " "DarkGray"
                            Write-Host ""
                            Show-Center "=== $(Get-AppText 'M_Sys') 2 ===" "Red"
                            Write-Host ""
                            
                            Show-MenuItem "1" (Get-AppText "A_Store") (Get-AppText "Cat_Sys") "Yellow" (Get-AppText "DA_Store")
                            Show-Separator
                            Show-MenuItem "2" (Get-AppText "A_One") (Get-AppText "Cat_Adv") "Red" (Get-AppText "DA_One")
                            Show-Separator
                            Show-MenuItem "3" (Get-AppText "A_Font") (Get-AppText "Cat_Adv") "Red" (Get-AppText "DA_Font")
                            Show-Separator
                            Show-MenuItem "4" (Get-AppText "A_Blue") (Get-AppText "Cat_Adv") "Red" (Get-AppText "DA_Blue")
                            Show-Separator
                            Show-MenuItem "5" (Get-AppText "A_Own") (Get-AppText "Cat_Sys") "Yellow" (Get-AppText "DA_Own")
                            Show-Separator
                            Show-MenuItem "6" (Get-AppText "A_Drv") (Get-AppText "Cat_Adv") "Red" (Get-AppText "DA_Drv")
                            Show-Separator
                            Show-MenuItem "0" (Get-AppText "Back") "---" "DarkGray" (Get-AppText "D_Back")
                            
                            Write-Host "`n"
                            Show-Center (Get-AppText "Choose") $global:AppTheme
                            $AdvKey = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
                            
                            $AdvOutput = $null
                            switch ($AdvKey) {
                                '1' {
                                    Show-Center (Get-AppText "Msg_Wait") "Cyan"
                                    try {
                                        Get-AppxPackage -AllUsers | ForEach-Object { 
                                            Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" 
                                        }
                                        $AdvOutput = [PSCustomObject]@{ Status = "Success"; Message = "Windows Store restaurada." }
                                    } catch {
                                        $AdvOutput = [PSCustomObject]@{ Status = "Error"; Message = $_.Exception.Message }
                                    }
                                }
                                '2' {
                                    try {
                                        [void](taskkill.exe /f /im OneDrive.exe 2>$null)
                                        $Path = "$env:USERPROFILE\OneDrive"
                                        if (Test-Path $Path) {
                                            Remove-Item -Path $Path -Recurse -Force -ErrorAction SilentlyContinue
                                        }
                                        $AdvOutput = [PSCustomObject]@{ Status = "Success"; Message = "OneDrive e diretórios residuais removidos." }
                                    } catch {
                                        $AdvOutput = [PSCustomObject]@{ Status = "Error"; Message = $_.Exception.Message }
                                    }
                                }
                                '3' {
                                    try {
                                        [void](Stop-Service -Name "FontCache" -Force -ErrorAction SilentlyContinue)
                                        $Path = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\*.dat"
                                        Remove-Item -Path $Path -Force -ErrorAction SilentlyContinue
                                        [void](Start-Service -Name "FontCache" -ErrorAction SilentlyContinue)
                                        $AdvOutput = [PSCustomObject]@{ Status = "Success"; Message = "Cache de fontes reiniciado e limpo." }
                                    } catch {
                                        $AdvOutput = [PSCustomObject]@{ Status = "Error"; Message = $_.Exception.Message }
                                    }
                                }
                                '4' {
                                    try {
                                        [void](Stop-Service -Name "bthserv" -Force -ErrorAction SilentlyContinue)
                                        $Path = "HKLM:\SYSTEM\CurrentControlSet\Services\BTHPORT\Parameters\Keys\*"
                                        Remove-Item -Path $Path -Recurse -Force -ErrorAction SilentlyContinue
                                        [void](Start-Service -Name "bthserv" -ErrorAction SilentlyContinue)
                                        $AdvOutput = [PSCustomObject]@{ Status = "Success"; Message = "Cache do pareamento Bluetooth limpo." }
                                    } catch {
                                        $AdvOutput = [PSCustomObject]@{ Status = "Error"; Message = $_.Exception.Message }
                                    }
                                }
                                '5' { $AdvOutput = Set-TakeOwnership }
                                '6' { 
                                    Show-Center (Get-AppText "Msg_Wait") "Cyan"
                                    $AdvOutput = Backup-Drivers 
                                    if ($AdvOutput.Status -eq "Success") {
                                        Show-Center "Destino: $($AdvOutput.Destination)" "Cyan"
                                        Start-Sleep -Seconds 1
                                    }
                                }
                                '0' { break }
                            }
                            
                            if ($AdvOutput) {
                                if ($AdvOutput.Status -eq "Success") {
                                    Show-Center ($AdvOutput.Message) "Green"
                                } else {
                                    Show-Center "Erro: $($AdvOutput.Message)" "Red"
                                }
                                Start-Sleep -Seconds 2
                            }
                        } while ($true)
                    }
                    '0' { break }
                }
                
                if ($SysOutput) {
                    if ($SysOutput.Status -eq "Success") {
                        Show-Center ($SysOutput.Message) "Green"
                    } else {
                        Show-Center "Erro: $($SysOutput.Message)" "Red"
                    }
                    Start-Sleep -Seconds 2
                }
            } while ($true)
        }
        
        '5' { 
            # Windows/Office Activator (MAS)
            Show-Header
            Show-Center (Get-AppText "M_Act") "Red"
            Write-Host "`n"
            Show-Center "[1] Windows HWID  |  [2] Office" "White"
            Write-Host ""
            Show-Center (Get-AppText "Msg_Wait") "Cyan"
            [void]($Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown"))
            
            $FetchResult = Invoke-ThirdPartyTool -ToolName "MAS"
            if ($FetchResult.Status -eq "Success") {
                try {
                    & $FetchResult.ScriptBlock
                } catch {
                    Show-Center "Erro ao invocar ativador MAS: $($_.Exception.Message)" "Red"
                    Start-Sleep -Seconds 3
                }
            } else {
                Show-Center "Falha ao baixar MAS: $($FetchResult.Message)" "Red"
                Start-Sleep -Seconds 3
            }
        }
        
        '6' { 
            # Diagnóstico
            Show-Header
            Show-Center "=== $(Get-AppText 'M_Diag') ===" "White"
            Write-Host "`n"
            Show-Center (Get-AppText "Msg_Wait") "Yellow"
            Write-Host "`n"
            
            # Invoca diagnóstico otimizado do backend
            $Diag = Get-SystemDiagnostics
            
            if ($Diag.Status -eq "Success" -or $Diag.Status -eq "Warning") {
                # Renderiza dados formatando no console CLI de forma apartada
                if ($Diag.OperatingSystem) {
                    $UptimeStr = "$($Diag.OperatingSystem.Uptime.Days)d $($Diag.OperatingSystem.Uptime.Hours)h $($Diag.OperatingSystem.Uptime.Minutes)m"
                    Show-Center "$(Get-AppText 'Diag_OS'): $($Diag.OperatingSystem.Caption) (Build $($Diag.OperatingSystem.BuildNumber))" "White"
                    Show-Center "$(Get-AppText 'Diag_Up'): $UptimeStr" "White"
                }
                
                Write-Host "`n"
                Show-Center (Get-AppText 'Diag_HW') "Cyan"
                
                $HardwareLines = @()
                if ($Diag.Cpu) { $HardwareLines += "[CPU] $($Diag.Cpu.Name)" }
                if ($Diag.Gpu) { $HardwareLines += "[GPU] $($Diag.Gpu.Name)" }
                if ($Diag.Memory) { 
                    $MemDetails = @()
                    foreach ($Mod in $Diag.Memory.Modules) {
                        $MemDetails += "$($Mod.CapacityGB)GB $($Mod.SpeedMHz)MHz"
                    }
                    $MemSummary = "$($Diag.Memory.TotalGB) GB (" + ($MemDetails -join ' + ') + ")"
                    $HardwareLines += "[RAM] $MemSummary" 
                }
                Show-Pyramid $HardwareLines "White"
                
                Write-Host "`n"
                Show-Center (Get-AppText 'Diag_Store') "Cyan"
                Write-Host ""
                foreach ($Disk in $Diag.Storage) {
                    $DiskColor = if ($Disk.HealthStatus -eq "Healthy") { "Green" } else { "Red" }
                    Show-DualCenter "$($Disk.MediaType) - $($Disk.SizeGB) GB - ($($Disk.Model))" "[$($Disk.HealthStatus)]" "White" $DiskColor
                }
            } else {
                Show-Center "Erro ao carregar diagnostico: $($Diag.Message)" "Red"
            }
            Wait-User
        }
        
        '7' { 
            # Menu de Configurações
            do {
                Show-Header
                Show-Center " COMMAND CENTER $Version | LANG: $($global:UserLang) " "DarkGray"
                Write-Host ""
                Show-Center "=== $(Get-AppText 'M_Set') ===" "Blue"
                Write-Host ""
                
                Show-MenuItem "1" (Get-AppText "S_Lang") (Get-AppText "Cat_Set") "Blue" (Get-AppText "DS_Lang")
                Show-Separator
                Show-MenuItem "2" (Get-AppText "S_Theme") (Get-AppText "Cat_Set") "Magenta" (Get-AppText "DS_Theme")
                Show-Separator
                Show-MenuItem "3" (Get-AppText "S_Short") (Get-AppText "Cat_Set") "Cyan" (Get-AppText "DS_Short")
                Show-Separator
                Show-MenuItem "4" (Get-AppText "S_Upd") (Get-AppText "Cat_Set") "Blue" (Get-AppText "DS_Upd")
                Show-Separator
                Show-MenuItem "5" (Get-AppText "S_Rst") (Get-AppText "Cat_Set") "Red" (Get-AppText "DS_Rst")
                Show-Separator
                Show-MenuItem "0" (Get-AppText "Back") "---" "DarkGray" (Get-AppText "D_Back")
                
                Write-Host "`n"
                Show-Center (Get-AppText "Choose") $global:AppTheme
                $SubKey = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
                
                switch ($SubKey) {
                    '1' { 
                        Remove-Item $PrefFile -Force -ErrorAction SilentlyContinue
                        Select-LanguageGui
                    }
                    '2' { 
                        if ($global:AppTheme -eq "Cyan") { $global:AppTheme = "Green"; Set-Content $ThemeFile "Green" }
                        elseif ($global:AppTheme -eq "Green") { $global:AppTheme = "Magenta"; Set-Content $ThemeFile "Magenta" }
                        else { $global:AppTheme = "Cyan"; Set-Content $ThemeFile "Cyan" }
                        Show-Center (Get-AppText "Msg_Done") "Green"
                        Start-Sleep -Seconds 1
                    }
                    '3' {
                        try {
                            $WshShell = New-Object -ComObject WScript.Shell
                            $Shortcut = $WshShell.CreateShortcut("$HOME\Desktop\System Optimizer.lnk")
                            $Shortcut.TargetPath = "$ScriptPath\SystemOptimizer.bat"
                            $Shortcut.IconLocation = "shell32.dll, 24" 
                            $Shortcut.Save()
                            Show-Center (Get-AppText "Msg_Done") "Green"
                        } catch {
                            Show-Center "Erro ao criar atalho de Desktop." "Red"
                        }
                        Start-Sleep -Seconds 2
                    }
                    '4' { 
                        Show-Header
                        Show-Center (Get-AppText "Msg_Wait") "Cyan"
                        $UpdateStatus = Start-AppUpdate
                        $FailCount = 0
                        foreach ($FRes in $UpdateStatus) {
                            if ($FRes.Status -eq "Error") {
                                Show-Center "Falha ao baixar $($FRes.File): $($FRes.Message)" "Red"
                                $FailCount++
                            } else {
                                Show-Center "$($FRes.File): $($FRes.Status) ($($FRes.Message))" "Green"
                            }
                        }
                        if ($FailCount -eq 0) {
                            Show-Center (Get-AppText "Msg_UpdateOK") "Green"
                        } else {
                            Show-Center (Get-AppText "Msg_UpdateFail") "Red"
                        }
                        Wait-User
                    }
                    '5' { 
                        Remove-Item $PrefFile -Force -ErrorAction SilentlyContinue
                        Remove-Item $ThemeFile -Force -ErrorAction SilentlyContinue
                        Show-Center (Get-AppText "Msg_Done") "Green"
                        Start-Sleep -Seconds 1
                        exit 0
                    }
                    '0' { break }
                }
            } while ($true)
        }
        
        '0' { exit 0 }
    }
} while ($true)
