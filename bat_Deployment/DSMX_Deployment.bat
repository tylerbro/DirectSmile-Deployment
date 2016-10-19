REM DSMX Deploy Batch

@echo off
chcp 1252

cd /d "C:\Program Files (x86)\DirectSmile\DirectSmile Installation Service\Client"

SET "DIRECTSMILE_AZURE_CDN=http://directsmile.blob.core.windows.net/installer"

IF "%DEPLOY_VERSION%" == "DSMX_LATEST_RELEASE" (
	ECHO +------------------------------------------------------------------------------------+
	ECHO Set installer when Job has been triggered as "DSMX_LATEST_RELEASE Mode"
	ECHO +------------------------------------------------------------------------------------+
	ECHO
	SET "COMMAND_URL=%DIRECTSMILE_AZURE_CDN%/dsmx.msi")

IF "%DEPLOY_VERSION%" == "DSMX_DSF_RELEASE" (
	ECHO +------------------------------------------------------------------------------------+
	ECHO Set installer when Job has been triggered as "DSMX_DSF_RELEASE Mode"
	ECHO +------------------------------------------------------------------------------------+
	ECHO
	SET "COMMAND_URL=%DIRECTSMILE_AZURE_CDN%/DSMX-DSF.msi")
	
IF "%DEPLOY_VERSION%" == "DSMX_SPECIFIC_VERSION" (
	ECHO +------------------------------------------------------------------------------------+
	ECHO Set installer when Job has been triggered as "DSMX_SPECIFIC_VERSION" together with "DSMX_INSTALLER_FILE_PATH"
	ECHO +------------------------------------------------------------------------------------+
	ECHO
	SET "COMMAND_URL=%DSMX_INSTALLER_FILE_PATH%")
REM ************************************************************************************************

ECHO +------------------------------------------------------------------------------------+
ECHO Create Common part of Deployment command for DSMX
ECHO +------------------------------------------------------------------------------------+
ECHO
SET COMMON_COMMAND=DSMInstallationClient.exe install /endpoint:"https://%FQDN%/DSMInstallationService.svc"  /productCode:DSMX /url:"%COMMAND_URL%" WEBSITES="%WEBSITES%" DIRPROPERTY1="%WEBSITES%" DSMXURL="%DSMXURL%" DSMOURL="%DSMOURL%" SQLINSTANCENAME="%SQLINSTANCENAME%" SQLDATABASENAME="%DSMX_SQLDATABASENAME%" INSTALLDIR="%EMAILBACKEND%" DIRECTSMILE_TRIGGER_SERVICE="%TRIGGERBACKEND%" 

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
IF "%SQL_AUTHENTICATION%" == "true" (
	SET SQLAUTH_COMMAND=SQLUSERNAME="%SQL_USERNAME%" SQLPASSWORD="%SQL_PASSWORD%") ELSE (
	SET "SQLAUTH_COMMAND=")

	ECHO %SQLAUTH_COMMAND%

ECHO +------------------------------------------------------------------------------------+
ECHO Create IIS Application Identitiy User Specification part of Deployment command
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%CONFIGURE_IISAPPLICATIONPOOLIDENTITY_USER%" == "true" (
	SET IISAPPIDENTITY_COMMAND=IISAPPIDENTITYUSERNAME="%IISAPPLICATIONPOOLIDENTITY_USERNAME%" IISAPPIDENTITYPASSWORD="%IISAPPLICATIONPOOLIDENTITY_PASSWORD%") ELSE (
	SET "IISAPPIDENTITY_COMMAND=")

	ECHO %IISAPPIDENTITY_COMMAND%

