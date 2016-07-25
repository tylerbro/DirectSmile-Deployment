# DirectSmile-Deployment
JobDSL base DirectSmile Deployment job for Jenkins/DSMInstallation Service

You can do:
  - Create DSMG deploy job on Jenkins
  - Create DSMI deploy job on Jenkins
  - Create DSMX deploy job on Jenkins



### Version
1.0.0.1

### Requirement

To use this job properly, you need to have below

* [Jenkins] - OSS Continuous Integration Tool
    * [Git plugin] - 
    * [Credential Plugin] - 
    * [Credential Binding Plugin] -
    * [JobDSL Plugin] -
    * [Parameterized Build] -

* [DSM Installation Service] - DirectSmile Installation Service to make automatic deployment

### Set Up

First, you need to install Jenkins on your Windows machine

Second, install all required plugins

Third, install DSM Installation Service on same machine or windows slave Jenkins node

```cmd
msiexec -i DSMInstallationService.msi
```

Last, please ensure that you hvae installed proper certificate file that you can communicate with target DSMInstallation Service running machines.

### Create Seed Job

As this is customized to use JobDSL for each product specific deploy job generation, you need to create Seed job at first.

* Create new freestyle job
* Add 2 new parameteres
    ### CUSTOMER_NAME
    Example description
    ```html
    <h3>Customer Name</h3>
    <p>this value become as POST-fix for generated deploy jobs</p></br>
    <p>example : JobDSL_DSMG_Deploy__<font color="red">efiDSMDevOps</font></p>
    ```

    ### FQDN
    Example description
    ```html
    <h3>Fully Qualified Domain Name</h3>
    <p>Customer server's FQDN which listedn by DSMInstallation Service</p>
    ```
* Check out this GitHub project
    ```cmd
    Repository URL: https://github.com/Nobukins/DirectSmile-Deployment
    Credential: none
    Braches to build: */master
    ```
* Set dsl as below
    ```cmd
    JobDSL_DSMG_Deployment.groovy
    JobDSL_DSMI_Deployment.groovy
    JobDSL_DSMX_Deployment.groovy
    ```
