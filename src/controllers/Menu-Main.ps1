# =================================================================
# SYSTEM OPTIMIZER - CONTROLLER (MAIN MENU ROUTER)
# =================================================================

function Invoke-MainMenu {
    [CmdletBinding()]
    param()

    # Loop Rotulado para navegação CLI perfeita
    :MainLoop do {
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
                
                # Executa otimização profunda e renderiza saída estruturada
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
                
                # Executa otimização leve e renderiza
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
                # Navega para o controlador Gamer
                Invoke-GamerMenu
            }
            
            '4' { 
                # Navega para o controlador de Sistema
                Invoke-SystemMenu
            }
            
            '5' { 
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
                        Show-Center "Erro ao carregar MAS: $($_.Exception.Message)" "Red"
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
                
                # Invoca diagnóstico estruturado
                $Diag = Get-SystemDiagnostics
                
                if ($Diag.Status -eq "Success" -or $Diag.Status -eq "Warning") {
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
                # Navega para o controlador de Configurações
                Invoke-SettingsMenu
            }
            
            '0' { 
                exit 0 
            }
        }
    } while ($true)
}
