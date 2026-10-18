@echo off
setlocal enableDelayedExpansion

set origen=%1
set origen="%origen:"=%"
set destino=Pendiente
set DURORI=0
set DURFIN=1

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
echo *******************************************************************************
echo %TIME%
set compara=%origen:~-13%
set compara=%compara:"=%
set comparador=.HD720p.MKV
if not "%compara%" == "%comparador%" goto :destino

echo Fichero Procesado Anteriormente: %origen%
echo *******************************************************************************
goto :fin

:destino
set desthd="%origen:"=%.HD720p.MKV"
For %%A in (%desthd%) do (
 set drive=%%~dA
 set fullpath = %%~fA
 set mipath=%%~pA
 set filename=%%~nA
 set extension=%%~xA)

set destino=%filename: =.%
python.exe D:\Developer\ffmpeg\normalizar.py %destino% > %TEMP%\normalizardestino.txt
set /p ficheronormalizado=<%TEMP%\normalizardestino.txt

set carpeta="%drive%%mipath%"
set destino="%drive%%mipath%%ficheronormalizado%%extension%"
set noconvertir="%drive%%mipath%noconvertir.txt"

if not exist %noconvertir% goto :preparar
echo No Convertir Existe el fichero:%noconvertir%
echo *******************************************************************************
goto :fin

:preparar
echo Carpeta Destino:%carpeta%
echo Origen:%origen%
echo Destino:%destino%

if exist %carpeta% goto :comprobardestino
mkdir %carpeta%

:comprobardestino
if not exist %destino% goto :convertir

echo Fichero Destino:%destino% ya existe
echo *******************************************************************************
goto :fin

:convertir
REM CALCULAMOS LA DURACION DEL VIDEO ORIGINAL
ffprobe -i  %origen% -show_entries format=duration -v quiet -of csv="p=0" > "%TEMP%\DuracionOriginal.txt"
set /p DURORI=<"%TEMP%\DuracionOriginal.txt"
set /a DURORI*=1
set /a durmin=%DURORI%/60
set /a durrest=%DURORI%-(%durmin%*60)
set /a durhor=%durmin%/60
set /a durmin=%durmin%-(durhor*60)
echo Duracion Original: %DURORI% Segundos (%durhor%:%durmin%:%durrest%)

echo Convirtiendo ...
rem D:\Software\Portables\ffmpeg\bin\ffmpeg.exe -y -i %origen% -c:v libx264 -preset medium -minrate 2500K -maxrate 4000K -bufsize 4000K -pix_fmt yuv420p -profile:v high -level 4.2 -vf "scale=1280:-2" -map 0:v? -c:a ac3 -map 0:a? -c:s srt -map 0:s? -map_chapters 0 -map_metadata 0 -f matroska -threads 0 %destino% 1> "%TEMP%\log.conversion.txt" 2>&1
rem ffmpeg.exe -i %origen% -c:v libx264 -b:v 2000K -vf "scale=1280:-2" -map 0:v -map_chapters 0 -map_metadata -0 -c:a ac3 -b:a 192k -map 0:a? -c:s srt -map 0:s? %destino% 1> "%TEMP%\log.conversion.txt" 2>&1

rem Ejecutamos la conversion en otra ventana para ver el progreso.
rem Quitamos la copia de capitulos y metadatos start /wait cmd /c ffmpeg.exe -i %origen% -c:v libx264 -b:v 2000K -vf "scale=1280:-2" -map 0:v -map_chapters 0 -map_metadata -0 -c:a ac3 -b:a 192k -map 0:a? -c:s srt -map 0:s? %destino%
rem start /wait cmd /c ffmpeg.exe -i %origen% -c:v h264_nvenc -b:v 2000K -vf "scale=1280:-2,format=yuv420p" -map 0:v -c:a ac3 -b:a 192k -map 0:a? -c:s srt -map 0:s? %destino%
rem start /wait cmd /c ffmpeg.exe -i %origen% -c:v libx264 -b:v 2000K -vf "scale=1280:-2" -map 0:v -c:a ac3 -b:a 192k -map 0:a? -c:s srt -map 0:s? -r 25 %destino%
rem start /wait cmd /c ffmpeg.exe -i %origen% -c:v h264_nvenc -cq 22 -vf "scale=1280:-2,format=yuv420p" -map 0:v -c:a ac3 -b:a 192k -map 0:a? -c:s srt -map 0:s? %destino%

start /min /wait cmd /c ffmpeg.exe -i %origen% -c:v h264_nvenc -b:v 3M -minrate 3M -maxrate 3M -vf "scale=1280:-2,format=yuv420p" -map 0:v -c:a ac3 -b:a 192k -map 0:a? -c:s srt -map 0:s? %destino%
echo Conversion Finalizada

REM CALCULAMOS LA DURACION DEL VIDEO CONVERTIDO PARA COMPROBAR QUE FUE CORRECTA
ffprobe -i  %destino% -show_entries format=duration -v quiet -of csv="p=0" > "%TEMP%\DuracionFinal.txt"
set /p DURFIN=<"%TEMP%\DuracionFinal.txt"
set /a DURFIN*=1
echo Duracion Final: %DURFIN% Segundos

IF %DURORI%==%DURFIN% (
  echo La duracion es la misma, se borra el fichero origen.
  del %origen%
  rem Recycle.exe -f %origen%
  ) ELSE (
  echo *************************************************************
  echo *** ERRROR en la duracion, no se borra el fichero Origen. ***
  echo *************************************************************
  echo %TIME%.%origen% > "%TEMP%\erroresffmpeg.txt"
  color 0C
  )
echo Hora: %TIME%
echo *******************************************************************************
rundll32 user32.dll,MessageBeep
timeout /T 29
:fin

