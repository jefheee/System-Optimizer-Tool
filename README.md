#  System Optimizer & Command Center

Um utilitário CLI (Command Line Interface) robusto e automatizado, desenvolvido em **PowerShell** e **Batch**, voltado para a limpeza profunda, redução de latência e otimização de performance do Windows (10 e 11).

Este projeto nasceu da necessidade de unificar dezenas de ferramentas de otimização espalhadas pela internet em um único hub intuitivo, seguro e rápido.

<img width="956" height="619" alt="image" src="https://github.com/user-attachments/assets/dcfa7082-521f-47dc-97b6-cb1fd34a00f9" />

##  Como este projeto foi construído
Este script é resultado da união entre **conhecimento de domínio** e **Inteligência Artificial**. A arquitetura, a lógica de quais chaves de registro modificar, a escolha das ferramentas (MAS, WinUtil) e a estrutura de UX foram desenhadas por mim (Jefherson), enquanto a IA (Gemini) foi utilizada como *Pair Programmer* para refinar a sintaxe do PowerShell, injetar código C# e garantir o tratamento de erros (Error Handling) impecável.

---

##  Funcionalidades Principais

###  1. Otimização e Faxina Profunda
* **Smart Cleanup:** Limpa arquivos temporários, logs do sistema, relatórios de erros, cache de navegadores e a Lixeira do Windows, calculando e exibindo em tempo real os **Megabytes (MB) liberados**.
* **RAM & Storage Boost:** Otimiza a memória RAM esvaziando o *Working Set* de processos em background e executa o comando TRIM para prolongar a vida útil de SSDs.
* **Network Tweaks:** Ativa o RSS e o *Auto-Tuning* TCP para melhor vazão de rede.

<img width="957" height="922" alt="image" src="https://github.com/user-attachments/assets/6675c880-a450-4dee-87f6-b1f86f2930c7" />

###  2. Gaming Toolkit (Foco em Baixa Latência)
* **Timer Resolution (0.5ms):** Injeta código C# nativo para forçar o relógio do Windows a operar na latência mínima (0.5ms), reduzindo o input lag em jogos competitivos.
* **Game Booster:** Altera a prioridade da CPU do seu jogo favorito para "Alta" via Registro, de forma permanente.
* **Desativador de FSO:** Desliga as "Otimizações de Tela Cheia" globais, melhorando a velocidade do *Alt+Tab*.
* **FilterKeys Fix:** Reduz o atraso de repetição das teclas para movimentação mais ágil.
* **Smart Shutdown:** Monitora o uso de Rede e CPU. Desliga o PC automaticamente quando um download longo ou descompactação pesada termina.
* **Jitter Test:** Ferramenta de disparo rápido de ping para calcular a oscilação da internet.

<img width="958" height="727" alt="image" src="https://github.com/user-attachments/assets/3bbc3948-ae03-4ac4-bcdf-09f1a062f96c" />

###  3. Ferramentas de Sistema e Reparo
* **WinUtil Integrado:** Atalho para a ferramenta de debloat avançada do *Chris Titus Tech*.
* **Windows Update Fix:** Reinicia serviços e limpa o diretório `SoftwareDistribution` para destravar atualizações.
* **Task & Event Cleaner:** Apaga "Gatilhos Órfãos" no Agendador de Tarefas e limpa anos de logs inúteis no Visualizador de Eventos.
* **DNS Jumper:** Testa o ping do Google e Cloudflare e aplica o melhor automaticamente.
* **Ativador MAS:** Acesso direto ao *Microsoft Activation Scripts* para licenciamento do sistema.

<img width="956" height="785" alt="image" src="https://github.com/user-attachments/assets/27e8d1c3-1b6a-45b7-b2fe-8924ef534974" />

<img width="1592" height="943" alt="image" src="https://github.com/user-attachments/assets/89b184b2-2837-4fd6-83bc-88313c264a66" />


###  4. Diagnóstico de Hardware Dinâmico
* Leitura WMI em tempo real. Identifica o modelo exato do Processador, Placa de Vídeo, Placa-Mãe e a saúde (S.M.A.R.T) dos discos (NVMe/SSD/HDD).
* **RAM Scanner:** Detecta cada pente de memória individualmente, somando a capacidade e avisando caso a velocidade (MHz) esteja muito baixa (indicando que o XMP está desligado na BIOS).

  <img width="959" height="931" alt="image" src="https://github.com/user-attachments/assets/73610038-6f21-41f8-8d31-b73b12768f14" />

---

##  Como Usar

1. Baixe os arquivos do repositório ou clone-o: `git clone https://github.com/jefheee/System-Optimizer-Tool.git`
2. Extraia os arquivos para uma pasta.
3. Dê um duplo clique no arquivo **`SystemOptimizer.bat`**.
4. O script solicitará privilégios de Administrador automaticamente. Confirme.
5. Navegue pelo menu utilizando os números do teclado.

> **Nota:** Nenhuma ferramenta permanente (como otimização de registro) é aplicada sem o seu comando. Há uma aba **REVERSOR (UNDO)** no menu para restaurar as configurações padrão do Windows caso necessário.

---

##  Histórico de Evolução (Changelog)

O projeto passou por dezenas de iterações, evoluindo de um simples arquivo em lote para uma aplicação híbrida avançada.

* **v41.0 a Atual (A Era Titan & C#):**
  * Transição completa de interface estática para CLI responsiva com alinhamento dinâmico e suporte a blocos de caracteres estendidos.
  * Injeção direta de código **C#** (`Add-Type`) para invocar APIs do Windows (`ntdll.dll` e `psapi.dll`), permitindo manipulação direta do *Timer Resolution* e do *Working Set* da RAM sem uso de softwares de terceiros.
  * Implementação da leitura dinâmica de RAM via classes do WMI com alertas de XMP.
  * Criação do algoritmo *Smart Shutdown* com tolerância a picos de CPU.
* **v31.0 - v40.0 (A Era da Ferramentaria):**
  * Migração estrutural de `.bat` puro para PowerShell acionado por `.bat` (Bypass Wrapper).
  * Inclusão do Menu de Reversão de danos (Undo Mode).
  * Adição de ferramentas de conectividade (DNS Jumper), Backup Inteligente de Saves (caçando pastas dinâmicas em `AppData` e `Documents`) e Mouse Hz Tester.
* **v1.0 - v30.0 (A Fundação):**
  * Scripts iniciais baseados inteiramente em arquivos de lote (.bat).
  * Foco em rotinas de exclusão forçada (Temp, Prefetch) e reparo básico de imagem via `sfc` e `dism`.

---
*Desenvolvido por Jefherson Luiz.*
