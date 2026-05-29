# =================================================================
# SYSTEM OPTIMIZER - OPT-GAMER MODULE (GAMING LATENCY TWEAKS)
# =================================================================

# Reduz latência ajustando a resolução de timers do kernel Windows
function Set-LatencyResolution {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [bool]$Enable
    )
    
    $Result = [PSCustomObject]@{
        Tweak      = "Timer Resolution"
        Value      = if ($Enable) { "0.5ms" } else { "Default" }
        Status     = "Success"
        Message    = ""
    }
    
    try {
        $CurrentRes = 0
        if ($Enable) {
            # 5000 = 0.5ms
            $Ret = [Win32]::NtSetTimerResolution(5000, $true, [ref]$CurrentRes)
            if ($Ret -ne 0) {
                $Result.Status = "Warning"
                $Result.Message = "NtSetTimerResolution retornou status $Ret"
            } else {
                $Result.Message = "Resolucao ajustada para 0.5ms (Atual: $($CurrentRes / 10000)ms)"
            }
        } else {
            # 156000 = 15.6ms (Padrão Windows)
            $Ret = [Win32]::NtSetTimerResolution(156000, $true, [ref]$CurrentRes)
            $Result.Message = "Resolucao de temporizador restaurada para o padrao do Windows (Atual: $($CurrentRes / 10000)ms)"
        }
    } catch {
        $Result.Status = "Error"
        $Result.Message = $_.Exception.Message
    }
    
    return $Result
}

# Configura prioridade alta de CPU para um determinado jogo/processo no Registro do Windows
function Set-ProcessPriority {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ProcessName
    )
    
    $Result = [PSCustomObject]@{
        Tweak   = "CpuPriorityClass"
        Value   = "$ProcessName -> High"
        Status  = "Success"
        Message = ""
    }
    
    if (-not $ProcessName) {
        $Result.Status = "Error"
        $Result.Message = "Nome do processo invalido ou vazio."
        return $Result
    }
    
    # Normaliza a extensão .exe
    $KeyName = if ($ProcessName.EndsWith(".exe")) { $ProcessName } else { "$ProcessName.exe" }
    $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$KeyName\PerfOptions"
    
    try {
        if (-not (Test-Path $RegPath)) {
            [void](New-Item -Path $RegPath -Force)
        }
        # CpuPriorityClass = 3 representa prioridade High
        Set-ItemProperty -Path $RegPath -Name "CpuPriorityClass" -Value 3 -Force -ErrorAction Stop
        $Result.Message = "Prioridade configurada no Registro com sucesso para $KeyName."
    } catch {
        $Result.Status = "Error"
        $Result.Message = $_.Exception.Message
    }
    
    return $Result
}

# Desativa a otimização de tela cheia (GameDVR) para evitar delays de Alt+Tab
function Set-GameDVR {
    [CmdletBinding()]
    param()

    $Result = [PSCustomObject]@{
        Tweak   = "GameDVR_FSEBehaviorMode"
        Value   = "Disabled (2)"
        Status  = "Success"
        Message = ""
    }
    
    $RegPath = "HKCU:\System\GameConfigStore"
    try {
        Set-ItemProperty -Path $RegPath -Name "GameDVR_FSEBehaviorMode" -Value 2 -Force -ErrorAction Stop
        $Result.Message = "GameDVR FSEBehaviorMode ajustado para 2 no Registro."
    } catch {
        $Result.Status = "Error"
        $Result.Message = $_.Exception.Message
    }
    return $Result
}

# Remove aceleração de mouse aplicando precisão 1:1 nas chaves de registro
function Set-MouseOptimization {
    [CmdletBinding()]
    param()

    $Result = [PSCustomObject]@{
        Tweak   = "MouseSpeed"
        Value   = "0"
        Status  = "Success"
        Message = ""
    }
    
    $RegPath = "HKCU:\Control Panel\Mouse"
    try {
        Set-ItemProperty -Path $RegPath -Name "MouseSpeed" -Value "0" -Force -ErrorAction Stop
        $Result.Message = "Aceleracao do mouse desativada no Registro."
    } catch {
        $Result.Status = "Error"
        $Result.Message = $_.Exception.Message
    }
    return $Result
}

