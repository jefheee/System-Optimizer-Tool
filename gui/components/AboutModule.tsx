'use client';

import { motion } from "framer-motion";
import { 
  Info, 
  Terminal, 
  ShieldCheck, 
  Globe, 
  Heart,
  Cpu
} from "lucide-react";

export default function AboutModule() {
  return (
    <div className="space-y-8">
      <div>
        <h2 className="text-xl font-extrabold text-zinc-100 tracking-tight flex items-center gap-2">
          <Info className="w-5 h-5 text-zinc-400" />
          Sobre o System Optimizer
        </h2>
        <p className="text-xs text-zinc-500 mt-1">
          Informações sobre o software, tecnologia empregada e licenciamento.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        
        {/* Info principal */}
        <div className="p-6 rounded-2xl bg-zinc-900/40 border border-zinc-800/60 backdrop-blur-xl md:col-span-2 space-y-6 hover:border-zinc-700/30 transition-all duration-300">
          <div className="flex items-center gap-4">
            <div className="w-12 h-12 rounded-2xl bg-gradient-to-tr from-cyan-500 to-purple-600 flex items-center justify-center text-white font-extrabold text-xl shadow-lg shadow-cyan-500/20 shrink-0">
              S
            </div>
            <div>
              <h3 className="font-extrabold text-zinc-100 text-base">System Optimizer Core</h3>
              <p className="text-xs text-zinc-500">Versão 2.1.0 &bull; Release Estável (x64)</p>
            </div>
          </div>

          <p className="text-xs text-zinc-400 leading-relaxed">
            O System Optimizer é um painel completo para simplificar a otimização de máquinas Windows. O projeto consolida scripts de automação robustos e boas práticas de ajustes de registro em uma interface limpa, rápida e segura utilizando o ecossistema Next.js, Tauri e PowerShell.
          </p>

          <div className="border-t border-zinc-800/50 pt-4 grid grid-cols-2 gap-4">
            <div className="space-y-1">
              <span className="text-[10px] text-zinc-500 font-semibold uppercase tracking-wider block">Arquitetura</span>
              <span className="text-xs font-bold text-zinc-300">Rust Tauri v2 + Win32 API</span>
            </div>
            <div className="space-y-1">
              <span className="text-[10px] text-zinc-500 font-semibold uppercase tracking-wider block">Script Bridge</span>
              <span className="text-xs font-bold text-zinc-300">PowerShell Engine 5.1+</span>
            </div>
          </div>
        </div>

        {/* Informações de Requisitos / Licença */}
        <div className="p-6 rounded-2xl bg-zinc-900/40 border border-zinc-800/60 backdrop-blur-xl space-y-6 hover:border-zinc-700/30 transition-all duration-300 flex flex-col justify-between">
          <div className="space-y-4">
            <h4 className="font-bold text-sm text-zinc-200 flex items-center gap-2">
              <ShieldCheck className="w-4 h-4 text-emerald-400" />
              Garantia de Segurança
            </h4>
            <p className="text-xs text-zinc-500 leading-relaxed">
              O otimizador opera localmente e não realiza chamadas externas não autorizadas. Todos os tweaks aplicados podem ser auditados inspecionando a pasta de código-fonte.
            </p>
          </div>

          <div className="flex flex-col gap-2 border-t border-zinc-800/50 pt-4">
            <a 
              href="https://github.com/jefheee/System-Optimizer-Tool" 
              target="_blank" 
              rel="noopener noreferrer"
              className="flex items-center justify-between text-xs font-semibold text-zinc-400 hover:text-zinc-200 transition-colors p-2 rounded-lg hover:bg-zinc-850"
            >
              <span className="flex items-center gap-2">
                <Globe className="w-4 h-4" />
                Repositório GitHub
              </span>
              &rarr;
            </a>
            <div className="flex items-center justify-between text-xs text-zinc-500 px-2">
              <span>Licença</span>
              <span className="font-bold text-zinc-400">MIT Open Source</span>
            </div>
          </div>
        </div>

      </div>

      {/* Créditos Rodapé */}
      <div className="p-5 rounded-2xl bg-zinc-900/20 border border-zinc-900 flex items-center justify-between flex-wrap gap-4">
        <p className="text-xs text-zinc-600 flex items-center gap-1.5 font-medium">
          Criado com <Heart className="w-3.5 h-3.5 text-red-500 fill-red-500" /> para a comunidade Open Source.
        </p>
        <div className="flex items-center gap-4 text-xs font-bold text-zinc-500">
          <span className="flex items-center gap-1.5">
            <Terminal className="w-3.5 h-3.5" />
            Tauri Sandbox
          </span>
          &bull;
          <span className="flex items-center gap-1.5">
            <Cpu className="w-3.5 h-3.5" />
            Hardware Acceleration
          </span>
        </div>
      </div>

    </div>
  );
}
