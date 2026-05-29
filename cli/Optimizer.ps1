# =================================================================
# SYSTEM OPTIMIZER - BOOTSTRAPPER (CLI ROUTER LAUNCHER)
# =================================================================
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$FixedW = 100
$Version = "V59 (Modular)"

# ScriptPath agora é a pasta /cli/ onde este bootstrapper reside
$ScriptPath = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent -Path $MyInvocation.MyCommand.Definition }
$global:ScriptPath = $ScriptPath
$global:CurrentFile = $MyInvocation.MyCommand.Definition

# Importação de utilitários, core, módulos e roteadores voltando um nível (..\src\...)
$Libs = @(
    "..\src\utils\Win32-Helper.ps1", "..\src\core\Lang-Manager.ps1", "..\src\core\UI-Renderer.ps1",
    "..\src\utils\Update-Helper.ps1", "..\src\utils\ThirdParty-Fetcher.ps1",
    "..\src\modules\Opt-Clean.ps1", "..\src\modules\Opt-Gamer.ps1", "..\src\modules\Opt-System.ps1", "..\src\modules\Opt-Diagnostics.ps1",
    "..\src\controllers\Menu-Gamer.ps1", "..\src\controllers\Menu-System.ps1", "..\src\controllers\Menu-Settings.ps1", "..\src\controllers\Menu-Main.ps1"
)

foreach ($Lib in $Libs) {
    $Path = Join-Path $ScriptPath $Lib
    if (Test-Path $Path) { . $Path } else { Write-Error "Modulo ausente: $Lib"; Start-Sleep -Seconds 5; exit 1 }
}

Set-ConsoleBuffer
Invoke-MainMenu
