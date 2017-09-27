// This is All in one DirectSmile program deployment job generation groovy script
//ALL Upper case indicates Environmental Variable comes from Jenkins as Parameter input
if (binding.variables.get('DEBUG_RUN')) {
	//Inherite value from env var comes Jenkins
	//This part set default value for Credential ID(SQL_CREDENTIAL,IISAPPLICATIONPOOLIDENTITY_CREDENTIAL), to avoid any failure due to missing ID specification.
	//Please replace it with your own Jenkins server's whatever Credenital ID that you can show it as kind of example
	if (SQL_CREDENTIAL == ''|IISAPPLICATIONPOOLIDENTITY_CREDENTIAL == '') {
	//Set Default Credential ID
		DEFAULT_SQL_CRDENTIAL_ID = 'Example-SQL-Credential-ID'
		DEFAULT_LOGIN_CRDENTIAL_ID = 'Example-Login-Credential-ID'
		SQL_CREDENTIAL = DEFAULT_SQL_CRDENTIAL_ID
		IISAPPLICATIONPOOLIDENTITY_CREDENTIAL = DEFAULT_LOGIN_CRDENTIAL_ID
		LOGINUSERFORBACKEND_CREDENTIAL = DEFAULT_LOGIN_CRDENTIAL_ID
	}
} else {
	//***************************************************************************
	//******* General Arguments
	//***************************************************************************
		SERVERNAME=SERVERNAME.toUpperCase()
		DEBUG_RUN = 'true'
		DSMG_DEPLOY = 'false'
		DSMI_DEPLOY = 'false'
		DSMX_DEPLOY = 'false'
	//***************************************************************************
	//******* Deployment Version selector
	//***************************************************************************
		DSMG_INSTALLER_FILE_PATH = ''
		DSMI_INSTALLER_FILE_PATH = ''
		DSMX_INSTALLER_FILE_PATH = ''
	//***************************************************************************
	//******* DSMG Relates Arguments
	//***************************************************************************
		DSMG_INSTALLDIR = 'C:\\Program Files (x86)\\DirectSmile Generator'
		LOGLEVEL = 'Warning'
		LOGPATH = 'C:\\Program Files (x86)\\DirectSmile\\DirectSmile Logs'
		ALLUSERS = 'true'
		CLIENTUILEVEL = 'false'
		MSILOG = 'C:\\Program Files (x86)\\DirectSmile\\DirectSmile Logs\\DSMG_Deployment_MSILOG.log'
	//***************************************************************************
	//******* DSMI Relates Arguments
	//***************************************************************************
		DIRPROPERTY1 = 'C:\\inetpub\\wwwroot\\DSMO'
		DSMGPATH = 'C:\\Program Files (x86)\\DirectSmile Generator'
		DSMXPATH = 'C:\\inetpub\\wwwroot'	
		DSMI_INSTALLDIR = 'C:\\Program Files (x86)\\DirectSmile\\DirectSmile Online Backend'
		DSMIII = ''
		DSMI_REPLICATION_MASTER = 'false'
		DSMI_REPLICATION_SLAVE = 'false'
		AVOID_USER_SESSION = 'false'
		NOASS = '1'
		BACKENDROUTINGARG = 'dsmi'
		SHORTTIMEOUT = '20'
		CROSSDOMAINURI = '*'
		IISAPPNAME = 'DSMO'
		SERVICE_EXE_NAME = 'DSMOnlineBackend.exe'
		LOG_LEVEL = '1'
	//***************************************************************************
	//******* DSMX Relates Arguments
	//***************************************************************************
		EMAILBACKEND = 'C:\\Program Files (x86)\\DirectSmile\\DirectSmile Email Backend'
		TRIGGERBACKEND = 'C:\\Program Files (x86)\\DirectSmile\\DirectSmile Trigger Service'
		LANDINGPAGEDATADIR = 'C:\\inetpub\\wwwroot\\LandingPageData'
		SHAREDSETTINGSFILE = ''
		DSMXSERVERKEY = ''
		DEFAULTREDIRECTURL = ''
		DSMIMASTERURL = ''
		DSMIFRONTENDURL = ''
		FAILOVERENDPOINT = ''
		WEBSITENAME = 'Default Web Site'
		APPPOOLNAME = 'DefaultAppPool'
		STATICCOMPRESSIONOPTION = 'false'
	//***************************************************************************
	//******* DSMI and DSMX common Arguments
	//***************************************************************************
		DSMOURL= 'http://' + FQDN + '/dsmo'	
		DSMXURL = 'http://' + FQDN
		WEBSITES = 'C:\\inetpub\\wwwroot'
	//***************************************************************************
	//******* DSMI and DSMX common Arguments - Optional configuration
	//***************************************************************************
		CONFIGURE_IISAPPLICATIONPOOLIDENTITY_USER = 'true'
		CONFIGURE_LOGINUSERFORBACKEND = 'true'
		SERVICE_DOMAIN = 'printhosting.com'
	//***************************************************************************
	//******* DSMI and DSMX common Arguments - SQL Database
	//***************************************************************************
		SQLINSTANCENAME = '.'
		DSMI_SQLDATABASENAME = SERVERNAME + '_dsmodb'
		IMGDBNAME = SERVERNAME + '_dsmoImages'
		DSMX_SQLDATABASENAME = SERVERNAME + '_LP3_DSM'	
		SQL_AUTHENTICATION = 'true'
	//***************************************************************************
	//******* DSMI and DSMX common Arguments - Set Default Credential ID
	//***************************************************************************
		DEFAULT_SQL_CRDENTIAL_ID = 'Example-SQL-Credential-ID'
		DEFAULT_LOGIN_CRDENTIAL_ID = 'Example-Login-Credential-ID'
		if (FQDN.toUpperCase().contains('MYPRINTDESK.NET')) { 
			CNNAME = '*.myprintdesk.net' 
			ENABLEWF = '0'
		}
		else if (FQDN.toUpperCase().contains('XMEDIASERVICE.COM')) { 
			CNNAME = '*.xmediaservice.com' 
			ENABLEWF = '1'
		}
		else {
			CNNAME = FQDN 
			ENABLEWF = '0'
		}
		if (SERVERNAME.contains('QA')) {
			DSMUSERS = '\\\\dsmqafs.printhosting.com\\DSMI\\' + SERVERNAME + '\\DSMUsers'
			DSMTEMP = '\\\\dsmqafs.printhosting.com\\DSMI\\' + SERVERNAME + '\\DSMTemp'
			SQL_CREDENTIAL = SERVERNAME + '_SQLCredentials'
			IISAPPLICATIONPOOLIDENTITY_CREDENTIAL = 'DSMQA_Auto_Login'
			LOGINUSERFORBACKEND_CREDENTIAL = 'DSMQA_Auto_Login'
		} 
		else if (SERVERNAME.contains('PRDAPP5')) {
			DSMUSERS = '\\\\ihsfs503\\DSM\\' + SERVERNAME + '\\DSMUsers'
			DSMTEMP = '\\\\ihsfs503\\DSM\\' + SERVERNAME + '\\DSMTemp'
			SQL_CREDENTIAL = SERVERNAME + '_SQLCredentials'
			IISAPPLICATIONPOOLIDENTITY_CREDENTIAL = 'DSMPRD_Auto_Login'
			LOGINUSERFORBACKEND_CREDENTIAL = 'DSMPRD_Auto_Login'
		} 
		else if (SERVERNAME.contains('PRD')) {
			DSMUSERS = '\\\\dsmprdfs.printhosting.com\\DSM\\' + SERVERNAME + '\\DSMUsers'
			DSMTEMP = '\\\\dsmprdfs.printhosting.com\\DSM\\' + SERVERNAME + '\\DSMTemp'
			SQL_CREDENTIAL = SERVERNAME + '_SQLCredentials'
			IISAPPLICATIONPOOLIDENTITY_CREDENTIAL = 'DSMPRD_Auto_Login'
			LOGINUSERFORBACKEND_CREDENTIAL = 'DSMPRD_Auto_Login'
		} 
		else {
			DSMUSERS = 'C:\\DSMUsers'
			DSMTEMP = 'C:\\DSMTemp'
			SQL_CREDENTIAL = DEFAULT_SQL_CRDENTIAL_ID
			IISAPPLICATIONPOOLIDENTITY_CREDENTIAL = DEFAULT_LOGIN_CRDENTIAL_ID
			LOGINUSERFORBACKEND_CREDENTIAL = DEFAULT_LOGIN_CRDENTIAL_ID
		}		
	//***************************************************************************
	//******* DSMIS Backup command common Arguments
	//***************************************************************************
		DSM_BACKUP = 'C:\\DSM_Backup'
		BACKUP_DSMICONFIGURATIONFILES = 'false'
		BACKUP_DSMXCONFIGURATIONFILES = 'false'
		BACKUP_DSMX_LANDINGPAGEDATA = 'false'
		DATABASE_BACKUP = 'false'
		SHRINK_DATABASE = 'false'
		DB_TIMEOUT = '30'
	//***************************************************************************
}
// *******************************************************************************************************
// Here is additional code to support new parameters
// *******************************************************************************************************
if (binding.variables.get('TRIGGER_BLOCK_LIMIT')) {
	} else{
	TRIGGER_BLOCK_LIMIT = '5000'
}
if (binding.variables.get('DSMI_MSILOG')) {
	} else{
	DSMI_MSILOG = 'C:\\Program Files (x86)\\DirectSmile\\DirectSmile Logs\\DSMI_Deployment_MSILOG.log'
}
if (binding.variables.get('DSMX_MSILOG')) {
	} else{
	DSMX_MSILOG = 'C:\\Program Files (x86)\\DirectSmile\\DirectSmile Logs\\DSMX_Deployment_MSILOG.log'
}
// *******************************************************************************************************

