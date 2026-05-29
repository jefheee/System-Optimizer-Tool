# =================================================================
# SYSTEM OPTIMIZER - WIN32 HELPER MODULE (C# P/INVOKE INITIALIZER)
# =================================================================

$Kernel32 = @"
using System;
using System.Runtime.InteropServices;

public class Win32 {
    [DllImport("ntdll.dll")] 
    public static extern int NtSetTimerResolution(uint DesiredResolution, bool SetResolution, ref uint CurrentResolution);
    
    [DllImport("psapi.dll")] 
    public static extern int EmptyWorkingSet(IntPtr hwProc);
}
"@

try {
    # Verifica se a classe Win32 já existe na sessão PowerShell atual antes de injetar
    if (-not ([System.Type]::GetType("Win32"))) {
        Add-Type -TypeDefinition $Kernel32 -PassThru | Out-Null
    }
} catch {
    # Fallback seguro de detecção em múltiplos escopos de execução
    try {
        $null = [Win32]
    } catch {
        Add-Type -TypeDefinition $Kernel32 -PassThru | Out-Null
    }
}
