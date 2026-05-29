# =================================================================
# SYSTEM OPTIMIZER - THIRD PARTY FETCHER (HYBRID INTEGRATION MODULE)
# =================================================================

function Invoke-ThirdPartyTool {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("MAS", "WinUtil")]
        [string]$ToolName
    )
    
    $URLs = @{
        "MAS"      = "https://get.activated.win"
        "WinUtil"  = "https://christitus.com/win"
    }
    
    $TargetURL = $URLs[$ToolName]
    
    # Prepara o objeto de retorno (Backend API Pattern)
    $Result = [PSCustomObject]@{
        ToolName    = $ToolName
        Status      = "Pending"
        Message     = ""
        ScriptBlock = $null
    }
    
    try {
        # Garante o protocolo de segurança TLS 1.2/1.3 para conexões modernas do GitHub/Web
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13
        
        # Faz a chamada HTTP segura sem aliases (Invoke-RestMethod)
        $ScriptText = Invoke-RestMethod -Uri $TargetURL -UseBasicParsing -TimeoutSec 15
        
        if ($ScriptText -and ($ScriptText.Length -gt 100)) {
            # Validação simples de assinatura/conteúdo esperado para mitigar sequestro de DNS ou injeção remota
            if ($ToolName -eq "MAS" -and -not ($ScriptText -match "massgrave" -or $ScriptText -match "Activation")) {
                $Result.Status = "Error"
                $Result.Message = "Validacao de integridade falhou para o script remoto MAS."
                return $Result
            }
            if ($ToolName -eq "WinUtil" -and -not ($ScriptText -match "titus" -or $ScriptText -match "winutil")) {
                $Result.Status = "Error"
                $Result.Message = "Validacao de integridade falhou para o script remoto WinUtil."
                return $Result
            }
            
            $Result.Status = "Success"
            $Result.Message = "Script baixado com sucesso."
            # Encapsula o script remoto em um script block para execução dinâmica no escopo do chamador
            $Result.ScriptBlock = [scriptblock]::Create($ScriptText)
        } else {
            $Result.Status = "Error"
            $Result.Message = "O script remoto retornado esta vazio ou e muito curto."
        }
    } catch {
        $Result.Status = "Error"
        $Result.Message = "Falha de comunicacao de rede ao buscar a ferramenta: $($_.Exception.Message)"
    }
    
    return $Result
}
