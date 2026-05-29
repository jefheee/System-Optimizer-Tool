# =================================================================
# SYSTEM OPTIMIZER - OPT-DIAGNOSTICS MODULE (HARDWARE SURVEY API)
# =================================================================

# Coleta dados de hardware do sistema usando consultas CIM otimizadas
function Get-SystemDiagnostics {
    [CmdletBinding()]
    param()

    # Prepara o objeto principal de retorno (Backend API Pattern)
    $DiagnosticData = [PSCustomObject]@{
        Status             = "Success"
        Timestamp          = (Get-Date).ToString("yyyy-MM-ddTHH:mm:sszzz")
        OperatingSystem    = $null
        Cpu                = $null
        Gpu                = $null
        Memory             = $null
        Storage            = @()
        Message            = "Diagnostico do sistema executado com sucesso."
    }

    try {
        # 1. Informações de Sistema Operacional (CIM Otimizado)
        # Limitamos a busca usando o parametro -Property para acelerar o retorno do CIM
        $OSInfo = Get-CimInstance -ClassName Win32_OperatingSystem -Property Caption, BuildNumber, LastBootUpTime -ErrorAction Stop
        
        $UptimeSpan = (Get-Date) - $OSInfo.LastBootUpTime
        
        $DiagnosticData.OperatingSystem = [PSCustomObject]@{
            Caption        = $OSInfo.Caption
            BuildNumber    = $OSInfo.BuildNumber
            LastBootUpTime = $OSInfo.LastBootUpTime
            Uptime         = @{
                Days    = $UptimeSpan.Days
                Hours   = $UptimeSpan.Hours
                Minutes = $UptimeSpan.Minutes
            }
        }
    } catch {
        $DiagnosticData.Status = "Warning"
        $DiagnosticData.Message = "Erro ao ler dados do SO: $($_.Exception.Message)"
    }

    try {
        # 2. Informações do Processador (CIM Otimizado)
        $CpuInfo = Get-CimInstance -ClassName Win32_Processor -Property Name -ErrorAction Stop
        $DiagnosticData.Cpu = [PSCustomObject]@{
            Name = $CpuInfo.Name.Trim()
        }
    } catch {
        $DiagnosticData.Status = "Warning"
        $DiagnosticData.Cpu = [PSCustomObject]@{ Name = "Desconhecido" }
    }

    try {
        # 3. Informações da Placa de Vídeo (CIM Otimizado)
        $GpuInfo = Get-CimInstance -ClassName Win32_VideoController -Property Name -ErrorAction Stop | Select-Object -First 1
        $DiagnosticData.Gpu = [PSCustomObject]@{
            Name = if ($GpuInfo) { $GpuInfo.Name.Trim() } else { "Desconhecido" }
        }
    } catch {
        $DiagnosticData.Status = "Warning"
        $DiagnosticData.Gpu = [PSCustomObject]@{ Name = "Desconhecido" }
    }

    try {
        # 4. Informações de Memória RAM (CIM Otimizado)
        $MemInfos = Get-CimInstance -ClassName Win32_PhysicalMemory -Property Capacity, Speed -ErrorAction Stop
        
        $RamTotalGB = 0
        $Modules = [System.Collections.Generic.List[PSCustomObject]]::new()
        
        foreach ($M in $MemInfos) {
            $SizeGB = [math]::Round($M.Capacity / 1GB, 0)
            $RamTotalGB += $SizeGB
            $Modules.Add([PSCustomObject]@{
                CapacityGB = $SizeGB
                SpeedMHz   = $M.Speed
            })
        }
        
        $DiagnosticData.Memory = [PSCustomObject]@{
            TotalGB      = $RamTotalGB
            ModuleCount  = $MemInfos.Count
            Modules      = $Modules
        }
    } catch {
        $DiagnosticData.Status = "Warning"
        $DiagnosticData.Memory = [PSCustomObject]@{
            TotalGB     = 0
            ModuleCount = 0
            Modules     = @()
        }
    }

    try {
        # 5. Informações sobre Discos Físicos (Get-PhysicalDisk otimizado)
        $Disks = Get-PhysicalDisk -ErrorAction Stop | Sort-Object MediaType, Size -Descending
        
        foreach ($D in $Disks) {
            $SizeGB = [Math]::Round($D.Size / 1GB, 0)
            $Type = if ($D.MediaType -eq "Unspecified") { "SSD" } else { $D.MediaType.ToString() }
            
            $DiagnosticData.Storage += [PSCustomObject]@{
                Model        = $D.Model.Trim()
                SizeGB       = $SizeGB
                MediaType    = $Type
                HealthStatus = $D.HealthStatus.ToString()
            }
        }
    } catch {
        $DiagnosticData.Status = "Warning"
        $DiagnosticData.Message += " | Erro ao obter dados de armazenamento: $($_.Exception.Message)"
    }

    return $DiagnosticData
}