ECHO +------------------------------------------------------------------------------------+
ECHO Create Service User Specification part of Deployment command
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%CONFIGURE_LOGINUSERFORBACKEND%" == "true" (
	SET SERVICE_COMMAND=SERVICE_USERNAME="%LOGINUSERFORBACKEND_USERNAME%" SERVICE_PASSWORD="%LOGINUSERFORBACKEND_PASSWORD%" SERVICE_DOMAIN="%SERVICE_DOMAIN%") ELSE (
	SET "SERVICE_COMMAND=")
	
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
		DSMInstallationClient.exe dbbackup /endpoint:"https://%FQDN%/DSMInstallationService.svc" /sqlserver="%SQLINSTANCENAME%" /dbname="%DSMX_SQLDATABASENAME%" /username="%SQL_USERNAME%" /password="%SQL_PASSWORD%" /destination="%BACKUP_DIRECTORY%\Database\%DSMX_SQLDATABASENAME%.bak" /shrink="%SHRINK_DATABASE%" /timeout="%DB_TIMEOUT%" 
		IF ERRORLEVEL 1 GOTO MYERROR ) ELSE (
		ECHO ***Creating BackUp of Crossmedia databse, then shrink it afterward. Use Windows Authentication***
		DSMInstallationClient.exe dbbackup /endpoint:"https://%FQDN%/DSMInstallationService.svc"  /sqlserver="%SQLINSTANCENAME%" /dbname="%DSMX_SQLDATABASENAME%" /destination="%BACKUP_DIRECTORY%\Database\%DSMX_SQLDATABASENAME%.bak" /shrink="%SHRINK_DATABASE%" /timeout="%DB_TIMEOUT%"
		IF ERRORLEVEL 1 GOTO MYERROR ))

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
IF "%BACKUP_DSMXCONFIGURATIONFILES%" == "true" (
ECHO +------------------------------------------------------------------------------------+
ECHO DEBUG: Create BackUp of DSMX Configuration file and DSMComponents directories
ECHO +------------------------------------------------------------------------------------+
ECHO
ECHO ***Creating BackUp of Webiste as Recursive disabled***
ECHO DSMInstallationClient.exe backup /endpoint:"https://%FQDN%/DSMInstallationService.svc"  /source="%WEBSITES%" /destination="%BACKUP_DIRECTORY%\Website" /recursive:no

ECHO ***Creating BackUp of EMAILBACKEND directory***
ECHO DSMInstallationClient.exe backup /endpoint:"https://%FQDN%/DSMInstallationService.svc"  /source="%EMAILBACKEND%" /destination="%BACKUP_DIRECTORY%\DSMComponents"

ECHO ***Creating BackUp of Trigger Service directory***
ECHO DSMInstallationClient.exe backup /endpoint:"https://%FQDN%/DSMInstallationService.svc"  /source="%TRIGGERBACKEND%" /destination="%BACKUP_DIRECTORY%\DSMComponents")

IF "%BACKUP_DSMX_LANDINGPAGEDATA%" == "true" (
ECHO +------------------------------------------------------------------------------------+
ECHO Create BackUp of DSMX LandingPageData directory
ECHO +------------------------------------------------------------------------------------+
ECHO
ECHO ***Creating BackUp of LandingPageDat directory***
ECHO DSMInstallationClient.exe backup /endpoint:"https://%FQDN%/DSMInstallationService.svc"  /source="%LANDINGPAGEDATADIR%" /destination="%BACKUP_DIRECTORY%\Website")

IF "%DATABASE_BACKUP%" == "true" (
ECHO +------------------------------------------------------------------------------------+
ECHO Create Database BackUp of DSMX --- %DSMX_SQLDATABASENAME%
ECHO +------------------------------------------------------------------------------------+
ECHO
	IF "%SQL_AUTHENTICATION%" == "true" (
		ECHO ***Creating BackUp of Crossmedia databse, then shrink it afterward. Use SQL Authentication ***
		ECHO DSMInstallationClient.exe dbbackup /endpoint:"https://%FQDN%/DSMInstallationService.svc" /sqlserver="%SQLINSTANCENAME%" /dbname="%DSMX_SQLDATABASENAME%" /username="%SQL_USERNAME%" /password="%SQL_PASSWORD%" /destination="%BACKUP_DIRECTORY%\Database\%DSMX_SQLDATABASENAME%.bak" /shrink="%SHRINK_DATABASE%" /timeout="%DB_TIMEOUT%") ELSE (
		ECHO ***Creating BackUp of Crossmedia databse, then shrink it afterward. Use Windows Authentication***
		ECHO DSMInstallationClient.exe dbbackup /endpoint:"https://%FQDN%/DSMInstallationService.svc"  /sqlserver="%SQLINSTANCENAME%" /dbname="%DSMX_SQLDATABASENAME%" /destination="%BACKUP_DIRECTORY%\Database\%DSMX_SQLDATABASENAME%.bak" /shrink="%SHRINK_DATABASE%" /timeout="%DB_TIMEOUT%"))

