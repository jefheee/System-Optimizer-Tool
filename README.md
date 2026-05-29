# 🚀 System Optimizer & Command Center

Um utilitário de otimização de sistema robusto, modular e de alto desempenho projetado para Windows (10 e 11). O projeto passou por uma evolução arquitetural completa, migrando de um monólito CLI para uma estrutura desacoplada baseada em uma **API Backend em PowerShell** e um **Frontend Moderno em Web GUI (Tauri + Next.js)**.

---

## 🏗️ Arquitetura do Projeto

O repositório está organizado de forma modular para isolar a interface de usuário da lógica de otimização:

*   **[`/src`](file:///c:/Projetos/System-Optimizer-Tool/src)**: Contém as bibliotecas puras de backend do PowerShell (`/src/modules/`) e utilitários (`/src/utils/`). Não há interação com console ou exibição de texto aqui. Tudo retorna objetos estruturados `[PSCustomObject]`.
*   **[`/gui`](file:///c:/Projetos/System-Optimizer-Tool/gui)**: A interface gráfica moderna construída com **Next.js (React)**, **TypeScript**, **Tailwind CSS** e **Framer Motion**, empacotada nativamente para Windows com **Tauri v2** em Rust.
*   **[`/cli`](file:///c:/Projetos/System-Optimizer-Tool/cli)**: O ecossistema CLI legado e interativo (arquivos `.bat` e `.ps1` de terminal) mantido para compatibilidade histórica.

---

## 🛠️ Como Executar e Compilar a Web GUI (Tauri)

Para testar e buildar a nova interface gráfica do **System Optimizer**, você deve interagir a partir do diretório `/gui`.

> [!WARNING]
> **NÃO execute comandos NPM na raiz do repositório.** A inicialização das ferramentas frontend deve ser feita estritamente dentro do diretório `/gui`.

### Pré-requisitos
Antes de iniciar, certifique-se de ter instalado:
1.  [Node.js](https://nodejs.org/) (Versão 18 ou superior)
2.  [Rust & Cargo](https://www.rust-lang.org/tools/install) (Para compilar o instalador nativo do Tauri)
3.  [C++ Build Tools do Visual Studio](https://visualstudio.microsoft.com/visual-cpp-build-tools/) (Requisito padrão do Tauri para compilar no Windows)

---

### Passos para Desenvolvimento e Build

#### 1. Navegar para a pasta da interface gráfica
Abra o terminal na raiz do projeto e execute:
```bash
cd gui
```

#### 2. Instalar as dependências do Next.js
Instale as bibliotecas necessárias para o painel de controle (React, Framer Motion, Lucide, Tailwind):
```bash
npm install
```

#### 3. Rodar o ambiente de desenvolvimento em tempo real
Inicie o servidor local do Next.js integrado com a janela nativa do Tauri. Qualquer alteração visual será refletida instantaneamente (Hot Reload):
```bash
npm run tauri dev
```

#### 4. Compilar o executável de produção (.exe)
Gere a versão final compactada, otimizada e sem consoles em segundo plano:
```bash
npm run tauri build
```

> [!TIP]
> Após o build ser concluído, o executável autônomo gerado estará localizado na pasta:
> **`gui/src-tauri/target/release/system-optimizer.exe`**

---

## 📜 Execução do Legado CLI (Terminal)

Para rodar a interface clássica do terminal, navegue até a pasta `/cli` e execute o lançador:
*   [SystemOptimizer.bat](file:///c:/Projetos/System-Optimizer-Tool/cli/SystemOptimizer.bat) (Executará solicitando direitos de administrador e desbloqueando as subpastas automaticamente).

---
*Desenvolvido por Jefherson Luiz & Antigravity.*
