'use client';

import { useState } from "react";
import { invokePowerShell, ActionResponse } from "../lib/api";
import { motion, AnimatePresence } from "framer-motion";
import { 
  Gamepad2, 
  Cpu, 
  MousePointer, 
  Keyboard, 
  Activity, 
  Wifi, 
  ShieldAlert, 
  Zap, 
  Loader2, 
  CheckCircle2, 
  XCircle,
  AlertCircle
} from "lucide-react";

export default function GamerModule() {
  const [activeActions, setActiveActions] = useState<Record<string, boolean>>({});
  const [results, setResults] = useState<Record<string, ActionResponse>>({});
  
  // Inputs states
  const [processName, setProcessName] = useState("");
  const [exclusionPath, setExclusionPath] = useState("");

  // Toggles states
  const [latencyEnabled, setLatencyEnabled] = useState(false);
  const [ramCleanEnabled, setRamCleanEnabled] = useState(false);

  const runAction = async (actionId: string, actionName: string, args: string = "") => {
    setActiveActions(prev => ({ ...prev, [actionId]: true }));
    try {
      const res = await invokePowerShell<ActionResponse>(actionName, args);
      setResults(prev => ({ ...prev, [actionId]: res }));
      
      // Update local states based on success
      if (res.Status === "Success") {
        if (actionName === "SetLatency") {
          setLatencyEnabled(args === "true");
        } else if (actionName === "SetRamClean") {
          setRamCleanEnabled(true);
        }
      }
    } catch (err: any) {
      setResults(prev => ({ 
        ...prev, 
        [actionId]: { Status: "Error", Message: err?.message || "Erro de comunicação." } 
      }));
    } finally {
      setActiveActions(prev => ({ ...prev, [actionId]: false }));
    }
  };

  return (
    <div className="space-y-8 animate-card-entry">
      <div>
        <h2 className="text-xl font-bold font-headline-lg text-zinc-100 tracking-tight flex items-center gap-2">
          <Gamepad2 className="w-5 h-5 text-tertiary" />
          Otimizações Gamer & Latência
        </h2>
        <p className="text-xs text-on-surface-variant mt-1">
          Ajuste as configurações do sistema para obter a menor latência de entrada e melhor desempenho nos seus jogos.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        
        {/* Temporizador de Latência (SetLatency) */}
        <div className="p-6 rounded-xl glass-card flex flex-col justify-between hover:border-primary/20 transition-all duration-300">
          <div className="flex items-start gap-4">
            <div className="p-3 bg-primary/10 rounded-lg text-primary">
              <Activity className="w-5 h-5" />
            </div>
            <div>
              <h4 className="font-bold text-zinc-200 text-sm">Resolução do Timer do Kernel</h4>
              <p className="text-xs text-on-surface-variant mt-1 leading-relaxed">
                Força a resolução do timer de sistema do Windows para 0.5ms, reduzindo o jitter e a latência de input global.
              </p>
            </div>
          </div>
          <div className="mt-6 flex items-center justify-between border-t border-white/5 pt-4">
            <span className="text-xs font-semibold text-on-surface-variant">Status: {latencyEnabled ? '0.5ms (Otimizado)' : 'Padrão (15.6ms)'}</span>
            <button
              onClick={() => runAction("latency", "SetLatency", latencyEnabled ? "false" : "true")}
              disabled={activeActions["latency"]}
              className={`flex items-center gap-2 px-4 py-2 rounded-lg text-xs font-bold transition-all hover:scale-105 ${
                latencyEnabled 
                  ? "bg-primary/10 border border-primary/30 text-primary hover:bg-primary/20" 
                  : "bg-zinc-850 border border-zinc-800 hover:border-zinc-700 text-zinc-300"
              }`}
            >
              {activeActions["latency"] ? (
                <Loader2 className="w-3.5 h-3.5 animate-spin" />
              ) : latencyEnabled ? (
                "Restaurar Padrão"
              ) : (
                "Ativar 0.5ms"
              )}
            </button>
          </div>
        </div>

        {/* Auto-Limpeza de RAM (SetRamClean) */}
        <div className="p-6 rounded-xl glass-card flex flex-col justify-between hover:border-primary/20 transition-all duration-300">
          <div className="flex items-start gap-4">
            <div className="p-3 bg-tertiary/10 rounded-lg text-tertiary">
              <Zap className="w-5 h-5" />
            </div>
            <div>
              <h4 className="font-bold text-zinc-200 text-sm">Job Auto-Limpeza de RAM</h4>
              <p className="text-xs text-on-surface-variant mt-1 leading-relaxed">
                Dispara uma tarefa em segundo plano a cada 10 minutos para liberar o Working Set de processos ociosos, mantendo RAM livre.
              </p>
            </div>
          </div>
          <div className="mt-6 flex items-center justify-between border-t border-white/5 pt-4">
            <span className="text-xs font-semibold text-on-surface-variant">Status: {ramCleanEnabled ? 'Ativo em Segundo Plano' : 'Inativo'}</span>
            <button
              onClick={() => runAction("ramclean", "SetRamClean")}
              disabled={activeActions["ramclean"] || ramCleanEnabled}
              className={`flex items-center gap-2 px-4 py-2 rounded-lg text-xs font-bold transition-all hover:scale-105 ${
                ramCleanEnabled 
                  ? "bg-tertiary/10 border border-tertiary/30 text-tertiary cursor-not-allowed" 
                  : "bg-zinc-850 hover:bg-zinc-800 text-zinc-300 border border-zinc-800"
              }`}
            >
              {activeActions["ramclean"] ? (
                <Loader2 className="w-3.5 h-3.5 animate-spin" />
              ) : ramCleanEnabled ? (
                "Ativo"
              ) : (
                "Iniciar Job"
              )}
            </button>
          </div>
        </div>

        {/* Otimização de Teclado e Mouse (SetMouse, SetKeyboard) */}
        <div className="p-6 rounded-xl glass-card hover:border-primary/20 transition-all duration-300 space-y-4">
          <div className="flex items-start gap-4">
            <div className="p-3 bg-secondary/10 rounded-lg text-secondary">
              <MousePointer className="w-5 h-5" />
            </div>
            <div>
              <h4 className="font-bold text-zinc-200 text-sm">Dispositivos de Entrada (Mouse & Teclado)</h4>
              <p className="text-xs text-on-surface-variant mt-1 leading-relaxed">
                Aplica chaves de Registro para remover aceleração artificial do mouse (1:1 precision) e reduz o tempo de repetição do teclado para 150ms.
              </p>
            </div>
          </div>
          <div className="flex gap-3 pt-2">
            <button
              onClick={() => runAction("mouse", "SetMouse")}
              disabled={activeActions["mouse"]}
              className="flex-1 py-2 rounded-lg bg-zinc-850 hover:bg-zinc-800 border border-zinc-800 hover:border-zinc-750 text-xs font-bold transition-all hover:scale-105 flex items-center justify-center gap-1.5"
            >
              {activeActions["mouse"] ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : "Otimizar Mouse"}
            </button>
            <button
              onClick={() => runAction("keyboard", "SetKeyboard")}
              disabled={activeActions["keyboard"]}
              className="flex-1 py-2 rounded-lg bg-zinc-850 hover:bg-zinc-800 border border-zinc-800 hover:border-zinc-750 text-xs font-bold transition-all hover:scale-105 flex items-center justify-center gap-1.5"
            >
              {activeActions["keyboard"] ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : "Otimizar Teclado"}
            </button>
          </div>
        </div>

        {/* Rede, DVR & Shaders (SetNetwork, SetGameDVR, ResetDirectX) */}
        <div className="p-6 rounded-xl glass-card hover:border-primary/20 transition-all duration-300 space-y-4">
          <div className="flex items-start gap-4">
            <div className="p-3 bg-amber-500/10 rounded-lg text-amber-400">
              <Wifi className="w-5 h-5" />
            </div>
            <div>
              <h4 className="font-bold text-zinc-200 text-sm">Rede, DVR & Cache Shaders</h4>
              <p className="text-xs text-on-surface-variant mt-1 leading-relaxed">
                Desativa o algoritmo de Nagle (TcpAckFrequency), otimiza o GameDVR no Registro e permite resetar o cache de shaders do DirectX.
              </p>
            </div>
          </div>
          <div className="flex flex-wrap gap-3 pt-2">
            <button
              onClick={() => runAction("network", "SetNetwork")}
              disabled={activeActions["network"]}
              className="flex-1 min-w-[110px] py-2 rounded-lg bg-zinc-850 hover:bg-zinc-800 border border-zinc-800 hover:border-zinc-750 text-xs font-bold transition-all hover:scale-105 flex items-center justify-center gap-1.5"
            >
              {activeActions["network"] ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : "Otimizar TCP"}
            </button>
            <button
              onClick={() => runAction("gamedvr", "SetGameDVR")}
              disabled={activeActions["gamedvr"]}
              className="flex-1 min-w-[110px] py-2 rounded-lg bg-zinc-850 hover:bg-zinc-800 border border-zinc-800 hover:border-zinc-750 text-xs font-bold transition-all hover:scale-105 flex items-center justify-center gap-1.5"
            >
              {activeActions["gamedvr"] ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : "Desativar FSO"}
            </button>
            <button
              onClick={() => runAction("directx", "ResetDirectX")}
              disabled={activeActions["directx"]}
              className="flex-1 min-w-[110px] py-2 rounded-lg bg-zinc-850 hover:bg-zinc-800 border border-zinc-800 hover:border-zinc-750 text-xs font-bold transition-all hover:scale-105 flex items-center justify-center gap-1.5"
            >
              {activeActions["directx"] ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : "Shader Reset"}
            </button>
          </div>
        </div>

        {/* Prioridade do Processo (SetPriority) */}
        <div className="p-6 rounded-xl glass-card hover:border-primary/20 transition-all duration-300 flex flex-col justify-between">
          <div className="flex items-start gap-4">
            <div className="p-3 bg-red-500/10 rounded-lg text-red-400">
              <Cpu className="w-5 h-5" />
            </div>
            <div className="w-full">
              <h4 className="font-bold text-zinc-200 text-sm">Prioridade de CPU do Jogo</h4>
              <p className="text-xs text-on-surface-variant mt-1 leading-relaxed">
                Registra o executável na chave do Windows PerfOptions para rodar sempre em prioridade Alta (High).
              </p>
              <div className="mt-4 flex gap-2">
                <input
                  type="text"
                  placeholder="Ex: valorant.exe ou cs2"
                  value={processName}
                  onChange={(e) => setProcessName(e.target.value)}
                  className="flex-1 bg-zinc-950 border border-white/10 focus:border-primary focus:ring-1 focus:ring-primary rounded-lg px-3 py-2 text-xs text-[#e5e2e1] outline-none transition-all placeholder:text-zinc-600"
                />
                <button
                  onClick={() => runAction("priority", "SetPriority", processName)}
                  disabled={activeActions["priority"] || !processName}
                  className="px-4 py-2 rounded-lg bg-zinc-850 hover:bg-zinc-800 text-xs font-bold border border-zinc-850 hover:border-zinc-750 text-zinc-200 disabled:opacity-40 disabled:cursor-not-allowed transition-all flex items-center gap-1"
                >
                  {activeActions["priority"] ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : "Aplicar"}
                </button>
              </div>
            </div>
          </div>
        </div>

        {/* Exclusão do Windows Defender (SetDefenderExclusion) */}
        <div className="p-6 rounded-xl glass-card hover:border-primary/20 transition-all duration-300 flex flex-col justify-between">
          <div className="flex items-start gap-4">
            <div className="p-3 bg-orange-500/10 rounded-lg text-orange-400">
              <ShieldAlert className="w-5 h-5" />
            </div>
            <div className="w-full">
              <h4 className="font-bold text-zinc-200 text-sm">Exclusão do Windows Defender</h4>
              <p className="text-xs text-on-surface-variant mt-1 leading-relaxed">
                Evita travamentos de leitura/escrita adicionando a pasta do seu jogo à lista de exclusões do antivírus.
              </p>
              <div className="mt-4 flex gap-2">
                <input
                  type="text"
                  placeholder="Ex: C:\Games\SteamApps"
                  value={exclusionPath}
                  onChange={(e) => setExclusionPath(e.target.value)}
                  className="flex-1 bg-zinc-950 border border-white/10 focus:border-primary focus:ring-1 focus:ring-primary rounded-lg px-3 py-2 text-xs text-[#e5e2e1] outline-none transition-all placeholder:text-zinc-600"
                />
                <button
                  onClick={() => runAction("exclusion", "SetDefenderExclusion", exclusionPath)}
                  disabled={activeActions["exclusion"] || !exclusionPath}
                  className="px-4 py-2 rounded-lg bg-zinc-850 hover:bg-zinc-800 text-xs font-bold border border-zinc-850 hover:border-zinc-750 text-zinc-200 disabled:opacity-40 disabled:cursor-not-allowed transition-all flex items-center gap-1"
                >
                  {activeActions["exclusion"] ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : "Adicionar"}
                </button>
              </div>
            </div>
          </div>
        </div>

      </div>

      {/* Seção de feedback de resultados */}
      <AnimatePresence>
        {Object.keys(results).length > 0 && (
          <div className="mt-8 space-y-3">
            <h3 className="text-xs font-bold text-on-surface-variant tracking-wider uppercase flex items-center justify-between">
              <span>Status das Modificações</span>
              <button 
                onClick={() => setResults({})}
                className="text-[10px] text-zinc-600 hover:text-zinc-400 transition-colors uppercase"
              >
                Limpar Log
              </button>
            </h3>
            <div className="space-y-2">
              {Object.entries(results).map(([key, value]) => (
                <motion.div
                  key={key}
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  exit={{ opacity: 0, y: -10 }}
                  className={`p-4 rounded-xl border flex gap-3 text-xs ${
                    value.Status === "Success"
                      ? "bg-tertiary/10 border-tertiary/20 text-tertiary"
                      : value.Status === "Warning"
                      ? "bg-amber-500/10 border-amber-500/20 text-amber-400"
                      : "bg-red-500/10 border-red-500/20 text-red-450"
                  }`}
                >
                  {value.Status === "Success" ? (
                    <CheckCircle2 className="w-4 h-4 shrink-0 mt-0.5" />
                  ) : value.Status === "Warning" ? (
                    <AlertCircle className="w-4 h-4 shrink-0 mt-0.5" />
                  ) : (
                    <XCircle className="w-4 h-4 shrink-0 mt-0.5" />
                  )}
                  <div>
                    <span className="font-bold capitalize text-zinc-200 block">{key}: {value.Status}</span>
                    <span className="text-zinc-450 mt-1 block">{value.Message}</span>
                    {value.Tweak && (
                      <span className="text-[10px] bg-zinc-950/60 px-2 py-0.5 rounded border border-white/5 inline-block mt-2">
                        Tweak: {value.Tweak} &rarr; {value.Value}
                      </span>
                    )}
                  </div>
                </motion.div>
              ))}
            </div>
          </div>
        )}
      </AnimatePresence>
    </div>
  );
}