// *******************************************************************************************************
// Start Actual Jenkins JobDSL
// *******************************************************************************************************
job('DirectSmile__Deployment_'+ SERVERNAME) {
	parameters {
	//***************************************************************************
	//******* General Arguments ********
        	booleanParam('DEBUG_RUN', false, '<p>If DEBUG_RUN=True all commands will be echoed to the screen only. Target system will not be touched. And it does not trigger downstream jobs</p>')
        	booleanParam('DSMG_DEPLOY', false, '<p>If DSMG_DEPLOY=True, DSMG Deployment commands will be executed. If DSMG_DEPLOY=False, then Target system will not update DSMG component.</p>')
        	booleanParam('DSMI_DEPLOY', false, '<p>If DSMI_DEPLOY=True, DSMI Deployment commands will be executed. If DSMI_DEPLOY=False, then Target system will not update DSMI component.</p>')
        	booleanParam('DSMX_DEPLOY', false, '<p>If DSMX_DEPLOY=True, DSMX Deployment commands will be executed. If DSMX_DEPLOY=False, then Target system will not update DSMX component.</p>')
		stringParam('FQDN', FQDN ,'<p>Fully Qualified Domain Name</p>')
		stringParam('SQLINSTANCENAME',SQLINSTANCENAME,'Instance name of your SQL Server<p>.\\SQLEXPRESS</p>')
	//***************************************************************************
	//******* Deployment Version selector
	//***************************************************************************
        	choiceParam('DSMG_DEPLOY_VERSION',['DSMG_SPECIFIC_VERSION','DSMG_LATEST_RELEASE','DSMG_DSF_RELEASE'],'')
		choiceParam('DSMI_DEPLOY_VERSION', ['DSMI_SPECIFIC_VERSION','DSMI_LATEST_RELEASE','DSMI_DSF_RELEASE'],'')
		choiceParam('DSMX_DEPLOY_VERSION', ['DSMX_SPECIFIC_VERSION','DSMX_LATEST_RELEASE','DSMX_DSF_RELEASE'],'')
		stringParam('DSMG_INSTALLER_FILE_PATH', DSMG_INSTALLER_FILE_PATH, 'Absolute File Path or URL to DSMG installer')
		stringParam('DSMI_INSTALLER_FILE_PATH', DSMI_INSTALLER_FILE_PATH, 'Absolute File Path or URL to DSMI installer')
		stringParam('DSMX_INSTALLER_FILE_PATH', DSMX_INSTALLER_FILE_PATH, 'Absolute File Path or URL to DSMX installer</br></br></br><h3><font color="red">DO NOT EDIT BELOW THIS LINE</h3>')
	//***************************************************************************
	//******* DSMG Relates Arguments
	//***************************************************************************
		stringParam('DSMG_INSTALLDIR', DSMG_INSTALLDIR, '<p>Installation target directory for DirectSmile Generator</p>')
		choiceParam('LOGLEVEL', ['Warning', 'Information', 'Critical', 'Error', 'Resume', 'Start', 'Stop', 'Suspend', 'Transfer', 'Verbose'],'<h3><font color="red">Only Valid &gt; Ver6.0.0.48</font></h3> <p>LOGLEVEL install param to configure loglevel (default=Warning)</p> <table cellspacing="1" summary="TraceEventType"><tbody><tr><th>TraceEventType</th><th>Description</th></tr><tr><td>Critical</td><td>Critical Error or Application Crash</td></tr><tr><td>Error</td><td>Recoverable Error</td></tr><tr><td>Information</td><td>Information message</td></tr><tr><td>Resume</td><td>Resume processing</td></tr><tr><td>Start</td><td>Start processing</td></tr><tr><td>Stop</td><td>Stop processing</td></tr><tr><td>Suspend</td><td>Suspend processing</td></tr><tr><td>Transfer</td><td>Change relative ID</td></tr><tr><td>Verbose</td><td>Debug tracing</td></tr><tr><td>Warning</td><td>Not important issues</td></tr></tbody> </table>')
		stringParam('LOGPATH',LOGPATH,'<h3><font color="red">Only Valid &gt; Ver6.0.0.48</font></h3></br><p>LOGPATH="C:\\Program Files (x86)\\DirectSmile\\DirectSmile Logs"</p></br></br><p>if NOT empty, the installer write input in DirectSmile Generator.exe.config</p></br>')
		booleanParam('ALLUSERS', ALLUSERS.toBoolean(), '<p>If ALLUSERS=True(Automatically convert to ALLUSERS=1 in actual deployment script), Register components for all users.</p>')
		booleanParam('CLIENTUILEVEL', CLIENTUILEVEL.toBoolean(), '<p>If CLIENTUILEVEL=false(Automatically convert to CLIENTUILEVEL=0 in actual deployment script), Installation dialog visibility level would be changed</p>')
		stringParam('MSILOG', MSILOG,'<h3><font color="red">Only Valid &gt; Ver1.0.0.94 of DSM Installation Service</font></h3></br><p>MSILOG="C:\\Program Files (x86)\\DirectSmile\\DirectSmile Logs\\DSMI_Deployment_MSILOG.log"</p></br></br><p>if NOT empty, the installer write msi log file by specified path/name</p></br>')
	//***************************************************************************
	//******* DSMI and DSMX common Arguments
	//***************************************************************************
		stringParam('DSMOURL',DSMOURL,'<h3><font color="red">Only Valid &gt; Ver7.2.0.60</font></h3></br> <p>DSMOURL="http://servername/dsmo"</p></br> <p>Please add this parameter to the dsmi installer call to get the base url of DSMI correctly set and to get the url to the dsmimages correctly set.</p></br>')
		stringParam('DSMXURL',DSMXURL,'<h3><font color="red">Only Valid &gt; Ver7.2.0.60</font></h3></br> <p>DSMXURL="http://servername/dsmx"</p><p>(In case of SmartServer deployment)</p></br></br> <p>Please add this parameter to the dsmi installer call to get the base url of DSMX correctly set in the DSMI settings.</p></br>')
		stringParam('WEBSITES', WEBSITES, '<p>UNC Path for the root website directory</p><br/><p>example: c:\\inetpub\\wwwroot</p>')
	//***************************************************************************
	//******* DSMI and DSMX common Arguments - Optional configuration
	//***************************************************************************
	//***************************************************************************
	//******* DSMI and DSMX common Arguments - Set Default Credential ID
	//***************************************************************************
	//Replaced to Credential Plugin with Credential Binding Plugin model
		booleanParam('CONFIGURE_IISAPPLICATIONPOOLIDENTITY_USER',CONFIGURE_IISAPPLICATIONPOOLIDENTITY_USER.toBoolean(),'Only available option higher than Ver6.1! Enable when you use specific user for Application Pool Identity')
		credentialsParam('IISAPPLICATIONPOOLIDENTITY_CREDENTIAL') {
            		type('com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl')
            		defaultValue(IISAPPLICATIONPOOLIDENTITY_CREDENTIAL)
            		description('<p>Usually, you need to specify Domain Account which has enough privileges to access relevant directory and service</p>')
        	}
	//Replaced to Credential Plugin with Credential Binding Plugin model
		booleanParam('CONFIGURE_LOGINUSERFORBACKEND',CONFIGURE_LOGINUSERFORBACKEND.toBoolean(),'Only available option higher than Ver6.1! Enable when you use specific user as login of DSMOnline Backend to run it as Windows Service')
		stringParam('SERVICE_DOMAIN',SERVICE_DOMAIN,'Service user domain that is executed')
		credentialsParam('LOGINUSERFORBACKEND_CREDENTIAL') {
            		type('com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl')
            		defaultValue(LOGINUSERFORBACKEND_CREDENTIAL)
            		description('<p>In case you run DirectSmile as Service mode, please add new credential in here, then specify your created Credential in here</p>')
        	}
	//***************************************************************************
	//******* DSMI and DSMX common Arguments - SQL Database
	//***************************************************************************
		stringParam('DSMI_SQLDATABASENAME',DSMI_SQLDATABASENAME,'Name of database for the DSMI-default, "dsmodb"')
		stringParam('IMGDBNAME',IMGDBNAME,'Name of dsmoImages database*New from Ver7.0.0.53')
		stringParam('DSMX_SQLDATABASENAME',DSMX_SQLDATABASENAME,'Name of database for the DSMX-default, "LP3_DSM"')
	//Replaced to Credential Plugin with Credential Binding Plugin model
		booleanParam('SQL_AUTHENTICATION',SQL_AUTHENTICATION.toBoolean(),'Does this server use SQL Authentication')
		credentialsParam('SQL_CREDENTIAL') {
            		type('com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl')
		        defaultValue(SQL_CREDENTIAL)
            		description('<p>In case you use SQL Authentication, please add new credential in here, then specify your created Credential in here</p>')
        	}
	//***************************************************************************
	//******* DSMIS Backup command common Arguments
	//***************************************************************************
		stringParam('DSM_BACKUP',DSM_BACKUP,'Location of backup files')
		booleanParam('BACKUP_DSMICONFIGURATIONFILES',BACKUP_DSMICONFIGURATIONFILES.toBoolean(),'Take a backup of DSMI configuration files and DSM Components')
		booleanParam('DATABASE_BACKUP',DATABASE_BACKUP.toBoolean(),'Take a backup of DSMI database')
		stringParam('SHRINK_DATABASE',SHRINK_DATABASE,'Whether shrink database when it is taking a backup')
		stringParam('DB_TIMEOUT',DB_TIMEOUT,'Timeout range of database backup')
		booleanParam('BACKUP_DSMXCONFIGURATIONFILES',BACKUP_DSMXCONFIGURATIONFILES.toBoolean(),'Take a backup of resource files')
		booleanParam('BACKUP_DSMX_LANDINGPAGEDATA',BACKUP_DSMX_LANDINGPAGEDATA.toBoolean(),'Take a backup of the LandigPageData directory(Up to 2GB. It will fail if it exceed more than 2GB because of win 32bit program limitation)')
	//***************************************************************************
	//******* DSMI Relates Arguments
	//***************************************************************************
		stringParam('DIRPROPERTY1', DIRPROPERTY1, 'UNC Path for the DSMI website directory')
		stringParam('CNNAME', CNNAME,'Common Name that your SSL issued to')
		stringParam('DSMGPATH',DSMGPATH,'<h3><font color="red">Only Valid &gt; Ver7.2.0.133</font></h3></br> <p>DSMGPATH="C:\\Program Files (x86)\\DirectSmile Generator"</p></br> <p>if NOT empty, the installer configures the DirectSmileWorkingDirectory in the tblSettings</p></br>')
		stringParam('DSMXPATH',DSMXPATH,'<h3><font color="red">Only Valid &gt; Ver7.2.4</font></h3></br><p>DSMXPATH="C:\\inetpub\\wwwroot"</p></br><p>if NOT empty, the installer write input in DSMXRootPath field of dsmodb.tblSettings.</p></br>')
		stringParam('DSMUSERS',DSMUSERS,'<h3><font color="red">Only Valid &gt; Ver7.2.0.60</font></h3> <p>DSMusers directory is getting created and permissions set if DSMUSERS!=null</p>')
		stringParam('DSMTEMP',DSMTEMP,'<h3><font color="red">Only Valid &gt; Ver7.2.0.54</font></h3> <p>DSMTemp can be set in installer now, creates also app pool and sets the permissions, sets the localimagerepository path and url in dsmodb.tblsettings</p>')
		stringParam('DSMI_INSTALLDIR',DSMI_INSTALLDIR,'Install target directory for DSMOnline Backend')
		stringParam('DSMIII',DSMIII,'DSMI Instance Identifier for systems with multiple DSMI instances.')
		booleanParam('DSMI_REPLICATION_MASTER',DSMI_REPLICATION_MASTER.toBoolean(),'Master Server of the Replication DSMI group')
		booleanParam('DSMI_REPLICATION_SLAVE',DSMI_REPLICATION_SLAVE.toBoolean(),'Slave Server of the Replication DSMI group')
		booleanParam('AVOID_USER_SESSION',AVOID_USER_SESSION.toBoolean(),'If true DSMI Backend is configured to run as native service without user session.')
		booleanParam('NOASS',NOASS.toBoolean(),'<p>Not execute Server Assessment while DSMI Installation</p></br><p>True = Skip Assessment, False = Execute Assessment</p>')
		stringParam('BACKENDROUTINGARG',BACKENDROUTINGARG,'Optional Routing argument added to the DSMI base URL to access the DSMI Backend HTTP handler.')
		stringParam('SHORTTIMEOUT',SHORTTIMEOUT,'Optional Configures the timeout in seconds for image processing requests in the backend.')
		stringParam('CROSSDOMAINURI',CROSSDOMAINURI,'Locks down cross domain access to specific domains')
		stringParam('IISAPPNAME',IISAPPNAME,'Optional Virtual directory name of the DSMI web application')
		stringParam('SERVICE_EXE_NAME',SERVICE_EXE_NAME,'Optional Name of the DSMI Backend service application')
		choiceParam('LOG_LEVEL', ['Information', 'Critical', 'Error', 'Resume', 'Start', 'Stop', 'Suspend', 'Transfer', 'Verbose', 'Warning'],'<h3><font color="red">Only Valid &gt; Ver7.1.0.40</font></h3> <p>LOG_LEVEL install param to configure loglevel (default=Information)</p> <table cellspacing="1" summary="TraceEventType"><tbody><tr><th>TraceEventType</th><th>Description</th></tr><tr><td>Critical</td><td>Critical Error or Application Crash</td></tr><tr><td>Error</td><td>Recoverable Error</td></tr><tr><td>Information</td><td>Information message</td></tr><tr><td>Resume</td><td>Resume processing</td></tr><tr><td>Start</td><td>Start processing</td></tr><tr><td>Stop</td><td>Stop processing</td></tr><tr><td>Suspend</td><td>Suspend processing</td></tr><tr><td>Transfer</td><td>Change relative ID</td></tr><tr><td>Verbose</td><td>Debug tracing</td></tr><tr><td>Warning</td><td>Not important issues</td></tr></tbody> </table>')
		choiceParam('ENABLEWF', [ENABLEWF,'0'],'<h3><font color="red">Only Valid &gt; Ver7.2.0.52</font></h3> <p>ENABLEWF=1|0 enables the Workflow(1) or disables it (0), default is ENABLEWF=1</p>')
		stringParam('DSMI_MSILOG', DSMI_MSILOG,'<h3><font color="red">Only Valid &gt; Ver1.0.0.94 of DSM Installation Service</font></h3></br><p>MSILOG="C:\\Program Files (x86)\\DirectSmile\\DirectSmile Logs\\DSMI_Deployment_MSILOG.log"</p></br></br><p>if NOT empty, the installer write msi log file by specified path/name</p></br>')
	//***************************************************************************
	//******* DSMX Relates Arguments
	//***************************************************************************
		stringParam('EMAILBACKEND',EMAILBACKEND,'UNC path for the DirectSmile Email Backend')
		stringParam('TRIGGERBACKEND',TRIGGERBACKEND,'UNC path for the DirectSmile Trigger Backend')
		stringParam('LANDINGPAGEDATADIR',LANDINGPAGEDATADIR,'UNC path for LandingPageData Directory')
		stringParam('SHAREDSETTINGSFILE',SHAREDSETTINGSFILE,'UNC path of the SharedSettingFile.xml. Important when you store LandingPageData in NAS or FileShare to support cluster DSMX configuration.')
		stringParam('DSMXSERVERKEY',DSMXSERVERKEY,'DSMXServerKey ID. Important when to support cluster/multiple DSMX instance configuration.')
		stringParam('DEFAULTREDIRECTURL',DEFAULTREDIRECTURL,'Default Redirect URL. Important for SaaS configuration')
		stringParam('DSMIMASTERURL',DSMIMASTERURL,'<p>DSMI Master Server URL. Important when to support cluster/multiple DSMI instance configuration.</p></br><p>However, it can be loadbalance DSMI URL from Ver7 DSMI, because of supporting multiple DSMI instance by one SQL DB.</p>')
		stringParam('DSMIFRONTENDURL',DSMIFRONTENDURL,'<p>DSMI Frontend URL. Specify Load Balanced DSMI URL for cluster/multiple DSMI as Crossmedia Backend configuration.</p>')
		stringParam('FAILOVERENDPOINT',FAILOVERENDPOINT,'<p>Redis Failover endpoint URL</p>')
		stringParam('WEBSITENAME',WEBSITENAME,'<p>Crossmedia website Name.</p></br><p>As default, it use "Default Web Site". If you use other than default, change this value. It is crutial to control website by appcmd.</p>')
		stringParam('APPPOOLNAME',APPPOOLNAME,'<p>Crossmedia website Application Pool Name.</p></br><p>As default, it use "DefaultAppPool". If you use other than default, change this value. It is crutial to control website by appcmd.</p>')
		booleanParam('STATICCOMPRESSIONOPTION',STATICCOMPRESSIONOPTION.toBoolean(),'<p>Option to make Static HTTP Content Compression on the DSMX Website.</p></br><p> Important to avoid css issue affected to Google Font not appearing correctly.</p>')
		stringParam('TRIGGER_BLOCK_LIMIT',TRIGGER_BLOCK_LIMIT,'<h3><font color="red">Only Valid &gt; Ver7.3.0.32</font></h3></br> <p>TRIGGER_BLOCK_LIMIT="20000"</p></br> <p>Please add this parameter to the dsmx installer call to set higher number of max block size that campaign manager send out to DSMI Workflow</p></br>')
		stringParam('DSMX_MSILOG', DSMX_MSILOG,'<h3><font color="red">Only Valid &gt; Ver1.0.0.94 of DSM Installation Service</font></h3></br><p>MSILOG="C:\\Program Files (x86)\\DirectSmile\\DirectSmile Logs\\DSMI_Deployment_MSILOG.log"</p></br></br><p>if NOT empty, the installer write msi log file by specified path/name</p></br>')
    }
	scm {
		git {
			remote {
				url ('https://github.com/Tylerbro/DirectSmile-Deployment')
				//credentials('fd99d794-0245-4a6b-a0fa-1d9bb5ffad46')
			}
			branch ('*/master')
			extensions {
				cleanAfterCheckout()
			}
		}
	}
	wrappers {
		credentialsBinding {
			usernamePassword('SQL_USERNAME','SQL_PASSWORD', SQL_CREDENTIAL)
			usernamePassword('IISAPPLICATIONPOOLIDENTITY_USERNAME','IISAPPLICATIONPOOLIDENTITY_PASSWORD', IISAPPLICATIONPOOLIDENTITY_CREDENTIAL)
			usernamePassword('LOGINUSERFORBACKEND_USERNAME','LOGINUSERFORBACKEND_PASSWORD', LOGINUSERFORBACKEND_CREDENTIAL)
		}
	}
	steps {
		dsl {
			external('JobDSL_ALLINONE_Deployment.groovy')
		}
		batchFile('bat_Deployment/DSMG_Deployment.bat')
		powerShell(readFileFromWorkspace ('ps1_DeployInterval/DSMG_Interval.ps1'))
		batchFile('bat_Deployment/DSMI_Deployment.bat')
		powerShell(readFileFromWorkspace ('ps1_DeployInterval/DSMI_Interval.ps1'))
		batchFile('bat_Deployment/DSMX_Deployment.bat')
		powerShell(readFileFromWorkspace ('Utilities/CTP_DSM_Version_Check.ps1'))
	}
	publishers {
		downstreamParameterized{
			trigger('DSMIS APPCMD - Preload Enabled and AlwaysRunning'){
				condition('SUCCESS')
				parameters {
					currentBuild()
					propertiesFile('Version.txt')
				}
			}
			trigger('DirectSmile CTP - Activation'){
				condition('SUCCESS')
				parameters {
					predefinedProps(['DSMG_DEPLOY': '${DSMG_DEPLOY}', 'DSMI_DEPLOY': '${DSMI_DEPLOY}', 'DSMX_DEPLOY': '${DSMX_DEPLOY}', 'TRIGGER_ORIGIN': '${TRIGGER_ORIGIN}','RELEASE_MANGEMENT_TAKE_A_BACKUP_VHD': '${RELEASE_MANGEMENT_TAKE_A_BACKUP_VHD}', 'NEW_BACKUP_BLOB_NAME':'${NEW_BACKUP_BLOB_NAME}', 'CHANGE_LOG':'${CHANGE_LOG}'])
					propertiesFile('Version.txt')
				}
			}
		}
	}
}
