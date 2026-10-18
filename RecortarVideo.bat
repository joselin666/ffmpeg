@echo off
setlocal

REM El %1 es el archivo que Windows le envia al script
set "inputfile=%~1"

echo Se va a proceder a cortar el video a continuacion se pedira la posicion inicial y final:
echo ****************************************************************************************
echo %inputfile%
echo ****************************************************************************************

Pause


rem Obtener la ruta del fichero de entrada (sin nombre de archivo)
for %%F in ("%inputfile%") do set inputpath=%%~dpF

rem Pedir punto inicial con valor por defecto 00:00:00
set starttime=00:00:00
set /p userstarttime=Desde que punto inicial (hh:mm:ss) quieres conservar [default 00:00:00]: 
if not "%userstarttime%"=="" set starttime=%userstarttime%

rem Pedir punto final
set /p endtime=Hasta que punto final (hh:mm:ss) quieres conservar: 

rem Construir ruta del fichero de salida en la misma carpeta que el de entrada
set outputfile=%inputpath%cortado.mp4

rem Ejecutar ffmpeg con parametro -ss para inicio y -to para final
ffmpeg -i "%inputfile%" -ss %starttime% -to %endtime% -c:v copy -c:a copy "%outputfile%"


