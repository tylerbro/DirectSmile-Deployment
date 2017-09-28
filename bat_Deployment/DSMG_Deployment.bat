REM DSMG Deploy Batch

@echo off
chcp 1252

cd /d "C:\Program Files (x86)\DirectSmile\DirectSmile Installation Service\Client"

SET "DIRECTSMILE_AZURE_CDN=http://directsmile.blob.core.windows.net/installer"

IF "%DSMG_DEPLOY_VERSION%" == "DSMG_LATEST_RELEASE" (
	ECHO +------------------------------------------------------------------------------------+
	ECHO Set installer when Job has been triggered as "DSMG_LATEST_RELEASE Mode"
	ECHO +------------------------------------------------------------------------------------+
	ECHO
	SET "COMMAND_URL=%DIRECTSMILE_AZURE_CDN%/dsmg.msi")

IF "%DSMG_DEPLOY_VERSION%" == "DSMG_DSF_RELEASE" (
	ECHO +------------------------------------------------------------------------------------+
	ECHO Set installer when Job has been triggered as "DSMG_DSF_RELEASE Mode"
	ECHO +------------------------------------------------------------------------------------+
	ECHO
	SET "COMMAND_URL=%DIRECTSMILE_AZURE_CDN%/DSMG-DSF.msi")

IF "%DSMG_DEPLOY_VERSION%" == "DSMG_SPECIFIC_VERSION" (
	ECHO +------------------------------------------------------------------------------------+
	ECHO Set installer when Job has been triggered as "DSMG_SPECIFIC_VERSION" together with "DSMG_INSTALLER_FILE_PATH"
	ECHO +------------------------------------------------------------------------------------+
	ECHO
	SET "COMMAND_URL=%DSMG_INSTALLER_FILE_PATH%")

ECHO +------------------------------------------------------------------------------------+
ECHO Set LOGLEVEL to support custom configuration
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%LOGLEVEL%" == "" (
	SET "LOGLEVEL_COMMAND=" ) ELSE (
	SET LOGLEVEL_COMMAND=LOGLEVEL="%LOGLEVEL%")	

ECHO +------------------------------------------------------------------------------------+
ECHO Set LOGPATH to support custom configuration
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%LOGPATH%" == "" (
	SET "LOGPATH_COMMAND=" ) ELSE (
	SET LOGPATH_COMMAND=LOGPATH="%LOGPATH%")	

ECHO +------------------------------------------------------------------------------------+
ECHO Set ALLUSERS to support custom configuration
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%ALLUSERS%" == "true" (
	SET ALLUSERS_COMMAND=ALLUSERS="1" ) ELSE (
	SET ALLUSERS_COMMAND=ALLUSERS="0")	

ECHO +------------------------------------------------------------------------------------+
ECHO Set CLIENTUILEVEL to support custom configuration
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%CLIENTUILEVEL%" == "false" (
	SET CLIENTUILEVEL_COMMAND=CLIENTUILEVEL="0" ) ELSE (
	SET CLIENTUILEVEL_COMMAND=CLIENTUILEVEL="1")

ECHO +------------------------------------------------------------------------------------+
ECHO Set MSILOG to support custom Installation command
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%MSILOG%" == "" (
	SET "MSILOG_COMMAND=" ) ELSE (
	SET MSILOG_COMMAND=MSILOG="%MSILOG%")		
	
IF "%DEBUG_RUN%" == "true" (
	GOTO DEBUG )

IF "%DSMG_DEPLOY%" == "false" (
		EXIT 0 )
		
IF NOT EXIST DSMG_INSTALLER_FILE_PATH (
		EXIT 0 )

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
DSMInstallationClient.exe uninstall /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productCode:DSMG /servicename:DSMOnlineBackend  /ProcessesToKill:"DirectSmile Generator;DSMWatchDog;VDPOnlineServer" %MSILOG_COMMAND%
IF ERRORLEVEL 1 GOTO MYERROR

ECHO +------------------------------------------------------------------------------------+
ECHO Installation of DirectSmile Generator
ECHO +------------------------------------------------------------------------------------+
DSMInstallationClient.exe install /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productCode:DSMG /url:"%COMMAND_URL%" INSTALLDIR="%DSMG_INSTALLDIR%" %ALLUSERS_COMMAND% %CLIENTUILEVEL_COMMAND% %LOGLEVEL_COMMAND% %LOGPATH_COMMAND% %MSILOG_COMMAND% /watchdog:yes
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
ECHO DEBUG: Pre-Version Check - DirectSmile Generator
ECHO +------------------------------------------------------------------------------------+
ECHO
ECHO DSMInstallationClient.exe version /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productCode:DSMG

ECHO +------------------------------------------------------------------------------------+
ECHO DEBUG: Uninstallation of DirectSmile Generator
ECHO +------------------------------------------------------------------------------------+
ECHO
ECHO DSMInstallationClient.exe uninstall /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productCode:DSMG /servicename:DSMOnlineBackend  /ProcessesToKill:"DirectSmile Generator;DSMWatchDog;VDPOnlineServer" /lime "C:\Uninstallation.log"

ECHO +------------------------------------------------------------------------------------+
ECHO DEBUG: Installation of DirectSmile Generator
ECHO +------------------------------------------------------------------------------------+
ECHO DSMInstallationClient.exe install /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productCode:DSMG /url:"%COMMAND_URL%" INSTALLDIR="%DSMG_INSTALLDIR%" %ALLUSERS_COMMAND% %CLIENTUILEVEL_COMMAND% %LOGLEVEL_COMMAND% %LOGPATH_COMMAND% %MSILOG_COMMAND% /watchdog:yes

ECHO +------------------------------------------------------------------------------------+
ECHO DEBUG: Restart DSMOnlineBackend to ensure affect changes
ECHO +------------------------------------------------------------------------------------+
ECHO
ECHO DSMInstallationClient.exe restart /endpoint:"https://%FQDN%/DSMInstallationService.svc" /servicename:DSMOnlineBackend

ECHO +------------------------------------------------------------------------------------+
ECHO DEBUG: Post-Version Check - DirectSmile Generator
ECHO +------------------------------------------------------------------------------------+
ECHO
ECHO DSMInstallationClient.exe version /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productCode:DSMG

EXIT 0
