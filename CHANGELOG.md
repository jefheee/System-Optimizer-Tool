# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

## [v55] - 2026-02-21
### Adicionado
- **Menu Advanced**: Nova página de ferramentas contendo funções agressivas e experimentais.
- **DirectX Shader Reset**: Limpeza profunda de caches da AMD/NVIDIA para corrigir gagueiras (stuttering) em jogos competitivos.
- **OneDrive Destroyer**: Remoção completa do OneDrive, incluindo chaves de registro e pastas residuais ocultas.
- **Fixes de Sistema**: Ferramentas para resetar o cache de fontes (letras borradas) e o cache do Bluetooth (falha de pareamento).
### Modificado
- Reestruturação de nomenclatura profissional: `Launcher.bat` e `OptimizerCore.ps1`.
- Blindagem da variável de caminho (`$PSScriptRoot`) para evitar falhas quando executado via atalhos administrativos.

## [v54] - A Era Titan Ultimate
### Adicionado
- Função `Take Ownership` para adicionar permissões totais a pastas teimosas no menu de contexto do Windows.
- **RAM Auto-Clean**: Processo imperceptível em segundo plano (`Job`) que esvazia o Working Set a cada 10 minutos.
- Inclusão rápida de pastas na lista de exclusão do Windows Defender para poupar uso de disco durante a gameplay.
### Corrigido
- Bug crítico no Auto-Updater onde a variável `$MyInvocation` retornava nula, impedindo o download de novas versões.
- Correção no link de update para apontar diretamente para a versão RAW do repositório.

## [v52] - v53
### Adicionado
- Implementação do sistema de **Auto-Update OTA (Over-The-Air)** baixando as atualizações diretamente do repositório GitHub via TLS 1.2.
- Alerta visual no diagnóstico caso a memória RAM esteja operando em frequências baixas (indicando XMP desativado na BIOS).
