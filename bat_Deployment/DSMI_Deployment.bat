REM DSMI Deploy Batch

@echo off
chcp 1252

cd /d "C:\Program Files (x86)\DirectSmile\DirectSmile Installation Service\Client"

SET "DIRECTSMILE_AZURE_CDN=http://directsmile.blob.core.windows.net/installer"

IF "%DEPLOY_VERSION%" == "DSMI_LATEST_RELEASE" (
	ECHO +------------------------------------------------------------------------------------+
	ECHO Set installer when Job has been triggered as "DSMI_LATEST_RELEASE Mode"
	ECHO +------------------------------------------------------------------------------------+
	ECHO
	SET "COMMAND_URL=%DIRECTSMILE_AZURE_CDN%/dsmi.msi")

IF "%DEPLOY_VERSION%" == "DSMI_DSF_RELEASE" (
	ECHO +------------------------------------------------------------------------------------+
	ECHO Set installer when Job has been triggered as "DSMI_DSF_RELEASE Mode"
	ECHO +------------------------------------------------------------------------------------+
	ECHO
	SET "COMMAND_URL=%DIRECTSMILE_AZURE_CDN%/DSMI-DSF.msi")
	
IF "%DEPLOY_VERSION%" == "DSMI_SPECIFIC_VERSION" (
	ECHO +------------------------------------------------------------------------------------+
	ECHO Set installer when Job has been triggered as "DSMI_SPECIFIC_VERSION" together with "DSMI_INSTALLER_FILE_PATH"
	ECHO +------------------------------------------------------------------------------------+
	ECHO
	SET "COMMAND_URL=%DSMI_INSTALLER_FILE_PATH%")

ECHO +------------------------------------------------------------------------------------+
ECHO SET replication mode /Default "Single"
ECHO +------------------------------------------------------------------------------------+
ECHO
SET "REPTYPE=1"
IF "%DSMI_Replication_Master%" == "true" (
	SET "REPTYPE=3")
IF "%DSMI_Replication_Slave%" == "true" (
	SET "REPTYPE=2")

ECHO +------------------------------------------------------------------------------------+
ECHO SET whether suppress Windows performance check during installation or not
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%NOASS%" == "true" (
	SET NOASS_VALUE=NOASS="1" ) ELSE (
	SET NOASS_VALUE=NOASS="0" )

ECHO +------------------------------------------------------------------------------------+
ECHO SET CrossDomain URI /Default "*"
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%CROSSDOMAINURI%" == "" (
	SET CROSSDOMAINURI="*") ELSE (
	SET CROSSDOMAINURI="%CROSSDOMAINURI%" )

ECHO +------------------------------------------------------------------------------------+
ECHO SET Virtual directory name of the DSMI web application /Default "DSMO"
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%IISAPPNAME%" == "" (
	SET IISAPPNAME="DSMO" ) ELSE (
	SET "IISAPPNAME=%IISAPPNAME%" )

ECHO +------------------------------------------------------------------------------------+
ECHO SET Name of the DSMI Backend service application /Default "DSMOnlineBackend.exe"
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%SERVICE_EXE_NAME%" == "" (
	SET "SERVICE_EXE_NAME_VALUE=") ELSE (
	SET SERVICE_EXE_NAME_VALUE=SERVICE_EXE_NAME="%SERVICE_EXE_NAME%" )

ECHO +------------------------------------------------------------------------------------+
ECHO Identifier of the DSMI instance in a multi instance DSMI server scenario
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%DSMIII%" == "" (
	SET "DSMIII_VALUE=" ) ELSE (
	SET DSMIII_VALUE=DSMI_INSTANCE_IDENTIFIER="%DSMIII%" )

ECHO +------------------------------------------------------------------------------------+
ECHO Specify dsmoImages database to support custom configuration
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%IMGDBNAME%" == "" (
	SET "IMGDBNAME_COMMAND=" ) ELSE (
	SET IMGDBNAME_COMMAND=IMGDBNAME="%IMGDBNAME%" )

ECHO +------------------------------------------------------------------------------------+
ECHO Specify Log Level to support custom configuration
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%LOG_LEVEL%" == "" (
	SET "LOG_LEVEL_COMMAND=" ) ELSE (
	SET LOG_LEVEL_COMMAND=LOG_LEVEL="%LOG_LEVEL%" )

ECHO +------------------------------------------------------------------------------------+
ECHO Specify DSMTemp directory to support custom configuration
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%DSMTEMP%" == "" (
	SET "DSMTEMP_COMMAND=" ) ELSE (
	SET DSMTEMP_COMMAND=DSMTEMP="%DSMTEMP%" )

