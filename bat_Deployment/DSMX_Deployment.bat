REM DSMX Deploy Batch

@echo off
chcp 1252

cd "C:\Program Files (x86)\DirectSmile\DirectSmile Installation Service\Client"

SET "DEFAULT_WEB_DIR=http://directsmile.blob.core.windows.net/installer/"
SET "LOCAL_WEB_DIR=%LOCAL_WEB_DIR%"

IF "%DEPLOY_VERSION%" == "DSMX_LATEST_RELEASE" (
	ECHO +------------------------------------------------------------------------------------+
	ECHO Set installer when Job has been triggered as "DSMX_LATEST_RELEASE Mode"
	ECHO +------------------------------------------------------------------------------------+
	ECHO
	SET "DSMX_REMOTE_INSTALLER_WEB_DIRECTORY=%DEFAULT_WEB_DIR%"
	SET "DSMX_INSTALLER_NAME=dsmx.msi")

	IF "%DEPLOY_VERSION%" == "DSMX_SPECIFIC_VERSION" (
		IF NOT "%LOCAL_WEB_DIR%" == "" (
			ECHO +------------------------------------------------------------------------------------+
			ECHO Set installer when Job has been triggered as "Specific Version Mode" together with "Download installer locally"
			ECHO +------------------------------------------------------------------------------------+
			ECHO
			SET "DSMX_REMOTE_INSTALLER_WEB_DIRECTORY=%LOCAL_WEB_DIR%"
			SET "DSMX_INSTALLER_NAME=%DSMX_VERSION_NUMBER%.msi") ELSE (
			ECHO +------------------------------------------------------------------------------------+
			ECHO Set installer when Job has been triggered as "Specific Version Mode"
			ECHO +------------------------------------------------------------------------------------+
			ECHO
			SET "DSMX_REMOTE_INSTALLER_WEB_DIRECTORY=%SUPPORT_WEB_DIR%"
			SET "DSMX_INSTALLER_NAME=dsmx-%DSMX_VERSION_NUMBER%.msi"))

REM ************************************************************************************************

ECHO +------------------------------------------------------------------------------------+
ECHO Create Common part of Deployment command for DSMX
ECHO +------------------------------------------------------------------------------------+
ECHO
SET COMMON_COMMAND=DSMInstallationClient.exe install /endpoint:"https://%FQDN%/DSMInstallationService.svc"  /productCode:DSMX /url:"%DSMX_REMOTE_INSTALLER_WEB_DIRECTORY%%DSMX_INSTALLER_NAME%" WEBSITES="%WEBSITES%" DIRPROPERTY1="%WEBSITES%" DSMXURL="%DSMXURL%" DSMOURL="%DSMOURL%" SQLINSTANCENAME="%SQLINSTANCENAME%" SQLDATABASENAME="%DSMX_SQLDATABASENAME%" INSTALLDIR="%EMAILBACKEND%" DIRECTSMILE_TRIGGER_SERVICE="%TRIGGERBACKEND%" 

ECHO %COMMON_COMMAND%


ECHO +------------------------------------------------------------------------------------+
ECHO SET LANDINGPAGEDATADIR
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%LANDINGPAGEDATADIR%" == "" (
	SET "LANDINGPAGEDATADIR_COMMAND=" ) ELSE (
	SET LANDINGPAGEDATADIR_COMMAND=LANDINGPAGEDATADIR="%LANDINGPAGEDATADIR%" )

ECHO +------------------------------------------------------------------------------------+
ECHO SET SHAREDSETTINGSFILE
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%SHAREDSETTINGSFILE%" == "" (
	SET "SHAREDSETTINGSFILE_COMMAND=" ) ELSE (
	SET SHAREDSETTINGSFILE_COMMAND=SHAREDSETTINGSFILE="%SHAREDSETTINGSFILE%" )

ECHO +------------------------------------------------------------------------------------+
ECHO SET DSMXSERVERKEY
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%DSMXSERVERKEY%" == "" (
	SET "DSMXSERVERKEY_COMMAND=" ) ELSE (
	SET DSMXSERVERKEY_COMMAND=DSMXSERVERKEY="%DSMXSERVERKEY%" )

