# =================================================================
# SYSTEM OPTIMIZER - CONTROLLER (SETTINGS MENU NAVIGATION)
# =================================================================

function Invoke-SettingsMenu {
    [CmdletBinding()]
    param()

    # Loop Rotulado para corrigir bug de navegação estrutural
    :SettingsLoop do {
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
                    Show-Center "Erro ao criar atalho." "Red"
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
            '0' { break SettingsLoop } # Retorna para o menu principal
        }
    } while ($true)
}
