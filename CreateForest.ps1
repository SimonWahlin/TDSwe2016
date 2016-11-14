Configuration Main
{

	Param ( [string] $DomainName, [PSCredential] $DomainCreds )

	Import-DscResource -ModuleName PSDesiredStateConfiguration, xActiveDirectory, xStorage

	Node localhost
	{
		LocalConfigurationManager 
        {
            ConfigurationMode = 'ApplyOnly'
            RebootNodeIfNeeded = $true
        }

		xDisk InitDataDisk
		{
			DriveLetter = 'F:'
			DiskNumber = 2
			FSFormat = 'NTFS'
		}

		xWaitforDisk WaitForDataDisk
        {
            DiskNumber = 2
            RetryIntervalSec = 10
            RetryCount = 60
        }

		WindowsFeature ADDS
        { 
            Ensure = "Present" 
            Name = "AD-Domain-Services"		
			DependsOn = "[xWaitforDisk]WaitForDataDisk"
        }
		xADDomain FirstDS 
        {
            DomainName = $DomainName
            DomainAdministratorCredential = $DomainCreds
            SafemodeAdministratorPassword = $DomainCreds
            DatabasePath = "F:\NTDS"
            LogPath = "F:\NTDS"
            SysvolPath = "F:\SYSVOL"
	        DependsOn = "[WindowsFeature]ADDS"
        }
	}
}