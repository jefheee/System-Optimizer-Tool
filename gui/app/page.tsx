'use client';

import { useEffect, useState } from "react";
import { invokePowerShell, SystemDiagnostics, ActionResponse } from "../lib/api";
import { motion, AnimatePresence } from "framer-motion";
import { 
  Cpu, 
  HardDrive, 
  RefreshCw, 
  Activity, 
  CheckCircle, 
  AlertTriangle, 
  Zap, 
  Activity as RamIcon, 
  Info, 
  Clock 
} from "lucide-react";

export default function Dashboard() {
  const [diagnostics, setDiagnostics] = useState<SystemDiagnostics | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);
  
  const [optimizing, setOptimizing] = useState<boolean>(false);
  const [optResult, setOptResult] = useState<ActionResponse | null>(null);

  // Carrega diagnóstico inicial
  const loadDiagnostics = async () => {
    setLoading(true);
    setError(null);
    try {
      const data = await invokePowerShell<SystemDiagnostics>("Diagnostics");
      if (data.Status === "Error") {
        setError(data.Message);
      } else {
        setDiagnostics(data);
      }
    } catch (err: any) {
      setError(
        typeof err === "string" 
          ? err 
          : err?.message || "Falha de comunicação com o backend em Rust/PowerShell."
      );
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadDiagnostics();
  }, []);

  // Executa Otimização Profunda (SSD)
  const handleOptimizeDeep = async () => {
    setOptimizing(true);
    setOptResult(null);
    try {
      const results = await invokePowerShell<ActionResponse[]>("OptimizeDeep");
      // Busca o objeto de resumo no array retornado
      const summary = results.find(r => r.Step === "Summary");
      if (summary) {
        setOptResult(summary);
        // Recarrega diagnósticos para refletir mudanças (ex: flush de RAM)
        await loadDiagnostics();
      } else {
        setOptResult({ Status: "Success", Message: "Otimizacao concluida com sucesso." });
      }
    } catch (err: any) {
      setOptResult({ 
        Status: "Error", 
        Message: err?.message || "Erro inesperado ao rodar otimizacao profunda." 
      });
    } finally {
      setOptimizing(false);
    }
  };

  // Card do Processador (CPU)
  const cpuCard = diagnostics?.Cpu && (
    <motion.div 
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4, delay: 0.1 }}
      className="p-6 rounded-2xl bg-zinc-900/60 border border-zinc-800/80 backdrop-blur-xl shadow-xl flex items-start gap-4 hover:border-cyan-500/30 transition-all duration-300 group"
    >
      <div className="p-3 bg-cyan-500/10 rounded-xl text-cyan-400 group-hover:bg-cyan-500/20 transition-colors">
        <Cpu className="w-6 h-6" />
      </div>
      <div>
        <p className="text-xs font-semibold text-zinc-500 tracking-wider uppercase">Processador (CPU)</p>
        <h3 className="text-lg font-bold text-zinc-200 mt-1 leading-snug">{diagnostics.Cpu.Name}</h3>
      </div>
    </motion.div>
  );

  // Card de GPU
  const gpuCard = diagnostics?.Gpu && (
    <motion.div 
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4, delay: 0.2 }}
      className="p-6 rounded-2xl bg-zinc-900/60 border border-zinc-800/80 backdrop-blur-xl shadow-xl flex items-start gap-4 hover:border-purple-500/30 transition-all duration-300 group"
    >
      <div className="p-3 bg-purple-500/10 rounded-xl text-purple-400 group-hover:bg-purple-500/20 transition-colors">
        <Activity className="w-6 h-6" />
      </div>
      <div>
        <p className="text-xs font-semibold text-zinc-500 tracking-wider uppercase">Placa de Video (GPU)</p>
        <h3 className="text-lg font-bold text-zinc-200 mt-1 leading-snug">{diagnostics.Gpu.Name}</h3>
      </div>
    </motion.div>
  );

  // Card de RAM
  const ramCard = diagnostics?.Memory && (
    <motion.div 
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4, delay: 0.3 }}
      className="p-6 rounded-2xl bg-zinc-900/60 border border-zinc-800/80 backdrop-blur-xl shadow-xl flex items-start gap-4 hover:border-emerald-500/30 transition-all duration-300 group"
    >
      <div className="p-3 bg-emerald-500/10 rounded-xl text-emerald-400 group-hover:bg-emerald-500/20 transition-colors">
        <RamIcon className="w-6 h-6" />
      </div>
      <div className="w-full">
        <p className="text-xs font-semibold text-zinc-500 tracking-wider uppercase">Memoria RAM</p>
        <h3 className="text-lg font-bold text-zinc-200 mt-1">{diagnostics.Memory.TotalGB} GB Instalados</h3>
        <div className="mt-2 flex gap-2 flex-wrap">
          {diagnostics.Memory.Modules.map((mod, i) => (
            <span key={i} className="text-[10px] font-medium bg-zinc-800/90 border border-zinc-700/60 text-zinc-400 px-2 py-0.5 rounded-full">
              Slot {i + 1}: {mod.CapacityGB}GB {mod.SpeedMHz}MHz
            </span>
          ))}
        </div>
      </div>
    </motion.div>
  );

  // Card de Uptime
  const uptimeCard = diagnostics?.OperatingSystem && (
    <motion.div 
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4, delay: 0.4 }}
      className="p-6 rounded-2xl bg-zinc-900/60 border border-zinc-800/80 backdrop-blur-xl shadow-xl flex items-start gap-4 hover:border-amber-500/30 transition-all duration-300 group"
    >
      <div className="p-3 bg-amber-500/10 rounded-xl text-amber-400 group-hover:bg-amber-500/20 transition-colors">
        <Clock className="w-6 h-6" />
      </div>
      <div>
        <p className="text-xs font-semibold text-zinc-500 tracking-wider uppercase">Tempo de Atividade (Uptime)</p>
        <h3 className="text-lg font-bold text-zinc-200 mt-1">
          {diagnostics.OperatingSystem.Uptime.Days}d {diagnostics.OperatingSystem.Uptime.Hours}h {diagnostics.OperatingSystem.Uptime.Minutes}m
        </h3>
        <p className="text-xs text-zinc-500 mt-1 leading-snug">
          SO: {diagnostics.OperatingSystem.Caption}
        </p>
      </div>
    </motion.div>
  );

  return (
    <main className="min-h-screen bg-black text-zinc-300 font-sans selection:bg-cyan-500/30 selection:text-cyan-200">
      
      {/* Luzes decorativas de fundo (Aesthetics Glow) */}
      <div className="absolute top-0 left-1/4 w-[500px] h-[500px] bg-cyan-500/5 rounded-full blur-[120px] pointer-events-none -z-10" />
      <div className="absolute bottom-0 right-1/4 w-[500px] h-[500px] bg-purple-500/5 rounded-full blur-[120px] pointer-events-none -z-10" />

      {/* Header Container */}
      <header className="border-b border-zinc-900/80 backdrop-blur-md bg-black/60 sticky top-0 z-50">
        <div className="max-w-6xl mx-auto px-6 py-4 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-cyan-500 to-purple-600 flex items-center justify-center text-white font-extrabold text-lg shadow-lg shadow-cyan-500/20">
              S
            </div>
            <div>
              <h1 className="font-extrabold text-zinc-100 text-lg tracking-tight">System Optimizer</h1>
              <p className="text-[10px] font-semibold text-zinc-500 tracking-wider uppercase">Web Controller Bridge</p>
            </div>
          </div>
          
          <button 
            onClick={loadDiagnostics}
            disabled={loading}
            className="p-2.5 rounded-xl border border-zinc-800 hover:border-zinc-700 bg-zinc-900/40 hover:bg-zinc-800/40 transition-all flex items-center justify-center text-zinc-400 hover:text-zinc-200 disabled:opacity-50 group"
          >
            <RefreshCw className={`w-5 h-5 ${loading ? 'animate-spin' : 'group-hover:rotate-180 transition-transform duration-500'}`} />
          </button>
        </div>
      </header>

      {/* Main Body */}
      <div className="max-w-6xl mx-auto px-6 py-10 grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        {/* Lado Esquerdo: Cards de Status de Hardware (2 colunas em telas grandes) */}
        <div className="lg:col-span-2 space-y-8">
          
          <div className="flex items-center justify-between">
            <h2 className="text-xl font-extrabold text-zinc-100 tracking-tight flex items-center gap-2">
              <Activity className="w-5 h-5 text-cyan-400" />
              Diagnostico de Hardware
            </h2>
            <span className="text-xs bg-zinc-900 border border-zinc-800 text-zinc-400 px-3 py-1 rounded-full flex items-center gap-1.5">
              <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse" />
              API Connect
            </span>
          </div>

          <AnimatePresence mode="wait">
            {loading && !diagnostics ? (
              <motion.div 
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                className="py-20 flex flex-col items-center justify-center gap-4 bg-zinc-900/20 rounded-2xl border border-zinc-900"
              >
                <RefreshCw className="w-8 h-8 text-cyan-500 animate-spin" />
                <p className="text-sm font-medium text-zinc-500">Buscando dados de diagnostico via PowerShell...</p>
              </motion.div>
            ) : error ? (
              <motion.div 
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                className="p-6 rounded-2xl bg-red-950/20 border border-red-900/60 backdrop-blur-md flex gap-4 text-red-400"
              >
                <AlertTriangle className="w-6 h-6 shrink-0" />
                <div>
                  <h4 className="font-bold text-zinc-100">Erro de Execucao</h4>
                  <p className="text-sm mt-1 leading-snug">{error}</p>
                </div>
              </motion.div>
            ) : (
              <motion.div 
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                className="grid grid-cols-1 md:grid-cols-2 gap-6"
              >
                {cpuCard}
                {gpuCard}
                {ramCard}
                {uptimeCard}
              </motion.div>
            )}
          </AnimatePresence>

          {/* Cards de Discos */}
          {diagnostics && diagnostics.Storage.length > 0 && (
            <div className="space-y-4">
              <h3 className="text-sm font-extrabold text-zinc-400 tracking-wider uppercase">Unidades de Armazenamento</h3>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {diagnostics.Storage.map((disk, idx) => (
                  <motion.div 
                    key={idx}
                    initial={{ opacity: 0, y: 15 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.3, delay: idx * 0.05 }}
                    className="p-5 rounded-2xl bg-zinc-900/40 border border-zinc-800/60 backdrop-blur-xl flex items-center justify-between"
                  >
                    <div className="flex items-center gap-3">
                      <div className="p-2.5 bg-zinc-800 rounded-xl text-zinc-400">
                        <HardDrive className="w-5 h-5" />
                      </div>
                      <div>
                        <h4 className="font-bold text-sm text-zinc-200 leading-snug">{disk.Model}</h4>
                        <p className="text-xs text-zinc-500 mt-0.5">{disk.MediaType} &bull; {disk.SizeGB} GB</p>
                      </div>
                    </div>
                    <span className={`text-[10px] font-bold px-2 py-0.5 rounded-md border ${
                      disk.HealthStatus === 'Healthy' 
                        ? 'bg-emerald-500/10 border-emerald-500/30 text-emerald-400' 
                        : 'bg-red-500/10 border-red-500/30 text-red-400'
                    }`}>
                      {disk.HealthStatus}
                    </span>
                  </motion.div>
                ))}
              </div>
            </div>
          )}

        </div>

        {/* Lado Direito: Caixa de Controle de Ações */}
        <div className="space-y-8">
          <h2 className="text-xl font-extrabold text-zinc-100 tracking-tight flex items-center gap-2">
            <Zap className="w-5 h-5 text-amber-400" />
            Central de Limpeza
          </h2>

          <div className="p-6 rounded-2xl bg-zinc-900/50 border border-zinc-800/80 backdrop-blur-xl shadow-2xl space-y-6">
            <div>
              <h3 className="font-bold text-zinc-200">Otimizar Sistema</h3>
              <p className="text-xs text-zinc-500 mt-1 leading-snug">
                Remove caches do Windows, arquivos de log acumulados, limpa a lixeira e otimiza a memoria RAM ativa.
              </p>
            </div>

            <button 
              onClick={handleOptimizeDeep}
              disabled={optimizing || loading}
              className="w-full py-3.5 rounded-xl bg-gradient-to-r from-cyan-500 to-purple-600 hover:from-cyan-600 hover:to-purple-700 text-white font-bold text-sm shadow-lg shadow-cyan-500/15 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-300 hover:-translate-y-0.5"
            >
              {optimizing ? (
                <span className="flex items-center justify-center gap-2">
                  <RefreshCw className="w-4 h-4 animate-spin" />
                  Otimizando Sistema...
                </span>
              ) : (
                "Executar Otimizacao Profunda (SSD)"
              )}
            </button>

            {/* Resultado da Otimização */}
            <AnimatePresence>
              {optResult && (
                <motion.div 
                  initial={{ opacity: 0, scale: 0.95 }}
                  animate={{ opacity: 1, scale: 1 }}
                  exit={{ opacity: 0, scale: 0.95 }}
                  className={`p-4 rounded-xl border flex gap-3 text-xs leading-snug ${
                    optResult.Status === "Success"
                      ? "bg-emerald-500/10 border-emerald-500/20 text-emerald-400"
                      : "bg-red-500/10 border-red-500/20 text-red-400"
                  }`}
                >
                  {optResult.Status === "Success" ? (
                    <CheckCircle className="w-5 h-5 shrink-0" />
                  ) : (
                    <AlertTriangle className="w-5 h-5 shrink-0" />
                  )}
                  <div>
                    <h5 className="font-bold text-zinc-200">
                      {optResult.Status === "Success" ? "Sucesso!" : "Falha na Acao"}
                    </h5>
                    <p className="text-zinc-400 mt-1">{optResult.Message}</p>
                    {optResult.BytesFreed !== undefined && optResult.BytesFreed > 0 && (
                      <p className="font-semibold text-emerald-400 mt-1">
                        Espaco liberado: {optResult.BytesFreed} MB
                      </p>
                    )}
                  </div>
                </motion.div>
              )}
            </AnimatePresence>

            <div className="pt-4 border-t border-zinc-800/80 space-y-4">
              <div className="flex items-start gap-2.5 text-xs text-zinc-500">
                <Info className="w-4 h-4 text-zinc-600 shrink-0 mt-0.5" />
                <p className="leading-snug">
                  Esta ponte consome diretamente os cmdlets nativos do Windows. Certifique-se de executar o Tauri com privilégios de administrador para que a limpeza ocorra sem restrições.
                </p>
              </div>
            </div>

          </div>
        </div>

      </div>
    </main>
  );
}
