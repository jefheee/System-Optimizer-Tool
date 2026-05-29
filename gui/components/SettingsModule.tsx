'use client';

import { useState } from "react";
import { invokePowerShell, ActionResponse } from "../lib/api";
import { useI18n, Language } from "../lib/i18n";
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
  const { language: currentLang, setLanguage, t } = useI18n();
  const [currentTheme, setCurrentTheme] = useState("Cyan");

  const runAction = async (actionId: string, actionName: string, args: string) => {
    setActiveActions(prev => ({ ...prev, [actionId]: true }));
    try {
      const res = await invokePowerShell<ActionResponse>(actionName, args);
      setResults(prev => ({ ...prev, [actionId]: res }));
      if (res.Status === "Success") {
        if (actionName === "SetTheme") {
          setCurrentTheme(args);
        } else if (actionName === "ResetSettings") {
          setLanguage("PT");
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

  const changeLanguage = async (code: Language) => {
    setLanguage(code);
    await runAction("lang", "SetLanguage", code);
  };

  const languages: { code: Language; name: string }[] = [
    { code: "PT", name: "Português" },
    { code: "EN", name: "English" },
    { code: "ES", name: "Español" },
    { code: "FR", name: "Français" },
    { code: "DE", name: "Deutsch" },
    { code: "RU", name: "Русский" },
    { code: "CN", name: "中文" }
  ];

  const themes = [
    { name: "Cyan", class: "bg-primary/20 text-primary border-primary/30" },
    { name: "Green", class: "bg-tertiary/20 text-tertiary border-tertiary/30" },
    { name: "Magenta", class: "bg-secondary/20 text-secondary border-secondary/30" }
  ];

  return (
    <div className="space-y-8 animate-card-entry">
      <div>
        <h2 className="text-xl font-bold font-headline-lg text-[#e5e2e1] tracking-tight flex items-center gap-2">
          <Sliders className="w-5 h-5 text-primary" />
          {t("settings.title")}
        </h2>
        <p className="text-xs text-on-surface-variant mt-1">
          {t("settings.subtitle")}
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        
        {/* Idioma */}
        <div className="p-6 rounded-2xl glass-card hover:border-primary/20 transition-all duration-300 space-y-4">
          <div className="flex items-center gap-3">
            <div className="p-3 bg-primary/10 rounded-xl text-primary">
              <Languages className="w-5 h-5" />
            </div>
            <h3 className="font-bold text-zinc-200">{t("settings.lang.title")}</h3>
          </div>
          <p className="text-xs text-on-surface-variant leading-relaxed">
            {t("settings.lang.desc")}
          </p>
          <div className="flex flex-wrap gap-2 pt-2">
            {languages.map(lang => (
              <button
                key={lang.code}
                onClick={() => changeLanguage(lang.code)}
                disabled={activeActions["lang"] || currentLang === lang.code}
                className={`px-3 py-1.5 rounded-lg text-xs font-semibold border transition-all ${
                  currentLang === lang.code
                    ? "bg-primary/10 border-primary/30 text-primary font-bold shadow-[0_0_10px_rgba(76,215,246,0.15)]"
                    : "bg-surface-container border-white/5 text-zinc-400 hover:text-[#e5e2e1] hover:border-white/10"
                }`}
              >
                {lang.name}
              </button>
            ))}
          </div>
        </div>

        {/* Tema Visual (SetTheme) */}
        <div className="p-6 rounded-2xl glass-card hover:border-primary/20 transition-all duration-300 space-y-4">
          <div className="flex items-center gap-3">
            <div className="p-3 bg-primary/10 rounded-xl text-primary">
              <Palette className="w-5 h-5" />
            </div>
            <h3 className="font-bold text-zinc-200">{t("settings.theme.title")}</h3>
          </div>
          <p className="text-xs text-on-surface-variant leading-relaxed">
            {t("settings.theme.desc")}
          </p>
          <div className="flex gap-2 pt-2">
            {themes.map(tOption => (
              <button
                key={tOption.name}
                onClick={() => runAction("theme", "SetTheme", tOption.name)}
                disabled={activeActions["theme"] || currentTheme === tOption.name}
                className={`flex-1 py-2 rounded-lg text-xs font-bold border transition-all ${
                  currentTheme === tOption.name
                    ? `${tOption.class} font-bold`
                    : "bg-surface-container border-white/5 text-zinc-400 hover:text-[#e5e2e1] hover:border-white/10"
                }`}
              >
                {tOption.name}
              </button>
            ))}
          </div>
        </div>

      </div>

      {/* Restauração de Configurações */}
      <div className="p-6 rounded-2xl glass-card flex items-center justify-between border-white/5 hover:border-error/20 transition-all duration-300 flex-wrap gap-4">
        <div className="flex items-start gap-4">
          <div className="p-3 bg-error-container/20 border border-error/10 rounded-xl text-error">
            <RotateCcw className="w-5 h-5 animate-pulse" />
          </div>
          <div>
            <h4 className="font-bold text-zinc-200 text-sm">{t("settings.reset.title")}</h4>
            <p className="text-xs text-on-surface-variant mt-1 leading-relaxed">
              {t("settings.reset.desc")}
            </p>
          </div>
        </div>
        <button
          onClick={() => runAction("reset", "ResetSettings", "")}
          disabled={activeActions["reset"]}
          className="px-4 py-2.5 rounded-xl bg-surface-container hover:bg-surface-container-high border border-white/5 hover:border-[#ff5555]/20 text-xs font-bold text-error hover:shadow-[0_0_10px_rgba(255,85,85,0.1)] transition-all flex items-center gap-1.5"
        >
          {activeActions["reset"] ? (
            <Loader2 className="w-3.5 h-3.5 animate-spin" />
          ) : (
            t("settings.reset.btn")
          )}
        </button>
      </div>

      {/* Resultados de feedback */}
      <AnimatePresence>
        {Object.keys(results).length > 0 && (
          <div className="mt-8 space-y-3">
            <h3 className="text-xs font-bold text-on-surface-variant tracking-wider uppercase flex items-center justify-between">
              <span>{t("settings.log.title")}</span>
              <button 
                onClick={() => setResults({})}
                className="text-[10px] text-zinc-650 hover:text-zinc-400 transition-colors uppercase"
              >
                {t("settings.log.clear")}
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
                      : "bg-error-container/20 border-error/20 text-error"
                  }`}
                >
                  {value.Status === "Success" ? (
                    <CheckCircle2 className="w-4 h-4 shrink-0 mt-0.5" />
                  ) : (
                    <XCircle className="w-4 h-4 shrink-0 mt-0.5" />
                  )}
                  <div>
                    <span className="font-bold capitalize text-zinc-200 block">{key}: {value.Status}</span>
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
