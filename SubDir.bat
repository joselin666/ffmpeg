@echo off
cls

echo "Borrando Ficheros Temporales"
rd %temp% /s /q

cls

set carpeta=%1
set carpeta="%carpeta:"=%"

:loop
if exist %carpeta% goto :entradaok
echo Directorio a convertir no existe. Indique la ruta completa del Directorio a convertir
echo *************************************************************************************
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
set filtros="%carpeta%*.vtt" "%carpeta%*.ass"
set fecha=%DATE:/=%
set hora=%TIME:,=%
set hora=%hora::=%
set hora=%hora: =%
set temporal="%TEMP%\aConvertir.%fecha%.%hora%.txt"
set filtrado="%TEMP%\aFiltrado.%fecha%.%hora%.txt"

dir %filtros% /b /s 1> %temporal% 2>&1
findstr /V /E .srt %temporal% > %filtrado% 
echo *************************************************************************************
echo Ficheros a Converir
echo *************************************************************************************
type %filtrado%
echo *************************************************************************************
for /f %%a in ('type %filtrado% ^| find /v /c ""') do set numLineas=%%a
echo Numero de Ficheros a Converir: %numLineas%
echo *************************************************************************************

if %numLineas% == 0 (
    goto :fin
)

FOR /F "tokens=*" %%A in (%filtrado:"=%) DO SubFile.bat "%%A"

:fin
echo Proceso Terminado