ECHO +------------------------------------------------------------------------------------+
ECHO Specify DSMUsers directory to support custom configuration
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%DSMUSERS%" == "" (
	SET "DSMUSERS_COMMAND=" ) ELSE (
	SET DSMUSERS_COMMAND=DSMUSERS="%DSMUSERS%" )

ECHO +------------------------------------------------------------------------------------+
ECHO Set Workflow enable/disable to support custom configuration
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%ENABLEWF%" == "" (
	SET "ENABLEWF_COMMAND=" ) ELSE (
	SET ENABLEWF_COMMAND=ENABLEWF="%ENABLEWF%" )

ECHO +------------------------------------------------------------------------------------+
ECHO Set DSMOURL to support custom configuration
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%DSMOURL%" == "" (
	SET "DSMOURL_COMMAND=" ) ELSE (
	SET DSMOURL_COMMAND=DSMOURL="%DSMOURL%"	)

ECHO +------------------------------------------------------------------------------------+
ECHO Set DSMXURL to support custom configuration
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%DSMXURL%" == "" (
	SET "DSMXURL_COMMAND=" ) ELSE (
	SET DSMXURL_COMMAND=DSMXURL="%DSMXURL%"	)
	
ECHO +------------------------------------------------------------------------------------+
ECHO Set DSMGPATH to support custom configuration
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%DSMGPATH%" == "" (
	SET "DSMGPATH_COMMAND=" ) ELSE (
	SET DSMGPATH_COMMAND=DSMGPATH="%DSMGPATH%"	)	

ECHO +------------------------------------------------------------------------------------+
ECHO Set DSMXPATH to support custom configuration
ECHO +------------------------------------------------------------------------------------+
ECHO
IF "%DSMXPATH%" == "" (
	SET "DSMXPATH_COMMAND=" ) ELSE (
	SET DSMXPATH_COMMAND=DSMXPATH="%DSMXPATH%"	)	
	
ECHO +------------------------------------------------------------------------------------+
ECHO Create Common part of Deployment command for DSMI 
ECHO +------------------------------------------------------------------------------------+
ECHO
SET COMMON_COMMAND=DSMInstallationClient.exe install /endpoint:"https://%FQDN%/DSMInstallationService.svc" /url:"%COMMAND_URL%" /productcode:DSMI  /watchdog:yes WEBSITES="%WEBSITES%" DIRPROPERTY1="%DIRPROPERTY1%" CNNAME="%CNNAME%" SQLINSTANCENAME="%SQLINSTANCENAME%" SQLDATABASENAME="%DSMI_SQLDATABASENAME%" INSTALLDIR="%DSMI_INSTALLDIR%" ISSERVERDB="%REPTYPE%" %IMGDBNAME_COMMAND% %LOG_LEVEL_COMMAND% %DSMTEMP_COMMAND% %DSMUSERS_COMMAND% %ENABLEWF_COMMAND% %DSMOURL_COMMAND% %DSMXURL_COMMAND% %DSMGPATH_COMMAND% %DSMXPATH_COMMAND%

ECHO +------------------------------------------------------------------------------------+
ECHO Create Optional part of Deployment command for DSMI 
ECHO +------------------------------------------------------------------------------------+
ECHO
SET OPTIONAL_COMMAND=AVOID_USER_SESSION="%AVOID_USER_SESSION%" BACKENDROUTINGARG="%BACKENDROUTINGARG%" SHORTTIMEOUT="%SHORTTIMEOUT%" CROSSDOMAINURI=%CROSSDOMAINURI% IISAPPNAME="%IISAPPNAME%" %NOASS_VALUE% %SERVICE_EXE_NAME_VALUE% %DSMIII_VALUE%

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

IF "%BACKUP_DSMICONFIGURATIONFILES%" == "true" (
ECHO +------------------------------------------------------------------------------------+
ECHO Create BackUp of DSMI Configuration file and DSMComponents directories /Enabled by default
ECHO +------------------------------------------------------------------------------------+
ECHO
DSMInstallationClient.exe backup /endpoint:"https://%FQDN%/DSMInstallationService.svc"  /source="%DIRPROPERTY1%" /destination="%DSM_BACKUP%\Website" /recursive:no
IF ERRORLEVEL 1 GOTO MYERROR

DSMInstallationClient.exe backup /endpoint:"https://%FQDN%/DSMInstallationService.svc"  /source="%DSMI_INSTALLDIR%" /destination="%DSM_BACKUP%\DSMComponents"
IF ERRORLEVEL 1 GOTO MYERROR )

