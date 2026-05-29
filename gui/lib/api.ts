// =================================================================
// SYSTEM OPTIMIZER - FRONTEND API (TAURI BRIDGE / TS TYPES)
// =================================================================

// Interfaces TypeScript tipadas estritamente correspondentes ao Get-SystemDiagnostics do PowerShell
export interface UptimeInfo {
  Days: number;
  Hours: number;
  Minutes: number;
}

export interface OperatingSystemInfo {
  Caption: string;
  BuildNumber: string;
  LastBootUpTime: string;
  Uptime: UptimeInfo;
}

export interface CpuInfo {
  Name: string;
}

export interface GpuInfo {
  Name: string;
}

export interface RamModule {
  CapacityGB: number;
  SpeedMHz: number;
}

export interface MemoryInfo {
  TotalGB: number;
  ModuleCount: number;
  Modules: RamModule[];
}

export interface StorageDisk {
  Model: string;
  SizeGB: number;
  MediaType: string;
  HealthStatus: string;
}

export interface SystemDiagnostics {
  Status: "Success" | "Warning" | "Error";
  Timestamp: string;
  OperatingSystem: OperatingSystemInfo | null;
  Cpu: CpuInfo | null;
  Gpu: GpuInfo | null;
  Memory: MemoryInfo | null;
  Storage: StorageDisk[];
  Message: string;
}

// Resposta genérica para ações do otimizador
export interface ActionResponse {
  Status: "Success" | "Warning" | "Error";
  Message: string;
  BytesFreed?: number;
  Tweak?: string;
  Value?: string;
  Step?: string;
  Target?: string;
}

/**
 * Invoca de forma segura a ponte Rust do Tauri para rodar comandos PowerShell
 * Trata automaticamente a barreira de SSR (Server-Side Rendering) do Next.js
 */
export async function invokePowerShell<T>(action: string, args: string = ""): Promise<T> {
  if (typeof window === "undefined") {
    throw new Error("O comando do Tauri nao pode ser invocado no Server-Side.");
  }

  try {
    // Importa dinamicamente a API do Tauri para evitar quebra no build Next.js
    const { invoke } = await import("@tauri-apps/api/core");
    
    // Executa a chamada do Tauri. A ponte Rust retorna uma string JSON.
    const rawResult: string = await invoke("invoke_powershell", { action, args });
    
    // Parseia a string JSON retornada do powershell
    const parsedData: T = JSON.parse(rawResult);
    return parsedData;
  } catch (error: any) {
    console.error("Erro ao invocar comando do Tauri:", error);
    
    // Se o erro for uma string JSON (erros disparados de forma controlada no Rust), faz o parse
    try {
      if (typeof error === "string") {
        return JSON.parse(error) as T;
      }
    } catch {}

    throw error;
  }
}
