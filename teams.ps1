# -----------------------------------------------------------
# Script Optimizado para Windows 11 Pro 25H2
# Objetivo: Descargar video de Teams desde URL (Portapapeles o Manual)
# -----------------------------------------------------------

# 1. Intentar obtener el contenido del portapapeles
$clipboardContent = Get-Clipboard -Raw

# 2. Validar si el contenido es una URL válida (comienza por http/https)
# Utilizamos la clase .NET [Uri] para una validación robusta
if ($clipboardContent -and [Uri]::IsWellFormedUriString($clipboardContent, [UriKind]::Absolute)) {
    Write-Host "URL valida detectada en el portapapeles." -ForegroundColor Green
    $inputfile = $clipboardContent.Trim()
}
else {
    # Si no hay URL válida, pedir al usuario
    Write-Host "El portapapeles no contiene una URL valida." -ForegroundColor Yellow
    $inputfile = Read-Host "Introduce el valor de la URL obtenida con Firefox, mas herramientas, herramientas para desarrollador, Red, videomanifest, F5, boton derecho, copiar valor, copiar url"
}

# Cambiar Playback=false por Playback=true
$inputfile = $inputfile -replace 'Playback=false', 'Playback=true'

# Encontrar posición de Playback=true
$pos = $inputfile.IndexOf('Playback=true')

if ($pos -ne -1) {
    # Cortar cadena hasta el final de Playback=true
    $length = $pos + 'Playback=true'.Length
    $inputfile = $inputfile.Substring(0, $length)
}

Write-Output "Valor final de inputfile:"
Write-Output $inputfile

# Ejecutar ffmpeg para descargar o convertir video usando la url
ffmpeg -i $inputfile -codec copy C:\Users\josef\Downloads\VideoTeams.mp4
