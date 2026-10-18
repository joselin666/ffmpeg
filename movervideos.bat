@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo   MOVER ARCHIVOS DE SUBCARPETAS
echo ========================================
echo.

:: --- 1. DETECCIÓN DE ARGUMENTOS ---
if "%~1" neq "" (
    set "carpeta=%~1"
    echo Carpeta recibida: "%~1"
) else (
    set /p "carpeta=Introduce la ruta completa de la carpeta: "
)

:: Validaciones básicas
if "%carpeta%"=="" goto ErrorRuta
set "carpeta=%carpeta:"=%"
if not exist "%carpeta%" goto ErrorRuta
if not exist "%carpeta%\*" goto ErrorNoDir

echo.
echo Analizando contenido en: %carpeta%
echo Buscando archivos en subcarpetas...
echo.

:: --- 2. PREVISUALIZACIÓN (SCAN) ---
set /a detectados=0

echo LISTA DE ARCHIVOS A MOVER:
echo ---------------------------------------------------

for /r "%carpeta%" %%F in (*) do (
    set "archivoCompleto=%%F"
    set "nombreArchivo=%%~nxF"
    set "carpetaArchivo=%%~dpF"
    
    REM Quitar la barra final para comparar correctamente
    set "carpetaArchivo=!carpetaArchivo:~0,-1!"
    set "carpetaBase=%carpeta%"
    
    REM Si la carpeta del archivo NO es la carpeta base...
    if /i not "!carpetaArchivo!"=="!carpetaBase!" (
        set /a detectados+=1
        
        REM Mostrar archivo detectado
        echo [!detectados!] !nombreArchivo!
        echo      Origen: ...!carpetaArchivo:~-30!
    )
)

echo ---------------------------------------------------
echo.

:: --- 3. TOMA DE DECISIÓN ---
if !detectados! equ 0 (
    echo No hay archivos en subcarpetas para mover.
    echo Todo esta organizado en la raiz.
    echo.
    pause
    exit /b 0
)

echo TOTAL DETECTADOS: !detectados! archivos.
echo Se moveran a: "%carpeta%"
echo.
set /p "confirmar=¿Proceder con el movimiento? (S/N): "

if /i not "%confirmar%"=="S" (
    echo.
    echo Operación cancelada por el usuario.
    pause
    exit /b 0
)

:: --- 4. EJECUCIÓN (MOVE) ---
echo.
echo Iniciando movimiento...
echo.

set /a movidos=0

for /r "%carpeta%" %%F in (*) do (
    set "carpetaArchivo=%%~dpF"
    set "carpetaArchivo=!carpetaArchivo:~0,-1!"
    set "carpetaBase=%carpeta%"
    
    if /i not "!carpetaArchivo!"=="!carpetaBase!" (
        move /y "%%F" "%carpeta%\" >nul 2>&1
        if !errorlevel! equ 0 (
            set /a movidos+=1
            echo [OK] %%~nxF
        ) else (
            echo [ERROR] Fallo al mover: %%~nxF
        )
    )
)

echo.
echo ========================================
echo Archivos movidos correctamente: %movidos% de %detectados%
echo ========================================
echo.

echo Eliminando subcarpetas vacías...
:: Eliminar carpetas vacías (ciclo repetido para anidadas)
for /l %%i in (1,1,5) do (
    for /f "delims=" %%D in ('dir "%carpeta%" /ad /b /s ^| sort /r') do (
        rd "%%D" 2>nul
    )
)
echo Limpieza finalizada.

echo.
pause
exit /b 0

:ErrorRuta
echo.
echo ERROR: La ruta no existe o es invalida.
pause
exit /b 1

:ErrorNoDir
echo.
echo ERROR: La ruta especificada no es una carpeta.
pause
exit /b 1