ECHO +------------------------------------------------------------------------------------+
ECHO SET DSMIMASTERURL
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%DSMIMASTERURL%" == "" (
	SET "DSMIMASTERURL_COMMAND=" ) ELSE (
	SET DSMIMASTERURL_COMMAND=DSMIMASTERURL="%DSMIMASTERURL%" )

ECHO +------------------------------------------------------------------------------------+
ECHO SET FAILOVERENDPOINT
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%FAILOVERENDPOINT%" == "" (
	SET "FAILOVERENDPOINT_COMMAND=" ) ELSE (
	SET FAILOVERENDPOINT_COMMAND=FAILOVERENDPOINT="%FAILOVERENDPOINT%" )

ECHO +------------------------------------------------------------------------------------+
ECHO SET DEFAULTREDIRECTURL
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%DEFAULTREDIRECTURL%" == "" (
	SET "DEFAULTREDIRECTURL_COMMAND=" ) ELSE (
	SET DEFAULTREDIRECTURL_COMMAND=DEFAULTREDIRECTURL="%DEFAULTREDIRECTURL%" )

ECHO +------------------------------------------------------------------------------------+
ECHO SET DSMIFRONTENDURL
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%DSMIFRONTENDURL%" == "" (
	SET "DSMIFRONTENDURL_COMMAND=" ) ELSE (
	SET DSMIFRONTENDURL_COMMAND=DSMIFRONTENDURL="%DSMIFRONTENDURL%" )

ECHO +------------------------------------------------------------------------------------+
ECHO Create Optional part of Deployment command for DSMX 
ECHO +------------------------------------------------------------------------------------+
ECHO
SET OPTIONAL_COMMAND=%LANDINGPAGEDATADIR_COMMAND% %SHAREDSETTINGSFILE_COMMAND% %DSMXSERVERKEY_COMMAND% %DSMIMASTERURL_COMMAND% %FAILOVERENDPOINT_COMMAND% %DEFAULTREDIRECTURL_COMMAND% %DSMIFRONTENDURL_COMMAND%

ECHO %OPTIONAL_COMMAND%

ECHO +------------------------------------------------------------------------------------+
ECHO Create SQL Auth part of Deployment command
ECHO +------------------------------------------------------------------------------------+
ECHO
IF NOT "%SQLUSERNAME%" == "" (
	IF NOT "%SQLPASSWORD%" == "" (
		SET SQLAUTH_COMMAND=SQLUSERNAME="%SQLUSERNAME%" SQLPASSWORD="%SQLPASSWORD%" ))
ECHO %SQLAUTH_COMMAND%

ECHO +------------------------------------------------------------------------------------+
ECHO Create IIS Application Identitiy User Specification part of Deployment command for DSMX
ECHO +------------------------------------------------------------------------------------+
ECHO
IF NOT "%IISAPPIDENTITYUSERNAME%" == "" (
	IF NOT "%IISAPPIDENTITYPASSWORD%" == "" (
		SET IISAPPIDENTITY_COMMAND=IISAPPIDENTITYUSERNAME="%IISAPPIDENTITYUSERNAME%" IISAPPIDENTITYPASSWORD="%IISAPPIDENTITYPASSWORD%" ))

ECHO %IISAPPIDENTITY_COMMAND%

ECHO +------------------------------------------------------------------------------------+
ECHO Create Service User Specification part of Deployment command
ECHO +------------------------------------------------------------------------------------+
ECHO
IF NOT "%SERVICE_USERNAME%" == "" (
	IF NOT "%SERVICE_PASSWORD%" == "" (
		SET SERVICE_COMMAND=SERVICE_USERNAME="%SERVICE_USERNAME%" SERVICE_PASSWORD="%SERVICE_PASSWORD%" SERVICE_DOMAIN="%SERVICE_DOMAIN%" ))
		
ECHO %SERVICE_COMMAND%

REM ************************************************************************************************

ECHO +------------------------------------------------------------------------------------+
ECHO Main part of Installation Service command
ECHO +------------------------------------------------------------------------------------+
ECHO

IF "%DEBUG_RUN%" == "true" (
  GOTO DEBUG )

