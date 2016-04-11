REM DSMG Deploy Batch

@echo off
chcp 1252

cd /d "C:\Program Files (x86)\DirectSmile\DirectSmile Installation Service\Client"

ECHO +------------------------------------------------------------------------------------+
ECHO Set Installer web directory and installer's file name based on selected version
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%Deploy_Version%" == "DSMG_LATEST_RELEASE" (
	SET REMOTE_INSTALLER_WEB_DIRECTORY=http://directsmile.blob.core.windows.net/installer
	SET INSTALLER_NAME=dsmg.msi ) else IF "%Deploy_Version%" == "DSMG_SPECIFIC_VERSION" (
		SET REMOTE_INSTALLER_WEB_DIRECTORY=http://ftp.directsmile.de/download/NonReleaseVersion
		SET INSTALLER_NAME=DSMGenInstaller-%DSMG_VERSION_NUMBER%.msi )

ECHO We take installer from %REMOTE_INSTALLER_WEB_DIRECTORY%/%INSTALLER_NAME%
		
ECHO +------------------------------------------------------------------------------------+
ECHO Main part of Installation Service command
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%DSMG_DEPLOY%" == "true" (

ECHO +------------------------------------------------------------------------------------+
ECHO Pre-Version Check - DirectSmile Generator
ECHO +------------------------------------------------------------------------------------+
ECHO
DSMInstallationClient.exe version /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productCode:DSMG

ECHO +------------------------------------------------------------------------------------+
ECHO Uninstallation of DirectSmile Generator
ECHO +------------------------------------------------------------------------------------+
ECHO
DSMInstallationClient.exe uninstall /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productCode:DSMG /servicename:DSMOnlineBackend  /ProcessesToKill:"DirectSmile Generator;DSMWatchDog;VDPOnlineServer" /lime "C:\Uninstallation.log"
IF ERRORLEVEL 1 GOTO MYERROR

ECHO +------------------------------------------------------------------------------------+
ECHO Installation of DirectSmile Generator
ECHO +------------------------------------------------------------------------------------+
ECHO DSMInstallationClient.exe install /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productCode:DSMG /url:"%REMOTE_INSTALLER_WEB_DIRECTORY%/%INSTALLER_NAME%" /msilog=True INSTALLDIR="%DSMG_INSTALLDIR%" /watchdog:yes ALLUSERS=1 CLIENTUILEVEL=0
DSMInstallationClient.exe install /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productCode:DSMG /url:"%REMOTE_INSTALLER_WEB_DIRECTORY%/%INSTALLER_NAME%" /msilog=True INSTALLDIR="%DSMG_INSTALLDIR%" /watchdog:yes ALLUSERS=1 CLIENTUILEVEL=0
IF ERRORLEVEL 1 GOTO MYERROR 

ECHO +------------------------------------------------------------------------------------+
ECHO Restart DSMOnlineBackend to ensure affect changes
ECHO +------------------------------------------------------------------------------------+
ECHO
DSMInstallationClient.exe restart /endpoint:"https://%FQDN%/DSMInstallationService.svc" /servicename:DSMOnlineBackend

ECHO +------------------------------------------------------------------------------------+
ECHO Post-Version Check - DirectSmile Generator
ECHO +------------------------------------------------------------------------------------+
ECHO
DSMInstallationClient.exe version /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productCode:DSMG
IF ERRORLEVEL 1 GOTO MYERROR  )

EXIT 0

:MYERROR
EXIT 1