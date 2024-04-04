# thanos.ps1

# Obtener el directorio actual donde se ejecuta el script
$basePath = Get-Location

# Enumerar todos los directorios dentro del directorio actual
$directories = Get-ChildItem -Path $basePath -Directory

foreach ($dir in $directories) {
    # Cambiar al directorio
    Set-Location -Path $dir.FullName
    
    # Mostrar el directorio actual para fines de depuración
    Write-Host "Limpieza en: $($dir.FullName)"
    
    # Ejecutar flutter clean
    flutter clean
    
    # Regresar al directorio base para continuar con el siguiente ciclo
    Set-Location -Path $basePath
}

Write-Host "Limpieza completada."
