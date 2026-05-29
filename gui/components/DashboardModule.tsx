'use client';

import { useEffect, useState } from "react";
import { invokePowerShell, SystemDiagnostics } from "../lib/api";
import { motion, AnimatePresence } from "framer-motion";
import { 
  Cpu, 
  HardDrive, 
  RefreshCw, 
  Activity, 
  AlertTriangle, 
  Activity as RamIcon, 
  Clock 
} from "lucide-react";

export default function DashboardModule() {
  const [diagnostics, setDiagnostics] = useState<SystemDiagnostics | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

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
    <div className="space-y-8">
      <div className="flex items-center justify-between">
        <h2 className="text-xl font-extrabold text-zinc-100 tracking-tight flex items-center gap-2">
          <Activity className="w-5 h-5 text-cyan-400" />
          Diagnostico de Hardware
        </h2>
        
        <button 
          onClick={loadDiagnostics}
          disabled={loading}
          className="p-2 rounded-xl border border-zinc-850 hover:border-zinc-700 bg-zinc-900/50 hover:bg-zinc-800/50 transition-all flex items-center justify-center text-zinc-400 hover:text-zinc-200 disabled:opacity-50 group"
        >
          <RefreshCw className={`w-4 h-4 ${loading ? 'animate-spin' : 'group-hover:rotate-180 transition-transform duration-500'}`} />
          <span className="text-xs ml-2 font-medium">Recarregar</span>
        </button>
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
  );
}
