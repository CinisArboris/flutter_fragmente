# Ruta al APK construido
$apkSourcePath = "build/app/outputs/flutter-apk/app-release.apk"

# Ruta de destino para el APK
# $apkDestDir = "../../firebase-hosting/public/latest"
$apkDestDir = "C:\Users\evargasm\Documents\git\firebase-hosting\public\latest"
$datePrefix = Get-Date -Format "dd_MM_yyyy"
$apkDestPath = "$apkDestDir/mi_movil_$datePrefix.apk"

# Crear la carpeta de destino si no existe
if (-Not (Test-Path -Path $apkDestDir)) {
    New-Item -ItemType Directory -Path $apkDestDir
}

# Mover el APK al destino con un prefijo de fecha
Copy-Item -Path $apkSourcePath -Destination $apkDestPath

Write-Host "APK movido a $apkDestPath"