IF "%DATABASE_BACKUP%" == "true" (
ECHO +------------------------------------------------------------------------------------+
ECHO Create Database BackUp of DSMI --- %DSMI_SQLDATABASENAME%
ECHO +------------------------------------------------------------------------------------+
ECHO
	IF "%SQL_AUTHENTICATION%" == "true" (
		ECHO ***Creating BackUp of DSMI databse, then shrink it afterward***
		DSMInstallationClient.exe dbbackup /endpoint:"https://%FQDN%/DSMInstallationService.svc"  /sqlserver="%SQLINSTANCENAME%" /dbname="%DSMI_SQLDATABASENAME%" /destination="%DSM_BACKUP%\Database\%DSMI_SQLDATABASENAME%.bak" /shrink="%SHRINK_DATABASE%" /timeout="%DB_TIMEOUT%" /username="%SQL_USERNAME%" /password="%SQL_PASSWORD%" 
		IF ERRORLEVEL 1 GOTO MYERROR ) ELSE (
		ECHO ***Creating BackUp of DSMI databse, then shrink it afterward***
		DSMInstallationClient.exe dbbackup /endpoint:"https://%FQDN%/DSMInstallationService.svc"  /sqlserver="%SQLINSTANCENAME%" /dbname="%DSMI_SQLDATABASENAME%" /destination="%DSM_BACKUP%\Database\%DSMI_SQLDATABASENAME%.bak" /shrink="%SHRINK_DATABASE%" /timeout="%DB_TIMEOUT%"
		IF ERRORLEVEL 1 GOTO MYERROR ))

ECHO +------------------------------------------------------------------------------------+
ECHO Check Current DSMI Version
ECHO +------------------------------------------------------------------------------------+
ECHO
DSMInstallationClient.exe version /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productCode:DSMI

IF ERRORLEVEL 1 GOTO MYERROR
ECHO +------------------------------------------------------------------------------------+
ECHO Uninstallation of DSMI
ECHO +------------------------------------------------------------------------------------+
ECHO
DSMInstallationClient.exe uninstall /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productcode:DSMI /servicename:DSMOnlineBackend /ProcessesToKill:"DirectSmile Generator;DSMWatchDog;VDPOnlineServer"
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
	GOTO POSTCHECK ) ELSE (
ECHO +------------------------------------------------------------------------------------+
ECHO Installation Commands for Default
ECHO +------------------------------------------------------------------------------------+
%COMMON_COMMAND% %OPTIONAL_COMMAND%
IF ERRORLEVEL 1 GOTO MYERROR )

:POSTCHECK
ECHO +------------------------------------------------------------------------------------+
ECHO Post-Version Check after the Update - DirectSmile Integration Server
ECHO +------------------------------------------------------------------------------------+
ECHO
DSMInstallationClient.exe version /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productCode:DSMI

EXIT 0

:MYERROR
EXIT 1

:DEBUG
ECHO **************************
ECHO *     DEBUG MODE         *
ECHO * Just echoing the calls *
ECHO **************************

IF "%BACKUP_DSMICONFIGURATIONFILES%" == "true" (
ECHO +------------------------------------------------------------------------------------+
ECHO DSBUG: Create BackUp of DSMI Configuration file and DSMComponents directories /Enabled by default
ECHO +------------------------------------------------------------------------------------+
ECHO
ECHO DSMInstallationClient.exe backup /endpoint:"https://%FQDN%/DSMInstallationService.svc"  /source="%DIRPROPERTY1%" /destination="%DSM_BACKUP%\Website" /recursive:no

ECHO DSMInstallationClient.exe backup /endpoint:"https://%FQDN%/DSMInstallationService.svc"  /source="%DSMI_INSTALLDIR%" /destination="%DSM_BACKUP%\DSMComponents")

IF "%DATABASE_BACKUP%" == "true" (
ECHO +------------------------------------------------------------------------------------+
ECHO DSBUG: Create Database BackUp of DSMI --- %DSMI_SQLDATABASENAME%
ECHO +------------------------------------------------------------------------------------+
ECHO
	IF "%SQL_AUTHENTICATION%" == "true" (
		ECHO ***Creating BackUp of DSMI databse, then shrink it afterward***
		ECHODSMInstallationClient.exe dbbackup /endpoint:"https://%FQDN%/DSMInstallationService.svc"  /sqlserver="%SQLINSTANCENAME%" /dbname="%DSMI_SQLDATABASENAME%" /destination="%DSM_BACKUP%\Database\%DSMI_SQLDATABASENAME%.bak" /shrink="%SHRINK_DATABASE%" /timeout="%DB_TIMEOUT%" /username="%SQL_USERNAME%" /password="%SQL_PASSWORD%" ) ELSE (
		ECHO ***Creating BackUp of DSMI databse, then shrink it afterward***
		ECHO DSMInstallationClient.exe dbbackup /endpoint:"https://%FQDN%/DSMInstallationService.svc"  /sqlserver="%SQLINSTANCENAME%" /dbname="%DSMI_SQLDATABASENAME%" /destination="%DSM_BACKUP%\Database\%DSMI_SQLDATABASENAME%.bak" /shrink="%SHRINK_DATABASE%" /timeout="%DB_TIMEOUT%" ))

