# =================================================================
# SYSTEM OPTIMIZER - OPT-SYSTEM MODULE (OS TWEAKS & REPAIRS)
# =================================================================

# Repara o cache e serviços do Windows Update travados
function Repair-WindowsUpdate {
    [CmdletBinding()]
    param()

    $Result = [PSCustomObject]@{
        Action  = "Repair Windows Update"
        Status  = "Success"
        Message = ""
    }
    
    try {
        # Para serviços
        foreach ($Service in @("wuauserv", "bits")) {
            $SObj = Get-Service -Name $Service -ErrorAction SilentlyContinue
            if ($SObj -and $SObj.Status -eq "Running") {
                [void](Stop-Service -Name $Service -Force)
            }
        }
        
        # Remove a pasta de distribuição que contém atualizações corrompidas baixadas
        $Path = "$env:windir\SoftwareDistribution"
        if (Test-Path $Path) {
            Remove-Item -Path $Path -Recurse -Force -ErrorAction SilentlyContinue
        }
        
        # Restaura os serviços
        Start-Service -Name "wuauserv" -ErrorAction SilentlyContinue
        $Result.Message = "Servicos de atualizacao reiniciados e cache SoftwareDistribution limpo."
    } catch {
        $Result.Status = "Error"
        $Result.Message = $_.Exception.Message
    }
    return $Result
}

# Testa o ping entre Google e Cloudflare DNS e aplica o mais rápido à interface de rede ativa
function Set-DnsOptimization {
    [CmdletBinding()]
    param()

    $Result = [PSCustomObject]@{
        Action  = "Optimize DNS"
        Status  = "Success"
        Message = ""
        BestDNS = ""
    }
    
    try {
        $GoogleTime = 9999
        $CloudflareTime = 9999
        
        try {
            $G = Test-Connection -ComputerName 8.8.8.8 -Count 1 -ErrorAction Stop
            $GoogleTime = $G.ResponseTime
        } catch {}
        
        try {
            $C = Test-Connection -ComputerName 1.1.1.1 -Count 1 -ErrorAction Stop
            $CloudflareTime = $C.ResponseTime
        } catch {}
        
        $InterfaceIndex = (Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1).InterfaceIndex
        if (-not $InterfaceIndex) {
            $Result.Status = "Error"
            $Result.Message = "Nenhum adaptador de rede ativo encontrado."
            return $Result
        }
        
        if ($CloudflareTime -lt $GoogleTime -and $CloudflareTime -lt 9999) {
            Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses ("1.1.1.1", "1.0.0.1") -ErrorAction Stop
            $Result.BestDNS = "Cloudflare (1.1.1.1)"
            $Result.Message = "Cloudflare configurado como DNS preferencial (Ping: $($CloudflareTime)ms vs Google: $($GoogleTime)ms)."
        } else {
            Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses ("8.8.8.8", "8.8.4.4") -ErrorAction Stop
            $Result.BestDNS = "Google (8.8.8.8)"
            $Result.Message = "Google configurado como DNS preferencial (Ping: $($GoogleTime)ms vs Cloudflare: $($CloudflareTime)ms)."
        }
    } catch {
        $Result.Status = "Error"
        $Result.Message = $_.Exception.Message
    }
    return $Result
}

# Executa ferramenta SFC para varredura e correção de corrupções de arquivos do sistema
function Invoke-SystemSfcDism {
    [CmdletBinding()]
    param()

    $Result = [PSCustomObject]@{
        Action  = "System File Scan"
        Status  = "Success"
        Message = ""
    }
    try {
        $Process = Start-Process -FilePath "sfc.exe" -ArgumentList "/scannow" -NoNewWindow -Wait -PassThru -ErrorAction Stop
        if ($Process.ExitCode -eq 0) {
            $Result.Message = "SFC concluido com sucesso. Nenhum erro de integridade encontrado."
        } else {
            $Result.Status = "Warning"
            $Result.Message = "SFC terminou com codigo de erro $($Process.ExitCode)."
        }
    } catch {
        $Result.Status = "Error"
        $Result.Message = $_.Exception.Message
    }
    return $Result
}

