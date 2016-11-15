

# TASK: Create a Windows Server 2016 VM, a future member server
# TIP: Store all your results in the variables

# Authenticate to your Azure subscription

# A VM should be a part of the AzureLab-RG resource group
# Resource group should be in the closest region

# Storage account for its VHD file should be a locally redundant storage
# HINT: Don't create a blob storage 

# Networking:
  #  subnet: Subnet-1    and address prefix: 10.0.0.0/24
  #  vNet:   AzureLabNet and address prefix: 10.0.0.0/16

# To enable communication with the VM in the virtual network, you need a public IP address and a network interface (NIC).
# An allocation method for a public IP address should be "Dynamic"
# To create a NIC you will need a subnet ID and a public IP address ID.
# HINT: Get-Member command is your friend. It will help you to find out needed properties of the VNet and the public IP address.

# Finally, you will create a VM configuration object (New-AzureRmVMConfig) before you pass it to the New-AzureRmVM cmdlet

<# You will need to:
    Create an admin credentials
    Pick a VM size (let's make a standard D1 v2 machine)
    Set operating system to "Windows", provision a VM agent, and enable auto update

    You will use the image from the Azure Gallery, so you need to set a source image.
    To do that find the suitable publisher, offer, and SKU for "Windows Server 2016".
    Specify the most recently patched version.
    
    Add a network interface (NIC) to the configuration of your VM using NIC's ID.
    
    Create an URI for your OS disk (VHD file). In other words, define the name (for example, OSDisk.vhd) and location of the VM hard disk. 
        The virtual hard disk file is stored in a container. Put it in a "vhds" container.
        Using Get-Member find a primary endpoint (URI) of your storage account for a blob.

    Set the OS disk using an URI to VHD file. Don't forget that you are creating a VM from a Gallery image.
#>


# Create a new VM using a VM configuration object. Put it in the same resource group and location as other resources. 