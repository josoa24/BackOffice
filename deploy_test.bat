@echo off
setlocal EnableDelayedExpansion

set SOURCE_DIR=D:\ITU\S5\MrNAINA\RESERVATION_VOITURE\BackOffice
set SRC_JAVA=%SOURCE_DIR%\src\main\java
set WEBINF=%SOURCE_DIR%\WEB-INF
set LIB_DIR=%SOURCE_DIR%\lib
set BUILD_TEMP=build-war-temp
set WAR_NAME=BackOffice.war
set DEST_DIR=D:\ITU\Tomcat\apache-tomcat-10.1.34\webapps
set SOURCES_FILE=java_all.txt
set DEPLOY_DIR=%DEST_DIR%\BackOffice

if exist "%DEST_DIR%\%WAR_NAME%" del "%DEST_DIR%\%WAR_NAME%"
if exist "%DEPLOY_DIR%" rmdir /s /q "%DEPLOY_DIR%"

if exist "%BUILD_TEMP%" rmdir /s /q "%BUILD_TEMP%"
mkdir "%BUILD_TEMP%\WEB-INF\classes"

xcopy "%WEBINF%\*" "%BUILD_TEMP%\WEB-INF\" /E /I /Y >nul

if exist "%SOURCES_FILE%" del "%SOURCES_FILE%"

for /r "%SRC_JAVA%" %%f in (*.java) do (
    echo %%f >> "%SOURCES_FILE%"
)

set CLASSPATH_JAR=%LIB_DIR%\FrontServlet.jar

javac -parameters -cp "%CLASSPATH_JAR%" -d "%BUILD_TEMP%\WEB-INF\classes" @"%SOURCES_FILE%"

if %errorlevel% neq 0 exit /b 1

del "%SOURCES_FILE%"

cd "%BUILD_TEMP%"
jar cf "%WAR_NAME%" *
cd ..

copy "%BUILD_TEMP%\%WAR_NAME%" "%DEST_DIR%\%WAR_NAME%" /Y

rmdir /s /q "%BUILD_TEMP%"

pause
