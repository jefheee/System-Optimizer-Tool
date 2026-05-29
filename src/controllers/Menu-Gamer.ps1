# =================================================================
# SYSTEM OPTIMIZER - CONTROLLER (GAMER MENU NAVIGATION)
# =================================================================

function Invoke-GamerMenu {
    [CmdletBinding()]
    param()

    # Loop Rotulado (Labeled Loop) para corrigir o bug de navegação estrutural do break em switch
    :GamerLoop do {
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
                $null = Set-LatencyResolution -Enable $false # Restaura o temporizador padrão
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
            '0' { break GamerLoop } # Sai imediatamente do loop de navegação Gamer
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
