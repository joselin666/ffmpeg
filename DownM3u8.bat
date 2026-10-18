@echo off

echo %TIME%

echo Entre la ruta completa del Fichero m3u8/mpd a descargar
echo *******************************************************
shift
set /P origen= 
set origen="%origen:"=%"

echo Nombre del programa a descargar
echo ********************************************************
shift
set /P destino=
set destino="C:\Users\josef\Downloads\%destino:"=%.mkv"

echo *******************************************************************************
echo Origen:%origen%
echo Destino:%destino%
echo *******************************************************************************

echo *******************************************************************************
echo Descargando ...
echo *******************************************************************************
ffmpeg.exe -i %origen% -codec copy %destino%
echo *******************************************************************************
echo Descarga Finalizada
echo *******************************************************************************

echo %TIME%
timeout /T 5