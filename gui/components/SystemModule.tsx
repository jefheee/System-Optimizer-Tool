'use client';

import { useState } from "react";
import { invokePowerShell, ActionResponse } from "../lib/api";
import { motion, AnimatePresence } from "framer-motion";
import { 
  Settings, 
  RefreshCw, 
  Wifi, 
  Search, 
  ShieldAlert, 
  Trash2, 
  FileText, 
  Loader2, 
  CheckCircle2, 
  XCircle,
  AlertCircle,
  Terminal,
  Cpu
} from "lucide-react";

export default function SystemModule() {
  const [activeActions, setActiveActions] = useState<Record<string, boolean>>({});
  const [results, setResults] = useState<Record<string, ActionResponse>>({});

  const runAction = async (actionId: string, actionName: string, args: string = "") => {
    setActiveActions(prev => ({ ...prev, [actionId]: true }));
    try {
      const res = await invokePowerShell<ActionResponse>(actionName, args);
      setResults(prev => ({ ...prev, [actionId]: res }));
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
    <div className="space-y-8">
      <div>
        <h2 className="text-xl font-extrabold text-zinc-100 tracking-tight flex items-center gap-2">
          <Settings className="w-5 h-5 text-purple-400" />
          Manutenção & Reparações do Sistema
        </h2>
        <p className="text-xs text-zinc-500 mt-1">
          Restaure a integridade dos arquivos do Windows, reconfigure conexões de rede e acione utilitários de terceiros.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        
        {/* WinUtil (Chris Titus) */}
        <div className="p-5 rounded-2xl bg-zinc-900/40 border border-zinc-800/60 backdrop-blur-xl flex flex-col justify-between hover:border-purple-500/20 transition-all duration-300">
          <div className="flex items-start gap-4">
            <div className="p-3 bg-blue-500/10 rounded-xl text-blue-400">
              <Terminal className="w-5 h-5" />
            </div>
            <div>
              <h4 className="font-bold text-zinc-200 text-sm">WinUtil (Chris Titus)</h4>
              <p className="text-xs text-zinc-500 mt-1 leading-relaxed">
                Abre o utilitário completo de debloat e instalação de pacotes do Chris Titus Tech em uma janela externa com privilégios de administrador.
              </p>
            </div>
          </div>
          <div className="mt-6 border-t border-zinc-800/50 pt-4 flex justify-end">
            <button
              onClick={() => runAction("winutil", "RunWinUtil")}
              disabled={activeActions["winutil"]}
              className="flex items-center gap-2 px-4 py-2 rounded-xl bg-zinc-850 hover:bg-zinc-800 border border-zinc-800 hover:border-zinc-750 text-xs font-bold text-zinc-200 transition-all"
            >
              {activeActions["winutil"] ? (
                <Loader2 className="w-3.5 h-3.5 animate-spin" />
              ) : (
                "Abrir WinUtil"
              )}
            </button>
          </div>
        </div>

        {/* Otimizar DNS (OptimizeDns) */}
        <div className="p-5 rounded-2xl bg-zinc-900/40 border border-zinc-800/60 backdrop-blur-xl flex flex-col justify-between hover:border-purple-500/20 transition-all duration-300">
          <div className="flex items-start gap-4">
            <div className="p-3 bg-cyan-500/10 rounded-xl text-cyan-400">
              <Wifi className="w-5 h-5" />
            </div>
            <div>
              <h4 className="font-bold text-zinc-200 text-sm">Otimizar Latência de DNS</h4>
              <p className="text-xs text-zinc-500 mt-1 leading-relaxed">
                Testa a latência em tempo real dos servidores do Google e Cloudflare, aplicando automaticamente o de menor ping à interface ativa.
              </p>
            </div>
          </div>
          <div className="mt-6 border-t border-zinc-800/50 pt-4 flex justify-end">
            <button
              onClick={() => runAction("dns", "OptimizeDns")}
              disabled={activeActions["dns"]}
              className="flex items-center gap-2 px-4 py-2 rounded-xl bg-zinc-850 hover:bg-zinc-800 border border-zinc-800 hover:border-zinc-750 text-xs font-bold text-zinc-200 transition-all"
            >
              {activeActions["dns"] ? (
                <Loader2 className="w-3.5 h-3.5 animate-spin" />
              ) : (
                "Otimizar Conexão DNS"
              )}
            </button>
          </div>
        </div>

        {/* Desativar Telemetria (DisableTelemetry) */}
        <div className="p-5 rounded-2xl bg-zinc-900/40 border border-zinc-800/60 backdrop-blur-xl flex flex-col justify-between hover:border-purple-500/20 transition-all duration-300">
          <div className="flex items-start gap-4">
            <div className="p-3 bg-red-500/10 rounded-xl text-red-400">
              <ShieldAlert className="w-5 h-5" />
            </div>
            <div>
              <h4 className="font-bold text-zinc-200 text-sm">Desativar Telemetria & Rastreamento</h4>
              <p className="text-xs text-zinc-500 mt-1 leading-relaxed">
                Interrompe serviços nativos de feedback (DiagTrack, dmwappushservice) e injeta políticas de privacidade para mitigar o uso de CPU.
              </p>
            </div>
          </div>
          <div className="mt-6 border-t border-zinc-800/50 pt-4 flex justify-end">
            <button
              onClick={() => runAction("telemetry", "DisableTelemetry")}
              disabled={activeActions["telemetry"]}
              className="flex items-center gap-2 px-4 py-2 rounded-xl bg-zinc-850 hover:bg-zinc-800 border border-zinc-800 hover:border-zinc-750 text-xs font-bold text-zinc-200 transition-all"
            >
              {activeActions["telemetry"] ? (
                <Loader2 className="w-3.5 h-3.5 animate-spin" />
              ) : (
                "Desativar Rastreamentos"
              )}
            </button>
          </div>
        </div>

        {/* Remover Bloatware (RemoveBloatware) */}
        <div className="p-5 rounded-2xl bg-zinc-900/40 border border-zinc-800/60 backdrop-blur-xl flex flex-col justify-between hover:border-purple-500/20 transition-all duration-300">
          <div className="flex items-start gap-4">
            <div className="p-3 bg-purple-500/10 rounded-xl text-purple-400">
              <Trash2 className="w-5 h-5" />
            </div>
            <div>
              <h4 className="font-bold text-zinc-200 text-sm">Remover Bloatware do Windows</h4>
              <p className="text-xs text-zinc-500 mt-1 leading-relaxed">
                Desinstala aplicativos embutidos indesejados (Xbox Overlay, YourPhone, Cortana, etc.) que rodam silenciosamente.
              </p>
            </div>
          </div>
          <div className="mt-6 border-t border-zinc-800/50 pt-4 flex justify-end">
            <button
              onClick={() => runAction("bloatware", "RemoveBloatware")}
              disabled={activeActions["bloatware"]}
              className="flex items-center gap-2 px-4 py-2 rounded-xl bg-zinc-850 hover:bg-zinc-800 border border-zinc-800 hover:border-zinc-750 text-xs font-bold text-zinc-200 transition-all"
            >
              {activeActions["bloatware"] ? (
                <Loader2 className="w-3.5 h-3.5 animate-spin" />
              ) : (
                "Remover Aplicativos Inúteis"
              )}
            </button>
          </div>
        </div>

        {/* Limpar Tarefas Órfãs (RemoveOrphans) */}
        <div className="p-5 rounded-2xl bg-zinc-900/40 border border-zinc-800/60 backdrop-blur-xl flex flex-col justify-between hover:border-purple-500/20 transition-all duration-300">
          <div className="flex items-start gap-4">
            <div className="p-3 bg-amber-500/10 rounded-xl text-amber-400">
              <Trash2 className="w-5 h-5" />
            </div>
            <div>
              <h4 className="font-bold text-zinc-200 text-sm">Limpar Tarefas Órfãs</h4>
              <p className="text-xs text-zinc-500 mt-1 leading-relaxed">
                Examina o Agendador de Tarefas do Windows e apaga registros obsoletos ou órfãos de aplicativos já excluídos.
              </p>
            </div>
          </div>
          <div className="mt-6 border-t border-zinc-800/50 pt-4 flex justify-end">
            <button
              onClick={() => runAction("orphans", "RemoveOrphans")}
              disabled={activeActions["orphans"]}
              className="flex items-center gap-2 px-4 py-2 rounded-xl bg-zinc-850 hover:bg-zinc-800 border border-zinc-800 hover:border-zinc-750 text-xs font-bold text-zinc-200 transition-all"
            >
              {activeActions["orphans"] ? (
                <Loader2 className="w-3.5 h-3.5 animate-spin" />
              ) : (
                "Limpar Tarefas Órfãs"
              )}
            </button>
          </div>
        </div>

        {/* Reparar Windows Update (RepairWindowsUpdate) */}
        <div className="p-5 rounded-2xl bg-zinc-900/40 border border-zinc-800/60 backdrop-blur-xl flex flex-col justify-between hover:border-purple-500/20 transition-all duration-300">
          <div className="flex items-start gap-4">
            <div className="p-3 bg-yellow-500/10 rounded-xl text-yellow-500">
              <RefreshCw className="w-5 h-5" />
            </div>
            <div>
              <h4 className="font-bold text-zinc-200 text-sm">Reparar Serviços Windows Update</h4>
              <p className="text-xs text-zinc-500 mt-1 leading-relaxed">
                Para o wuauserv/bits, limpa o diretório de distribuição temporário do Windows e força o reinício limpo dos serviços.
              </p>
            </div>
          </div>
          <div className="mt-6 border-t border-zinc-800/50 pt-4 flex justify-end">
            <button
              onClick={() => runAction("wupdate", "RepairWindowsUpdate")}
              disabled={activeActions["wupdate"]}
              className="flex items-center gap-2 px-4 py-2 rounded-xl bg-zinc-850 hover:bg-zinc-800 border border-zinc-800 hover:border-zinc-750 text-xs font-bold text-zinc-200 transition-all"
            >
              {activeActions["wupdate"] ? (
                <Loader2 className="w-3.5 h-3.5 animate-spin" />
              ) : (
                "Reparar Update Cache"
              )}
            </button>
          </div>
        </div>

        {/* Integridade do Sistema - SFC (SystemScan) */}
        <div className="p-5 rounded-2xl bg-zinc-900/40 border border-zinc-800/60 backdrop-blur-xl flex flex-col justify-between hover:border-purple-500/20 transition-all duration-300">
          <div className="flex items-start gap-4">
            <div className="p-3 bg-emerald-500/10 rounded-xl text-emerald-400">
              <Search className="w-5 h-5" />
            </div>
            <div>
              <h4 className="font-bold text-zinc-200 text-sm">Verificador de Arquivos SFC</h4>
              <p className="text-xs text-zinc-500 mt-1 leading-relaxed">
                Executa o utilitário nativo SFC /scannow de forma assíncrona para buscar e reparar arquivos de sistema corrompidos.
              </p>
            </div>
          </div>
          <div className="mt-6 border-t border-zinc-800/50 pt-4 flex justify-end">
            <button
              onClick={() => runAction("scan", "SystemScan")}
              disabled={activeActions["scan"]}
              className="flex-1 max-w-[200px] py-2 rounded-xl bg-zinc-850 hover:bg-zinc-800 border border-zinc-800 hover:border-zinc-750 text-xs font-bold text-zinc-250 transition-all"
            >
              {activeActions["scan"] ? (
                <span className="flex items-center justify-center gap-1.5">
                  <Loader2 className="w-3.5 h-3.5 animate-spin" />
                  Escaneando...
                </span>
              ) : (
                "Varredura Completa"
              )}
            </button>
          </div>
        </div>

        {/* Ferramentas Avançadas: Tomar Posse & Backup Drivers */}
        <div className="p-5 rounded-2xl bg-zinc-900/40 border border-zinc-800/60 backdrop-blur-xl hover:border-purple-500/20 transition-all duration-300 flex flex-col justify-between">
          <div className="flex items-start gap-4">
            <div className="p-3 bg-indigo-500/10 rounded-xl text-indigo-400">
              <FileText className="w-5 h-5" />
            </div>
            <div>
              <h4 className="font-bold text-zinc-200 text-sm">Ferramentas Avançadas</h4>
              <p className="text-xs text-zinc-500 mt-1 leading-relaxed">
                Adiciona o menu de contexto &quot;Tomar Posse&quot; para arquivos/pastas ou realiza o backup completo de drivers instalados em C:\Backup_Drivers.
              </p>
            </div>
          </div>
          <div className="flex gap-3 pt-4 border-t border-zinc-800/50 mt-6">
            <button
              onClick={() => runAction("ownership", "SetTakeOwnership")}
              disabled={activeActions["ownership"]}
              className="flex-1 py-2 rounded-xl bg-zinc-850 hover:bg-zinc-800 border border-zinc-800 hover:border-zinc-750 text-xs font-bold transition-all flex items-center justify-center gap-1.5 text-zinc-300"
            >
              {activeActions["ownership"] ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : "Tomar Posse"}
            </button>
            <button
              onClick={() => runAction("backup", "BackupDrivers")}
              disabled={activeActions["backup"]}
              className="flex-1 py-2 rounded-xl bg-zinc-850 hover:bg-zinc-800 border border-zinc-800 hover:border-zinc-750 text-xs font-bold transition-all flex items-center justify-center gap-1.5 text-zinc-300"
            >
              {activeActions["backup"] ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : "Backup Drivers"}
            </button>
          </div>
        </div>

      </div>

      {/* Resultados de feedback */}
      <AnimatePresence>
        {Object.keys(results).length > 0 && (
          <div className="mt-8 space-y-3">
            <h3 className="text-xs font-bold text-zinc-400 tracking-wider uppercase flex items-center justify-between">
              <span>Relatório de Ações do Sistema</span>
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
                      : value.Status === "Warning"
                      ? "bg-amber-500/10 border-amber-500/20 text-amber-400"
                      : "bg-red-500/10 border-red-500/20 text-red-400"
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
                    <span className="font-extrabold capitalize text-zinc-200 block">{key}: {value.Status}</span>
                    <span className="text-zinc-400 mt-1 block">{value.Message}</span>
                    {value.BestDNS && (
                      <span className="text-[10px] text-cyan-400 font-semibold block mt-1">
                        Melhor servidor encontrado: {value.BestDNS}
                      </span>
                    )}
                    {value.Destination && (
                      <span className="text-[10px] text-indigo-400 font-semibold block mt-1">
                        Destino: {value.Destination}
                      </span>
                    )}
                    {value.RemovedApps && value.RemovedApps.length > 0 && (
                      <div className="mt-2 flex flex-wrap gap-1">
                        {value.RemovedApps.map((app, idx) => (
                          <span key={idx} className="text-[9px] bg-zinc-950/60 border border-zinc-800 text-zinc-500 px-1.5 py-0.5 rounded">
                            {app}
                          </span>
                        ))}
                      </div>
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
