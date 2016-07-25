//ALL Upper case indicates Environmental Variable comes from Jenkins as Parameter input

if (binding.variables.containsKey('DEBUG_RUN')) {
	//Inherite value from env var comes Jenkins
} else {
    DEBUG_RUN = 'true'
	DSMG_INSTALLDIR = 'C:\\Program Files (x86)\\DirectSmile Generator'
	DSMG_INSTALLER_FILE_PATH = ''
}
job('DSMG_Deployment__' + CUSTOMER_NAME) {
	parameters {
        booleanParam('DEBUG_RUN', false, '<p>If DEBUG_RUN=True all commands will be echoed to the screeb only. Target system will not be touched.</p>')
		stringParam('CUSTOMER_NAME', CUSTOMER_NAME,'<h3>Customer Name</h3><p>this value become as post-fix for generated deploy jobs</p>')
		stringParam('FQDN', FQDN ,'<h3>Fully Qualified Domain Name</h3><p>Customer server FQDN which listedn by DSMInstallation Service</p>')
		stringParam('DSMG_INSTALLDIR', DSMG_INSTALLDIR, '<p>Installation target directory for DirectSmile Generator</p>')
        choiceParam('DEPLOY_VERSION', ['DSMG_LATEST_RELEASE','DSMG_DSF_RELEASE','DSMG_SPECIFIC_VERSION'], 'Select version you want to deploy')
		stringParam('DSMG_INSTALLER_FILE_PATH', DSMG_INSTALLER_FILE_PATH, '<h3>Abosolute File Path or URL</h3><p>You can use local directory path as value in here, as well as UNC path is supported</p><ul> <li>Example input: (URL) <a href="http://directsmile.blob.core.windows.net/installer/dsmg.msi">http://directsmile.blob.core.windows.net/installer/dsmg.msi<br /></a></li> <li>Example input: (UNC)&nbsp; <a href="\\\\NetworkAccessStorage\\DirectSmile\\Installer\\dsmg.msi">\\\\NetworkAccessStorage\\DirectSmile\\Installer\\dsmg.msi</a></li> </ul>')		
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