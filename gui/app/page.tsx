'use client';

import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { 
  Cpu, 
  Trash2, 
  Gamepad2, 
  Settings, 
  Info,
  Shield,
  Activity
} from "lucide-react";

// Módulos
import DashboardModule from "../components/DashboardModule";
import GamerModule from "../components/GamerModule";
import SystemModule from "../components/SystemModule";
import CleanModule from "../components/CleanModule";
import AboutModule from "../components/AboutModule";

type Tab = "dashboard" | "gamer" | "system" | "clean" | "about";

export default function Page() {
  const [activeTab, setActiveTab] = useState<Tab>("dashboard");

  const menuItems = [
    { id: "dashboard", label: "Dashboard", icon: Cpu, color: "text-cyan-400" },
    { id: "gamer", label: "Gamer Latency", icon: Gamepad2, color: "text-emerald-400" },
    { id: "system", label: "Sistema & Reparos", icon: Settings, color: "text-purple-400" },
    { id: "clean", label: "Limpeza de Disco", icon: Trash2, color: "text-orange-400" },
    { id: "about", label: "Sobre o App", icon: Info, color: "text-zinc-400" }
  ] as const;

  const renderModule = () => {
    switch (activeTab) {
      case "dashboard":
        return <DashboardModule />;
      case "gamer":
        return <GamerModule />;
      case "system":
        return <SystemModule />;
      case "clean":
        return <CleanModule />;
      case "about":
        return <AboutModule />;
    }
  };

  return (
    <main className="min-h-screen bg-black text-zinc-300 font-sans selection:bg-cyan-500/30 selection:text-cyan-200 flex relative overflow-hidden">
      
      {/* Luzes decorativas de fundo (Aesthetics Glow Orbs) */}
      <div className="absolute top-[-10%] left-[20%] w-[600px] h-[600px] bg-cyan-500/5 rounded-full blur-[130px] pointer-events-none -z-10 animate-pulse" />
      <div className="absolute bottom-[-10%] right-[10%] w-[600px] h-[600px] bg-purple-500/5 rounded-full blur-[130px] pointer-events-none -z-10" />

      {/* Sidebar Esquerda (Fixa) */}
      <aside className="w-64 border-r border-zinc-900/80 bg-zinc-950/80 backdrop-blur-xl shrink-0 flex flex-col justify-between p-6 z-40">
        <div className="space-y-8">
          {/* Logo Header */}
          <div className="flex items-center gap-3">
            <div className="w-9 h-9 rounded-xl bg-gradient-to-tr from-cyan-500 to-purple-600 flex items-center justify-center text-white font-extrabold text-base shadow-lg shadow-cyan-500/20 shrink-0">
              S
            </div>
            <div>
              <h1 className="font-extrabold text-zinc-100 text-sm tracking-tight leading-none">System Optimizer</h1>
              <span className="text-[9px] font-bold text-zinc-500 tracking-wider uppercase block mt-1">Web Control Panel</span>
            </div>
          </div>

          {/* Menu de Navegação */}
          <nav className="space-y-1.5">
            {menuItems.map((item) => {
              const Icon = item.icon;
              const isActive = activeTab === item.id;
              return (
                <button
                  key={item.id}
                  onClick={() => setActiveTab(item.id)}
                  className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-semibold tracking-wide transition-all duration-300 relative group ${
                    isActive 
                      ? "text-cyan-400 bg-cyan-500/10 border-l-2 border-cyan-500 shadow-[inset_0_1px_0_0_rgba(255,255,255,0.05)]" 
                      : "text-zinc-400 hover:text-zinc-200 hover:bg-zinc-900/50"
                  }`}
                >
                  <Icon className={`w-4 h-4 transition-transform duration-350 group-hover:scale-110 shrink-0 ${isActive ? 'text-cyan-400' : 'text-zinc-500'}`} />
                  {item.label}
                  {isActive && (
                    <motion.div 
                      layoutId="sidebar-active-indicator" 
                      className="absolute right-3 w-1.5 h-1.5 rounded-full bg-cyan-500 shadow-glow"
                      transition={{ type: "spring", stiffness: 300, damping: 30 }}
                    />
                  )}
                </button>
              );
            })}
          </nav>
        </div>

        {/* Footer da Sidebar */}
        <div className="border-t border-zinc-900/80 pt-4 flex items-center gap-2 text-[10px] font-semibold text-zinc-500">
          <Shield className="w-3.5 h-3.5 text-cyan-500" />
          <span>Privilégios de Administrador</span>
        </div>
      </aside>

      {/* Área de Conteúdo Direita (Rolável) */}
      <section className="flex-1 flex flex-col min-w-0 z-30">
        
        {/* Top Header Barra */}
        <header className="h-16 border-b border-zinc-900/80 backdrop-blur-md bg-black/40 flex items-center justify-between px-8">
          <div className="flex items-center gap-2">
            <span className="text-[10px] bg-zinc-900 border border-zinc-800 text-zinc-400 px-3 py-1 rounded-full flex items-center gap-1.5">
              <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse" />
              Tauri Webview Connect
            </span>
          </div>
          <div className="text-[10px] text-zinc-500 font-medium">
            System Optimizer v2.1.0 (64-bit)
          </div>
        </header>

        {/* Content Pane */}
        <div className="flex-1 overflow-y-auto px-8 py-8 max-w-5xl w-full mx-auto">
          <AnimatePresence mode="wait">
            <motion.div
              key={activeTab}
              initial={{ opacity: 0, y: 15 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -15 }}
              transition={{ duration: 0.25, ease: "easeInOut" }}
            >
              {renderModule()}
            </motion.div>
          </AnimatePresence>
        </div>
      </section>

    </main>
  );
}