# Remove tarefas agendadas órfãs que referenciam caminhos executáveis que não existem
function Remove-OrphanedTasks {
    [CmdletBinding()]
    param()

    $Result = [PSCustomObject]@{
        Action       = "Clean Orphaned Tasks"
        Status       = "Success"
        Message      = ""
        DeletedCount = 0
    }
    
    try {
        $Tasks = Get-ScheduledTask -ErrorAction Stop | Where-Object { $_.Actions.Execute -ne $null }
        $Deleted = 0
        foreach ($T in $Tasks) {
            $Path = $T.Actions.Execute.Replace('"', '')
            if ($Path -match "^[a-zA-Z]:\\") {
                if (-not (Test-Path $Path)) {
                    try {
                        [void](Unregister-ScheduledTask -TaskName $T.TaskName -Confirm:$false)
                        $Deleted++
                    } catch {}
                }
            }
        }
        $Result.DeletedCount = $Deleted
        $Result.Message = "Removidas $Deleted tarefas agendadas orfas cujo executavel nao existe."
    } catch {
        $Result.Status = "Error"
        $Result.Message = $_.Exception.Message
    }
    return $Result
}

# Remove bloatware embutido do Windows usando pacotes AppxPackage
function Remove-Bloatware {
    [CmdletBinding()]
    param()

    $Result = [PSCustomObject]@{
        Action       = "Remove Bloatware"
        Status       = "Success"
        Message      = ""
        RemovedApps  = @()
    }
    
    $TargetApps = @(
        "*Cortana*",
        "*XboxGameOverlay*",
        "*XboxGamingOverlay*",
        "*XboxSpeechToTextOverlay*",
        "*YourPhone*",
        "*BingWeather*",
        "*GetHelp*"
    )
    
    foreach ($AppName in $TargetApps) {
        try {
            $Package = Get-AppxPackage -Name $AppName -ErrorAction SilentlyContinue
            if ($Package) {
                Remove-AppxPackage -Package $Package.PackageFullName -ErrorAction Stop
                $Result.RemovedApps += $Package.Name
            }
        } catch {}
    }
    
    if ($Result.RemovedApps.Count -gt 0) {
        $Result.Message = "Removidos $($Result.RemovedApps.Count) pacotes AppX inuteis: $($Result.RemovedApps -join ', ')."
    } else {
        $Result.Message = "Nenhum aplicativo indesejado do Windows 10/11 foi encontrado para remocao."
    }
    return $Result
}

