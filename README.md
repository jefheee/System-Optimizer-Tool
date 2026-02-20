#  System Optimizer & Command Center

Uma ferramenta de automação e otimização de sistema "All-in-One" desenvolvida em PowerShell e Batch Scripting. Projetada para gamers e entusiastas que buscam desempenho máximo e manutenção simplificada.

##  Funcionalidades Principais
* **Otimização Inteligente:** Limpeza profunda de cache, logs e arquivos temporários com cálculo de espaço em tempo real.
* **Gaming Toolkit:** Redução de latência (Timer Resolution 0.5ms), otimização de mouse (1:1), unparking de núcleos de CPU e tweaks de rede.
* **Diagnóstico de Hardware Dinâmico:** Leitura direta da BIOS/WMI para identificar modelos exatos de RAM, GPU e saúde de SSDs/HDs.
* **Ferramentas de Sistema:** Integração com WinUtil (Chris Titus), reparo de Windows Update, Spooler de Impressão e Ativação MAS.

##  Tecnologias Utilizadas
* **PowerShell Scripting:** Lógica principal, manipulação de WMI, Registro do Windows e automação.
* **Batch Scripting:** Bootstrapper para elevação automática de privilégios (Admin).
* **Win32 APIs (C# Injection):** Uso de `ntdll.dll` e `psapi.dll` para otimização de memória RAM e Timer Resolution em baixo nível.

##  Instalação
1. Baixe o arquivo ZIP.
2. Execute o `LIMPAR_PC.bat` (Ele solicitará permissão de Admin automaticamente).
3. Navegue pelo menu interativo.
