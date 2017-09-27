<#
.SYNOPSIS  
    Run DSMInstallationService Client 
.DESCRIPTION  
    Run DSMInstallationService Client to check deployed DSM Product Version
.NOTES  
    File Name  : ps_DSMISVersion.ps1
    Author: Nobuaki Ogawa  - Nobuaki.Ogawa@efi.com
.LINK  
     http://devops-az01.directsmile.com
.PARAMETER resImg
   Result Image file(after composit master and test image)
#>

param (
	[string]$DSMIS_DIR="C:\Program Files (x86)\DirectSmile\DirectSmile Installation Service\Client"
)

<# Jenkins ENV Variable support #>
if ($env:WORKSPACE) { $WorkSP=$env:WORKSPACE }
if ($env:FQDN) { $FQDN=$env:FQDN }

<# Step 1: Change directory#>
cd "$DSMIS_DIR"

<# Check Product Version for ALL products#>
$VERSION_CHECK_DSMG = .\DSMInstallationClient.exe version /endpoint:"https://$FQDN/DSMInstallationService.svc" /productCode:DSMG 2>&1
$RESULT_DSMG = $VERSION_CHECK_DSMG.ToString() -split " "
$RESULTCode_DSMG = $RESULT_DSMG[1]

$VERSION_CHECK_DSMI = .\DSMInstallationClient.exe version /endpoint:"https://$FQDN/DSMInstallationService.svc" /productCode:DSMI 2>&1
$RESULT_DSMI = $VERSION_CHECK_DSMI.ToString() -split " "
$RESULTCode_DSMI = $RESULT_DSMI[1]

$VERSION_CHECK_DSMX = .\DSMInstallationClient.exe version /endpoint:"https://$FQDN/DSMInstallationService.svc" /productCode:DSMX 2>&1
$RESULT_DSMX = $VERSION_CHECK_DSMX.ToString() -split " "
$RESULTCode_DSMX = $RESULT_DSMX[1]

$VERSION_CHECK_DSMSTORE = .\DSMInstallationClient.exe version /endpoint:"https://$FQDN/DSMInstallationService.svc" /productCode:DSMSTORE 2>&1
$RESULT_DSMSTORE = $VERSION_CHECK_DSMSTORE.ToString() -split " "
$RESULTCode_DSMSTORE = $RESULT_DSMSTORE[1]

ECHO $RESULTCode_DSMG
ECHO $RESULTCode_DSMI
ECHO $RESULTCode_DSMX
ECHO $RESULTCode_DSMSTORE

"`n" + "DSMG_VERSION=$RESULTCode_DSMG" + "`n" + "DSMI_VERSION=$RESULTCode_DSMI" + "`n" + "DSMX_VERSION=$RESULTCode_DSMX" + "`n" + "DSMSTORE_VERSION=$RESULTCode_DSMSTORE" | Out-File "$WorkSP\Version.txt" -encoding UTF8
