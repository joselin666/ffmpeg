@echo off
setlocal enabledelayedexpansion

REM Solicita al usuario la ruta completa de la carpeta
set /p carpeta="Introduce la ruta completa de la carpeta: "

REM Cambia a la carpeta introducida
cd /d "%carpeta%"

REM Recorre todos los archivos que contengan ACCESO.T1x en el nombre
for %%f in (*ACCESO.T1x*) do (
    REM Extrae el nombre original y genera el nuevo nombre
    set "archivo=%%f"
    set "nuevo=!archivo:ACCESO.T1x=0!"
    REN "%%f" "!nuevo!"
)

echo Proceso finalizado.
pause