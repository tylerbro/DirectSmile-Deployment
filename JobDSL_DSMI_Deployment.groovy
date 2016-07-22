//	ALL Upper case indicates Environmental Variable comes from Jenkins as Parameter input
if (binding.variables.containsKey('DEBUG_RUN')) {
	//Inherite value from env var comes Jenkins
} else {
    DEBUG_RUN = 'true'
	DSMI_VERSION_NUMBER = '7.2.2.201'
	LOCAL_WEB_DIR = ''
	DSMOURL = ''
	DSMXURL = ''
	WEBSITES = 'C:\\inetpub\\wwwroot'	
	DIRPROPERTY1 = 'C:\\inetpub\\wwwroot\\DSMO'
	CNNAME = ''
	SQLINSTANCENAME = '.'
	DSMI_SQLDATABASENAME = 'dsmodb'
	IMGDBNAME = 'dsmoImages'
	SQL_AUTHENTICATION = 'false'
	SQLUSERNAME = ''
	SQLPASSWORD = ''
	DSMGPATH = 'C:\\Program Files (x86)\\DirectSmile Generator'
	DSMUSERS = 'C:\\DSMUsers'
	DSMTEMP = 'C:\\DSMTemp'
	INSTALLDIR = 'C:\\Program Files (x86)\\DirectSmile\\DirectSmile Online Backend'
	CONFIGURE_IISAPPLICATIONPOOLIDENTITY_USER = 'false'
	IISAPPIDENTITYUSERNAME = ''
	IISAPPIDENTITYPASSWORD = ''
	CONFIGURE_LOGINUSERFORBACKEND = 'false'
	SERVICE_USERNAME = ''
	SERVICE_PASSWORD = ''
	SERVICE_DOMAIN = ''
	DSM_BACKUP = 'C:\\DSM_Backup'
	BACKUP_DSMICONFIGURATIONFILES = 'true'
	DATABASE_BACKUP = 'true'
	SHRINK_DATABASE = 'true'
	DB_TIMEOUT = '30'
	DSMIII = 'DSMI01'
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
	ENABLEWF = '1'
}
job('DSMI_Deployment__' + CUSTOMER_NAME) {
    parameters {
        booleanParam('DEBUG_RUN', false, '<p>If DEBUG_RUN=True all commands will be echoed to the screeb only. Target system will not be touched.</p>')
		stringParam('CUSTOMER_NAME', CUSTOMER_NAME,'<h3>Customer Name</h3><p>this value become as post-fix for generated deploy jobs</p>')
		stringParam('FQDN', FQDN ,'<h3>Fully Qualified Domain Name</h3><p>Customer server FQDN which listedn by DSMInstallation Service</p>')

		choiceParam('DEPLOY_VERSION', ['DSMI_LATEST_RELEASE','DSMI_LATEST_STABLE_RELEASE','DSMI_DSF_RELEASE','DSMI_VER6_0_x','DSMI_VER6_1_x','DSMI_VER6_2_x','DSMI_VER6_3_x','DSMI_VER7_0_x','DSMI_VER7_1_x','DSMI_VER7_2_x','DSMI_TRUNK_VERSION','DSMI_SPECIFIC_VERSION'],'Select version you want to deploy')
		stringParam('DSMI_VERSION_NUMBER', DSMI_VERSION_NUMBER, '<p>This field is only relevant when you select "<strong>DSMI_SPECIFIC_VERSION</strong>" in above selection menu.</p> <p>&nbsp;</p> <p>The file name should have<span style="background-color: #ffff00;"> "</span><strong><span style="background-color: #ffff00;">dsmi-</span></strong><span style="background-color: #ffff00;">"</span> as its prefix. You only need to input version number</p> <ul> <li>Example input: <strong>7.2.2.201</strong></li> </ul> <p>While we create download link, we add "dsmi-" + "%DSMI_VERSION_NUMBER%" + ".msi" automatically. </p> <p>&nbsp;</p> <p>In case you set value in <strong>LOCAL_WEB_DIR</strong>, then this value should be exactly file name of .msi you gonna execute.</p> <ul> <li>Example input: <strong>dsmi-7.2.2.201</strong></li> </ul>')	
		stringParam('LOCAL_WEB_DIR', LOCAL_WEB_DIR, '<p>You can use local directory path as value in here.as well as UNC path is supported</p> <p>Please ensure that you provide "<strong>/</strong>"(slash) for URL case in the end, "<strong>\\</strong>"(back slash) in case of UNC path.</p> <ul> <li>Example input: (URL) <a href="http://myserver/DirectSmile/Installer/">http://myserver/DirectSmile/Installer/<br /></a></li> <li>Example input: (UNC)&nbsp; <a href="\\\\NetworkAccessStorage\\DirectSmile\\Installer\\">\\\\NetworkAccessStorage\\DirectSmile\\Installer\\</a></li> </ul>')		
		
		stringParam('DSMOURL',DSMOURL,'<h3><font color="red">Only Valid > Ver7.2.0.60</font></h3></br> <p>DSMOURL="http://servername/dsmo"</p></br> <p>Please add this parameter to the dsmi installer call to get the base url of DSMI correctly set and to get the url to the dsmimages correctly set.</p></br>')
		stringParam('DSMXURL',DSMXURL,'<h3><font color="red">Only Valid > Ver7.2.0.60</font></h3></br> <p>DSMXURL="http://servername/dsmx"</p><p>(In case of SmartServer deployment)</p></br></br> <p>Please add this parameter to the dsmi installer call to get the base url of DSMX correctly set in the DSMI settings.</p></br>')

		stringParam('WEBSITES', WEBSITES, 'UNC Path for the root website directory')
		stringParam('DIRPROPERTY1', DIRPROPERTY1, 'UNC Path for the DSMI website directory')
		stringParam('CNNAME', CNNAME,'Common Name that your SSL issued to')
		stringParam('SQLINSTANCENAME',SQLINSTANCENAME,'Instance name of your SQL Server<p>.\\SQLEXPRESS</p>')
		stringParam('DSMI_SQLDATABASENAME',DSMI_SQLDATABASENAME,'Name of database for the DSMI-default, "dsmodb"')
		stringParam('IMGDBNAME',IMGDBNAME,'Name of dsmoImages database*New from Ver7.0.0.53')
		booleanParam('SQL_AUTHENTICATION',SQL_AUTHENTICATION.toBoolean(),'Does this server use SQL Authentication')
		stringParam('SQLUSERNAME',SQLUSERNAME,'User name for SQL Authentication')

		//Need to be changed to mask password
		stringParam('SQLPASSWORD',SQLPASSWORD,'Password for SQL Authentication')

		stringParam('DSMGPATH',DSMGPATH,'<h3><font color="red">Only Valid > Ver7.2.0.133</font></h3></br> <p>DSMGPATH="C:\\Program Files (x86)\\DirectSmile Generator"</p></br></br> <p>if NOT empty, the installer configures the DirectSmileWorkingDirectory in the tblSettings</p></br>')

		stringParam('DSMUSERS',DSMUSERS,'<h3><font color="red">Only Valid > Ver7.2.0.60</font></h3> <p>DSMusers directory is getting created and permissions set if DSMUSERS!=null</p>')
		stringParam('DSMTEMP',DSMTEMP,'<h3><font color="red">Only Valid > Ver7.2.0.54</font></h3> <p>DSMTemp can be set in installer now, creates also app pool and sets the permissions, sets the localimagerepository path and url in dsmodb.tblsettings</p>')

		stringParam('DSMI_INSTALLDIR',DSMI_INSTALLDIR,'Install target directory for DSMOnline Backend')
		booleanParam('CONFIGURE_IISAPPLICATIONPOOLIDENTITY_USER',CONFIGURE_IISAPPLICATIONPOOLIDENTITY_USER.toBoolean(),'Only available option higher than Ver6.1! Enable when you use specific user for Application Pool Identity')
		stringParam('IISAPPIDENTITYUSERNAME',IISAPPIDENTITYUSERNAME,'Usually, you need to specify Domain Account which has enough privileges to access relevant directory and service')

		//Need to be changed to mask password
		stringParam('IISAPPIDENTITYPASSWORD',IISAPPIDENTITYPASSWORD,'Usually, you need to specify Domain Account which has enough privileges to access relevant directory and service')

		booleanParam('Configure_LoginUserforBackend',Configure_LoginUserforBackend.toBoolean(),'Only available option higher than Ver6.1! Enable when you use specific user as login of DSMOnline Backend to run it as Windows Service')
		stringParam('SERVICE_USERNAME',SERVICE_USERNAME,'')

		//Need to be changed to mask password
		stringParam('SERVICE_PASSWORD',SERVICE_PASSWORD,'')
		stringParam('SERVICE_DOMAIN',SERVICE_DOMAIN,'Service user domain that is executed')

		stringParam('DSM_BackUp',DSM_BackUp,'Location of backup files')
		booleanParam('BACKUP_DSMICONFIGURATIONFILES',BACKUP_DSMICONFIGURATIONFILES.toBoolean(),'Take a backup of DSMI configuration files and DSM Components')
		booleanParam('DATABASE_BACKUP',DATABASE_BACKUP.toBoolean(),'Take a backup of DSMI database')
		stringParam('SHRINK_DATABASE',SHRINK_DATABASE,'Whether shrink database when it is taking a backup')
		stringParam('DB_TIMEOUT',DB_TIMEOUT,'Timeout range of database backup')

		stringParam('DSMIII',DSMIII,'DSMI Instance Identifier for systems with multiple DSMI instances.')
		booleanParam('DSMI_Replication_Master',DSMI_Replication_Master.toBoolean(),'Master Server of the Replication DSMI group')
		booleanParam('DSMI_Replication_Slave',DSMI_Replication_Slave.toBoolean(),'Slave Server of the Replication DSMI group')
		booleanParam('AVOID_USER_SESSION',AVOID_USER_SESSION.toBoolean(),'If true DSMI Backend is configured to run as native service without user session.')

		booleanParam('NOASS',NOASS.toBoolean(),'<p>Not execute Server Assessment while DSMI Installation</p></br><p>True = Skip Assessment, False = Execute Assessment</p>')
		stringParam('BACKENDROUTINGARG',BACKENDROUTINGARG,'Optional Routing argument added to the DSMI base URL to access the DSMI Backend HTTP handler.')
		stringParam('SHORTTIMEOUT',SHORTTIMEOUT,'Optional Configures the timeout in seconds for image processing requests in the backend.')
		stringParam('CROSSDOMAINURI',CROSSDOMAINURI,'Locks down cross domain access to specific domains')
		stringParam('IISAPPNAME',IISAPPNAME,'Optional Virtual directory name of the DSMI web application')
		stringParam('SERVICE_EXE_NAME',SERVICE_EXE_NAME,'Optional Name of the DSMI Backend service application')

		choiceParam('LOG_LEVEL', ['Information', 'Critical', 'Error', 'Resume', 'Start', 'Stop', 'Suspend', 'Transfer', 'Verbose', 'Warning'],'<h3><font color="red">Only Valid &gt; Ver7.1.0.40</font></h3> <p>LOG_LEVEL install param to configure loglevel (default=Information)</p> <table cellspacing="1" summary="TraceEventType"><tbody><tr><th>TraceEventType</th><th>Description</th></tr><tr><td>Critical</td><td>Critical Error or Application Crash</td></tr><tr><td>Error</td><td>Recoverable Error</td></tr><tr><td>Information</td><td>Information message</td></tr><tr><td>Resume</td><td>Resume processing</td></tr><tr><td>Start</td><td>Start processing</td></tr><tr><td>Stop</td><td>Stop processing</td></tr><tr><td>Suspend</td><td>Suspend processing</td></tr><tr><td>Transfer</td><td>Change relative ID</td></tr><tr><td>Verbose</td><td>Debug tracing</td></tr><tr><td>Warning</td><td>Not important issues</td></tr></tbody> </table>')
		choiceParam('ENABLEWF', ['1','0'],'<h3><font color="red">Only Valid > Ver7.2.0.52</font></h3> <p>ENABLEWF=1|0 enables the Workflow(1) or disables it (0), default is ENABLEWF=1</p>')
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
    steps {
        dsl {
            external('JobDSL_DSMI_Deployment.groovy')
		}
        batchFile('bat_Deployment/DSMI_Deployment.bat')
    }
}