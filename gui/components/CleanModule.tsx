'use client';

import { useState } from "react";
import { invokePowerShell, ActionResponse } from "../lib/api";
import { motion, AnimatePresence } from "framer-motion";
import { 
  Zap, 
  Trash2, 
  Layers, 
  CheckCircle2, 
  AlertTriangle, 
  Loader2,
  Database,
  HardDrive
} from "lucide-react";

export default function CleanModule() {
  const [running, setRunning] = useState<string | null>(null);
  const [summaryResult, setSummaryResult] = useState<ActionResponse | null>(null);
  const [detailResults, setDetailResults] = useState<ActionResponse[]>([]);

  const handleClean = async (type: "OptimizeDeep" | "OptimizeLite" | "RemoveOrphans") => {
    setRunning(type);
    setSummaryResult(null);
    setDetailResults([]);
    try {
      if (type === "RemoveOrphans") {
        const res = await invokePowerShell<ActionResponse>("RemoveOrphans");
        setSummaryResult(res);
      } else {
        const results = await invokePowerShell<ActionResponse[]>(type);
        const summary = results.find(r => r.Step === "Summary");
        if (summary) {
          setSummaryResult(summary);
        }
        setDetailResults(results.filter(r => r.Step !== "Summary"));
      }
    } catch (err: any) {
      setSummaryResult({
        Status: "Error",
        Message: err?.message || "Ocorreu um erro ao executar a limpeza."
      });
    } finally {
      setRunning(null);
    }
  };

  return (
    <div className="space-y-8 animate-card-entry">
      <div>
        <h2 className="text-xl font-bold font-headline-lg text-zinc-100 tracking-tight flex items-center gap-2">
          <Trash2 className="w-5 h-5 text-orange-500" />
          Central de Limpeza & Otimização
        </h2>
        <p className="text-xs text-on-surface-variant mt-1">
          Libere espaço valioso de armazenamento e elimine lixo acumulado do sistema de forma segura.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        
        {/* Limpeza Profunda (OptimizeDeep) */}
        <div className="p-6 rounded-2xl glass-card flex flex-col justify-between hover:border-orange-500/20 transition-all duration-300 md:col-span-2 relative overflow-hidden group">
          <div className="absolute top-0 right-0 w-32 h-32 bg-orange-500/5 rounded-full blur-[40px] pointer-events-none group-hover:bg-orange-500/10 transition-all" />
          
          <div className="space-y-4">
            <div className="flex items-center gap-3">
              <div className="p-3 bg-orange-500/10 rounded-lg text-orange-500">
                <HardDrive className="w-5 h-5" />
              </div>
              <h3 className="font-bold text-zinc-200">Limpeza Profunda (Recomendado para SSD)</h3>
            </div>
            <p className="text-xs text-on-surface-variant leading-relaxed">
              Remove caches de atualizações do Windows, arquivos de prefetched, logs de diagnóstico, caches de navegadores (Chrome/Edge), esvazia a lixeira e executa o comando nativo TRIM para consolidar blocos livres no SSD.
            </p>
          </div>

          <div className="mt-8 flex items-center justify-between border-t border-white/5 pt-4">
            <span className="text-[10px] text-zinc-500 flex items-center gap-1.5 font-semibold">
              <span className="w-1.5 h-1.5 rounded-full bg-orange-500" />
              Requer privilégios de Administrador
            </span>
            <button
              onClick={() => handleClean("OptimizeDeep")}
              disabled={running !== null}
              className="px-5 py-3 rounded-lg bg-gradient-to-r from-orange-500 to-red-600 hover:from-orange-600 hover:to-red-755 text-zinc-950 text-xs font-bold hover:shadow-[0_0_15px_rgba(249,115,22,0.4)] transition-all hover:scale-105 flex items-center gap-2"
            >
              {running === "OptimizeDeep" ? (
                <>
                  <Loader2 className="w-4 h-4 animate-spin" />
                  Limpando Sistema...
                </>
              ) : (
                "Executar Limpeza Profunda"
              )}
            </button>
          </div>
        </div>

        {/* Limpeza Rápida (OptimizeLite) */}
        <div className="p-6 rounded-2xl glass-card flex flex-col justify-between hover:border-orange-500/20 transition-all duration-300">
          <div className="space-y-4">
            <div className="flex items-center gap-3">
              <div className="p-3 bg-amber-500/10 rounded-lg text-amber-500">
                <Zap className="w-5 h-5" />
              </div>
              <h3 className="font-bold text-zinc-200">Limpeza Lite (HDD)</h3>
            </div>
            <p className="text-xs text-on-surface-variant leading-relaxed">
              Ação rápida e sem riscos que limpa arquivos temporários do usuário e do Windows, logs leves e a lixeira. Livre de otimização de bloco SSD.
            </p>
          </div>

          <div className="mt-6 border-t border-white/5 pt-4 flex justify-end">
            <button
              onClick={() => handleClean("OptimizeLite")}
              disabled={running !== null}
              className="px-4 py-2.5 rounded-lg bg-zinc-850 hover:bg-zinc-800 border border-zinc-800 hover:border-zinc-750 text-xs font-bold text-[#e5e2e1] transition-all hover:scale-105"
            >
              {running === "OptimizeLite" ? (
                <Loader2 className="w-3.5 h-3.5 animate-spin" />
              ) : (
                "Limpeza Lite"
              )}
            </button>
          </div>
        </div>

      </div>

      <div className="grid grid-cols-1 gap-6">
        {/* Limpeza de Tarefas Agendadas (RemoveOrphans) */}
        <div className="p-5 rounded-xl glass-card hover:border-orange-500/20 transition-all duration-300 flex items-center justify-between">
          <div className="flex items-center gap-4">
            <div className="p-3 bg-yellow-500/10 rounded-lg text-yellow-500">
              <Layers className="w-5 h-5" />
            </div>
            <div>
              <h4 className="font-bold text-zinc-200 text-sm">Remover Tarefas Agendadas Órfãs</h4>
              <p className="text-xs text-on-surface-variant mt-1">
                Varre o Windows Task Scheduler e apaga as tarefas criadas por apps que já foram desinstalados e não possuem mais executáveis válidos.
              </p>
            </div>
          </div>
          <button
            onClick={() => handleClean("RemoveOrphans")}
            disabled={running !== null}
            className="px-4 py-2 rounded-lg bg-zinc-850 hover:bg-zinc-800 border border-zinc-800 hover:border-zinc-750 text-xs font-bold text-[#e5e2e1] transition-all hover:scale-105 shrink-0 ml-4"
          >
            {running === "RemoveOrphans" ? (
              <Loader2 className="w-3.5 h-3.5 animate-spin" />
            ) : (
              "Remover Órfãs"
            )}
          </button>
        </div>
      </div>

      {/* Resultados e Log detalhado */}
      <AnimatePresence>
        {summaryResult && (
          <motion.div
            initial={{ opacity: 0, y: 15 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0 }}
            className="space-y-6"
          >
            {/* Bloco de Resumo */}
            <div className={`p-5 rounded-xl border flex gap-4 ${
              summaryResult.Status === "Success"
                ? "bg-tertiary/10 border-tertiary/20 text-tertiary"
                : "bg-red-500/10 border-red-500/20 text-red-450"
            }`}>
              {summaryResult.Status === "Success" ? (
                <CheckCircle2 className="w-6 h-6 shrink-0 mt-0.5" />
              ) : (
                <AlertTriangle className="w-6 h-6 shrink-0 mt-0.5" />
              )}
              <div>
                <h4 className="font-bold text-zinc-100 text-sm">Status do Processamento</h4>
                <p className="text-xs text-on-surface-variant mt-1">{summaryResult.Message}</p>
                {summaryResult.BytesFreed !== undefined && (
                  <p className="text-sm font-bold text-tertiary mt-2 flex items-center gap-1">
                    <Database className="w-4 h-4" />
                    Espaço Total Liberado: {summaryResult.BytesFreed} MB
                  </p>
                )}
                {summaryResult.DeletedCount !== undefined && (
                  <p className="text-sm font-bold text-tertiary mt-2">
                    Tarefas deletadas: {summaryResult.DeletedCount}
                  </p>
                )}
              </div>
            </div>

            {/* Grid de Passos Detalhados */}
            {detailResults.length > 0 && (
              <div className="space-y-3">
                <h4 className="text-xs font-bold text-on-surface-variant tracking-wider uppercase">Relatório de Arquivos Deletados</h4>
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                  {detailResults.map((step, idx) => (
                    <div 
                      key={idx} 
                      className="p-4 rounded-lg glass-card flex items-center justify-between text-xs hover:border-zinc-800 transition-all duration-300"
                    >
                      <div>
                        <span className="font-semibold text-zinc-300 block">{step.Target || step.Step}</span>
                        <span className="text-[10px] text-zinc-500 mt-0.5 block">{step.Message || 'Limpeza efetuada.'}</span>
                      </div>
                      {step.BytesFreed !== undefined && step.BytesFreed > 0 && (
                        <span className="font-bold text-tertiary bg-tertiary/5 border border-tertiary/10 px-2 py-0.5 rounded text-[10px]">
                          -{step.BytesFreed} MB
                        </span>
                      )}
                    </div>
                  ))}
                </div>
              </div>
            )}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
