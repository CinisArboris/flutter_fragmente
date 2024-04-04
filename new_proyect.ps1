$androidLanguage = "java"
$iosLanguage = "swift"
$org = "com.cinisarboris.estados_bloc"
$description = "estados_bloc"
$platforms = "android"
$template = "app"
$noPub = $true
$overwrite = $true
$outputDir = ""
$appName = "estados_bloc"

$flutterCreateArgs = "--android-language $androidLanguage " +
  "--ios-language $iosLanguage " +
  "--org $org " +
  "--description '$description' " +
  "--platforms $platforms " +
  "--template $template"

if ($noPub) {
    $flutterCreateArgs += " --no-pub"
}

if ($overwrite) {
    $flutterCreateArgs += " --overwrite"
}

if (![string]::IsNullOrWhiteSpace($outputDir)) {
    $flutterCreateArgs += " --output-dir $outputDir"
}

$command = "flutter create $appName $flutterCreateArgs"

Write-Host "Running command: $command"
Invoke-Expression -Command $command