ECHO +------------------------------------------------------------------------------------+
ECHO Create BackUp of DSMX Configuration file and DSMComponents directories
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%BACKUP_DSMXCONFIGURATIONFILES%" == "true" (
ECHO ***Creating BackUp of Webiste as Recursive disabled***
DSMInstallationClient.exe backup /endpoint:"https://%FQDN%/DSMInstallationService.svc"  /source="%WEBSITES%" /destination="%BACKUP_DIRECTORY%\Website" /recursive:no
IF ERRORLEVEL 1 GOTO MYERROR 

ECHO ***Creating BackUp of EMAILBACKEND directory***
DSMInstallationClient.exe backup /endpoint:"https://%FQDN%/DSMInstallationService.svc"  /source="%EMAILBACKEND%" /destination="%BACKUP_DIRECTORY%\DSMComponents"
IF ERRORLEVEL 1 GOTO MYERROR

ECHO ***Creating BackUp of Trigger Service directory***
DSMInstallationClient.exe backup /endpoint:"https://%FQDN%/DSMInstallationService.svc"  /source="%TRIGGERBACKEND%" /destination="%BACKUP_DIRECTORY%\DSMComponents"
IF ERRORLEVEL 1 GOTO MYERROR )

ECHO +------------------------------------------------------------------------------------+
ECHO Create BackUp of DSMX LandingPageData directory
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%BACKUP_DSMX_LANDINGPAGEDATA%" == "true" (

ECHO ***Creating BackUp of LandingPageDat directory***
DSMInstallationClient.exe backup /endpoint:"https://%FQDN%/DSMInstallationService.svc"  /source="%LANDINGPAGEDATADIR%" /destination="%BACKUP_DIRECTORY%\Website"
IF ERRORLEVEL 1 GOTO MYERROR )

ECHO +------------------------------------------------------------------------------------+
ECHO Create Database BackUp of DSMX --- %DSMX_SQLDATABASENAME%
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%DATABASE_BACKUP%" == "true" (
	IF "%SQL_AUTHENTICATION%" == "true" (
		ECHO ***Creating BackUp of Crossmedia databse, then shrink it afterward. Use SQL Authentication ***
		DSMInstallationClient.exe dbbackup /endpoint:"https://%FQDN%/DSMInstallationService.svc" /sqlserver="%SQLINSTANCENAME%" /dbname="%DSMX_SQLDATABASENAME%" /username="%SQLUSERNAME%" /password="%SQLPASSWORD%" /destination="%BACKUP_DIRECTORY%\Database\%DSMX_SQLDATABASENAME%.bak" /shrink="%SHRINK_DATABASE%" /timeout="%DB_TIMEOUT%" 
		IF ERRORLEVEL 1 GOTO MYERROR ))	ELSE (
		ECHO ***Creating BackUp of Crossmedia databse, then shrink it afterward. Use Windows Authentication***
		DSMInstallationClient.exe dbbackup /endpoint:"https://%FQDN%/DSMInstallationService.svc"  /sqlserver="%SQLINSTANCENAME%" /dbname="%DSMX_SQLDATABASENAME%" /destination="%BACKUP_DIRECTORY%\Database\%DSMX_SQLDATABASENAME%.bak" /shrink="%SHRINK_DATABASE%" /timeout="%DB_TIMEOUT%"
		IF ERRORLEVEL 1 GOTO MYERROR )

ECHO +------------------------------------------------------------------------------------+
ECHO Pre-Version Check - DirectSmile Crossmedia
ECHO +------------------------------------------------------------------------------------+
ECHO
DSMInstallationClient.exe version /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productCode:DSMX


ECHO +------------------------------------------------------------------------------------+
ECHO Restart IIS via DSM Installation Service as stop-start AppPool
ECHO +------------------------------------------------------------------------------------+
ECHO
DSMInstallationClient.exe appcmd /args:"stop apppool /apppool.name:""%APPPOOLNAME%""" /endpoint:"https://%FQDN%/DSMInstallationService.svc"

DSMInstallationClient.exe appcmd /args:"start apppool /apppool.name:""%APPPOOLNAME%""" /endpoint:"https://%FQDN%/DSMInstallationService.svc"

