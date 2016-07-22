//ALL Upper case indicates Environmental Variable comes from Jenkins as Parameter input

if (binding.variables.containsKey('DEBUG_RUN')) {
	//Inherite value from env var comes Jenkins
} else {
    DEBUG_RUN = 'true'
	DSMG_INSTALLDIR = 'C:\Program Files (x86)\DirectSmile Generator'
	DSMG_VERSION_NUMBER = '6.0.0.44'
	LOCAL_WEB_DIR = ''
}
job('DSMG_Deployment__' + CUSTOMER_NAME) {
	parameters {
        booleanParam('DEBUG_RUN', false, '<p>If DEBUG_RUN=True all commands will be echoed to the screeb only. Target system will not be touched.</p>')
		stringParam('CUSTOMER_NAME', CUSTOMER_NAME,'<h3>Customer Name</h3><p>this value become as post-fix for generated deploy jobs</p>')
		stringParam('FQDN', FQDN ,'<h3>Fully Qualified Domain Name</h3><p>Customer server FQDN which listedn by DSMInstallation Service</p>')
		stringParam('DSMG_INSTALLDIR', DSMG_INSTALLDIR, '<p>Installation target directory for DirectSmile Generator</p>')
        choiceParam('DEPLOY_VERSION', ['DSMG_LATEST_RELEASE','DSMG_DSF_RELEASE','DSMG_SPECIFIC_VERSION'], 'Select version you want to deploy')
		stringParam('DSMG_VERSION_NUMBER', DSMG_VERSION_NUMBER, '<p>This field is only relevant when you select "<strong>DSMG_SPECIFIC_VERSION</strong>" in above selection menu.</p> <p>&nbsp;</p> <p>The file name should have<span style="background-color: #ffff00;"> "</span><strong><span style="background-color: #ffff00;">DSMGenInstaller-</span></strong><span style="background-color: #ffff00;">"</span> as its prefix. You only need to input version number</p> <ul> <li>Example input: <strong>6.0.0.44</strong></li> </ul> <p>While we create download link, we add "DSMGenInstaller-" + "%DSMG_VERSION_NUMBER%" + ".msi" automatically.</p> <p>&nbsp;</p> <p>In case you set value in <strong>LOCAL_WEB_DIR</strong>, then this value should be exactly file name of .msi you gonna execute.</p> <ul> <li>Example input: <strong>DSMGenInstaller-6.0.0.44</strong></li> </ul>')
		stringParam('LOCAL_WEB_DIR', LOCAL_WEB_DIR, '<p>You can use local directory path as value in here.as well as UNC path is supported</p> <p>Please ensure that you provide "<strong>/</strong>"(slash) for URL case in the end, "<strong>\\</strong>"(back slash) in case of UNC path.</p> <ul> <li>Example input: (URL) <a href="http://myserver/DirectSmile/Installer/">http://myserver/DirectSmile/Installer/<br /></a></li> <li>Example input: (UNC)&nbsp; <a href="\\\\NetworkAccessStorage\\DirectSmile\\Installer\\">\\\\NetworkAccessStorage\\DirectSmile\\Installer\\</a></li> </ul>')		
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