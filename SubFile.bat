@echo off
setlocal enableDelayedExpansion

set "origen=%~1"
set origen="%origen:"=%"

:loop
if exist %origen% goto :entradaok
echo Origen:%origen%
echo Fichero a convertir no existe. Indique la ruta completa del fichero de subtitulo a convertir
echo ********************************************************************************************
shift
set /P origen= 
set origen="%origen:"=%"
goto :loop

:entradaok
echo Entrada OK

set destino="%~dpn1.srt"

echo Convirtiendo ...
ffmpeg.exe -i %origen% %destino%
echo Conversion Finalizada
echo *******************************************************************************
timeout /T 3
:fin

