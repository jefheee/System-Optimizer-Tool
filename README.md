# 🚀 System Optimizer & Command Center

Um utilitário CLI (Command Line Interface) robusto e automatizado, desenvolvido em **PowerShell** e **Batch**, voltado para a limpeza profunda, redução de latência e otimização de performance do Windows (10 e 11).

Este projeto nasceu da necessidade de unificar dezenas de ferramentas de otimização espalhadas pela internet em um único hub intuitivo, seguro e rápido.

<img width="956" height="619" alt="image" src="https://github.com/user-attachments/assets/dcfa7082-521f-47dc-97b6-cb1fd34a00f9" />

## 🧠 Como este projeto foi construído

Este script é resultado da união entre **conhecimento de domínio** e **Inteligência Artificial**. 

A arquitetura, a lógica de quais chaves de registro modificar, a escolha das ferramentas (MAS, WinUtil) e a estrutura de UX foram desenhadas por mim (**Jefherson**), enquanto a IA (**Gemini**) foi utilizada como *Pair Programmer* para refinar a sintaxe avançada do PowerShell, injetar código C# e garantir um tratamento de erros (*Error Handling*) impecável.

---

## ⚡ Funcionalidades Principais

### 1. Otimização Inteligente (SSD & HDD)
* **Smart Cleanup:** Limpa arquivos temporários, logs do sistema, relatórios de erro e cache de navegadores, exibindo em tempo real os **Megabytes (MB) liberados**.
* **Modo Lite (Novo):** Uma rotina de limpeza segura desenvolvida especificamente para **HDDs e PCs antigos**, evitando comandos agressivos que poderiam causar lentidão em discos mecânicos.
* **RAM & Storage Boost:** Otimiza a memória RAM esvaziando o *Working Set* de processos em background e executa o comando TRIM para prolongar a vida útil de SSDs.

<img width="957" height="922" alt="image" src="https://github.com/user-attachments/assets/6675c880-a450-4dee-87f6-b1f86f2930c7" />

### 2. Gaming Toolkit (Foco em Baixa Latência)
* **Timer Resolution (0.5ms):** Injeta código **C#** nativo para forçar o relógio do Windows a operar na latência mínima (0.5ms), reduzindo o *input lag* em jogos competitivos.
* **DirectX Shader Reset:** Ferramenta para limpar caches de shaders (AMD/NVIDIA), corrigindo engasgos (*stuttering*) após atualizações de drivers ou jogos.
* **Game Booster:** Altera a prioridade da CPU para "Alta" de forma permanente e desativa as "Otimizações de Tela Cheia" (FSO) para melhorar a estabilidade do FPS.
* **Network Tweaks:** Otimiza o registro TCP e ativa o RSS para garantir a melhor vazão de rede possível em partidas online.

<img width="958" height="727" alt="image" src="https://github.com/user-attachments/assets/3bbc3948-ae03-4ac4-bcdf-09f1a062f96c" />

### 3. Ferramentas de Sistema & Backup
* **Driver Backup (Novo):** Exporta todos os drivers instalados na máquina (Rede, Áudio, Vídeo) para a pasta `C:\Backup_Drivers`, facilitando a restauração após uma formatação.
* **OneDrive Destroyer:** Utilitário para remoção completa do OneDrive, eliminando o aplicativo e resquícios de chaves de registro.
* **System Fixes:** Atalhos integrados para reparar o **Windows Update**, resetar o cache de fontes borradas e corrigir falhas de pareamento Bluetooth.
* **WinUtil & Ativador MAS:** Acesso direto a scripts de debloat avançado e licenciamento permanente.

<img width="956" height="785" alt="image" src="https://github.com/user-attachments/assets/27e8d1c3-1b6a-45b7-b2fe-8924ef534974" />

### 4. Customização & Internacionalização (i18n)
* **Multi-idioma Nativo (JSON):** Suporte estrutural a 7 idiomas através de um dicionário externo (**`lang.json`**), permitindo a troca instantânea entre Português, Inglês, Espanhol, Francês, Alemão, Russo e Chinês.
* **Temas Visuais:** Menu de Ajustes que permite personalizar a cor do terminal (Cyan, Matrix Green ou Neon Magenta).
* **Auto-Update Completo:** Sistema de sincronização que baixa automaticamente o motor, o lançador (.bat), o manual e as notas de versão diretamente do repositório.

<img width="1592" height="943" alt="image" src="https://github.com/user-attachments/assets/89b184b2-2837-4fd6-83bc-88313c264a66" />

### 5. Diagnóstico Dinâmico de Hardware
* Leitura WMI em tempo real de CPU, GPU, Placa-Mãe e integridade dos discos.
* **RAM Scanner:** Detecta pentes individuais e alerta caso a frequência (MHz) esteja operando abaixo do esperado (XMP desativado na BIOS).

<img width="959" height="931" alt="image" src="https://github.com/user-attachments/assets/73610038-6f21-41f8-8d31-b73b12768f14" />

---

## 🛠️ Como Usar

1.  Baixe a última versão na aba de **Releases** do GitHub.
2.  Extraia o conteúdo do arquivo `.zip` ou `.rar` para uma pasta.
3.  Execute o arquivo **`SystemOptimizer.bat`**.
4.  O script solicitará privilégios de Administrador automaticamente. Confirme.
5.  Selecione seu idioma preferido no primeiro acesso (visual de pirâmide invertida).

---

## 📜 Histórico de Evolução

O projeto evoluiu de scripts básicos de limpeza de 2020 para uma aplicação robusta.

* **v55.0 - v58.0 (A Era Global & Customização):** Implementação de JSON externo para idiomas, Modo Lite para HDDs, Backup de Drivers, Criador de Atalhos e sistema de Temas.
* **v41.0 - v54.0 (Titan & C#):** Injeção de APIs `ntdll.dll` e `psapi.dll`, interface CLI responsiva e diagnóstico avançado de hardware.
* **v1.0 - v30.0 (A Fundação):** Scripts baseados em arquivos de lote (.bat) focados em exclusão básica de arquivos temporários (`deltree`, `rd`).

---
*Desenvolvido por Jefherson Luiz.*
