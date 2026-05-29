# =================================================================
# SYSTEM OPTIMIZER - LANG MANAGER MODULE (TRANSLATION ENGINE)
# =================================================================

$CliFolder = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot "..\..\cli"))
$LangJsonPath = Join-Path $CliFolder "lang.json"
$PrefFile = Join-Path $CliFolder "lang.ini"

# Carrega o dicionário JSON de traduções
if (Test-Path $LangJsonPath) {
    try {
        $global:Dict = Get-Content $LangJsonPath -Raw | ConvertFrom-Json
    } catch {
        throw "ERRO: O arquivo lang.json esta corrompido ou mal formatado. ($($_.Exception.Message))"
    }
} else {
    throw "ERRO CRITICO: O arquivo 'lang.json' nao foi encontrado no diretorio do programa!"
}

# Inicializa o idioma preferido do usuário
if (Test-Path $PrefFile) {
    $global:UserLang = (Get-Content $PrefFile).Trim()
} else {
    $global:UserLang = "PT"
    Set-Content $PrefFile "PT" -Force
}

# Valida se o idioma carregado é válido no dicionário, aplicando EN como fallback seguro
# Correção de bug de variável não inicializada
$LanguageExists = $null -ne $global:Dict.$global:UserLang
if (-not $LanguageExists) {
    $global:UserLang = "EN"
    Set-Content $PrefFile "EN" -Force
}

# Obtém a tradução para a chave especificada
function Get-AppText {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Key
    )
    try {
        $Val = $global:Dict.$global:UserLang.$Key
        if ($Val) { return $Val } else { return "[$Key]" }
    } catch {
        return "[$Key]"
    }
}
