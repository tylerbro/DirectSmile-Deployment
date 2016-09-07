//ALL Upper case indicates Environmental Variable comes from Jenkins as Parameter input

if (binding.variables.containsKey('DEBUG_RUN')) {
	//Inherite value from env var comes Jenkins
} else {
    DEBUG_RUN = 'true'
	DSMG_INSTALLDIR = 'C:\\Program Files (x86)\\DirectSmile Generator'
	DSMG_INSTALLER_FILE_PATH = ''
	LOGLEVEL = 'Warning'
	LOGPATH = 'C:\\Program Files (x86)\\DirectSmile\\DirectSmile Logs'
}
job('DSMG_Deployment__' + CUSTOMER_NAME) {
	parameters {
        booleanParam('DEBUG_RUN', false, '<p>If DEBUG_RUN=True all commands will be echoed to the screeb only. Target system will not be touched.</p>')
		stringParam('CUSTOMER_NAME', CUSTOMER_NAME,'<h3>Customer Name</h3><p>this value become as post-fix for generated deploy jobs</p>')
		stringParam('FQDN', FQDN ,'<h3>Fully Qualified Domain Name</h3><p>Customer server FQDN which listedn by DSMInstallation Service</p>')
		stringParam('DSMG_INSTALLDIR', DSMG_INSTALLDIR, '<p>Installation target directory for DirectSmile Generator</p>')
        choiceParam('DEPLOY_VERSION', ['DSMG_LATEST_RELEASE','DSMG_DSF_RELEASE','DSMG_SPECIFIC_VERSION'], 'Select version you want to deploy')
		stringParam('DSMG_INSTALLER_FILE_PATH', DSMG_INSTALLER_FILE_PATH, '<h3>Abosolute File Path or URL</h3><p>You can use local directory path as value in here, as well as UNC path is supported</p><ul> <li>Example input: (URL) <a href="http://directsmile.blob.core.windows.net/installer/dsmg.msi">http://directsmile.blob.core.windows.net/installer/dsmg.msi<br /></a></li> <li>Example input: (UNC)&nbsp; <a href="\\\\NetworkAccessStorage\\DirectSmile\\Installer\\dsmg.msi">\\\\NetworkAccessStorage\\DirectSmile\\Installer\\dsmg.msi</a></li> </ul>')
		
		choiceParam('LOGLEVEL', ['Warning', 'Information', 'Critical', 'Error', 'Resume', 'Start', 'Stop', 'Suspend', 'Transfer', 'Verbose'],'<h3><font color="red">Only Valid &gt; Ver6.0.0.48</font></h3> <p>LOGLEVEL install param to configure loglevel (default=Warning)</p> <table cellspacing="1" summary="TraceEventType"><tbody><tr><th>TraceEventType</th><th>Description</th></tr><tr><td>Critical</td><td>Critical Error or Application Crash</td></tr><tr><td>Error</td><td>Recoverable Error</td></tr><tr><td>Information</td><td>Information message</td></tr><tr><td>Resume</td><td>Resume processing</td></tr><tr><td>Start</td><td>Start processing</td></tr><tr><td>Stop</td><td>Stop processing</td></tr><tr><td>Suspend</td><td>Suspend processing</td></tr><tr><td>Transfer</td><td>Change relative ID</td></tr><tr><td>Verbose</td><td>Debug tracing</td></tr><tr><td>Warning</td><td>Not important issues</td></tr></tbody> </table>')
		stringParam('LOGPATH',LOGPATH,'<h3><font color="red">Only Valid &gt; Ver6.0.0.48</font></h3></br><p>LOGPATH="C:\\Program Files (x86)\\DirectSmile\\DirectSmile Logs"</p></br></br><p>if NOT empty, the installer write input in DirectSmile Generator.exe.config</p></br>')
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
            external('JobDSL_DSMG_Deployment.groovy')
		}
        batchFile('bat_Deployment/DSMG_Deployment.bat')
    }
}