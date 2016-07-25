REM DSMG Deploy Batch

@echo off
chcp 1252

cd "C:\Program Files (x86)\DirectSmile\DirectSmile Installation Service\Client"

SET "DIRECTSMILE_AZURE_CDN=http://directsmile.blob.core.windows.net/installer"

IF "%DEPLOY_VERSION%" == "DSMG_LATEST_RELEASE" (
	ECHO +------------------------------------------------------------------------------------+
	ECHO Set installer when Job has been triggered as "DSMG_LATEST_RELEASE Mode"
	ECHO +------------------------------------------------------------------------------------+
	ECHO
	SET "COMMAND_URL=%DIRECTSMILE_AZURE_CDN%/dsmg.msi")

IF "%DEPLOY_VERSION%" == "DSMG_DSF_RELEASE" (
	ECHO +------------------------------------------------------------------------------------+
	ECHO Set installer when Job has been triggered as "DSMG_DSF_RELEASE Mode"
	ECHO +------------------------------------------------------------------------------------+
	ECHO
	SET "COMMAND_URL=%DIRECTSMILE_AZURE_CDN%/DSMG-DSF.msi")

IF "%DEPLOY_VERSION%" == "DSMG_SPECIFIC_VERSION" (
	ECHO +------------------------------------------------------------------------------------+
	ECHO Set installer when Job has been triggered as "DSMG_SPECIFIC_VERSION" together with "DSMG_INSTALLER_FILE_PATH"
	ECHO +------------------------------------------------------------------------------------+
	ECHO
	SET "COMMAND_URL=%DSMG_INSTALLER_FILE_PATH%")

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
DSMInstallationClient.exe install /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productCode:DSMG /url:"%COMMAND_URL%" /msilog=True INSTALLDIR="%DSMG_INSTALLDIR%" /watchdog:yes ALLUSERS=1 CLIENTUILEVEL=0
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
ECHO DSMInstallationClient.exe install /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productCode:DSMG /url:"%COMMAND_URL%" /msilog=True INSTALLDIR="%DSMG_INSTALLDIR%" /watchdog:yes ALLUSERS=1 CLIENTUILEVEL=0

EXIT 0