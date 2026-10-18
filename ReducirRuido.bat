@echo off
setlocal

REM El %1 es el archivo que Windows le envia al script
set "inputfile=%~1"

echo Se va a proceder a reducir el ruido y el eco en el archivo:
echo ***********************************************************
echo %inputfile%
echo ***********************************************************

rem Construir ruta del fichero de salida en la misma carpeta que el de entrada
set outputfile=%inputpath%sinRuido.mp4

rem Ejecutar ffmpeg para reducción de ruido
ffmpeg -i "%inputfile%" -af "highpass=f=200, lowpass=f=3000" -c:v copy "%outputfile%"

rem Construir ruta del fichero de salida en la misma carpeta que el de entrada
set inputfile=%outputfile%
set outputfile=%inputpath%sinEco.mp4

rem Ejecutar para eliminar el eco
ffmpeg -i "%inputfile%" -af "acompressor=threshold=-20dB:ratio=4:attack=200:release=1000" -c:v copy "%outputfile%"

rem Ejecutar para eliminar el eco plus
set inputfile=%outputfile%
set outputfile=%inputpath%sinEcoPlus.mp4
ffmpeg -i "%inputfile%" -af "acompressor=threshold=-20dB:ratio=4:attack=200:release=1000" -c:v copy "%outputfile%"

echo Proceso completado.

endlocal
