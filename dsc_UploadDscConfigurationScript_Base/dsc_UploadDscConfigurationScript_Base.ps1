<#
.SYNOPSIS  
    Uploads a PS DSC Configuration script into Azure storage.
.DESCRIPTION  
     Uploads a PS DSC Configuration script into Azure storage. As part of the PowerShell DSC tools.
.NOTES  
    File Name  : dsc_UploadDscConfigurationScript_Base.ps1  
.EXAMPLE  
    .\dsc_UploadDscConfigurationScript_Base.ps1 -ConfigurationPath c:\temp\IISInstall.ps1
    This example publish DSC script optimized to be apply Azure VM on selected Storage account.
.PARAMETER StorageAccount  
   Azure Storage Account name.
.PARAMETER StorageKey  
   Azure Storage Access Key.
.PARAMETER StorageContainer  
   Azure Storage Container name.
.PARAMETER ConfigurationPath  
   Path to the local PS DSC script file.
#>

param (
    [string]$StorageAccount="",
    [string]$StorageKey="",
    [string]$StorageContainer="",
    [string]$ConfigurationPath=""
)

<# Jenkins ENV Variable support #>
if ($env:AZURE_STORAGE_ACCOUNT_NAME) { $StorageAccount=$env:AZURE_STORAGE_ACCOUNT_NAME }
if ($env:AZURE_STORAGE_KEY) { $StorageKey=$env:AZURE_STORAGE_KEY }
if ($env:AZURE_STORAGE_CONTAINER_NAME) { $StorageContainer=$env:AZURE_STORAGE_CONTAINER_NAME }
if ($env:AZURE_DSC_CONFIG_PATH) { $ConfigurationPath=$env:AZURE_DSC_CONFIG_PATH }

$StorageContext = New-AzureStorageContext -StorageAccountName $StorageAccount -StorageAccountKey $StorageKey
Publish-AzureVMDscConfiguration -ConfigurationPath $ConfigurationPath -ContainerName $StorageContainer -StorageContext $StorageContext -Force