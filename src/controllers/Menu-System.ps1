# =================================================================
# SYSTEM OPTIMIZER - CONTROLLER (SYSTEM MENU NAVIGATION)
# =================================================================

# Submenu de Ferramentas Avançadas (Página 2)
function Invoke-SystemToolsPage2 {
    [CmdletBinding()]
    param()

    # Loop Rotulado para corrigir bug de navegação estrutural
    :SystemPage2Loop do {
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
                    $AdvOutput = [PSCustomObject]@{ Status = "Success"; Message = "OneDrive e residuos removidos." }
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
                    $AdvOutput = [PSCustomObject]@{ Status = "Success"; Message = "Cache do Bluetooth zerado." }
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
            '0' { break SystemPage2Loop } # Retorna para a página 1 de ferramentas do sistema
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

# Menu Principal de Ferramentas de Sistema (Página 1)
function Invoke-SystemMenu {
    [CmdletBinding()]
    param()

    # Loop Rotulado para corrigir bug de navegação estrutural
    :SystemLoop do {
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
                $FetchResult = Invoke-ThirdPartyTool -ToolName "WinUtil"
                if ($FetchResult.Status -eq "Success") {
                    try {
                        & $FetchResult.ScriptBlock
                        $SysOutput = [PSCustomObject]@{ Status = "Success"; Message = "WinUtil executado." }
                    } catch {
                        $SysOutput = [PSCustomObject]@{ Status = "Error"; Message = "Falha ao rodar WinUtil: $($_.Exception.Message)" }
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
                # Navega para a página 2 (Submenu Avançado)
                Invoke-SystemToolsPage2
            }
            '0' { break SystemLoop } # Retorna para o menu principal
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
