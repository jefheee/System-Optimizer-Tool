# =================================================================
# SYSTEM OPTIMIZER - UI RENDERER MODULE (CONSOLE UI ENGINE)
# =================================================================

$ThemeFile = Join-Path $ScriptPath "theme.ini"
$global:AppTheme = if (Test-Path $ThemeFile) { (Get-Content $ThemeFile).Trim() } else { "Cyan" }

# Configura o buffer do terminal para evitar quebra de layout e tela preta
function Set-ConsoleBuffer {
    try {
        $RawUI = $Host.UI.RawUI
        $Buf = $RawUI.BufferSize
        $Buf.Width = 120
        $Buf.Height = 3000
        $RawUI.BufferSize = $Buf
    } catch {
        # Silencia exceção se rodar sob um host não-interativo
    }
}

# Renderiza texto centralizado
function Show-Center {
    param(
        [string]$Text,
        [string]$Color = "White"
    )
    $Trimmed = $Text.Trim()
    $PadLeft = [math]::Floor(($FixedW - $Trimmed.Length) / 2)
    if ($PadLeft -lt 0) { $PadLeft = 0 }
    Write-Host (" " * $PadLeft) -NoNewline
    Write-Host "$Trimmed" -ForegroundColor $Color
}

# Renderiza lista de itens no formato de pirâmide invertida por comprimento de caracteres
function Show-Pyramid {
    param(
        [array]$List,
        [string]$Color = "White"
    )
    $Sorted = $List | Sort-Object Length -Descending
    foreach ($Item in $Sorted) {
        Show-Center $Item $Color
    }
}

# Renderiza dois textos divididos no centro com cores diferentes
function Show-DualCenter {
    param(
        [string]$LeftText,
        [string]$RightText,
        [string]$ColorL = "White",
        [string]$ColorR = "White"
    )
    $TotalLen = $LeftText.Length + 5 + $RightText.Length
    $PadLeft = [math]::Floor(($FixedW - $TotalLen) / 2)
    if ($PadLeft -lt 0) { $PadLeft = 0 }
    Write-Host (" " * $PadLeft) -NoNewline
    Write-Host "$LeftText     " -NoNewline -ForegroundColor $ColorL
    Write-Host "$RightText" -ForegroundColor $ColorR
}

# Desenha uma linha separadora cinza escuro
function Show-Separator {
    Show-Center "--------------------------------------------------------------------------------" "DarkGray"
}

# Renderiza o cabeçalho ASCII do System Optimizer
function Show-Header {
    Clear-Host
    Write-Host "`n"
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

# Desenha uma linha de item de menu
function Show-MenuItem {
    param(
        [string]$Num,
        [string]$Title,
        [string]$CategoryText,
        [string]$ColorHex,
        [string]$Desc
    )
    $PadStart = " " * 8
    Write-Host "$PadStart" -NoNewline
    Write-Host "[$Num] " -NoNewline -ForegroundColor $global:AppTheme
    $T = "$Title".PadRight(28)
    Write-Host "$T" -NoNewline -ForegroundColor White
    $A = "[$CategoryText]".PadRight(12)
    Write-Host "$A " -NoNewline -ForegroundColor $ColorHex
    Write-Host "- $Desc" -ForegroundColor Gray
}

# Pausa a execução aguardando interação do teclado
function Wait-User {
    Write-Host "`n"
    Show-Center (Get-AppText "Wait") "DarkGray"
    [void]($Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown"))
}

# Exibe o seletor visual de linguagens
function Select-LanguageGui {
    Show-Header
    Show-Center " GLOBAL LANGUAGE SELECTOR " "DarkGray"
    Write-Host "`n"
    
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
    
    Write-Host "`n"
    Show-Center (Get-AppText "Choose") $global:AppTheme
    $Choice = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
    switch ($Choice) {
        '2' { $global:UserLang = "EN"; Set-Content $PrefFile "EN" }
        '3' { $global:UserLang = "ES"; Set-Content $PrefFile "ES" }
        '4' { $global:UserLang = "FR"; Set-Content $PrefFile "FR" }
        '5' { $global:UserLang = "DE"; Set-Content $PrefFile "DE" }
        '6' { $global:UserLang = "RU"; Set-Content $PrefFile "RU" }
        '7' { $global:UserLang = "CN"; Set-Content $PrefFile "CN" }
        Default { $global:UserLang = "PT"; Set-Content $PrefFile "PT" }
    }
}