ECHO +------------------------------------------------------------------------------------+
ECHO Uninstall DSMX from the server
ECHO +------------------------------------------------------------------------------------+
ECHO

DSMInstallationClient.exe uninstall /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productcode:DSMX /servicename:DirectSmileTriggerService
IF ERRORLEVEL 1 GOTO MYERROR


ECHO +------------------------------------------------------------------------------------+
ECHO Main part of Installation Service Deployment commands
ECHO +------------------------------------------------------------------------------------+
ECHO

IF "%SQL_AUTHENTICATION%" == "true" (
	IF "%CONFIGURE_IISAPPLICATIONPOOLIDENTITY_USER%" == "true" (
		IF "%CONFIGURE_LOGINUSERFORBACKEND%" == "true" (
			ECHO +------------------------------------------------------------------------------------+
			ECHO Installation Commands for "SQL_Auth" and "IISApplicationPoolIdentityUser_Specified" and "ServiceLoginUser_Specified"
			ECHO +------------------------------------------------------------------------------------+
			%COMMON_COMMAND% %OPTIONAL_COMMAND% %SQLAUTH_COMMAND% %IISAPPIDENTITY_COMMAND% %SERVICE_COMMAND%
			IF ERRORLEVEL 1 GOTO MYERROR 
			GOTO POSTCHECK ) ELSE ( 
				ECHO +------------------------------------------------------------------------------------+
				ECHO Installation Commands for "SQL_Auth" and "IISApplicationPoolIdentityUser_Specified"
				ECHO +------------------------------------------------------------------------------------+
				%COMMON_COMMAND% %OPTIONAL_COMMAND% %SQLAUTH_COMMAND% %IISAPPIDENTITY_COMMAND%
				IF ERRORLEVEL 1 GOTO MYERROR 
				GOTO POSTCHECK )) ELSE IF "%CONFIGURE_LOGINUSERFORBACKEND%" == "true" (
			ECHO +------------------------------------------------------------------------------------+
			ECHO Installation Commands for "SQL_Auth" and "ServiceLoginUser_Specified"
			ECHO +------------------------------------------------------------------------------------+
			%COMMON_COMMAND% %OPTIONAL_COMMAND% %SQLAUTH_COMMAND% %SERVICE_COMMAND%
			IF ERRORLEVEL 1 GOTO MYERROR 
			GOTO POSTCHECK )
	ECHO +------------------------------------------------------------------------------------+
	ECHO Installation Commands for "SQL_Auth"
	ECHO +------------------------------------------------------------------------------------+
	%COMMON_COMMAND% %OPTIONAL_COMMAND% %SQLAUTH_COMMAND%
	IF ERRORLEVEL 1 GOTO MYERROR 
	GOTO POSTCHECK ) ELSE IF "%CONFIGURE_IISAPPLICATIONPOOLIDENTITY_USER%" == "true" (
	IF "%CONFIGURE_LOGINUSERFORBACKEND%" == "true" (
		ECHO +------------------------------------------------------------------------------------+
		ECHO Installation Commands for "IISApplicationPoolIdentityUser_Specified" and "ServiceLoginUser_Specified"
		ECHO +------------------------------------------------------------------------------------+
		%COMMON_COMMAND% %OPTIONAL_COMMAND% %IISAPPIDENTITY_COMMAND% %SERVICE_COMMAND%
		IF ERRORLEVEL 1 GOTO MYERROR 
		GOTO POSTCHECK ) ELSE (
		ECHO +------------------------------------------------------------------------------------+
		ECHO Installation Commands for "IISApplicationPoolIdentityUser_Specified"
		ECHO +------------------------------------------------------------------------------------+
		%COMMON_COMMAND% %OPTIONAL_COMMAND% %IISAPPIDENTITY_COMMAND%
		IF ERRORLEVEL 1 GOTO MYERROR 
		GOTO POSTCHECK )) ELSE IF "%CONFIGURE_LOGINUSERFORBACKEND%" == "true" (
	ECHO +------------------------------------------------------------------------------------+
	ECHO Installation Commands for "ServiceLoginUser_Specified"
	ECHO +------------------------------------------------------------------------------------+
	%COMMON_COMMAND% %OPTIONAL_COMMAND% %SERVICE_COMMAND%
	IF ERRORLEVEL 1 GOTO MYERROR 
	GOTO POSTCHECK  ) ELSE (
ECHO +------------------------------------------------------------------------------------+
ECHO Installation Commands for Default
ECHO +------------------------------------------------------------------------------------+
%COMMON_COMMAND% %OPTIONAL_COMMAND%
IF ERRORLEVEL 1 GOTO MYERROR )

