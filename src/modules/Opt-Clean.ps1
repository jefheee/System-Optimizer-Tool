# =================================================================
# SYSTEM OPTIMIZER - OPT-CLEAN MODULE (CLEANUP & CACHE DEBLOAT)
# =================================================================

# Calcula recursivamente o tamanho dos arquivos em um diretório
function Get-DiskSizeMB {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )
    if (-not (Test-Path $Path)) {
        return 0
    }
    
    try {
        $Items = Get-ChildItem -Path $Path -Recurse -File -ErrorAction Stop
        if ($Items) {
            $Sum = ($Items | Measure-Object -Property Length -Sum).Sum
            if ($Sum) {
                return [math]::Round($Sum / 1MB, 2)
            }
        }
    } catch {
        # Erro esperado ao tentar ler arquivos bloqueados/sistema
    }
    return 0
}

# Limpeza profunda otimizada para SSD (com TRIM)
function Invoke-Optimization {
    [CmdletBinding()]
    param()

    $Results = [System.Collections.Generic.List[PSCustomObject]]::new()
    $TotalFreedMB = 0

    # Diretórios a serem limpos
    $Steps = @(
        @{Name = "Temp User"; Path = "$env:TEMP\*"},
        @{Name = "Temp Windows"; Path = "$env:WINDIR\Temp\*"},
        @{Name = "Prefetch"; Path = "$env:WINDIR\Prefetch\*"},
        @{Name = "Update Cache"; Path = "$env:WINDIR\SoftwareDistribution\Download\*"},
        @{Name = "Logs"; Path = "$env:WINDIR\Logs\*"}
    )
    
    # 1. Parar serviços que travam arquivos de atualizações
    $StoppedServices = @()
    foreach ($Service in @("wuauserv", "bits")) {
        $SObj = Get-Service -Name $Service -ErrorAction SilentlyContinue
        if ($SObj -and $SObj.Status -eq "Running") {
            try {
                Stop-Service -Name $Service -Force -ErrorAction Stop
                $StoppedServices += $Service
            } catch {}
        }
    }

    # 2. Executar a limpeza de cada pasta
    foreach ($Step in $Steps) {
        $StepResult = [PSCustomObject]@{
            Step        = "Clean Folder"
            Target      = $Step.Name
            BytesFreed  = 0
            Status      = "Success"
            Message     = ""
        }
        
        try {
            $Size = Get-DiskSizeMB -Path $Step.Path
            $StepResult.BytesFreed = $Size
            
            if (Test-Path $Step.Path) {
                Get-ChildItem -Path $Step.Path -Recurse -Force -ErrorAction SilentlyContinue | 
                    Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
            }
            $TotalFreedMB += $Size
        } catch {
            $StepResult.Status = "Warning"
            $StepResult.Message = $_.Exception.Message
        }
        $Results.Add($StepResult)
    }

    # 3. Limpar Lixeira
    $RecycleResult = [PSCustomObject]@{
        Step        = "Clear Recycle Bin"
        Target      = "Recycle Bin"
        BytesFreed  = 0
        Status      = "Success"
        Message     = ""
    }
    try {
        [void](Clear-RecycleBin -Force -ErrorAction Stop)
    } catch {
        $RecycleResult.Status = "Warning"
        $RecycleResult.Message = $_.Exception.Message
    }
    $Results.Add($RecycleResult)

    # 4. Navegadores (Caches)
    $Browsers = @(
        @{Name = "Chrome Cache"; Path = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*"},
        @{Name = "Edge Cache"; Path = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*"}
    )
    foreach ($B in $Browsers) {
        $BResult = [PSCustomObject]@{
            Step        = "Clean Browser Cache"
            Target      = $B.Name
            BytesFreed  = 0
            Status      = "Success"
            Message     = ""
        }
        try {
            if (Test-Path $B.Path) {
                $Size = Get-DiskSizeMB -Path $B.Path
                $BResult.BytesFreed = $Size
                Remove-Item -Path $B.Path -Recurse -Force -ErrorAction SilentlyContinue
                $TotalFreedMB += $Size
            } else {
                $BResult.Status = "Skipped"
                $BResult.Message = "Diretorio de cache do navegador nao encontrado."
            }
        } catch {
            $BResult.Status = "Warning"
            $BResult.Message = $_.Exception.Message
        }
        $Results.Add($BResult)
    }

    # 5. Logs do Visualizador de Eventos (Event Logs)
    $EventLogResult = [PSCustomObject]@{
        Step        = "Clear Event Logs"
        Target      = "wevtutil"
        BytesFreed  = 0
        Status      = "Success"
        Message     = ""
    }
    try {
        $Logs = wevtutil.exe el
        foreach ($Log in $Logs) {
            try {
                [void](wevtutil.exe cl "$Log" 2>$null)
            } catch {}
        }
    } catch {
        $EventLogResult.Status = "Warning"
        $EventLogResult.Message = $_.Exception.Message
    }
    $Results.Add($EventLogResult)

    # 6. Otimizações de Rede e Memória do Kernel
    $KernelResult = [PSCustomObject]@{
        Step        = "Kernel Tweaks"
        Target      = "Network/Memory"
        BytesFreed  = 0
        Status      = "Success"
        Message     = ""
    }
    try {
        [void](netsh.exe int tcp set global rss=enabled)
        [void](fsutil.exe behavior set memoryusage 2)
    } catch {
        $KernelResult.Status = "Warning"
        $KernelResult.Message = $_.Exception.Message
    }
    $Results.Add($KernelResult)

    # 7. Reduzir Working Set dos Processos (Limpeza RAM)
    $RamResult = [PSCustomObject]@{
        Step        = "RAM Working Set Flush"
        Target      = "Processes"
        BytesFreed  = 0
        Status      = "Success"
        Message     = ""
    }
    try {
        $Processes = Get-Process
        foreach ($P in $Processes) {
            if ($P.Handle -and -not $P.HasExited) {
                try {
                    [void][Win32]::EmptyWorkingSet($P.Handle)
                } catch {}
            }
        }
    } catch {
        $RamResult.Status = "Warning"
        $RamResult.Message = $_.Exception.Message
    }
    $Results.Add($RamResult)

    # 8. Limpar DNS Cache (FlushDNS)
    $DnsResult = [PSCustomObject]@{
        Step        = "Flush DNS"
        Target      = "ipconfig"
        BytesFreed  = 0
        Status      = "Success"
        Message     = ""
    }
    try {
        [void](ipconfig.exe /flushdns)
    } catch {
        $DnsResult.Status = "Warning"
        $DnsResult.Message = $_.Exception.Message
    }
    $Results.Add($DnsResult)

    # 9. Restaurar Serviços que foram parados temporariamente
    foreach ($Service in $StoppedServices) {
        try {
            Start-Service -Name $Service -ErrorAction SilentlyContinue
        } catch {}
    }

    # 10. Otimização de Volume (TRIM) para C: (SSD)
    $TrimResult = [PSCustomObject]@{
        Step        = "Optimize Volume (TRIM)"
        Target      = "Drive C:"
        BytesFreed  = 0
        Status      = "Success"
        Message     = ""
    }
    try {
        [void](Optimize-Volume -DriveLetter C -ReTrim -ErrorAction Stop)
    } catch {
        $TrimResult.Status = "Warning"
        $TrimResult.Message = $_.Exception.Message
    }
    $Results.Add($TrimResult)

    # Adiciona o objeto final com o sumário
    $SummaryResult = [PSCustomObject]@{
        Step        = "Summary"
        Target      = "Total Freed"
        BytesFreed  = $TotalFreedMB
        Status      = "Success"
        Message     = "Otimizacao profunda e limpeza de arquivos concluidas."
    }
    $Results.Add($SummaryResult)

    return $Results
}

# Limpeza leve otimizada para HDD (sem TRIM)
function Invoke-LiteOptimization {
    [CmdletBinding()]
    param()

    $Results = [System.Collections.Generic.List[PSCustomObject]]::new()
    $TotalFreedMB = 0

    $Steps = @(
        @{Name = "Temp User"; Path = "$env:TEMP\*"},
        @{Name = "Temp Windows"; Path = "$env:WINDIR\Temp\*"},
        @{Name = "Logs"; Path = "$env:WINDIR\Logs\*"}
    )

    foreach ($Step in $Steps) {
        $StepResult = [PSCustomObject]@{
            Step        = "Clean Folder (Lite)"
            Target      = $Step.Name
            BytesFreed  = 0
            Status      = "Success"
            Message     = ""
        }
        try {
            $Size = Get-DiskSizeMB -Path $Step.Path
            $StepResult.BytesFreed = $Size
            if (Test-Path $Step.Path) {
                Get-ChildItem -Path $Step.Path -Recurse -Force -ErrorAction SilentlyContinue | 
                    Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
            }
            $TotalFreedMB += $Size
        } catch {
            $StepResult.Status = "Warning"
            $StepResult.Message = $_.Exception.Message
        }
        $Results.Add($StepResult)
    }

    $RecycleResult = [PSCustomObject]@{
        Step        = "Clear Recycle Bin (Lite)"
        Target      = "Recycle Bin"
        BytesFreed  = 0
        Status      = "Success"
        Message     = ""
    }
    try {
        [void](Clear-RecycleBin -Force -ErrorAction Stop)
    } catch {
        $RecycleResult.Status = "Warning"
        $RecycleResult.Message = $_.Exception.Message
    }
    $Results.Add($RecycleResult)

    $SummaryResult = [PSCustomObject]@{
        Step        = "Summary"
        Target      = "Total Freed"
        BytesFreed  = $TotalFreedMB
        Status      = "Success"
        Message     = "Otimizacao Lite concluida."
    }
    $Results.Add($SummaryResult)

    return $Results
}