ECHO +------------------------------------------------------------------------------------+
ECHO DSBUG: Check Current DSMI Version
ECHO +------------------------------------------------------------------------------------+
ECHO
ECHO DSMInstallationClient.exe version /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productCode:DSMI

ECHO +------------------------------------------------------------------------------------+
ECHO DSBUG: Uninstallation of DSMI
ECHO +------------------------------------------------------------------------------------+
ECHO
ECHO DSMInstallationClient.exe uninstall /endpoint:"https://%FQDN%/DSMInstallationService.svc" /productcode:DSMI /servicename:DSMOnlineBackend /ProcessesToKill:"DirectSmile Generator;DSMWatchDog;VDPOnlineServer"

ECHO +------------------------------------------------------------------------------------+
ECHO DSBUG: Main part of Installation Service Deployment commands
ECHO +------------------------------------------------------------------------------------+
ECHO

IF "%SQL_AUTHENTICATION%" == "true" (
	IF "%CONFIGURE_IISAPPLICATIONPOOLIDENTITY_USER%" == "true" (
		IF "%CONFIGURE_LOGINUSERFORBACKEND%" == "true" (
			ECHO +------------------------------------------------------------------------------------+
			ECHO DSBUG: Installation Commands for "SQL_Auth" and "IISApplicationPoolIdentityUser_Specified" and "ServiceLoginUser_Specified"
			ECHO +------------------------------------------------------------------------------------+
			ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND% %SQLAUTH_COMMAND% %IISAPPIDENTITY_COMMAND% %SERVICE_COMMAND%
			EXIT 0 ) ELSE (
			ECHO +------------------------------------------------------------------------------------+
			ECHO DSBUG: Installation Commands for "SQL_Auth" and "IISApplicationPoolIdentityUser_Specified"
			ECHO +------------------------------------------------------------------------------------+
			ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND% %SQLAUTH_COMMAND% %IISAPPIDENTITY_COMMAND%
			EXIT 0 )) ELSE IF "%CONFIGURE_LOGINUSERFORBACKEND%" == "true" (
						ECHO +------------------------------------------------------------------------------------+
						ECHO DSBUG: Installation Commands for "SQL_Auth" and "ServiceLoginUser_Specified"
						ECHO +------------------------------------------------------------------------------------+
						ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND% %SQLAUTH_COMMAND% %SERVICE_COMMAND%
						EXIT 0 )
	ECHO +------------------------------------------------------------------------------------+
	ECHO DSBUG: Installation Commands for "SQL_Auth"
	ECHO +------------------------------------------------------------------------------------+
	ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND% %SQLAUTH_COMMAND%) ELSE IF "%CONFIGURE_IISAPPLICATIONPOOLIDENTITY_USER%" == "true" (
	IF "%CONFIGURE_LOGINUSERFORBACKEND%" == "true" (
		ECHO +------------------------------------------------------------------------------------+
		ECHO DSBUG: Installation Commands for "IISApplicationPoolIdentityUser_Specified" and "ServiceLoginUser_Specified"
		ECHO +------------------------------------------------------------------------------------+
		ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND% %IISAPPIDENTITY_COMMAND% %SERVICE_COMMAND%
		EXIT 0 ) ELSE (
		ECHO +------------------------------------------------------------------------------------+
		ECHO DSBUG: Installation Commands for "IISApplicationPoolIdentityUser_Specified"
		ECHO +------------------------------------------------------------------------------------+
		ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND% %IISAPPIDENTITY_COMMAND%
		EXIT 0 )) ELSE IF "%CONFIGURE_LOGINUSERFORBACKEND%" == "true" (
	ECHO +------------------------------------------------------------------------------------+
	ECHO DSBUG: Installation Commands for "ServiceLoginUser_Specified"
	ECHO +------------------------------------------------------------------------------------+
	ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND% %SERVICE_COMMAND%
	EXIT 0 ) ELSE (
ECHO +------------------------------------------------------------------------------------+
ECHO DSBUG: Installation Commands for Default
ECHO +------------------------------------------------------------------------------------+
ECHO %COMMON_COMMAND% %OPTIONAL_COMMAND%)

EXIT 0