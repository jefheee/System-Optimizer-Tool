// =================================================================
// SYSTEM OPTIMIZER - TAURI CORE LIBRARY (RUST BACKEND INTERFACE)
// =================================================================

use std::process::Command;

#[cfg(target_os = "windows")]
use std::os::windows::process::CommandExt;

/// Executa um script PowerShell de forma silenciosa e retorna a string JSON de saída
#[tauri::command]
fn invoke_powershell(action: String, args: Option<String>) -> Result<String, String> {
    let args_str = args.unwrap_or_default();
    
    let mut command = Command::new("powershell.exe");
    command.arg("-NoProfile")
           .arg("-ExecutionPolicy")
           .arg("Bypass")
           .arg("-File")
           .arg("../src/core/API-Bridge.ps1")
           .arg("-Action")
           .arg(&action)
           .arg("-Args")
           .arg(&args_str);

    // Oculta completamente a janela de console do cmd/powershell no Windows
    #[cfg(target_os = "windows")]
    {
        // CREATE_NO_WINDOW = 0x08000000
        command.creation_flags(0x08000000);
    }

    match command.output() {
        Ok(output) => {
            let stdout = String::from_utf8_lossy(&output.stdout).trim().to_string();
            let stderr = String::from_utf8_lossy(&output.stderr).trim().to_string();

            if !output.status.success() {
                let code = output.status.code().unwrap_or(-1);
                return Err(format!(
                    "{{\"Status\":\"Error\",\"Message\":\"Erro no processo do PowerShell (Exit Code: {}). Stderr: {}\"}}",
                    code,
                    stderr.replace('"', "\\\"").replace('\n', " ")
                ));
            }

            if stdout.is_empty() {
                if !stderr.is_empty() {
                    return Err(format!(
                        "{{\"Status\":\"Error\",\"Message\":\"PowerShell nao gerou stdout, mas reportou erro. Stderr: {}\"}}",
                        stderr.replace('"', "\\\"").replace('\n', " ")
                    ));
                }
                return Err("{\"Status\":\"Error\",\"Message\":\"O PowerShell terminou sem retornar dados no stdout.\"}".to_string());
            }

            Ok(stdout)
        }
        Err(e) => {
            Err(format!(
                "{{\"Status\":\"Error\",\"Message\":\"Impossivel iniciar o executavel do powershell.exe: {}\"}}",
                e.to_string().replace('"', "\\\"")
            ))
        }
    }
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![invoke_powershell])
        .setup(|app| {
            if cfg!(debug_assertions) {
                app.handle().plugin(
                    tauri_plugin_log::Builder::default()
                        .level(log::LevelFilter::Info)
                        .build(),
                )?;
            }
            Ok(())
        })
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
