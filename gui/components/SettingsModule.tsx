'use client';

import { useState } from "react";
import { invokePowerShell, ActionResponse } from "../lib/api";
import { motion, AnimatePresence } from "framer-motion";
import { 
  Sliders, 
  Languages, 
  Palette, 
  RotateCcw, 
  Loader2, 
  CheckCircle2, 
  XCircle
} from "lucide-react";

export default function SettingsModule() {
  const [activeActions, setActiveActions] = useState<Record<string, boolean>>({});
  const [results, setResults] = useState<Record<string, ActionResponse>>({});

  const [currentLang, setCurrentLang] = useState("PT");
  const [currentTheme, setCurrentTheme] = useState("Cyan");

  const runAction = async (actionId: string, actionName: string, args: string) => {
    setActiveActions(prev => ({ ...prev, [actionId]: true }));
    try {
      const res = await invokePowerShell<ActionResponse>(actionName, args);
      setResults(prev => ({ ...prev, [actionId]: res }));
      if (res.Status === "Success") {
        if (actionName === "SetLanguage") {
          setCurrentLang(args);
        } else if (actionName === "SetTheme") {
          setCurrentTheme(args);
        } else if (actionName === "ResetSettings") {
          setCurrentLang("PT");
          setCurrentTheme("Cyan");
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

  const languages = [
    { code: "PT", name: "Português" },
    { code: "EN", name: "English" },
    { code: "ES", name: "Español" },
    { code: "FR", name: "Français" },
    { code: "DE", name: "Deutsch" },
    { code: "RU", name: "Русский" },
    { code: "CN", name: "中文" }
  ];

  const themes = [
    { name: "Cyan", class: "bg-cyan-500 text-cyan-200" },
    { name: "Green", class: "bg-emerald-500 text-emerald-200" },
    { name: "Magenta", class: "bg-purple-600 text-purple-200" }
  ];

  return (
    <div className="space-y-8">
      <div>
        <h2 className="text-xl font-extrabold text-zinc-100 tracking-tight flex items-center gap-2">
          <Sliders className="w-5 h-5 text-blue-400" />
          Configurações de Preferências
        </h2>
        <p className="text-xs text-zinc-500 mt-1">
          Ajuste as preferências gerais do System Optimizer, como idioma de tradução e temas de cor.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        
        {/* Idioma (SetLanguage) */}
        <div className="p-6 rounded-2xl bg-zinc-900/40 border border-zinc-800/60 backdrop-blur-xl hover:border-blue-500/20 transition-all duration-300 space-y-4">
          <div className="flex items-center gap-3">
            <div className="p-3 bg-blue-500/10 rounded-xl text-blue-400">
              <Languages className="w-5 h-5" />
            </div>
            <h3 className="font-bold text-zinc-200">Selecionar Idioma</h3>
          </div>
          <p className="text-xs text-zinc-500 leading-relaxed">
            Selecione o idioma de tradução dos scripts internos. O idioma escolhido será gravado no arquivo de preferência local do PowerShell.
          </p>
          <div className="flex flex-wrap gap-2 pt-2">
            {languages.map(lang => (
              <button
                key={lang.code}
                onClick={() => runAction("lang", "SetLanguage", lang.code)}
                disabled={activeActions["lang"] || currentLang === lang.code}
                className={`px-3 py-1.5 rounded-lg text-xs font-semibold border transition-all ${
                  currentLang === lang.code
                    ? "bg-blue-500/10 border-blue-500/30 text-blue-400 font-bold"
                    : "bg-zinc-850 border-zinc-800 text-zinc-400 hover:text-zinc-250 hover:border-zinc-700"
                }`}
              >
                {lang.name}
              </button>
            ))}
          </div>
        </div>

        {/* Tema Visual (SetTheme) */}
        <div className="p-6 rounded-2xl bg-zinc-900/40 border border-zinc-800/60 backdrop-blur-xl hover:border-blue-500/20 transition-all duration-300 space-y-4">
          <div className="flex items-center gap-3">
            <div className="p-3 bg-blue-500/10 rounded-xl text-blue-400">
              <Palette className="w-5 h-5" />
            </div>
            <h3 className="font-bold text-zinc-200">Tema do Terminal CLI</h3>
          </div>
          <p className="text-xs text-zinc-500 leading-relaxed">
            Selecione o tema de cores padrão que o console do PowerShell utilizará ao ser executado em modo híbrido interativo.
          </p>
          <div className="flex gap-2 pt-2">
            {themes.map(t => (
              <button
                key={t.name}
                onClick={() => runAction("theme", "SetTheme", t.name)}
                disabled={activeActions["theme"] || currentTheme === t.name}
                className={`flex-1 py-2 rounded-lg text-xs font-bold border transition-all ${
                  currentTheme === t.name
                    ? "bg-blue-500/10 border-blue-500/30 text-blue-400"
                    : "bg-zinc-850 border-zinc-800 text-zinc-400 hover:text-zinc-250 hover:border-zinc-700"
                }`}
              >
                {t.name}
              </button>
            ))}
          </div>
        </div>

      </div>

      {/* Restauração de Configurações */}
      <div className="p-6 rounded-2xl bg-zinc-900/20 border border-zinc-900 flex items-center justify-between hover:border-red-500/10 transition-all duration-300 flex-wrap gap-4">
        <div className="flex items-start gap-4">
          <div className="p-3 bg-red-500/10 rounded-xl text-red-500">
            <RotateCcw className="w-5 h-5" />
          </div>
          <div>
            <h4 className="font-bold text-zinc-200 text-sm">Resetar Configurações</h4>
            <p className="text-xs text-zinc-500 mt-1 leading-relaxed">
              Exclui os arquivos de preferências (`lang.ini` e `theme.txt`) restaurando o programa aos padrões originais.
            </p>
          </div>
        </div>
        <button
          onClick={() => runAction("reset", "ResetSettings", "")}
          disabled={activeActions["reset"]}
          className="px-4 py-2.5 rounded-xl bg-zinc-850 hover:bg-zinc-800 border border-zinc-800 hover:border-zinc-750 text-xs font-bold text-red-400 hover:text-red-300 transition-all flex items-center gap-1.5"
        >
          {activeActions["reset"] ? (
            <Loader2 className="w-3.5 h-3.5 animate-spin" />
          ) : (
            "Restaurar Padrões"
          )}
        </button>
      </div>

      {/* Resultados de feedback */}
      <AnimatePresence>
        {Object.keys(results).length > 0 && (
          <div className="mt-8 space-y-3">
            <h3 className="text-xs font-bold text-zinc-400 tracking-wider uppercase flex items-center justify-between">
              <span>Relatório de Configurações</span>
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
                    <span className="font-extrabold capitalize text-zinc-200 block">{key}: {value.Status}</span>
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
