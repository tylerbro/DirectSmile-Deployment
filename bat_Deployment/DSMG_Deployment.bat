REM DSMG Deploy Batch

@echo off
chcp 1252

cd /d "C:\Program Files (x86)\DirectSmile\DirectSmile Installation Service\Client"

SET "DEFAULT_WEB_DIR=http://directsmile.blob.core.windows.net/installer/"
SET "LOCAL_WEB_DIR=%LOCAL_WEB_DIR%"

IF "%DEPLOY_VERSION%" == "DSMG_LATEST_RELEASE" (
ECHO +------------------------------------------------------------------------------------+
ECHO Set default installer web directory and installer's file name
ECHO +------------------------------------------------------------------------------------+
ECHO
SET "REMOTE_INSTALLER_WEB_DIRECTORY=%DEFAULT_WEB_DIR%"
SET "INSTALLER_NAME=dsmg.msi")

	IF "%DEPLOY_VERSION%" == "DSMG_DSF_RELEASE" (
	ECHO +------------------------------------------------------------------------------------+
	ECHO Change installer's file name when Job have been triggered as "DSF Release Mode"
	ECHO +------------------------------------------------------------------------------------+
	ECHO
	SET "REMOTE_INSTALLER_WEB_DIRECTORY=%DEFAULT_WEB_DIR%"
	SET "INSTALLER_NAME=DSMG-DSF.msi")
	
		IF "%DEPLOY_VERSION%" == "DSMG_SPECIFIC_VERSION" (
			IF NOT "%LOCAL_WEB_DIR%" == "" (
			ECHO +------------------------------------------------------------------------------------+
			ECHO Set installer when Job has been triggered as "Specific Version Mode" together with "Download installer locally"
			ECHO +------------------------------------------------------------------------------------+
			ECHO
			SET "REMOTE_INSTALLER_WEB_DIRECTORY=%LOCAL_WEB_DIR%"
			SET "INSTALLER_NAME=%DSMG_VERSION_NUMBER%.msi") else (
				ECHO +------------------------------------------------------------------------------------+
				ECHO Change installer's file name when Job have been triggered as "Specific Version"
				ECHO +------------------------------------------------------------------------------------+
				ECHO
				SET "REMOTE_INSTALLER_WEB_DIRECTORY=%SUPPORT_WEB_DIR%"
				SET "INSTALLER_NAME=DSMGenInstaller-%DSMG_VERSION_NUMBER%.msi"))

IF "%DEBUG_RUN%" == "true" (
	GOTO DEBUG)

ECHO +------------------------------------------------------------------------------------+
ECHO Main part of Installation Service command
ECHO +------------------------------------------------------------------------------------+
ECHO

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
DSMInstallationClient.exe install /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productCode:DSMG /url:"%REMOTE_INSTALLER_WEB_DIRECTORY%%INSTALLER_NAME%" /msilog=True INSTALLDIR="%DSMG_INSTALLDIR%" /watchdog:yes ALLUSERS=1 CLIENTUILEVEL=0
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
IF ERRORLEVEL 1 GOTO MYERROR

EXIT 0

:MYERROR
EXIT 1


:DEBUG
ECHO **************************
ECHO *     DEBUG MODE         *
ECHO * Just echoing the calls *
ECHO **************************
ECHO +------------------------------------------------------------------------------------+
ECHO Installation of DirectSmile Generator
ECHO +------------------------------------------------------------------------------------+
ECHO DSMInstallationClient.exe install /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productCode:DSMG /url:"%REMOTE_INSTALLER_WEB_DIRECTORY%%INSTALLER_NAME%" /msilog=True INSTALLDIR="%DSMG_INSTALLDIR%" /watchdog:yes ALLUSERS=1 CLIENTUILEVEL=0

EXIT 0