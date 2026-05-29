'use client';

import { useState } from "react";
import { invokePowerShell, ActionResponse } from "../lib/api";
import { motion, AnimatePresence } from "framer-motion";
import { 
  Key, 
  ShieldCheck, 
  Monitor, 
  FileText, 
  Loader2, 
  CheckCircle2, 
  XCircle,
  AlertCircle
} from "lucide-react";

export default function ActivatorModule() {
  const [activeActions, setActiveActions] = useState<Record<string, boolean>>({});
  const [results, setResults] = useState<Record<string, ActionResponse>>({});

  const runAction = async (actionId: string, actionName: string) => {
    setActiveActions(prev => ({ ...prev, [actionId]: true }));
    try {
      const res = await invokePowerShell<ActionResponse>(actionName);
      setResults(prev => ({ ...prev, [actionId]: res }));
    } catch (err: any) {
      setResults(prev => ({ 
        ...prev, 
        [actionId]: { Status: "Error", Message: err?.message || "Erro de comunicação com o script MAS." } 
      }));
    } finally {
      setActiveActions(prev => ({ ...prev, [actionId]: false }));
    }
  };

  return (
    <div className="space-y-8">
      <div>
        <h2 className="text-xl font-extrabold text-zinc-100 tracking-tight flex items-center gap-2">
          <Key className="w-5 h-5 text-red-500" />
          Ativação de Licenças (MAS)
        </h2>
        <p className="text-xs text-zinc-500 mt-1">
          Ative suas cópias do Windows e do Microsoft Office utilizando os scripts oficiais e seguros do MAS (Microsoft Activation Scripts) em janelas separadas.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        
        {/* Ativar Windows (ActivateWindows) */}
        <div className="p-6 rounded-2xl bg-zinc-900/40 border border-zinc-800/60 backdrop-blur-xl flex flex-col justify-between hover:border-red-500/20 transition-all duration-300 relative overflow-hidden group">
          <div className="absolute top-0 right-0 w-32 h-32 bg-red-500/5 rounded-full blur-[40px] pointer-events-none group-hover:bg-red-500/10 transition-colors" />
          <div className="space-y-4">
            <div className="flex items-center gap-3">
              <div className="p-3 bg-red-500/10 rounded-xl text-red-500">
                <Monitor className="w-5 h-5" />
              </div>
              <h3 className="font-bold text-zinc-200">Ativar Windows (HWID)</h3>
            </div>
            <p className="text-xs text-zinc-500 leading-relaxed">
              Associa uma licença digital permanente ao hardware do seu computador através do método HWID do Microsoft Activation Scripts. Seguro e definitivo.
            </p>
          </div>
          <div className="mt-8 border-t border-zinc-800/50 pt-4 flex items-center justify-between">
            <span className="text-[10px] text-zinc-500 flex items-center gap-1">
              <ShieldCheck className="w-3.5 h-3.5 text-emerald-500" />
              Janela Externa Requerida
            </span>
            <button
              onClick={() => runAction("winact", "ActivateWindows")}
              disabled={activeActions["winact"]}
              className="px-4 py-2 rounded-xl bg-red-650 hover:bg-red-600 border border-red-800 hover:border-red-750 text-xs font-bold text-zinc-100 transition-all flex items-center gap-1.5"
            >
              {activeActions["winact"] ? (
                <Loader2 className="w-3.5 h-3.5 animate-spin" />
              ) : (
                "Ativar Windows"
              )}
            </button>
          </div>
        </div>

        {/* Ativar Office (ActivateOffice) */}
        <div className="p-6 rounded-2xl bg-zinc-900/40 border border-zinc-800/60 backdrop-blur-xl flex flex-col justify-between hover:border-red-500/20 transition-all duration-300 relative overflow-hidden group">
          <div className="absolute top-0 right-0 w-32 h-32 bg-red-500/5 rounded-full blur-[40px] pointer-events-none group-hover:bg-red-500/10 transition-colors" />
          <div className="space-y-4">
            <div className="flex items-center gap-3">
              <div className="p-3 bg-red-500/10 rounded-xl text-red-500">
                <FileText className="w-5 h-5" />
              </div>
              <h3 className="font-bold text-zinc-200">Ativar Microsoft Office</h3>
            </div>
            <p className="text-xs text-zinc-500 leading-relaxed">
              Ativa suas instalações locais do Microsoft Office (KMS38 ou similar) de forma automatizada através do console externo do MAS.
            </p>
          </div>
          <div className="mt-8 border-t border-zinc-800/50 pt-4 flex items-center justify-between">
            <span className="text-[10px] text-zinc-500 flex items-center gap-1">
              <ShieldCheck className="w-3.5 h-3.5 text-emerald-500" />
              Janela Externa Requerida
            </span>
            <button
              onClick={() => runAction("offact", "ActivateOffice")}
              disabled={activeActions["offact"]}
              className="px-4 py-2 rounded-xl bg-red-650 hover:bg-red-600 border border-red-800 hover:border-red-750 text-xs font-bold text-zinc-100 transition-all flex items-center gap-1.5"
            >
              {activeActions["offact"] ? (
                <Loader2 className="w-3.5 h-3.5 animate-spin" />
              ) : (
                "Ativar Office"
              )}
            </button>
          </div>
        </div>

      </div>

      {/* Resultados de feedback */}
      <AnimatePresence>
        {Object.keys(results).length > 0 && (
          <div className="mt-8 space-y-3">
            <h3 className="text-xs font-bold text-zinc-400 tracking-wider uppercase flex items-center justify-between">
              <span>Status das Ativações</span>
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
                      ? "bg-emerald-500/10 border-emerald-500/20 text-emerald-400"
                      : "bg-red-500/10 border-red-500/20 text-red-400"
                  }`}
                >
                  {value.Status === "Success" ? (
                    <CheckCircle2 className="w-4 h-4 shrink-0 mt-0.5" />
                  ) : (
                    <XCircle className="w-4 h-4 shrink-0 mt-0.5" />
                  )}
                  <div>
                    <span className="font-extrabold capitalize text-zinc-200 block">{key === "winact" ? "Ativação Windows" : "Ativação Office"}: {value.Status}</span>
                    <span className="text-zinc-400 mt-1 block">{value.Message}</span>
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
