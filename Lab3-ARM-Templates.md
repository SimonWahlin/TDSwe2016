# ARM Templates Lab

## Create ARM resources
1. Start Visual Studio 2015
2. Choose File->New->Project…
3. In the search box in the upper right corner, type "Azure Resource Group" and choose the one for Visual C#
4. Use the following information:
    Name : AzureADLabTemplate
    Location: Use the suggested location
    SolutionName: AzureADLabTemplate
    Click OK
5. Select Blank Template and click OK.
6. In Solution Explorer, open azuredeploy.json
7. In the JSON outline, add the following resources:
    **Windows Virtual Machine**
    Name: DC01

    **Storage account: Choose <Create new…>**
    Name: adlabstorage

    **Virtual Network: <Create new…>**
    Name: AdLabNet
8. Note that Visual Studio not only created the three resources selected but also added a network interface, a few parameters and a bunch of variables for us.
9. Now add a Public IP Address resource using the following information:
    Name: DC01PublicIP
    Attached To: DC01Nic
10. Add the following parameters:
    Name: AdminUserName
    Type: string

    Name: AdminPassword
    Type: securestring

    Name: domainName
    Type: string
    DefaultValue: lab.prv
11. Read through the variables that were automatically created and get familiar with them.
12. Move DC01WindowOSVersion from parameters into the variables section and set it to the hardcoded value of "2016-Datacenter"
13. Also move the following values into variables section:
    Adlabstoragetype: Standard_LRS
    DC01Name: DC01
14. Remove the parameters DC01AdminUserName, DC01AdminPassword and DC01PublicIPDnsName.
15. Add a variable called DC01DATADiskName and give it the value DC01DATADisk
16. Add a variable called DC01PrivateIPAddress and give it the value of 10.0.0.10
17. Update the DC01NicName value to use the variable DC01Name followed by -NIC
18. Update all references in the resources region to reflect your changes. Look for text underlined with red to locate where changes are needed.For the public ipaddress, remove the whole DnsSettings property.
19. Add a data-disk to the virtual machine using the variable DC01DataDiskname as name. Use IntelliSense and/or quick-start-templates to figure out the correct syntax.Use the following configuration:
    Name: Get this from the DC01DataDiskname variable
    CreateOption: Empty
    Uri: See OSDisk for inspiration
    Caching: None
    DiskSize: 10GB
    Lun: 0
20. Configure DC01Nic with the static IPAddress defined in variable DC01PrivateIPAddress
21. In the properties for the AdLabNet VNET, add a property called dhcpOptions and within it configure the list of dnsServers to contain the IP in variable DC01PrivateIPAddress as well as "8.8.8.8".
22. In Solution Explorer, right click your project and choose Deploy -> New…
23. Log in with the LiveID associated with your AzurePass, fill in all the fields, check "Validate Only" and click OK
24. Leave the parameters as-is and enter a password when requested.
25. The deployment will fail, probably telling you that the storage account name is invalid. Update the storage account name variable to only use "adlabstor" instead of "adlabstorage".
26. Run the validation again. This time using the same deployment as last time but don't forget to check the validate only checkbox.
27. Fix any new errors that were found.
28. Once the template validates, go ahead and deploy it to Azure.

## Adding Desired State Configuration
1. In the JSON outline for your template, right-click your VM and select Add new resource
2. Select PowerShell DSC Extension and name it CreateForest
3. Open the newly created CreateForest.ps1 script and replace the content with file found here: https://github.com/SimonWahlin/TDSwe2016/blob/master/CreateForest.ps1
4. In azuredeploy.json, locate the CreateForest resource and in the configurationArguments section, add a string for DomainName containing the value of the parameter DomainName
5. In the ProtectedSettings section, add a complex object called configurationArguments.
6. Inside the newly created configurationArguments, create an object called DomainCreds containing two strings, userName and password containing the value of the parameters AdminUserName and AdminPassword.
7. Download the modules xActiveDirectory and xStorage, put them into your project folder and include them into the project.
    a. In solution explorer, rightclick AzureADLabTemplate and click Open folder in File Explorer.
    b. Copy the path to your project folder and download the modules using PowerShellGet
    *Save-Module -Name xActiveDirectory, xStorage -Path $ProjectPath*
    c. Back in Solution Explorer in Visual Studio, click the little button called "Show all files", right-click the module directories and click "Include in Project"
8. Make sure all files are saved and deploy your template to the same resourcegroup as before. Leave the parameters as is and enter a password when prompted. Be patient, it might take some time. If the authentication token expires, check deployment status in the portal.

## Extra assignments
If you have time left or want to keep on experimenting after the pre-conference, here are some suggestions that could expand the use of your template.

1. Add a second VM called SRV1 to the template.
2. Add a new DSC extension, this time using the JsonADDomainExtension. For inspiration look at these quickstart templates:[https://github.com/Azure/azure-quickstart-templates/tree/master/201-vm-domain-joinhttps://github.com/Azure/azure-quickstart-templates/tree/master/201-vm-domain-join-existing](https://github.com/Azure/azure-quickstart-templates/tree/master/201-vm-domain-joinhttps://github.com/Azure/azure-quickstart-templates/tree/master/201-vm-domain-join-existing)
3. Add a parameter for MemberServerCount and create as many member-servers as specified by the parameter, join them all to the domain.
