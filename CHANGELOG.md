# Changelog

Todas as mudanças e evoluções do System Optimizer serão documentadas aqui.

## [v56.0] - A Era Global & Lite Mode
### Adicionado
- **Suporte Multi-idioma (i18n)**: Implementação de arquitetura baseada em Dicionário de Variáveis (Hash Table). O sistema agora suporta nativamente PT-BR, EN, ES e FR no Menu Principal, salvando a preferência do usuário automaticamente no arquivo `lang.ini`.
- **Modo Lite (Otimização para HDDs)**: Nova rotina de limpeza desenvolvida para computadores antigos e Discos Rígidos mecânicos (HDD). Exclui a execução de comandos agressivos (como TRIM de SSD e limpeza forçada do Working Set da RAM) que causavam lentidão temporária em discos mais antigos.
- **Auto-Sync Completo**: A ferramenta interna de atualização agora baixa e sincroniza de forma independente o Motor PowerShell, o `CHANGELOG.md` e o `README.md` locais.

### Modificado
- Reformulação visual do Menu Principal para abrigar as variáveis de tradução sem poluir a lógica de execução.

## [v55.0] - A Era Titan Legacy
### Adicionado
- **Menu Advanced**: Nova página de ferramentas contendo funções profundas e experimentais.
- **DirectX Shader Reset**: Limpeza de caches da AMD/NVIDIA para corrigir gagueiras (stuttering) em jogos.
- **OneDrive Destroyer**: Remoção agressiva do OneDrive, eliminando chaves de registro e pastas residuais ocultas.
- **Fixes de Sistema**: Ferramentas para resetar o cache de fontes (letras borradas) e o cache do Bluetooth (falha de pareamento).
- **Auto-Sync Changelog**: O script agora baixa automaticamente este arquivo `CHANGELOG.md` para a sua máquina ao se atualizar, mantendo você informado offline.

### Modificado
- Reestruturação de nomenclatura profissional: `LIMPAR_PC.bat` virou `SystemOptimizer.bat` e `MotorLimpeza.ps1` virou `OptimizerCore.ps1`.
- Blindagem da variável de caminho (`$PSScriptRoot`) para evitar falhas críticas quando o script é executado via atalhos administrativos.

## [v54.0] - Titan Ultimate
### Adicionado
- Função `Take Ownership` no menu de contexto (Botão Direito).
- **RAM Auto-Clean**: Processo imperceptível em segundo plano (Job) que esvazia o Working Set a cada 10 minutos.
- Inclusão rápida de pastas na exclusão do Windows Defender.

### Corrigido
- Bug crítico no Auto-Updater onde a variável `$MyInvocation` retornava nula em menus dinâmicos.

## [v53.0 e Anteriores] - A Fundação e Ferramentaria
- Transição completa de interface estática para CLI responsiva.
- Injeção direta de código C# (Add-Type) para invocar APIs do Windows (ntdll.dll e psapi.dll).
- Implementação da leitura dinâmica de RAM via WMI com alertas de velocidade (XMP).
- Implementação do sistema de Auto-Update OTA (Over-The-Air) via GitHub (TLS 1.2).