# Otimiza o atraso de repetição de teclas do teclado
function Set-KeyboardOptimization {
    [CmdletBinding()]
    param()

    $Result = [PSCustomObject]@{
        Tweak   = "AutoRepeatDelay"
        Value   = "150"
        Status  = "Success"
        Message = ""
    }
    
    $RegPath = "HKCU:\Control Panel\Accessibility\Keyboard Response"
    try {
        if (-not (Test-Path $RegPath)) {
            [void](New-Item -Path $RegPath -Force)
        }
        Set-ItemProperty -Path $RegPath -Name "AutoRepeatDelay" -Value "150" -Force -ErrorAction Stop
        $Result.Message = "Atraso do teclado configurado para 150ms no Registro."
    } catch {
        $Result.Status = "Error"
        $Result.Message = $_.Exception.Message
    }
    return $Result
}

# Desativa atrasos de confirmação de pacotes TCP (Nagle) ativando TcpAckFrequency
function Set-NetworkOptimization {
    [CmdletBinding()]
    param()

    $Result = [PSCustomObject]@{
        Tweak   = "TcpAckFrequency"
        Value   = "Enabled (1)"
        Status  = "Success"
        Message = ""
    }
    
    try {
        $Interfaces = Get-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\*" -ErrorAction Stop
        $SuccessCount = 0
        foreach ($Interface in $Interfaces) {
            try {
                New-ItemProperty -Path $Interface.PSPath -Name "TcpAckFrequency" -Value 1 -PropertyType DWord -Force -ErrorAction Stop | Out-Null
                $SuccessCount++
            } catch {}
        }
        $Result.Message = "TcpAckFrequency ativado em $SuccessCount adaptadores de rede."
    } catch {
        $Result.Status = "Error"
        $Result.Message = $_.Exception.Message
    }
    return $Result
}

# Inicia um Job em segundo plano para limpar o working set a cada 10 minutos
function Start-RamAutoCleanJob {
    [CmdletBinding()]
    param()

    $Result = [PSCustomObject]@{
        Tweak   = "RAM Auto-Clean Job"
        Value   = "10min Loop"
        Status  = "Success"
        Message = ""
    }
    
    try {
        $Existing = Get-Job -Name "RamOpt" -ErrorAction SilentlyContinue
        if ($Existing) {
            $Result.Message = "Job RAM Auto-Clean ja esta em execucao."
            return $Result
        }
        
        Start-Job -Name "RamOpt" -ScriptBlock {
            # Recria a classe C# isolada dentro do contexto do Job
            $Kernel32 = @"
            using System;
            using System.Runtime.InteropServices;
            public class Win32 {
                [DllImport("psapi.dll")] public static extern int EmptyWorkingSet(IntPtr hwProc);
            }
"@
            try { Add-Type -TypeDefinition $Kernel32 -PassThru | Out-Null } catch {}
            
            while ($true) {
                $Processes = Get-Process
                foreach ($P in $Processes) {
                    if ($P.Handle) {
                        try { [void][Win32]::EmptyWorkingSet($P.Handle) } catch {}
                    }
                }
                Start-Sleep -Seconds 600
            }
        } | Out-Null
        
        $Result.Message = "Job de limpeza automatica do Working Set (RAM) iniciado em segundo plano."
    } catch {
        $Result.Status = "Error"
        $Result.Message = $_.Exception.Message
    }
    
    return $Result
}

# Adiciona exclusão de varredura do Windows Defender para a pasta do jogo
function Add-DefenderExclusion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )
    
    $Result = [PSCustomObject]@{
        Tweak   = "Defender Exclusion"
        Value   = $Path
        Status  = "Success"
        Message = ""
    }
    
    if (-not (Test-Path $Path)) {
        $Result.Status = "Error"
        $Result.Message = "O caminho especificado nao existe."
        return $Result
    }
    
    try {
        Add-MpPreference -ExclusionPath $Path -ErrorAction Stop
        $Result.Message = "Pasta excluida das varreduras do Windows Defender."
    } catch {
        $Result.Status = "Error"
        $Result.Message = $_.Exception.Message
    }
    return $Result
}

# Redefine o cache de Shaders do DirectX
function Reset-DirectXShader {
    [CmdletBinding()]
    param()

    $Result = [PSCustomObject]@{
        Tweak   = "DirectX Shader Cache Reset"
        Value   = "Cleanmgr"
        Status  = "Success"
        Message = ""
    }
    
    try {
        # Roda o limpador em background síncrono
        $Process = Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:64" -WindowStyle Hidden -PassThru -Wait -ErrorAction Stop
        $Result.Message = "Comando de limpeza do shader DirectX enviado com sucesso."
    } catch {
        $Result.Status = "Error"
        $Result.Message = $_.Exception.Message
    }
    return $Result
}
