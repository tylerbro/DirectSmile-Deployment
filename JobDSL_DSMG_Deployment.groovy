//ALL Upper case indicates Environmental Variable comes from Jenkins as Parameter input
//If you'd like to use this JobDSL for initial seed creation, comment in below line with your input
//def CUSTOMER_NAME = ''
job('DSMG_Deployment__' + CUSTOMER_NAME) {
    parameters {
        booleanParam('DEBUG_MODE', false, '<h3>Uncheck - Check run script in console log, Check - Execute on the target</h3>')
		stringParam('CUSTOMER_NAME', CUSTOMER_NAME,'<h2>Name of customer</h2>')
		stringParam('FQDN', FQDN ,'<h3>Fully Qualified Domain Name of the DSMI/DSMX/VDP server</h3>')
		stringParam('DSMG_INSTALLDIR', 'C:\\Program Files (x86)\\DirectSmile Generator', '<h3>Installation target directory for DSMOnline Backend</h3>')
        choiceParam('DEPLOY_VERSION', ['LATEST_RELEASE','SPECIFIC_VERSION'], '<h3>Select version you want to deploy</h3>')
		stringParam('DSMG_SPECIFIC_VERSION_FILE_PATH', DSMG_SPECIFIC_VERSION_FILE_PATH, '<h3>!This value only active when you select <Font color=red>DSMG_SPECIFIC_VERSION</Font> as Deploy_Version</h3></br><p>File URL or Local/UNC file path</p>')	
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