ECHO +------------------------------------------------------------------------------------+
ECHO Pre-Version Check - DirectSmile Crossmedia
ECHO +------------------------------------------------------------------------------------+
ECHO
ECHO DSMInstallationClient.exe version /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productCode:DSMX

ECHO +------------------------------------------------------------------------------------+
ECHO Restart IIS via DSM Installation Service as stop-start AppPool
ECHO +------------------------------------------------------------------------------------+
ECHO
ECHO DSMInstallationClient.exe appcmd /args:"stop apppool /apppool.name:""%APPPOOLNAME%""" /endpoint:"https://%FQDN%/DSMInstallationService.svc"

ECHO DSMInstallationClient.exe appcmd /args:"start apppool /apppool.name:""%APPPOOLNAME%""" /endpoint:"https://%FQDN%/DSMInstallationService.svc"

ECHO +------------------------------------------------------------------------------------+
ECHO Uninstall DSMX from the server
ECHO +------------------------------------------------------------------------------------+
ECHO
ECHO DSMInstallationClient.exe uninstall /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productcode:DSMX /servicename:DirectSmileTriggerService

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
			ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND% %SQLAUTH_COMMAND% %IISAPPIDENTITY_COMMAND% %SERVICE_COMMAND%
			EXIT 0 ) ELSE ( 
				ECHO +------------------------------------------------------------------------------------+
				ECHO Installation Commands for "SQL_Auth" and "IISApplicationPoolIdentityUser_Specified"
				ECHO +------------------------------------------------------------------------------------+
				ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND% %SQLAUTH_COMMAND% %IISAPPIDENTITY_COMMAND%
				EXIT 0 )) ELSE IF "%CONFIGURE_LOGINUSERFORBACKEND%" == "true" (
			ECHO +------------------------------------------------------------------------------------+
			ECHO Installation Commands for "SQL_Auth" and "ServiceLoginUser_Specified"
			ECHO +------------------------------------------------------------------------------------+
			ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND% %SQLAUTH_COMMAND% %SERVICE_COMMAND%
			EXIT 0 )
	ECHO +------------------------------------------------------------------------------------+
	ECHO Installation Commands for "SQL_Auth"
	ECHO +------------------------------------------------------------------------------------+
	ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND% %SQLAUTH_COMMAND%
	EXIT 0 ) ELSE IF "%CONFIGURE_IISAPPLICATIONPOOLIDENTITY_USER%" == "true" (
	IF "%CONFIGURE_LOGINUSERFORBACKEND%" == "true" (
		ECHO +------------------------------------------------------------------------------------+
		ECHO Installation Commands for "IISApplicationPoolIdentityUser_Specified" and "ServiceLoginUser_Specified"
		ECHO +------------------------------------------------------------------------------------+
		ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND% %IISAPPIDENTITY_COMMAND% %SERVICE_COMMAND%
		EXIT 0 ) ELSE (
		ECHO +------------------------------------------------------------------------------------+
		ECHO Installation Commands for "IISApplicationPoolIdentityUser_Specified"
		ECHO +------------------------------------------------------------------------------------+
		ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND% %IISAPPIDENTITY_COMMAND%
		EXIT 0 )) ELSE IF "%CONFIGURE_LOGINUSERFORBACKEND%" == "true" (
	ECHO +------------------------------------------------------------------------------------+
	ECHO Installation Commands for "ServiceLoginUser_Specified"
	ECHO +------------------------------------------------------------------------------------+
	ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND% %SERVICE_COMMAND%
	EXIT 0 ) ELSE (
ECHO +------------------------------------------------------------------------------------+
ECHO Installation Commands for Default
ECHO +------------------------------------------------------------------------------------+
ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND%)

EXIT 0