@echo off

echo %TIME%

REM --- INICIO LOGICA PORTAPAPELES ---
set "origen="

echo Verificando portapapeles...

REM Usamos PowerShell para obtener el texto del portapapeles
for /f "usebackq tokens=*" %%a in (`powershell -command "Get-Clipboard"`) do set "origen=%%a"

REM Verificamos si la variable origen contiene "http" para saber si es una URL valida
echo "%origen%" | findstr /i "http" >nul
if errorlevel 1 (
    echo [!] El portapapeles esta vacio o no contiene una URL valida.
    set "origen="
) else (
    echo [!] URL detectada en el portapapeles.
)

REM Si no se encontro nada valido, pedimos al usuario
if not defined origen (
    echo.
    echo Entre la ruta completa de la web a descargar
    echo **********************************************
    set /P origen= 
)
REM --- FIN LOGICA PORTAPAPELES ---

echo *******************************************************************************
echo Origen:%origen%
echo *******************************************************************************
echo Descargando ...
echo *******************************************************************************
yt-dlp.exe %origen% -P C:\Users\josef\Downloads
echo *******************************************************************************
echo Descarga Finalizada en C:\Users\josef\Downloads
echo *******************************************************************************

echo %TIME%
timeout /T 5