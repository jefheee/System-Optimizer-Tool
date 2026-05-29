# =================================================================
# SYSTEM OPTIMIZER - UPDATE HELPER MODULE (AUTO-UPDATE ROUTINES)
# =================================================================

function Start-AppUpdate {
    [CmdletBinding()]
    param(
        [string]$RepoRaw = "https://raw.githubusercontent.com/jefheee/System-Optimizer-Tool/main"
    )
    
    $FilesToUpdate = @(
        "Optimizer.ps1",
        "SystemOptimizer.bat",
        "lang.json",
        "CHANGELOG.md",
        "README.md",
        "src/core/Lang-Manager.ps1",
        "src/core/UI-Renderer.ps1",
        "src/utils/Win32-Helper.ps1",
        "src/utils/Update-Helper.ps1",
        "src/utils/ThirdParty-Fetcher.ps1",
        "src/modules/Opt-Clean.ps1",
        "src/modules/Opt-Gamer.ps1",
        "src/modules/Opt-System.ps1",
        "src/modules/Opt-Diagnostics.ps1"
    )
    
    $Results = [System.Collections.Generic.List[PSCustomObject]]::new()
    
    # Configura TLS 1.2+
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13
    
    foreach ($File in $FilesToUpdate) {
        $LocalPath = Join-Path $global:ScriptPath $File.Replace('/', '\')
        $RemoteURL = "$RepoRaw/$File"
        
        $FileResult = [PSCustomObject]@{
            File    = $File
            Status  = "Pending"
            Message = ""
        }
        
        try {
            # Garante que a pasta pai local exista antes do download
            $ParentDir = Split-Path -Parent $LocalPath
            if (-not (Test-Path $ParentDir)) {
                [void](New-Item -ItemType Directory -Path $ParentDir -Force)
            }
            
            # Executa a requisição sem o alias irm
            $Content = Invoke-RestMethod -Uri $RemoteURL -UseBasicParsing -TimeoutSec 10
            
            # Validação simples baseada na integridade e tipo do arquivo
            $Valid = $false
            if ($File -eq "lang.json" -and $Content -match "LangName") { $Valid = $true }
            elseif ($File -eq "SystemOptimizer.bat" -and $Content -match "SYSTEM OPTIMIZER") { $Valid = $true }
            elseif ($File.EndsWith(".ps1") -and ($Content -match "function" -or $Content -match "#")) { $Valid = $true }
            elseif ($File.EndsWith(".md")) { $Valid = $true }
            
            if ($Valid) {
                Set-Content -Path $LocalPath -Value $Content -Force -Encoding UTF8
                $FileResult.Status = "Success"
                $FileResult.Message = "Atualizado"
            } else {
                $FileResult.Status = "Skipped"
                $FileResult.Message = "Ignorado (Validacao de integridade falhou)"
            }
        } catch {
            $FileResult.Status = "Error"
            $FileResult.Message = $_.Exception.Message
        }
        
        $Results.Add($FileResult)
    }
    
    return $Results
}
