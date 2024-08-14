# Definir la ruta de la carpeta
$cachePath = "C:\Users\eyver\AppData\Local\Pub\Cache\hosted\pub.dev\"

# Verificar si la carpeta existe
if (Test-Path $cachePath) {
    Write-Host "Eliminando el contenido de la carpeta Pub Cache..."
    
    # Eliminar todo el contenido dentro de la carpeta
    Get-ChildItem -Path $cachePath | Remove-Item -Recurse -Force
    
    Write-Host "Contenido de la carpeta Pub Cache eliminado."
} else {
    Write-Host "La carpeta no existe."
}
