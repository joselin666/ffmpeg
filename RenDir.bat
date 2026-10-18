@echo off
cls

set carpeta=%1
set carpeta="%carpeta:"=%"

:loop
if exist %carpeta% goto :entradaok
echo Directorio a revisar nombres no existe. Indique la ruta completa del Directorio
echo *******************************************************************************
shift
set /P carpeta= 
set carpeta="%carpeta:"=%"
goto :loop

:entradaok
REM Quito las comillas si las tiene y añado \ si no es el ultimo caracter
set carpeta=%carpeta:"=%
if not %carpeta:~-1% == \ set carpeta=%carpeta%\
echo %carpeta%

REM Defino los filtros de busqueda y los nombres de los ficheros temporales
REM set filtros="%carpeta%*.mp4" "%carpeta%*.mkv" "%carpeta%*.avi"

set filtros="%carpeta%*.*"
set fecha=%DATE:/=%
set hora=%TIME:,=%
set hora=%hora::=%
set hora=%hora: =%
set temporal="%TEMP%\aRenombrar.%fecha%.%hora%.txt"

echo Fichero Temporal: %temporal%
dir %filtros% /b /s 1> %temporal% 2>&1
echo Comienza Proceso de Ficheros

FOR /F "tokens=*" %%A in (%temporal:"=%) DO RenFile.bat "%%A"