:POSTCHECK
ECHO +------------------------------------------------------------------------------------+
ECHO Post-Version Check after the Update - DirectSmile Crossmedia
ECHO +------------------------------------------------------------------------------------+
ECHO
DSMInstallationClient.exe version /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productCode:DSMX

EXIT 0

:MYERROR
EXIT 1



:DEBUG
ECHO **************************
ECHO *     DEBUG MODE         *
ECHO * Just echoing the calls *
ECHO **************************
ECHO +------------------------------------------------------------------------------------+
ECHO Main part of Crossmedia Deployment commands
ECHO +------------------------------------------------------------------------------------+
ECHO

IF "%SQL_AUTHENTICATION%" == "true" (
	IF "%CONFIGURE_IISAPPLICATIONPOOLIDENTITY_USER%" == "true" (
		IF "%CONFIGURE_LOGINUSERFORBACKEND%" == "true" (
			ECHO +------------------------------------------------------------------------------------+
			ECHO Installation Commands for "SQL_Auth" and "IISApplicationPoolIdentityUser_Specified" and "ServiceLoginUser_Specified"
			ECHO +------------------------------------------------------------------------------------+
			ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND% %SQLAUTH_COMMAND% %IISAPPIDENTITY_COMMAND% %SERVICE_COMMAND%) ELSE ( 
				ECHO +------------------------------------------------------------------------------------+
				ECHO Installation Commands for "SQL_Auth" and "IISApplicationPoolIdentityUser_Specified"
				ECHO +------------------------------------------------------------------------------------+
				ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND% %SQLAUTH_COMMAND% %IISAPPIDENTITY_COMMAND%)) ELSE IF "%CONFIGURE_LOGINUSERFORBACKEND%" == "true" (
			ECHO +------------------------------------------------------------------------------------+
			ECHO Installation Commands for "SQL_Auth" and "ServiceLoginUser_Specified"
			ECHO +------------------------------------------------------------------------------------+
			ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND% %SQLAUTH_COMMAND% %SERVICE_COMMAND%)
	ECHO +------------------------------------------------------------------------------------+
	ECHO Installation Commands for "SQL_Auth"
	ECHO +------------------------------------------------------------------------------------+
	ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND% %SQLAUTH_COMMAND%) ELSE IF "%CONFIGURE_IISAPPLICATIONPOOLIDENTITY_USER%" == "true" (
	IF "%CONFIGURE_LOGINUSERFORBACKEND%" == "true" (
		ECHO +------------------------------------------------------------------------------------+
		ECHO Installation Commands for "IISApplicationPoolIdentityUser_Specified" and "ServiceLoginUser_Specified"
		ECHO +------------------------------------------------------------------------------------+
		ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND% %IISAPPIDENTITY_COMMAND% %SERVICE_COMMAND%) ELSE (
		ECHO +------------------------------------------------------------------------------------+
		ECHO Installation Commands for "IISApplicationPoolIdentityUser_Specified"
		ECHO +------------------------------------------------------------------------------------+
		ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND% %IISAPPIDENTITY_COMMAND%)) ELSE IF "%CONFIGURE_LOGINUSERFORBACKEND%" == "true" (
	ECHO +------------------------------------------------------------------------------------+
	ECHO Installation Commands for "ServiceLoginUser_Specified"
	ECHO +------------------------------------------------------------------------------------+
	ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND% %SERVICE_COMMAND%) ELSE (
ECHO +------------------------------------------------------------------------------------+
ECHO Installation Commands for Default
ECHO +------------------------------------------------------------------------------------+
ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND%)

EXIT 0