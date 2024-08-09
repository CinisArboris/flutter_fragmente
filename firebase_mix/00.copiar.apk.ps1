# Ruta al APK construido
$apkSourcePath = "build/app/outputs/flutter-apk/app-release.apk"

# Ruta de destino para el APK
$apkDestDir = "C:\Users\evargasm\Documents\git\firebase-hosting-mi-movil\public\latest"
$apkDestPath = "$apkDestDir\mi_movil_prod.apk"

# Crear la carpeta de destino si no existe
if (-Not (Test-Path -Path $apkDestDir)) {
    New-Item -ItemType Directory -Path $apkDestDir -Force
}

# Copiar el APK al destino con el nombre especificado
Copy-Item -Path $apkSourcePath -Destination $apkDestPath -Force

Write-Host "APK copiado a $apkDestPath exitosamente."
