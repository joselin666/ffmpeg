@echo off
setlocal enableDelayedExpansion

set origen=%1
set origen="%origen:"=%"

:loop
if exist %origen% goto :entradaok
echo Origen:%origen%
echo Fichero a convertir no existe. Indique la ruta completa del fichero a convertir
echo *******************************************************************************
shift
set /P origen= 
set origen="%origen:"=%"
goto :loop

:entradaok
set destino="%origen:"=%.CONVERTIDO.mkv"

:preparar
echo Carpeta Destino:%carpeta%
echo Origen:%origen%
echo Destino:%destino%

:convertir

echo Convirtiendo ...

ffmpeg.exe -i %origen% -c:v h264_nvenc -b:v 3M -minrate 3M -maxrate 3M -vf "scale=1280:-2,format=yuv420p" -map 0:v -c:a ac3 -b:a 192k -map 0:a? -c:s srt -map 0:s? %destino%
echo Conversion Finalizada

echo Hora: %TIME%
echo *******************************************************************************
rundll32 user32.dll,MessageBeep
timeout /T 29
:fin

