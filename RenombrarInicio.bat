@echo off
setlocal enabledelayedexpansion

rem Solicita la ruta completa de la carpeta
set /p carpeta=Introduce la ruta completa de la carpeta:

rem Cambia al directorio especificado
cd /d "%carpeta%"

rem Recorre cada archivo
for %%f in (*) do (
    set "archivo=%%f"
    rem Obtiene la extensión y el resto del nombre quitando los 3 primeros caracteres
    set "nuevo=!archivo:~3!"
    rem Renombra el archivo con '0' al inicio y mantiene el resto
    ren "%%f" "0!nuevo!"
)
echo Procesamiento terminado.
pause
