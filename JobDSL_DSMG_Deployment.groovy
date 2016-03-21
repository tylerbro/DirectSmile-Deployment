//ALL Upper case indicates Environmental Variable comes from Jenkins as Parameter input
job('DSMG_Deployment' + CUSTOMER_NAME) {
    parameters {
        booleanParam('DSMG_Deploy', false, 'Uncheck - Check run script in console log, Check - Execute on the target')
		stringParam('FQDN', FQDN,'Fully Qualified Domain Name of the DSMI website')
		stringParam('DSMG_INSTALLDIR', 'C:\\Program Files (x86)\\DirectSmile Generator', 'Installation target directory for DSMOnline Backend')
        choiceParam('Deploy_Version', ['DSMG_LATEST_RELEASE(default)', 		'DSMG_LATEST_STABLE_RELEASE', 'DSMG_DSF_RELEASE', 'DSMG_VER5_1_x', 'DSMG_VER5_4_x', 'DSMG_VER6_0_x', 'DSMG_TRUNK_VERSION', 'DSMG_SPECIFIC_VERSION'], 'Select version you want to deploy')
		stringParam('DSMG_VERSION_NUMBER', '5.1.0.367', 'You need to specify version number at here. File name should have "DSMGenInstaller-" as prefix, and ".msi" as postfix. So you only need to provide exact version number at here')	
    }
}