# Desativa serviços de telemetria e aplica chaves estáticas de privacidade nativas colhidas do WinUtil
function Disable-Telemetry {
    [CmdletBinding()]
    param()

    $Result = [PSCustomObject]@{
        Action  = "Disable Telemetry"
        Status  = "Success"
        Message = ""
    }
    
    try {
        # 1. Desativa serviços principais de rastreamento e telemetria
        $DiagTrack = Get-Service -Name "DiagTrack" -ErrorAction SilentlyContinue
        if ($DiagTrack) {
            [void](Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue)
            [void](Set-Service -Name "DiagTrack" -StartupType Disabled -ErrorAction SilentlyContinue)
        }
        
        $Dmwap = Get-Service -Name "dmwappushservice" -ErrorAction SilentlyContinue
        if ($Dmwap) {
            [void](Stop-Service -Name "dmwappushservice" -Force -ErrorAction SilentlyContinue)
            [void](Set-Service -Name "dmwappushservice" -StartupType Disabled -ErrorAction SilentlyContinue)
        }
        
        # 2. Injeta as chaves de Registro de privacidade extraídas das políticas do Chris Titus
        $RegistryTweaks = @(
            @{Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"; Name = "AllowTelemetry"; Value = 0; Type = "DWord"},
            @{Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"; Name = "MaxTelemetryAllowed"; Value = 0; Type = "DWord"},
            @{Path = "HKLM:\SOFTWARE\Microsoft\Windows\AppCompat"; Name = "AITEnable"; Value = 0; Type = "DWord"},
            @{Path = "HKLM:\SOFTWARE\Microsoft\Windows\AppCompat"; Name = "DisableInventory"; Value = 1; Type = "DWord"},
            @{Path = "HKLM:\SOFTWARE\Microsoft\Windows\AppCompat"; Name = "DisableUAR"; Value = 1; Type = "DWord"},
            @{Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"; Name = "AllowCortana"; Value = 0; Type = "DWord"},
            @{Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"; Name = "DisableWebSearch"; Value = 1; Type = "DWord"},
            @{Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"; Name = "ConnectedSearchUseWeb"; Value = 0; Type = "DWord"}
        )
        
        foreach ($Tweak in $RegistryTweaks) {
            try {
                if (-not (Test-Path $Tweak.Path)) {
                    [void](New-Item -Path $Tweak.Path -Force)
                }
                Set-ItemProperty -Path $Tweak.Path -Name $Tweak.Name -Value $Tweak.Value -Type $Tweak.Type -Force -ErrorAction Stop
            } catch {}
        }
        
        $Result.Message = "Telemetria desativada via Servicos e Politicas de Privacidade de Registro aplicadas."
    } catch {
        $Result.Status = "Error"
        $Result.Message = $_.Exception.Message
    }
    
    return $Result
}

# Registra as chaves de menu de contexto "Tomar Posse" para arquivos e diretórios
function Set-TakeOwnership {
    [CmdletBinding()]
    param()

    $Result = [PSCustomObject]@{
        Action  = "Add Take Ownership Context Menu"
        Status  = "Success"
        Message = ""
    }
    
    try {
        $RegFile = "HKCR\*\shell\runas"
        $RegDir = "HKCR\Directory\shell\runas"
        
        # Registro para Arquivos
        if (-not (Test-Path $RegFile)) { [void](New-Item -Path $RegFile -Force) }
        Set-ItemProperty -Path $RegFile -Name "(default)" -Value "Tomar Posse" -Force
        if (-not (Test-Path "$RegFile\command")) { [void](New-Item -Path "$RegFile\command" -Force) }
        Set-ItemProperty -Path "$RegFile\command" -Name "(default)" -Value "cmd.exe /c takeown /f `"%1`" && icacls `"%1`" /grant administrators:F" -Force
        
        # Registro para Diretórios
        if (-not (Test-Path $RegDir)) { [void](New-Item -Path $RegDir -Force) }
        Set-ItemProperty -Path $RegDir -Name "(default)" -Value "Tomar Posse" -Force
        if (-not (Test-Path "$RegDir\command")) { [void](New-Item -Path "$RegDir\command" -Force) }
        Set-ItemProperty -Path "$RegDir\command" -Name "(default)" -Value "cmd.exe /c takeown /f `"%1`" /r /d y && icacls `"%1`" /grant administrators:F /t" -Force
        
        $Result.Message = "Opcao 'Tomar Posse' integrada ao menu de contexto do Windows Explorer."
    } catch {
        $Result.Status = "Error"
        $Result.Message = $_.Exception.Message
    }
    return $Result
}

# Realiza backup de todos os drivers de terceiros instalados no sistema
function Backup-Drivers {
    [CmdletBinding()]
    param()

    $Result = [PSCustomObject]@{
        Action      = "Backup Drivers"
        Destination = "C:\Backup_Drivers"
        Status      = "Success"
        Message     = ""
    }
    
    try {
        if (-not (Test-Path $Result.Destination)) {
            [void](New-Item -ItemType Directory -Force -Path $Result.Destination)
        }
        
        Export-WindowsDriver -Online -Destination $Result.Destination -ErrorAction Stop | Out-Null
        $Result.Message = "Backup de todos os drivers de terceiros concluido em $($Result.Destination)."
    } catch {
        $Result.Status = "Error"
        $Result.Message = $_.Exception.Message
    }
    return $Result
}
