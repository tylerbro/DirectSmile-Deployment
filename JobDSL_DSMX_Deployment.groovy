//	ALL Upper case indicates Environmental Variable comes from Jenkins as Parameter input	

if (binding.variables.containsKey('DEBUG_RUN')) {
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
	//Define default value for all var except Seed Job parameters
    DEBUG_RUN = 'true'
	DSMOURL= 'http://' + FQDN + '/dsmo'	
	DSMXURL = 'http://' + FQDN
	
	DSMX_INSTALLER_FILE_PATH = ''
	
	WEBSITES = 'C:\\inetpub\\wwwroot'
	SQLINSTANCENAME = '.'
	DSMX_SQLDATABASENAME = 'LP3_DSM'
	SQL_AUTHENTICATION = 'false'

	CONFIGURE_IISAPPLICATIONPOOLIDENTITY_USER = 'false'

	CONFIGURE_LOGINUSERFORBACKEND = 'false'
	SERVICE_DOMAIN = ''

	DSM_BACKUP = 'C:\\DSM_Backup'
	BACKUP_DSMXCONFIGURATIONFILES = 'true'
	BACKUP_DSMX_LANDINGPAGEDATA = 'false'
	DATABASE_BACKUP = 'true'
	SHRINK_DATABASE = 'true'
	DB_TIMEOUT = '30'

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
	
	TRIGGER_BLOCK_LIMIT = '5000'

	//Set Default Credential ID
		DEFAULT_SQL_CRDENTIAL_ID = 'Example-SQL-Credential-ID'
		DEFAULT_LOGIN_CRDENTIAL_ID = 'Example-Login-Credential-ID'
		
		SQL_CREDENTIAL = DEFAULT_SQL_CRDENTIAL_ID
		IISAPPLICATIONPOOLIDENTITY_CREDENTIAL = DEFAULT_LOGIN_CRDENTIAL_ID
		LOGINUSERFORBACKEND_CREDENTIAL = DEFAULT_LOGIN_CRDENTIAL_ID
}
job('DSMX_Deployment__' + CUSTOMER_NAME) {
	description('Update DSMX to one of Release, Release Candidate, or Developement version')
    parameters {
        booleanParam('DEBUG_RUN', DEBUG_RUN.toBoolean(), '<p>If DEBUG_RUN=True all commands will be echoed to the screeb only. Target system will not be touched.</p>')
		stringParam('CUSTOMER_NAME', CUSTOMER_NAME,'<h3>Customer Name</h3><p>this value become as post-fix for generated deploy jobs</p>')
		stringParam('FQDN', FQDN ,'<h3>Fully Qualified Domain Name</h3><p>Customer server FQDN which listedn by DSMInstallation Service</p>')
		stringParam('DSMXURL',DSMXURL,'<p>http:// prefix is needed</p>')
		stringParam('DSMOURL',DSMOURL,'<p>http:// prefix and /dsmo as postfix are needed</p>')		
		
		choiceParam('DEPLOY_VERSION', ['DSMX_LATEST_RELEASE','DSMX_DSF_RELEASE','DSMX_SPECIFIC_VERSION'],'<h2>Select version you want to deploy</h2>')
		stringParam('DSMX_INSTALLER_FILE_PATH', DSMX_INSTALLER_FILE_PATH, '<h3>Abosolute File Path or URL</h3><p>You can use local directory path as value in here, as well as UNC path is supported</p><ul> <li>Example input: (URL) <a href="http://directsmile.blob.core.windows.net/installer/dsmx.msi">http://directsmile.blob.core.windows.net/installer/dsmx.msi<br /></a></li> <li>Example input: (UNC)&nbsp; <a href="\\\\NetworkAccessStorage\\DirectSmile\\Installer\\dsmx.msi">\\\\NetworkAccessStorage\\DirectSmile\\Installer\\dsmx.msi</a></li> </ul>')		
		
		stringParam('WEBSITES', WEBSITES, 'UNC Path for the root website directory')

		stringParam('SQLINSTANCENAME',SQLINSTANCENAME,'Instance name of your SQL Server<p>.\\SQLEXPRESS</p>')
		stringParam('DSMX_SQLDATABASENAME',DSMX_SQLDATABASENAME,'Name of database for the DSMX-default, "LP3_DSM"')

//Replaced to Credential Plugin with Credential Binding Plugin model
		booleanParam('SQL_AUTHENTICATION',SQL_AUTHENTICATION.toBoolean(),'Does this server use SQL Authentication')
		credentialsParam('SQL_CREDENTIAL') {
            type('com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl')
            defaultValue(SQL_CREDENTIAL)
            description('<h3>SQL Authentication</h3></br><p>In case you use SQL Authentication, please add new credential in here, then specify your created Credential in here</p>')
        }

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
            description('<h3>Login User for Backend</h3></br><p>In case you run DirectSmile as Service mode, please add new credential in here, then specify your created Credential in here</p>')
        }

		stringParam('EMAILBACKEND',EMAILBACKEND,'UNC path for the DirectSmile Email Backend')
		stringParam('TRIGGERBACKEND',TRIGGERBACKEND,'UNC path for the DirectSmile Trigger Backend')
		stringParam('LANDINGPAGEDATADIR',LANDINGPAGEDATADIR,'UNC path for LandingPageData Directory')
		
		stringParam('DSM_BACKUP',DSM_BACKUP,'Location of backup files')
		booleanParam('BACKUP_DSMXCONFIGURATIONFILES',BACKUP_DSMXCONFIGURATIONFILES.toBoolean(),'Take a backup of resource files')
		booleanParam('BACKUP_DSMX_LANDINGPAGEDATA',BACKUP_DSMX_LANDINGPAGEDATA.toBoolean(),'Take a backup of the LandigPageData directory(Up to 2GB. It will fail if it exceed more than 2GB because of win 32bit program limitation)')
		booleanParam('DATABASE_BACKUP',DATABASE_BACKUP.toBoolean(),'Take a backup of the LP3_DSM database')
		stringParam('SHRINK_DATABASE',SHRINK_DATABASE,'Whether shrink database when it is taking a backup')
		stringParam('DB_TIMEOUT',DB_TIMEOUT,'Timeout range of database backup')
		
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
		}
	scm {
		git {
			remote {
				url ('https://github.com/Nobukins/DirectSmile-Deployment')
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
            external('JobDSL_DSMX_Deployment.groovy')
		}
        batchFile('bat_Deployment/DSMX_Deployment.bat')
    }
}