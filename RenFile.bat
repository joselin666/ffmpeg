@echo off

set origen=%1
set origen="%origen:"=%"
set destino=Pendiente
set DURORI=0
set DURFIN=1

:loop
if exist %origen% goto :entradaok
echo Fichero a Renombrar no existe. Indique la ruta completa del fichero a Renombrar
echo *******************************************************************************
shift
set /P origen= 
set origen="%origen:"=%"
goto :loop

:entradaok
For %%A in (%origen%) do (
 set drive=%%~dA
 set fullpath = %%~fA
 set mipath=%%~pA
 set filename=%%~nA
 set extension=%%~xA)

set destino=%filename: =.%
python normalizar.py %destino% > %TEMP%\normalizar.txt
set /p destino=<%TEMP%\normalizar.txt

if "%filename%" == "%destino%" goto :fin
echo *******************************************************************************
echo Renombrar ...
echo "%filename%"
echo "%destino%"
rename "%drive%%mipath%%filename%%extension%" "%destino%%extension%"
echo *******************************************************************************
:fin

