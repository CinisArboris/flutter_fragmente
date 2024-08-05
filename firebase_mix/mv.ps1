# Ruta al APK construido (cambiar a app-debug.apk)
$apkSourcePath = "build/app/outputs/flutter-apk/app-debug.apk"

# Verificar si el archivo fuente existe
if (-Not (Test-Path -Path $apkSourcePath)) {
    Write-Host "El archivo fuente no existe: $apkSourcePath"
    exit 1
}

# Ruta de destino para el APK
$apkDestDir = "C:\Users\eyver\Documents\git\firebase-hosting-mi-movil\public\latest"
$apkDestPath = "$apkDestDir\app-debug.apk"

# Crear la carpeta de destino si no existe
try {
    if (-Not (Test-Path -Path $apkDestDir)) {
        New-Item -ItemType Directory -Path $apkDestDir -Force
        Write-Host "Directorio creado: $apkDestDir"
    }
} catch {
    Write-Host "Error al crear el directorio: $_"
    exit 1
}

# Copiar el APK al destino
try {
    Copy-Item -Path $apkSourcePath -Destination $apkDestPath -Force
    Write-Host "APK movido a $apkDestPath"
} catch {
    Write-Host "Error al copiar el APK: $_"
    exit 1
}
