'use client';

import { useState } from "react";
import { invokePowerShell, ActionResponse } from "../lib/api";
import { useI18n } from "../lib/i18n";
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
  const { t } = useI18n();

  const handleClean = async (type: "OptimizeDeep" | "OptimizeLite" | "RemoveOrphans") => {
    setRunning(type);
    setSummaryResult(null);
    try {
      const res = await invokePowerShell<ActionResponse>(type);
      setSummaryResult(res);
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
        <h2 className="text-xl font-bold font-headline-lg text-[#e5e2e1] tracking-tight flex items-center gap-2">
          <Trash2 className="w-5 h-5 text-primary" />
          {t("clean.title")}
        </h2>
        <p className="text-xs text-on-surface-variant mt-1">
          {t("clean.desc")}
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        
        {/* Limpeza Profunda (OptimizeDeep) */}
        <div className="p-6 rounded-2xl glass-card flex flex-col justify-between hover:border-primary/20 transition-all duration-300 md:col-span-2 relative overflow-hidden group">
          <div className="absolute top-0 right-0 w-32 h-32 bg-primary/5 rounded-full blur-[40px] pointer-events-none group-hover:bg-primary/10 transition-all" />
          
          <div className="space-y-4">
            <div className="flex items-center gap-3">
              <div className="p-3 bg-primary/10 rounded-lg text-primary">
                <HardDrive className="w-5 h-5" />
              </div>
              <h3 className="font-bold text-zinc-200">{t("clean.deep.title")}</h3>
            </div>
            <p className="text-xs text-on-surface-variant leading-relaxed">
              {t("clean.deep.desc")}
            </p>
          </div>

          <div className="mt-8 flex items-center justify-between border-t border-white/5 pt-4">
            <span className="text-[10px] text-zinc-500 flex items-center gap-1.5 font-semibold">
              <span className="w-1.5 h-1.5 rounded-full bg-primary" />
              {t("clean.req_admin")}
            </span>
            <button
              onClick={() => handleClean("OptimizeDeep")}
              disabled={running !== null}
              className="px-5 py-3 rounded-lg bg-gradient-to-r from-primary to-secondary text-zinc-950 text-xs font-bold hover:shadow-[0_0_15px_rgba(76,215,246,0.4)] transition-all hover:scale-105 flex items-center gap-2"
            >
              {running === "OptimizeDeep" ? (
                <>
                  <Loader2 className="w-4 h-4 animate-spin" />
                  {t("clean.deep.running")}
                </>
              ) : (
                t("clean.deep.btn")
              )}
            </button>
          </div>
        </div>

        {/* Limpeza Rápida (OptimizeLite) */}
        <div className="p-6 rounded-2xl glass-card flex flex-col justify-between hover:border-primary/20 transition-all duration-300">
          <div className="space-y-4">
            <div className="flex items-center gap-3">
              <div className="p-3 bg-[#d0bcff]/10 rounded-lg text-secondary">
                <Zap className="w-5 h-5" />
              </div>
              <h3 className="font-bold text-zinc-200">{t("clean.lite.title")}</h3>
            </div>
            <p className="text-xs text-on-surface-variant leading-relaxed">
              {t("clean.lite.desc")}
            </p>
          </div>

          <div className="mt-6 border-t border-white/5 pt-4 flex justify-end">
            <button
              onClick={() => handleClean("OptimizeLite")}
              disabled={running !== null}
              className="px-4 py-2.5 rounded-lg bg-surface-container hover:bg-surface-container-high border border-white/5 hover:border-white/10 text-xs font-bold text-[#e5e2e1] transition-all hover:scale-105"
            >
              {running === "OptimizeLite" ? (
                <Loader2 className="w-3.5 h-3.5 animate-spin" />
              ) : (
                t("clean.lite.btn")
              )}
            </button>
          </div>
        </div>

      </div>

      <div className="grid grid-cols-1 gap-6">
        {/* Limpeza de Tarefas Agendadas (RemoveOrphans) */}
        <div className="p-5 rounded-xl glass-card hover:border-primary/20 transition-all duration-300 flex items-center justify-between">
          <div className="flex items-center gap-4">
            <div className="p-3 bg-primary/10 rounded-lg text-primary">
              <Layers className="w-5 h-5" />
            </div>
            <div>
              <h4 className="font-bold text-zinc-200 text-sm">{t("clean.orphans.title")}</h4>
              <p className="text-xs text-on-surface-variant mt-1">
                {t("clean.orphans.desc")}
              </p>
            </div>
          </div>
          <button
            onClick={() => handleClean("RemoveOrphans")}
            disabled={running !== null}
            className="px-4 py-2 rounded-lg bg-surface-container hover:bg-surface-container-high border border-white/5 hover:border-white/10 text-xs font-bold text-[#e5e2e1] transition-all hover:scale-105 shrink-0 ml-4"
          >
            {running === "RemoveOrphans" ? (
              <Loader2 className="w-3.5 h-3.5 animate-spin" />
            ) : (
              t("clean.orphans.btn")
            )}
          </button>
        </div>
      </div>

      {/* Resultados do Log */}
      <AnimatePresence>
        {summaryResult && (
          <motion.div
            initial={{ opacity: 0, y: 15 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0 }}
            className="space-y-6"
          >
            <div className={`p-5 rounded-xl border flex gap-4 ${
              summaryResult.Status === "Success"
                ? "bg-tertiary/10 border-tertiary/20 text-tertiary"
                : "bg-error-container/20 border-error/20 text-error"
            }`}>
              {summaryResult.Status === "Success" ? (
                <CheckCircle2 className="w-6 h-6 shrink-0 mt-0.5" />
              ) : (
                <AlertTriangle className="w-6 h-6 shrink-0 mt-0.5" />
              )}
              <div>
                <h4 className="font-bold text-zinc-100 text-sm">{t("clean.status")}</h4>
                <p className="text-xs text-[#bcc9cd] mt-1 leading-snug">{summaryResult.Message}</p>
                {summaryResult.BytesFreed !== undefined && summaryResult.BytesFreed > 0 && (
                  <p className="text-sm font-bold text-tertiary mt-2 flex items-center gap-1">
                    <Database className="w-4 h-4" />
                    {t("clean.freed")}: {summaryResult.BytesFreed} MB
                  </p>
                )}
                {summaryResult.DeletedCount !== undefined && (
                  <p className="text-sm font-bold text-tertiary mt-2">
                    {t("clean.deleted_tasks")}: {summaryResult.DeletedCount}
                  </p>
                )}
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
