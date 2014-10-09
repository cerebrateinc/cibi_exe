@echo OFF

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------


:: BatchCHECKMYSQL
:-------------------------------------
REM --> check if mysql already exist


if not exist "C:\Program Files\MySQL\MySQL Server 5.6\bin\mysql.exe" (
	echo Installing mysql...
	start /w mysql-installer-web-community-5.6.21.0.msi 
) else (
	echo ***Mysql already installed***
	goto MYSQLNOTRUNNING
)

:MYSQLWAITLOOP
tasklist /FI "IMAGENAME eq MySQLInstaller.exe" 2>NUL | find /I /N "MySQLInstaller.exe">NUL
if "%ERRORLEVEL%"=="0" goto MYSQLRUNNING
goto MYSQLNOTRUNNING

:MYSQLRUNNING
ping 9.9.9.9 /f >nul 2>&1
goto MYSQLWAITLOOP

:MYSQLNOTRUNNING
echo Finished MySQl setup.
:--------------------------------------



:: BatchCHECKREDIS
:-------------------------------------
REM --> check if redis already exist

if not exist "C:\Program Files\Redis\redis-server.exe" (
	echo Installing redis...
	start /w redis-2.4.6-setup-64-bit.exe 

	:: Assign Path variables
	SET REDIS="C:\Program Files\Redis"

	:: Set Path variable
	setx PATH "%PATH%;%REDIS%;"
) else (
	echo ***Redis already installed***
	goto REDISNOTRUNNING
)

:REDISWAITLOOP
tasklist /FI "IMAGENAME eq redis-2.4.6-setup-64-bit.exe" 2>NUL | find /I /N "redis-2.4.6-setup-64-bit.exe">NUL
if "%ERRORLEVEL%"=="0" goto REDISRUNNING
goto REDISNOTRUNNING

:REDISRUNNING
ping 9.9.9.9 /f >nul 2>&1
goto REDISWAITLOOP

:REDISNOTRUNNING
echo Finished Redis setup.
:--------------------------------------


:: BatchCHECKJAVA
:-------------------------------------
REM --> check if redis already exist

if not exist "C:\Program Files\Java\jdk1.7.0_67\bin\java.exe" (
	echo Installing java...
	start /w jdk-7u67-windows-x64.exe
) else (
	echo ***Java already installed***
	goto JAVANOTRUNNING
)

:JAVAWAITLOOP
tasklist /FI "IMAGENAME eq jjdk-7u67-windows-x64.exe" 2>NUL | find /I /N "jdk-7u67-windows-x64.exe">NUL
if "%ERRORLEVEL%"=="0" goto JAVARUNNING
goto JAVANOTRUNNING

:JAVARUNNING
ping 9.9.9.9 /f >nul 2>&1
goto JAVAWAITLOOP

:JAVANOTRUNNING
echo Finished Java setup.
:--------------------------------------



:: BatchCHECKPLAY
:-------------------------------------
if not exist "C:\play-2.0\play" (
	echo Installing play...
	mkdir "c:/play-2.0"
	xcopy /s play-2.0 "c:/play-2.0"

	:: Assign Path variables
	SET JAVA_HOME="C:\Program Files\Java\jdk1.7.0_67\bin"
	SET PLAY="C:\play-2.0\"

	:: Set Path variable
	setx PATH "%PATH%;%PLAY%;%JAVA_HOME%;"

) else (
	echo ***Play already installed***
)

echo Finished Play setup.
:--------------------------------------

pause
